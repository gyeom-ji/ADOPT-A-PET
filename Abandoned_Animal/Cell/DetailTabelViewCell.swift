//
//  DetailTabelViewCell.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/17.
import Foundation
import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.textColor = .systemBrown
        self.title.font = .systemFont(ofSize: 12, weight: .medium)
     }
}

