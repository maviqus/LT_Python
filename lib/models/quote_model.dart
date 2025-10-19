class Quote {
  final String text;
  final String author;
  final String book;
  final String authorImg;
  final String id;

  Quote({
    required this.text,
    required this.author,
    required this.book,
    required this.authorImg,
    required this.id,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'] ?? '',
      author: json['a'] ?? '',
      book: '',
      authorImg: '',
      id: '',
    );
  }
}
