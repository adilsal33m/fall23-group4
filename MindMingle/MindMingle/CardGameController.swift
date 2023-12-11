//
//  CardGameController.swift
//  MindMingle
//
//  Created by MindMingle on 10/12/2023.
//
//
//  ViewController.swift
//  MatchCards
//
//  Created by MindMingle on 13/11/2023.
//

import UIKit

class CardGameController: UIViewController {
    
    
    var numberOfRows = 7
        var cardsPerRow = 4
        
        var numberOfPairOfCards: Int {
            return (numberOfRows * cardsPerRow) / 2
        }
        
        private lazy var game = MatchCard(numberOfPairsOfCards: self.numberOfPairOfCards)
        
        private var cardEmoji = [Card: String]()
        private var emojiChoices = "🐶🐱🐭🐹🦁🐔🙊🦇🦊"
        
        let flipCountLabel = UILabel()
        let scoreLabel = UILabel()
        let timeLabel = UILabel()
        
        private var cardButtons = [UIButton]()
        
        var lastCardButtonTapped: UIButton!
        var secondLastCardButtonTapped: UIButton!
        
        var FlippedCardCount = 0
        var startTime: TimeInterval?
        var timer: Timer?

        override func viewDidLoad() {
            super.viewDidLoad()
            createCardUI(numberOfRows: self.numberOfRows, cardsPerRow: self.cardsPerRow)
            updateViewFromModel()
            startTimer()
        }

        func configureGrid(buttonNumber: Int) {
            switch buttonNumber {
            case 1:
                numberOfRows = 4
                cardsPerRow = 4
            case 2:
                numberOfRows = 4
                cardsPerRow = 6
            case 5:
                numberOfRows = 6
                cardsPerRow = 6
            case 6:
                numberOfRows = 8
                cardsPerRow = 8
            default:
                numberOfRows = 4 // Default case
                cardsPerRow = 4
            }

            game = MatchCard(numberOfPairsOfCards: numberOfPairOfCards) // Reinitialize the game
                    clearCardUI()  // Clear existing UI
                    createCardUI(numberOfRows: numberOfRows, cardsPerRow: cardsPerRow)  // Create new UI
                    updateViewFromModel()
        }

    private func clearCardUI() {
            cardButtons.forEach { $0.removeFromSuperview() }
            cardButtons.removeAll()
        }

    
    func createCardUI(numberOfRows: Int, cardsPerRow: Int) {
        // Create a stack view for the top section
        let topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.alignment = .fill
        topStackView.distribution = .fillProportionally
        topStackView.spacing = 10
        
        let backgroundImage = UIImageView(image: UIImage(named: "Background"))
        
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .scaleAspectFill // Adjust content mode to fit
            
        if let customFont = UIFont(name: "HappyMonkey-Regular", size: 16) {
            // Use the custom font for the title label
            scoreLabel.font = customFont
            flipCountLabel.font = customFont
            timeLabel.font = customFont
        } else {
            // Fallback to a system font if the custom font is not available
            scoreLabel.font = UIFont.systemFont(ofSize: 24)
        }
        
        // Add the image view to the view as the background
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        // Create the score label and flip count label
        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .left
        flipCountLabel.text = "Flips: 0"
        flipCountLabel.textAlignment = .right
        
        // Set time label
        timeLabel.text = "Time: 0s"
        timeLabel.textAlignment = .center
        
        // Add the labels to the top stack view
        topStackView.addArrangedSubview(scoreLabel)
        topStackView.addArrangedSubview(timeLabel)
        topStackView.addArrangedSubview(flipCountLabel)
        
        // Clear existing card buttons
        cardButtons.forEach { $0.removeFromSuperview() }
        cardButtons.removeAll()

        // Create a stack view for the bottom section
        let bottomStackView = UIStackView()
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .fill
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 10
        
        // Create the grid of card buttons
        for _ in 0..<numberOfRows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            
            for _ in 0..<cardsPerRow {
                let cardButton = UIButton()
                cardButton.backgroundColor = .black // Default background color
                cardButton.layer.cornerRadius = 4
                cardButton.layer.masksToBounds = true
                
                // Add the card button to the card buttons array
                cardButtons.append(cardButton)
                
                // Add the target-action pair
                cardButton.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
                
                rowStackView.addArrangedSubview(cardButton)
            }
            
            bottomStackView.addArrangedSubview(rowStackView)
        }

        // Create a parent stack view to arrange the top and bottom sections vertically
        let parentStackView = UIStackView()
        parentStackView.axis = .vertical
        parentStackView.alignment = .fill
        parentStackView.distribution = .fill
        parentStackView.spacing = 20

        // Add the top and bottom stack views to the parent stack view
        parentStackView.addArrangedSubview(topStackView)
        parentStackView.addArrangedSubview(bottomStackView)

