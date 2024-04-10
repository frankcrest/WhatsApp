//
//  ChatRow.swift
//  WhatsApp
//
//  Created by Frank Chen on 2024-04-01.
//

import SwiftUI

struct ChatRow: View {
    
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "\(chat.person.imgString)")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 1)
                }
            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(chat.person.name)
                            .bold()
                        
                        Spacer()
                        
                        Text(chat.messages.last?.date.descriptiveString() ?? "")
                    }
                    
                    HStack {
                        Text(chat.messages.last?.text ?? "")
                            .foregroundStyle(.gray)
                            .lineLimit(2)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                        
                        
                    }
                }
                
                Circle()
                    .foregroundStyle(chat.hasUnreadMessage ? .blue : .clear)
                    .frame(width: 18, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: 80)
    }
}

#Preview {
    ChatRow(chat: Chat.sampleChats[0])
}
