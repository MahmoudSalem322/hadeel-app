/// The six daily time markers shown in the app.
///
/// [sunrise] is displayed in timetables but is not a prayer, so it is never
/// the target of "next prayer" countdowns or prayer notifications.
enum Prayer {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;

  bool get isObligatory => this != Prayer.sunrise;

  static const List<Prayer> obligatory = [
    Prayer.fajr,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];
}
