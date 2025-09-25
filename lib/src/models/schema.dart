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
      final typeName = _sanitizeClassName(parts.last);
      
      // Check if this would create an invalid type name
      if (typeName.isEmpty || typeName == 'InvalidType') {
        return 'dynamic';
      }
      
      return typeName;
    }

    // Handle enums
    if (enum_ != null && enum_!.isNotEmpty) {
      // This is an enum type, we'll generate a proper enum class
      return 'String'; // For now, treat enums as strings in the model
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
          final itemType = items!.getDartType();
          // Avoid nested InvalidType
          if (itemType.contains('InvalidType') || itemType.isEmpty) {
            return 'List<dynamic>';
          }
          return 'List<$itemType>';
        }
        return 'List<dynamic>';
      case 'object':
        return 'Map<String, dynamic>';
      default:
        // Handle null or unknown types
        if (type == null || type?.trim().isEmpty == true) {
          return 'dynamic';
        }
        // Fallback for any unhandled type
        return 'dynamic';
    }
  }

  /// Sanitize class name to be valid Dart identifier
  String _sanitizeClassName(String name) {
    // Handle very long complex names by shortening them
    if (name.length > 100) {
      // Take last meaningful part after double underscore
      final parts = name.split('__');
      name = parts.isNotEmpty ? parts.last : name.substring(name.length - 50);
    }
    
    // Remove invalid characters and ensure it starts with a letter
    String sanitized = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    
    // Ensure it starts with a letter
    if (sanitized.isNotEmpty && !RegExp(r'^[a-zA-Z]').hasMatch(sanitized)) {
      sanitized = 'C$sanitized';
    }
    
    // If empty after sanitization, provide a default
    if (sanitized.isEmpty) {
      sanitized = 'GeneratedClass';
    }
    
    return sanitized;
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

  /// Check if this schema represents an enum
  bool get isEnum => enum_ != null && enum_!.isNotEmpty;

  /// Get enum values as strings
  List<String> get enumValues {
    if (!isEnum) return [];
    return enum_!.map((e) => e.toString()).toList();
  }

  /// Check if this schema is valid for code generation
  bool get isValidForGeneration {
    // Skip schemas that would generate invalid class names
    if (ref != null) {
      final parts = ref!.split('/');
      final className = parts.last;
      return _isValidClassName(className);
    }
    return true;
  }

  /// Check if a class name is valid for Dart
  bool _isValidClassName(String name) {
    // Must start with letter or underscore
    // Can contain letters, numbers, underscores
    // Cannot be empty
    return name.isNotEmpty && 
           RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name) &&
           !_isDartKeyword(name);
  }

  /// Check if name is a Dart keyword
  bool _isDartKeyword(String name) {
    const keywords = {
      'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch',
      'class', 'const', 'continue', 'default', 'deferred', 'do', 'dynamic',
      'else', 'enum', 'export', 'extends', 'external', 'factory', 'false',
      'final', 'finally', 'for', 'function', 'get', 'hide', 'if', 'implements',
      'import', 'in', 'interface', 'is', 'library', 'mixin', 'new', 'null',
      'on', 'operator', 'part', 'rethrow', 'return', 'set', 'show', 'static',
      'super', 'switch', 'sync', 'this', 'throw', 'true', 'try', 'typedef',
      'var', 'void', 'while', 'with', 'yield'
    };
    return keywords.contains(name.toLowerCase());
  }
}