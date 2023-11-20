//
//  MissingSerchViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/21.
//

import Foundation
import UIKit

protocol SendKindInfoDelegate {
    func sendKindInfo(isDog:Bool, isCat:Bool, isEct:Bool)
}

class MissingSearchViewController: UIViewController{
    
    @IBOutlet weak var ectBtn: UIButton!
    @IBOutlet weak var catBtn: UIButton!
    @IBOutlet weak var dogBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var delegate: SendKindInfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        clickDogBtn(dogBtn)
        swipeRecognizer()
    }
    
    @IBAction func clickOkBtn(_ sender: UIButton) {
        delegate?.sendKindInfo(isDog: dogBtn.isSelected, isCat: catBtn.isSelected, isEct: ectBtn.isSelected)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {        self.dismiss(animated: true)
    }
    
    @IBAction func clickDogBtn(_ sender: UIButton) {
        dogBtn.isSelected.toggle()
        if dogBtn.isSelected == true{
            dogBtn.backgroundColor = .beige
        }
        else{
            dogBtn.backgroundColor = .white
        }
    }
    
    @IBAction func clickCatBtn(_ sender: UIButton) {
        catBtn.isSelected.toggle()

        if catBtn.isSelected == true{
            catBtn.backgroundColor = .beige
        }
        else{
            catBtn.backgroundColor = .white
        }
    }
    
    @IBAction func clickEctBtn(_ sender: UIButton) {
        ectBtn.isSelected.toggle()

        if ectBtn.isSelected == true{
            ectBtn.backgroundColor = .beige
        }
        else{
            ectBtn.backgroundColor = .white
        }
    }
}
