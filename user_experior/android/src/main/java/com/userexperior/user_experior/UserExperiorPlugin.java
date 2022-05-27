package com.userexperior.user_experior;

import android.app.Activity;
import com.userexperior.UserExperior;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


/** UserExperiorPlugin */
public class UserExperiorPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {

  private static Activity activity;

  private static FlutterPluginBinding flutterPluginBinding;

  private static BinaryMessenger messenger;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "user_experior");
    channel.setMethodCallHandler(new UserExperiorPlugin());
    UserExperiorPlugin.activity = registrar.activity();
    messenger = registrar.messenger();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "startRecording":
        String ueVersionKey = call.argument("ueVersionKey");
        String fw = call.argument("fw");
        String sv = call.argument("sv");
        try {
            if (activity != null) {
                UserExperior.startRecording(activity.getApplicationContext(), ueVersionKey, fw, sv);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("userexperiorlogs: "+e.getMessage());
        }
        break;
      case "stopRecording":
        UserExperior.stopRecording();
        break;
      case "pauseRecording":
        UserExperior.pauseRecording();
        break;
      case "resumeRecording":
        UserExperior.resumeRecording();
        break;
      case "setUserIdentifier":
        String userIdentifier = call.argument("userIdentifier");
        try {
          UserExperior.setUserIdentifier(userIdentifier);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      case "setUserProperties":
        final HashMap<String, Object> map = call.argument("properties");
        try {
          if (map != null && map.size() != 0) {
            UserExperior.setUserProperties(map);
          }
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      case "setCustomTag":
        String customTag = call.argument("customTag");
        String customType = call.argument("customType");
        try {
          UserExperior.setCustomTag(customTag, customType);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      case "logEvent":
        String eventName = call.argument("eventName");
        if (eventName == null || eventName.length() == 0) {
          throw new IllegalArgumentException("missing event Name");
        }
        try {
          UserExperior.logEvent(eventName);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      case "logEventWithProperties":
        String eventNameWithProp = call.argument("eventName");
        final HashMap<String, Object> evtMap = call.argument("properties");
        if (eventNameWithProp == null || eventNameWithProp.length() == 0) {
          throw new IllegalArgumentException("missing event Name");
        }
        if (evtMap == null || evtMap.size() == 0) {
          try {
            UserExperior.logEvent(eventNameWithProp);
          } catch (Exception e) {
            e.printStackTrace();
          }
        } else {
          try {
            UserExperior.logEvent(eventNameWithProp, evtMap);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
        break;
      case "logMessage":
        String messageName = call.argument("messageName");
        if (messageName == null || messageName.length() == 0) {
          throw new IllegalArgumentException("missing msg Name");
        }
        try {
          UserExperior.logMessage(messageName);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      case "logMessageWithProperties":
        String messageNameWithProp = call.argument("messageName");
        final HashMap<String, Object> msgMap = call.argument("properties");
        if (messageNameWithProp == null || messageNameWithProp.length() == 0) {
          throw new IllegalArgumentException("missing msg Name");
        }
        if (msgMap == null || msgMap.size() == 0) {
          try {
            UserExperior.logMessage(messageNameWithProp);
          } catch (Exception e) {
            e.printStackTrace();
          }
        } else {
          try {
            UserExperior.logMessage(messageNameWithProp, msgMap);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
        break;
      case "startScreen":
        String screenName = call.argument("screenName");
        try {
          UserExperior.startScreen(screenName);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      case "startTimer": {
        String timerName = call.argument("timerName");
        try {
          UserExperior.startTimer(timerName);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      }

      case "startTimerWithProperties": {
        String timerNameWithProp = call.argument("timerName");
        final HashMap<String, String> timerProps = call.argument("properties");
        if (timerNameWithProp == null || timerNameWithProp.length() == 0) {
          throw new IllegalArgumentException("missing timer Name");
        }
        if (timerProps == null || timerProps.size() == 0) {
          try {
            UserExperior.startTimer(timerNameWithProp);
          } catch (Exception e) {
            e.printStackTrace();
          }
        } else {
          try {
            UserExperior.startTimer(timerNameWithProp, timerProps);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
        break;
      }
      case "endTimer": {
        String timerName = call.argument("timerName");
        try {
          UserExperior.endTimer(timerName);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;
      }
      case "endTimerWithProperties": {
        String timerNameWithProp = call.argument("timerName");
        final HashMap<String, String> timerProps = call.argument("properties");
        if (timerNameWithProp == null || timerNameWithProp.length() == 0) {
          throw new IllegalArgumentException("missing timer Name");
        }
        if (timerProps == null || timerProps.size() == 0) {
          try {
            UserExperior.endTimer(timerNameWithProp);
          } catch (Exception e) {
            e.printStackTrace();
          }
        } else {
          try {
            UserExperior.endTimer(timerNameWithProp, timerProps);
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
        break;
      }
      /*case "setDeviceLocation":
        double latitude = call.argument("latitude");
        double longitude = call.argument("longitude");
        try {
          UserExperior.setDeviceLocation(latitude, longitude);
        } catch (Exception e) {
          e.printStackTrace();
        }
        break;*/
      case "optOut":
        UserExperior.optOut();
        break;
      case "optIn":
        UserExperior.optIn();
        break;
      case "getOptOutStatus":
        result.success(UserExperior.getOptOutStatus());
        break;
      case "consent":
        UserExperior.consent();
        break;
      case "isRecording":
        result.success(UserExperior.isRecording());
        break;
      //case "activateThirdPartyAnalyticsMonitor":
        //UserExperior.activateThirdPartyAnalyticsMonitor();
        //break;

      default:
        result.notImplemented();
        break;
    }
  }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        flutterPluginBinding = binding;
        messenger = flutterPluginBinding.getBinaryMessenger();
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
      messenger = flutterPluginBinding.getBinaryMessenger();
      final MethodChannel channel = new MethodChannel(messenger, "user_experior");
      channel.setMethodCallHandler(new UserExperiorPlugin());
      UserExperiorPlugin.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
      onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
      onAttachedToActivity(binding);
      UserExperiorPlugin.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        UserExperiorPlugin.activity = null;
    }
}
