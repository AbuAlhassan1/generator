import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'models/openapi_spec.dart';
import 'code_generator.dart';

class OpenApiGenerator {
  Future<void> generate(String input, String outputDir) async {
    String jsonString;
    
    // Check if input is a URL or file path
    if (_isUrl(input)) {
      print('Fetching OpenAPI specification from: $input');
      jsonString = await _fetchFromUrl(input);
    } else {
      // Read from local file
      final file = File(input);
      if (!await file.exists()) {
        throw Exception('Input file does not exist: $input');
      }
      jsonString = await file.readAsString();
    }

    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    
    // Parse OpenAPI specification
    final spec = OpenApiSpec.fromJson(jsonData);
    
    // Create output directory
    final outputDirectory = Directory(outputDir);
    if (!await outputDirectory.exists()) {
      await outputDirectory.create(recursive: true);
    }

    // Generate Dart models
    final codeGenerator = CodeGenerator(outputDir);
    await codeGenerator.generateModels(spec);
    
    print('Generated models in: ${path.absolute(outputDir)}');
  }

  /// Check if the input string is a URL
  bool _isUrl(String input) {
    return input.toLowerCase().startsWith('http://') || 
           input.toLowerCase().startsWith('https://');
  }

  /// Fetch OpenAPI specification from URL
  Future<String> _fetchFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to fetch from URL: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching from URL: $e');
    }
  }
}