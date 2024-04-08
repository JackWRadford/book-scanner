//
//  BTError.swift
//  BookTracker
//
//  Created by Jack Radford on 05/04/2024.
//

import Foundation

enum BTError: String, Error {
    case invalidURL = "Invalid URL."
    case unableToComplete = "Unable to complete your request."
    case invalidResponse = "Invalid response from the server."
    case invalidData = "The data recieved from the server was invalid."
    case unableToGetToReadBooks = "Your To Read list could not be fetched."
    case unableToSaveToReadBooks = "Your changes to the To Read list could not be saved."
    case alreadyInToReadList = "This book is already in your To Read list."
}
