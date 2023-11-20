//
//  AbandonedNoticeInsertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/17.
//

import Foundation
import UIKit
import AVFoundation
import Photos

extension AbandonedNoticeInsertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.pickerController.dismiss(animated: true)
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        imgView.image = userPickedImage
        self.imgData = userPickedImage.jpegData(compressionQuality: 0.2)!
    }
}

class AbandonedNoticeInsertViewController: UIViewController{
    private var abandonedM = AbandonedNoticeModel.shared
    
    @IBOutlet weak var noticeNumLabel: UILabel!
    @IBOutlet weak var featureField: UITextFieldDesignable!
    @IBOutlet weak var colorField: UITextFieldDesignable!
    @IBOutlet weak var neuterSwitch: UISwitch!
    @IBOutlet weak var sexSeg: UISegmentedControl!
    @IBOutlet weak var breedField: UITextFieldDesignable!
    @IBOutlet weak var ectBtn: UIButton!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var dogBtn: UIButton!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var receiptDatePicker: UIDatePicker!
    @IBOutlet weak var placeField: UITextFieldDesignable!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var noticeNumField: UITextFieldDesignable!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgBtn: UIButton!
    
    var imgData = Data()
    var pickerController = UIImagePickerController()
    var isChange = Bool()
    var isCheck = false
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if isChange == true {
            let notice = abandonedM.abandonedNotice
            
            noticeNumField.isHidden = true
            checkBtn.isHidden = true
            noticeNumLabel.isHidden = false
            
            noticeNumLabel.text = notice.noticeNum
            placeField.text = notice.place
            
            receiptDatePicker.date = dateFormatter.date(from: notice.receiptDate)!
            
            let period = notice.period.split(separator: " ~ ", maxSplits: 2)
           
            startDatePicker.date = dateFormatter.date(from: String(period[0]))!
            endDatePicker.date = dateFormatter.date(from: String(period[1]))!
            
            notice.animal.kind == "고양이" ? clickCatBtn(catBtn) : notice.animal.kind == "기타축종" ? clickEctBtn(ectBtn) : nil
            
            breedField.text = notice.animal.breed
            notice.animal.sex == "수컷" ? (sexSeg.selectedSegmentIndex = 0) : notice.animal.sex == "암컷" ? (sexSeg.selectedSegmentIndex = 1) : (sexSeg.selectedSegmentIndex = 2)
            //중성화
            notice.animal.neuter == "예" ? (neuterSwitch.isOn = true) : (neuterSwitch.isOn = false)
            colorField.text = notice.animal.color
            featureField.text = notice.animal.feature
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noticeNumLabel.isHidden = true
        swipeRecognizer()
        noticeNumField.becomeFirstResponder()
        clickDogBtn(dogBtn)
        
        //switch color change
        neuterSwitch.onTintColor = UIColor.systemBrown
        neuterSwitch.tintColor = UIColor.beige
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "카메라", image: UIImage(systemName: "camera"), handler: { (_) in self.clickCamera()}),
                UIAction(title: "앨범", image: UIImage(systemName: "photo"), handler: { (_) in self.clickGallery()}),
            ]
        }
        var demoMenu: UIMenu{
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems )
        }
        
        self.imgBtn.menu = demoMenu
        self.imgBtn.showsMenuAsPrimaryAction = true
        
        pickerController.delegate = self
        PHPhotoLibrary.requestAuthorization { (state) in
            print(state)
        }
        AVCaptureDevice.requestAccess(for: .video) { (result) in
            print(result)
        }
        
        hideKeyboardWhenTappedAround()
    }

    
     func clickCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .denied:
            settingAlert(authString: "카메라")
            break
        case .restricted:
            break
        case .authorized:
            self.pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({state in if state == .authorized {
                self.pickerController.sourceType = .camera
                self.present(self.pickerController, animated: true, completion: nil)
            }
                else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
            break
        default:
            break
        }
    }
    
    func clickGallery() {
        switch PHPhotoLibrary.authorizationStatus(){
        case .denied:
            settingAlert(authString: "앨범")
            break
        case .restricted:
            break
        case .authorized:
            self.pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({state in if state == .authorized {
                self.pickerController.sourceType = .photoLibrary
                self.present(self.pickerController, animated: true, completion: nil)
            }
                else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
            break
        default:
            break
        }
    }
    
    func settingAlert(authString: String){
        if let appName = Bundle.main.infoDictionary!["ADOPT A PET"]
            as? String {
            let alert = UIAlertController(title: "설정", message: "\(appName)가 \(authString) 접근이 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default){
                (action) in
            }
            let confirmAction = UIAlertAction(title: "확인", style: .default){
                (action) in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
        }
    }
    
    // 다음 누르면 입력창 넘어가기, 완료 누르면 키보드 내려가기
    @objc func didEndOnExit(_ sender: UITextField) {
        
        if colorField.isFirstResponder {
            featureField.becomeFirstResponder()
        }
    }
    
    @IBAction func clickBackBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clickCheckBtn(_ sender: UIButton) {
        checkNoticeNum(noticeNum: noticeNumField.text!)
    }
    
    
    @IBAction func clickStartDate(_ sender: UIDatePicker) {
        endDatePicker.minimumDate = startDatePicker.date
    }
    
    @IBAction func clickEndDate(_ sender: UIDatePicker) {
        startDatePicker.maximumDate = endDatePicker.date
    }
    
    
    @IBAction func clickDogBtn(_ sender: UIButton) {
        dogBtn.isSelected.toggle()
        if dogBtn.isSelected == true{
            dogBtn.backgroundColor = .beige
            
            if catBtn.isSelected == true {
                clickCatBtn(catBtn)
            }
            if ectBtn.isSelected == true {
                clickEctBtn(ectBtn)
            }
        }
        else{
            dogBtn.backgroundColor = .white
        }
    }
    
    @IBAction func clickCatBtn(_ sender: UIButton) {
        catBtn.isSelected.toggle()

        if catBtn.isSelected == true{
            catBtn.backgroundColor = .beige
            
            if dogBtn.isSelected == true {
                clickDogBtn(dogBtn)
            }
            if ectBtn.isSelected == true {
                clickEctBtn(ectBtn)
            }
        }
        else{
            catBtn.backgroundColor = .white
        }
    }
    
    
    @IBAction func clickEctBtn(_ sender: UIButton) {
        ectBtn.isSelected.toggle()

        if ectBtn.isSelected == true{
            ectBtn.backgroundColor = .beige
            
            if catBtn.isSelected == true {
                clickCatBtn(catBtn)
            }
            if dogBtn.isSelected == true {
                clickDogBtn(dogBtn)
            }
        }
        else{
            ectBtn.backgroundColor = .white
        }
    }
    
    @IBAction func clickSaveBtn(_ sender: UIButton) {
        if isChange == false {
            if isCheck == true {
                updateAbandonedNotice(shelterId: 1)
               
                self.dismiss(animated: true)
            }
            else {
                let alert = UIAlertController(title: "", message: "공고번호 중복확인을 해주세요", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            updateAbandonedNotice(shelterId: 1)
            self.dismiss(animated: true)
        }
    }
    
}

extension AbandonedNoticeInsertViewController{
    
    func insertAbandonedNotice(shelterId: Int){
 
        AbandonedNoticeModel.shared.insertAbandoned(noticeNum: noticeNumField.text!, receiptDate: dateFormatter.string(from: receiptDatePicker.date), place: placeField.text!, period: dateFormatter.string(from: startDatePicker.date) + " ~ " + dateFormatter.string(from: endDatePicker.date), animal: Animal(id: 0, kind: dogBtn.isSelected == true ? "개" : catBtn.isSelected == true ? "고양이" : "기타축종", sex: sexSeg.selectedSegmentIndex == 0 ? "수컷" : sexSeg.selectedSegmentIndex == 1 ? "암컷" : "미상", age: "", color: colorField.text!, feature: featureField.text!, breed: breedField.text!, neuter: neuterSwitch.isOn ? "예" : "아니오", isUrl: false, img: ""), shelterListId: shelterId){
            (response) in
            if let response = response {
                if !response {
                    print("fail")
                }
            }
        }
    }
    
    func updateAbandonedNotice(shelterId: Int){
        
        abandonedM.updateAbandoned(abandonedId: abandonedM.abandonedNotice.id,noticeNum:abandonedM.abandonedNotice.noticeNum, receiptDate: dateFormatter.string(from: receiptDatePicker.date), place: placeField.text!, period: dateFormatter.string(from: startDatePicker.date) + " ~ " + dateFormatter.string(from: endDatePicker.date), animal: Animal(id: abandonedM.abandonedNotice.animal.id, kind: dogBtn.isSelected == true ? "개" : catBtn.isSelected == true ? "고양이" : "기타축종", sex: sexSeg.selectedSegmentIndex == 0 ? "수컷" : sexSeg.selectedSegmentIndex == 1 ? "암컷" : "미상", age: "", color: colorField.text!, feature: featureField.text!, breed: breedField.text!, neuter: neuterSwitch.isOn ? "예" : "아니오", isUrl: false, img: ""), shelterListId: shelterId){
            (response) in
            if let response = response {
                if !response {
                    print("fail")
                }
            }
        }
    }
    
    func checkNoticeNum(noticeNum: String){
        AbandonedNoticeModel.shared.checkNoticeNum(noticeNum: noticeNum){
            (response) in
            if response == false {
                self.isCheck = true
                let alert = UIAlertController(title: "", message: "사용가능한 공고번호 입니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "", message: "존재하는 공고번호입니다. 다시 입력해주세요", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                }
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
