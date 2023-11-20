//
//  SignUpViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation
import UIKit
import JSPhoneFormat

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idCheckBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var pwEyeBtn: UIButton!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    var isCheck = Bool()
    var buttonBottomConstraint: NSLayoutConstraint?
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = phoneField.text else { return }
        phoneField.text = phoneFormat.addCharacter(at: text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.idField.becomeFirstResponder()
        
        pwEyeBtn.tintColor = .systemBrown
        let eyeImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
        pwField.isSecureTextEntry = true
        pwEyeBtn.setImage(eyeImage, for: .normal)
        

        buttonBottomConstraint?.isActive = true
        
        //자동완성 끄기
        idField.autocorrectionType = .no
        pwField.autocorrectionType = .no
        phoneField.autocorrectionType = .no
        emailField.autocorrectionType = .no
        nameField.autocorrectionType = .no
        
        idField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        pwField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        phoneField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        phoneField.addTarget(self,action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        nameField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
    }
        
    @IBAction func clickSignUpBtn(_ sender: UIButton) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let id = idField.text, !id.isEmpty else { return }
        guard let password = pwField.text, !password.isEmpty else { return }
        guard let name = nameField.text, !name.isEmpty else { return }
        guard let phone = phoneField.text, !phone.isEmpty else { return }
        guard let email = emailField.text, !email.isEmpty else { return }
            
        //아이디 인증
        if isCheck == true{
            if isValidEmail(id: email){
                if let removable = self.view.viewWithTag(100) {
                    removable.removeFromSuperview()
                }
            }
            else {
                shakeTextField(textField: emailField, first: 5, second: 5)
                emailField.text = ""
                emailField.attributedPlaceholder = NSAttributedString(
                    string: "이메일 형식을 확인해 주세요",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 102/255, green: 51/255, blue: 0/255, alpha: 1)])
                
            } // 이메일 형식 오류
            insertMember(id: id, pw: password, name: name, phone: phone, email: email)
        }
        else{
            let alert = UIAlertController(title: "", message: "아이디 중복확인을 해주세요", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default){
                (action) in
            }
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {

        if phoneField.isFirstResponder {
            emailField.becomeFirstResponder()
        }
        if nameField.isFirstResponder {
            phoneField.becomeFirstResponder()
        }
        if pwField.isFirstResponder {
            nameField.becomeFirstResponder()
        }
        if idField.isFirstResponder {
            pwField.becomeFirstResponder()
        }
    }
    
    @IBAction func clickPasswordEyeBtn(_ sender: UIButton) {
        // 보안 설정 반전
        pwField.isSecureTextEntry.toggle()
        // 버튼 선택 상태에 따른 눈 모양 이미지 변경
        let eyeImage = UIImage(systemName: pwEyeBtn.isSelected ? "eye.slash" : "eye", withConfiguration: imageConfig)
        pwEyeBtn.setImage(eyeImage, for: .normal)
        // 버튼 선택 상태 반전
        pwEyeBtn.isSelected.toggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
    }
    
    // 이메일 형식 검사
    func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
    
    func moveToLoginView(){
        self.dismiss(animated: true)
    }
    
    @IBAction func clickIdCheckBtn(_ sender: UIButton) {
        guard let id = idField.text, !id.isEmpty else { return }
        checkExistId(id: id)
    }
    
}

extension SignUpViewController{
    
    func insertMember(id:String, pw: String, name:String, phone: String, email:String){
        MemberModel.shared.insertMember(id: id, pw: pw, name: name, phone: phone, email: email){ response in
            if response == true {
                
                let alert = UIAlertController(title: "회원가입 완료", message: "로그인 화면으로 이동합니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in self.moveToLoginView()
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "회원가입 실패", message: "다시 시도해 주세요", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func checkExistId(id: String){
        MemberModel.shared.checkExistMember(id: id){
            (response) in
            if response == false {
                self.isCheck = true
                
                let alert = UIAlertController(title: "", message: "사용가능한 아이디입니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "", message: "존재하는 아이디입니다. 다시 입력해주세요", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
