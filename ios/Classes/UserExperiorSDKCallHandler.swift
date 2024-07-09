//
//  UserExperiorSDKCallHandler.swift
//  user_experior
//
//
//
import Foundation
import UserExperiorSDK
import Flutter

@objc(UEPlatformSDKCallHandler)
public protocol UEPlatformSDKCallHandler : NSObjectProtocol
{
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
}
@objc(UserExperiorSDKCallHandler)
@objcMembers
public class UserExperiorSDKCallHandler : NSObject , UEPlatformSDKCallHandler
{
    // MARK: - Type
    fileprivate class MethodsNames {
        private init() {}
        
        fileprivate static var GET_PLATFORM_VERSION        : String { "getPlatformVersion" }

        fileprivate static var RECORDING_START             : String { "startRecording" }
        fileprivate static var RECORDING_STOP              : String { "stopRecording" }
        fileprivate static var RECORDING_PAUSE             : String { "pauseRecording" }
        fileprivate static var RECORDING_RESUME            : String { "resumeRecording" }
        
        fileprivate static var SET_USER_IDENTIFIER         : String { "setUserIdentifier" }
        fileprivate static var SET_USER_PROPERTIES         : String { "setUserProperties" }
        
        fileprivate static var START_SCREEN                : String { "startScreen" }
        fileprivate static var TIMER_START                 : String { "startTimer" }
        fileprivate static var TIMER_START_WITH_PROPERTIES : String { "startTimerWithProperties" }
        fileprivate static var TIMER_END                   : String { "endTimer" }
        fileprivate static var TIMER_END_WITH_PROPERTIES   : String { "endTimerWithProperties" }
        
        fileprivate static var LOG_EVENT                   : String { "logEvent" }
        fileprivate static var LOG_EVENT_WITH_PROPERTIES   : String { "logEventWithProperties" }
        fileprivate static var LOG_MESSAGE                 : String { "logMessage" }
        fileprivate static var LOG_MESSAGE_WITH_PROPERTIES : String { "logMessageWithProperties" }
        
        fileprivate static var DEVICE_LOCATION             : String { "setDeviceLocation" }
        fileprivate static var OPT_OUT                     : String { "optOut" }
        fileprivate static var OPT_IN                      : String { "optIn" }
        fileprivate static var GET_OPT_OUT_STATUS          : String { "getOptOutStatus" }
        fileprivate static var IS_RECORDING                : String { "isRecording" }
    }


    // MARK: - SDKCallHandler
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        switch call.method {
        case MethodsNames.GET_PLATFORM_VERSION:
            result("iOS " + UIDevice.current.systemVersion)

        case MethodsNames.RECORDING_START:
            guard let args = call.arguments as? [String: Any]        else { return }
            guard let ueVersionKey = args["ueVersionKey"] as? String else { return }
            guard let fw = args["fw"] as? String else { return }
            guard let sv = args["sv"] as? String else { return }
            UserExperior.startRecording(ueVersionKey, fw, sv)
            result(nil)
            
        case MethodsNames.RECORDING_STOP:
            UserExperior.stopRecording()
            result(nil)
            
        case MethodsNames.RECORDING_PAUSE:
            UserExperior.pauseRecording()
            result(nil)
            
        case MethodsNames.RECORDING_RESUME:
            UserExperior.resumeRecording()
            result(nil)
            
        case MethodsNames.START_SCREEN:
            guard let args = call.arguments as? [String: Any]    else { return }
            guard let screenName = args["screenName"] as? String else { return }
            UserExperior.startScreen(screenName)
            result(nil)
            
        case MethodsNames.TIMER_START:
            guard let args = call.arguments as? [String: Any]  else { return }
            guard let timerName = args["timerName"] as? String else { return }
            UserExperior.startTimer(timerName, properties: [String : Any]() )
            result(nil)
            
        case MethodsNames.TIMER_START_WITH_PROPERTIES:
            guard let args = call.arguments as? [String: Any]  else { return }
            guard let timerName = args["timerName"] as? String else { return }
            guard !timerName.isEmpty                           else { return }
            guard let properties = args["properties"] as? [String: Any] else { return }
            UserExperior.startTimer(timerName, properties: properties )
            result(nil)
            
        case MethodsNames.TIMER_END:
            guard let args = call.arguments as? [String: Any]  else { return }
            guard let timerName = args["timerName"] as? String else { return }
            guard !timerName.isEmpty                           else { return }
            UserExperior.endTimer(timerName, properties: [String : Any]() )
            result(nil)
            
        case MethodsNames.TIMER_END_WITH_PROPERTIES:
            guard let args = call.arguments as? [String: Any]           else { return }
            guard let timerName  = args["timerName" ] as? String        else { return }
            guard !timerName.isEmpty                                    else { return }
            guard let properties = args["properties"] as? [String: Any] else { return }
            UserExperior.endTimer(timerName, properties: properties )
            result(nil)
            
        case MethodsNames.SET_USER_IDENTIFIER:
            guard let args = call.arguments as? [String: Any]            else { return }
            guard let userIdentifier = args["userIdentifier"] as? String else { return }
            UserExperior.setUserIdentifier(userIdentifier)
            result(nil)
            
        case MethodsNames.SET_USER_PROPERTIES:
            guard let args = call.arguments as? [String: Any]           else { return }
            guard let properties = args["properties"] as? [String: Any] else { return }
            UserExperior.setUserProperties(properties)
            result(nil)
            
        case MethodsNames.LOG_EVENT:
            guard let args = call.arguments as? [String: Any]  else { return }
            guard let eventName = args["eventName"] as? String else { return }
            guard !eventName.isEmpty else { return }
            UserExperior.logEvent(eventName)
            result(nil)
            
        case MethodsNames.LOG_EVENT_WITH_PROPERTIES:
            guard let args = call.arguments as? [String: Any]           else { return }
            guard let eventName  = args["eventName"] as? String         else { return }
            guard let properties = args["properties"] as? [String: Any] else { return }
            guard !eventName.isEmpty                                    else { return }
            UserExperior.logEvent(eventName, properties: properties)
            result(nil)
            
        case MethodsNames.LOG_MESSAGE:
            guard let args = call.arguments as? [String: Any]      else { return }
            guard let messageName = args["messageName"] as? String else { return }
            guard !messageName.isEmpty                             else { return }
            UserExperior.logMessage(messageName)
            result(nil)
            
        case MethodsNames.LOG_MESSAGE_WITH_PROPERTIES:
            guard let args = call.arguments as? [String: Any]           else { return }
            guard let messageName = args["messageName"] as? String      else { return }
            guard !messageName.isEmpty                                  else { return }
            guard let properties = args["properties"] as? [String: Any] else { return }
            UserExperior.logMessage(messageName, properties: properties)
            result(nil)
            
        case MethodsNames.OPT_IN:
            UserExperior.consentOptIn()
            result(nil)
            
        case MethodsNames.OPT_OUT:
            UserExperior.consentOptOut()
            result(nil)
        
        case MethodsNames.GET_OPT_OUT_STATUS:
            result(UserExperior.getOptOutStatus)
            
        case MethodsNames.IS_RECORDING:
            result(UserExperior.isRecording)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
