//
//  Authentication.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import Foundation
import SwiftUI

class Authentication : ObservableObject {
    @Published var isValidated = false
    @Published var user = "";
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case networkError
        case invalidResponse
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Either your email or password are incorrect. Please try again", comment: "")
            case .networkError:
                return NSLocalizedString("There was an error connecting to the server. Please check your internet connection and try again", comment: "")
            case .invalidResponse:
                return NSLocalizedString("The server returned an invalid response. Please try again later or contact customer support", comment: "")
            }
        }
    }
    func updateUser (username: String){
        DispatchQueue.main.async{
            self.user = username;
        }
    }
    func getUser() -> String {
        return user
    }
    func updateValidation(success: Bool) {
        withAnimation {
            DispatchQueue.main.async{
                self.isValidated = success
            }
        }
    }
}
class loginService {
    static let shared = loginService()
    
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {
        let url = URL(string: "https://health.northernhorizon.org/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: Any] = ["username": credentials.email, "password": credentials.password]
        let jsonData = try! JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let isLoggedIn = json?["message"] as? String {
                    completion(isLoggedIn == "success" ? .success(true) : .failure(.invalidCredentials))
                } else {
                    completion(.failure(.invalidResponse)) // handle invalid response
                }
            } catch {
                completion(.failure(.invalidResponse)) // handle invalid response
            }
        }
        task.resume()
    }
    func logout(user: String, completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {
        let url = URL(string: "https://health.northernhorizon.org/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: Any] = ["username": user]
        let jsonData = try! JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    completion(message == "success" ? .success(true) : .failure(.invalidResponse))
                } else {
                    completion(.failure(.invalidResponse)) // handle invalid response
                }
            } catch {
                completion(.failure(.invalidResponse)) // handle invalid response
            }
        }
        task.resume()
    }
    
}
