import UIKit

class HighScoreController: UIViewController, UITableViewDelegate {
    var highScores: [HighScore] = []
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the TableView
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear // Make the table view background transparent
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Register the UITableViewCell class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HighScoreCell")

        
        
        // Background Image (Same as your previous screens)
                        let backgroundImage = UIImageView(image: UIImage(named: "Background"))
                        backgroundImage.contentMode = .scaleAspectFill
                        backgroundImage.frame = view.bounds
                        view.addSubview(backgroundImage)

                let darkBrownColor = UIColor(red: 0.4, green: 0.2, blue: 0.0, alpha: 1.0)
                
                        // Title Label
                        let titleLabel = UILabel()
                        titleLabel.text = "Highscore"
                titleLabel.textColor = darkBrownColor // Change text color here
                        titleLabel.font = UIFont(name: "HappyMonkey-Regular", size: 25)
                        titleLabel.textAlignment = .center
                        titleLabel.translatesAutoresizingMaskIntoConstraints = false
                        view.addSubview(titleLabel)

                        // Green Box
                        let greenBox = UIView()
                        greenBox.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1.0)
                        greenBox.layer.cornerRadius = 12
                        greenBox.translatesAutoresizingMaskIntoConstraints = false
                        view.addSubview(greenBox)
        addHighScore(name: "AmanUllah", score: 40)

                        greenBox.addSubview(tableView)

                        // Back Button
                        let backButton = createButton(title: "Back")
                        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
                        view.addSubview(backButton)

                
                // Layout Constraints
                        NSLayoutConstraint.activate([
                            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 170), // Reduce the space here

                            greenBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                            greenBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                            greenBox.widthAnchor.constraint(equalToConstant: 320),
                            greenBox.heightAnchor.constraint(equalToConstant: 400),

                            tableView.leadingAnchor.constraint(equalTo: greenBox.leadingAnchor),
                            tableView.trailingAnchor.constraint(equalTo: greenBox.trailingAnchor),
                            tableView.topAnchor.constraint(equalTo: greenBox.topAnchor),
                            tableView.bottomAnchor.constraint(equalTo: greenBox.bottomAnchor),

                            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                            backButton.topAnchor.constraint(equalTo: greenBox.bottomAnchor, constant: 20)
                        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }


    func loadHighScores() {
        if let savedScores = UserDefaults.standard.object(forKey: "HighScores") as? Data {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([HighScore].self, from: savedScores) {
                highScores = loadedScores
            }
        }
        tableView?.reloadData()
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

    private func image(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }

    @objc func backButtonTapped() {
        let frontpageviewcontroller = FrontPageViewController() // Replace with your actual initialization code

        // Push the SelectViewController onto the navigation stack
        navigationController?.pushViewController(frontpageviewcontroller, animated: true)
    }

    func addHighScore(name: String, score: Int) {
        let newHighScore = HighScore(name: name, score: score)
        highScores.append(newHighScore)
        // Sort the highScores array if needed, and update the tableView
        highScores.sort { $0.score > $1.score }
        tableView?.reloadData()
    }


    private func saveHighScores() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(highScores) {
            UserDefaults.standard.set(encoded, forKey: "HighScores")
        }
    }
    
}

// MARK: - UITableViewDataSource
extension HighScoreController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath)
        let score = highScores[indexPath.row]
        cell.textLabel?.text = "\(score.name) - \(score.score)"
        cell.textLabel?.font = UIFont(name: "HappyMonkey-Regular", size: 22) // Adjust size as needed
        cell.textLabel?.text = "\(score.name) - \(score.score)"

        // Optional: Set the background color of the cell to clear if needed
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
}


