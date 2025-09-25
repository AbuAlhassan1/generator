# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-09-25

### Added
- Initial release of Dart OpenAPI Generator
- Generate Dart models from OpenAPI 3.0 JSON specifications
- Support for both local files and remote URLs (HTTP/HTTPS)
- Full null safety support with Dart SDK >=3.8.0
- JSON serialization using `json_annotation` and `json_serializable`
- Command-line interface with help and options
- Custom JSON converters for handling mixed types in real-world APIs
- Comprehensive error handling and validation
- Generated code includes:
  - Properly typed Dart classes
  - Required vs optional field handling
  - Documentation comments from OpenAPI descriptions
  - Barrel file for easy imports
  - Clean, readable code following Dart conventions

### Features
- **Schema Support**:
  - Object schemas with nested properties
  - Primitive types (string, integer, number, boolean)
  - Array types with proper generic typing
  - Enum generation
  - Schema references ($ref) resolution
  - additionalProperties handling (including boolean values)

- **CLI Features**:
  - Input from file paths or URLs
  - Configurable output directory
  - Built-in help system
  - Clear error messages and validation

- **Code Quality**:
  - Strong typing throughout
  - Null safety compliance
  - Proper error handling
  - Clean separation of concerns
  - Comprehensive documentation

### Tested With
- Swagger Petstore API (basic OpenAPI spec)
- RxiQ Clinic Management API (complex real-world spec with 619+ schemas)
- Various edge cases and mixed-type scenarios

### Development
- VS Code integration with build tasks
- Proper package structure for pub.dev publishing
- Modular architecture for extensibility
- Comprehensive usage documentation