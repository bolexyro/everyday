abstract class StreakRepository {
  Future<int> getCurrentStreakCount(String currentUserEmail);
  Future<int> getMostStreakCount(String currentUserEmail);
  Future<List<DateTime>> getStreakCalendar(String currentUserEmail);
}
