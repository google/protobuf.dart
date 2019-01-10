///
//  Generated code. Do not modify.
//  source: int64grid.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class Grid extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Grid', package: const $pb.PackageName('int64_grid'))
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
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Line', package: const $pb.PackageName('int64_grid'))
    ..p<Int64>(1, 'cells', $pb.PbFieldType.P6)
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

  List<Int64> get cells => $_getList(0);
}

class Grid10 extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Grid10', package: const $pb.PackageName('int64_grid'))
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
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Line10', package: const $pb.PackageName('int64_grid'))
    ..aInt64(1, 'cell1')
    ..aInt64(2, 'cell2')
    ..aInt64(3, 'cell3')
    ..aInt64(4, 'cell4')
    ..aInt64(5, 'cell5')
    ..aInt64(6, 'cell6')
    ..aInt64(7, 'cell7')
    ..aInt64(8, 'cell8')
    ..aInt64(9, 'cell9')
    ..aInt64(10, 'cell10')
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

  Int64 get cell1 => $_getI64(0);
  set cell1(Int64 v) { $_setInt64(0, v); }
  bool hasCell1() => $_has(0);
  void clearCell1() => clearField(1);

  Int64 get cell2 => $_getI64(1);
  set cell2(Int64 v) { $_setInt64(1, v); }
  bool hasCell2() => $_has(1);
  void clearCell2() => clearField(2);

  Int64 get cell3 => $_getI64(2);
  set cell3(Int64 v) { $_setInt64(2, v); }
  bool hasCell3() => $_has(2);
  void clearCell3() => clearField(3);

  Int64 get cell4 => $_getI64(3);
  set cell4(Int64 v) { $_setInt64(3, v); }
  bool hasCell4() => $_has(3);
  void clearCell4() => clearField(4);

  Int64 get cell5 => $_getI64(4);
  set cell5(Int64 v) { $_setInt64(4, v); }
  bool hasCell5() => $_has(4);
  void clearCell5() => clearField(5);

  Int64 get cell6 => $_getI64(5);
  set cell6(Int64 v) { $_setInt64(5, v); }
  bool hasCell6() => $_has(5);
  void clearCell6() => clearField(6);

  Int64 get cell7 => $_getI64(6);
  set cell7(Int64 v) { $_setInt64(6, v); }
  bool hasCell7() => $_has(6);
  void clearCell7() => clearField(7);

  Int64 get cell8 => $_getI64(7);
  set cell8(Int64 v) { $_setInt64(7, v); }
  bool hasCell8() => $_has(7);
  void clearCell8() => clearField(8);

  Int64 get cell9 => $_getI64(8);
  set cell9(Int64 v) { $_setInt64(8, v); }
  bool hasCell9() => $_has(8);
  void clearCell9() => clearField(9);

  Int64 get cell10 => $_getI64(9);
  set cell10(Int64 v) { $_setInt64(9, v); }
  bool hasCell10() => $_has(9);
  void clearCell10() => clearField(10);
}

