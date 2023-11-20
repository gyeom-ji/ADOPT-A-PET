//
//  UIImageViewExtension.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 11/10/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIColor{
    
    class var darkGreen: UIColor? {return UIColor(named: "darkGreen")}
    class var orange: UIColor? {return UIColor(named: "orange")}
    class var beige: UIColor? {return UIColor(named: "beige")}
}
