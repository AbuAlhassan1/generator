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
    
    // Generate individual model files
    for (final entry in schemas.entries) {
      final className = entry.key;
      final schema = entry.value;
      
      await _generateModelFile(className, schema);
    }

    // Generate barrel file
    await _generateBarrelFile(schemas.keys.toList());
  }

  Future<void> _generateModelFile(String className, Schema schema) async {
    final fileName = '${className.snakeCase}.dart';
    final filePath = path.join(outputDir, fileName);
    
    final content = _generateModelClass(className, schema);
    
    final file = File(filePath);
    await file.writeAsString(content);
    print('Generated: $fileName');
  }

  String _generateModelClass(String className, Schema schema) {
    final buffer = StringBuffer();
    
    // Import statements
    buffer.writeln("import 'package:json_annotation/json_annotation.dart';");
    buffer.writeln();
    buffer.writeln("part '${className.snakeCase}.g.dart';");
    buffer.writeln();
    
    // Class declaration
    buffer.writeln('@JsonSerializable()');
    buffer.writeln('class $className {');
    
    // Properties
    if (schema.properties != null) {
      for (final entry in schema.properties!.entries) {
        final propertyName = entry.key;
        final propertySchema = entry.value;
        final isRequired = schema.isFieldRequired(propertyName);
        final dartType = propertySchema.getDartType();
        final nullableType = isRequired ? dartType : '$dartType?';
        
        // Add property documentation if available
        if (propertySchema.description != null) {
          buffer.writeln('  /// ${propertySchema.description}');
        }
        
        buffer.writeln('  final $nullableType $propertyName;');
        buffer.writeln();
      }
    }
    
    // Constructor
    buffer.writeln('  $className({');
    if (schema.properties != null) {
      for (final entry in schema.properties!.entries) {
        final propertyName = entry.key;
        final isRequired = schema.isFieldRequired(propertyName);
        
        if (isRequired) {
          buffer.writeln('    required this.$propertyName,');
        } else {
          buffer.writeln('    this.$propertyName,');
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
}