//
//  CheckViewController.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/21.
//

import Foundation
import UIKit

class CheckViewController: UIViewController{
    
    @IBOutlet weak var checkLabel2: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    var text = """
- 반려동물을 맞이할 환경적 준비, 마음의 각오는 되어 있습니까?
- 개, 고양이는 10~15년 이상 삽니다.
결혼, 임신, 유학, 이사 등으로 가정환경이 바뀌어도 한번 인연을 맺은 동물은 끝까지 책임지고 보살피겠다는 결심이 섰습니까?
- 모든 가족과의 합의는 되어 있습니까?
- 반려동물을 기른 경험이 있습니까?
- 내 동물을 위해 공부할 각오가 되어 있습니까?
- 아플 때 적절한 치료를 해주고, 중성화수술(불임수술)을 실천할 생각입니까?
- 입양으로 인한 경제적 부담을 짊어질 의사와 능력이 있습니까?
- 우리 집에서 키우는 다른 동물과 잘 어울릴 수 있을지 고민해보았습니까?
"""
    var text2 = """
- 시·군·구청에서 보호하고 있는 유기동물 중 공고한 지 10일이 지나도 주인이 나타나지 않는 경우 일반인에게 분양할 수 있습니다.
- 입양 보호시설에 신청서를 작성한 후 승인 시, 담당자의 안내에 따라 방문 일시 등을 예약합니다.
- 입양 시 신분증 복사본 2장과 필요한 반려동물 물품을 준비하고 보호시설을 방문해 입양계약서를 작성해야 합니다.
- 입양 보호시설에는 신청자 본인이 직접 방문해야 합니다.
- 미성년자에게는 반려동물을 분양하지 않습니다. 분양을 원하는 미성년자는 부모님의 허락을 얻어 반드시 부모님과 함께 방문해야 합니다.
"""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        //행간 조절
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        let attrString2 = NSMutableAttributedString(string: text2)
        attrString2.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString2.length))
        
        checkLabel.attributedText = attrString
        checkLabel2.attributedText = attrString2
        
    }
    
    @IBAction func clickOkBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
