//
//  ChatModel.swift
//  WhatsApp
//
//  Created by Frank Chen on 2024-04-01.
//

import Foundation

struct Chat: Identifiable {
    var id: UUID { person.id }
    let person: Person
    var messages: [Message]
    var hasUnreadMessage = false
}

struct Person: Identifiable {
    let name: String
    let id = UUID()
    let imgString: String
}

struct Message: Identifiable {
    
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID().uuidString
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.date = date
        self.text = text
        self.type = type
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}


extension Chat {
    static let sampleChats: [Chat] = {
        var chats: [Chat] = []
        for _ in 0..<5 {
            var messages: [Message] = []
            for _ in 0..<10 {
                let randomMessage = Lorem.sentences(Int.random(in: 1...3))
                let randomDate = Date().addingTimeInterval(Double.random(in: -86400*7...0)) // Random date within the last week
                let messageType: Message.MessageType = Bool.random() ? .Sent : .Received
                messages.append(Message(randomMessage, type: messageType, date: randomDate))
            }
            let chat = Chat(person: RandomPersonGenerator.generateRandomPerson(), messages: messages, hasUnreadMessage: .random())
            chats.append(chat)
        }
        return chats
    }()
}

struct RandomPersonGenerator {
    static let names = ["Alice", "Bob", "Charlie", "David", "Emma", "Frank", "Grace", "Henry", "Ivy", "Jack", "Kate", "Liam", "Mia", "Noah", "Olivia", "Peter", "Quinn", "Ryan", "Sophia", "Tyler", "Ursula", "Victor", "Wendy", "Xavier", "Yara", "Zane"]
    static let symbols = ["person.fill", "person.2.fill", "person.3.fill", "person.4.fill", "person.5.fill", "person.6.fill", "person.7.fill", "person.8.fill", "person.9.fill", "person.crop.circle.fill", "person.crop.circle", "person.crop.circle.badge.checkmark", "person.crop.circle.badge.xmark", "person.crop.circle.badge.plus", "person.crop.circle.badge.minus", "person.crop.circle.badge.exclamationmark", "person.crop.circle.badge.questionmark", "person.crop.rectangle.fill", "person.crop.rectangle", "person.crop.square.fill", "person.crop.square", "person.2.crop.circle.fill", "person.2.crop.circle", "person.3.crop.circle.fill", "person.3.crop.circle"]
    
    static func generateRandomPerson() -> Person {
        let randomName = names.randomElement() ?? "Unknown"
        let randomSymbol = symbols.randomElement() ?? "person.fill"
        return Person(name: randomName, imgString: randomSymbol)
    }
}


// Sample data generator
struct Lorem {
    static func sentences(_ count: Int) -> String {
        var result = ""
        for _ in 0..<count {
            let wordsCount = Int.random(in: 5...15)
            let words = (0..<wordsCount).map { _ in Lorem.words.randomElement()! }
            let sentence = words.joined(separator: " ").capitalized
            result += sentence + ". "
        }
        return result
    }
    
    static let words: [String] = [
        "Lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
        "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore",
        "magna", "aliqua", "Ut", "enim", "ad", "minim", "veniam", "quis", "nostrud",
        "exercitation", "ullamco", "laboris", "nisi", "ut", "aliquip", "ex", "ea", "commodo",
        "consequat", "Duis", "aute", "irure", "dolor", "in", "reprehenderit", "in", "voluptate",
        "velit", "esse", "cillum", "dolore", "eu", "fugiat", "nulla", "pariatur", "Excepteur",
        "sint", "occaecat", "cupidatat", "non", "proident", "sunt", "in", "culpa", "qui",
        "officia", "deserunt", "mollit", "anim", "id", "est", "laborum"
    ]
}
