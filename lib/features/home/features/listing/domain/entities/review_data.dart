class ReviewData {
  const ReviewData({
    required this.name,
    required this.initials,
    required this.rating,
    required this.date,
    required this.text,
  });
  final String name, initials, date, text;
  final int rating;
}
