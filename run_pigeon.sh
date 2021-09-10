flutter pub run pigeon \
  --input pigeon/schema.dart \
  --dart_out lib/api_generated.dart  \
  --objc_header_out ios/Runner/Pigeon.h \
  --objc_source_out ios/Runner/Pigeon.m \
  --objc_prefix FLT \
  --java_out android/app/src/main/java/io/flutter/plugins/Pigeon.java \
  --java_package "io.flutter.plugins"
