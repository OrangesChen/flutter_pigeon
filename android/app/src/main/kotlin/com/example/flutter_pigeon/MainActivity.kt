package com.example.flutter_pigeon

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.Pigeon

class MainActivity: FlutterActivity() {
    private class MyApi: Pigeon.Api {
        override fun getPlatformVersion(): Pigeon.Version {
            var result = Pigeon.Version()
            result.string = "Android ${android.os.Build.VERSION.RELEASE}"
            return result
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 2. setup()
        Pigeon.Api.setup(flutterEngine.dartExecutor.binaryMessenger, MyApi())
    }

}
