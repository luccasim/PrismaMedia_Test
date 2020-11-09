//
//  UserViewController.swift
//  PrismaMedia_Test
//
//  Created by owee on 09/11/2020.
//

import UIKit

class UserViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var userStackView: UIStackView!
    
    //MARK: - Models
    
    private var user : User?
    private var userRequest : ReqResWS = ReqResWS.shared
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Settings outlets
        self.avatarImageView.image = nil
        self.fullnameLabel.text = nil
        self.emailLabel.text = nil
        self.settingButton.setTitle("Modifier", for: .normal)
        self.activityMonitor.hidesWhenStopped = true
        self.navigationController?.navigationBar.isHidden = true
        self.settingButton.layer.borderWidth = 1
        self.settingButton.layer.borderColor = UIColor.white.cgColor
        
        // No Persistance.
        self.set(User: nil)
        
        self.fetchUser()
    }
    
    @IBAction func settingButtonPress(_ sender: UIButton) {
        // Pretty StraightForward, no comment...
        self.performSegue(withIdentifier: "showSetter", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifier = segue.identifier
        
        switch identifier {
        
        case "showSetter":
            
            // Send this controller reference to segue destination
            if let dvc = segue.destination as? UserSettingViewController {
                dvc.userVC = self
            }
            
        default: break
            
        }
    }
    
    // MARK: - Setters
    
    public func set(User:User?) {
        
        // Stop Activity Monitor and show user info if user exist
        if let newUser = User {
            self.activityMonitor.stopAnimating()
            self.userStackView.isHidden = false
            self.fullnameLabel.text = newUser.fullName
            self.emailLabel.text = newUser.email
            self.user = newUser
        }
        
        // Start Activity Monitor and hide user info if nil
        else {
            self.activityMonitor.startAnimating()
            self.userStackView.isHidden = true
        }
        
    }
    
    // MARK: - Async Fetching
    
    private var retry = 3

    private func fetchUser() {
        
        guard retry > 0 else {
            print("Default Error Handler, unable to connect with webservice")
            return
        }

        self.userRequest.taskGetUser(Id: 1) { (result) in
            
            switch result {
            
            case .success(let reponse):
                
                let avatarURL = URLComponents(string: reponse.data.avatar)?.url
                
                self.user = User(
                    fullName: "\(reponse.data.firstName) \(reponse.data.lastName.uppercased())",
                    email: reponse.data.email,
                    avatarURL: avatarURL)
                
                // Fetch image and when display info if retrieve
                self.fetchAvatarImage(avatarURL: avatarURL)
                
                
            case .failure(let error):
                
                print("Debug => \(error.localizedDescription)")
                
                // Not handing Error! Maybe retry 3 time a call after 15 secondes ?
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    self.retry -= 1
                    self.fetchUser()
                }
                
                break
            }
        }
        
    }
    
    private func fetchAvatarImage(avatarURL:URL?) {
            
        if let url = avatarURL {
            
            URLSession.shared.dataTask(with: url) { (data, rep, err) in
                
                if let error = err {
                    print("Can't retrieve avatar image -> \(error.localizedDescription)")
                }
                
                else if let image = data.flatMap({UIImage(data: $0)}) {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                        self.set(User: self.user)
                    }
                }
                
            }.resume()
        }
        
    }
}
