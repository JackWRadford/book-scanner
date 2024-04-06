//
//  Book.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import Foundation

struct Book: Codable, Hashable {
    let id: String
    let title: String
    let authors: [String]
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let averageRating: Double?
    let ratingsCount: Int?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
        case title
        case authors
        case publisher
        case publishedDate
        case description
        case pageCount
        case averageRating
        case ratingsCount
        case imageLinks
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let volumeInfoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        title = try volumeInfoContainer.decode(String.self, forKey: .title)
        authors = try volumeInfoContainer.decode([String].self, forKey: .authors)
        publisher = try? volumeInfoContainer.decode(String.self, forKey: .publisher)
        publishedDate = try? volumeInfoContainer.decode(String.self, forKey: .publishedDate)
        description = try? volumeInfoContainer.decode(String.self, forKey: .description)
        pageCount = try? volumeInfoContainer.decode(Int.self, forKey: .pageCount)
        averageRating = try? volumeInfoContainer.decode(Double.self, forKey: .averageRating)
        ratingsCount = try? volumeInfoContainer.decode(Int.self, forKey: .ratingsCount)
        
        let imageLinksContainer = try? volumeInfoContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        thumbnail = try? imageLinksContainer?.decode(String.self, forKey: .thumbnail)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        
        var volumeInfoContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        try volumeInfoContainer.encode(title, forKey: .title)
        try volumeInfoContainer.encode(authors, forKey: .authors)
        try volumeInfoContainer.encodeIfPresent(publisher, forKey: .publisher)
        try volumeInfoContainer.encodeIfPresent(publishedDate, forKey: .publishedDate)
        try volumeInfoContainer.encodeIfPresent(description, forKey: .description)
        try volumeInfoContainer.encodeIfPresent(pageCount, forKey: .pageCount)
        try volumeInfoContainer.encodeIfPresent(averageRating, forKey: .averageRating)
        try volumeInfoContainer.encodeIfPresent(ratingsCount, forKey: .ratingsCount)
        
        if let thumbnail = thumbnail {
            var imageLinksContainer = volumeInfoContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
            try imageLinksContainer.encode(thumbnail, forKey: .thumbnail)
        }
    }
}

