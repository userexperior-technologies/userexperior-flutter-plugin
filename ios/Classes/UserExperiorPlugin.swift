//
//  UserExperiorPlugin.swift
//  user_experior
//
//
//
import Foundation
import UserExperiorSDK
import Flutter

public class UserExperiorPlugin : NSObject, FlutterPlugin
{
    // MARK: - Type
    internal class Constants {
        private init() {}
        internal static var CHANNEL_NAME : String { "user_experior" }
    }
    // MARK: - Attributes
    internal var methodChannel : FlutterMethodChannel
    internal var     interface : UEPlatformPluginInterface
    internal var   callHandler : UEPlatformSDKCallHandler

    // MARK: - Constructors
    init(method channel: FlutterMethodChannel) 
    {
        self.methodChannel = channel
        self.interface     = UserExperiorSDKPlugin(method: channel, recordingAllowed: true)
        self.callHandler   = UserExperiorSDKCallHandler()
        super.init()
        UEPlatformPluginManager.shared.addPluginInterface(interface)
    }
    
    // MARK: -
    public static func register(with registrar: FlutterPluginRegistrar)
    {
        let channel  = FlutterMethodChannel(name: Constants.CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = UserExperiorPlugin.init(method: channel)

        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        methodChannel.setMethodCallHandler(nil)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        switch call.method {
        case "updateTransitioningState":
            guard let args = call.arguments as?  [String: Any] else { return }
            guard let isTransitioning = args["state"] as? Bool else { return }
            interface.updateTransitioningState(state: isTransitioning)
            result(nil)
            break
            
        default:
            callHandler.handle(call, result: result)
        }
    }
}
