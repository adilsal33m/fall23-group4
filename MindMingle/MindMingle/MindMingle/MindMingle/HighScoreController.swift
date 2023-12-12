//
//  HighScoreController.swift
//  MindMingle
//
//  Created by MindMingle on 13/12/2023.
//

import UIKit

class HighScoreController: UIViewController, UITableViewDelegate {
    var highScores: [HighScore] = []
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHighScores()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
                tableView.delegate = self
                tableView.dataSource = self

                // Add the tableView to your view
                self.view.addSubview(tableView)
    }
    

    private func loadHighScores() {
        let defaults = UserDefaults.standard
        if let savedScores = defaults.object(forKey: "highScores") as? Data {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([HighScore].self, from: savedScores) {
                highScores = loadedScores
            }
        }

        // Sort the scores in descending order
        highScores.sort { $0.score > $1.score }
    }

    private func saveHighScores() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(highScores) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "highScores")
        }
    }

    func addHighScore(newScore: HighScore) {
        highScores.append(newScore)

        // Keep only the top 10 scores
        highScores.sort { $0.score > $1.score }
        if highScores.count > 10 {
            highScores.removeLast()
        }

        saveHighScores()
    }
}

extension HighScoreController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath)
        let score = highScores[indexPath.row]
        cell.textLabel?.text = "\(score.name) - \(score.score)"
        return cell
    }
}

