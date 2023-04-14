//
//  LoginVM.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var user = ""
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty
    }
    func login(completion: @escaping (Bool) -> Void) {
        showProgressView = true
        loginService.shared.login(credentials: credentials) { [unowned self](result:Result<Bool, Authentication.AuthenticationError>) in

            DispatchQueue.main.async {
                self.user  = self.credentials.email
                self.showProgressView = false
                switch result {
                case .success:
                    completion(true)
                case .failure(let authError):
                    self.credentials = Credentials()
                    self.error = authError
                    completion(false)
                }
            }
        }
    }
    
//    func logout (completion: @escaping (Bool) -> Void){
//        showProgressView = true
//        loginService.shared.logout(user: user) { [unowned self](result:Result<Bool, Authentication.AuthenticationError>) in
//            DispatchQueue.main.async {
//                self.user  = ""
//                self.showProgressView = false
//                switch result {
//                case .success:
//                    completion(true)
//                case .failure(let authError):
//                    self.credentials = Credentials()
//                    self.error = authError
//                    completion(false)
//                }
//            }
//        }
//    }
//    
}
