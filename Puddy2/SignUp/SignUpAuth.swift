//
//  SignUpAuth.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/10/23.
//

import SwiftUI
import Foundation

class Verification : ObservableObject {
    @Published var isVerified = false
    
    enum VerificationError: Error, LocalizedError, Identifiable {
        case invalidEmail
        case noMatch
        case networkError
        case invalidResponse
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case.invalidEmail:
                return NSLocalizedString("Please enter a valid email.", comment: "")
            case.noMatch:
                return NSLocalizedString("Passwords don't match.", comment: "")
            case.networkError: // add a networkError description
                return NSLocalizedString("A network error occurred. Please try again later.", comment: "")
            case .invalidResponse: // add an invalidResponse description
                            return NSLocalizedString("The server's response was invalid. Please try again later.", comment: "")
            }
        }
    }
    func isVerified(success: Bool) {
        withAnimation {
            isVerified = success
        }
    }
}

class signUpService {
    
    //communitcate with the server for sign up logic
    static let shared = signUpService()

    func signup(credentials: SUCredentials,
               completion: @escaping (Result<Bool, Verification.VerificationError>) -> Void) {
        print(credentials.email)
        let url = URL(string: "https://health.northernhorizon.org/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: Any] = ["email": credentials.email, "password": credentials.password, "confirmpassword":credentials.confirmPassword]
        let jsonData = try! JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }
            do {
                //response is a json object that is defined as {message: response}
                //check response if successful + show error if theres error(s) e.g. password don't match, email is not valid, etc.
                //calls the server and send the code that the user enters
                //the server will compare the two code and return a message that is either successful or fail
                //
                //get function: your computer ask the server for data
                //post function: your computer give the data to the server, response with something that is related to the data
                
                
                
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    completion(message == "successful" ? .success(true) : .failure(.invalidEmail))
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

