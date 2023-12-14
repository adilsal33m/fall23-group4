//
//  EasyInstructionsViewController.swift
//  MindMingle
//
//  Created by MindMingle on 06/12/2023.
//

import UIKit
import AVFoundation

class CEasyInstructionsViewController: UIViewController {

    var gridDetect: String? = ""
    var buttonTapSound: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let soundURL = Bundle.main.url(forResource: "click_effect-86995", withExtension: "mp3") {
                    do {
                        try buttonTapSound = AVAudioPlayer(contentsOf: soundURL)
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
        
        let darkGreenColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
        
        
        // Title above the container
        let aboveContainerTitle = UILabel()
        aboveContainerTitle.text = "Choose your Difficulty Level"
        aboveContainerTitle.textColor = darkBrownColor
        aboveContainerTitle.font = UIFont(name: "HappyMonkey-Regular", size: 25)
        aboveContainerTitle.textAlignment = .center
        aboveContainerTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aboveContainerTitle)
        
        
        // Container with Different Background
        let container = UIView()
        container.backgroundColor = darkGreenColor
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Easy - Choose your Grid"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        // Buttons (Side by Side)
        let button1 = createOutlineButton(title: "3 x 4")
        let button2 = createOutlineButton(title: "4 x 5")
        container.addSubview(button1)
        container.addSubview(button2)
        button1.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)

        // Line Divider
        let lineDivider = UIView()
        lineDivider.backgroundColor = .white
        lineDivider.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(lineDivider)
        
        

        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Rules"
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 22)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(subtitleLabel)

        // Instructions Content (Replace with actual instructions)
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Match the same pairs with the as less flips as you can to make a high score"
        instructionsLabel.textColor = .white
        instructionsLabel.font = UIFont(name: "HappyMonkey-Regular", size: 20)
        instructionsLabel.textAlignment = .center
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(instructionsLabel)

        let button3 = createButton(title: "Start Game")
        button3.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        let button4 = createButton(title: "Back")
        button4.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)


        view.addSubview(button3)
        view.addSubview(button4)

        
        // Layout Constraints
        NSLayoutConstraint.activate([
            
            aboveContainerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboveContainerTitle.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -30),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 320),
            container.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            container.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -160),
            container.heightAnchor.constraint(equalTo: container.widthAnchor, multiplier: 2.75/3),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -35),

            
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),

            button1.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            button1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            button1.widthAnchor.constraint(equalToConstant: 130),

            button2.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            button2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            button2.widthAnchor.constraint(equalToConstant: 130),

            lineDivider.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            lineDivider.heightAnchor.constraint(equalToConstant: 1),
            lineDivider.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            lineDivider.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            subtitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: lineDivider.bottomAnchor, constant: 20),

            instructionsLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            instructionsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            instructionsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            instructionsLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button3.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20),

            button4.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button4.topAnchor.constraint(equalTo: button3.bottomAnchor, constant: 10)
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
        let fixedWidth: CGFloat = 320.0
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
    
    func createOutlineButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .white  // Set the background color to white
        
        // Set border color and width for the outline effect
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        
        button.layer.cornerRadius = 8
        button.clipsToBounds = true // Ensure content doesn't overflow
        // Set content inset for right and left sides only
        let fixedWidth: CGFloat = 130.0
        button.widthAnchor.constraint(equalToConstant: fixedWidth).isActive = true
        
        let horizontalPadding: CGFloat = 10.0
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: horizontalPadding, bottom: 8, right: horizontalPadding)
        
        // Set background color for different button states
        button.setBackgroundImage(image(withColor: darkGreenColor), for: .normal)
        button.setBackgroundImage(image(withColor: UIColor.green), for: .highlighted)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    
    @objc func startButtonTapped() {
        // Placeholder for Start button tap
        buttonTapSound?.play()
        print("Start button tapped")
        
        if let grid = gridDetect
        {
            let cardController = CardGameController()
            if grid == "3 x 4"
            {
                cardController.configureGrid(buttonNumber: 1)// Configure for 3by4 grid
                gridDetect = ""
                navigationController?.pushViewController(cardController, animated: true)
            }
            else if grid == "4 x 5"
            {
                cardController.configureGrid(buttonNumber: 2)  // Configure for 4by5 grid
                gridDetect = ""
                navigationController?.pushViewController(cardController, animated: true)
            }
            else
            {
                print("Grid is not selected")
            }
        }
    }

    @objc func backButtonTapped() {
        // Placeholder for Back button tap
        buttonTapSound?.play()
        print("Back button tapped")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func button1Tapped() {
            // Handle button 1 tap
            buttonTapSound?.play()
            print("Button 1 tapped")
            gridDetect = "3 x 4"
        }

        @objc func button2Tapped() {
            // Handle button 2 tap
            buttonTapSound?.play()
            print("Button 2 tapped")
            gridDetect = "4 x 5"
        }

    @IBAction func gridButtonPressed(_ sender: UIButton) {
            let cardGameController = CardGameController() // Or get reference from storyboard/segue
            cardGameController.configureGrid(buttonNumber: sender.tag)
            
            // Navigate to CardGameController, adjust based on your navigation logic
            self.present(cardGameController, animated: true, completion: nil)
        }

}

