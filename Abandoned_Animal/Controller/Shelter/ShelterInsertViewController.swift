//
//  ShelterInsertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/02/02.
//

import Foundation
import UIKit

class ShelterInsertViewController: UIViewController{
    
    @IBOutlet weak var typeSeg: UISegmentedControl!
    @IBOutlet weak var endPicker: UIDatePicker!
    @IBOutlet weak var startPicker: UIDatePicker!
    @IBOutlet weak var addressField: UITextFieldDesignable!
    @IBOutlet weak var cityField: UITextFieldDesignable!
    @IBOutlet weak var countyField: UITextFieldDesignable!
    @IBOutlet weak var phoneField: UITextFieldDesignable!
    @IBOutlet weak var nameField: UITextFieldDesignable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeRecognizer()
        nameField.becomeFirstResponder()
        
        hideKeyboardWhenTappedAround()
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        
        if cityField.isFirstResponder {
            addressField.becomeFirstResponder()
        }
        if countyField.isFirstResponder {
            cityField.becomeFirstResponder()
        }
        if phoneField.isFirstResponder {
            countyField.becomeFirstResponder()
        }
        if nameField.isFirstResponder {
            phoneField.becomeFirstResponder()
        }
    }
    
    @IBAction func clickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickSaveBtn(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty else { self.setAlarm(str: "보호센터 명을 입력해주세요."); return }
        guard let phone = phoneField.text, !phone.isEmpty else { self.setAlarm(str: "전화번호를 입력해주세요."); return }
        guard let county = countyField.text, !county.isEmpty else { self.setAlarm(str: "시도를 입력해주세요."); return }
        guard let city = cityField.text, !city.isEmpty else { self.setAlarm(str: "시군구를 입력해주세요."); return }
        guard let address = addressField.text, !address.isEmpty else { self.setAlarm(str: "읍면동을 입력해주세요."); return }
        insertShelter(name: name, phone: phone, county: county, city: city, address: address)
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

extension ShelterInsertViewController{
    func insertShelter(name: String, phone: String, county: String, city: String, address: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        
        ShelterModel.shared.insertShelter(name: name, phone: phone, county: county, city: city, address: address, type: typeSeg.selectedSegmentIndex == 0 ? "법인" : typeSeg.selectedSegmentIndex == 1 ? "사설" : "동물병원", openTime: dateFormatter.string(from: startPicker.date), closeTime: dateFormatter.string(from: endPicker.date))
    }
}
