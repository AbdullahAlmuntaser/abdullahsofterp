import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/audit_log_service.dart';

class ApprovalWorkflowService {
  final AppDatabase db;
  final AuditLogService? auditLogService;

  ApprovalWorkflowService(this.db, {this.auditLogService});

  static const double defaultPurchaseApprovalThreshold = 10000;

  /// Check if a transaction requires approval based on amount threshold
  Future<bool> requiresApproval({
    required String type,
    required double amount,
    double? threshold,
  }) async {
    return amount >= (threshold ?? defaultPurchaseApprovalThreshold);
  }

  /// Create a new approval request (persisted in DB)
  Future<Map<String, dynamic>> createRequest({
    required String type,
    required String title,
    required double amount,
    required String requestedBy,
    String? referenceId,
    String? note,
  }) async {
    final now = DateTime.now().toIso8601String();
    final id = await db.customInsert(
      'INSERT INTO approval_requests (document_type, document_id, requested_by, status, requested_at) '
      'VALUES (?, ?, ?, ?, ?)',
      variables: [
        Variable(type),
        Variable(referenceId ?? ''),
        Variable(int.tryParse(requestedBy) ?? 0),
        const Variable('pending'),
        Variable(now),
      ],
    );

    final idStr = id.toString();
    if (auditLogService != null) {
      await auditLogService!.logAction(
        userId: requestedBy,
        action: 'APPROVAL_REQUEST_CREATE',
        logTableName: 'approval_requests',
        recordId: idStr,
        newValues: {'type': type, 'amount': amount},
      );
    }

    return {
      'id': idStr,
      'type': type,
      'title': title,
      'amount': amount,
      'requestedBy': requestedBy,
      'status': 'pending',
      'referenceId': referenceId,
      'note': note,
      'requestedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Get pending approval request for a reference
  Future<Map<String, dynamic>?> getPendingRequestForReference(
      String referenceId) async {
    final rows = (await db.customSelect(
      'SELECT * FROM approval_requests WHERE document_id = ? AND status = ?',
      variables: [Variable(referenceId), const Variable('pending')],
    ).get());
    return rows.isNotEmpty ? rows.first.data : null;
  }

  /// List all approval requests, optionally filtered by status
  Future<List<Map<String, dynamic>>> listRequests({String? status}) async {
    String sql = 'SELECT * FROM approval_requests';
    final vars = <Variable>[];
    if (status != null) {
      sql += ' WHERE status = ?';
      vars.add(Variable(status));
    }
    sql += ' ORDER BY requested_at DESC';
    return (await db.customSelect(sql, variables: vars).get())
        .map((e) => e.data)
        .toList();
  }

  /// Get count of pending approvals
  Future<int> getPendingCount() async {
    final rows = await db.customSelect(
      'SELECT COUNT(*) AS cnt FROM approval_requests WHERE status = ?',
      variables: [const Variable('pending')],
    ).get();
    return rows.first.data['cnt'] as int;
  }

  /// Approve an approval request
  Future<void> approve({
    required int requestId,
    required int decidedBy,
    String? decisionNote,
  }) async {
    await _decide(
      requestId: requestId,
      status: 'approved',
      decidedBy: decidedBy,
      decisionNote: decisionNote,
    );
  }

  /// Reject an approval request
  Future<void> reject({
    required int requestId,
    required int decidedBy,
    String? decisionNote,
  }) async {
    await _decide(
      requestId: requestId,
      status: 'rejected',
      decidedBy: decidedBy,
      decisionNote: decisionNote,
    );
  }

  Future<void> _decide({
    required int requestId,
    required String status,
    required int decidedBy,
    String? decisionNote,
  }) async {
    final existing = await db.customSelect(
      'SELECT * FROM approval_requests WHERE id = ?',
      variables: [Variable(requestId)],
    ).get();

    if (existing.isEmpty) {
      throw Exception('Approval request not found');
    }

    final request = existing.first.data;
    if (request['status'] != 'pending') {
      throw Exception('Approval request already decided');
    }

    await db.customUpdate(
      "UPDATE approval_requests SET status = ?, completed_at = ? WHERE id = ?",
      variables: [
        Variable(status),
        Variable(DateTime.now().toIso8601String()),
        Variable(requestId),
      ],
    );

    await db.customInsert(
      'INSERT INTO approval_history (request_id, level_order, approver_id, action, comments, action_date) VALUES (?, ?, ?, ?, ?, ?)',
      variables: [
        Variable(requestId),
        Variable(request['current_level'] ?? 1),
        Variable(decidedBy),
        Variable(status),
        Variable(decisionNote),
        Variable(DateTime.now().toIso8601String()),
      ],
    );

    if (auditLogService != null) {
      await auditLogService!.logAction(
        userId: decidedBy.toString(),
        action: 'APPROVAL_REQUEST_${status.toUpperCase()}',
        logTableName: 'approval_requests',
        recordId: requestId.toString(),
        oldValues: {'status': 'pending'},
        newValues: {'status': status, 'decisionNote': decisionNote},
      );
    }
  }

  Future<void> approveRequest({
    required int requestId,
    required int decidedBy,
    String? decisionNote,
  }) async {
    await approve(
      requestId: requestId,
      decidedBy: decidedBy,
      decisionNote: decisionNote,
    );
  }

  Future<void> rejectRequest({
    required int requestId,
    required int decidedBy,
    String? decisionNote,
  }) async {
    await reject(
      requestId: requestId,
      decidedBy: decidedBy,
      decisionNote: decisionNote,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    return listRequests(status: 'pending');
  }

  Future<Map<String, dynamic>?> getRequestById(int requestId) async {
    final rows = await db.customSelect(
      'SELECT * FROM approval_requests WHERE id = ?',
      variables: [Variable(requestId)],
    ).get();
    return rows.isNotEmpty ? rows.first.data : null;
  }

  Future<Map<String, dynamic>?> getRequestByReferenceId(
      String referenceId) async {
    final rows = await db.customSelect(
      'SELECT * FROM approval_requests WHERE document_id = ?',
      variables: [Variable(referenceId)],
    ).get();
    return rows.isNotEmpty ? rows.first.data : null;
  }

  /// 2.8: Verify that a user is authorized to approve based on role
  Future<bool> canApprove(int userId, String documentType) async {
    final user = await (db.select(db.users)
          ..where((u) => u.id.equals(userId.toString())))
        .getSingleOrNull();
    if (user == null) return false;
    if (user.role.toLowerCase() == 'admin') return true;
    return user.role.contains('manager') || user.role.contains('supervisor');
  }

  /// 2.9: Auto-confirm a transaction after full approval
  Future<void> onApproved(int requestId,
      {Future<void> Function()? onConfirm}) async {
    final request = await getRequestById(requestId);
    if (request == null || request['status'] != 'approved') return;
    if (onConfirm != null) {
      await onConfirm();
    }
  }
}
