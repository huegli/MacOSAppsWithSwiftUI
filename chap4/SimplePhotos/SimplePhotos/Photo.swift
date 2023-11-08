//
//  Photo.swift
//  SimplePhotos
//
//  Created by Nikolai Schlegel on 11/7/23.
//

import Foundation

struct Photo: Codable, Hashable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
