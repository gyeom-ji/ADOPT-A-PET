//
//  FormModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct Form: Codable{
    var id: Int
    var type: String
    var approval: String
    var abandoned: AbandonedNotice
    var member: Member
    
    init(id: Int, type: String, approval: String, abandoned: AbandonedNotice, member: Member) {
        self.id = id
        self.type = type
        self.approval = approval
        self.abandoned = abandoned
        self.member = member
    }
    
    init() {
        self.id = -1
        self.type = ""
        self.approval = ""
        self.abandoned = AbandonedNotice()
        self.member = Member()
    }
}

extension Form {
    func titleAtIndex(_ index: Int) -> String {
        let str = ["1. 신청자 정보","이름 : ", "전화번호 : ", "이메일 : " ,"2. 동물 정보", "축종 :", "품종 :", "성별 :", "색상 :", "중성화 여부 :", "특징 :", "3. 구조 정보", "공고번호 :", "발생장소 :", "접수일시 :" ,"공고기간 :", "4. 동물보호센터 안내", "관할보호센터명 :", "전화번호 :", "보호장소 :", "4. 기타", ""]
        return str[index]
    }
    
    func contentAtIndex(_ index: Int) -> String {
        let str = ["*",member.name, member.phone, member.email, "*", abandoned.animal.kind, abandoned.animal.breed, abandoned.animal.sex, abandoned.animal.color, abandoned.animal.neuter, abandoned.animal.feature, "*", abandoned.noticeNum,abandoned.place,abandoned.receiptDate,abandoned.period, "*", abandoned.shelter.name, abandoned.shelter.phone, abandoned.shelter.address, "*", "위 동물을 잃어버린 소유자는 보호 센터로 문의하시어 동물을 찾아가시기 바랍니다. 다만, 「동물보호법」 제19조 및 같은 법 시행규칙 제21조에 따라 소유자에게 보호 비용이 청구될 수 있습니다. 또한 「동물보호법」 제17조에 따른 공고가 있는 날부터 10일이 경과하여도 소유자 등을 알 수 없는 경우에는 「유실물법」 제12조 및 「민법」 제253조의 규정에도 불구하고 해당 시·도지사 또는 시장·군수·구청장이 그 동물의 소유권을 취득하게 됩니다."]
        
        return str[index]
    }
}
