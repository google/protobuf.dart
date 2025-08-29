class PhoneType extends $pb.ProtobufEnum {
  static const PhoneType unspecified = PhoneType._(0, _omitEnumNames ? '' : 'PHONE_TYPE_UNSPECIFIED');
  static const PhoneType mobile = PhoneType._(1, _omitEnumNames ? '' : 'PHONE_TYPE_MOBILE');
  static const PhoneType home = PhoneType._(2, _omitEnumNames ? '' : 'PHONE_TYPE_HOME');
  static const PhoneType work = PhoneType._(3, _omitEnumNames ? '' : 'PHONE_TYPE_WORK');

  static const $core.List<PhoneType> values = <PhoneType> [
    unspecified,
    mobile,
    home,
    work,
  ];

  static final $core.List<PhoneType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PhoneType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PhoneType._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
