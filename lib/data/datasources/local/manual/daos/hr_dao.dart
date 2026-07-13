import 'package:decimal/decimal.dart';
import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class HrDao {
  final ManualDatabase _db;
  HrDao(this._db);

  // ==================== EMPLOYEES ====================
  Future<List<Employee>> getAllEmployees({bool activeOnly = true}) async {
    String sql = 'SELECT * FROM employees';
    if (activeOnly) sql += ' WHERE is_active = 1';
    sql += ' ORDER BY name';
    final rows = _db.query(sql);
    return rows.map((r) => Employee.fromMap(r)).toList();
  }

  Future<Employee?> getEmployeeById(String id) async {
    final rows = _db.query('SELECT * FROM employees WHERE id = ?', [id]);
    return rows.isEmpty ? null : Employee.fromMap(rows.first);
  }

  Future<String> insertEmployee({
    required String name, required String employeeCode,
    String? jobTitle, String? role, Decimal? basicSalary,
    DateTime? hireDate, String? warehouseId,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO employees (id, name, employee_code, job_title, role, basic_salary, hire_date, warehouse_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, name, employeeCode, jobTitle, role ?? 'USER',
          basicSalary?.toString() ?? '0',
          hireDate?.toIso8601String(), warehouseId]);
    return id;
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> fields) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    final values = fields.values.map((v) => v?.toString()).toList();
    values.add(id);
    _db.execute('UPDATE employees SET $sets WHERE id = ?', values);
  }

  Future<void> deleteEmployee(String id) async {
    _db.execute('UPDATE employees SET is_active = 0 WHERE id = ?', [id]);
  }

  // ==================== HR EMPLOYEES (extended) ====================
  Future<List<HrEmployee>> getAllHrEmployees({String? department}) async {
    String sql = 'SELECT * FROM hr_employees WHERE status = \'ACTIVE\'';
    final params = <Object?>[];
    if (department != null) { sql += ' AND department = ?'; params.add(department); }
    sql += ' ORDER BY name';
    final rows = _db.query(sql, params);
    return rows.map((r) => HrEmployee.fromMap(r)).toList();
  }

  Future<String> insertHrEmployee(Map<String, dynamic> fields) async {
    final id = const Uuid().v4();
    fields['id'] = id;
    final cols = fields.keys.join(', ');
    final placeholders = fields.keys.map((_) => '?').join(', ');
    _db.execute('INSERT INTO hr_employees ($cols) VALUES ($placeholders)', fields.values.toList());
    return id;
  }

  // ==================== PAYROLL ====================
  Future<List<PayrollEntry>> getAllPayrollEntries() async {
    final rows = _db.query('SELECT * FROM payroll_entries ORDER BY year DESC, month DESC');
    return rows.map((r) => PayrollEntry.fromMap(r)).toList();
  }

  Future<String> createPayrollEntry(int month, int year, {String? note}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO payroll_entries (id, month, year, note) VALUES (?, ?, ?, ?)',
        [id, month, year, note]);
    return id;
  }

  Future<void> addPayrollLine({
    required String payrollEntryId, required String employeeId,
    Decimal? basicSalary, Decimal? allowances,
    Decimal? deductions, Decimal? netSalary,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO payroll_lines (id, payroll_entry_id, employee_id, basic_salary, allowances, deductions, net_salary)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, payrollEntryId, employeeId, basicSalary?.toString(),
          allowances?.toString(), deductions?.toString(), netSalary?.toString()]);
  }

  // ==================== ATTENDANCE ====================
  Future<List<AttendanceRecord>> getAttendance(String employeeId, DateTime start, DateTime end) async {
    final rows = _db.query('''
      SELECT * FROM attendance_records
      WHERE employee_id = ? AND date >= ? AND date <= ?
      ORDER BY date
    ''', [employeeId, start.toIso8601String(), end.toIso8601String()]);
    return rows.map((r) => AttendanceRecord.fromMap(r)).toList();
  }

  Future<String> recordAttendance({
    required String employeeId, required DateTime date,
    String? checkIn, String? checkOut, String? status, String? notes,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO attendance_records (id, employee_id, date, check_in, check_out, status, notes)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, employeeId, date.toIso8601String(), checkIn, checkOut,
          status ?? 'PRESENT', notes]);
    return id;
  }

  // ==================== LEAVE ====================
  Future<List<LeaveType>> getLeaveTypes() async {
    final rows = _db.query('SELECT * FROM leave_types ORDER BY name');
    return rows.map((r) => LeaveType.fromMap(r)).toList();
  }

  Future<String> createLeaveType(String name, int daysAllowed, {bool isPaid = true}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO leave_types (id, name, days_allowed, is_paid) VALUES (?, ?, ?, ?)',
        [id, name, daysAllowed, isPaid ? 1 : 0]);
    return id;
  }

  Future<List<LeaveRequest>> getLeaveRequests(String employeeId) async {
    final rows = _db.query('''
      SELECT * FROM leave_requests WHERE employee_id = ? ORDER BY start_date DESC
    ''', [employeeId]);
    return rows.map((r) => LeaveRequest.fromMap(r)).toList();
  }

  Future<String> submitLeaveRequest({
    required String employeeId, required String leaveTypeId,
    required DateTime start, required DateTime end,
    String? reason,
  }) async {
    final id = const Uuid().v4();
    final days = end.difference(start).inDays + 1;
    _db.execute('''
      INSERT INTO leave_requests (id, employee_id, leave_type_id, start_date, end_date, days_count, reason)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [id, employeeId, leaveTypeId, start.toIso8601String(),
          end.toIso8601String(), days, reason]);
    return id;
  }

  Future<void> approveLeave(String id, String approvedBy) async {
    _db.execute('UPDATE leave_requests SET status = \'APPROVED\', approved_by = ? WHERE id = ?',
        [approvedBy, id]);
  }

  // ==================== ATTENDANCE & LEAVE REPORTS (JOIN) ====================
  Future<List<Map<String, dynamic>>> getEmployeeAttendanceReport(
      String employeeId, int year, int month) async {
    return _db.query('''
      SELECT a.date, a.check_in, a.check_out, a.status, a.notes
      FROM attendance_records a
      WHERE a.employee_id = ?
        AND CAST(strftime('%Y', a.date) AS INTEGER) = ?
        AND CAST(strftime('%m', a.date) AS INTEGER) = ?
      ORDER BY a.date
    ''', [employeeId, year, month]);
  }
}

class HrEmployee {
  final String id; final String name; final String employeeCode;
  final String? nationalId; final String? phone; final String? email;
  final String? jobTitle; final String? department;
  final Decimal basicSalary; final DateTime? hireDate;
  final String contractType; final String status;
  HrEmployee.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], employeeCode = m['employee_code'],
    nationalId = m['national_id'], phone = m['phone'], email = m['email'],
    jobTitle = m['job_title'], department = m['department'],
    basicSalary = _hd(m['basic_salary']),
    hireDate = m['hire_date'] != null ? DateTime.parse(m['hire_date']) : null,
    contractType = m['contract_type'] ?? 'PERMANENT',
    status = m['status'] ?? 'ACTIVE';
}

class LeaveType {
  final String id; final String name; final int daysAllowed; final bool isPaid;
  LeaveType.fromMap(Map<String, dynamic> m) :
    id = m['id'], name = m['name'], daysAllowed = m['days_allowed'] as int? ?? 0,
    isPaid = m['is_paid'] == 1;
}

Decimal _hd(dynamic v) {
  if (v == null) return Decimal.zero;
  if (v is Decimal) return v;
  return Decimal.tryParse(v.toString()) ?? Decimal.zero;
}
