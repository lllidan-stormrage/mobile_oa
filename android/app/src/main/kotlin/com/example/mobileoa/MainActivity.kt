package com.example.mobileoa

import android.os.Bundle
import androidx.annotation.NonNull
import com.example.mobileoa.plugins.LocationFlutterPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import org.devio.flutter.splashscreen.SplashScreen
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        LocationFlutterPlugin.registerWith(this,flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        SplashScreen.show(this, true)// here
        super.onCreate(savedInstanceState)


    }


}
