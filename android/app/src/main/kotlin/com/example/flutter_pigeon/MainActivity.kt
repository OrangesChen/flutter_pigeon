package com.example.flutter_pigeon

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.Pigeon
import java.util.*

class MainActivity: FlutterActivity() {
    // 声明 Flutter Api 
    lateinit var flutterApi: Pigeon.MyApi
    private class MyApi: Pigeon.Api {
        override fun getPlatformVersion(result: Pigeon.Result<String>?) {
            var version = "Android ${android.os.Build.VERSION.RELEASE}"
            result?.success(version)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 调用 Flutter Api
        Timer().schedule(object: TimerTask() {
            override fun run() {
                // Platform Channel func 必须在主线程上执行该方法
                Handler(Looper.getMainLooper()).post {
                    // Call the desired channel message here.
                    flutterApi.sessionInValid {  Log.d("Call func", "====Call flutter func!===") }
                }
            }
        }, 1000)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 2. setup()
        Pigeon.Api.setup(flutterEngine.dartExecutor.binaryMessenger, MyApi())
        flutterApi = Pigeon.MyApi(flutterEngine.dartExecutor.binaryMessenger)
    }

}
