// ignore_for_file: public_member_api_docs, sort_constructors_first

class Quote {
  final String quote;
  final String author;

  Quote({required this.quote, required this.author});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'q': quote,
      'a': author,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      quote: map['q'] as String,
      author: map['a'] as String,
    );
  }
}
