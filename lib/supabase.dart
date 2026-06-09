import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTableService {
  final table = Supabase.instance.client.from('table1');
  RealtimeChannel? subscription;

  Future loadLastestRow() async {
    try {
      final response = await table
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      return response;
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  RealtimeChannel subscribeToTable1({
    required Function(Map<String, dynamic>) onNewRow,
  }) {
    subscription = Supabase.instance.client
        .channel('public:table1')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'table1',
          callback: (payload) => onNewRow(payload.newRecord),
        )
        .subscribe();

    return subscription!;
  }

  void unsubscribe() {
    subscription?.unsubscribe();
    subscription = null;
  }
}
