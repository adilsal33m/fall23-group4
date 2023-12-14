//
//  HardInstructionsViewController.swift
//  MindMingle
//
//  Created by MindMingle on 06/12/2023.
//


import UIKit
import AVFoundation

class CHardInstructionsViewController: UIViewController {
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
        titleLabel.text = "Hard - Choose your Grid"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        // Buttons (Side by Side)
        let button5 = createOutlineButton(title: "5 x 6")
        let button6 = createOutlineButton(title: "7 x 8")
        container.addSubview(button5)
        container.addSubview(button6)
        button5.addTarget(self, action: #selector(button5Tapped), for: .touchUpInside)
        button6.addTarget(self, action: #selector(button6Tapped), for: .touchUpInside)

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
        instructionsLabel.text = "Match the same pairs with the as less flips as you can to make a high score but with a twist. You have make a highscore within a time frame with a score penalty on each wrong match."
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
            container.heightAnchor.constraint(equalToConstant: 490),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65),

            
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),

            button5.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            button5.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            button5.widthAnchor.constraint(equalToConstant: 130),

            button6.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            button6.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            button6.widthAnchor.constraint(equalToConstant: 130),

            lineDivider.topAnchor.constraint(equalTo: button5.bottomAnchor, constant: 20),
            lineDivider.heightAnchor.constraint(equalToConstant: 1),
            lineDivider.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            lineDivider.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            subtitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: lineDivider.bottomAnchor, constant: 20),

            instructionsLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 0),
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

    
    @objc func startButtonTapped()
    {
        buttonTapSound?.play()
        print("Start button tapped")
        
        if let grid = gridDetect
        {
            let cardController = CardGameController()
            if grid == "5 x 6"
            {
                cardController.configureGrid(buttonNumber: 5)// Configure for 6by6 grid
                gridDetect = ""
                navigationController?.pushViewController(cardController, animated: true)
            }
            else if grid == "7 x 8"
            {
                cardController.configureGrid(buttonNumber: 6)  // Configure for 6by6 grid
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
    
    @objc func button5Tapped()
    {
        // Handle button 5 tap
        buttonTapSound?.play()
        print("Button 5 tapped")
        gridDetect = "5 x 6"
    }

    @objc func button6Tapped()
    {
        // Handle button 6 tap
        buttonTapSound?.play()
        print("Button 6 tapped")
        gridDetect = "7 x 8"
    }
    
    @IBAction func gridButtonPressed(_ sender: UIButton) {
            let cardGameController = CardGameController() // Or get reference from storyboard/segue
            cardGameController.configureGrid(buttonNumber: sender.tag)
            
            // Navigate to CardGameController, adjust based on your navigation logic
            self.present(cardGameController, animated: true, completion: nil)
        }


}

