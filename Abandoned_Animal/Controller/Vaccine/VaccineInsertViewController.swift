//
//  VaccineInsertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/02/02.
//

import Foundation
import UIKit

class VaccineInsertViewController: UIViewController{
    
    @IBOutlet weak var boosterTextView: UITextViewDesignable!
    @IBOutlet weak var addTextView: UITextViewDesignable!
    @IBOutlet weak var typeSeg: UISegmentedControl!
    @IBOutlet weak var basicTextView: UITextView!
    @IBOutlet weak var nameField: UITextFieldDesignable!
    let basicTextViewPlaceHolder = "기초접종 정보를 입력해주세요"
    let addTextViewPlaceHolder = "추가접종 정보를 입력해주세요"
    let boosterTextViewPlaceHolder = "보강접종 정보를 입력해주세요"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        nameField.becomeFirstResponder()
        
        hideKeyboardWhenTappedAround()
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        
        if addTextView.isFirstResponder {
            boosterTextView.becomeFirstResponder()
        }
        if basicTextView.isFirstResponder {
            addTextView.becomeFirstResponder()
        }
        if nameField.isFirstResponder {
            basicTextView.becomeFirstResponder()
        }
    }
    
    @IBAction func clickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickSaveBtn(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty else { self.setAlarm(str: "백신 명을 입력해주세요."); return }
      
     
        insertVaccine(name: name, basicVaccine: basicTextView.text!, addVaccine: addTextView.text!, boosterVaccine: boosterTextView.text!)
        self.dismiss(animated: true)
    }
    
    func setAlarm(str: String){
        let alert = UIAlertController(title: "", message: str, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default){
            (action) in
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension VaccineInsertViewController{
    func insertVaccine(name: String, basicVaccine: String, addVaccine: String, boosterVaccine: String){
        
        VaccineModel.shared.insertVaccine(name: name, basicVaccine: basicVaccine, addVaccine: addVaccine, boosterVaccine: boosterVaccine , animalType: typeSeg.selectedSegmentIndex == 0 ? "강아지" : typeSeg.selectedSegmentIndex == 1 ? "고양이" : "기타축종")
    }
}
