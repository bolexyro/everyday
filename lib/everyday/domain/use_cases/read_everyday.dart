import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class ReadEverydayUseCase {
  const ReadEverydayUseCase(this.todayRepository);
  final EverydayRepository todayRepository;

  Future<List<Today>> call() {
    return todayRepository.readEveryday();
  }
}
