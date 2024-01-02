class Child {
  String name;
  String recordKey;
  int patchTime;

  Child({required this.name, required this.patchTime, required this.recordKey});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recordKey': recordKey,
      'patchTime': patchTime,
    };
  }

  static Child fromJson(Map<String, dynamic> json) {
    return Child(
      name: json['name'],
      recordKey: json['recordKey'],
      patchTime: json['patchTime'],
    );
  }
}
