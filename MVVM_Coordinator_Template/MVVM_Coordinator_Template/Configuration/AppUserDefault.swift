//
//  AppUserDefault.swift
//  MVVM_Coordinator_Template
//
//  Created by Bo Zhang on 2024-01-25.
//

import Foundation

// Accessable property in UserDefault
public struct AppUserDefault {
    
    private init() {}
    
    @UserDefault(key: "user_region", defaultValue: Locale.current.region?.identifier ?? "US")
    public static var region: String
    
    @UserDefault(key: "base_URL_string", defaultValue: "api.themoviedb.org")
    public static var baseURLString: String
    
    @UserDefault(key: "image_base_URL_string", defaultValue: "image.tmdb.org")
    public static var imageURLString: String
    
    @UserDefault(key: "access_token",
                 defaultValue: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOWM1YmFmNGRmOWJjNTUxY2VmMTViMDk0NGRhNjY4NCIsInN1YiI6IjYxMjViNWUxOTQ0YTU3MDAyY2QwM2IyMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qpKsPxmt6JzPtyhCJvrOvnC873TiwxPkm1nHdF1x0AM")
    public static var accessToken: String
    
}

// Used for get/set value in UserDefault
@propertyWrapper
public struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}


