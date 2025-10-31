class PhoneNumber extends $pb.GeneratedMessage {
  factory PhoneNumber() => create();

  PhoneNumber._();

  factory PhoneNumber.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory PhoneNumber.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PhoneNumber', createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'number')
    ..aE<PhoneNumber_PhoneType>(2, _omitFieldNames ? '' : 'type', enumValues: PhoneNumber_PhoneType.values)
    ..a<$core.String>(3, _omitFieldNames ? '' : 'name', $pb.PbFieldType.OS, defaultOrMaker: '\$')
    ..aOS(4, _omitFieldNames ? '' : 'deprecatedField')
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneNumber clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneNumber copyWith(void Function(PhoneNumber) updates) => super.copyWith((message) => updates(message as PhoneNumber)) as PhoneNumber;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneNumber create() => PhoneNumber._();
  @$core.override
  PhoneNumber createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PhoneNumber getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhoneNumber>(create);
  static PhoneNumber? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  PhoneNumber_PhoneType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(PhoneNumber_PhoneType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getS(2, '\$');
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(4)
  $core.String get deprecatedField => $_getSZ(3);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(4)
  set deprecatedField($core.String value) => $_setString(3, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(4)
  $core.bool hasDeprecatedField() => $_has(3);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(4)
  void clearDeprecatedField() => $_clearField(4);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
