//
//  Book.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import Foundation

struct Book: Codable {
    let id: String
    let title: String
    let authors: [String]
    let publisher: String
    let publishedDate: String
    let description: String
    let pageCount: Int
    let averageRating: Double
    let ratingsCount: Int
    let thumbnail: String
}
