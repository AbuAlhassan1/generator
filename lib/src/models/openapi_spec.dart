import 'package:json_annotation/json_annotation.dart';
import 'schema.dart';

part 'openapi_spec.g.dart';

@JsonSerializable()
class OpenApiSpec {
  final String openapi;
  final Info info;
  final Map<String, PathItem>? paths;
  final Components? components;

  OpenApiSpec({
    required this.openapi,
    required this.info,
    this.paths,
    this.components,
  });

  factory OpenApiSpec.fromJson(Map<String, dynamic> json) =>
      _$OpenApiSpecFromJson(json);

  Map<String, dynamic> toJson() => _$OpenApiSpecToJson(this);
}

@JsonSerializable()
class Info {
  final String title;
  final String version;
  final String? description;

  Info({
    required this.title,
    required this.version,
    this.description,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class PathItem {
  final Operation? get;
  final Operation? post;
  final Operation? put;
  final Operation? delete;

  PathItem({this.get, this.post, this.put, this.delete});

  factory PathItem.fromJson(Map<String, dynamic> json) =>
      _$PathItemFromJson(json);
  Map<String, dynamic> toJson() => _$PathItemToJson(this);
}

@JsonSerializable()
class Operation {
  final String? operationId;
  final List<String>? tags;
  final String? summary;
  final String? description;
  final List<Parameter>? parameters;
  final RequestBody? requestBody;
  final Map<String, Response>? responses;

  Operation({
    this.operationId,
    this.tags,
    this.summary,
    this.description,
    this.parameters,
    this.requestBody,
    this.responses,
  });

  factory Operation.fromJson(Map<String, dynamic> json) =>
      _$OperationFromJson(json);
  Map<String, dynamic> toJson() => _$OperationToJson(this);
}

@JsonSerializable()
class Parameter {
  final String name;
  @JsonKey(name: 'in')
  final String in_;
  final bool? required;
  final Schema? schema;

  Parameter({
    required this.name,
    required this.in_,
    this.required,
    this.schema,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) =>
      _$ParameterFromJson(json);
  Map<String, dynamic> toJson() => _$ParameterToJson(this);
}

@JsonSerializable()
class RequestBody {
  final Map<String, MediaType>? content;
  final bool? required;

  RequestBody({this.content, this.required});

  factory RequestBody.fromJson(Map<String, dynamic> json) =>
      _$RequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$RequestBodyToJson(this);
}

@JsonSerializable()
class Response {
  final String description;
  final Map<String, MediaType>? content;

  Response({required this.description, this.content});

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}

@JsonSerializable()
class MediaType {
  final Schema? schema;

  MediaType({this.schema});

  factory MediaType.fromJson(Map<String, dynamic> json) =>
      _$MediaTypeFromJson(json);
  Map<String, dynamic> toJson() => _$MediaTypeToJson(this);
}

@JsonSerializable()
class Components {
  final Map<String, Schema>? schemas;

  Components({this.schemas});

  factory Components.fromJson(Map<String, dynamic> json) =>
      _$ComponentsFromJson(json);
  Map<String, dynamic> toJson() => _$ComponentsToJson(this);
}