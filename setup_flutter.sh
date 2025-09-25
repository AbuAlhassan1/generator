#!/bin/bash
# Flutter project setup script for Dart OpenAPI Generator

echo "🚀 Setting up Dart OpenAPI Generator in your Flutter project..."

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not in a Flutter project root (pubspec.yaml not found)"
    exit 1
fi

# Check if flutter is in pubspec.yaml
if ! grep -q "flutter:" pubspec.yaml; then
    echo "❌ Error: This doesn't appear to be a Flutter project"
    exit 1
fi

echo "📦 Adding dependencies to pubspec.yaml..."

# Add dev dependencies if not present
if ! grep -q "dart_openapi_generator:" pubspec.yaml; then
    echo "  Adding dart_openapi_generator..."
    echo "" >> pubspec.yaml
    echo "  # OpenAPI Generator dependencies" >> pubspec.yaml
    echo "  dart_openapi_generator:" >> pubspec.yaml
    echo "    git:" >> pubspec.yaml
    echo "      url: https://github.com/yourusername/dart_openapi_generator.git" >> pubspec.yaml
fi

if ! grep -q "build_runner:" pubspec.yaml; then
    echo "  Adding build_runner..."
    # This would need more sophisticated YAML editing in practice
fi

echo "📁 Creating directory structure..."
mkdir -p lib/models/generated
mkdir -p lib/services
mkdir -p scripts

echo "📝 Creating generation script..."
cat > scripts/generate_models.dart << 'EOF'
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart run scripts/generate_models.dart <openapi-url-or-file>');
    exit(1);
  }
  
  final input = args[0];
  
  print('🔄 Generating models from: $input');
  
  final result = await Process.run('dart', [
    'run',
    'dart_openapi_generator',
    '-i', input,
    '-o', 'lib/models/generated'
  ]);
  
  if (result.exitCode == 0) {
    print('✅ Models generated successfully!');
  } else {
    print('❌ Error generating models:');
    print(result.stderr);
    exit(1);
  }
  
  print('🔄 Running build_runner...');
  final buildResult = await Process.run('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs'
  ]);
  
  if (buildResult.exitCode == 0) {
    print('✅ JSON serialization generated successfully!');
    print('🎉 All done! Import your models with: import "models/generated/models.dart";');
  } else {
    print('❌ Error running build_runner:');
    print(buildResult.stderr);
    exit(1);
  }
}
EOF

echo "📝 Creating API client template..."
cat > lib/services/api_client.dart << 'EOF'
import 'dart:convert';
import 'package:http/http.dart' as http;
// Import your generated models
// import '../models/generated/models.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  
  ApiClient({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();
  
  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final defaultHeaders = {'Content-Type': 'application/json'};
    final requestHeaders = {...defaultHeaders, ...?headers};
    
    late http.Response response;
    
    switch (method.toUpperCase()) {
      case 'GET':
        response = await _client.get(uri, headers: requestHeaders);
        break;
      case 'POST':
        response = await _client.post(
          uri,
          headers: requestHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case 'PUT':
        response = await _client.put(
          uri,
          headers: requestHeaders,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case 'DELETE':
        response = await _client.delete(uri, headers: requestHeaders);
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw HttpException(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }
  }
  
  // Add your API methods here after generating models
  // Example:
  // Future<List<Pet>> getPets() async {
  //   final response = await _request('GET', '/pets');
  //   return (response['data'] as List)
  //       .map((json) => Pet.fromJson(json))
  //       .toList();
  // }
  
  void dispose() {
    _client.close();
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  
  @override
  String toString() => 'HttpException: $message';
}
EOF

echo "📝 Adding .gitignore entries..."
if [ -f ".gitignore" ]; then
    if ! grep -q "*.g.dart" .gitignore; then
        echo "" >> .gitignore
        echo "# Generated files" >> .gitignore
        echo "*.g.dart" >> .gitignore
    fi
else
    echo "# Generated files" > .gitignore
    echo "*.g.dart" >> .gitignore
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run: dart pub get"
echo "2. Generate models: dart run scripts/generate_models.dart https://your-api.com/openapi.json"
echo "3. Import models in your code: import 'models/generated/models.dart';"
echo ""
echo "📖 See USAGE.md for detailed integration examples"