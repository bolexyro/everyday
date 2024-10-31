import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class DeleteTodayUseCase {
  const DeleteTodayUseCase(this.todayRepository);
  final EverydayRepository todayRepository;

  Future<void> call(String id, String videoPath) {
    return todayRepository.deleteToday(id, videoPath);
  }
}
