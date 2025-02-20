package com.userexperior.user_experior

import com.userexperior.bridge.UEPlatformPluginManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/** UserExperiorPlugin */
class UserExperiorPlugin : FlutterPlugin {

    // region - singleton
    private companion object {

        const val CHANNEL_NAME = "user_experior"

        // region - Attributes
        /// The MethodChannel that will the communication between Flutter and native Android
        ///
        /// This local reference serves to register the plugin with the Flutter Engine and unregister it
        /// when the Flutter Engine is detached from the Activity
        private var methodChannels = HashMap<BinaryMessenger, MethodChannel>()
        private var pluginInterface = UserExperiorSDKPlugin(methodChannels, true)
        // endregion

        init {
            UEPlatformPluginManager.getInstance().bridges += pluginInterface
        }
    }
    // endregion

    // region - attributes


    // endregion

    // region - FlutterPlugin
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val messenger = binding.binaryMessenger

        if (methodChannels.contains(messenger).not()) {
            methodChannels[messenger] = MethodChannel(messenger, CHANNEL_NAME)
            methodChannels[messenger]?.setMethodCallHandler(UserExperiorSDKCallHandler(binding.applicationContext) {
                pluginInterface.changeTransitioningState(it)
            })
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        val messenger = binding.binaryMessenger
        if (methodChannels.contains(messenger)) {
            val methodChannel = methodChannels.remove(messenger)
            methodChannel?.setMethodCallHandler(null)
        }
    }
    // endregion
}