        // Add the parent stack view to the main view
        view.addSubview(parentStackView)
        
        let restartButton = UIButton()
        restartButton.setTitle("Restart", for: .normal)
        restartButton.backgroundColor = .blue
        restartButton.addTarget(self, action: #selector(restartButtonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(restartButton)
        
        // Add constraints to define the position and size of the parent stack view
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            parentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            parentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            parentStackView.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -20)
        ])
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
        
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: parentStackView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: parentStackView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: parentStackView.bottomAnchor)
        ])
        
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restartButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            restartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        // Update the game model for new grid size
            game = MatchCard(numberOfPairsOfCards: (numberOfRows * cardsPerRow) / 2)

            // Refresh the UI
            updateViewFromModel()
    }
    
    
    @objc func cardButtonTapped(_ sender: UIButton) {
        
        FlippedCardCount += 1

        
        if FlippedCardCount != 3 {
            secondLastCardButtonTapped = lastCardButtonTapped
            lastCardButtonTapped = sender
        }
        if lastCardButtonTapped == nil {
            lastCardButtonTapped = sender
            secondLastCardButtonTapped = sender
        }
        
        
        if FlippedCardCount == 3 {
            if lastCardButtonTapped != secondLastCardButtonTapped {
                if lastCardButtonTapped.title(for: .normal) != secondLastCardButtonTapped.title(for: .normal) {
                    UIView.transition(with: lastCardButtonTapped, duration: 0.4, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
                    UIView.transition(with: secondLastCardButtonTapped, duration: 0.4, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
                }
            }
            lastCardButtonTapped = sender
            FlippedCardCount = 1
        }
        
        if let cardNumber = cardButtons.firstIndex(of: sender), cardNumber < game.cards.count {
                    game.chooseCard(at: cardNumber)
                    updateViewFromModel()
                } else {
                    print("Card button index is out of range")
                }
    }
    
    private func updateViewFromModel() {
        
        // Update the flip count
        flipCountLabel.text = "Flips: \(game.flipCount)"
        
        // Update the Score
        scoreLabel.text = "Score: \(game.score)"
        
        for index in cardButtons.indices {
                guard index < game.cards.count else {
                    print("Error: Index \(index) is out of bounds for cards array.")
                    continue
                }

                let button = cardButtons[index]
                let card = game.cards[index]
            if card.isMatched {
                        // If the card is matched, remove the button from the view and disable it
                        UIView.animate(withDuration: 0.3, animations: {
                            button.alpha = 0  // Fade out animation
                        }, completion: { _ in
                            button.isHidden = true
                            button.isEnabled = false
                        })
                    } else {
                        // Reset the button's properties if the card is not matched
                        button.isHidden = false
                        button.alpha = 1
                        button.isEnabled = true
                        
            button.layer.cornerRadius = 3 // Adjust the radius as needed
            button.layer.masksToBounds = true
                        
                        if card.isFaceUp {
                                        button.setTitle(getEmoji(for: card), for: .normal)
                                        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                                        button.backgroundColor = .white
                                    } else {
                                        button.setTitle("", for: .normal)
                                        button.backgroundColor = .systemGreen
                                    }
                                }
        }
        
        if game.allCardsMatched {
            stopTimer()
            
            //let highScoreManager = HighScoreManager()
            //let topFiveHighScores = highScoreManager.getTopHighScore()
            //let lastHighScore = topFiveHighScores.last
            //let newScore = HighScore(time: <#T##TimeInterval#>, score: game.score, flips: game.flipCount)
            
            performSegue(withIdentifier: "showHighScore", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHighScore" {
            
        }
    }
    
    private func getEmoji(for card: Card) -> String {
        if cardEmoji[card] == nil, emojiChoices.count > 0 {
            let stringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4Random)
            cardEmoji[card] = String(emojiChoices.remove(at: stringIndex))
            
            //let randomIndex = getRandomIndex(for: emojiChoices.count)
            //cardEmoji[card] = emojiChoices.remove(at: randomIndex)
        }
        return cardEmoji[card] ?? "?"
    }
    
    
    func flipCard(_ card: Card, button: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
    }
    
    
    @objc func restartButtonTapped(_ sender: UIButton) {
        
    }

    
    private func startTimer() {
        startTime = Date.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        guard let startTime = startTime else {
            return
        }
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTime = currentTime - startTime
        
        // Update the time label in your UI
        timeLabel.text = "Time: \(Int(elapsedTime))s"
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}

extension Int {
    var arc4Random: Int {
        switch self {
        case 1...Int.max:
            return Int(arc4random_uniform(UInt32(self)))
        case -Int.max..<0:
            return Int(arc4random_uniform(UInt32(self)))
        default:
            return 0
        }
    }
}

