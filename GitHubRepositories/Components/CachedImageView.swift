//
//  CachedImageView.swift
//  GitHubRepositories
//
//  Created by Luka Alimbarashvili on 31.12.25.
//

import UIKit

/// UIImageView subclass that downloads images asynchronously
/// and caches them in memory to avoid repeated network calls.
/// Designed to use in tableView cells to improve
/// scrolling performance during image loading.
final class CachedImageView: UIImageView {
    
    private static let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        image = placeholder
        guard let url = URL(string: urlString) else { return }
        
        // Use cached image if available
        if let cached = Self.cache.object(forKey: url as NSURL) {
            image = cached
            return
        }
        
        // Fetch from network
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            Self.cache.setObject(image, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    func reset() {
        image = nil
    }
}
