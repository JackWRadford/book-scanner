//
//  PersistenceManager.swift
//  BookTracker
//
//  Created by Jack Radford on 08/04/2024.
//

import Foundation

enum PersistenceAction {
    case add, delete
}

struct PersistenceManager {
    
    static private let userDefaults = UserDefaults.standard
    
    enum Keys {
        static let toRead = "toRead"
    }
    
    
    /// Either add or remove the given book for the "To Read" UserDefaults.
    ///
    /// - Parameters:
    ///   - book: The Book to add or remove.
    ///   - actionType: The PersistenceAction.
    static func update(book: Book, actionType: PersistenceAction) throws {
        // Get the current "To Read" books.
        var toReadBooks = try getBooksToRead()
        // Add or delete.
        switch actionType {
        case .add:
            // Make sure that the book is not already in the "To Read" list.
            guard !toReadBooks.contains(where: { $0.id == book.id }) else { throw BTError.alreadyInToReadList }
            toReadBooks.append(book)
            
        case .delete:
            toReadBooks.removeAll { $0.id == book.id }
        }
        try save(toReadBooks: toReadBooks)
    }
    
    static func getBooksToRead() throws -> [Book] {
        guard let booksData = userDefaults.data(forKey: Keys.toRead) else { return []}
        do {
            let decoder = JSONDecoder()
            let books = try decoder.decode([Book].self, from: booksData)
            return books
        } catch {
            throw BTError.unableToGetToReadBooks
        }
    }
    
    static private func save(toReadBooks: [Book]) throws {
        do {
            let encoder = JSONEncoder()
            let encodedBooks = try encoder.encode(toReadBooks)
            userDefaults.set(encodedBooks, forKey: Keys.toRead)
        } catch {
            throw BTError.unableToSaveToReadBooks
        }
    }
}
