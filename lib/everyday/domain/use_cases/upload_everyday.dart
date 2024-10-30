import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class UploadEverydayUseCase {
  const UploadEverydayUseCase(this.todayRepository);
  final EverydayRepository todayRepository;

  Future<void> call() {
    return todayRepository.uploadEveryday();
  }
}
