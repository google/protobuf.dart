class HTTPStatusCode extends $pb.ProtobufEnum {
  static const HTTPStatusCode unspecified = HTTPStatusCode._(0, _omitEnumNames ? '' : 'HTTP_STATUS_CODE_UNSPECIFIED');
  static const HTTPStatusCode notFound = HTTPStatusCode._(1, _omitEnumNames ? '' : 'HTTP_STATUS_CODE_NOT_FOUND');
  static const HTTPStatusCode internalServerError = HTTPStatusCode._(2, _omitEnumNames ? '' : 'HTTP_STATUS_CODE_INTERNAL_SERVER_ERROR');
  static const HTTPStatusCode ok = HTTPStatusCode._(3, _omitEnumNames ? '' : 'HTTP_STATUS_CODE_OK');

  static const $core.List<HTTPStatusCode> values = <HTTPStatusCode> [
    unspecified,
    notFound,
    internalServerError,
    ok,
  ];

  static final $core.List<HTTPStatusCode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static HTTPStatusCode? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HTTPStatusCode._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
