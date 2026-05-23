import "package:flutter/material.dart";

class Prop {
  final String title, location, price, agency, esvNum, imgUrl;
  final int beds, baths;
  final String thirdMeta;
  final IconData thirdIcon;
  final double accuracy;
  const Prop({
    required this.title,
    required this.location,
    required this.price,
    required this.agency,
    required this.esvNum,
    required this.imgUrl,
    required this.beds,
    required this.baths,
    required this.thirdMeta,
    required this.thirdIcon,
    required this.accuracy,
  });
}

class Deal {
  final String title, location, status, price, imgUrl;
  const Deal({
    required this.title,
    required this.location,
    required this.status,
    required this.price,
    required this.imgUrl,
  });
}
