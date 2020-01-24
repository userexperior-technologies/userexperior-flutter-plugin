#import "UserExperiorPlugin.h"
//#import <user_experior/user_experior-Swift.h>
#import <UserExperior/UserExperior-Swift.h>

@implementation UserExperiorPlugin
//+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  //[SwiftUserExperiorPlugin registerWithRegistrar:registrar];
//}

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
    } else if ([@"startRecording" isEqualToString:call.method]) {
        NSString* ueVersionKey = call.arguments[@"ueVersionKey"];
        [UserExperior initialize:ueVersionKey];
    } else if([@"stopRecording" isEqualToString:call.method]) {
        [UserExperior stopRecording];
    } else if([@"pauseRecording" isEqualToString:call.method]) {
        [UserExperior pauseRecording];
    } else if([@"resumeRecording" isEqualToString:call.method]) {
        [UserExperior resumeRecording];
    } else if ([@"startScreen" isEqualToString:call.method]) {
        NSString* screenName = call.arguments[@"screenName"];
        [UserExperior startScreen:screenName];
    } else if ([@"setUserIdentifier" isEqualToString:call.method]) {
        NSString* userIdentifier = call.arguments[@"userIdentifier"];
        [UserExperior setUserIdentifier:userIdentifier];
    } else if ([@"setCustomTag" isEqualToString:call.method]) {
        NSString* customTag = call.arguments[@"customTag"];
        NSString* customType = call.arguments[@"customType"];
        if (customTag.length>0 && customType.length>0) {
            [UserExperior setCustomTagWithString:customTag customType:customType];
        }
    } else if ([@"optIn" isEqualToString:call.method]) {
        [UserExperior optIn];
    } else if ([@"optOut" isEqualToString:call.method]) {
        [UserExperior optOut];
    } else if ([@"getOptOutStatus"isEqualToString:call.method]) {
        result(@( [UserExperior getOptOutStatus]));
    } else if ([@"consent"isEqualToString:call.method]) {
        [UserExperior consent];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
