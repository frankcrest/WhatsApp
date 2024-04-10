//
//  ContentView.swift
//  WhatsApp
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = ChatsViewModel()
    
    let chats = Chat.sampleChats
    
    @State private var query = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.getSortedFilteredChats(query: query)) { chat in
                    //Hack to get rid of arrow
                    ZStack {
                        ChatRow(chat: chat)
                        NavigationLink {
                            ChatView(chat: chat)
                                .environmentObject(vm)
                        } label: {
                            EmptyView()
                        }
                        .buttonStyle(.plain)
                        .frame(width: 0)
                        .opacity(0)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            vm.markAsUnread(!chat.hasUnreadMessage, chat: chat)
                        }) {
                            if chat.hasUnreadMessage {
                                Label("Read", systemImage: "text.bubble")
                            } else {
                                Label("Unread", systemImage: "circle.fill")
                            }
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $query)
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
