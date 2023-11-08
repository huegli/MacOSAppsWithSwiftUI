//
//  ApiCall.swift
//  SimplePhotos
//
//  Created by Nikolai Schlegel on 11/7/23.
//

import Foundation

class ApiCall {
    static func getPhotos(completion:@escaping ([Photo]) -> ()) {
        let getPhotosUrlString = "https://jsonplaceholder.typicode.com/photos"
        guard let url = URL(string: getPhotosUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let photos = try?
                    JSONDecoder().decode([Photo].self, from: data) {
                    DispatchQueue.main.async {
                        completion(photos)
                    }
                    return
                }
            }
            print(
                "Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
