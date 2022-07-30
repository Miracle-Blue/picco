class Filter {
  int minPrice;
  int maxPrice;
  String roomsNumber;
  String bedsNumber;
  String bathsNumber;

  Filter({
    this.minPrice = 20,
    this.maxPrice = 2000,
    this.roomsNumber = 'Неважно',
    this.bedsNumber = 'Неважно',
    this.bathsNumber = 'Неважно',
  });
}
