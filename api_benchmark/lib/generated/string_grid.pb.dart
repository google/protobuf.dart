///
//  Generated code. Do not modify.
//  source: string_grid.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class Grid extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Grid', package: const $pb.PackageName('string_grid'))
    ..pp<Line>(1, 'lines', $pb.PbFieldType.PM, Line.$checkItem, Line.create)
    ..hasRequiredFields = false
  ;

  Grid() : super();
  Grid.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Grid.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Grid clone() => new Grid()..mergeFromMessage(this);
  Grid copyWith(void Function(Grid) updates) => super.copyWith((message) => updates(message as Grid));
  $pb.BuilderInfo get info_ => _i;
  static Grid create() => new Grid();
  Grid createEmptyInstance() => create();
  static $pb.PbList<Grid> createRepeated() => new $pb.PbList<Grid>();
  static Grid getDefault() => _defaultInstance ??= create()..freeze();
  static Grid _defaultInstance;
  static void $checkItem(Grid v) {
    if (v is! Grid) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<Line> get lines => $_getList(0);
}

class Line extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Line', package: const $pb.PackageName('string_grid'))
    ..pPS(1, 'cells')
    ..hasRequiredFields = false
  ;

  Line() : super();
  Line.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Line.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Line clone() => new Line()..mergeFromMessage(this);
  Line copyWith(void Function(Line) updates) => super.copyWith((message) => updates(message as Line));
  $pb.BuilderInfo get info_ => _i;
  static Line create() => new Line();
  Line createEmptyInstance() => create();
  static $pb.PbList<Line> createRepeated() => new $pb.PbList<Line>();
  static Line getDefault() => _defaultInstance ??= create()..freeze();
  static Line _defaultInstance;
  static void $checkItem(Line v) {
    if (v is! Line) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<String> get cells => $_getList(0);
}

class Grid10 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Grid10', package: const $pb.PackageName('string_grid'))
    ..pp<Line10>(1, 'lines', $pb.PbFieldType.PM, Line10.$checkItem, Line10.create)
    ..hasRequiredFields = false
  ;

  Grid10() : super();
  Grid10.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Grid10.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Grid10 clone() => new Grid10()..mergeFromMessage(this);
  Grid10 copyWith(void Function(Grid10) updates) => super.copyWith((message) => updates(message as Grid10));
  $pb.BuilderInfo get info_ => _i;
  static Grid10 create() => new Grid10();
  Grid10 createEmptyInstance() => create();
  static $pb.PbList<Grid10> createRepeated() => new $pb.PbList<Grid10>();
  static Grid10 getDefault() => _defaultInstance ??= create()..freeze();
  static Grid10 _defaultInstance;
  static void $checkItem(Grid10 v) {
    if (v is! Grid10) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<Line10> get lines => $_getList(0);
}

class Line10 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Line10', package: const $pb.PackageName('string_grid'))
    ..aOS(1, 'cell1')
    ..aOS(2, 'cell2')
    ..aOS(3, 'cell3')
    ..aOS(4, 'cell4')
    ..aOS(5, 'cell5')
    ..aOS(6, 'cell6')
    ..aOS(7, 'cell7')
    ..aOS(8, 'cell8')
    ..aOS(9, 'cell9')
    ..aOS(10, 'cell10')
    ..hasRequiredFields = false
  ;

  Line10() : super();
  Line10.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Line10.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Line10 clone() => new Line10()..mergeFromMessage(this);
  Line10 copyWith(void Function(Line10) updates) => super.copyWith((message) => updates(message as Line10));
  $pb.BuilderInfo get info_ => _i;
  static Line10 create() => new Line10();
  Line10 createEmptyInstance() => create();
  static $pb.PbList<Line10> createRepeated() => new $pb.PbList<Line10>();
  static Line10 getDefault() => _defaultInstance ??= create()..freeze();
  static Line10 _defaultInstance;
  static void $checkItem(Line10 v) {
    if (v is! Line10) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get cell1 => $_getS(0, '');
  set cell1(String v) { $_setString(0, v); }
  bool hasCell1() => $_has(0);
  void clearCell1() => clearField(1);

  String get cell2 => $_getS(1, '');
  set cell2(String v) { $_setString(1, v); }
  bool hasCell2() => $_has(1);
  void clearCell2() => clearField(2);

  String get cell3 => $_getS(2, '');
  set cell3(String v) { $_setString(2, v); }
  bool hasCell3() => $_has(2);
  void clearCell3() => clearField(3);

  String get cell4 => $_getS(3, '');
  set cell4(String v) { $_setString(3, v); }
  bool hasCell4() => $_has(3);
  void clearCell4() => clearField(4);

  String get cell5 => $_getS(4, '');
  set cell5(String v) { $_setString(4, v); }
  bool hasCell5() => $_has(4);
  void clearCell5() => clearField(5);

  String get cell6 => $_getS(5, '');
  set cell6(String v) { $_setString(5, v); }
  bool hasCell6() => $_has(5);
  void clearCell6() => clearField(6);

  String get cell7 => $_getS(6, '');
  set cell7(String v) { $_setString(6, v); }
  bool hasCell7() => $_has(6);
  void clearCell7() => clearField(7);

  String get cell8 => $_getS(7, '');
  set cell8(String v) { $_setString(7, v); }
  bool hasCell8() => $_has(7);
  void clearCell8() => clearField(8);

  String get cell9 => $_getS(8, '');
  set cell9(String v) { $_setString(8, v); }
  bool hasCell9() => $_has(8);
  void clearCell9() => clearField(9);

  String get cell10 => $_getS(9, '');
  set cell10(String v) { $_setString(9, v); }
  bool hasCell10() => $_has(9);
  void clearCell10() => clearField(10);
}

