//
//  ChatView.swift
//  WhatsApp
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatsViewModel
    let chat: Chat
    
    @State private var text = ""
    @FocusState private var isFocused
    
    var body: some View {
        VStack(spacing: 0, content: {
            GeometryReader { reader in
                ScrollViewReader { proxy in
                    ScrollView {
                        getMessagesView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: viewModel.lastMessageId, perform: { _ in
                                print("DEBUG view model: \(viewModel.lastMessageId)")
                                print("DEBUG view model: \(String(describing: viewModel.lastMessage))")
                                scrollTo(messageID: viewModel.lastMessageId, shouldAnimate: true, scrollReader: proxy)
                            })
                            .onAppear(perform: {
                                if let messageID = chat.messages.last?.id {
                                    scrollTo(messageID: messageID, shouldAnimate: false, scrollReader: proxy)
                                }
                            })
                    }
                }
            }
            .padding(.bottom, 5)
            
            toolbarView()
        })
        .padding(.top, 1)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text(chat.person.name).bold()
                }
                .tint(.primary)

            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "video")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "phone")
                }

            }
        }
        .onAppear {
            viewModel.markAsUnread(false, chat: chat)
        }
    }
    
    func scrollTo(messageID: String, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
        let delay = shouldAnimate ? 0.05 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(shouldAnimate ? .easeIn : nil) {
                scrollReader.scrollTo(messageID, anchor: .bottom)
            }
        }
    }
    
    func toolbarView() -> some View {
        VStack {
            let height: CGFloat = 37
            HStack {
                TextField("Message...", text: $text)
                    .padding(.horizontal, 10)
                    .frame(height: height)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocused)
                
                Button (action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .frame(width: height, height: height)
                        .background(
                            Circle()
                                .foregroundStyle(text.isEmpty ? .gray : .blue)
                        )
                }
                .disabled(text.isEmpty)
            }
            .frame(height: height)
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(.thickMaterial)
    }
    
    func sendMessage() {
        if let message = viewModel.sendMessage(text, in: chat) {
            text = ""
            viewModel.lastMessageId = message.id
        }
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    func getMessagesView(viewWidth: CGFloat) -> some View {
        LazyVGrid(columns: columns, pinnedViews: [.sectionHeaders], content: {
            let sectionMessages = viewModel.getSectionMessages(for: chat)
            ForEach(sectionMessages.indices, id: \.self) { sectionIndex in
                let messages = sectionMessages[sectionIndex]
                Section(header: sectionHeader(firstMessage: messages.first!)) {
                    ForEach(messages) { message in
                        let isReceived = message.type == .Received
                        HStack {
                            ZStack {
                                Text(message.text)
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(isReceived ? Color.black.opacity(0.2) : .green.opacity(0.9))
                                    .cornerRadius(13)
                            }
                            .frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing)
                            .padding(.vertical)
                        }
                        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
                        .id(message.id) // important for auto scrolling
                    }
                }
            }
        })
    }
    
    func sectionHeader(firstMessage message: Message) -> some View {
        ZStack {
            Text(message.date.descriptiveString(dateStyle: .medium))
                .foregroundStyle(.primary)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120)
                .padding(.vertical, 5)
                .background(Capsule().foregroundStyle(.blue))
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ChatView(chat: Chat.sampleChats[0])
        .environmentObject(ChatsViewModel())
}
