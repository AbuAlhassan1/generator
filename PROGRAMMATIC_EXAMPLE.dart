import 'package:dart_openapi_generator/dart_openapi_generator.dart';

/// Example of using the OpenAPI Generator programmatically
void main() async {
  final generator = OpenApiGenerator();
  
  try {
    // Generate from URL
    await generator.generate(
      'https://petstore3.swagger.io/api/v3/openapi.json',
      'lib/models/generated',
    );
    print('✅ Models generated successfully!');
  } catch (e) {
    print('❌ Error: $e');
  }
}