class PhoneNumber_PhoneType extends $pb.ProtobufEnum {
  static const PhoneNumber_PhoneType MOBILE =
      PhoneNumber_PhoneType._(0, _omitEnumNames ? '' : 'MOBILE');
  static const PhoneNumber_PhoneType HOME =
      PhoneNumber_PhoneType._(1, _omitEnumNames ? '' : 'HOME');
  static const PhoneNumber_PhoneType WORK =
      PhoneNumber_PhoneType._(2, _omitEnumNames ? '' : 'WORK');

  static const PhoneNumber_PhoneType BUSINESS = WORK;

  static const $core.List<PhoneNumber_PhoneType> values =
      <PhoneNumber_PhoneType>[
    MOBILE,
    HOME,
    WORK,
  ];

  static final $core.List<PhoneNumber_PhoneType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PhoneNumber_PhoneType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PhoneNumber_PhoneType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
