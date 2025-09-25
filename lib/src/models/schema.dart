import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

/// Converter to handle additionalProperties which can be either bool or Schema
class AdditionalPropertiesConverter implements JsonConverter<dynamic, dynamic> {
  const AdditionalPropertiesConverter();

  @override
  dynamic fromJson(dynamic json) {
    if (json is bool) {
      return json;
    } else if (json is Map<String, dynamic>) {
      return Schema.fromJson(json);
    }
    return null;
  }

  @override
  dynamic toJson(dynamic object) {
    if (object is bool) {
      return object;
    } else if (object is Schema) {
      return object.toJson();
    }
    return null;
  }
}

@JsonSerializable()
class Schema {
  final String? type;
  final String? format;
  final String? description;
  final Map<String, Schema>? properties;
  final List<String>? required;
  final Schema? items;
  final List<dynamic>? enum_;
  @JsonKey(name: '\$ref')
  final String? ref;
  final bool? nullable;
  final dynamic example;
  @AdditionalPropertiesConverter()
  final dynamic additionalProperties; // Can be bool or Schema
  final List<Schema>? allOf;
  final List<Schema>? oneOf;
  final List<Schema>? anyOf;

  Schema({
    this.type,
    this.format,
    this.description,
    this.properties,
    this.required,
    this.items,
    this.enum_,
    this.ref,
    this.nullable,
    this.example,
    this.additionalProperties,
    this.allOf,
    this.oneOf,
    this.anyOf,
  });

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);
  Map<String, dynamic> toJson() => _$SchemaToJson(this);

  /// Get the Dart type name for this schema
  String getDartType() {
    if (ref != null) {
      // Extract class name from reference like "#/components/schemas/User"
      final parts = ref!.split('/');
      return parts.last;
    }

    switch (type) {
      case 'string':
        return 'String';
      case 'integer':
        return format == 'int64' ? 'int' : 'int';
      case 'number':
        return format == 'float' ? 'double' : 'double';
      case 'boolean':
        return 'bool';
      case 'array':
        if (items != null) {
          return 'List<${items!.getDartType()}>';
        }
        return 'List<dynamic>';
      case 'object':
        return 'Map<String, dynamic>';
      default:
        return 'dynamic';
    }
  }

  /// Check if this schema represents a primitive type
  bool get isPrimitive {
    return ['string', 'integer', 'number', 'boolean'].contains(type);
  }

  /// Check if this is a reference to another schema
  bool get isReference => ref != null;

  /// Check if this is an array type
  bool get isArray => type == 'array';

  /// Check if this is an object type
  bool get isObject => type == 'object' && properties != null;

  /// Check if this field is required
  bool isFieldRequired(String fieldName) {
    return required?.contains(fieldName) ?? false;
  }
}