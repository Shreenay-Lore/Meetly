package com.example.meetly

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Ensure proper cleanup of image resources
    }
    
    override fun onDestroy() {
        super.onDestroy()
        // Clean up any pending image operations
    }
}
