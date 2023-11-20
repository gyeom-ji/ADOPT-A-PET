//
//  FindLoginAlertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import Foundation
import UIKit

class FindLoginAlertViewController: UIViewController{
    
    @IBOutlet weak var pwEyeBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pwField: UITextFieldDesignable!
    
    var color = String()
    var firstLabelText = String()
    var secondLabelText = String()
    var firstBtnText = String()
    var secondBtnText = String()
    var pk = Int()
    var isMember = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.tintColor = UIColor(named: color)
        firstBtn.setTitle(firstBtnText, for: .normal)
        secondBtn.setTitle(secondBtnText, for: .normal)
        firstLabel.text = firstLabelText
        if secondLabelText == "*" {
            secondLabel.isHidden = true
            pwField.isHidden = false
        }
        else{
            secondLabel.isHidden = false
            pwField.isHidden = true
            secondLabel.text = secondLabelText
        }
        firstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        firstBtn.sizeToFit()
        secondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        hideKeyboardWhenTappedAround()
        
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
    
    @IBAction func clickSecondBtn(_ sender: UIButton) {
        if secondBtnText == "비밀번호 재설정" {
            let preVC = self.presentingViewController
            
            guard let vc = preVC as? FindIdViewController else {return}
            vc.isPwSelect = true
            self.presentingViewController?.dismiss(animated: true)
        }
        //나가기
        else{
            moveToLoginView()
        }
    }
    
    @IBAction func clickFirstBtn(_ sender: UIButton) {
        
        if firstBtnText == "확인" {
            self.dismiss(animated: true)
        }
        else { //변경하기
            guard let pw = pwField.text, !pw.isEmpty else { self.setAlarm(); return }
            
            if isMember == true{
                updatePwMember(id: pk, pw:pw)
            }
            else{
                updatePwStaff(id: pk, pw: pw)
            }
        }
        
    }
    
    func setAlarm(){
        let alert = UIAlertController(title: "", message: "재설정할 비밀번호를 입력해주세요.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default){
                (action) in
            }
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
    }
    
    func moveToLoginView(){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController")as? LoginViewController else {return}
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
}

extension FindLoginAlertViewController{
    
    func updatePwMember(id: Int, pw: String){
        MemberModel.shared.updatePwMember(id: id, pw: pw){ response in
            if response  == true {
                
                let alert = UIAlertController(title: "비밀번호 재설정 완료", message: "로그인 화면으로 이동합니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in self.moveToLoginView()
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "비밀번호 재설정 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updatePwStaff(id: Int, pw: String){
        ShelterStaffModel.shared.updatePwStaff(id: id, pw: pw){ response in
            if response  == true {
                
                let alert = UIAlertController(title: "비밀번호 재설정 완료", message: "로그인 화면으로 이동합니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in self.moveToLoginView()
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "비밀번호 재설정 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
