//
//  SelectViewController.swift
//  MindMingle
//
//  Created by MindMingle on 05/12/2023.
//


import UIKit
import AVFoundation

class SelectViewController: UIViewController {

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

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Choose Game Type"
        titleLabel.textColor = darkBrownColor
        titleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 25)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Mingle Cards Button
        let mingleCardsButton = createButton(title: "Mingle Cards")
        mingleCardsButton.addTarget(self, action: #selector(mingleCardsButtonTapped), for: .touchUpInside)
        view.addSubview(mingleCardsButton)

        // Mind Cards Button
        let mindCardsButton = createButton(title: "Mind Quiz")
        mindCardsButton.addTarget(self, action: #selector(mindCardsButtonTapped), for: .touchUpInside)
        view.addSubview(mindCardsButton)

        // Back Button
        let backButton = createButton(title: "Back")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 280),

            mingleCardsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mingleCardsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),

            mindCardsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mindCardsButton.topAnchor.constraint(equalTo: mingleCardsButton.bottomAnchor, constant: 10),

            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: mindCardsButton.bottomAnchor, constant: 10)
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

    @objc func mingleCardsButtonTapped() {
        buttonTapSound?.play()
        print("Mingle Cards button tapped")
        // Perform actions for Mingle Cards button
    }

    @objc func mindCardsButtonTapped() {
        buttonTapSound?.play()
        print("Mind Cards button tapped")
        // Perform actions for Mind Cards button
    }

    @objc func backButtonTapped() {
        buttonTapSound?.play()
        // Perform actions for Back button
        print("Back button tapped")
    }
}

