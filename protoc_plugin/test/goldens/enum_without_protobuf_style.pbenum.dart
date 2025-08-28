class PhoneType extends $pb.ProtobufEnum {
  static const PhoneType PHONE_TYPE_UNSPECIFIED = PhoneType._(0, _omitEnumNames ? '' : 'PHONE_TYPE_UNSPECIFIED');
  static const PhoneType PHONE_TYPE_MOBILE = PhoneType._(1, _omitEnumNames ? '' : 'PHONE_TYPE_MOBILE');

  static const $core.List<PhoneType> values = <PhoneType> [
    PHONE_TYPE_UNSPECIFIED,
    PHONE_TYPE_MOBILE,
  ];

  static final $core.List<PhoneType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PhoneType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PhoneType._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
