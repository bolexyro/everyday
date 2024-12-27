import 'package:myapp/features/everyday/domain/repository/today_repository.dart';

class DeleteTodayUseCase {
  const DeleteTodayUseCase(this.todayRepository);
  final TodayRepository todayRepository;

  Future<void> call(String id, String videoPath, bool onlyLocal) {
    return todayRepository.deleteToday(id, videoPath, onlyLocal);
  }
}
