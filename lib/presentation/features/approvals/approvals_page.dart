import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/core/auth/auth_provider.dart';
import 'package:supermarket/core/services/approval_workflow_service.dart';
import 'package:supermarket/l10n/app_localizations.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _requests = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  ApprovalWorkflowService get _service =>
      context.read<ApprovalWorkflowService>();

  Future<void> _loadRequests() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      final requests = await _service.listRequests();
      if (mounted) {
        setState(() => _requests = requests);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingApprovalRequests(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createDemoRequest() async {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();
    await _service.createRequest(
      type: 'purchase',
      title: l10n.largePurchaseRequest,
      amount: ApprovalWorkflowService.defaultPurchaseApprovalThreshold,
      requestedBy: auth.currentUser?.username ?? 'system',
      note: l10n.demoRequestNote,
    );
    await _loadRequests();
  }

  Future<void> _decide(Map<String, dynamic> request, bool approved) async {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.read<AuthProvider>();
    final requestId = request['id'] is int ? request['id'] as int : int.parse(request['id'].toString());
    final decidedBy = int.tryParse(auth.currentUser?.id ?? '') ?? 0;
    try {
      if (approved) {
        await _service.approve(requestId: requestId, decidedBy: decidedBy);
      } else {
        await _service.reject(requestId: requestId, decidedBy: decidedBy);
      }
      await _loadRequests();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(approved ? l10n.requestApproved : l10n.requestRejected)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToUpdateRequest(e.toString()))),
        );
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'approved':
        return l10n.approved;
      case 'rejected':
        return l10n.rejected;
      default:
        return l10n.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.approvalWorkflow),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: _isLoading ? null : _loadRequests,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createDemoRequest,
        icon: const Icon(Icons.add_task),
        label: Text(l10n.demoRequest),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRequests,
              child: _requests.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 160),
                        Center(child: Text(l10n.noApprovalRequests)),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        final request = _requests[index];
                        final status = request['status'] as String? ?? 'pending';
                        final title = request['title'] as String? ?? '';
                        final type = request['type'] as String? ?? '';
                        final amount = request['amount'] is num ? (request['amount'] as num).toDouble() : 0.0;
                        final requestedBy = request['requestedBy'] as String? ?? '';
                        final createdAtStr = request['createdAt'] as String? ?? request['requestedAt'] as String? ?? '';
                        final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();
                        final note = request['note'] as String?;
                        final isPending = status == 'pending';
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _statusColor(status),
                              child:
                                  const Icon(Icons.rule, color: Colors.white),
                            ),
                            title: Text(title),
                            subtitle: Text(
                              '$type • ${NumberFormat.currency(symbol: '').format(amount)}\n'
                              '${l10n.byUser(requestedBy)} • ${DateFormat('yyyy-MM-dd HH:mm').format(createdAt)}\n'
                              '${note ?? ''}',
                            ),
                            isThreeLine: true,
                            trailing: isPending
                                ? Wrap(
                                    spacing: 4,
                                    children: [
                                      IconButton(
                                        tooltip: l10n.approve,
                                        onPressed: () => _decide(request, true),
                                        icon: const Icon(Icons.check_circle),
                                        color: Colors.green,
                                      ),
                                      IconButton(
                                        tooltip: l10n.reject,
                                        onPressed: () =>
                                            _decide(request, false),
                                        icon: const Icon(Icons.cancel),
                                        color: Colors.red,
                                      ),
                                    ],
                                  )
                                : Chip(
                                    label: Text(_statusLabel(status, l10n)),
                                    backgroundColor:
                                        _statusColor(status)
                                            .withOpacity(0.12),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
