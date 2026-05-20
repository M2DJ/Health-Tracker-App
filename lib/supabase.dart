import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTableService {
  final table = Supabase.instance.client.from('table1');

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
}
