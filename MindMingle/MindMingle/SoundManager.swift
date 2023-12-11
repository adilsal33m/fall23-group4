//
//  SoundManager.swift
//  MindMingle
//
//  Created by MindMingle on 10/12/2023.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var isMusicEnabled: Bool = true {
        didSet {
            if !isMusicEnabled {
                backgroundMusic?.stop()
            } else {
                playBackgroundMusic()
            }
        }
    }
    var isSoundEnabled: Bool = true {
            didSet {
                if isSoundEnabled {
                    // Code to enable sound effects (if needed)
                } else {
                    // Code to disable sound effects
                    soundEffectPlayer?.stop()
                }
            }
        }

    private var backgroundMusic: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?

    private init() {} // Private initializer for singleton

    // Play background music
    func playBackgroundMusic() {
        guard isMusicEnabled else { return }

        do {
            if let musicURL = Bundle.main.url(forResource: "Adventure-320bit(chosic.com)", withExtension: "mp3") {
                backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusic?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusic?.prepareToPlay()
                backgroundMusic?.play()
            } else {
                print("Background music file not found")
            }
        } catch {
            print("Error loading music: \(error.localizedDescription)")
        }
    }

    // Play a sound effect
    func playSoundEffect(soundName: String) {
        guard isSoundEnabled, let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }

        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: soundURL)
            soundEffectPlayer?.prepareToPlay()
            soundEffectPlayer?.play()
        } catch {
            print("Error loading sound effect: \(error.localizedDescription)")
        }
    }
    
    func saveSettings() {
            UserDefaults.standard.set(isMusicEnabled, forKey: "MusicEnabled")
            UserDefaults.standard.set(isSoundEnabled, forKey: "SoundEnabled")
        }

        // Load settings from UserDefaults
        func loadSettings() {
            isMusicEnabled = UserDefaults.standard.bool(forKey: "MusicEnabled")
            isSoundEnabled = UserDefaults.standard.bool(forKey: "SoundEnabled")
        }
}

