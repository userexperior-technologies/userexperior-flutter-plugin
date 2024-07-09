//
//  UserExperiorSDKPlugin.swift
//  user_experior
//
//
//
import Foundation
import UserExperiorSDK
import Flutter

public class UserExperiorSDKPlugin : NSObject, UEPlatformPluginInterface
{
    // MARK: - Attributes
    private  var recordingAllowed : Bool
    internal var methodChannel    : FlutterMethodChannel
    internal var platformMasks    : [String:UEPlatformMask]
    internal var isDebugMode      : Bool

    // MARK: - Constructors
    init(method channel: FlutterMethodChannel, recordingAllowed: Bool)
    {
        self.recordingAllowed = recordingAllowed
        self.methodChannel = channel
        self.platformMasks = [String:UEPlatformMask]()
        self.isDebugMode   = false
        super.init()
    }
    
    // MARK: - UEPlatformPluginInterface
    public func updateTransitioningState(state: Bool)
    {
        recordingAllowed = !state
    }
    
    // MARK: - UEPlatformPluginInterface
    public var isRecordingAllowed : Bool 
    {
        return recordingAllowed
    }
    
    public var pluginInformation: UEPlatformPluginInformation
    {
        return UEPlatformPluginInformation(pluginTechnology: "FLUTTER", pluginVersion: "5.0.0.1")
    }
    
    public var pluginRootClasses: [String]
    {
        return ["FlutterView"]
    }
    
    public func obtainMaskedLocationsData() -> [UserExperiorSDK.UEPlatformMask] {
        
        let channel   = self.methodChannel
        let startTime = DispatchTime.now()
        DispatchQueue.main.async {
            
            channel.invokeMethod("getMarkerLocations", arguments: "arg") { (result) in
               
                guard let locations = result as? Array<Dictionary<String, String>> else {
                    print( "Error occurred on MaskedLocations, please submit a bug. Or check that you have added UEMarker Widget to your application")
                    return
                }
                
                self.platformMasks.removeAll(keepingCapacity: true)
               
                for location in locations {
                    guard let mask = UEPlatformMask(location) else { continue }
                    self.platformMasks[mask.identifier] = mask
                }
                
                if (self.isDebugMode)
                {
                    let endTime = DispatchTime.now()
                    let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let elapsedTimeMicroseconds = elapsedTime / 1000
                    debugPrint("Time elapsed: \(elapsedTimeMicroseconds) microseconds")
                }
            }
        }
        return platformMasks.compactMap { $0.value }
    }
}
