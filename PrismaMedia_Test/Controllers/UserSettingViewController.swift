//
//  UserSettingViewController.swift
//  PrismaMedia_Test
//
//  Created by owee on 09/11/2020.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var settingButton: UIButton!
    
    weak var userVC : UserViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        
    }
    
}
