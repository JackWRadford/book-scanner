//
//  NetworkManager.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

struct NetworkManager {
    static let shared = NetworkManager()
    
    private let pageSize = 15
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q"
    
    private let cache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getBooks(for query: String) async throws -> [Book] {
        let endpoint = baseURL + query
        guard let url = URL(string: endpoint) else { throw BTError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw BTError.invalidResponse
        }
        
        do {
            return try decoder.decode([Book].self, from: data)
        } catch {
            throw BTError.invalidData
        }
    }
}
