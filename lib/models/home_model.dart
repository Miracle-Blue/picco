class HomeModel {
  String? id;
  String userId;
  String sellType;
  String homeType;
  String city;
  String district;
  String street;
  String price;
  String definition;
  Geo geo;
  List<bool> houseFacilities;
  String bedsCount;
  String bathCount;
  String roomsCount;
  String houseArea;
  String pushedDate;
  int callsCount;
  int allViews;
  int smsCount;
  List<String> houseImages;
  String? deepLink;

  HomeModel({
    this.id,
    required this.userId,
    required this.sellType,
    required this.homeType,
    required this.city,
    required this.district,
    required this.street,
    required this.price,
    required this.definition,
    required this.geo,
    required this.houseFacilities,
    required this.bedsCount,
    required this.bathCount,
    required this.roomsCount,
    required this.houseArea,
    required this.callsCount,
    required this.allViews,
    required this.smsCount,
    required this.pushedDate,
    required this.houseImages,
    this.deepLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sellType': sellType,
      'homeType': homeType,
      'city': city,
      'district': district,
      'street': street,
      'price': price,
      'definition': definition,
      'geo': geo.toJson(),
      'houseFacilities': houseFacilities,
      'bedsCount': bedsCount,
      'bathCount': bathCount,
      'roomsCount': roomsCount,
      'houseArea': houseArea,
      'callsCount': callsCount,
      'allViews': allViews,
      'smsCount': smsCount,
      'pushedDate': pushedDate,
      'houseImages': houseImages,
      'deepLink': deepLink,
    };
  }

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      sellType: json['sellType'] as String,
      homeType: json['homeType'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      street: json['street'] as String,
      price: json['price'] as String,
      definition: json['definition'] as String,
      geo: Geo.fromJson(json['geo']),
      houseFacilities: List<bool>.from(json['houseFacilities']),
      bedsCount: json['bedsCount'] as String,
      bathCount: json['bathCount'] as String,
      roomsCount: json['roomsCount'] as String,
      houseArea: json['houseArea'] as String,
      smsCount: json['smsCount'] as int,
      allViews: json['allViews'] as int,
      callsCount: json['callsCount'] as int,
      pushedDate: json['pushedDate'] as String,
      houseImages: List<String>.from(json['houseImages']),
      deepLink: json['deepLink'] as String,
    );
  }

  @override
  String toString() {
    return 'HomeModel{'
        'id: $id,'
        'userId: $userId,'
        'sellType: $sellType,'
        'homeType: $homeType,'
        'city: $city,'
        'district: $district,'
        'street: $street,'
        'price: $price,'
        'definition: $definition,'
        'geo: $geo,'
        'houseFacilities: $houseFacilities,'
        'bedsCount: $bedsCount,'
        'bathCount: $bathCount,'
        'roomsCount: $roomsCount,'
        'houseArea: $houseArea,'
        'smsCount: $smsCount,'
        'allViews: $allViews,'
        'callsCount: $callsCount,'
        'pushedDate: $pushedDate,'
        'houseImages: $houseImages,'
        'deepLink:$deepLink}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          sellType == other.sellType &&
          homeType == other.homeType &&
          city == other.city &&
          district == other.district &&
          street == other.street &&
          price == other.price &&
          definition == other.definition &&
          geo == other.geo &&
          houseFacilities == other.houseFacilities &&
          bedsCount == other.bedsCount &&
          bathCount == other.bathCount &&
          roomsCount == other.roomsCount &&
          houseArea == other.houseArea &&
          pushedDate == other.pushedDate &&
          callsCount == other.callsCount &&
          allViews == other.allViews &&
          smsCount == other.smsCount &&
          houseImages == other.houseImages &&
          deepLink == other.deepLink;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      sellType.hashCode ^
      homeType.hashCode ^
      city.hashCode ^
      district.hashCode ^
      street.hashCode ^
      price.hashCode ^
      definition.hashCode ^
      geo.hashCode ^
      houseFacilities.hashCode ^
      bedsCount.hashCode ^
      bathCount.hashCode ^
      roomsCount.hashCode ^
      houseArea.hashCode ^
      pushedDate.hashCode ^
      callsCount.hashCode ^
      allViews.hashCode ^
      smsCount.hashCode ^
      houseImages.hashCode ^
      deepLink.hashCode;
}

class Geo {
  final double latitude;
  final double longitude;

  const Geo({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  @override
  String toString() {
    return 'Geo{ latitude: $latitude, longitude: $longitude, }';
  }
}

List<HomeModel> homes = [];
Map<String, HomeModel> filteredHomes = {};
List<HomeModel> similarHomes = [];

const homeSellType = [
  'buy_houses',
  'rent_houses',
];

const homeCategoryType = [
  'house',
  'buildings_for_business',
  'new_building',
  'cottage',
  'hotel',
  'country_houses',
];
