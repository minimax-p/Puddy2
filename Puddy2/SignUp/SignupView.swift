//
//  Signup.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/8/23.

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpVM = SignUpViewModel()

    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var wrongConfirmPassword: Float = 0
    @State private var showingSignUpScreen = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
//            Color.green
//                .ignoresSafeArea()
//            Circle()
//                .scale(1.7)
//                .foregroundColor(.white.opacity(0.15))
//            Circle()
//                .scale(1.35)
//                .foregroundColor(.white)
            
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Email Address", text: $signUpVM.credentials.email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongUsername))
                
                SecureField("Password", text: $signUpVM.credentials.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongPassword))
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongConfirmPassword))
                
                Button("Sign Up") {
                    signUpVM.signUp { success in

                    }
                }
                .disabled(signUpVM.signUpDisabled)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .autocapitalization(.none)
            .padding()
            .disabled(signUpVM.showProgressView)
            .offset()
            .alert(item: $signUpVM.error) { error in
                Alert(title: Text("Invalid Sign Up"), message:
                    Text(error.localizedDescription))
            }
            if signUpVM.showProgressView {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ProgressView()
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
        }
    }
}
struct ContentVieww_Previews: PreviewProvider {
    static var previews: some View {
            SignUpView()
    }
}
