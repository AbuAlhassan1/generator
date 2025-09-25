// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiSpec _$OpenApiSpecFromJson(Map<String, dynamic> json) => OpenApiSpec(
  openapi: json['openapi'] as String,
  info: Info.fromJson(json['info'] as Map<String, dynamic>),
  paths: (json['paths'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, PathItem.fromJson(e as Map<String, dynamic>)),
  ),
  components: json['components'] == null
      ? null
      : Components.fromJson(json['components'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OpenApiSpecToJson(OpenApiSpec instance) =>
    <String, dynamic>{
      'openapi': instance.openapi,
      'info': instance.info,
      'paths': instance.paths,
      'components': instance.components,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
  title: json['title'] as String,
  version: json['version'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
  'title': instance.title,
  'version': instance.version,
  'description': instance.description,
};

PathItem _$PathItemFromJson(Map<String, dynamic> json) => PathItem(
  get: json['get'] == null
      ? null
      : Operation.fromJson(json['get'] as Map<String, dynamic>),
  post: json['post'] == null
      ? null
      : Operation.fromJson(json['post'] as Map<String, dynamic>),
  put: json['put'] == null
      ? null
      : Operation.fromJson(json['put'] as Map<String, dynamic>),
  delete: json['delete'] == null
      ? null
      : Operation.fromJson(json['delete'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PathItemToJson(PathItem instance) => <String, dynamic>{
  'get': instance.get,
  'post': instance.post,
  'put': instance.put,
  'delete': instance.delete,
};

Operation _$OperationFromJson(Map<String, dynamic> json) => Operation(
  operationId: json['operationId'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  summary: json['summary'] as String?,
  description: json['description'] as String?,
  parameters: (json['parameters'] as List<dynamic>?)
      ?.map((e) => Parameter.fromJson(e as Map<String, dynamic>))
      .toList(),
  requestBody: json['requestBody'] == null
      ? null
      : RequestBody.fromJson(json['requestBody'] as Map<String, dynamic>),
  responses: (json['responses'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Response.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$OperationToJson(Operation instance) => <String, dynamic>{
  'operationId': instance.operationId,
  'tags': instance.tags,
  'summary': instance.summary,
  'description': instance.description,
  'parameters': instance.parameters,
  'requestBody': instance.requestBody,
  'responses': instance.responses,
};

Parameter _$ParameterFromJson(Map<String, dynamic> json) => Parameter(
  name: json['name'] as String,
  in_: json['in'] as String,
  required: json['required'] as bool?,
  schema: json['schema'] == null
      ? null
      : Schema.fromJson(json['schema'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ParameterToJson(Parameter instance) => <String, dynamic>{
  'name': instance.name,
  'in': instance.in_,
  'required': instance.required,
  'schema': instance.schema,
};

RequestBody _$RequestBodyFromJson(Map<String, dynamic> json) => RequestBody(
  content: (json['content'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, MediaType.fromJson(e as Map<String, dynamic>)),
  ),
  required: json['required'] as bool?,
);

Map<String, dynamic> _$RequestBodyToJson(RequestBody instance) =>
    <String, dynamic>{
      'content': instance.content,
      'required': instance.required,
    };

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
  description: json['description'] as String,
  content: (json['content'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, MediaType.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
  'description': instance.description,
  'content': instance.content,
};

MediaType _$MediaTypeFromJson(Map<String, dynamic> json) => MediaType(
  schema: json['schema'] == null
      ? null
      : Schema.fromJson(json['schema'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MediaTypeToJson(MediaType instance) => <String, dynamic>{
  'schema': instance.schema,
};

Components _$ComponentsFromJson(Map<String, dynamic> json) => Components(
  schemas: (json['schemas'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Schema.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$ComponentsToJson(Components instance) =>
    <String, dynamic>{'schemas': instance.schemas};
