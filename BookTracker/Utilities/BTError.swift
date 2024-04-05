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
}
