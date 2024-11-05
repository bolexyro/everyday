import 'package:myapp/everyday/domain/repository/today_repository.dart';

class DeleteTodayUseCase {
  const DeleteTodayUseCase(this.todayRepository);
  final TodayRepository todayRepository;

  Future<void> call(String id, String videoPath) {
    return todayRepository.deleteToday(id, videoPath);
  }
}
