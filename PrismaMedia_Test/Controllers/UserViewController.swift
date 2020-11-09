//
//  UserViewController.swift
//  PrismaMedia_Test
//
//  Created by owee on 09/11/2020.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var userStackView: UIStackView!
    
    private var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.avatarImageView.image = nil
        self.fullnameLabel.text = nil
        self.emailLabel.text = nil
        self.settingButton.setTitle("Modifier", for: .normal)
        self.activityMonitor.hidesWhenStopped = true
        
        // No Persistance.
        self.set(User: nil)
    }
    
    public func set(User:User?) {
        
        // Stop Activity Monitor and show user info if user exist
        if let newUser = User {
            self.activityMonitor.stopAnimating()
            self.fullnameLabel.text = self.user?.fullName
            self.emailLabel.text = self.user?.email
            self.user = newUser
        }
        
        // Start Activity Monitor and hide user info if nil
        else {
            self.activityMonitor.startAnimating()
            self.userStackView.isHidden = false
        }
        
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

}
