//
//  UIImageView.swift
//  tMDBMovies
//
//  Created by Alagarsamy on 07/02/26.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadTMDBImage(path: String, placeholder: UIImage? = nil, size: String = "w342") {
        self.image = placeholder
        
        let baseURL = Constants.posterBaseURL
        let fullPath = baseURL + size + path
        
        if let cachedImage = imageCache.object(forKey: fullPath as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: fullPath) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            imageCache.setObject(image, forKey: fullPath as NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
