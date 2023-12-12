//
//  QEasyInstructionsViewController.swift
//  MindMingle
//
//  Created by MindMingle on 06/12/2023.
//

import UIKit
import AVFoundation

class QEasyInstructionsViewController: UIViewController {

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
        titleLabel.text = "Easy"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
    

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
        instructionsLabel.text = "Answer as much as questions as much for a higher score. But in a time frame of 7 secs for each question and with a limit of 2 wrong answers only but with uniquely hard questions."
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
            container.heightAnchor.constraint(equalToConstant: 320),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65),

            
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),

            lineDivider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
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
    
    @objc func startButtonTapped() {
        // Placeholder for Start button tap
        buttonTapSound?.play()
        print("Start button tapped")
        // Add any actions or transitions you want for the Start button
    }

    @objc func backButtonTapped() {
        // Placeholder for Back button tap
        buttonTapSound?.play()
        print("Back button tapped")
        // Add any actions or transitions you want for the Back button
    }

}
