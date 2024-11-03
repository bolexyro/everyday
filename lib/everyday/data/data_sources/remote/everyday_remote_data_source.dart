import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EverydayRemoteDataSource {
  const EverydayRemoteDataSource(this.supaBaseClient);
  final SupabaseClient supaBaseClient;

  Future<void> backupEveryday(List<Today> everyday) async {
    // await supaBaseClient.storage.from('bucket_name').;
  }
}
