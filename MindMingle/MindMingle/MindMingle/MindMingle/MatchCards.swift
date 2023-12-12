//
//  Cards.swift
//  MindMingle
//
//  Created by MindMingle on 10/12/2023.
//

import Foundation

class MatchCard {
    
    private(set) var cards = [Card]()
    
    private(set) var flipCount = 0
    
    var elapsedTime: TimeInterval = 0

    private(set) var score = 0
    
    private(set) var discoveredCardsIndicies = [Int]()
    
    private var startTime: Date?
    
    private var faceUpCardIndex: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var allCardsMatched: Bool {
        for card in cards {
            if !card.isMatched {
                return false
            }
        }
        return true
    }
    
    
    // Method to start the timer
    func startTimer() {
        startTime = Date()
    }
    
    // Method to Check if the match occurred within the time limit
    func didMatchWithinTimeLimit() -> Bool {
        guard let startTime = startTime else { return false }
        let elapsedTime = Date().timeIntervalSince(startTime)
        return elapsedTime <= 5.0
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "You need atleast 1 pair of cards")
        
        // Create cards in an order
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // shuffle all the cards
        cards.shuffle()
    }
    
    func chooseCard(at index: Int) {
        guard cards.indices.contains(index) else {
                    print("Chosen index not in cards")
                    return
                }
        
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = faceUpCardIndex, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    // increment score by 2
                    score += 4
                    
                    // bonus score
                    // Check if the match occured within the time limit
                    if didMatchWithinTimeLimit() {
                        // Award bonus score for matching within 5 seconds
                        score += 2
                    }
                } else {
                    
                    if discoveredCardsIndicies.contains(index) {
                        score -= 1
                    }
                    
                    if discoveredCardsIndicies.contains(matchIndex) {
                        score -= 1
                    }
                }
                
                cards[index].isFaceUp = true
                discoveredCardsIndicies += [index, matchIndex]
                
            } else {
                faceUpCardIndex = index
                startTimer()
            }
        }
        
    }
    
    func resetGame() {
            // Reset the flip count and score
            flipCount = 0
            score = 0
            discoveredCardsIndicies.removeAll()

            // Reset all cards
            for index in cards.indices {
                cards[index].isMatched = false
                cards[index].isFaceUp = false
            }

            // Shuffle the cards for a new game
            cards.shuffle()
        }
    
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
