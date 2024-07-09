package com.userexperior.user_experior

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.userexperior.UserExperior
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UserExperiorSDKCallHandler(
    private var storedContext : Context,
    val onTransitionChanged: (Boolean) -> Unit) :
    MethodChannel.MethodCallHandler
{
    // region - singleton
    private companion object {
        object MethodsNames {
            const val GET_PLATFORM_VERSION = "getPlatformVersion"
            const val UPDATE_TRANSITIONING_STATE = "updateTransitioningState"

            const val RECORDING_START = "startRecording"
            const val RECORDING_STOP = "stopRecording"
            const val RECORDING_PAUSE = "pauseRecording"
            const val RECORDING_RESUME = "resumeRecording"

            const val SET_USER_IDENTIFIER = "setUserIdentifier"
            const val SET_USER_PROPERTIES = "setUserProperties"

            const val START_SCREEN = "startScreen"
            const val TIMER_START = "startTimer"
            const val TIMER_START_WITH_PROPERTIES = "startTimerWithProperties"
            const val TIMER_END = "endTimer"
            const val TIMER_END_WITH_PROPERTIES = "endTimerWithProperties"

            const val LOG_EVENT = "logEvent"
            const val LOG_EVENT_WITH_PROPERTIES = "logEventWithProperties"
            const val LOG_MESSAGE = "logMessage"
            const val LOG_MESSAGE_WITH_PROPERTIES = "logMessageWithProperties"

            const val DEVICE_LOCATION = "setDeviceLocation"
            const val OPT_OUT = "optOut"
            const val OPT_IN = "optIn"
            const val GET_OPT_OUT_STATUS = "getOptOutStatus"
            const val IS_RECORDING = "isRecording"
        }
    }
    // endregion

    // region - attributes
    private var mainHandler = Handler(Looper.getMainLooper())
    // endregion

    // region - MethodCallHandler
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // Accept commands from dart
        mainHandler.post {

            when (call.method) {
                MethodsNames.GET_PLATFORM_VERSION -> {
                    result.success("Android ${Build.VERSION.RELEASE}")
                    return@post
                }

                MethodsNames.UPDATE_TRANSITIONING_STATE -> {
                    call.argument<Boolean>("state")?.let {
                        onTransitionChanged(it)
                    }
                }
                MethodsNames.RECORDING_START -> {
                    val ueVersionKey = call.argument<String>("ueVersionKey")
                    val fw = call.argument<String>("fw")
                    val sv = call.argument<String>("sv")
                    try {
                        UserExperior.startRecording(storedContext.applicationContext, ueVersionKey, fw, sv)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.RECORDING_START}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.RECORDING_STOP -> {
                    UserExperior.stopRecording()
                }

                MethodsNames.RECORDING_PAUSE -> {
                    UserExperior.pauseRecording()
                }

                MethodsNames.RECORDING_RESUME -> {
                    UserExperior.resumeRecording()
                }

                MethodsNames.SET_USER_IDENTIFIER -> {
                    val userIdentifier = call.argument<String>("userIdentifier")
                    try {
                        UserExperior.setUserIdentifier(userIdentifier)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.SET_USER_IDENTIFIER}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.SET_USER_PROPERTIES -> {
                    val map = call.argument<HashMap<String, Any>>("properties")
                    try {
                        if (map != null && map.size != 0) {
                            UserExperior.setUserProperties(map)
                        }
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.SET_USER_PROPERTIES}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.START_SCREEN -> {
                    val screenName = call.argument<String>("screenName")
                    try {
                        UserExperior.startScreen(screenName)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.START_SCREEN}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.TIMER_START -> {
                    val timerName = call.argument<String>("timerName")
                    try {
                        @Suppress("DEPRECATION")
                        UserExperior.startTimer(timerName)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.TIMER_START}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.TIMER_START_WITH_PROPERTIES -> {
                    val timerNameWithProp = call.argument<String>("timerName")
                    val timerProps = call.argument<HashMap<String, String>>("properties")

                    require(!(timerNameWithProp.isNullOrEmpty())) { "missing timer Name" }

                    if (timerProps == null || timerProps.size == 0) {
                        try {
                            @Suppress("DEPRECATION")
                            UserExperior.startTimer(timerNameWithProp)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.TIMER_START}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    } else {
                        try {
                            UserExperior.startTimer(timerNameWithProp, timerProps)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.TIMER_START_WITH_PROPERTIES}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    }
                }

                MethodsNames.TIMER_END -> {
                    val timerName = call.argument<String>("timerName")
                    try {
                        @Suppress("DEPRECATION")
                        UserExperior.endTimer(timerName)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.TIMER_END}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.TIMER_END_WITH_PROPERTIES -> {
                    val timerNameWithProp = call.argument<String>("timerName")
                    val timerProps = call.argument<HashMap<String, String>>("properties")

                    require(!(timerNameWithProp.isNullOrEmpty())) { "missing timer Name" }

                    if (timerProps == null || timerProps.size == 0) {
                        try {
                            @Suppress("DEPRECATION")
                            UserExperior.endTimer(timerNameWithProp)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.TIMER_END}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    } else {
                        try {
                            UserExperior.endTimer(timerNameWithProp, timerProps)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.TIMER_END_WITH_PROPERTIES}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    }
                }

                MethodsNames.LOG_EVENT -> {
                    val eventName = call.argument<String>("eventName")

                    require(!(eventName.isNullOrEmpty())) { "missing event Name" }

                    try {
                        UserExperior.logEvent(eventName)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.LOG_EVENT}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.LOG_EVENT_WITH_PROPERTIES -> {
                    val eventNameWithProp = call.argument<String>("eventName")
                    val evtMap = call.argument<HashMap<String, Any>>("properties")

                    require(!(eventNameWithProp.isNullOrEmpty())) { "missing event Name" }

                    if (evtMap == null || evtMap.size == 0) {
                        try {
                            UserExperior.logEvent(eventNameWithProp)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.LOG_EVENT}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    } else {
                        try {
                            UserExperior.logEvent(eventNameWithProp, evtMap)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.LOG_EVENT_WITH_PROPERTIES}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    }
                }

                MethodsNames.LOG_MESSAGE -> {
                    val messageName = call.argument<String>("messageName")

                    require(!(messageName.isNullOrEmpty())) { "missing msg Name" }

                    try {
                        @Suppress("DEPRECATION")
                        UserExperior.logMessage(messageName)
                    } catch (e: Exception) {
                        Log.d(
                            "UserExperiorPlugin",
                            "Error occurred on \"${MethodsNames.LOG_MESSAGE}\", please submit a bug. If the log persists after start of the app submit a bug."
                        )
                        e.printStackTrace()
                    }
                }

                MethodsNames.LOG_MESSAGE_WITH_PROPERTIES -> {
                    val messageNameWithProp = call.argument<String>("messageName")
                    val msgMap = call.argument<HashMap<String, Any>>("properties")

                    require(!(messageNameWithProp.isNullOrEmpty())) { "missing msg Name" }

                    if (msgMap == null || msgMap.size == 0) {
                        try {
                            @Suppress("DEPRECATION")
                            UserExperior.logMessage(messageNameWithProp)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.LOG_MESSAGE}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    } else {
                        try {
                            @Suppress("DEPRECATION")
                            UserExperior.logMessage(messageNameWithProp, msgMap)
                        } catch (e: Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.LOG_MESSAGE_WITH_PROPERTIES}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    }
                }

                MethodsNames.DEVICE_LOCATION -> {
                    val latitude = call.argument<Double>("latitude")
                    val longitude = call.argument<Double>("longitude")
                    if (latitude != null && longitude != null) {
                        try {
                            UserExperior.setDeviceLocation(latitude, longitude)
                        } catch (e: java.lang.Exception) {
                            Log.d(
                                "UserExperiorPlugin",
                                "Error occurred on \"${MethodsNames.DEVICE_LOCATION}\", please submit a bug. If the log persists after start of the app submit a bug."
                            )
                            e.printStackTrace()
                        }
                    }
                }

                MethodsNames.OPT_OUT -> {
                    @Suppress("DEPRECATION")
                    UserExperior.optOut()
                }

                MethodsNames.OPT_IN -> {
                    @Suppress("DEPRECATION")
                    UserExperior.optIn()
                }

                MethodsNames.GET_OPT_OUT_STATUS -> {
                    result.success(UserExperior.getOptOutStatus())
                    return@post
                }

                MethodsNames.IS_RECORDING -> {
                    result.success(UserExperior.isRecording())
                    return@post
                }

                else -> {
                    result.notImplemented()
                    return@post
                }
            }
            result.success(null)
        }
    }
    // endregion
}