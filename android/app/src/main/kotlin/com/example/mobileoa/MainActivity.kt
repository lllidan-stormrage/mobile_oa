package com.example.mobileoa

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        SplashScreen.show(this, true);// here
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this);
    }


}
