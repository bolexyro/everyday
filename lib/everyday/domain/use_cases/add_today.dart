import 'package:myapp/everyday/domain/entities/today.dart';
import 'package:myapp/everyday/domain/repository/everyday_repository.dart';

class AddTodayUseCase {
  const AddTodayUseCase(this.todayRepository);
  final EverydayRepository todayRepository;

  Future<Today> call(String videoPath, String caption) {
    return todayRepository.addToday(videoPath, caption);
  }
}
