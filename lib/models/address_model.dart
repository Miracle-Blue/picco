class Address {
  List regions = [];
  List districts = [];

  Address();

  Address.fromJsonRegions(Map<String, dynamic> json) : regions = json['ru'];

  Address.fromJsonDistricts(Map<String, dynamic> json) : districts = json["ru"];
}
