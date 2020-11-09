//
//  UserSettingViewController.swift
//  PrismaMedia_Test
//
//  Created by owee on 09/11/2020.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var settingButton: UIButton!
    
    // MARK: - Models
    
    weak var userVC : UserViewController?
    var newUser : User!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newUser = User(fullName: "", email: "", avatarURL: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func pressButton(_ sender: UIButton) {
        
        self.userVC?.set(User: newUser)
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func fullnameDidEnd(_ sender: UITextField) {
        
        if let text = sender.text {
            self.newUser.fullName = text
        }
        
    }
    
    @IBAction func emailDidEnd(_ sender: UITextField) {
        
        if let text = sender.text {
            self.newUser.email = text
        }
    }
}
