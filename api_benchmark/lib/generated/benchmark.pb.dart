///
//  Generated code. Do not modify.
//  source: benchmark.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'benchmark.pbenum.dart';

export 'benchmark.pbenum.dart';

class Suite extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Suite', package: const $pb.PackageName('benchmark'))
    ..pp<Request>(1, 'requests', $pb.PbFieldType.PM, Request.$checkItem, Request.create)
    ..hasRequiredFields = false
  ;

  Suite() : super();
  Suite.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Suite.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Suite clone() => new Suite()..mergeFromMessage(this);
  Suite copyWith(void Function(Suite) updates) => super.copyWith((message) => updates(message as Suite));
  $pb.BuilderInfo get info_ => _i;
  static Suite create() => new Suite();
  Suite createEmptyInstance() => create();
  static $pb.PbList<Suite> createRepeated() => new $pb.PbList<Suite>();
  static Suite getDefault() => _defaultInstance ??= create()..freeze();
  static Suite _defaultInstance;
  static void $checkItem(Suite v) {
    if (v is! Suite) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<Request> get requests => $_getList(0);
}

class Request extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Request', package: const $pb.PackageName('benchmark'))
    ..e<BenchmarkID>(1, 'id', $pb.PbFieldType.OE, BenchmarkID.READ_INT32_FIELDS_JSON, BenchmarkID.valueOf, BenchmarkID.values)
    ..a<Params>(2, 'params', $pb.PbFieldType.OM, Params.getDefault, Params.create)
    ..a<int>(3, 'samples', $pb.PbFieldType.O3)
    ..a<int>(4, 'duration', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Request() : super();
  Request.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Request.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Request clone() => new Request()..mergeFromMessage(this);
  Request copyWith(void Function(Request) updates) => super.copyWith((message) => updates(message as Request));
  $pb.BuilderInfo get info_ => _i;
  static Request create() => new Request();
  Request createEmptyInstance() => create();
  static $pb.PbList<Request> createRepeated() => new $pb.PbList<Request>();
  static Request getDefault() => _defaultInstance ??= create()..freeze();
  static Request _defaultInstance;
  static void $checkItem(Request v) {
    if (v is! Request) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  BenchmarkID get id => $_getN(0);
  set id(BenchmarkID v) { setField(1, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  Params get params => $_getN(1);
  set params(Params v) { setField(2, v); }
  bool hasParams() => $_has(1);
  void clearParams() => clearField(2);

  int get samples => $_get(2, 0);
  set samples(int v) { $_setSignedInt32(2, v); }
  bool hasSamples() => $_has(2);
  void clearSamples() => clearField(3);

  int get duration => $_get(3, 0);
  set duration(int v) { $_setSignedInt32(3, v); }
  bool hasDuration() => $_has(3);
  void clearDuration() => clearField(4);
}

class Params extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Params', package: const $pb.PackageName('benchmark'))
    ..a<int>(1, 'messageCount', $pb.PbFieldType.O3)
    ..a<int>(2, 'int32FieldCount', $pb.PbFieldType.O3)
    ..a<int>(3, 'int32RepeatCount', $pb.PbFieldType.O3)
    ..a<int>(4, 'int64FieldCount', $pb.PbFieldType.O3)
    ..a<int>(5, 'int64RepeatCount', $pb.PbFieldType.O3)
    ..a<int>(6, 'stringFieldCount', $pb.PbFieldType.O3)
    ..a<int>(7, 'stringRepeatCount', $pb.PbFieldType.O3)
    ..a<int>(8, 'stringSize', $pb.PbFieldType.O3)
    ..aOS(9, 'stringValue')
    ..hasRequiredFields = false
  ;

  Params() : super();
  Params.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Params.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Params clone() => new Params()..mergeFromMessage(this);
  Params copyWith(void Function(Params) updates) => super.copyWith((message) => updates(message as Params));
  $pb.BuilderInfo get info_ => _i;
  static Params create() => new Params();
  Params createEmptyInstance() => create();
  static $pb.PbList<Params> createRepeated() => new $pb.PbList<Params>();
  static Params getDefault() => _defaultInstance ??= create()..freeze();
  static Params _defaultInstance;
  static void $checkItem(Params v) {
    if (v is! Params) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get messageCount => $_get(0, 0);
  set messageCount(int v) { $_setSignedInt32(0, v); }
  bool hasMessageCount() => $_has(0);
  void clearMessageCount() => clearField(1);

  int get int32FieldCount => $_get(1, 0);
  set int32FieldCount(int v) { $_setSignedInt32(1, v); }
  bool hasInt32FieldCount() => $_has(1);
  void clearInt32FieldCount() => clearField(2);

  int get int32RepeatCount => $_get(2, 0);
  set int32RepeatCount(int v) { $_setSignedInt32(2, v); }
  bool hasInt32RepeatCount() => $_has(2);
  void clearInt32RepeatCount() => clearField(3);

  int get int64FieldCount => $_get(3, 0);
  set int64FieldCount(int v) { $_setSignedInt32(3, v); }
  bool hasInt64FieldCount() => $_has(3);
  void clearInt64FieldCount() => clearField(4);

  int get int64RepeatCount => $_get(4, 0);
  set int64RepeatCount(int v) { $_setSignedInt32(4, v); }
  bool hasInt64RepeatCount() => $_has(4);
  void clearInt64RepeatCount() => clearField(5);

  int get stringFieldCount => $_get(5, 0);
  set stringFieldCount(int v) { $_setSignedInt32(5, v); }
  bool hasStringFieldCount() => $_has(5);
  void clearStringFieldCount() => clearField(6);

  int get stringRepeatCount => $_get(6, 0);
  set stringRepeatCount(int v) { $_setSignedInt32(6, v); }
  bool hasStringRepeatCount() => $_has(6);
  void clearStringRepeatCount() => clearField(7);

  int get stringSize => $_get(7, 0);
  set stringSize(int v) { $_setSignedInt32(7, v); }
  bool hasStringSize() => $_has(7);
  void clearStringSize() => clearField(8);

  String get stringValue => $_getS(8, '');
  set stringValue(String v) { $_setString(8, v); }
  bool hasStringValue() => $_has(8);
  void clearStringValue() => clearField(9);
}

class Report extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Report', package: const $pb.PackageName('benchmark'))
    ..e<Status>(1, 'status', $pb.PbFieldType.OE, Status.RUNNING, Status.valueOf, Status.values)
    ..aOS(2, 'message')
    ..a<Env>(3, 'env', $pb.PbFieldType.OM, Env.getDefault, Env.create)
    ..pp<Response>(4, 'responses', $pb.PbFieldType.PM, Response.$checkItem, Response.create)
    ..hasRequiredFields = false
  ;

  Report() : super();
  Report.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Report.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Report clone() => new Report()..mergeFromMessage(this);
  Report copyWith(void Function(Report) updates) => super.copyWith((message) => updates(message as Report));
  $pb.BuilderInfo get info_ => _i;
  static Report create() => new Report();
  Report createEmptyInstance() => create();
  static $pb.PbList<Report> createRepeated() => new $pb.PbList<Report>();
  static Report getDefault() => _defaultInstance ??= create()..freeze();
  static Report _defaultInstance;
  static void $checkItem(Report v) {
    if (v is! Report) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Status get status => $_getN(0);
  set status(Status v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);

  String get message => $_getS(1, '');
  set message(String v) { $_setString(1, v); }
  bool hasMessage() => $_has(1);
  void clearMessage() => clearField(2);

  Env get env => $_getN(2);
  set env(Env v) { setField(3, v); }
  bool hasEnv() => $_has(2);
  void clearEnv() => clearField(3);

  List<Response> get responses => $_getList(3);
}

class Env extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Env', package: const $pb.PackageName('benchmark'))
    ..aOS(1, 'script')
    ..aOS(2, 'page')
    ..a<Platform>(10, 'platform', $pb.PbFieldType.OM, Platform.getDefault, Platform.create)
    ..a<Packages>(11, 'packages', $pb.PbFieldType.OM, Packages.getDefault, Packages.create)
    ..hasRequiredFields = false
  ;

  Env() : super();
  Env.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Env.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Env clone() => new Env()..mergeFromMessage(this);
  Env copyWith(void Function(Env) updates) => super.copyWith((message) => updates(message as Env));
  $pb.BuilderInfo get info_ => _i;
  static Env create() => new Env();
  Env createEmptyInstance() => create();
  static $pb.PbList<Env> createRepeated() => new $pb.PbList<Env>();
  static Env getDefault() => _defaultInstance ??= create()..freeze();
  static Env _defaultInstance;
  static void $checkItem(Env v) {
    if (v is! Env) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get script => $_getS(0, '');
  set script(String v) { $_setString(0, v); }
  bool hasScript() => $_has(0);
  void clearScript() => clearField(1);

  String get page => $_getS(1, '');
  set page(String v) { $_setString(1, v); }
  bool hasPage() => $_has(1);
  void clearPage() => clearField(2);

  Platform get platform => $_getN(2);
  set platform(Platform v) { setField(10, v); }
  bool hasPlatform() => $_has(2);
  void clearPlatform() => clearField(10);

  Packages get packages => $_getN(3);
  set packages(Packages v) { setField(11, v); }
  bool hasPackages() => $_has(3);
  void clearPackages() => clearField(11);
}

class Platform extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Platform', package: const $pb.PackageName('benchmark'))
    ..aOS(1, 'hostname')
    ..e<OSType>(2, 'osType', $pb.PbFieldType.OE, OSType.LINUX, OSType.valueOf, OSType.values)
    ..aOS(3, 'dartVersion')
    ..aOS(10, 'userAgent')
    ..aOB(20, 'checkedMode')
    ..aOB(21, 'dartVM')
    ..hasRequiredFields = false
  ;

  Platform() : super();
  Platform.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Platform.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Platform clone() => new Platform()..mergeFromMessage(this);
  Platform copyWith(void Function(Platform) updates) => super.copyWith((message) => updates(message as Platform));
  $pb.BuilderInfo get info_ => _i;
  static Platform create() => new Platform();
  Platform createEmptyInstance() => create();
  static $pb.PbList<Platform> createRepeated() => new $pb.PbList<Platform>();
  static Platform getDefault() => _defaultInstance ??= create()..freeze();
  static Platform _defaultInstance;
  static void $checkItem(Platform v) {
    if (v is! Platform) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get hostname => $_getS(0, '');
  set hostname(String v) { $_setString(0, v); }
  bool hasHostname() => $_has(0);
  void clearHostname() => clearField(1);

  OSType get osType => $_getN(1);
  set osType(OSType v) { setField(2, v); }
  bool hasOsType() => $_has(1);
  void clearOsType() => clearField(2);

  String get dartVersion => $_getS(2, '');
  set dartVersion(String v) { $_setString(2, v); }
  bool hasDartVersion() => $_has(2);
  void clearDartVersion() => clearField(3);

  String get userAgent => $_getS(3, '');
  set userAgent(String v) { $_setString(3, v); }
  bool hasUserAgent() => $_has(3);
  void clearUserAgent() => clearField(10);

  bool get checkedMode => $_get(4, false);
  set checkedMode(bool v) { $_setBool(4, v); }
  bool hasCheckedMode() => $_has(4);
  void clearCheckedMode() => clearField(20);

  bool get dartVM => $_get(5, false);
  set dartVM(bool v) { $_setBool(5, v); }
  bool hasDartVM() => $_has(5);
  void clearDartVM() => clearField(21);
}

class Packages extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Packages', package: const $pb.PackageName('benchmark'))
    ..aOS(1, 'version')
    ..pp<PackageVersion>(2, 'packages', $pb.PbFieldType.PM, PackageVersion.$checkItem, PackageVersion.create)
    ..hasRequiredFields = false
  ;

  Packages() : super();
  Packages.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Packages.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Packages clone() => new Packages()..mergeFromMessage(this);
  Packages copyWith(void Function(Packages) updates) => super.copyWith((message) => updates(message as Packages));
  $pb.BuilderInfo get info_ => _i;
  static Packages create() => new Packages();
  Packages createEmptyInstance() => create();
  static $pb.PbList<Packages> createRepeated() => new $pb.PbList<Packages>();
  static Packages getDefault() => _defaultInstance ??= create()..freeze();
  static Packages _defaultInstance;
  static void $checkItem(Packages v) {
    if (v is! Packages) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get version => $_getS(0, '');
  set version(String v) { $_setString(0, v); }
  bool hasVersion() => $_has(0);
  void clearVersion() => clearField(1);

  List<PackageVersion> get packages => $_getList(1);
}

class PackageVersion extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PackageVersion', package: const $pb.PackageName('benchmark'))
    ..aOS(1, 'name')
    ..aOS(2, 'source')
    ..aOS(3, 'version')
    ..aOS(4, 'path')
    ..hasRequiredFields = false
  ;

  PackageVersion() : super();
  PackageVersion.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PackageVersion.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PackageVersion clone() => new PackageVersion()..mergeFromMessage(this);
  PackageVersion copyWith(void Function(PackageVersion) updates) => super.copyWith((message) => updates(message as PackageVersion));
  $pb.BuilderInfo get info_ => _i;
  static PackageVersion create() => new PackageVersion();
  PackageVersion createEmptyInstance() => create();
  static $pb.PbList<PackageVersion> createRepeated() => new $pb.PbList<PackageVersion>();
  static PackageVersion getDefault() => _defaultInstance ??= create()..freeze();
  static PackageVersion _defaultInstance;
  static void $checkItem(PackageVersion v) {
    if (v is! PackageVersion) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) { $_setString(0, v); }
  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get source => $_getS(1, '');
  set source(String v) { $_setString(1, v); }
  bool hasSource() => $_has(1);
  void clearSource() => clearField(2);

  String get version => $_getS(2, '');
  set version(String v) { $_setString(2, v); }
  bool hasVersion() => $_has(2);
  void clearVersion() => clearField(3);

  String get path => $_getS(3, '');
  set path(String v) { $_setString(3, v); }
  bool hasPath() => $_has(3);
  void clearPath() => clearField(4);
}

class Response extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Response', package: const $pb.PackageName('benchmark'))
    ..a<Request>(1, 'request', $pb.PbFieldType.OM, Request.getDefault, Request.create)
    ..pp<Sample>(2, 'samples', $pb.PbFieldType.PM, Sample.$checkItem, Sample.create)
    ..hasRequiredFields = false
  ;

  Response() : super();
  Response.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Response.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Response clone() => new Response()..mergeFromMessage(this);
  Response copyWith(void Function(Response) updates) => super.copyWith((message) => updates(message as Response));
  $pb.BuilderInfo get info_ => _i;
  static Response create() => new Response();
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => new $pb.PbList<Response>();
  static Response getDefault() => _defaultInstance ??= create()..freeze();
  static Response _defaultInstance;
  static void $checkItem(Response v) {
    if (v is! Response) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  Request get request => $_getN(0);
  set request(Request v) { setField(1, v); }
  bool hasRequest() => $_has(0);
  void clearRequest() => clearField(1);

  List<Sample> get samples => $_getList(1);
}

class Sample extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Sample', package: const $pb.PackageName('benchmark'))
    ..a<int>(1, 'duration', $pb.PbFieldType.O3)
    ..a<int>(2, 'loopCount', $pb.PbFieldType.O3)
    ..a<Counts>(3, 'counts', $pb.PbFieldType.OM, Counts.getDefault, Counts.create)
    ..hasRequiredFields = false
  ;

  Sample() : super();
  Sample.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Sample.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Sample clone() => new Sample()..mergeFromMessage(this);
  Sample copyWith(void Function(Sample) updates) => super.copyWith((message) => updates(message as Sample));
  $pb.BuilderInfo get info_ => _i;
  static Sample create() => new Sample();
  Sample createEmptyInstance() => create();
  static $pb.PbList<Sample> createRepeated() => new $pb.PbList<Sample>();
  static Sample getDefault() => _defaultInstance ??= create()..freeze();
  static Sample _defaultInstance;
  static void $checkItem(Sample v) {
    if (v is! Sample) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get duration => $_get(0, 0);
  set duration(int v) { $_setSignedInt32(0, v); }
  bool hasDuration() => $_has(0);
  void clearDuration() => clearField(1);

  int get loopCount => $_get(1, 0);
  set loopCount(int v) { $_setSignedInt32(1, v); }
  bool hasLoopCount() => $_has(1);
  void clearLoopCount() => clearField(2);

  Counts get counts => $_getN(2);
  set counts(Counts v) { setField(3, v); }
  bool hasCounts() => $_has(2);
  void clearCounts() => clearField(3);
}

class Counts extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Counts', package: const $pb.PackageName('benchmark'))
    ..a<int>(1, 'int32Reads', $pb.PbFieldType.O3)
    ..a<int>(2, 'int64Reads', $pb.PbFieldType.O3)
    ..a<int>(4, 'stringReads', $pb.PbFieldType.O3)
    ..a<int>(5, 'stringWrites', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Counts() : super();
  Counts.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Counts.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Counts clone() => new Counts()..mergeFromMessage(this);
  Counts copyWith(void Function(Counts) updates) => super.copyWith((message) => updates(message as Counts));
  $pb.BuilderInfo get info_ => _i;
  static Counts create() => new Counts();
  Counts createEmptyInstance() => create();
  static $pb.PbList<Counts> createRepeated() => new $pb.PbList<Counts>();
  static Counts getDefault() => _defaultInstance ??= create()..freeze();
  static Counts _defaultInstance;
  static void $checkItem(Counts v) {
    if (v is! Counts) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get int32Reads => $_get(0, 0);
  set int32Reads(int v) { $_setSignedInt32(0, v); }
  bool hasInt32Reads() => $_has(0);
  void clearInt32Reads() => clearField(1);

  int get int64Reads => $_get(1, 0);
  set int64Reads(int v) { $_setSignedInt32(1, v); }
  bool hasInt64Reads() => $_has(1);
  void clearInt64Reads() => clearField(2);

  int get stringReads => $_get(2, 0);
  set stringReads(int v) { $_setSignedInt32(2, v); }
  bool hasStringReads() => $_has(2);
  void clearStringReads() => clearField(4);

  int get stringWrites => $_get(3, 0);
  set stringWrites(int v) { $_setSignedInt32(3, v); }
  bool hasStringWrites() => $_has(3);
  void clearStringWrites() => clearField(5);
}

