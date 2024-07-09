package com.userexperior.user_experior

import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import com.userexperior.bridge.location.UEPlatformMask
import com.userexperior.bridge.model.UEPlatformPluginInformation
import com.userexperior.bridge.model.UEPlatformPluginInterface
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.WeakHashMap

class UserExperiorSDKPlugin(
    private val methodChannels: HashMap<BinaryMessenger, MethodChannel>,
    private var recordingAllowed: Boolean,
) : UEPlatformPluginInterface {

    // region - attributes
    private val locationsCache = WeakHashMap<FlutterView, WeakHashMap<String,UEPlatformMask>>()

    private var isDebugMode = false //with false to production
    // endregion

    fun changeTransitioningState(state: Boolean) {
        recordingAllowed = !state
    }

    // region - UEPlatformPluginInterface
    override fun isRecordingAllowed() : Boolean = recordingAllowed
    override fun pluginInformation()  : UEPlatformPluginInformation =
        UEPlatformPluginInformation("FLUTTER", "5.0.0.1")
    override fun pluginRootClasses()  : List<Class<out View?>?> = listOf(FlutterView::class.java)
    override fun obtainMaskedLocationsData(instance: View?) : List<UEPlatformMask?> {

        if (instance !is FlutterView) {
            return ArrayList()
        }

        val methodChannel = methodChannels[instance.binaryMessenger] ?: return ArrayList()

        val timer = UserExperiorTimer()
        timer.start()

        Handler(Looper.getMainLooper()).post {

            methodChannel.invokeMethod( "getMarkerLocations","arg", object : MethodChannel.Result {
                override fun success(result: Any?) {

                    val locations = result as? ArrayList<HashMap<String,String>> ?: return

                    val locationsForView = locationsCache[instance].let {
                        var locationsForView = locationsCache[instance]
                        if (locationsForView == null) {
                            locationsForView = WeakHashMap<String,UEPlatformMask>()
                            locationsCache[instance] = locationsForView
                        }
                        locationsForView
                    }
                    locationsForView.clear()

                    for (location in locations) {
                        val mask = location.toUEPlatformMask()
                        locationsForView[mask.identifier] = mask
                    }

                    if (isDebugMode) {
                        Log.d("elapsedTime:", "${timer.elapsedMicros()}")
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.d(
                        "UserExperiorPlugin",
                        "Error occurred on MaskedLocations, please submit a bug. Or check that you have added UEMarker Widget to your application"
                    )
                }

                override fun notImplemented() {

                    Log.d(
                        "UserExperiorPlugin",
                        "Masked Locations not implemented, please check that UserExperior is implemented. If the log persists after start of the app submit a bug."
                    )
                }
            })
        }
        return locationsCache[instance]?.values?.toList() ?: ArrayList()
    }
    // endregion
}
