//
//  ToEatItem.swift
//  mealmiru-member-ios
//
//  Created by Hirokazu Toki on 2026/02/05.
//

import Foundation

struct ToEatItem: Identifiable, Equatable {
    let id: UUID
    var name: String
    var expDate: Date?
    var isChecked: Bool = false

    init(id: UUID = UUID(), name: String, expDate: Date?) {
        self.id = id
        self.name = name
        self.expDate = expDate
        
    }
}
