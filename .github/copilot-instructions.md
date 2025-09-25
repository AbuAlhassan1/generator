# Dart OpenAPI Generator

This project generates Dart models and schemas from OpenAPI JSON specifications.

## Project Structure
- `lib/` - Main library code
- `bin/` - Command-line executable
- `test/` - Unit tests
- `example/` - Example OpenAPI specifications and generated code

## Development Guidelines
- Follow Dart naming conventions (lowerCamelCase for variables/methods, UpperCamelCase for classes)
- Use strong typing and null safety
- Generate clean, readable Dart code with proper documentation
- Support common OpenAPI features: objects, arrays, enums, references ($ref)
- Handle nested schemas and complex types
- Generate appropriate imports and exports

## Code Generation Patterns
- Create separate files for each model class
- Use `json_annotation` for serialization
- Generate `fromJson` and `toJson` methods
- Handle optional/nullable fields properly
- Support inheritance and composition where applicable