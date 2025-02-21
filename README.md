# Bloc Clean Architecture CLI 🚀

A simple Dart CLI tool to generate a Bloc Clean Architecture structure in a Flutter project.

## 🛠 Features

✅ Generates a feature-based directory structure.
✅ Implements Bloc (Business Logic Component) for state management.
✅ Supports Clean Architecture principles (Data, Domain, Presentation layers).
✅ Reduces boilerplate and speeds up development.

## 🚀 Installation

To install the CLI globally, run:

```sh
dart pub global activate bloc_clean
```

## ⚡ Usage

To generate a new feature with Bloc Clean Architecture, run:

```sh
bloc_clean -f feature_name
```

Replace feature_name with your actual feature name (in snake_case).

For example:

```sh
bloc_clean -f auth
```

## 📂 Generated Directory Structure

The CLI will generate the following feature-based directory structure inside your Flutter project:

```sh
lib/src/features/feature_name
│── data
│   ├── models/            # Data models
│   ├── sources/           # Local & remote data sources
│   │   ├── local/
│   │   ├── remote/
│   ├── repositories/      # Data layer repository implementations
│
│── domain
│   ├── entities/          # Business entities
│   ├── repositories/      # Domain layer repository interfaces
│   ├── use_cases/         # Business logic (use cases)
│
│── presentation
│   ├── bloc/             # Bloc (State Management)
│   ├── views/            # UI Screens
│   │   ├── components/   # UI Components
```

## 📖 Example Feature: auth

If you run:

```sh
bloc_clean -f auth
```

It will create:

```sh
lib/src/features/auth
│── data
│   ├── models/auth.dart
│   ├── sources/local/auth.dart
│   ├── sources/remote/auth.dart
│   ├── repositories/auth_impl.dart
│
│── domain
│   ├── entities/auth.dart
│   ├── repositories/auth.dart
│   ├── use_cases/auth.dart
│
│── presentation
│   ├── bloc/auth_bloc.dart
│   ├── bloc/auth_event.dart
│   ├── bloc/auth_state.dart
│   ├── views/auth.dart
│   ├── views/components/.gitkeep
```

## 📝 Notes

Bloc Structure: Includes Bloc, Events, and States.
Separation of Concerns: Uses Clean Architecture principles.
Easy Integration: Works with existing Flutter projects.

## 📄 License

This project is licensed under the MIT License.
