//
//  APIError.swift
//  TheMovieDB
//
//  Created by Segundo Fariña on 10/03/2023.
//
import Foundation

enum APIError: Error {
  case invalidLoginCredentials
  case invalidResponse
  case decodingError
}

extension APIError: LocalizedError {
  public var errorDescription: String? {
         switch self {
         case .invalidResponse:
             return NSLocalizedString("Error de conexión con el servidor", comment: "")
         case .invalidLoginCredentials:
            return NSLocalizedString("Usuario y contraseña invalidos", comment: "")
         case .decodingError:
           return NSLocalizedString("Error de decodificación", comment: "")
        }
     }
}
