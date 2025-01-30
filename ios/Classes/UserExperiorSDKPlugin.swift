//
//  UserExperiorSDKPlugin.swift
//  user_experior
//
//
//
import Foundation
import UserExperiorSDK
import Flutter

class UEPlatformPluginView {
    internal var locations: [String: UEPlatformMask]
    internal var encodedImage: Data
    internal var wireframe: String

    // Default initializer
    convenience init() {
        self.init(locations: [:], image: Data(), wireframe: "")
    }

    // Custom initializer
    init(locations: [String: UEPlatformMask], image: Data, wireframe: String) {
        self.locations = locations
        self.encodedImage = image
        self.wireframe = wireframe
    }
}

public class UserExperiorSDKPlugin : NSObject, UEPlatformPluginInterface
{
    // MARK: - Attributes
    private  var recordingAllowed : Bool
    internal var methodChannel    : FlutterMethodChannel
    internal var pluginView       : UEPlatformPluginView
    internal var isDebugMode      : Bool

    // MARK: - Constructors
    init(method channel: FlutterMethodChannel, recordingAllowed: Bool)
    {
        self.recordingAllowed = recordingAllowed
        self.methodChannel = channel
        self.pluginView    = UEPlatformPluginView()
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
            
            channel.invokeMethod("fetchFlutterData", arguments: ["mode": "basic"]) { (result) in
                
                guard let payload = result as? [String: Any] else {
                    print( "Error occurred on MaskedLocations, please submit a bug. Or check that you have added UEMarker Widget to your application")
                    return
                }
                
                guard let locations = payload["locations"] as? Array<Dictionary<String, String>> else {
                    print( "Error occurred on MaskedLocations, please submit a bug. Or check that you have added UEMarker Widget to your application")
                    return
                }
                
                self.pluginView.locations.removeAll(keepingCapacity: true)
               
                for location in locations {
                    guard let mask = UEPlatformMask(location) else { continue }
                    self.pluginView.locations[mask.identifier] = mask
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
        return pluginView.locations.compactMap { $0.value }
    }
}
