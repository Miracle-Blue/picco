import 'package:flutter/material.dart';
import 'package:picco/customer/view/controller_pages.dart';
import 'package:picco/models/filter_model.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/log_service.dart';

class FilterProvider extends ChangeNotifier {
  Filter _filterObject = Filter();

  final _houseProperties = <String>[
    'Комнаты',
    'Спальни',
    'Ванны',
  ];

  final _propertiesNumber = <String>[
    'Неважно',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '9+',
  ];

  /*final _homeAppliances = <String>[
    'Кухонный мебель',
    'Мебель в комнатах',
    'Холодильник',
    'Стиральная машина',
    'Телевизор',
    'Wi-Fi',
    'Кондитционер',
    'Посудамойка',
    'Душевая кабина',
    'Можно с детми',
    'Можно с животными',
  ];*/

  final Map<String, bool> _facilities = {
    'Кухонная мебель': false,
    'Мебель в комнатах': false,
    'Холодильник': false,
    'Стиральная машина': false,
    'Телевизор': false,
    'Интернет': false,
    'Кондиционер': false,
    'Посудомоечная машина': false,
    'Душевая кабина': false,
    'Можно с детьми': false,
    'Домашние животные разрешены': false,
  };

  RangeValues _sliderValue = const RangeValues(1, 100);

  RangeValues get sliderValue => _sliderValue;

  set sliderValue(RangeValues value) {
    if (value != _sliderValue) {
      _sliderValue = value;
      _filterObject.minPrice = _sliderValue.start.floor() * 20;
      _filterObject.maxPrice = _sliderValue.end.floor() * 20;

      for (final home in homes) {
        if (_filterObject.maxPrice >= int.parse(home.price) &&
            _filterObject.minPrice <= int.parse(home.price)) {
          filteredHomes.putIfAbsent(home.id!, () => home);
        }
      }

      Log.w(filteredHomes.toString());
      notifyListeners();
    }
  }

  List<String> get facilities => _facilities.keys.toList();

  List<String> get propertiesNumber => _propertiesNumber;

  List<String> get houseProperties => _houseProperties;

  int get minPrice => _sliderValue.start.floor() * 20;

  int get maxPrice => _sliderValue.end.floor() * 20;

  int get avgPrice => ((minPrice + maxPrice) / 2).round();

  /// For ListView
  bool checkIfSelected(int index, int i) {
    // * i - is index of _houseProperties list
    // * index - is index of _propertiesNumber list
    String number = _houseProperties[i] == 'Комнаты'
        ? _filterObject.roomsNumber
        : _houseProperties[i] == 'Спальни'
            ? _filterObject.bedsNumber
            : _filterObject.bathsNumber;

    return propertiesNumber[index] == number;
  }

  void updateSelected(int index, int i) {
    // * i - is index of _houseProperties list
    // * index - is index of _propertiesNumber list
    _houseProperties[i] == 'Комнаты'
        ? _filterObject.roomsNumber = _propertiesNumber[index]
        : _houseProperties[i] == 'Спальни'
            ? _filterObject.bedsNumber = _propertiesNumber[index]
            : _filterObject.bathsNumber = _propertiesNumber[index];

    for (final home in homes) {
      if (home.roomsCount == _filterObject.roomsNumber ||
          home.bedsCount == _filterObject.bedsNumber ||
          home.bathCount == _filterObject.bathsNumber) {
        filteredHomes.putIfAbsent(home.id!, () => home);
      }
    }

    Log.w(filteredHomes.toString());
    notifyListeners();
  }

  /// For CheckboxListTile
  bool identifyValue(String title) {
    if (_facilities.keys.contains(title)) {
      return _facilities[title]!;
    }
    return false;
  }

  // => _facilities.values.toList()[index];
  // {
  //   switch (title) {
  //     case 'Wi-Fi':
  //       return _filterObject.hasWiFi;
  //     case 'Кондиционер':
  //       return _filterObject.hasAC;
  //     case 'Посудомоечная машина':
  //       return _filterObject.hasWashingMachine;
  //     case 'Холодильник':
  //       return _filterObject.hasFridge;
  //     case 'Телевизор':
  //       return _filterObject.hasTV;
  //   }
  //   return false;
  // }

  void updateValue(String title, bool value) {
    if (_facilities.keys.contains(title)) {
      _facilities[title] = value;

      for (final home in homes) {
        for (int i = 0; i < _facilities.length; i++) {
          if (_facilities.values.toList()[i] == true &&
              home.houseFacilities[i] == true) {
            filteredHomes.putIfAbsent(home.id!, () => home);
          }
        }
      }

      Log.w(filteredHomes.toString());
      notifyListeners();
    }
    // switch (title) {
    //   case 'Wi-Fi':
    //     _filterObject.hasWiFi = value;
    //     notifyListeners();
    //     break;
    //   case 'Кондиционер':
    //     _filterObject.hasAC = value;
    //     notifyListeners();
    //     break;
    //   case 'Посудомоечная машина':
    //     _filterObject.hasWashingMachine = value;
    //     notifyListeners();
    //     break;
    //   case 'Холодильник':
    //     _filterObject.hasFridge = value;
    //     notifyListeners();
    //     break;
    //   case 'Телевизор':
    //     _filterObject.hasTV = value;
    //     notifyListeners();
    //     break;
    // }
  }

  /// For Buttons
  void clear() {
    print(
        'slider.start: ${_sliderValue.start} \t slider.end: ${_sliderValue.end}');
    print(
        'minPrice: ${_filterObject.minPrice} \t maxPrice: ${_filterObject.maxPrice}');
    print(
        'roomsNumber: ${_filterObject.roomsNumber} \t bedsNumber: ${_filterObject.bedsNumber} \t bathsNumber: ${_filterObject.bathsNumber}');
    print('Facilities: $_facilities');

    _filterObject = Filter();
    _sliderValue = const RangeValues(1, 100);
    notifyListeners();
    for (String title in _facilities.keys) {
      print('Updating....');
      updateValue(title, false);
    }

    print('Cleared Facilities: $_facilities');
  }

  void done(BuildContext context) {
    print(
        'minPrice: ${_filterObject.minPrice} \t maxPrice: ${_filterObject.maxPrice}');
    print(
        'roomsNumber: ${_filterObject.roomsNumber} \t bedsNumber: ${_filterObject.bedsNumber} \t bathsNumber: ${_filterObject.bathsNumber}');
    print('Facilities: $_facilities');
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PagesController(),
      ),
    );
  }
}
