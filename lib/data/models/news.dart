// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
  News({
    required this.totalResults,
    required this.articles,
  });

  List<Article> articles;
  int totalResults;

  factory News.fromJson(Map<String, dynamic> json) => News(
    articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
    totalResults: json["totalResults"],
  );

  Map<String, dynamic> toJson() => {
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Article {
  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  DateTime? publishedAt;
  String? content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    source: Source.fromJson(json["source"]),
    author: json["author"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    urlToImage: json["urlToImage"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    content: json["content"],
  );

  factory Article.frommap(Map<String, dynamic> map) => Article(
    source: Source(name: map['source']),
    author: map["author"],
    title: map["title"],
    description: map["description"],
    url: map["url"],
    urlToImage: map["urlToImage"],
    publishedAt: DateTime.parse(map["publishedAt"]),
    content: map["content"],
  );

  Map<String, dynamic> toJson() => {
    "source": source?.toJson(),
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt?.toIso8601String(),
    "content": content,
  };
}

class Source {
  Source({
    required this.name,
  });

  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
