package com.example.mobileoa.plugins

import android.content.Context
import android.os.Build
import android.util.Log
import com.baidu.location.BDAbstractLocationListener
import com.baidu.location.BDLocation
import com.baidu.location.Poi
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class LocationFlutterPlugin(context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var locationService: LocationService? = null
    var mLocationStr = "";
    private var mEventSink: EventSink? = null

    private val mContext = context

    companion object {

        private val CHANNEL_METHOD_LOCATION = "bdmap_location_flutter_plugin"
        private val CHANNEL_STREAM_LOCATION = "bdmap_location_flutter_plugin_stream"
        /**
         * 注册组件
         */
        @JvmStatic
        fun registerWith(context: Context, messenger: BinaryMessenger) {
            Log.i("LocationFlutterPlugin", "注册")

            val plugin = LocationFlutterPlugin(context)
            /** 开始、停止定位
             */
            val channel = MethodChannel(messenger, CHANNEL_METHOD_LOCATION)
            channel.setMethodCallHandler(plugin)
            /**
             * 监听位置变化
             */
            val eventChannel = EventChannel(messenger, CHANNEL_STREAM_LOCATION)
            eventChannel.setStreamHandler(plugin)

        }

    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        //定位数据
        mEventSink = events
    }

    override fun onCancel(arguments: Any?) {
        stopLocation()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startLocation" -> {
                Log.i("LocationFlutterPlugin", "开始定位")
                startLocation() // 启动定位
            }
            "stopLocation" -> {
                Log.i("LocationFlutterPlugin", "停止定位")
                stopLocation() // 停止定位
            }
            "getPlatformVersion" -> {
                result.success("Android " + Build.VERSION.RELEASE)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * 停止定位
     */
    private fun stopLocation() {
        locationService?.stop()
    }

    /**
     * 开始定位
     */
    private fun startLocation() {
        locationService = LocationService(mContext)
        locationService!!.registerListener(mListener)
        //注册监听
        LocationService.setLocationOption(locationService!!.defaultLocationClientOption)

        locationService?.start()
    }

    /*****
     *
     * 定位结果回调，重写onReceiveLocation方法，可以直接拷贝如下代码到自己工程中修改
     *
     */
    private val mListener: BDAbstractLocationListener = object : BDAbstractLocationListener() {
        /**
         * 定位请求回调函数
         * @param location 定位结果
         */
        override fun onReceiveLocation(location: BDLocation) { 
            if (location.locType != BDLocation.TypeServerError) {
                val tag = 1
                val sb = StringBuffer(256)
                sb.append("time : ")
                /**
                 * 时间也可以使用systemClock.elapsedRealtime()方法 获取的是自从开机以来，每次回调的时间；
                 * location.getTime() 是指服务端出本次结果的时间，如果位置不发生变化，则时间不变
                 */
                sb.append(location.time)
                sb.append("\nlocType : ") // 定位类型
                sb.append(location.locType)
                sb.append("\nlocType description : ") // *****对应的定位类型说明*****
                sb.append(location.locTypeDescription)
                sb.append("\nlatitude : ") // 纬度
                sb.append(location.latitude)
                sb.append("\nlongtitude : ") // 经度
                sb.append(location.longitude)
                sb.append("\nradius : ") // 半径
                sb.append(location.radius)
                sb.append("\nCountryCode : ") // 国家码
                sb.append(location.countryCode)
                sb.append("\nProvince : ") // 获取省份
                sb.append(location.province)
                sb.append("\nCountry : ") // 国家名称
                sb.append(location.country)
                sb.append("\ncitycode : ") // 城市编码
                sb.append(location.cityCode)
                sb.append("\ncity : ") // 城市
                sb.append(location.city)
                sb.append("\nDistrict : ") // 区
                sb.append(location.district)
                sb.append("\nTown : ") // 获取镇信息
                sb.append(location.town)
                sb.append("\nStreet : ") // 街道
                sb.append(location.street)
                sb.append("\naddr : ") // 地址信息
                sb.append(location.addrStr)
                sb.append("\nStreetNumber : ") // 获取街道号码
                sb.append(location.streetNumber)
                sb.append("\nUserIndoorState: ") // *****返回用户室内外判断结果*****
                sb.append(location.userIndoorState)
                sb.append("\nDirection(not all devices have value): ")
                sb.append(location.direction) // 方向
                sb.append("\nlocationdescribe: ")
                sb.append(location.locationDescribe) // 位置语义化信息
                sb.append("\nPoi: ") // POI信息
                if (location.poiList != null && !location.poiList.isEmpty()) {
                    for (i in location.poiList.indices) {
                        val poi = location.poiList[i] as Poi
                        sb.append("poiName:")
                        sb.append(poi.name + ", ")
                        sb.append("poiTag:")
                        sb.append(poi.tags + "\n")
                    }
                }
                if (location.poiRegion != null) {
                    sb.append("PoiRegion: ") // 返回定位位置相对poi的位置关系，仅在开发者设置需要POI信息时才会返回，在网络不通或无法获取时有可能返回null
                    val poiRegion = location.poiRegion
                    sb.append("DerectionDesc:") // 获取POIREGION的位置关系，ex:"内"
                    sb.append(poiRegion.derectionDesc + "; ")
                    sb.append("Name:") // 获取POIREGION的名字字符串
                    sb.append(poiRegion.name + "; ")
                    sb.append("Tags:") // 获取POIREGION的类型
                    sb.append(poiRegion.tags + "; ")
                    sb.append("\nSDK版本: ")
                }
                sb.append(locationService!!.sdkVersion) // 获取SDK版本
                if (location.locType == BDLocation.TypeGpsLocation) { // GPS定位结果
                    sb.append("\nspeed : ")
                    sb.append(location.speed) // 速度 单位：km/h
                    sb.append("\nsatellite : ")
                    sb.append(location.satelliteNumber) // 卫星数目
                    sb.append("\nheight : ")
                    sb.append(location.altitude) // 海拔高度 单位：米
                    sb.append("\ngps status : ")
                    sb.append(location.gpsAccuracyStatus) // *****gps质量判断*****
                    sb.append("\ndescribe : ")
                    sb.append("gps定位成功")
                } else if (location.locType == BDLocation.TypeNetWorkLocation) { // 网络定位结果
// 运营商信息
                    if (location.hasAltitude()) { // *****如果有海拔高度*****
                        sb.append("\nheight : ")
                        sb.append(location.altitude) // 单位：米
                    }
                    sb.append("\noperationers : ") // 运营商信息
                    sb.append(location.operators)
                    sb.append("\ndescribe : ")
                    sb.append("网络定位成功")
                } else if (location.locType == BDLocation.TypeOffLineLocation) { // 离线定位结果
                    sb.append("\ndescribe : ")
                    sb.append("离线定位成功，离线定位结果也是有效的")
                } else if (location.locType == BDLocation.TypeServerError) {
                    sb.append("\ndescribe : ")
                    sb.append("服务端网络定位失败，可以反馈IMEI号和大体定位时间到loc-bugs@baidu.com，会有人追查原因")
                } else if (location.locType == BDLocation.TypeNetWorkException) {
                    sb.append("\ndescribe : ")
                    sb.append("网络不同导致定位失败，请检查网络是否通畅")
                } else if (location.locType == BDLocation.TypeCriteriaException) {
                    sb.append("\ndescribe : ")
                    sb.append("无法获取有效定位依据导致定位失败，一般是由于手机的原因，处于飞行模式下一般会造成这种结果，可以试着重启手机")
                }
                Log.i("LocationFlutterPlugin",sb.toString())
                if (null == mEventSink) {
                    return
                }
                mEventSink!!.success(location.addrStr)
            }
        }

        override fun onConnectHotSpotMessage(s: String, i: Int) {
            super.onConnectHotSpotMessage(s, i)
        }

        /**
         * 回调定位诊断信息，开发者可以根据相关信息解决定位遇到的一些问题
         * @param locType 当前定位类型
         * @param diagnosticType 诊断类型（1~9）
         * @param diagnosticMessage 具体的诊断信息释义
         */
        override fun onLocDiagnosticMessage(locType: Int, diagnosticType: Int, diagnosticMessage: String) {
            super.onLocDiagnosticMessage(locType, diagnosticType, diagnosticMessage)
            val tag = 2
            val sb = StringBuffer(256)
            sb.append("诊断结果: ")
            if (locType == BDLocation.TypeNetWorkLocation) {
                if (diagnosticType == 1) {
                    sb.append("网络定位成功，没有开启GPS，建议打开GPS会更好")
                    sb.append("\n" + diagnosticMessage)
                } else if (diagnosticType == 2) {
                    sb.append("网络定位成功，没有开启Wi-Fi，建议打开Wi-Fi会更好")
                    sb.append("\n" + diagnosticMessage)
                }
            } else if (locType == BDLocation.TypeOffLineLocationFail) {
                if (diagnosticType == 3) {
                    sb.append("定位失败，请您检查您的网络状态")
                    sb.append("\n" + diagnosticMessage)
                }
            } else if (locType == BDLocation.TypeCriteriaException) {
                if (diagnosticType == 4) {
                    sb.append("定位失败，无法获取任何有效定位依据")
                    sb.append("\n" + diagnosticMessage)
                } else if (diagnosticType == 5) {
                    sb.append("定位失败，无法获取有效定位依据，请检查运营商网络或者Wi-Fi网络是否正常开启，尝试重新请求定位")
                    sb.append(diagnosticMessage)
                } else if (diagnosticType == 6) {
                    sb.append("定位失败，无法获取有效定位依据，请尝试插入一张sim卡或打开Wi-Fi重试")
                    sb.append("\n" + diagnosticMessage)
                } else if (diagnosticType == 7) {
                    sb.append("定位失败，飞行模式下无法获取有效定位依据，请关闭飞行模式重试")
                    sb.append("\n" + diagnosticMessage)
                } else if (diagnosticType == 9) {
                    sb.append("定位失败，无法获取任何有效定位依据")
                    sb.append("\n" + diagnosticMessage)
                }
            } else if (locType == BDLocation.TypeServerError) {
                if (diagnosticType == 8) {
                    sb.append("定位失败，请确认您定位的开关打开状态，是否赋予APP定位权限")
                    sb.append("\n" + diagnosticMessage)
                }
            }
            Log.i("LocationFlutterPlugin",sb.toString())
        }
    }

}