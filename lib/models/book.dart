class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int pages;
  final String publisher;
  final DateTime publishDate;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.pages,
    required this.publisher,
    required this.publishDate,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      pages: json['pages'] as int,
      publisher: json['publisher'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'pages': pages,
      'publisher': publisher,
      'publishDate': publishDate.toIso8601String(),
      'rating': rating,
      'reviewCount': reviewCount,
      'isAvailable': isAvailable,
    };
  }
} 