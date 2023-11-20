//
//  RegionAlertViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/15.
//

import Foundation
import UIKit

protocol SendRegionInfoDelegate {
    func sendRegionInfo(region: String, city: String)
}

extension RegionAlertViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return citiesManager.region.count
        }
        else{
            let selectedCity = regionPicker.selectedRow(inComponent: 0)
            
            return citiesManager.region[selectedCity].city.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
               return citiesManager.region[row].name
           } else {
               // 나머지 컴포넌트의 행에는 0번째 컴포넌트에서 선택한 도시에 대한
               // tourAttractions 배열의 값들이 나온다.
               let selectedCity = regionPicker.selectedRow(inComponent: 0)
               return citiesManager.region[selectedCity].city[row]
           }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
                // 특정 컴포넌트의 행을 선택하게 하는 메소드이다.
                // 그러므로 아래는 1번째 컴포넌트의 0번째 줄을 선택하게 된다.
                regionPicker.selectRow(0, inComponent: 1, animated: false)
            }

            // 선택한 값을 레이블이 보여주는 부분
            let regionIdx = regionPicker.selectedRow(inComponent: 0)
            let selectedRegion = citiesManager.region[regionIdx].name
            let cityIdx = regionPicker.selectedRow(inComponent: 1)
            let selectedCity = citiesManager.region[regionIdx].city[cityIdx]
        
        if selectedCity != ""{
            region = " \(selectedRegion)"
            city = "\(selectedCity)"
        }
        else{
            region = "\(selectedRegion)"
            city = "전체"
        }
         regionPicker.reloadComponent(1)
        }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
}

class RegionAlertViewController: UIViewController{
    
    @IBOutlet weak var regionPicker: UIPickerView!
    var region = String()
    var city = String()
    var citiesManager = City()
    var delegate: SendRegionInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        region = "전체"
        city = "전체"
        regionPicker.delegate = self
        regionPicker.dataSource = self
        swipeRecognizer()
    }
    
    @IBAction func clickOkBtn(_ sender: UIButton) {
        delegate?.sendRegionInfo(region: region, city: city)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {        self.dismiss(animated: true)
    }
}
