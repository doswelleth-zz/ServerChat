//
//  Extensions.swift
//  serverchat
//
//  Created by David Oliver Doswell on 1/24/18.
//  Copyright © 2018 David Oliver Doswell. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data!)
                }
            }
        }).resume()
    }
}


let now = Date()
let pastDate = Date(timeIntervalSinceNow: -60)

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self as Date))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            print("POSTED \(secondsAgo)")
            return "\(secondsAgo)"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute)"
        } else if secondsAgo < day {
            return "\(secondsAgo < hour)"
        } else if secondsAgo < week {
            return "\(secondsAgo / day)"
        }
        return "\(secondsAgo / week)"
    }
    
}









