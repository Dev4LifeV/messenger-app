//
//  ChatViewController.swift
//  Messenger
//
//  Created by Victor Proppe on 09/01/23.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var photo: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private let selfSender: Sender = Sender(photo: "", senderId: "1", displayName: "Joe Smith")
    
    private var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messages.append(Message(
            sender: selfSender,
            messageId: "1",
            sentDate: Date(),
            kind: .text("Hello World message")))
        messages.append(Message(
            sender: selfSender,
            messageId: "2",
            sentDate: Date(),
            kind: .text("Hello World message")))
        
        self.view.backgroundColor = .white
        
        messagesCollectionView.reloadData()
    }

}

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return Sender(photo: "", senderId: "1", displayName: "Joe Smith")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: MessagesLayoutDelegate, MessagesDisplayDelegate {
    
}
