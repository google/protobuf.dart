class PhoneType extends $pb.ProtobufEnum {
  static const PhoneType MOBILE = PhoneType._(0, _omitEnumNames ? '' : 'MOBILE');
  static const PhoneType HOME = PhoneType._(1, _omitEnumNames ? '' : 'HOME');
  static const PhoneType WORK = PhoneType._(2, _omitEnumNames ? '' : 'WORK');

  static const PhoneType BUSINESS = WORK;

  static const $core.List<PhoneType> values = <PhoneType> [
    MOBILE,
    HOME,
    WORK,
  ];

  static final $core.List<PhoneType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PhoneType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PhoneType._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
