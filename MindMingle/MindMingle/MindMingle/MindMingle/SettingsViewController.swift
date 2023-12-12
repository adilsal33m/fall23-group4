//
//  SettingsViewController.swift
//  MindMingle
//
//  Created by MindMingle on 06/12/2023.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {

    // Sound toggle properties
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

        let darkGreenColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
        
        // Background setup
        let backgroundImage = UIImageView(image: UIImage(named: "BlurBackground"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)

        // Icon with Music Toggle Button
        let musicIconView = createIconView(imageName: "Music")
        view.addSubview(musicIconView)
        view.addSubview(musicToggleButton)

        // Icon with Sound Toggle Button
        let soundIconView = createIconView(imageName: "Sound")
        view.addSubview(soundIconView)
        view.addSubview(soundToggleButton)
        
        // Back Button
                let backButton = createButton(title: "Back")
                backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
                view.addSubview(backButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // Background Image
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Music Icon and Toggle Button
            musicIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musicIconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            musicIconView.widthAnchor.constraint(equalToConstant: 60),
            musicIconView.heightAnchor.constraint(equalToConstant: 60),

            musicToggleButton.centerYAnchor.constraint(equalTo: musicIconView.centerYAnchor),
            musicToggleButton.leadingAnchor.constraint(equalTo: musicIconView.trailingAnchor, constant: 20),

            // Sound Icon and Toggle Button
            soundIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            soundIconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            soundIconView.widthAnchor.constraint(equalToConstant: 60),
            soundIconView.heightAnchor.constraint(equalToConstant: 60),

            soundToggleButton.centerYAnchor.constraint(equalTo: soundIconView.centerYAnchor),
            soundToggleButton.leadingAnchor.constraint(equalTo: soundIconView.trailingAnchor, constant: 20),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                        backButton.topAnchor.constraint(equalTo: soundToggleButton.bottomAnchor, constant: 80),
        ])
        
        
        // Custom colors for toggle buttons
        musicToggleButton.tintColor = .white
            musicToggleButton.onTintColor = darkGreenColor // Change color as needed

        soundToggleButton.tintColor = .white
            soundToggleButton.onTintColor = darkGreenColor // Change color as needed
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Update the toggle buttons to reflect the current settings
            musicToggleButton.isOn = SoundManager.shared.isMusicEnabled
            soundToggleButton.isOn = SoundManager.shared.isSoundEnabled
        }
    
    func createIconView(imageName: String) -> UIImageView {
        let iconView = UIImageView(image: UIImage(named: imageName))
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }

    // Music Toggle Button
    let musicToggleButton: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true // Set the initial state as needed
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(musicToggleChanged), for: .valueChanged)
        return toggle
    }()

    // Sound Toggle Button
    let soundToggleButton: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true // Set the initial state as needed
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(soundToggleChanged), for: .valueChanged)
        return toggle
    }()

    
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
        
    @objc func musicToggleChanged() {
            SoundManager.shared.isMusicEnabled = musicToggleButton.isOn
            SoundManager.shared.saveSettings()
            playButtonSound()
        }

    @IBAction func soundToggleChanged(_ sender: Any) {
            if let toggle = sender as? UISwitch { // or UIButton, depending on your UI element
                SoundManager.shared.isSoundEnabled = toggle.isOn // Update the sound setting
            }
        }

        @objc func backButtonTapped() {
            playButtonSound()
            // Code to navigate back to the previous screen
            navigationController?.popViewController(animated: true)
        }

    func playButtonSound() {
        if SoundManager.shared.isSoundEnabled {
            SoundManager.shared.playSoundEffect(soundName: "click_effect-86995")
        }
    }
}

