import 'package:flutter/cupertino.dart';
import 'package:picco/customer/view/pages/profile/local_widgets/information_page.dart';
import 'package:picco/customer/view/pages/profile/local_widgets/notification_page.dart';
import 'package:picco/customer/view/pages/profile/local_widgets/settings_page.dart';
import 'package:picco/customer/view/pages/profile/local_widgets/user_management_page.dart';

class AppArt {
  String name;
  String logo;

  AppArt({
    required this.name,
    required this.logo,
  });
}

class AppArtList {
  static List<AppArt> products = [
    AppArt(
      name: 'Дома / Квартира',
      logo: 'assets/icons/home_page_icons/hotels.png',
    ),
    AppArt(
      name: 'Здания для бизнеса',
      logo: 'assets/icons/home_page_icons/office-buildings.png',
    ),
    AppArt(
      name: 'Новостройки',
      logo: 'assets/icons/home_page_icons/office-buildings.png',
    ),
    AppArt(
      name: 'Загородные дома',
      logo: 'assets/icons/home_page_icons/country-houses.png',
    ),
    AppArt(
      name: 'Коттеджи',
      logo: 'assets/icons/home_page_icons/pavilions.png',
    ),
    AppArt(
      name: 'Гостиница',
      logo: 'assets/icons/home_page_icons/hotels.png',
    ),
  ];
}

class ImageCity {
  final String image;
  final String name;

  ImageCity({
    required this.image,
    required this.name,
  });
}

class ImageCityList {
  static List<ImageCity> list = [
    ImageCity(
      image: 'assets/images/tashkent.jpg',
      name: 'Ташкент',
    ),
    ImageCity(
      image: 'assets/images/samarkand.jpg',
      name: 'Самарканд',
    ),
    ImageCity(
      image: 'assets/images/khiva.jpg',
      name: 'Хива',
    ),
  ];
}

class AttractivePlaces {
  final String image;
  final String videoAboutDes;
  final String extraImage;
  final String name;
  final String photoDescription;
  final String extraImageDescription;
  final String description;
  final String url;

  AttractivePlaces(
      {required this.extraImage,
      required this.photoDescription,
      required this.extraImageDescription,
      required this.videoAboutDes,
      required this.url,
      required this.image,
      required this.name,
      required this.description,
      });
}

class AttractivePlacesList {
  static List<AttractivePlaces> list = [
    AttractivePlaces(
        image: 'assets/images/tashkent.jpg',
        name: 'Ташкент',
        description:
            "The Tashkent Television Tower (Uzbek:Toshkent Teleminorasi) is a 375-metre-high (1,230 ft) tower, located in Tashkent, Uzbekistan and is the twelfth tallest tower in the world.",
        url: 'https://youtu.be/P8fcfqagsC0',
        photoDescription:
            '''Неотъемлемая часть каждого путешествия — это фотографии! В этой рубрике мы познакомим вас с самыми красивыми местами этого города, где вы сможете сделать самые лучшие кадры. \nP.S. Не забывайте, что при посещении религиозных достопримечательностей Узбекистана женщинам желательно прикрыть открытые части тела (плечи, спина и ноги).''',
        extraImage: 'assets/extra_images/mm.jpg',
        extraImageDescription:
            '☪️ Мечеть Минор была построена в 2014 году и сразу же полюбилась всем жителям и гостям столицы. \nВыполнена она из белого мрамора и расположена в живописном месте.',
        videoAboutDes: 'Video about Tashkent'),
    AttractivePlaces(
      image: 'assets/images/samarkand.jpg',
      name: 'Самарканд',
      description:
          "The Tashkent Television Tower (Uzbek:Tashkent Telemeter) is a 375-metre-high (1,230 ft) tower, located in Tashkent, Uzbekistan and is the twelfth tallest tower in the world.",
      url: 'https://www.youtube.com/watch?v=1feAEm1EnSI',
      photoDescription: 'v',
      extraImage: 'assets/extra_images/samarkand.jpg',
      extraImageDescription:
          '☪️ Комплекс Хазрати Имам (в народе известный как Хаст Имам) является одной из главных достопримечательностей Ташкента. Он появился около 4 веков назад. \nСейчас множество туристов каждый день приезжают оценить красоту архитектуры этого места.',
      videoAboutDes: 'Video about Samarkand',
    ),
    AttractivePlaces(
      image: 'assets/images/khiva.jpg',
      name: 'Хива',
      description:
          "The Tashkent Television Tower (Uzbek:Toshkent Teleminorasi) is a 375-metre-high (1,230 ft) tower, located in Tashkent, Uzbekistan and is the twelfth tallest tower in the world.",
      url: 'https://www.youtube.com/watch?v=vQVwkyn3-F8',
      photoDescription: 'v',
      extraImage: 'assets/extra_images/xiva.jpg',
      extraImageDescription: '''Khiva is a beautiful oasis city with ancient walls, minarets and unique clay buildings.\nKhiva is over 2500 years old. If you want to plunge into history and see the true beauty of the ancient East, then welcome to Khiva.''',
      videoAboutDes: 'Video about Khiva',
    ),
  ];
}

class ProfileModel {
  String text;
  IconData icon;
  Widget id;

  ProfileModel({required this.text, required this.icon, required this.id});

  static List<ProfileModel> elements = [
    ProfileModel(
      text: 'Управление пользователями',
      icon: CupertinoIcons.person,
      id: UserManagementPage(),
    ),
    ProfileModel(
      text: 'Настройки',
      icon: CupertinoIcons.settings,
      id: const SettingsPage(),
    ),
    ProfileModel(
      text: 'Уведомления',
      icon: CupertinoIcons.bell,
      id: const NotificationPage(),
    ),
    ProfileModel(
      text: 'Информация',
      icon: CupertinoIcons.info,
      id: const InformationPage(),
    ),
    // ProfileModel(
    //   text: 'Выйти',
    //   icon: CupertinoIcons.arrow_right,
    //   id: const HomePage(),
    // )
  ];
}

//Managements TextFields
class TextFieldLabels {
  String? text2;

  TextFieldLabels({this.text2});

  static List<TextFieldLabels> labels = [
    TextFieldLabels(text2: 'Полное имя'),
    TextFieldLabels(text2: 'Телефонный номер'),
    TextFieldLabels(text2: 'Пароль'),
  ];
}

List<String> imagesHeader = [
  "assets/home_page_images/rent.png",
  "assets/home_page_images/house.png",
  "assets/home_page_images/hyatt.png",
  "assets/home_page_images/tashkent_city.png",
  "assets/home_page_images/dacha.png",
];

class FavoriteObject {
  List favoriteHousesList = [];

  set list(List list) => favoriteHousesList = list;

  List get list => favoriteHousesList;
}
