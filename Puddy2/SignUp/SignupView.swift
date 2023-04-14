//
//  Signup.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/8/23.

import SwiftUI
import RiveRuntime
struct SignUpView: View {
    @StateObject private var signUpVM = SignUpViewModel()
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var wrongConfirmPassword: Float = 0
    @State private var showingSignUpScreen = false
    @State var showVerification = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
//            Color.green
//                .ignoresSafeArea()
//            Circle()
//                .scale(1.7)
//                .foregroundColor(.white.opacity(0.15))
//            Circle()
//                .scale(1.35)
//                .foregroundColor(.white)
//            RiveViewModel(fileName: "shapes").view()
//                .ignoresSafeArea()
//                .blur(radius: 30)
//                .background(
//                    Image("Spline")
//                        .blur(radius: 50)
//                        .offset(x:200, y: 100)
//                )
//            let gradient = Gradient(colors: [Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))])
//            let linearGradient = LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
//            Circle()
//                .fill(linearGradient)
//                .frame(width: 600, height: 600)
//                .shadow(color: Color(#colorLiteral(red: 1, green: 0.9215698242, blue: 0.5450980663, alpha: 0.8)), radius: 20, x: 0, y: 0)
//                .overlay(Circle().stroke(linearGradient, lineWidth: 5))
//                .blur(radius: 20)
//                .offset(y:520)
//            Circle()
//                .fill(linearGradient)
//                .frame(width: 200, height: 200)
//                .shadow(color: Color(#colorLiteral(red: 1, green: 0.9215698242, blue: 0.5450980663, alpha: 0.8)), radius: 20, x: 0, y: 0)
//                .overlay(Circle().stroke(linearGradient, lineWidth: 5))
//                .blur(radius: 20)
//                .offset(x:200, y:-400)
            VStack {
                Text("Sign Up")
                    .font(.custom("Poppins Bold", size: 40, relativeTo: .largeTitle))
                    .bold()
                    .padding()
                    .foregroundColor(Color.white)
                TextField("Email Address", text: $signUpVM.credentials.email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongUsername))
                
                SecureField("Password", text: $signUpVM.credentials.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongPassword))
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongConfirmPassword))
                
                Button("Sign Up") {
                        withAnimation(.spring()){
                            showVerification = true;
                        }
                }
//                .disabled(signUpVM.signUpDisabled)
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
            if !showVerification {
                VerificationCodeView()
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .ignoresSafeArea(.all, edges: .bottom)
                    .shadow(color: .black.opacity(0.5), radius: 40, x: 0 , y : -40)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .overlay(
                        Button {
                            withAnimation(.spring()){
                                showVerification = false
                            }
                        } label: {
                            Image(systemName:"arrow.backward")
                                .frame(width: 36, height: 36 )
                                .foregroundColor(.white)
                                .background(.black)
                                .mask(Circle())
                                .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 10)
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(20)
                    )
                    .zIndex(2)
            }
        }
    }
}


struct VerificationCodeView: View {
    @StateObject private var signUpVM = SignUpViewModel()
    
    @State private var username = ""
    @State private var textFieldText = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var wrongConfirmPassword: Float = 0
    @State private var showingSignUpScreen = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                Text("Verification")
                    .font(.custom("Poppins Bold", size: 30, relativeTo: .title3))
                    .bold()
                    .padding()
                    .foregroundColor(Color.black)
                TextField("", text: $textFieldText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .frame(width: 200, height: 65)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    .onChange(of: textFieldText) { newValue in
                        // Limit input to 6 digits
                        let sanitizedValue = newValue.filter(\.isNumber).prefix(6)
                        textFieldText = String(sanitizedValue)
                    }

                Button("Sign Up") {
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(30)
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
