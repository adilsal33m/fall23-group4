//
//  ViewController.swift
//  MindMingle
//
//  Created by MindMingle on 05/12/2023.
//

import UIKit
import AVFoundation
import AVKit

//Main Page
class FrontPageViewController: UIViewController {
    
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
        
        // Background Image
        let backgroundImage = UIImageView(image: UIImage(named: "Background"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.addSubview(backgroundImage)
        
        // Create a button with an icon
                let iconButton = UIButton(type: .custom)
                let iconImage = UIImage(named: "Settings") // Replace "your_icon_image" with your image name
                iconButton.setImage(iconImage, for: .normal)
                iconButton.tintColor = .white // Adjust the tint color of the icon as needed
                iconButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(iconButton)

        let darkBrownColor = UIColor(red: 0.4, green: 0.2, blue: 0.0, alpha: 1.0)

        // Create a UIImageView with your image
        let imageView = UIImageView(image: UIImage(named: "Mask group"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "MindMingle"
        titleLabel.textColor = darkBrownColor
        titleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 40)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Play Button
        let playButton = createButton(title: "Play")
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        view.addSubview(playButton)

        // Tutorial Button
        let tutorialButton = createButton(title: "Tutorial")
        tutorialButton.addTarget(self, action: #selector(TutorialButtonTapped), for: .touchUpInside)
        view.addSubview(tutorialButton)

        // highScoresButton Button
        let highScoresButton = createButton(title: "High Scores")
        highScoresButton.addTarget(self, action: #selector(highScoresButtonTapped), for: .touchUpInside)
        view.addSubview(highScoresButton)
        
        iconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
        

        // Layout Constraints
        NSLayoutConstraint.activate([
            
            iconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                        iconButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                        iconButton.widthAnchor.constraint(equalToConstant: 45), // Adjust width as needed
            iconButton.heightAnchor.constraint(equalToConstant: 45),
            // Image View Constraints
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 190),
                imageView.widthAnchor.constraint(equalToConstant: 100),  // Adjust the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 100),  // Adjust the height as needed
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20), // Adjust spacing from image,

            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),

            tutorialButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tutorialButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),

            highScoresButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highScoresButton.topAnchor.constraint(equalTo: tutorialButton.bottomAnchor, constant: 20)
        ])
    }
    
    let darkGreenColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)

    
    //Functions
    func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HappyMonkey-Regular", size: 22)
        button.backgroundColor = darkGreenColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true // Ensure content doesn't overflow
        
        // Set content inset for right and left sides only
        let fixedWidth: CGFloat = 210.0
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

    @objc func playButtonTapped() {
        buttonTapSound?.play()
        print("Play button tapped")
        let nameViewController = NameViewController() // Replace with your actual initialization code
            
            // Push the NameViewController onto the navigation stack
            self.navigationController?.pushViewController(nameViewController, animated: true)
    }


    @objc func TutorialButtonTapped() {
            buttonTapSound?.play()
            print("Settings button tapped")
            
            if let videoPath = Bundle.main.path(forResource: "Tutorial 2", ofType: "mov") {
                let videoURL = URL(fileURLWithPath: videoPath)
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    playerViewController.player?.play()
                }
            }
    }
    
    @objc func highScoresButtonTapped() {
        buttonTapSound?.play()
        print("High Scores button tapped")
        let highscore = HighScoreController()
        
        navigationController?.pushViewController(highscore, animated: true)
    }
    
    
    @objc func iconButtonTapped() {
        buttonTapSound?.play()
        print("Icon button tapped")
        
        // Instantiate the SettingsViewController
        let settingsViewController = SettingsViewController()
        
        // Push the SettingsViewController onto the navigation stack
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
}


