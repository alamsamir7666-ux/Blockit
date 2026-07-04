package com.blockit.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.blockit.app.channel.SessionMethodChannel
import com.blockit.app.channel.PermissionMethodChannel
import com.blockit.app.channel.SessionEventChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        SessionMethodChannel.register(flutterEngine.dartExecutor.binaryMessenger, this)
        PermissionMethodChannel.register(flutterEngine.dartExecutor.binaryMessenger, this)
        SessionEventChannel.register(flutterEngine.dartExecutor.binaryMessenger)
    }
}
