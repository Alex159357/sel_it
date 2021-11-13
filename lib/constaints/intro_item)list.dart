

import 'package:sel_it/data/intro_list_item.dart';

class IntroList{
  static List<IntroListItem> get introList => [
    IntroListItem(step: "1", image: "assets/img/camera_img.png", caption: "Сделайте фото Вашего товара или услуги", imageHeight: 70 ),
    IntroListItem(step: "2", image: "assets/img/logo.png", caption: "Мы создаем мини сайт", imageHeight: 30),
    IntroListItem(step: "3", image: "assets/img/social.png", caption: "Мы рекламируем Ваш мини сайт", imageHeight: 70),
    IntroListItem(step: "4", image: "assets/img/clients.png", caption: "Вы получаете звонки, клиентов, продажи", imageHeight: 70),
  ];
}