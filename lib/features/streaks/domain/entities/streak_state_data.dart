class StreakStateData {
  const StreakStateData({
    required this.currentStreakCount,
    required this.mostStreakCount,
    required this.streakCalendr,
  });

  final int currentStreakCount;
  final int mostStreakCount;
  final List<DateTime> streakCalendr;

  StreakStateData copyWith({
    int? currentStreakCount,
    int? mostStreakCount,
    List<DateTime>? streakCalendr,
  }) {
    return StreakStateData(
      currentStreakCount: currentStreakCount ?? this.currentStreakCount,
      mostStreakCount: mostStreakCount ?? this.mostStreakCount,
      streakCalendr: streakCalendr ?? this.streakCalendr,
    );
  }
}
