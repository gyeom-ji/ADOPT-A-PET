//
//  MissingNoticeInsertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/18.
//
import Foundation
import UIKit
import Photos
import AVFoundation

extension MissingNoticeInsertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.pickerController.dismiss(animated: true)
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        imgView.image = userPickedImage
        self.imgData = userPickedImage.jpegData(compressionQuality: 0.2)!
        
    }
}


extension MissingNoticeInsertViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
}

class MissingNoticeInsertViewController: UIViewController{
    private var memberM = MemberModel.shared
    private var missingM = MissingNoticeModel.shared
    
    @IBOutlet weak var breedField: UITextFieldDesignable!
    @IBOutlet weak var featureField: UITextFieldDesignable!
    @IBOutlet weak var colorField: UITextFieldDesignable!
    @IBOutlet weak var sexSeg: UISegmentedControl!
    @IBOutlet weak var nameField: UITextFieldDesignable!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var placeField: UITextFieldDesignable!
    @IBOutlet weak var missingDatePicker: UIDatePicker!
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var imgBtn: UIButton!
    
    var ageList = ["미상", "1살", "2살", "3살", "4살", "5살", "6살", "7살", "8살", "9살", "10살", "11살", "12살", "13살", "14살", "15살", "16살", "17살", "18살", "19살", "20살" ]
    var imgData = Data()
    var pickerController = UIImagePickerController()
    var isChange = false
    var userPk = Int()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if isChange == true {
            
            let missing = missingM.missingNotice
            nameField.text = missing.animalName
            
            breedField.text = missing.animal.breed
            
            missing.animal.sex == "수컷" ? (sexSeg.selectedSegmentIndex = 0) : missing.animal.sex == "암컷" ? (sexSeg.selectedSegmentIndex = 1) : (sexSeg.selectedSegmentIndex = 2)
            
            var age = 0
            if missing.animal.age != "미상" {
                age = Int(missing.animal.age.dropLast())!
            }
            
            colorField.text = missing.animal.color
            featureField.text = missing.animal.feature
            
            agePicker.selectRow(age, inComponent: 0, animated: false)
            
            missingDatePicker.date = dateFormatter.date(from: missing.date)!
            
            placeField.text = missing.place
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeRecognizer()
        nameField.becomeFirstResponder()
        
        ///set UsertDefaults
        let defaults = UserDefaults.standard
        self.userPk = defaults.integer(forKey: "pk")
        MemberModel.shared.readMember(id: userPk) {}
        
        agePicker.delegate = self
        agePicker.dataSource = self
        
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
    
    @IBAction func clickSaveBtn(_ sender: UIButton) {
        if isChange == true {
            updateMissingNotice(id: missingM.missingNotice.id)
        }
        else{
            insertMissingNotice(id: userPk)
        }
        self.dismiss(animated: true)
    }
    
}

extension MissingNoticeInsertViewController{

    func insertMissingNotice(id: Int){
        
        guard let name = nameField.text, !name.isEmpty else { return }
        guard let breed = breedField.text, !breed.isEmpty else { return }
        guard let color = colorField.text, !color.isEmpty else { return }
        guard let feature = featureField.text, !feature.isEmpty else { return }
        guard let place = placeField.text, !place.isEmpty else { return }
        
        MissingNoticeModel.shared.insertMissing(memberId: userPk, personName: memberM.member.name, animalName: name, email: memberM.member.email, phone: memberM.member.phone, date: dateFormatter.string(from: missingDatePicker.date), place: place, animal: Animal(id: 0, kind: "", sex: sexSeg.selectedSegmentIndex == 0 ? "수컷" : sexSeg.selectedSegmentIndex == 1 ? "암컷" : "미상", age: ageList[agePicker.selectedRow(inComponent: 0)], color: color, feature: feature, breed: breed, neuter: "", isUrl: false, img: ""))
    }
    
    func updateMissingNotice(id: Int){
        
        guard let name = nameField.text, !name.isEmpty else { return }
        guard let breed = breedField.text, !breed.isEmpty else { return }
        guard let color = colorField.text, !color.isEmpty else { return }
        guard let feature = featureField.text, !feature.isEmpty else { return }
        guard let place = placeField.text, !place.isEmpty else { return }
        
        MissingNoticeModel.shared.updateMissing(memberId: userPk, missingId: id, personName:  memberM.member.name, animalName: name, email: memberM.member.email, phone: memberM.member.phone, date: dateFormatter.string(from: missingDatePicker.date), place: place, animal: Animal(id: missingM.missingNotice.animal.id, kind: "", sex: sexSeg.selectedSegmentIndex == 0 ? "수컷" : sexSeg.selectedSegmentIndex == 1 ? "암컷" : "미상", age: ageList[agePicker.selectedRow(inComponent: 0)], color: color, feature: feature, breed: breed, neuter: "", isUrl: false, img: ""))
    }
}
