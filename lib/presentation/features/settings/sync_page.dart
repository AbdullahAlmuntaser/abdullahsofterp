import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/l10n/app_localizations.dart';
import 'package:supermarket/presentation/features/settings/providers/sync_provider.dart';
import 'package:supermarket/presentation/features/settings/widgets/sync_status_card.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final syncProvider = context.watch<SyncProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cloudSync),
        actions: [
          IconButton(
            icon: syncProvider.isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: syncProvider.isSyncing ? null : () => syncProvider.sync(),
            tooltip: l10n.syncNow,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SyncStatusCard(),
            const SizedBox(height: 20),
            Expanded(
              child: syncProvider.queue.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_done,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'جميع البيانات متزامنة',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: syncProvider.queue.length,
                      itemBuilder: (context, index) {
                        final item = syncProvider.queue[index];
                        return ListTile(
                          leading: _statusIcon(item.statusLabel),
                          title: Text('${item.tableName}: ${item.entityId}'),
                          subtitle: Text(item.operation),
                          trailing: Text(
                            item.createdAt.toString().substring(0, 16),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return const Icon(Icons.hourglass_empty, color: Colors.orange);
      case 'synced':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'failed':
        return const Icon(Icons.error, color: Colors.red);
      default:
        return const Icon(Icons.help_outline);
    }
  }
}
