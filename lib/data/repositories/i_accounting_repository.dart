import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/models/accounting/account_tree_node.dart';
import 'package:supermarket/data/datasources/local/daos/accounting_dao.dart';

abstract class IAccountingRepository {
  Future<bool> isDateInClosedPeriod(DateTime date);
  Future<void> closeAccountingPeriod(String periodId, {String? userId});
  Future<List<GLAccount>> getAllAccounts();
  Stream<List<GLAccount>> watchAccounts();
  Future<GLAccount?> getAccountByCode(String code);
  Future<GLAccount?> getAccountById(String id);
  Future<String> createAccount(GLAccountsCompanion account);
  Future<bool> updateAccount(GLAccount account);
  Future<List<GLAccount>> getAccountsByType(String type);
  Future<List<CostCenter>> getAllCostCenters();
  Stream<List<CostCenter>> watchCostCenters();
  Future<String> createCostCenter(CostCentersCompanion cc);
  Future<bool> updateCostCenter(CostCenter cc);
  Future<void> createEntry(GLEntriesCompanion entry, List<GLLinesCompanion> lines);
  Future<Decimal> getAccountBalance(String accountId, {String? branchId});
  Future<Decimal> getAccountBalanceAsOfDate(String accountId, DateTime asOfDate, {String? branchId});
  Future<List<TrialBalanceItem>> getTrialBalance({String? branchId, DateTime? asOfDate});
  Future<BalanceSheet> getBalanceSheet({DateTime? asOfDate, String? branchId});
  Future<IncomeStatement> getIncomeStatement({required DateTime startDate, required DateTime endDate, String? branchId});
  Stream<List<GLEntry>> watchRecentEntries({int limit = 50});
  Future<List<GLLineWithAccount>> getLinesForEntry(String entryId);
  Future<List<GLEntry>> getGLEntriesInDateRange(DateTime startDate, DateTime endDate);
  Future<List<PostingProfile>> getAllPostingProfiles();
  Stream<List<PostingProfile>> watchPostingProfiles();
  Future<bool> updatePostingProfile(PostingProfile profile);
  Future<int> createPostingProfile(PostingProfilesCompanion profile);
  Future<int> deletePostingProfile(String id);
  Future<List<AccountTreeNode>> getAccountTree({DateTime? asOfDate, String? branchId});
  Future<Decimal> getAccountTreeBalance(String accountId, {DateTime? asOfDate, String? branchId});
}
