class Contact {
  Contact({
    required this.phone,
    required this.fullName,
  });
  late final String phone;
  late final String fullName;
  late int id;
  Contact.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    fullName = json['fullName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = <String, dynamic>{};
    _data['phone'] = phone;
    _data['fullName'] = fullName;
    return _data;
  }
}
