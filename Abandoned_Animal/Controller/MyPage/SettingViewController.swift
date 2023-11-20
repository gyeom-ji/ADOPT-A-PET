//
//  SettingViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/18.
//

import Foundation
import UIKit
import CoreLocation

class SettingViewController: UIViewController {
    
    @IBOutlet weak var infoBtn: UIButton!
    var userType = Int()
    var userPk = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.userType = defaults.integer(forKey: "userType")
        self.userPk = defaults.integer(forKey: "pk")
    }
    
    @IBAction func clickInfoBtn(_ sender: UIButton) {
       
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "MyInfoViewController")as? MyInfoViewController else {return}
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func clickDeleteRollBtn(_ sender: UIButton) {
        
        if userType == 1 {
            ShelterStaffModel.shared.deleteStaff(id: userPk)
        }
        else{
            MemberModel.shared.deleteMember(id: userPk)
        }
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController")as? LoginViewController else {return}
        
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
}
