//
//  CheckPasswordViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/19.
//

import Foundation
import UIKit

class CheckPasswordViewController: UIViewController{
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var pwField: UITextFieldDesignable!
    @IBOutlet weak var pwEyeBtn: UIButton!
    
    var userPk = Int()
    var userType = Int()
    var isRetry = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        let defaults = UserDefaults.standard
        self.userType = defaults.integer(forKey: "userType")
        self.userPk = defaults.integer(forKey: "pk")
        
        ///pwField 보안 설정
        pwEyeBtn.tintColor = .systemBrown
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        let eyeImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
        pwField.isSecureTextEntry = true
        pwEyeBtn.setImage(eyeImage, for: .normal)

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
    
    @IBAction func clickOkBtn(_ sender: UIButton) {
        guard let password = pwField.text, !password.isEmpty else { self.setAlarm(str: "비밀번호를 입력해주세요."); return }
        if userType == 1 {
            checkPasswordStaff(id: userPk, pw: password)
        }
        else{
            checkPasswordMember(id: userPk, pw: password)
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
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}

extension CheckPasswordViewController{
    
    func checkPasswordMember(id: Int, pw: String){
        MemberModel.shared.isPwMember(id: id, pw: pw){ response in
            if response == true {
                self.dismiss(animated: true)
            }
            else{
                DispatchQueue.main.async {
                    self.shakeTextField(textField: self.pwField, first: 10, second: 20)
                    self.pwLabel.text = "비밀번호가 틀립니다. 다시 입력해주세요"
                    self.pwField.text = ""
                }
            }
        }
    }
    
    func checkPasswordStaff(id: Int, pw: String){
        ShelterStaffModel.shared.isPwStaff(id: id, pw: pw){ response in
            if response == true {
                self.dismiss(animated: true)
            }
            else{
                DispatchQueue.main.async {
                    self.shakeTextField(textField: self.pwField, first: 10, second: 20)
                    self.pwLabel.text = "비밀번호가 틀립니다. 다시 입력해주세요"
                    self.pwField.text = ""
                }
            }
        }
    }
}
