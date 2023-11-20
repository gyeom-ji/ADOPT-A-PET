//
//  AbandonedNoticeTableViewCell.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import UIKit

class AbandonedNoticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var animalBreed: UILabel!
    @IBOutlet weak var animalSex: UILabel!
    @IBOutlet weak var noticeNum: UILabel!
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

