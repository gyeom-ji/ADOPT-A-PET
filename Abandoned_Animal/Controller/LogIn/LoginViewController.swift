//
//  LoginViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var pwEyeBtn: UIButton!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var idField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        let eyeImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
        
        pwEyeBtn.tintColor = .systemBrown
        pwField.isSecureTextEntry = true
        pwEyeBtn.setImage(eyeImage, for: .normal)
        
        idField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        pwField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        guard let id = idField.text, !id.isEmpty else { self.setAlarm(str: "아이디를 입력해주세요."); return }
        guard let password = pwField.text, !password.isEmpty else { self.setAlarm(str: "비밀번호를 입력해주세요."); return }
        
        if id[id.startIndex] == "#" {
            staffLogin(id: id, pw: password)
        } else if id[id.startIndex] == "@" {
            adminLogin(id: id, pw: password)
        } else{
            memberLogin(id: id, pw: password)
        }
    }
    
    func setAlarm(str: String){
        let alert = UIAlertController(title: "", message: str, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default){
            (action) in
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didEndOnExit(_ sender: UITextField) {
        if idField.isFirstResponder {
            pwField.becomeFirstResponder()
        }
    }
    
    @IBAction func clickPasswordEyeBtn(_ sender: UIButton) {
        // 보안 설정 반전
        pwField.isSecureTextEntry.toggle()
        // 버튼 선택 상태 반전
        pwField.isSelected.toggle()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        // 버튼 선택 상태에 따른 눈 모양 이미지 변경
        let eyeImage = UIImage(systemName: pwEyeBtn.isSelected ? "eye.slash" : "eye", withConfiguration: imageConfig)
        pwEyeBtn.setImage(eyeImage, for: .normal)
        // 버튼 선택된 경우 자동으로 들어가는 틴트 컬러를 투명으로 변경해줌
        pwEyeBtn.isSelected.toggle()
    }
    
}

extension LoginViewController{
    
    func memberLogin(id: String, pw:String){
        MemberModel.shared.loginMember(id: id, pw: pw){
            response in
            if let response = response {
                if response {
                    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "UITabBarController")as? UITabBarController else {return}
                    nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    self.present(nextVC, animated: true, completion: nil)
                }
                else {
                    self.setAlarm(str: "입력한 정보에 해당하는 계정이 없습니다. 다시 시도해주세요.")
                }
            }
        }
    }
    
    func staffLogin(id: String, pw:String){
        ShelterStaffModel.shared.loginStaff(id: id, pw: pw){
            response in
            if let response = response {
                print(response)
                if response {
                    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "UITabBarController")as? UITabBarController else {return}
                    nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    self.present(nextVC, animated: true, completion: nil)
                    //#staff69888
                }
                else {
                    self.setAlarm(str: "입력한 정보에 해당하는 계정이 없습니다.")
                }
            }
        }
    }
    
    func adminLogin(id: String, pw:String){
        AdminModel.shared.loginAdmin(id: id, pw: pw){
            response in
            if let response = response {
                if response {
                    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "UITabBarController")as? UITabBarController else {return}
                    nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    self.present(nextVC, animated: true, completion: nil)
                }
                else {
                    self.setAlarm(str: "입력한 정보에 해당하는 계정이 없습니다.")
                }
            }
        }
    }
}
