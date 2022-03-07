class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.publishDate,
    required this.edition,
    required this.cost,
    required this.sugRetailPrice,
    required this.condition,
    required this.sold,
  });

  final String id;
  String title;
  final String author;
  final String publisher;
  final int publishDate;
  final int edition;
  final double cost;
  final double sugRetailPrice;
  final String condition;
  final bool sold;
}