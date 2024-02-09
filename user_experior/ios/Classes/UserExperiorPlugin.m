#import "UserExperiorPlugin.h"
@import UserExperiorSDK;

@implementation UserExperiorPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"user_experior"
                                     binaryMessenger:[registrar messenger]];
    UserExperiorPlugin* instance = [[UserExperiorPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if ([@"startRecording" isEqualToString:call.method]) {
        NSString* ueVersionKey = call.arguments[@"ueVersionKey"];
        NSString* fw = call.arguments[@"fw"];
        NSString* sv = call.arguments[@"sv"];
        [UserExperior startRecordingWithVersionKey:ueVersionKey fw:fw sv:sv];
    }
    else if([@"stopRecording" isEqualToString:call.method]) {
        [UserExperior stopRecording];
    }
    else if([@"pauseRecording" isEqualToString:call.method]) {
        [UserExperior pauseRecording];
    }
    else if([@"resumeRecording" isEqualToString:call.method]) {
        [UserExperior resumeRecording];
    }
    else if ([@"startScreen" isEqualToString:call.method]) {
        NSString* screenName = call.arguments[@"screenName"];
        [UserExperior startScreenWithName:screenName];
    }
    else if ([@"startTimer" isEqualToString:call.method]) {
        NSString* timerName = call.arguments[@"timerName"];
        [UserExperior startScreenWithName:timerName];
    }
    else if ([@"startTimerWithProperties" isEqualToString:call.method]) {
        NSString* timerName = call.arguments[@"timerName"];
        NSDictionary* properties = call.arguments[@"properties"];
        if (timerName.length>0 && [properties isKindOfClass:NSDictionary.class]) {
            [UserExperior startTimerWithName:timerName properties:properties];
        }
    }
    else if ([@"endTimer" isEqualToString:call.method]) {
        NSString* timerName = call.arguments[@"timerName"];
        [UserExperior endTimerWithName:timerName];
    }
    else if ([@"endTimerWithProperties" isEqualToString:call.method]) {
        NSString* timerName = call.arguments[@"timerName"];
        NSDictionary* properties = call.arguments[@"properties"];
        if (timerName.length>0 && [properties isKindOfClass:NSDictionary.class]) {
            [UserExperior endTimerWithName:timerName properties:properties];
        }
    }
    else if ([@"setUserIdentifier" isEqualToString:call.method]) {
        NSString* userIdentifier = call.arguments[@"userIdentifier"];
        [UserExperior setUserIdentifier:userIdentifier];
    }
    else if ([@"setUserProperties" isEqualToString:call.method]) {
        NSDictionary* properties = call.arguments[@"properties"];
        if ([properties isKindOfClass:NSDictionary.class]) {
            [UserExperior setUserProperties:properties];
        }
    }
    else if ([@"logEvent" isEqualToString:call.method]) {
        NSString* eventName = call.arguments[@"eventName"];
        if (eventName.length>0) {
            [UserExperior logEventWithName:eventName];
        }
    }
    else if ([@"logEventWithProperties" isEqualToString:call.method]) {
        NSString* eventName = call.arguments[@"eventName"];
        NSDictionary* properties = call.arguments[@"properties"];
        if (eventName.length>0 && [properties isKindOfClass:NSDictionary.class]) {
            [UserExperior logEventWithName:eventName properties:properties];
        }
    }
    else if ([@"logMessage" isEqualToString:call.method]) {
        NSString* messageName = call.arguments[@"messageName"];
        if (messageName.length>0) {
            [UserExperior logMessageWithName:messageName];
        }
    }
    else if ([@"logMessageWithProperties" isEqualToString:call.method]) {
        NSString* messageName = call.arguments[@"messageName"];
        NSDictionary* properties = call.arguments[@"properties"];
        if (messageName.length>0 && [properties isKindOfClass:NSDictionary.class]) {
            [UserExperior logMessageWithName:messageName properties:properties];
        }
    }
    else if ([@"optIn" isEqualToString:call.method]) {
        [UserExperior consentOptIn];
    }
    else if ([@"optOut" isEqualToString:call.method]) {
        [UserExperior consentOptOut];
    }
    else if ([@"getOptOutStatus"isEqualToString:call.method]) {
        result(@([UserExperior getOptOutStatus]));
    }
    else if ([@"isRecording"isEqualToString:call.method]) {
        result(@([UserExperior isRecording]));
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

@end
