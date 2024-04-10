//
//  ChatsViewModel.swift
//  WhatsApp
//
//  Created by Frank Chen on 2024-04-01.
//

import Foundation

class ChatsViewModel: ObservableObject {
    
    @Published var chats = Chat.sampleChats
    @Published var lastMessageId = ""
    @Published var lastMessage: Message?
    
    func getSortedFilteredChats(query: String) -> [Chat] {
        let sorted = chats.sorted {
            guard let date1 = $0.messages.last?.date else { return false }
            guard let date2 = $1.messages.last?.date else { return false }
            return date1 > date2
        }
        
        if query ==  "" {
            return sorted
        }
        
        return sorted.filter({ $0.person.name.lowercased().contains(query.lowercased()) })
    }
    
    func getSectionMessages(for chat:Chat) -> [[Message]] {
        var res = [[Message]]()
        var tmp = [Message]()
        for message in chat.messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date)
                if daysBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                } else {
                    tmp.append(message)
                }
            } else {
                tmp.append(message)
            }
        }
        res.append(tmp)
        return res
    }
    
    func markAsUnread(_ newValue: Bool, chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }){
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    func sendMessage(_ text: String, in chat: Chat) -> Message? {
        if let index = chats.firstIndex(where: { $0.id == chat.id}) {
            let message = Message(text, type: .Sent)
            chats[index].messages.append(message)
            lastMessageId = message.id
            lastMessage = message
            return message
        }
        return nil
    }
}
