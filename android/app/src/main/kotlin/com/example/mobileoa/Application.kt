package com.example.mobileoa

import com.baidu.mapapi.CoordType
import com.baidu.mapapi.SDKInitializer
import io.flutter.app.FlutterApplication

class Application : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        SDKInitializer.initialize(this)
        SDKInitializer.setCoordType(CoordType.BD09LL)
    }
}