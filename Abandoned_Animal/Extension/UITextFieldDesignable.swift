//
//  UITextFieldDesignable.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import UIKit
import SnapKit

@IBDesignable
class UITextViewDesignable: UITextView, UITextViewDelegate  {
    
    let border = CALayer()
    
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            border.borderColor = lineColor.cgColor
        }
    }
    
    @IBInspectable open var selectedLineColor : UIColor = UIColor.black {
        didSet{
        }
    }
    
    
    @IBInspectable open var lineHeight : CGFloat = CGFloat(1.0) {
        didSet{
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        self.delegate=self;
        border.borderColor = lineColor.cgColor
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = lineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        self.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        border.borderColor = lineColor.cgColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        border.borderColor = selectedLineColor.cgColor
    }
    
}

@IBDesignable
class UITextFieldDesignable: UITextField, UITextFieldDelegate  {
    @IBInspectable var leftimage : UIImage?{
        didSet{
            updateTextField()
        }
    }
    
    @IBInspectable var leftMargin : CGFloat = 0 {
        didSet{
            updateTextField()
        }
    }
    
    @IBInspectable var viewColor : UIColor? {
        didSet{
            updateTextField()
        }
    }
    
    @IBInspectable var imageTintColor : UIColor? {
        didSet{
            updateTextField()
        }
    }
    
    
    @IBInspectable var viewWidth : CGFloat = 0 {
        didSet{
            updateTextField()
        }
    }
    
    @IBInspectable var viewHeight : CGFloat = 0 {
        didSet{
            updateTextField()
        }
    }
    
    func updateTextField(){
        
        guard let image = leftimage else {
          
            leftViewMode = .never
            return
        }
        
        leftViewMode = .always
        
        let viewWidth = leftMargin + self.viewWidth

        let insideView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth , height: viewHeight))
        insideView.backgroundColor = viewColor
        
        let insideImageView = UIImageView(frame: CGRect(x: leftMargin, y: 0, width: self.viewWidth, height: viewHeight))
        insideImageView.image = image
        insideImageView.tintColor = imageTintColor
        insideView.addSubview(insideImageView)
        
        leftView = insideView
    
    }
    
    let border = CALayer()
    
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            border.borderColor = lineColor.cgColor
        }
    }
    
    @IBInspectable open var selectedLineColor : UIColor = UIColor.black {
        didSet{
        }
    }
    
    
    @IBInspectable open var lineHeight : CGFloat = CGFloat(1.0) {
        didSet{
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        self.delegate=self;
        border.borderColor = lineColor.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = lineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width:  self.frame.size.width, height: self.frame.size.height)
        self.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = selectedLineColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = lineColor.cgColor
    }
    
}

