//
//  FormInsertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/17.
//

import Foundation
import UIKit

class FormInsertViewController: UIViewController{
    private var memberM = MemberModel.shared
    private var abandonedM = AbandonedNoticeModel.shared
    private var formM = FormModel.shared
    
    @IBOutlet weak var feature: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var adoptionBtn: UIButton!
    @IBOutlet weak var protectionBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!

    var isChange = Bool()
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        memberM.readMember(id: defaults.integer(forKey: "pk")){
            
        }
        
        DispatchQueue.main.async {
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "CheckViewController")as? CheckViewController else {return}
          
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
        }
        clickAdoptionBtn(adoptionBtn)
        
        let abandoned = abandonedM.abandonedNotice
        
        feature.text = abandoned.animal.feature
        color.text = abandoned.animal.color
        age.text = abandoned.animal.neuter
        sex.text = abandoned.animal.sex
        breed.text =  abandoned.animal.breed
        kind.text =  abandoned.animal.kind
        
        if abandoned.animal.isUrl == true {
            let url = URL(string: abandoned.animal.img)
            imgView.load(url: url!)
        }
        swipeRecognizer()
    }
    
    @IBAction func clickProtectionBtn(_ sender: UIButton) {
        protectionBtn.isSelected.toggle()
        
        if protectionBtn.isSelected == true{
            protectionBtn.backgroundColor = .beige
   
            if adoptionBtn.isSelected == true {
                clickAdoptionBtn(adoptionBtn)
            }
        }
        else{
            protectionBtn.backgroundColor = .white
        }
    }
    
    @IBAction func clickAdoptionBtn(_ sender: UIButton) {
        adoptionBtn.isSelected.toggle()
        if adoptionBtn.isSelected == true{
            adoptionBtn.backgroundColor = .beige
            
            if protectionBtn.isSelected == true {
                clickProtectionBtn(protectionBtn)
            }
        }
        else{
            adoptionBtn.backgroundColor = .white
        }
    }
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickOkBtn(_ sender: UIButton) {
        if isChange {
            updateForm(type: adoptionBtn.isSelected ? "입양신청" : "임시보호신청")
        }
        else{
            insertForm(type: (adoptionBtn.isSelected ? "입양신청" : "임시보호신청"), approval: "검토중")
        }
        self.dismiss(animated: true)
    }
}

extension FormInsertViewController{
    
    func insertForm(type: String, approval: String){
        formM.insertForm(type: type, approval: approval, abandoned: AbandonedNotice(id: abandonedM.abandonedNotice.id, noticeNum: abandonedM.abandonedNotice.noticeNum, receiptDate: abandonedM.abandonedNotice.receiptDate, place: abandonedM.abandonedNotice.place, period: abandonedM.abandonedNotice.period, animal: abandonedM.abandonedNotice.animal, shelter: abandonedM.abandonedNotice.shelter), member: Member(id: memberM.member.id, memberId: memberM.member.memberId, memberPw: memberM.member.memberPw, name: memberM.member.name, phone: memberM.member.phone, email: memberM.member.email))
    }
    
    func updateForm(type: String){
        formM.updateForm(id: formM.form.id, type: type, approval: formM.form.approval, abandoned: AbandonedNotice(id: abandonedM.abandonedNotice.id, noticeNum: abandonedM.abandonedNotice.noticeNum, receiptDate: abandonedM.abandonedNotice.receiptDate, place: abandonedM.abandonedNotice.place, period: abandonedM.abandonedNotice.period, animal: abandonedM.abandonedNotice.animal, shelter: abandonedM.abandonedNotice.shelter), member: Member(id: memberM.member.id, memberId: memberM.member.memberId, memberPw: memberM.member.memberPw, name: memberM.member.name, phone: memberM.member.phone, email: memberM.member.email))
    }
}
