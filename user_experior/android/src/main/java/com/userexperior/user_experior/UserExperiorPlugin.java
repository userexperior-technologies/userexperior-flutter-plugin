package com.userexperior.user_experior;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.userexperior.UserExperior;

import java.lang.reflect.Field;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
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
    messenger = flutterPluginBinding.getBinaryMessenger();
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
                FlutterActivity activityObject = (FlutterActivity) UserExperiorPlugin.activity;
                Class<?> activityClass = activityObject.getClass();
                Field delegateField = ReflectionUtilities.getField(activityClass, "delegate", true);
                delegateField.setAccessible(true);
                Object delegateObject = delegateField.get(activityObject);

                Class<?> delegateClass = delegateObject.getClass();
                Field flutterViewField = ReflectionUtilities.getField(delegateClass, "flutterView", true);
                flutterViewField.setAccessible(true);
                Object targetObject = flutterViewField.get(delegateObject);

                FlutterView flutterView = (FlutterView)targetObject;
                UserExperior.startRecording(activity.getApplicationContext(), ueVersionKey, flutterView);
            }
        } catch (Exception e) {
            e.printStackTrace();
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
      case "setCustomTag":
        String customTag = call.argument("customTag");
        String customType = call.argument("customType");
        try {
          UserExperior.setCustomTag(customTag, customType);
        } catch (Exception e) {
          e.printStackTrace();
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
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        flutterPluginBinding = binding;
        messenger = flutterPluginBinding.getBinaryMessenger();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
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
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
      onAttachedToActivity(binding);
      UserExperiorPlugin.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        UserExperiorPlugin.activity = null;
    }
}
