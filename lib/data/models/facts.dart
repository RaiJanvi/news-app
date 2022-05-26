// To parse this JSON data, do
//
//     final facts = factsFromJson(jsonString);

import 'dart:convert';

List<Facts> factsFromJson(String str) => List<Facts>.from(json.decode(str).map((x) => Facts.fromJson(x)));

String factsToJson(List<Facts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Facts {
  Facts({
    required this.fact,
  });

  String fact;

  factory Facts.fromJson(Map<String, dynamic> json) => Facts(
    fact: json["fact"],
  );

  Map<String, dynamic> toJson() => {
    "fact": fact,
  };
}
