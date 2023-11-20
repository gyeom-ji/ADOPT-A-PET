//
//  MyInfoViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/19.
//

import Foundation
import UIKit

class MyInfoViewController: UIViewController{
    private var memberM = MemberModel.shared
    private var staffM = ShelterStaffModel.shared
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var pwEyeBtn: UIButton!
    @IBOutlet weak var pwField: UITextFieldDesignable!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailField: UITextFieldDesignable!
    @IBOutlet weak var phoneField: UITextFieldDesignable!
    @IBOutlet weak var nameField: UITextFieldDesignable!
    @IBOutlet weak var infoEditBtn: UIButton!
    @IBOutlet weak var changePwBtn: UIButton!
    
    var userType = Int()
    var isPw = Bool()
    var userPk = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CheckPasswordViewController")as? CheckPasswordViewController else {return}

            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
            
            if self.userType == 1 {
                self.readShelterStaff(id: self.userPk)
            }
            else{
                self.readMember(id: self.userPk)
            }
        }
        
        let defaults = UserDefaults.standard
        self.userType = defaults.integer(forKey: "userType")
        self.userPk = defaults.integer(forKey: "pk")

        swipeRecognizer()
        
        pwField.isSecureTextEntry = true
        pwEyeBtn.tintColor = .systemBrown
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        let eyeImage = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
        pwField.isSecureTextEntry = true
        pwEyeBtn.setImage(eyeImage, for: .normal)
        
        emailField.isHidden = true
        phoneField.isHidden = true
        nameField.isHidden = true
        pwLabel.isHidden = true
        pwField.isHidden = true
        pwEyeBtn.isHidden = true
        updateBtn.isHidden = true
        isPw = false
        
        nameField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        phoneField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        emailField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        hideKeyboardWhenTappedAround()
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        if phoneField.isFirstResponder {
            emailField.becomeFirstResponder()
        }
        if nameField.isFirstResponder {
            phoneField.becomeFirstResponder()
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
    
    @IBAction func clickInfoEditBtn(_ sender: UIButton) {
        
        phoneField.text = ""
        nameField.text = ""
        emailField.text = ""
        
        emailLabel.isHidden = true
        phoneLabel.isHidden = true
        nameLabel.isHidden = true
        phoneField.isHidden = false
        nameField.isHidden = false
        pwLabel.isHidden = true
        pwField.isHidden = true
        
        if userType == 2 {
            emailField.isHidden = false
        }
        else{
            emailField.isHidden = true
        }
       
        infoEditBtn.isHidden = true
        changePwBtn.isHidden = true
        updateBtn.isHidden = false
        isPw = false
    }
    
    @IBAction func clickUpdateBtn(_ sender: UIButton) {
        guard let phone = phoneField.text, !phone.isEmpty else { self.setAlert(title: "", message: "전화번호를 입력해주세요."); return }
        guard let name = nameField.text, !name.isEmpty else { self.setAlert(title: "", message: "이름을 입력해주세요."); return }

        if userType == 2 {
            if isPw == true{
                guard let password = pwField.text, !password.isEmpty else { self.setAlert(title: "", message: "비밀번호를 입력해주세요."); return }
                updateMemberPw(id: userPk, pw: password)
               
            }
            else{
                guard let email = emailField.text, !email.isEmpty else { self.setAlert(title: "", message: "이메일을 입력해주세요."); return }
                updateMember(id: userPk, name: name, phone: phone, email: email)
            }
        }
        else{
            if isPw == true{
                guard let password = pwField.text, !password.isEmpty else { self.setAlert(title: "", message: "비밀번호를 입력해주세요."); return }
                updateStaffPw(id: userPk, pw: password)
            }
            else{
                updateStaff(id: userPk, name: name, phone: phone)
            }
        }
        
        infoEditBtn.isHidden = false
        changePwBtn.isHidden = false
        updateBtn.isHidden = true

    }
    
    @IBAction func clickChangePwBtn(_ sender: UIButton) {
        pwField.text = ""
        emailField.isHidden = true
        phoneField.isHidden = true
        nameField.isHidden = true
        nameLabel.isHidden = true
        phoneLabel.isHidden = true
        emailLabel.isHidden = true
        pwLabel.isHidden = false
        pwField.isHidden = false
        
        isPw = true

        infoEditBtn.isHidden = true
        changePwBtn.isHidden = true
        updateBtn.isHidden = false

    }
    
    func setAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in  self.clickOkBtn()}))

        present(alert, animated: true)
    }
    
    
    func clickOkBtn(){
        
        if userType == 1 {
            readShelterStaff(id: userPk)
        }
        else{
            readMember(id: userPk)
        }
        emailLabel.isHidden = false
        phoneLabel.isHidden = false
        nameLabel.isHidden = false
        emailField.isHidden = true
        phoneField.isHidden = true
        nameField.isHidden = true
        pwLabel.isHidden = true
        pwField.isHidden = true
        
    }
    
    @IBAction func clickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension MyInfoViewController{
    
    func readMember(id:Int){
        memberM.readMember(id: id){
            DispatchQueue.main.async {
                self.nameLabel.text = self.memberM.member.name
                self.emailLabel.text = self.memberM.member.email
                self.phoneLabel.text = self.memberM.member.phone
            }
        }
    }
    
    func readShelterStaff(id:Int){
        staffM.readStaff(id: id){
            DispatchQueue.main.async {
                self.nameLabel.text = self.staffM.staff.name
                self.emailLabel.isHidden = true
                self.phoneLabel.text = self.staffM.staff.phone
            }
        }
    }
    
    func updateMember(id: Int, name: String, phone: String, email: String){
        memberM.updateMember(id: id, memberId: memberM.member.memberId, pw: memberM.member.memberPw, name:name, phone: phone, email: email){
            (response) in
            if response == true {
                self.setAlert(title: "내 정보", message: "수정이 완료되었습니다")
            }
            else
            {
                self.setAlert(title: "내정보 수정 실패", message: "다시 시도해주세요")
            }
        }
    }
    
    func updateStaff(id: Int, name: String, phone: String){
        staffM.updateStaff(id: id, staffId: staffM.staff.staffId, staffPw: staffM.staff.staffPw, name: name, phone: phone, shelterId: staffM.staff.shelter.id){
            (response) in
            if response == true {
                self.setAlert(title: "내 정보", message: "수정이 완료되었습니다")
            }
            else
            {
                self.setAlert(title: "내정보 수정 실패", message: "다시 시도해주세요")
            }
        }
    }
    
    func updateMemberPw(id:Int, pw: String){
        memberM.updatePwMember(id: id, pw: pw){
            response in
            if response == true {
                self.setAlert(title: "비밀번호", message: "수정이 완료되었습니다")
            }
            else
            {
                self.setAlert(title: "비밀번호 수정 실패", message: "다시 시도해주세요")
            }
        }
    }
    
    func updateStaffPw(id:Int, pw: String){
        staffM.updatePwStaff(id: id, pw: pw){
            response in
            if response == true {
                self.setAlert(title: "비밀번호", message: "수정이 완료되었습니다")
            }
            else
            {
                self.setAlert(title: "비밀번호 수정 실패", message: "다시 시도해주세요")
            }
        }
    }
}
