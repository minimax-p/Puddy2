//
//  SignupVM.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/8/23.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var credentials = SUCredentials()
    @Published var showProgressView = false
    @Published var error: Verification.VerificationError?
    @Published var user = ""

    var signUpDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty || credentials.confirmPassword.isEmpty
    }

    func signUp(completion: @escaping (Bool) -> Void) {
        guard credentials.password == credentials.confirmPassword else {
            error = .noMatch
            completion(false)
            return
        }
        user = credentials.email
        showProgressView = true
        signUpService.shared.signup(credentials: credentials) { [unowned self](result:Result<Bool, Verification.VerificationError>) in
            showProgressView = false
            switch result {
            case .success:
                completion(true)
            case .failure(let authError):
                credentials = SUCredentials()
                error = authError
                completion(false)
            }
        }
    }
}

