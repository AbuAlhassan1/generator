// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schema _$SchemaFromJson(Map<String, dynamic> json) => Schema(
  type: json['type'] as String?,
  format: json['format'] as String?,
  description: json['description'] as String?,
  properties: (json['properties'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Schema.fromJson(e as Map<String, dynamic>)),
  ),
  required: (json['required'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  items: json['items'] == null
      ? null
      : Schema.fromJson(json['items'] as Map<String, dynamic>),
  enum_: json['enum_'] as List<dynamic>?,
  ref: json[r'$ref'] as String?,
  nullable: json['nullable'] as bool?,
  example: json['example'],
  additionalProperties: const AdditionalPropertiesConverter().fromJson(
    json['additionalProperties'],
  ),
  allOf: (json['allOf'] as List<dynamic>?)
      ?.map((e) => Schema.fromJson(e as Map<String, dynamic>))
      .toList(),
  oneOf: (json['oneOf'] as List<dynamic>?)
      ?.map((e) => Schema.fromJson(e as Map<String, dynamic>))
      .toList(),
  anyOf: (json['anyOf'] as List<dynamic>?)
      ?.map((e) => Schema.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SchemaToJson(Schema instance) => <String, dynamic>{
  'type': instance.type,
  'format': instance.format,
  'description': instance.description,
  'properties': instance.properties,
  'required': instance.required,
  'items': instance.items,
  'enum_': instance.enum_,
  r'$ref': instance.ref,
  'nullable': instance.nullable,
  'example': instance.example,
  'additionalProperties': const AdditionalPropertiesConverter().toJson(
    instance.additionalProperties,
  ),
  'allOf': instance.allOf,
  'oneOf': instance.oneOf,
  'anyOf': instance.anyOf,
};
