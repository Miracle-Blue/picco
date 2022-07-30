class FilterModel {
  int minPrice;
  int maxPrice;
  String bedsNumber;
  String bathsNumber;
  String roomsNumber;
  bool hasWiFi;
  bool hasAC;
  bool hasWashingMachine;

  FilterModel({
    this.minPrice = 20,
    this.maxPrice = 2000,
    this.bedsNumber = 'Неважно',
    this.bathsNumber = 'Неважно',
    this.roomsNumber = 'Неважно',
    this.hasWiFi = false,
    this.hasAC = false,
    this.hasWashingMachine = false,
  });
}
