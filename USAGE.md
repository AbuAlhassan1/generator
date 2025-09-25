# Using Dart OpenAPI Generator in Flutter Projects

This guide shows you how to integrate the Dart OpenAPI Generator into your Flutter projects to automatically generate API models from OpenAPI specifications.

## Installation Options

### Option 1: As a Dev Dependency (Recommended)

Add this to your Flutter project's `pubspec.yaml`:

```yaml
dev_dependencies:
  dart_openapi_generator:
    git:
      url: https://github.com/yourusername/dart_openapi_generator.git
      ref: main
  # Required for generated code
  json_annotation: ^4.8.1
  build_runner: ^2.4.7
  json_serializable: ^6.7.1

dependencies:
  # Your app dependencies
  flutter:
    sdk: flutter
  # Required at runtime for generated models
  json_annotation: ^4.8.1
```

### Option 2: As a Global Package

```bash
dart pub global activate --source git https://github.com/yourusername/dart_openapi_generator.git
```

## Usage in Flutter Projects

### 1. Add Build Script to package.json (Optional)

Create a `scripts/generate_models.dart` file in your Flutter project:

```dart
import 'dart:io';

Future<void> main() async {
  // Generate models from your API's OpenAPI spec
  final result = await Process.run('dart', [
    'run',
    'dart_openapi_generator',
    '-i', 'https://your-api.com/openapi.json',
    '-o', 'lib/models/generated'
  ]);
  
  if (result.exitCode == 0) {
    print('✅ Models generated successfully!');
  } else {
    print('❌ Error generating models:');
    print(result.stderr);
  }
  
  // Run build_runner to generate JSON serialization
  print('Running build_runner...');
  final buildResult = await Process.run('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs'
  ]);
  
  if (buildResult.exitCode == 0) {
    print('✅ JSON serialization generated successfully!');
  } else {
    print('❌ Error running build_runner:');
    print(buildResult.stderr);
  }
}
```

### 2. Add to pubspec.yaml Scripts

```yaml
scripts:
  generate: dart run scripts/generate_models.dart
```

### 3. Manual Usage

```bash
# Navigate to your Flutter project root
cd your_flutter_project

# Generate models from OpenAPI spec
dart run dart_openapi_generator -i https://your-api.com/openapi.json -o lib/models

# Generate JSON serialization code
dart run build_runner build --delete-conflicting-outputs
```

## Integration Examples

### Example 1: REST API Client

After generating models, create an API client:

```dart
// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart'; // Your generated barrel file

class ApiClient {
  final String baseUrl;
  
  ApiClient({required this.baseUrl});
  
  Future<List<Pet>> getPets() async {
    final response = await http.get(Uri.parse('$baseUrl/pets'));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }
  
  Future<Pet> createPet(PetCreate petData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(petData.toJson()),
    );
    
    if (response.statusCode == 201) {
      return Pet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create pet');
    }
  }
}
```

### Example 2: Provider/Riverpod Integration

```dart
// lib/providers/pets_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_client.dart';
import '../models/models.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://your-api.com/api/v1');
});

final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  return await apiClient.getPets();
});

final petProvider = FutureProvider.family<Pet, int>((ref, petId) async {
  final apiClient = ref.read(apiClientProvider);
  return await apiClient.getPet(petId);
});
```

### Example 3: Flutter Widget Usage

```dart
// lib/screens/pets_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pets_provider.dart';

class PetsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('Pets')),
      body: petsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (pets) => ListView.builder(
          itemCount: pets.length,
          itemBuilder: (context, index) {
            final pet = pets[index];
            return ListTile(
              title: Text(pet.name),
              subtitle: Text(pet.tag ?? 'No tag'),
              leading: CircleAvatar(
                child: Text(pet.id.toString()),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## Automated Workflow

### GitHub Actions (CI/CD)

Create `.github/workflows/generate-models.yml`:

```yaml
name: Generate API Models

on:
  schedule:
    - cron: '0 2 * * *' # Daily at 2 AM
  workflow_dispatch: # Manual trigger

jobs:
  generate-models:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: stable
          
      - name: Get dependencies
        run: dart pub get
        
      - name: Generate models
        run: |
          dart run dart_openapi_generator \
            -i https://your-api.com/openapi.json \
            -o lib/models
            
      - name: Generate JSON serialization
        run: dart run build_runner build --delete-conflicting-outputs
        
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v4
        with:
          title: 'Update API models'
          body: 'Automated update of API models from OpenAPI specification'
          branch: update-api-models
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/sh
# Check if OpenAPI spec has changed and regenerate models

if git diff --cached --name-only | grep -q "openapi.json"; then
  echo "OpenAPI spec changed, regenerating models..."
  dart run dart_openapi_generator -i openapi.json -o lib/models
  dart run build_runner build --delete-conflicting-outputs
  git add lib/models/
fi
```

## Best Practices

### 1. Directory Structure

```
your_flutter_project/
├── lib/
│   ├── models/
│   │   ├── generated/          # Generated models (don't edit)
│   │   │   ├── pet.dart
│   │   │   ├── pet.g.dart
│   │   │   ├── user.dart
│   │   │   ├── user.g.dart
│   │   │   └── models.dart     # Barrel file
│   │   └── custom/             # Custom models (your code)
│   ├── services/
│   │   └── api_client.dart
│   └── providers/
├── openapi.json                # Local copy (optional)
└── scripts/
    └── generate_models.dart
```

### 2. .gitignore Recommendations

```
# Generated files
lib/models/generated/
*.g.dart

# Or keep generated files in git for team consistency
# (recommended for small teams)
```

### 3. Version Pinning

Pin the generator version in your `pubspec.yaml`:

```yaml
dev_dependencies:
  dart_openapi_generator:
    git:
      url: https://github.com/yourusername/dart_openapi_generator.git
      ref: v1.0.0  # Use specific version tag
```

## Troubleshooting

### Common Issues

1. **Build conflicts**: Use `--delete-conflicting-outputs` with build_runner
2. **Import errors**: Make sure `json_annotation` is in both dependencies and dev_dependencies
3. **Type conflicts**: Ensure your OpenAPI spec uses consistent types

### Debugging

```bash
# Verbose output
dart run dart_openapi_generator -i spec.json -o lib/models --verbose

# Analyze generated code
dart analyze lib/models/

# Format generated code
dart format lib/models/
```