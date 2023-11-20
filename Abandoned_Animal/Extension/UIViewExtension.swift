//
//  ViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor {
        get {
            let color = self.layer.borderColor ?? UIColor.clear.cgColor
            return UIColor(cgColor: color)
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat {
        //그림자의 퍼짐정도
        get{
            return self.layer.shadowRadius
        }
        
        
        set{
            self.layer.shadowRadius = newValue
        }
        
    }
    
    @IBInspectable var shadowOpacity : Float {
        //그림자의 투명도 0 - 1 사이의 값을 가짐
        get{
            return self.layer.shadowOpacity
        }
        
        set{
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    @IBInspectable var shadowColor : UIColor {
        //그림자의 색
        get{
            if let shadowColor = self.layer.shadowColor {
                return UIColor(cgColor: shadowColor)
            }
            return UIColor.clear
        }
        set{
            //그림자의 색이 지정됬을 경우
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            //shadowOffset은 빛의 위치를 지정해준다. 북쪽에 있으면 남쪽으로 그림지가 생기는 것
            self.layer.shadowColor = newValue.cgColor
            //그림자의 색을 지정
        }
        
    }
    
    @IBInspectable var maskToBound : Bool{
        
        get{
            return self.layer.masksToBounds
        }
        
        set{
            self.layer.masksToBounds = newValue
        }
    }
}
