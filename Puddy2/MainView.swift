//
//  MainView.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import SwiftUI
import Foundation
import RiveRuntime

struct ContentView: View {
    @StateObject var messagesManager = MessagesManager()
    @EnvironmentObject var authentication: Authentication
    
    var bearImage = Image("Nurse Bear")
    var body: some View {
        NavigationView{
            VStack {
                VStack {
                    HStack(spacing: 10){
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                            bearImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                        }
                        VStack (alignment: .leading){
                            Text("Puddy")
                                .font(.custom("Poppins Bold", size: 30, relativeTo: .largeTitle))
                        }
                        Spacer()
                        ZStack(alignment: .trailing) {
                            Button(action: {
                                loginService.shared.clear(username: authentication.user)
                                //                                loginService.shared.logout(user: authentication.user)
                                //                                authentication.updateValidation(success: false)
                                //                                authentication.updateUser(username: "")
                            }) {
                                Text("Clear Chat")
                                    .font(.custom("Inter SemiBold", size: 15, relativeTo: .title2))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(messagesManager.messages, id: \.id) { message in
                                MessageBubble(message: message)
                            }
                            if messagesManager.showWaitingBubble {
                                WaitingBubble()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .padding(.top, 10)
                        .background(.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .onChange(of: messagesManager.lastMessageId) { id in
                            // When the lastMessageId changes, scroll to the bottom of the conversation
                            withAnimation {
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(
                    Color("Silver")
                )
                MessageField(username: "\(authentication.getUser())")
                    .environmentObject(messagesManager)
            }
        }
    }
}

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//struct ContentView: View {
//    @StateObject var messagesManager: MessagesManager
////    let chat: Chat
////
////    init(chat: Chat) {
////        self.chat = chat
////        self._messagesManager = StateObject(wrappedValue: MessagesManager())
////    }
//
//    var body: some View {
//        VStack {
//            VStack {
//                TitleRow()
//
//                ScrollViewReader { proxy in
//                    ScrollView {
//                        ForEach(messagesManager.messages, id: \.id) { message in
//                            MessageBubble(message: message)
//                        }
//                    }
//                    .padding(.top, 10)
//                    .background(.white)
//                    .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
//                    .onChange(of: messagesManager.lastMessageId) { id in
//                        // When the lastMessageId changes, scroll to the bottom of the conversation
//                        withAnimation {
//                            proxy.scrollTo(id, anchor: .bottom)
//                        }
//                    }
//                }
//            }
//            .background(Color("Bluee"))
//            MessageField()
//                .environmentObject(messagesManager)
//        }
//    }
//}

//CHAT SELECTION MENU
//struct ChatSelectionView: View {
//    @StateObject var chatManager = ChatManager()
//
//    var body: some View {
//        NavigationView {
//            List(chatManager.chats) { chat in
//                NavigationLink(destination: ContentView(chat: chat)) {
//                    ChatRow(chat: chat)
//                }
//            }
//            .navigationTitle("Chats")
//        }
//        .onAppear {
//            chatManager.fetchChats()
//        }
//    }
//}
//
//
//
//struct ChatRow: View {
//    let chat: Chat
//
//    var body: some View {
//        HStack {
//            Image(systemName: "message.fill")
//                .foregroundColor(.blue)
//                .padding(.trailing)
//            VStack(alignment: .leading) {
//                Text(chat.name)
//                    .font(.headline)
//
//            }
//        }
//    }
//}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
