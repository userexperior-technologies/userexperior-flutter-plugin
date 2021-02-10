package com.userexperior.user_experior;

import android.app.Activity;
import com.userexperior.UserExperior;

import java.util.Map;

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
        try {
            if (activity != null) {
                UserExperior.startRecording(activity.getApplicationContext(), ueVersionKey);
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
        final Map<String, Object> map = call.argument("properties");
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
        UserExperior.logEvent(eventName);
        break;
      case "logEventWithProperties":
        String eventName = call.argument("eventName");
        final Map<String, Object> map = call.argument("properties");
        if (eventName == null || eventName.length() == 0) {
          throw new IllegalArgumentException("missing event Name");
        }
        if (map == null || map.size() == 0) {
          UserExperior.logEvent(eventName);
        } else {
          UserExperior.logEvent(eventName, map);
        }
        break;
      case "logMessage":
        String messageName = call.argument("messageName");
        if (messageName == null || messageName.length() == 0) {
          throw new IllegalArgumentException("missing msg Name");
        }
        UserExperior.logMessage(messageName);
        break;
      case "logMessageWithProperties":
        String messageName = call.argument("messageName");
        final Map<String, Object> map = call.argument("properties");
        if (messageName == null || messageName.length() == 0) {
          throw new IllegalArgumentException("missing msg Name");
        }
        if (map == null || map.size() == 0) {
          UserExperior.logMessage(messageName);
        } else {
          UserExperior.logMessage(messageName, map);
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
      case "endTimer": {
        String timerName = call.argument("timerName");
        try {
          UserExperior.endTimer(timerName);
        } catch (Exception e) {
          e.printStackTrace();
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
