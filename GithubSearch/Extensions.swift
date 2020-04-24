//
//  Extensions.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    /// Sets the imageView's image property with an image from a URL. Temporarily stores sets the image to a
    /// system icon as a placeholder. It checks if the image has been pre-cached, if not it will download it and save it to the cache
    ///
    /// - Parameter string: The string URL of the image
    func setImageURL(string: String?) {
        self.backgroundColor = .lightGray
        self.image = UIImage(systemName: "photo")?.withTintColor(.white)
        self.contentMode = .center
//        self.layer.cornerRadius = self.frame.height / 2
        guard let string = string else { return }
        guard let url = URL(string: string) else { return }
        
        var resultImage: UIImage?
        
        DispatchQueue.global().async { [weak self] in
            // if image is in cache set the image
            if let image = UsersManager.getImage(forKey: string) {
                resultImage = image
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                // otherwise get downloaded image
                UsersManager.cacheImage(image: image, forKey: string)
                resultImage = image
            }
            
            DispatchQueue.main.async {
                self?.image = resultImage
                self?.contentMode = .scaleAspectFit
                self?.backgroundColor = .clear
                self?.layer.cornerRadius = (self?.frame.height ?? 0) / 2
            }
        }
    }
}

extension String {

    func toDate(withFormat format: String = "yyyy-MM-ddThh:mm:ssZ")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {

    func toString(withFormat format: String = "MMMM d, yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
