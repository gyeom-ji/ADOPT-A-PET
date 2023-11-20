//
//  FindIdViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import Foundation
import UIKit
import JSPhoneFormat

class FindIdViewController: UIViewController{
    @IBOutlet weak var idField: UITextFieldDesignable!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var phoneField: UITextFieldDesignable!
    @IBOutlet weak var nameField: UITextFieldDesignable!
    @IBOutlet weak var pwLine: UIView!
    @IBOutlet weak var idLine: UIView!
    @IBOutlet weak var findPwBtn: UIButton!
    @IBOutlet weak var findIdBtn: UIButton!
 
    var isPwSelect: Bool?
    var result: String?

    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = phoneField.text else { return }
        phoneField.text = phoneFormat.addCharacter(at: text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idLabel.isHidden = true
        idField.isHidden = true
        clickIdFindBtn(findIdBtn)
        isPwSelect = false
        //자동완성 끄기
        idField.autocorrectionType = .no
        phoneField.autocorrectionType = .no
        nameField.autocorrectionType = .no
        
        idField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        phoneField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        phoneField.addTarget(self,action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameField.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        
        hideKeyboardWhenTappedAround()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = isPwSelect {
            clickPwFindBtn(findPwBtn)
            idField.text = result
        }
    }
    
    @IBAction func clickPwFindBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.7, animations: {
            self.pwLine.backgroundColor = .systemBrown
            self.idLine.backgroundColor = .lightGray
            self.findPwBtn.tintColor = .systemBrown
            self.findIdBtn.tintColor = .lightGray
        })
        idLabel.isHidden = false
        idField.isHidden = false
        findBtn.setTitle("비밀번호 재설정", for: .normal)
        findBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        isPwSelect = true
    }
    
    @IBAction func clickIdFindBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.7, animations: {
            self.idLine.backgroundColor = .systemBrown
            self.pwLine.backgroundColor = .lightGray
            self.findIdBtn.tintColor = .systemBrown
            self.findPwBtn.tintColor = .lightGray
        })
        idLabel.isHidden = true
        idField.isHidden = true
        findBtn.setTitle("아이디 찾기", for: .normal)
        findBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        isPwSelect = false
    }
    
    @IBAction func clickFindBtn(_ sender: UIButton) {

        guard let name = nameField.text, !name.isEmpty else { return }
        guard let phone = phoneField.text, !phone.isEmpty else { return }
        
        if isPwSelect == false {
            findIdMember(name: name, phone: phone)
        }
        else {
            guard let id = idField.text, !id.isEmpty else { return }
            if id[id.startIndex] != "#" {
                findPwMember(id: id, name: name, phone: phone)
            }
            else{
                findPwStaff(id: id, name: name, phone: phone)
            }
        }
    }
    
    @objc func didEndOnExit(_ sender: UITextField) {

        if nameField.isFirstResponder {
            phoneField.becomeFirstResponder()
        }
        if idField.isFirstResponder {
            nameField.becomeFirstResponder()
        }
    }
}

extension FindIdViewController{
    
    func findIdMember(name: String, phone: String){
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FindLoginAlertViewController")as? FindLoginAlertViewController else {return}
        
        MemberModel.shared.findIdMember(name: name, phone: phone){
            response in
            
            if response != "" {
                self.result = response
                nextVC.color = "darkGreen"
                nextVC.firstLabelText = "입력한 정보와 일치한 아이디를 찾았습니다."
                nextVC.secondLabelText = "아이디 : " + self.result!
                nextVC.firstBtnText = "확인"
                nextVC.secondBtnText = "비밀번호 재설정"
                
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.modalTransitionStyle = .crossDissolve
                self.present(nextVC, animated: true, completion: nil)
            }
            else{
                self.findIdStaff(name: name, phone: phone)
            }
        }
    }
    
    func findIdStaff(name: String, phone: String){
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FindLoginAlertViewController")as? FindLoginAlertViewController else {return}
        
        ShelterStaffModel.shared.findIdStaff(name: name, phone: phone){
            response in
            if response != "" {
                self.result = response
                
                nextVC.color = "darkGreen"
                nextVC.firstLabelText = "입력한 정보와 일치한 아이디를 찾았습니다."
                nextVC.secondLabelText = "아이디 : " + self.result!
                nextVC.firstBtnText = "확인"
                nextVC.secondBtnText = "비밀번호 재설정"
                
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.modalTransitionStyle = .crossDissolve
                self.present(nextVC, animated: true, completion: nil)
            }
            else{
                nextVC.color = "orange"
                nextVC.firstLabelText = "입력한 정보와 일치하는 아이디가 존재하지 않습니다. 다시 입력해주세요"
                nextVC.secondLabelText = ""
                nextVC.firstBtnText = "확인"
                nextVC.secondBtnText = "나가기"
                
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.modalTransitionStyle = .crossDissolve
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    
    func findPwMember(id:String, name:String, phone:String){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FindLoginAlertViewController")as? FindLoginAlertViewController else {return}
        
        MemberModel.shared.findPwMember(memberId: id, name: name, phone: phone){
            response in
            if let response = response {
                if response != -1 {
                    nextVC.pk = response
                    nextVC.color = "darkGreen"
                    nextVC.isMember = true
                    nextVC.firstLabelText = "새로운 비밀번호를 입력해주세요."
                    nextVC.secondLabelText = "*"
                    nextVC.firstBtnText = "변경하기"
                    nextVC.secondBtnText = "나가기"
                    
                    nextVC.modalPresentationStyle = .overFullScreen
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.present(nextVC, animated: true, completion: nil)
                } else{
                    nextVC.color = "orange"
                    nextVC.firstLabelText = "입력한 정보에 해당하는 계정이 존재하지 않습니다. 다시 입력해주세요."
                    nextVC.secondLabelText = ""
                    nextVC.firstBtnText = "확인"
                    nextVC.secondBtnText = "비밀번호 재설정"
                    
                    nextVC.modalPresentationStyle = .overFullScreen
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.present(nextVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func findPwStaff(id:String, name:String, phone:String){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "FindLoginAlertViewController")as? FindLoginAlertViewController else {return}
        
        ShelterStaffModel.shared.findPwStaff(staffId: id, name: name, phone: phone){
            response in
            if let response = response {
                if response != -1 {
                    nextVC.pk = response
                    nextVC.isMember = false
                    nextVC.color = "darkGreen"
                    nextVC.firstLabelText = "새로운 비밀번호를 입력해주세요."
                    nextVC.secondLabelText = "*"
                    nextVC.firstBtnText = "변경하기"
                    nextVC.secondBtnText = "나가기"
                    
                    nextVC.modalPresentationStyle = .overFullScreen
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.present(nextVC, animated: true, completion: nil)
                }
                else{
                    nextVC.color = "orange"
                    nextVC.firstLabelText = "입력한 정보에 해당하는 계정이 존재하지 않습니다. 다시 입력해주세요."
                    nextVC.secondLabelText = ""
                    nextVC.firstBtnText = "확인"
                    nextVC.secondBtnText = "비밀번호 재설정"
                    
                    nextVC.modalPresentationStyle = .overFullScreen
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.present(nextVC, animated: true, completion: nil)
                }
            }
        }
    }
}
