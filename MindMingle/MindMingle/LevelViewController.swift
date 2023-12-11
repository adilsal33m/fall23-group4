//
//  LevelViewController.swift
//  MindMingle
//
//  Created by MindMingle on 05/12/2023.
//

import UIKit
import AVFoundation

class LevelViewController: UIViewController {

    var buttonTapSound: AVAudioPlayer?
    var selectedDifficulty: String?
    var selectedTheme: String?
    var easyButton: UIButton!
    var hardButton: UIButton!
    var emojiGalaxyButton: UIButton!
    var theoremNumbersButton: UIButton!
    var continueButton: UIButton!
    
    var isDifficultySelected = false
    var isThemeSelected = false



    override func viewDidLoad() {
        super.viewDidLoad()

        if let soundURL = Bundle.main.url(forResource: "click_effect-86995", withExtension: "mp3") {
            do {
                buttonTapSound = try AVAudioPlayer(contentsOf: soundURL)
                buttonTapSound?.prepareToPlay()
            } catch {
                print("Error loading sound: \(error.localizedDescription)")
            }
        } else {
            print("Button tap sound file not found")
        }

        // Background Image (Same as the first screen)
        let backgroundImage = UIImageView(image: UIImage(named: "Background"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.addSubview(backgroundImage)

        let darkBrownColor = UIColor(red: 0.4, green: 0.2, blue: 0.0, alpha: 1.0)

        // Choose Difficulty Level Title
        let difficultyTitleLabel = UILabel()
        difficultyTitleLabel.text = "Choose Difficulty Level"
        difficultyTitleLabel.textColor = darkBrownColor
        difficultyTitleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 25)
        difficultyTitleLabel.textAlignment = .center
        difficultyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(difficultyTitleLabel)

        // Easy Button
        let easyButton = createButton(title: "Easy")
        easyButton.addTarget(self, action: #selector(easyButtonTapped), for: .touchUpInside)
        view.addSubview(easyButton)

        // Hard Button
        let hardButton = createButton(title: "Hard")
        hardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
        view.addSubview(hardButton)

        // Choose Theme Title
        let themeTitleLabel = UILabel()
        themeTitleLabel.text = "Choose Theme"
        themeTitleLabel.textColor = darkBrownColor
        themeTitleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 25)
        themeTitleLabel.textAlignment = .center
        themeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeTitleLabel)

        // Emoji Galaxy Button
        let emojiGalaxyButton = createButton(title: "Emoji Galaxy")
        emojiGalaxyButton.addTarget(self, action: #selector(emojiGalaxyButtonTapped), for: .touchUpInside)
        view.addSubview(emojiGalaxyButton)

        // Theorem Numbers Button
        let theoremNumbersButton = createButton(title: "Theorem Numbers")
        theoremNumbersButton.addTarget(self, action: #selector(theoremNumbersButtonTapped), for: .touchUpInside)
        view.addSubview(theoremNumbersButton)

        // Back Button
        let backButton = createButton(title: "Back")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        // Continue Button
        let continueButton = createButton(title: "Continue")
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        continueButton.isEnabled = false // Initially disable the button
        view.addSubview(continueButton)

        // Assign it to the instance variable
        self.continueButton = continueButton

        continueButton.isEnabled = false
        continueButton.backgroundColor = UIColor.gray

        // Layout Constraints
        NSLayoutConstraint.activate([
            difficultyTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            difficultyTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 170),

            easyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            easyButton.topAnchor.constraint(equalTo: difficultyTitleLabel.bottomAnchor, constant: 10),

            hardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hardButton.topAnchor.constraint(equalTo: easyButton.bottomAnchor, constant: 10),

            themeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeTitleLabel.topAnchor.constraint(equalTo: hardButton.bottomAnchor, constant: 50),

            emojiGalaxyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiGalaxyButton.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: 10),

            theoremNumbersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            theoremNumbersButton.topAnchor.constraint(equalTo: emojiGalaxyButton.bottomAnchor, constant: 10),
            

            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        continueButton.topAnchor.constraint(equalTo: theoremNumbersButton.bottomAnchor, constant: 50),

                        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        backButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10)
        ])
    }

    let darkGreenColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)

    func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HappyMonkey-Regular", size: 22)
        button.backgroundColor = darkGreenColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true // Ensure content doesn't overflow
        // Set content inset for right and left sides only
        let fixedWidth: CGFloat = 290.0
        button.widthAnchor.constraint(equalToConstant: fixedWidth).isActive = true
        let horizontalPadding: CGFloat = 10.0
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: horizontalPadding, bottom: 8, right: horizontalPadding)
        // Set background color for different button states
        button.setBackgroundImage(image(withColor: darkGreenColor), for: .normal)
        button.setBackgroundImage(image(withColor: UIColor.green), for: .highlighted)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    func image(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }
        return UIImage()
    }


    @objc func easyButtonTapped() {
            buttonTapSound?.play()
            selectedDifficulty = "Easy"
            isDifficultySelected = true
            updateContinueButtonState()
        }

        @objc func hardButtonTapped() {
            buttonTapSound?.play()
            selectedDifficulty = "Hard"
            isDifficultySelected = true
            updateContinueButtonState()
        }

        @objc func emojiGalaxyButtonTapped() {
            buttonTapSound?.play()
            selectedTheme = "Emoji Galaxy"
            isThemeSelected = true
            updateContinueButtonState()
        }

        @objc func theoremNumbersButtonTapped() {
            buttonTapSound?.play()
            selectedTheme = "Theorem Numbers"
            isThemeSelected = true
            updateContinueButtonState()
        }

    @objc func continueButtonTapped() {
        buttonTapSound?.play()
        if let difficulty = selectedDifficulty, let theme = selectedTheme {
            print("Selected Difficulty: \(difficulty)")
            print("Selected Theme: \(theme)")

            // Check the selected difficulty and enable the button with a green background
            if difficulty == "Easy" || difficulty == "Hard" {
                continueButton.isEnabled = true
                continueButton.backgroundColor = darkGreenColor
            } else {
                continueButton.isEnabled = false
                continueButton.backgroundColor = UIColor.gray // Gray out the button
            }

            // Push the appropriate view controller onto the navigation stack
            if difficulty == "Easy" {
                let cEasyInstructionViewController = CEasyInstructionsViewController()
                navigationController?.pushViewController(cEasyInstructionViewController, animated: true)
            } else if difficulty == "Hard" {
                let cHardInstructionViewController = CHardInstructionsViewController()
                navigationController?.pushViewController(cHardInstructionViewController, animated: true)
            }
        } else {
            print("Please select both difficulty and theme before continuing.")
        }
    }



        @objc func backButtonTapped() {
            buttonTapSound?.play()
            navigationController?.popViewController(animated: true)
        }
    
    
    func updateContinueButtonState() {
            if isDifficultySelected && isThemeSelected {
                continueButton.isEnabled = true
                continueButton.backgroundColor = darkGreenColor
            } else {
                continueButton.isEnabled = false
                continueButton.backgroundColor = UIColor.gray
            }
        }
    
}
