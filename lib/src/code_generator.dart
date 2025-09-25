import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'models/openapi_spec.dart';
import 'models/schema.dart';

class CodeGenerator {
  final String outputDir;

  CodeGenerator(this.outputDir);

  Future<void> generateModels(OpenApiSpec spec) async {
    if (spec.components?.schemas == null) {
      print('No schemas found in the OpenAPI specification');
      return;
    }

    final schemas = spec.components!.schemas!;
    final validClassNames = <String>[];
    
    // Generate individual model files
    for (final entry in schemas.entries) {
      final className = entry.key;
      final schema = entry.value;
      
      // Skip invalid schemas
      if (!schema.isValidForGeneration) {
        print('Skipping invalid schema: $className');
        continue;
      }
      
      final sanitizedClassName = _sanitizeClassName(className);
      
      try {
        if (schema.isEnum) {
          await _generateEnumFile(sanitizedClassName, schema);
        } else {
          await _generateModelFile(sanitizedClassName, schema);
        }
        validClassNames.add(sanitizedClassName);
      } catch (e) {
        print('Error generating $className: $e');
        continue;
      }
    }

    // Generate barrel file
    await _generateBarrelFile(validClassNames);
  }

  Future<void> _generateModelFile(String className, Schema schema) async {
    final fileName = '${className.snakeCase}.dart';
    final filePath = path.join(outputDir, fileName);
    
    final content = _generateModelClass(className, schema);
    
    final file = File(filePath);
    await file.writeAsString(content);
    print('Generated: $fileName');
  }

  Future<void> _generateEnumFile(String enumName, Schema schema) async {
    final fileName = '${enumName.snakeCase}.dart';
    final filePath = path.join(outputDir, fileName);
    
    final content = _generateEnumClass(enumName, schema);
    
    final file = File(filePath);
    await file.writeAsString(content);
    print('Generated: $fileName');
  }

