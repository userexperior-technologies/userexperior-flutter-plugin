package com.userexperior.user_experior;

import android.app.Activity;
import android.view.SurfaceView;

import com.userexperior.UserExperior;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterView;

/** UserExperiorPlugin */
public class UserExperiorPlugin implements MethodCallHandler {

  private final Activity activity;
  private static FlutterView flutterView;

  private UserExperiorPlugin(Activity activity) {
    this.activity = activity;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "user_experior");
    channel.setMethodCallHandler(new UserExperiorPlugin(registrar.activity()));
    //flutterView = registrar.view();
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
            UserExperior.startRecording(activity.getApplicationContext(), ueVersionKey, (SurfaceView)flutterView);
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
      /*case "startTimer": {
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
      case "setDeviceLocation":
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
}
