import 'package:flutter/material.dart';

class ErrorSummaryWidget extends StatelessWidget {
  final List<String> errors;
  final String title;

  const ErrorSummaryWidget({
    super.key,
    required this.errors,
    this.title = 'يرجى تصحيح الأخطاء التالية:',
  });

  ErrorSummaryWidget.single({
    super.key,
    required String error,
    this.title = 'خطأ',
  }) : errors = [error];

  bool get hasErrors => errors.isNotEmpty;

  factory ErrorSummaryWidget.fromValidation(Map<String, String?> fields) {
    final errors = fields.entries
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .map((e) => e.value!)
        .toList();
    return ErrorSummaryWidget(errors: errors);
  }

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (errors.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${errors.length}',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...errors.map((error) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 28),
                Icon(Icons.fiber_manual_record, size: 6, color: Colors.red.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}