  /// Sanitize class name to be valid Dart identifier
  String _sanitizeClassName(String name) {
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

  String _generateEnumClass(String enumName, Schema schema) {
    final buffer = StringBuffer();
    
    // Add documentation if available
    if (schema.description != null) {
      buffer.writeln('/// ${schema.description}');
    }
    
    buffer.writeln('enum $enumName {');
    
    final enumValues = schema.enumValues;
    for (int i = 0; i < enumValues.length; i++) {
      final value = enumValues[i];
      final enumValueName = _sanitizeEnumValue(value);
      
      buffer.write('  @JsonValue(\'$value\')');
      buffer.write(' $enumValueName');
      
      if (i < enumValues.length - 1) {
        buffer.writeln(',');
      } else {
        buffer.writeln('');
      }
    }
    
    buffer.writeln('}');
    
    return buffer.toString();
  }

  /// Sanitize enum value to be valid Dart identifier
  String _sanitizeEnumValue(String value) {
    // Convert to camelCase and remove invalid characters
    String sanitized = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    
    // Ensure it starts with a letter
    if (sanitized.isNotEmpty && !RegExp(r'^[a-zA-Z]').hasMatch(sanitized)) {
      sanitized = 'value_$sanitized';
    }
    
    // If empty after sanitization, provide a default
    if (sanitized.isEmpty) {
      sanitized = 'unknown';
    }
    
    return sanitized;
  }

  String _generateModelClass(String className, Schema schema) {
    final buffer = StringBuffer();
    
    // Import statements
    buffer.writeln("import 'package:json_annotation/json_annotation.dart';");
    buffer.writeln();
    buffer.writeln("part '${className.snakeCase}.g.dart';");
    buffer.writeln();
    
    // Add class documentation if available
    if (schema.description != null) {
      buffer.writeln('/// ${schema.description}');
    }
    
    // Class declaration
    buffer.writeln('@JsonSerializable()');
    buffer.writeln('class $className {');
    
    // Properties
    if (schema.properties != null && schema.properties!.isNotEmpty) {
      for (final entry in schema.properties!.entries) {
        final propertyName = entry.key;
        final propertySchema = entry.value;
        final isRequired = schema.isFieldRequired(propertyName);
        
        // Skip properties that would cause issues
        if (!_isValidPropertyName(propertyName)) {
          print('  Skipping invalid property name: $propertyName');
          continue;
        }
        
        final dartType = propertySchema.getDartType();
        final nullableType = isRequired ? dartType : '$dartType?';
        
        // Add property documentation if available
        if (propertySchema.description != null) {
          buffer.writeln('  /// ${propertySchema.description}');
        }
        
        // Add JsonKey annotation if property name needs mapping
        final jsonKey = _getJsonKeyAnnotation(propertyName);
        if (jsonKey.isNotEmpty) {
          buffer.writeln('  $jsonKey');
        }
        
        buffer.writeln('  final $nullableType ${_sanitizePropertyName(propertyName)};');
        buffer.writeln();
      }
    } else {
      // If no properties, add a comment
      buffer.writeln('  // No properties defined in schema');
      buffer.writeln();
    }
    
    // Constructor
    buffer.writeln('  $className({');
    if (schema.properties != null && schema.properties!.isNotEmpty) {
      for (final entry in schema.properties!.entries) {
        final propertyName = entry.key;
        final isRequired = schema.isFieldRequired(propertyName);
        
        // Skip invalid properties
        if (!_isValidPropertyName(propertyName)) {
          continue;
        }
        
        final sanitizedName = _sanitizePropertyName(propertyName);
        
        if (isRequired) {
          buffer.writeln('    required this.$sanitizedName,');
        } else {
          buffer.writeln('    this.$sanitizedName,');
        }
      }
    }
    buffer.writeln('  });');
    buffer.writeln();
    
    // fromJson factory
    buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) =>');
    buffer.writeln('      _\$${className}FromJson(json);');
    buffer.writeln();
    
    // toJson method
    buffer.writeln('  Map<String, dynamic> toJson() => _\$${className}ToJson(this);');
    
    buffer.writeln('}');
    
    return buffer.toString();
  }

  Future<void> _generateBarrelFile(List<String> classNames) async {
    final filePath = path.join(outputDir, 'models.dart');
    final buffer = StringBuffer();
    
    buffer.writeln('// Generated barrel file for OpenAPI models');
    buffer.writeln();
    
    for (final className in classNames) {
      buffer.writeln("export '${className.snakeCase}.dart';");
    }
    
    final file = File(filePath);
    await file.writeAsString(buffer.toString());
    print('Generated: models.dart (barrel file)');
  }

  /// Check if property name is valid for Dart
  bool _isValidPropertyName(String name) {
    return name.isNotEmpty && 
           !_isDartKeyword(name) &&
           RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name);
  }

  /// Sanitize property name to be valid Dart identifier
  String _sanitizePropertyName(String name) {
    // If already valid, return as-is
    if (_isValidPropertyName(name)) {
      return name;
    }
    
    // Replace invalid characters with underscores
    String sanitized = name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    
    // Ensure it starts with a letter or underscore
    if (sanitized.isNotEmpty && !RegExp(r'^[a-zA-Z_]').hasMatch(sanitized)) {
      sanitized = '_$sanitized';
    }
    
    // If empty or keyword, prefix with underscore
    if (sanitized.isEmpty || _isDartKeyword(sanitized)) {
      sanitized = '_$sanitized';
    }
    
    return sanitized.isEmpty ? '_property' : sanitized;
  }

  /// Get JsonKey annotation if property name needs mapping
  String _getJsonKeyAnnotation(String originalName) {
    final sanitizedName = _sanitizePropertyName(originalName);
    
    // If names are different, we need JsonKey annotation
    if (originalName != sanitizedName) {
      return '@JsonKey(name: \'$originalName\')';
    }
    
    return '';
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