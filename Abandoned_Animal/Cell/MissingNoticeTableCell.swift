//
//  MissingNoticeTableCell.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/15.
//

import Foundation
import UIKit

class MissingNoticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var missingPlace: UILabel!
    @IBOutlet weak var missingDate: UILabel!
    @IBOutlet weak var animalSex: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
         self.imgView.image = nil
     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
