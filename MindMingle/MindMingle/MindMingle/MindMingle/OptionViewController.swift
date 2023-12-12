//
//  OptionViewController.swift
//  MindMingle
//
//  Created by MindMingle on 06/12/2023.
//

import UIKit
import AVFoundation

protocol OptionViewControllerDelegate: AnyObject {
    func resumeGame()
    func restartGame()
    func quitGame()
}

class OptionViewController: UIViewController {
    weak var delegate: OptionViewControllerDelegate?

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
        let backgroundImage = UIImageView(image: UIImage(named: "BlurBackground"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.addSubview(backgroundImage)

        let darkBrownColor = UIColor(red: 0.4, green: 0.2, blue: 0.0, alpha: 1.0)
        let darkGreenColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)

        // Title above the container
        let aboveContainerTitle = UILabel()
        aboveContainerTitle.text = "Options"
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

        // Resume, Settings, Quit Buttons
        let resumeButton = createButton(title: "Resume")
        let restartButton = createButton(title: "Restart")
        let quitButton = createButton(title: "Quit")

        
        container.addSubview(resumeButton)

        // Divider 1
        let divider1 = createDivider()
        container.addSubview(divider1)

        container.addSubview(restartButton)

        // Divider 2
        let divider2 = createDivider()
        container.addSubview(divider2)

        container.addSubview(quitButton)

        resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
        quitButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)

        // Layout Constraints
        NSLayoutConstraint.activate([
            aboveContainerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboveContainerTitle.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -20),

            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 320),
            container.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            container.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -160),
            container.heightAnchor.constraint(equalToConstant: 200),

            resumeButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            resumeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),

            divider1.topAnchor.constraint(equalTo: resumeButton.bottomAnchor, constant: 10),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            divider1.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            divider1.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            restartButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            restartButton.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 10),

            divider2.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 10),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            divider2.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            quitButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            quitButton.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 10)
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

    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .white
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }
    
    @objc func resumeButtonTapped() {
        buttonTapSound?.play()
        delegate?.resumeGame()
        dismiss(animated: true, completion: nil)
    }

    @objc func restartButtonTapped() {
        buttonTapSound?.play()
        delegate?.restartGame()
        dismiss(animated: true, completion: nil)
    }

    @objc func quitButtonTapped() {
        buttonTapSound?.play()
        delegate?.quitGame()
        dismiss(animated: true, completion: nil)
    }

}
