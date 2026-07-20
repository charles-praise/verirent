import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Status { initial }

final class MainState extends Equatable {
  final Status status;
  final int navigationIndex;
  final List<Widget> pages;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const MainState({
    this.status = Status.initial,
    this.navigationIndex = 0,
    this.pages = const [],
    this.scaffoldKey,
  });

  MainState copyWith({
    Status? status,
    int? navigationIndex,
    List<Widget>? pages,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    return MainState(
      status: status ?? this.status,
      navigationIndex: navigationIndex ?? this.navigationIndex,
      pages: pages ?? this.pages,
      scaffoldKey: scaffoldKey ?? this.scaffoldKey,
    );
  }

  @override
  List<Object> get props => [status, navigationIndex, pages, ?scaffoldKey];
}
