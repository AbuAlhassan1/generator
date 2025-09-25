# Dart OpenAPI Generator

A Dart tool for generating models and schemas from OpenAPI JSON specifications.

## Features

- ✅ Parse OpenAPI 3.0 JSON specifications from files or URLs
- ✅ Fetch specifications directly from web endpoints
- ✅ Generate Dart model classes with proper typing
- ✅ Support for nullable and required fields
- ✅ JSON serialization with `json_annotation`
- ✅ Proper documentation comments
- ✅ Command-line interface

## Installation

### Option 1: Use in Flutter/Dart Projects (Recommended)

Add to your project's `pubspec.yaml`:

```yaml
dev_dependencies:
  dart_openapi_generator:
    git:
      url: https://github.com/yourusername/dart_openapi_generator.git
  json_annotation: ^4.8.1
  build_runner: ^2.4.7
  json_serializable: ^6.7.1

dependencies:
  json_annotation: ^4.8.1  # Required for generated models
```

### Option 2: Install Globally

```bash
dart pub global activate --source git https://github.com/yourusername/dart_openapi_generator.git
```

### Option 3: Clone and Build Locally

1. Clone this repository
2. Run `dart pub get` to install dependencies
3. Run `dart run build_runner build` to generate JSON serialization code

## Usage

### Command Line

```bash
# Generate models from a local OpenAPI specification file
dart run bin/dart_openapi_generator.dart -i path/to/openapi.json -o lib/models

# Generate models from a URL
dart run bin/dart_openapi_generator.dart -i https://api.example.com/openapi.json -o lib/models

# Show help
dart run bin/dart_openapi_generator.dart -h
```

### Options

- `-i, --input`: Input OpenAPI JSON file path or URL (required)
- `-o, --output`: Output directory for generated files (default: lib/models)
- `-h, --help`: Show usage information

### Examples

```bash
# Generate models from a local file
dart run bin/dart_openapi_generator.dart -i path/to/openapi.json -o lib/models

# Generate models from a URL (e.g., Swagger Petstore API)
dart run bin/dart_openapi_generator.dart -i https://petstore3.swagger.io/api/v3/openapi.json -o lib/models

# Generate models from GitHub raw file
dart run bin/dart_openapi_generator.dart -i https://raw.githubusercontent.com/username/repo/main/openapi.json -o lib/models
```

This will generate:
- Individual model files (e.g., `pet.dart`, `user.dart`)
- A barrel file (`models.dart`) that exports all generated models

## Using as a Package in Flutter Projects

See [USAGE.md](USAGE.md) for detailed integration guide including:
- Adding as dev dependency
- Automated workflows
- API client integration
- Provider/Riverpod usage examples
- CI/CD setup

## Generated Code Structure

Each generated model includes:
- Proper Dart class with typed fields
- JSON serialization methods (`fromJson`, `toJson`)
- Documentation comments from OpenAPI descriptions
- Null safety support
- Proper handling of required vs optional fields

### Example Generated Code

```dart
import 'package:json_annotation/json_annotation.dart';

part 'pet.g.dart';

@JsonSerializable()
class Pet {
  /// Unique identifier for the pet
  final int id;

  /// Name of the pet
  final String name;

  /// Tag for the pet
  final String? tag;

  Pet({
    required this.id,
    required this.name,
    this.tag,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
  Map<String, dynamic> toJson() => _$PetToJson(this);
}
```

## Supported OpenAPI Features

- [x] Object schemas
- [x] Primitive types (string, integer, number, boolean)
- [x] Array types
- [x] Required/optional fields
- [x] Enums
- [x] Schema references ($ref)
- [x] Descriptions and documentation
- [x] Nullable types

## VS Code Tasks

This project includes VS Code tasks:

- **Build OpenAPI Generator**: Compiles the tool to an executable

## Development

To contribute to this project:

1. Fork the repository
2. Make your changes
3. Run `dart analyze` to check for issues
4. Submit a pull request

## License

MIT License - see LICENSE file for details.