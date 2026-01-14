import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:runmates/models/notification_model.dart';

class NotificationService {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<NotificationModel>> getNotificationStream() {
    return _client
        .schema('runmates')
        .from('notifications')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (data) =>
              data.map((item) => NotificationModel.fromJson(item)).toList(),
        );
  }

  Map<String, List<NotificationModel>> groupNotificationsByDate(
    List<NotificationModel> data,
  ) {
    final Map<String, List<NotificationModel>> grouped = {};

    for (var item in data) {
      final String groupLabel = _getDateLabel(item.createdAt);

      if (!grouped.containsKey(groupLabel)) {
        grouped[groupLabel] = [];
      }
      grouped[groupLabel]!.add(item);
    }
    return grouped;
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) {
      return 'Hari Ini';
    } else if (checkDate == yesterday) {
      return 'Kemarin';
    } else {
      try {
        return DateFormat('d MMMM yyyy', 'id_ID').format(date);
      } catch (e) {
        return DateFormat('d MMMM yyyy').format(date);
      }
    }
  }
}
