//
//  FormTabelCell.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/21.
//

import Foundation
import UIKit

class FormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
  
    @IBOutlet weak var fifthContent: UILabel!
    @IBOutlet weak var fourthContent: UILabel!
    @IBOutlet weak var thirdContent: UILabel!
    @IBOutlet weak var secondContent: UILabel!
    @IBOutlet weak var firstContent: UILabel!
    @IBOutlet weak var fifthTitle: UILabel!
    @IBOutlet weak var fourthTitle: UILabel!
    @IBOutlet weak var thirdTitle: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var firstTitle: UILabel!
    
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
