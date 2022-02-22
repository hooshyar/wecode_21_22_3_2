import 'dart:convert';

class ListItem {
  String imgUil;
  String newsTitle;
  String author;
  String data;
  ListItem({
    required this.imgUil,
    required this.newsTitle,
    required this.author,
    required this.data,
  });


  ListItem copyWith({
    String? imgUil,
    String? newsTitle,
    String? author,
    String? data,
  }) {
    return ListItem(
      imgUil: imgUil ?? this.imgUil,
      newsTitle: newsTitle ?? this.newsTitle,
      author: author ?? this.author,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imgUil': imgUil,
      'newsTitle': newsTitle,
      'author': author,
      'data': data,
    };
  }

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      imgUil: map['imgUil'] ?? '',
      newsTitle: map['newsTitle'] ?? '',
      author: map['author'] ?? '',
      data: map['data'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ListItem.fromJson(String source) => ListItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ListItem(imgUil: $imgUil, newsTitle: $newsTitle, author: $author, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ListItem &&
      other.imgUil == imgUil &&
      other.newsTitle == newsTitle &&
      other.author == author &&
      other.data == data;
  }

  @override
  int get hashCode {
    return imgUil.hashCode ^
      newsTitle.hashCode ^
      author.hashCode ^
      data.hashCode;
  }
}
