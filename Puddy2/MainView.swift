//
//  MainView.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import SwiftUI
import Foundation
struct ContentView: View {
    @StateObject var messagesManager = MessagesManager()
    @EnvironmentObject var authentication: Authentication
    
    var name = "Puddy"
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
                            Text(name)
                                .font(.title).bold()
                        }
                        Spacer()
                        ZStack(alignment: .trailing) {
                            Button(action: {
                                
//                                authentication.updateValidation(success: false)
//                                authentication.updateUser(username: "")
                            }) {
                                Text("Log Out")
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
                    LinearGradient(
                        gradient: Gradient(colors: [Color("Beige"), Color("Silver")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
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





//COMPONENTS
struct TitleRow: View {
    var bearImage = Image("Nurse Bear")
    var body: some View {
        HStack(spacing: 10){
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                bearImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .padding(.top, 38) // shift the image down by adding padding to the top
                    .scaleEffect(1.4) // zoom in on the image by scaling it up
                    .clipShape(Circle())

            }

            VStack (alignment: .leading){
                Text(name)
                    .font(.title).bold()
                
            }
            
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    var name = "Puddy"
}

struct MessageBubble: View {
    var message: Message
    @State private var showTime = false
    var body: some View {
        VStack(alignment:message.isUser ? .trailing : .leading){
            HStack{
                Text(message.text)
                    .padding()
                    .background(message.isUser ?
                                Color.blue : Color("Brown Gold"))
                    .foregroundColor(Color.white)
                    .cornerRadius(30, corners: message.isUser ? [.bottomLeft, .topLeft, .topRight] : [.bottomRight, .topLeft, .topRight])
            }
            .frame(maxWidth:300, alignment: message.isUser ?
                .trailing : .leading)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.isUser ? .trailing : .leading, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment:
                    message.isUser ? .trailing : .leading)
        .padding(message.isUser ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
}
struct MessageField: View {
    @EnvironmentObject var messagesManager: MessagesManager
    @State private var message = ""
    var username: String
    var body: some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)

            Button {
                messagesManager.sendMessage(text: message, username: username)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        Color.blue
//                        Gradient(colors: [Color("Reu").opacity(0.6), Color.green.opacity(0.8)])
                    )
                    .cornerRadius(50)
            }
        
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("Grayy"))
        .cornerRadius(50)
        .padding()
    }
}
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct WaitingBubble: View {
    @State private var dotScale: CGFloat = 1
    @State private var isShowing: Bool = false

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading){
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .scaleEffect(dotScale)
                        .frame(width: 8, height: 8)
                        .foregroundColor(.white)
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .delay(Double(index) * 0.2),
                            value: dotScale
                        )
                }
            }
            .onReceive(timer) { _ in
                withAnimation {
                    dotScale = dotScale == 1 ? 0.7 : 1
                }
            }
            .frame(maxWidth: 40, maxHeight: 15, alignment: .leading)
            .padding(10)
            .background(Color("Brown Gold"))
            .cornerRadius(20)
            .opacity(isShowing ? 1 : 0)
            .animation(.easeIn(duration: 0.5), value: isShowing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
        .padding(.horizontal, 10)
        .onAppear {
            withAnimation {
                isShowing = true
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            WaitingBubble()
    }
}
