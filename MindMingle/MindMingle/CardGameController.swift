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
import AVFoundation
import UIKit

class CardGameController: UIViewController
{
    var buttonTapSound: AVAudioPlayer?
    var playerName: String?
    var matchSound: AVAudioPlayer?
    var gameEndSound: AVAudioPlayer?
    var errSound: AVAudioPlayer?
    

    
    var numberOfRows = 7
    var cardsPerRow = 4
        
        var numberOfPairOfCards: Int
        {
            return (numberOfRows * cardsPerRow) / 2
        }
        
        private lazy var game = MatchCard(numberOfPairsOfCards: self.numberOfPairOfCards)
        
        private var cardEmoji = [Card: String]()
        private var emojiChoices = "😂😘😑🥳😭👻❤✌🍕🌼🌟✈️💸🗿💩"
        
        let flipCountLabel = UILabel()
        let scoreLabel = UILabel()
        let timeLabel = UILabel()
        private var cardsFlipped = false
        
        private var cardButtons = [UIButton]()
        
        var lastCardButtonTapped: UIButton!
        var secondLastCardButtonTapped: UIButton!
        
        var FlippedCardCount = 0
        var startTime: TimeInterval?
        var timer: Timer?

        override func viewDidLoad()
        {
            super.viewDidLoad()
            createCardUI(numberOfRows: self.numberOfRows, cardsPerRow: self.cardsPerRow)
            updateViewFromModel()
            startTimer()

            if let soundURL = Bundle.main.url(forResource: "click_effect-86995", withExtension: "mp3")
            {
                do
                {
                    try buttonTapSound = AVAudioPlayer(contentsOf: soundURL)
                        buttonTapSound?.prepareToPlay()
                }
                catch
                {
                    print("Error loading sound: \(error.localizedDescription)")
                }
            }
            else
            {
                print("Button tap sound file not found")
            }
            
            // Load and prepare the match sound
            if let matchSoundURL = Bundle.main.url(forResource: "achievement-sound-1-95506", withExtension: "mp3")
            {
                do
                {
                    try matchSound = AVAudioPlayer(contentsOf: matchSoundURL)
                    matchSound?.prepareToPlay()
                }
                catch
                {
                    print("Error loading match sound: \(error.localizedDescription)")
                }
            }
            else
            {
                print("Match sound file not found")
            }

            // Load and prepare the game end sound
            if let gameEndSoundURL = Bundle.main.url(forResource: "yay-6120", withExtension: "mp3")
            {
                do
                {
                    try gameEndSound = AVAudioPlayer(contentsOf: gameEndSoundURL)
                        gameEndSound?.prepareToPlay()
                }
                catch
                {
                    print("Error loading game end sound: \(error.localizedDescription)")
                }
            }
            else
            {
                print("Game end sound file not found")
            }
            
            // Load and prepare the error sound
            if let errSoundURL = Bundle.main.url(forResource: "error-2-126514", withExtension: "mp3")
            {
                do
                {
                    try errSound = AVAudioPlayer(contentsOf: errSoundURL)
                        errSound?.prepareToPlay()
                }
                catch
                {
                    print("Error loading match sound: \(error.localizedDescription)")
                }
            }
            else
            {
                print("Match sound file not found")
            }

}
    func configureGrid(buttonNumber: Int)
    {
            switch buttonNumber {
            case 1:
                numberOfRows = 3
                cardsPerRow = 4
            case 2:
                numberOfRows = 4
                cardsPerRow = 5
            case 5:
                numberOfRows = 5
                cardsPerRow = 6
            case 6:
                numberOfRows = 7
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

    
    func createCardUI(numberOfRows: Int, cardsPerRow: Int)
    {
        let topStackView = UIStackView()
        topStackView.axis = .horizontal
        topStackView.alignment = .fill
        topStackView.distribution = .fillProportionally
        topStackView.spacing = 10
        
        let iconButton = UIButton(type: .custom)
            let iconImage = UIImage(named: "Settings")
            iconButton.setImage(iconImage, for: .normal)
            iconButton.tintColor = .white
            view.addSubview(iconButton)
        
        iconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
        
        
        iconButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                iconButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                iconButton.widthAnchor.constraint(equalToConstant: 40),
                iconButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        
        let backgroundImage = UIImageView(image: UIImage(named: "Background"))
        
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .scaleAspectFill // Adjust content mode to fit
            
        if let customFont = UIFont(name: "HappyMonkey-Regular", size: 19) {
            scoreLabel.font = customFont
            flipCountLabel.font = customFont
            timeLabel.font = customFont
        } else {

            scoreLabel.font = UIFont.systemFont(ofSize: 24)
        }
        
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)

        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .left
        flipCountLabel.text = "Flips: 0"
        flipCountLabel.textAlignment = .right
        
        timeLabel.text = "Time: 0s"
        timeLabel.textAlignment = .center
        
        topStackView.addArrangedSubview(scoreLabel)
        topStackView.addArrangedSubview(timeLabel)
        topStackView.addArrangedSubview(flipCountLabel)
        
        cardButtons.forEach { $0.removeFromSuperview() }
        cardButtons.removeAll()

        let bottomStackView = UIStackView()
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .fill
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 10
        
        // Create the grid of card buttons as in the previous example
        for _ in 0..<numberOfRows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10
            
            for _ in 0..<cardsPerRow {
                let cardButton = UIButton()
                cardButton.setTitle("", for: .normal)
                cardButton.backgroundColor = .black
                

                
                // add the card button to card buttons array
                cardButtons.append(cardButton)
                
                // add the target-action pair
                cardButton.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
                
                rowStackView.addArrangedSubview(cardButton)
            }
            
            bottomStackView.addArrangedSubview(rowStackView)
        }


        let parentStackView = UIStackView()
        parentStackView.axis = .vertical
        parentStackView.alignment = .fill
        parentStackView.distribution = .fill
        parentStackView.spacing = 20


        parentStackView.addArrangedSubview(topStackView)
        parentStackView.addArrangedSubview(bottomStackView)

        view.addSubview(parentStackView)
        
        
        NSLayoutConstraint.activate([
            iconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            iconButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iconButton.widthAnchor.constraint(equalToConstant: 40),
            iconButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentStackView.topAnchor.constraint(equalTo: iconButton.bottomAnchor, constant: 10), // Changed to position below the icon button
            parentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            parentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            parentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
                    
                    topStackView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        topStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
                    ])
        
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: parentStackView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: parentStackView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: parentStackView.bottomAnchor)
        ])
        
            game = MatchCard(numberOfPairsOfCards: (numberOfRows * cardsPerRow) / 2)
            updateViewFromModel()
        
        
    }
    
    
    @objc func cardButtonTapped(_ sender: UIButton)
    {
        FlippedCardCount += 1
        
        if FlippedCardCount != 3
        {
            secondLastCardButtonTapped = lastCardButtonTapped
            lastCardButtonTapped = sender
        }
        if lastCardButtonTapped == nil
        {
            lastCardButtonTapped = sender
            secondLastCardButtonTapped = sender
        }
        
        
        if FlippedCardCount == 3 {
            if lastCardButtonTapped != secondLastCardButtonTapped
            {
                if lastCardButtonTapped.title(for: .normal) != secondLastCardButtonTapped.title(for: .normal)
                {
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
            if card.isMatched
            {
                UIView.transition(with: button, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                    // Flip animation
                    button.alpha = 0.5
                    self.matchSound?.play()
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        // Fade out animation after flip
                        button.alpha = 0
                    }, completion: { _ in
                        button.isHidden = true
                        button.isEnabled = false
                    })

                })
                    }
            else
            {
                button.isHidden = false
                button.alpha = 1
                button.isEnabled = true
                        
                button.layer.cornerRadius = 3
                button.layer.masksToBounds = true
                        
                if card.isFaceUp
                {
                    button.setTitle(getEmoji(for: card), for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                    button.backgroundColor = .white
                }
                else
                {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = .systemGreen
                }
            }
        }
        
        if game.allCardsMatched {
            gameEndSound?.play()
            stopTimer()
                navigateToHighScores()
            }
        
        }
    
    private func navigateToHighScores() {
        let highScoreVC = HighScoreController()
        navigationController?.pushViewController(highScoreVC, animated: true)
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
        UIView.transition(with: button, duration: 0.5, options: [.transitionFlipFromTop], animations: nil, completion: nil)
    }
    

    
    private func startTimer() {
        timer?.invalidate()

        if startTime == nil {
            startTime = Date.timeIntervalSinceReferenceDate - game.elapsedTime
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    
    }
    
    @objc private func updateTimer() {
        guard let startTime = startTime else {
            return
        }
        
        let currentTime = Date.timeIntervalSinceReferenceDate
        let totalTime = currentTime - startTime + game.elapsedTime
        
        // Update the time label in your UI
        timeLabel.text = "Time: \(Int(totalTime))s"
    }

    
    private func stopTimer() {
        if let startTime = startTime {
            let currentTime = Date.timeIntervalSinceReferenceDate
            game.elapsedTime += currentTime - startTime
        }
        timer?.invalidate()
        timer = nil
        startTime = nil
    }


    
    @objc func iconButtonTapped() {
        buttonTapSound?.play()
        
        let optionViewController = OptionViewController()
        optionViewController.delegate = self
        
        stopTimer()
        
        navigationController?.pushViewController(optionViewController, animated: true)
    }
    
    func gameDidEnd() {
        guard let playerName = playerName else {
            print("Player name not set")
            return
        }

        let finalScore = game.score
        let newHighScore = HighScore(name: playerName, score: finalScore)
        saveHighScore(newHighScore)

        navigateToHighScores()  // This function should present HighScoreController
    }


    func saveHighScore(_ highScore: HighScore) {
        var highScores = [HighScore]()

        // Load existing high scores
        if let savedScores = UserDefaults.standard.object(forKey: "HighScores") as? Data {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([HighScore].self, from: savedScores) {
                highScores = loadedScores
            }
        }

        // Add new high score and save
        highScores.append(highScore)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(highScores) {
            UserDefaults.standard.set(encoded, forKey: "HighScores")
        }
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



extension CardGameController: OptionViewControllerDelegate {
    func resumeGame() {
        navigationController?.popViewController(animated: true)
        startTimer()
    }

    func restartGame() {
        navigationController?.popViewController(animated: true)
        game.resetGame()
            game.elapsedTime = 0
            updateViewFromModel()
            startTimer()
    }

    func quitGame() {
        let frontpageviewController = FrontPageViewController()

        navigationController?.pushViewController(frontpageviewController, animated: true)
    }
    
    
}

extension CardGameController: NameViewControllerDelegate {
    func playerNameEntered(name: String) {
        playerName = name
    }
}



