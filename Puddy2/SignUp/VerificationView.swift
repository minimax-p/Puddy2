//
//  VerificationView.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/14/23.
//

import SwiftUI
import RiveRuntime

struct VerificationCodeView: View {
    @StateObject private var signUpVM = SignUpViewModel()
    @State var code = ""
    @State var isLoading = false
    let check  = RiveViewModel(fileName: "check", stateMachineName: "State Machine 1")
    
    
    
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
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .frame(width: 200, height: 65)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    .onChange(of: code) { newValue in
                        // Limit input to 6 digits
                        let sanitizedValue = newValue.filter(\.isNumber).prefix(6)
                        code = String(sanitizedValue)
                    }
                HStack{
                    Text("Didn't receive the code?")
                        .font(.custom("Inter Regular", size: 15, relativeTo: .body))
                    Text("Send another one")
                    .font(.custom("Inter SemiBold", size: 15, relativeTo: .body))
                        .foregroundColor(.gray)
                        .onTapGesture {
                        }
                }
                .padding(.top, 10)
                Button {
                   check.triggerInput("Check")
                } label: {
                    Label("VERIFY", systemImage: "checkmark.shield.fill")
                        .font(.custom("Inter SemiBold", size: 15, relativeTo: .title2))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(10)
                }
//                .font(.custom("Inter SemiBold", size: 15, relativeTo: .title2))
//                .foregroundColor(.white)
//                .frame(width: 200, height: 50)
//                .background(Color.blue)
//                .cornerRadius(10)
//                .padding(10)
            }
            .autocapitalization(.none)
            .padding()
            .disabled(signUpVM.showProgressView)
            .offset()
            .alert(item: $signUpVM.error) { error in
                Alert(title: Text("Invalid Sign Up"), message:
                    Text(error.localizedDescription))
            }
            .overlay (check.view()
                .frame(width: 100, height: 100)
                .allowsHitTesting(false))
            
            if signUpVM.showProgressView {
//                .overlay (check.view())
//                Color.black.opacity(0.5)
//                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    ProgressView()
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 10)
//                }
            }
        }
    }
}
struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView()
    }
}
