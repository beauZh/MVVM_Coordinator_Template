//
//  MTCache.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-06.
//

import UIKit

actor CacheManager {
    static let shared = CacheManager()
    private init(){}
    
    private var cache:  NSCache<NSString, UIImage> {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 300
        return cache
    }
    
    func getImage(for path: String) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: path)) {
            return image
        }
        return nil
    }
    
    func setImage(for path: String, with image: UIImage) {
        cache.setObject(image, forKey: NSString(string: path))
    }
    
    func removeImage(for path: String) {
        cache.removeObject(forKey: NSString(string: path))
    }
    
    func cleanCache() {
        cache.removeAllObjects()
    }
    
}
