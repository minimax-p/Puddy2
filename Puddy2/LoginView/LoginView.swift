//
//  LoginView.swift
//  Puddy2
//
//  Created by iMacBig03 on 3/31/23.
//

import SwiftUI
struct BrownGoldProgressViewStyle: ProgressViewStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .progressViewStyle(CircularProgressViewStyle(tint: color))
    }
}

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject var authentication: Authentication
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @State var showSignUp = false
    var body: some View {
        
        ZStack {
            Color.brown
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)

            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Email Address", text: $loginVM.credentials.email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(.black.opacity(0.03))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongUsername))
                SecureField("Password", text: $loginVM.credentials.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(.black.opacity(0.03))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongPassword))
                Button("Log in") {
                    loginVM.login { success in
                        authentication.updateUser(username: loginVM.user)
                        authentication.updateValidation(success: success)
                    }
                }
                .disabled(loginVM.loginDisabled)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                HStack {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                                    withAnimation(.spring()){
                                        showSignUp = true;
                                    }
                                }
                            }
                    }
                    .padding(.top, 20)
            }
            .autocapitalization(.none)
            .padding()
            .disabled(loginVM.showProgressView)
            .alert(item: $loginVM.error) { error in
            Alert(title: Text("Invalid Login"), message:
                Text(error.localizedDescription))
            }
            if showSignUp {
                SignUpView()
//                    .offset(y: showSignUp ?  -10 : 0)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .ignoresSafeArea(.all, edges: .bottom)
                    .shadow(color: .black.opacity(0.5), radius: 40, x: 0 , y : -40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .overlay(
                        Button {
                            withAnimation(.spring()){
                                showSignUp = false
                            }
                        } label: {
                            Image(systemName:"xmark")
                                .frame(width: 36, height: 36 )
                                .foregroundColor(.white)
                                .background(.black)
                                .mask(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(20)
                    )
                    .zIndex(1)
            }
            if loginVM.showProgressView {

                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        ProgressView()
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .progressViewStyle(BrownGoldProgressViewStyle(color: Color("Brown Gold")))
                    }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
