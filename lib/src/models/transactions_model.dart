class TransactionModel {
  String id;
  double amount;
  String description;
  String category;
  String method;
  DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.method,
    required this.date,
  });

factory TransactionModel.fromJson(String id, Map<String, dynamic> json) {
    return TransactionModel(
      id: id,
      amount: json['amount'] ?? 0.0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      method: json['method'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
}


  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'description': description,
        'category': category,
        'method': method,
        'date': date.toIso8601String(),
      };
}
