#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_openapi_generator/dart_openapi_generator.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input OpenAPI JSON file path or URL')
    ..addOption('output', abbr: 'o', help: 'Output directory for generated files', defaultsTo: 'lib/models')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage information');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('Dart OpenAPI Generator');
      print('Usage: dart_openapi_generator -i <input_file_or_url> -o <output_dir>');
      print('');
      print('Examples:');
      print('  dart_openapi_generator -i openapi.json -o lib/models');
      print('  dart_openapi_generator -i https://api.example.com/openapi.json -o lib/models');
      print(parser.usage);
      return;
    }

    final inputFile = results['input'] as String?;
    final outputDir = results['output'] as String;

    if (inputFile == null) {
      print('Error: Input file or URL is required');
      print(parser.usage);
      exit(1);
    }

    final generator = OpenApiGenerator();
    await generator.generate(inputFile, outputDir);
    
    print('✓ Generated Dart models successfully!');
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}