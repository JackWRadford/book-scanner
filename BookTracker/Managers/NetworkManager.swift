//
//  NetworkManager.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import UIKit

struct NetworkManager {
    static let shared = NetworkManager()
    
    static let pageSize = 15
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q="
    
    private let decoder = JSONDecoder()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    /// Fetch books from the Google Books API
    /// - Parameters:
    ///   - query: The search string.
    ///   - page: The page number. Expected to start at 1.
    /// - Returns: The array of Books.
    func getBooks(for query: String, page: Int) async throws -> [Book] {
        let startIndex = 0 + ((page - 1) * NetworkManager.pageSize)
        let endpoint = baseURL + "\(query)&maxResults=\(NetworkManager.pageSize)&startIndex=\(startIndex)"
        guard let url = URL(string: endpoint) else { throw BTError.invalidURL }
        
        print("NetworkManager.getBooks()")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw BTError.invalidResponse
        }
        
        do {
            return try decoder.decode(BookItemsResponse.self, from: data).items ?? []
        } catch {
            print(error.localizedDescription)
            throw BTError.invalidData
        }
    }
    
    func getBook(forISBN isbn: String) async throws -> Book? {
        let query = "isbn:\(isbn)"
        return try await getBooks(for: query, page: 1).first
    }
    
    func getThumbnail(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        // check cache for the image
        if let image = cache.object(forKey: cacheKey) { return image }
        
        // Replace "http://" with "https://"
        let secureURLString = urlString.replacingOccurrences(of: "http://", with: "https://")
        
        // fetch the image if it is not in cache
        guard let url = URL(string: secureURLString) else { return nil }
                
        do {
            print("NetworkManager.getThumbnail()")
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            // cache the image
            self.cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}

// MARK: - Response struct

extension NetworkManager {
    
    /// The response JSON data from the Google Books API
    struct BookItemsResponse: Codable {
        let totalItems: Int
        /// Note: The Google Books API omits the items property if there are not results
        let items: [Book]?
    }
}
