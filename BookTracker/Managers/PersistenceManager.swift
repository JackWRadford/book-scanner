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
    
    static func update(book: Book, actionType: PersistenceAction) -> BTError? {
        let toReadBooksResult = getBooksToRead()
        switch toReadBooksResult {
        case .success(var toReadBooks):
            return addOrDelete(book: book, in: &toReadBooks, for: actionType)
            
        case .failure(let error):
            return error
        }
    }
    
    static private func addOrDelete(book: Book, in toReadBooks: inout [Book], for actionType: PersistenceAction) -> BTError? {
        switch actionType {
        case .add:
            // Make sure that the books is not already in the To Read list.
            guard !toReadBooks.contains(book) else { return .alreadyInToReadList }
            toReadBooks.append(book)
            
        case .delete:
            toReadBooks.removeAll { $0.id == book.id }
        }
        return save(toReadBooks: toReadBooks)
    }
    
    static func getBooksToRead() -> Result<[Book], BTError> {
        guard let booksData = userDefaults.data(forKey: Keys.toRead) else { return .success([])}
        do {
            let decoder = JSONDecoder()
            let books = try decoder.decode([Book].self, from: booksData)
            return .success(books)
        } catch {
            return .failure(BTError.unableToGetToReadBooks)
        }
    }
    
    static private func save(toReadBooks: [Book]) -> BTError? {
        do {
            let encoder = JSONEncoder()
            let encodedBooks = try encoder.encode(toReadBooks)
            userDefaults.set(encodedBooks, forKey: Keys.toRead)
            return nil
        } catch {
            return .unableToSaveToReadBooks
        }
    }
}
