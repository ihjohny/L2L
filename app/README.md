# L2L App

L2L (Link to Learn) - Intelligent Learning Bookmark Platform

## Code Generation

This project uses code generation for Freezed models, JSON serialization, and Riverpod providers.

### Running Build Runner

Generate code after model changes or when cloning the project:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Alternative commands:**

| Command | Purpose |
|---------|---------|
| `flutter pub run build_runner build` | One-time build |
| `flutter pub run build_runner watch` | Continuous generation during development |
| `flutter pub run build_runner clean` | Remove all generated files |

### Troubleshooting

If code generation fails:

1. Clean and rebuild:
   ```bash
   flutter pub run build_runner clean
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. Ensure dependencies are installed:
   ```bash
   flutter pub get
   ```

3. Verify model files have:
   - `part 'filename.freezed.dart';` declaration
   - `part 'filename.g.dart';` (if using JSON serialization)
   - `@freezed` or `@JsonSerializable` annotations
