//
//  Cards.swift
//  MindMingle
//
//  Created by MindMingle on 10/12/2023.
//

import Foundation

struct Card: Hashable {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    private var identifier: Int
    private static var identifierFactory = 0
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
