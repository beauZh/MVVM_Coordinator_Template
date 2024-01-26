//
//  AppEnvironment.swift
//  MVVM_Coordinator_Template
//
//  Created by Bo Zhang on 2024-01-25.
//

import Foundation

final class AppEnvironment {
    
    private enum PlistKey: String {
        case appName = "CFBundleDisplayName"
        case appVersion = "CFBundleShortVersionString"
        case appBuild = "CFBundleVersion"
        case accessToken = "ACCESS_TOKEN"
        case apiHostname = "API_HOSTNAME"
        case imageHostname = "IMAGE_HOSTNAME"
        case dev = "DEV"
    }
    
    
    // use this if value stored in it infoDictionary
    private static func getValue(for key: PlistKey) -> String {
        return Bundle.main.infoDictionary![key.rawValue] as! String
    }
    
    static var baseURLString: String {
//        return "https://\(getValue(for: .apiHostname))/"
        return "https://\(AppUserDefault.baseURLString)/"
    }
    
    static var imageURLString: String {
//        return "https://\(getValue(for: .imageHostname))"
        return "https://\(AppUserDefault.imageURLString)/"
    }
    
//    static var appName : String {
//        return getValue(for: .appName)
//    }
    
//    static var versionString : String {
//        return getValue(for: .appVersion)
//    }
    
//    static var buildNumber : String {
//        return getValue(for: .appBuild)
//    }
    
    static var accessToken: String {
//        return "Bearer \(getValue(for: .accessToken))"
        return "Bearer \(AppUserDefault.accessToken)"
    }
    
}
