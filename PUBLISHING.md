# Publishing to pub.dev

To make your Dart OpenAPI Generator available on pub.dev for easier installation:

## 1. Prepare for Publishing

Update `pubspec.yaml`:

```yaml
name: dart_openapi_generator
description: A command-line tool and library for generating Dart models from OpenAPI JSON specifications. Supports both local files and remote URLs with full null safety and JSON serialization.
version: 1.0.0
homepage: https://github.com/yourusername/dart_openapi_generator
repository: https://github.com/yourusername/dart_openapi_generator
issue_tracker: https://github.com/yourusername/dart_openapi_generator/issues

topics:
  - openapi
  - code-generation
  - api
  - flutter
  - dart

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  args: ^2.4.2
  http: ^1.1.0
  json_annotation: ^4.8.1
  path: ^1.8.3
  recase: ^4.1.0

dev_dependencies:
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
  lints: ^3.0.0

executables:
  dart_openapi_generator:
```

## 2. Create CHANGELOG.md

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2024-XX-XX

### Added
- Initial release
- Generate Dart models from OpenAPI 3.0 specifications
- Support for local files and remote URLs
- Full null safety support
- JSON serialization with json_annotation
- Command-line interface
- Custom JSON converters for edge cases
- Comprehensive documentation

### Features
- Object schemas with proper typing
- Primitive types (string, integer, number, boolean)
- Array types with generic support
- Required/optional fields handling
- Enums generation
- Schema references ($ref) resolution
- Documentation comments from OpenAPI descriptions
- Barrel file generation for easy imports
```

## 3. Add LICENSE file

```
MIT License

Copyright (c) 2024 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 4. Validate Package

```bash
# Check package structure and dependencies
dart pub deps

# Analyze code quality
dart analyze

# Format code
dart format .

# Check publishing readiness
dart pub publish --dry-run
```

## 5. Publish

```bash
# Publish to pub.dev (requires pub.dev account)
dart pub publish
```

## 6. Usage After Publishing

Once published, users can install it with:

```yaml
# In pubspec.yaml
dev_dependencies:
  dart_openapi_generator: ^1.0.0
```

Or globally:

```bash
dart pub global activate dart_openapi_generator
```

## Benefits of Publishing to pub.dev

1. **Easy Installation**: Users can add it with a simple version number
2. **Version Management**: Semantic versioning and dependency resolution
3. **Discoverability**: Searchable on pub.dev
4. **Documentation**: Automatic documentation generation
5. **Analytics**: Usage statistics and popularity metrics
6. **CI/CD Integration**: Easier to integrate into automated workflows