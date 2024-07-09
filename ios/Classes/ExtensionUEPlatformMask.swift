//
//  ExtensionUEPlatformMask.swift
//  user_experior
//
//
//
import Foundation
import UserExperiorSDK
///
///
///
extension UEPlatformMask
{
    internal convenience init?(_ parameters: [String : String])
    {
        guard let identifier = parameters["i"] else { return nil }
        guard let xStr = parameters["x"] else { return nil }
        guard let yStr = parameters["y"] else { return nil }
        guard let wStr = parameters["w"] else { return nil }
        guard let hStr = parameters["h"] else { return nil }
        
        guard let x = Double(xStr) else { return nil }
        guard let y = Double(yStr) else { return nil }
        guard let w = Double(wStr) else { return nil }
        guard let h = Double(hStr) else { return nil }
        
        self.init(identifier: identifier, x: CGFloat(x), y: CGFloat(y), width: CGFloat(w), height: CGFloat(h))
    }
}
