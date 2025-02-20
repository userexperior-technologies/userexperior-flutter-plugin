package com.userexperior.user_experior

import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import com.userexperior.bridge.location.UEPlatformMask
import com.userexperior.bridge.model.UEPlatformPluginInformation
import com.userexperior.bridge.model.UEPlatformPluginInterface
import com.userexperior.bridge.model.UEPlatformPluginView
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.WeakHashMap
//import android.graphics.Bitmap
//import java.nio.ByteBuffer

@Suppress("unused")
class UserExperiorSDKPlugin(
    private val methodChannels: HashMap<BinaryMessenger, MethodChannel>,
    private var recordingAllowed: Boolean,
) : UEPlatformPluginInterface {

    // region - attributes
    private val cache = WeakHashMap<FlutterView, UEPlatformPluginView>()
    private var isDebugMode = false //with false to production
    // endregion

    fun changeTransitioningState(state: Boolean) {
        recordingAllowed = !state
    }

    // region - UEPlatformPluginInterface
    override fun isRecordingAllowed(): Boolean = recordingAllowed
    override fun pluginInformation(): UEPlatformPluginInformation =
        UEPlatformPluginInformation("FLUTTER", "5.0.0.1")

    override fun pluginRootClasses(): List<Class<out View?>?> = listOf(FlutterView::class.java)
    override fun obtainPluginView(instance: View): UEPlatformPluginView? {
        if (instance !is FlutterView) {
            return super.obtainPluginView(instance)
        }

        val methodChannel =
            methodChannels[instance.binaryMessenger] ?: return super.obtainPluginView(instance)

        val timer = UserExperiorTimer().apply { start() }

        Handler(Looper.getMainLooper()).post {

            methodChannel.invokeMethod("fetchFlutterData", mapOf("mode" to "full"), object : MethodChannel.Result {

                override fun success(result: Any?) {

                    val cacheEntry = cache.getOrPut(instance) { UEPlatformPluginView() }
                    val payload = (result as? HashMap<*, *>)
                        ?.filterKeys { it is String }
                        ?.mapKeys { it.key as String } as? HashMap<String, Any>
                        ?: HashMap()

                    val wireframe = payload["wireframe"] as? String
                    val encodedImage = payload["screenshot"] as? ByteArray
                    val encodedWidth = payload["width"] as? Int
                    val encodedHeight = payload["height"] as? Int
                    val encodedFormat = payload["format"] as? Int
                    val locations = (payload["locations"] as? List<*>)
                        ?.filterIsInstance<HashMap<String, String>>()
                        ?.toCollection(ArrayList())
                        ?: ArrayList()

                    cacheEntry.locations.clear()
                    if (locations.isNotEmpty()) {
                        locations.forEach { location ->
                            location.toUEPlatformMask().let { mask ->
                                cacheEntry.locations[mask.identifier] = mask
                            }
                        }
                    }
                    if (encodedImage != null) {
                        cacheEntry.encodedImage = encodedImage
                    }
                    if (encodedWidth != null) {
                        cacheEntry.width = encodedWidth
                    }
                    if (encodedHeight != null) {
                        cacheEntry.height = encodedHeight
                    }
                    if (encodedFormat != null) {
                        cacheEntry.encodedFormat = encodedFormat
                    }
                    if (wireframe != null) {
                        cacheEntry.wireframe = wireframe
                    }

                    // if (encodedImage != null && encodedWidth != null && encodedHeight != null) {
                    //     val aa = rawARGBtoBitmap(encodedImage, encodedWidth, encodedHeight)
                    //     Log.d("UserExperiorSDKPlugin:", "${timer.elapsedMilliseconds()}")
                    // }

                    if (isDebugMode) {
                        Log.d("UserExperiorSDKPlugin:", "${timer.elapsedMilliseconds()}")
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.d(
                        "UserExperiorPlugin",
                        "Error occurred on MaskedLocations, please submit a bug.\n" +
                                "Or check that you have added UEMarker Widget to your application\n" +
                                "Code=$errorCode, Message=$errorMessage, Details=$errorDetails"
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
        return cache[instance]
    }
    // endregion
    //    private fun rawARGBtoBitmap(argbData: ByteArray, width: Int, height: Int): Bitmap? {
    //        if (argbData.isEmpty() || width <= 0 || height <= 0) {
    //            return null
    //        }
    //        val timer = UserExperiorTimer().apply { start() }
    //
    //        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    //        val buffer = ByteBuffer.wrap(argbData)
    //        bitmap.copyPixelsFromBuffer(buffer)
    //        Log.d("UserExperiorSDKPlugin:", "rawARGBtoBitmap:: ${timer.elapsedMilliseconds()}")
    //        return bitmap
    //    }
}

private fun HashMap<String, String>.toUEPlatformMask(): UEPlatformMask {
    val identifier = this["i"] ?: throw IllegalArgumentException("Identifier is required")
    val x = this["x"]?.toFloatOrNull()
        ?: throw IllegalArgumentException("x is required and must be a float")
    val y = this["y"]?.toFloatOrNull()
        ?: throw IllegalArgumentException("y is required and must be a float")
    val w = this["w"]?.toFloatOrNull()
        ?: throw IllegalArgumentException("width is required and must be a float")
    val h = this["h"]?.toFloatOrNull()
        ?: throw IllegalArgumentException("height is required and must be a float")
    return UEPlatformMask(identifier, x, y, w, h)
}

@Suppress("unused")
private class UserExperiorTimer {
    private var start: Long = 0L

    fun start() {
        start = System.nanoTime()
    }

    fun elapsedMicros(): Long {
        val current = System.nanoTime()
        return (current - start) / 1_000
    }

    fun elapsedMilliseconds(): Long {
        val current = System.nanoTime()
        return (current - start) / 1_000_000
    }
}