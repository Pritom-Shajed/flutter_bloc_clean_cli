/// A CLI tool to generate Bloc Clean Architecture structure in a Flutter project.
///
/// Usage:
/// ```sh
/// bloc_clean -f feature_name
/// ```
library;

import 'dart:io';

import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser =
      ArgParser()
        ..addOption('feature', abbr: 'f', help: 'Feature name in snake_case')
        ..addFlag(
          'write',
          abbr: 'w',
          defaultsTo: true,
          help: 'Write basic structure in each file',
        );

  final argResults = parser.parse(arguments);
  final String? featureName = argResults['feature'];
  final bool writeCode = argResults['write'];

  if (featureName == null || featureName.isEmpty) {
    print('❌ Feature name is required. Use -f <feature_name>');
    exit(1);
  }

  if (!RegExp(r'^[a-z]+(_[a-z]+)*$').hasMatch(featureName)) {
    print('❌ Feature name must be in snake_case.');
    exit(1);
  }

  // Convert feature_name to PascalCase
  final String pascalCase =
      featureName
          .split('_')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join();

  final String baseDir = 'lib/src/features/$featureName';
  final List<String> directories = [
    '$baseDir/data/models',
    '$baseDir/data/sources/local',
    '$baseDir/data/sources/remote',
    '$baseDir/data/repositories',
    '$baseDir/domain/entities',
    '$baseDir/domain/repositories',
    '$baseDir/domain/use_cases',
    '$baseDir/presentation/bloc',
    '$baseDir/presentation/views/components',
  ];

  for (var dir in directories) {
    Directory(dir).createSync(recursive: true);
  }

  final Map<String, String> files = {
    '$baseDir/data/models/$featureName.dart':
        "import '../../domain/entities/$featureName.dart';\n\nclass ${pascalCase}Model extends ${pascalCase}Entity {}",
    '$baseDir/data/sources/local/$featureName.dart':
        "abstract class ${pascalCase}LocalService {}\n\nclass ${pascalCase}LocalServiceImpl implements ${pascalCase}LocalService {\n  ${pascalCase}LocalServiceImpl();\n}",
    '$baseDir/data/sources/remote/$featureName.dart':
        "abstract class ${pascalCase}RemoteService {}\n\nclass ${pascalCase}RemoteServiceImpl implements ${pascalCase}RemoteService {\n  ${pascalCase}RemoteServiceImpl();\n}",
    '$baseDir/data/repositories/${featureName}_impl.dart':
        "import '../../domain/repositories/$featureName.dart';\nimport '../../data/sources/local/$featureName.dart';\nimport '../../data/sources/remote/$featureName.dart';\n\nclass ${pascalCase}RepositoryImpl implements ${pascalCase}Repository {\n  final ${pascalCase}LocalService _localService;\n  final ${pascalCase}RemoteService _remoteService;\n\n  ${pascalCase}RepositoryImpl(this._localService, this._remoteService);\n}",
    '$baseDir/domain/entities/$featureName.dart':
        "import '../../data/models/$featureName.dart';\n\nclass ${pascalCase}Entity {\n  ${pascalCase}Entity();\n\n  ${pascalCase}Model get toModel => ${pascalCase}Model();\n}",
    '$baseDir/domain/repositories/$featureName.dart':
        "abstract class ${pascalCase}Repository {}",
    '$baseDir/domain/use_cases/$featureName.dart':
        "import '../repositories/$featureName.dart';\n\nclass ${pascalCase}UseCase {\n  final ${pascalCase}Repository _repository;\n\n  ${pascalCase}UseCase(this._repository);\n}",
    '$baseDir/presentation/bloc/${featureName}_bloc.dart':
        "import 'package:flutter_bloc/flutter_bloc.dart';\n\npart '${featureName}_event.dart';\npart '${featureName}_state.dart';\n\nclass ${pascalCase}Bloc extends Bloc<${pascalCase}Event, ${pascalCase}State> {\n  ${pascalCase}Bloc() : super(${pascalCase}Initial()) {\n    on<Fetch$pascalCase>((event, emit) async {\n      emit(${pascalCase}Loading());\n      await Future.delayed(Duration(seconds: 1));\n      emit(${pascalCase}Loaded(data: 'Sample data for $pascalCase'));\n    });\n  }\n}",
    '$baseDir/presentation/bloc/${featureName}_event.dart':
        "part of '${featureName}_bloc.dart';\n\nsealed class ${pascalCase}Event {}\n\nfinal class Fetch$pascalCase extends ${pascalCase}Event {}",
    '$baseDir/presentation/bloc/${featureName}_state.dart':
        "part of '${featureName}_bloc.dart';\n\nsealed class ${pascalCase}State {}\n\nfinal class ${pascalCase}Initial extends ${pascalCase}State {}\nfinal class ${pascalCase}Loading extends ${pascalCase}State {}\nfinal class ${pascalCase}Loaded extends ${pascalCase}State {\n  final String data;\n  ${pascalCase}Loaded({required this.data});\n}\nfinal class ${pascalCase}Error extends ${pascalCase}State {\n  final String message;\n  ${pascalCase}Error(this.message);\n}",
    '$baseDir/presentation/views/$featureName.dart':
        "import 'package:flutter/material.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport '../bloc/${featureName}_bloc.dart';\n\nclass ${pascalCase}View extends StatelessWidget {\n  const ${pascalCase}View({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(title: Text('$pascalCase')),\n      body: BlocBuilder<${pascalCase}Bloc, ${pascalCase}State>(\n        builder: (context, state) {\n          final bloc = context.watch<${pascalCase}Bloc>();\n          if (state is ${pascalCase}Loading) {\n            return Center(child: CircularProgressIndicator());\n          } else if (state is ${pascalCase}Loaded) {\n            return Center(child: Text(state.data));\n          } else if (state is ${pascalCase}Error) {\n            return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));\n          }\n          return Center(\n            child: ElevatedButton(\n              onPressed: () => bloc.add(Fetch$pascalCase()),\n              child: Text('Fetch Data'),\n            ),\n          );\n        },\n      ),\n    );\n  }\n}",
    '$baseDir/presentation/views/components/.gitkeep': "",
  };

  if (writeCode) {
    files.forEach((path, content) {
      File(path).writeAsStringSync(content);
    });
  }

  print('✅ Feature "$featureName" created successfully!');
}
