//
//  ShelterTableCell.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/15.
//

import Foundation
import UIKit

class ShelterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imgView: UIImageView!

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
