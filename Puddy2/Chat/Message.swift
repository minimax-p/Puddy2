//
//  Message.swift
//  Puddy2
//
//  Created by iMacBig03 on 4/11/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var isUser: Bool
    var timestamp: Date
}
