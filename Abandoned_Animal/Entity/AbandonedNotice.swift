//
//  AbandonedNotice.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct AbandonedNotice: Codable{
    var id: Int
    var noticeNum: String
    var receiptDate: String
    var place: String
    var period: String
    var animal: Animal
    var shelter: Shelter
    
    init(id: Int, noticeNum: String, receiptDate: String, place: String, period: String, animal: Animal, shelter: Shelter) {
        self.id = id
        self.noticeNum = noticeNum
        self.receiptDate = receiptDate
        self.place = place
        self.period = period
        self.animal = animal
        self.shelter = shelter
    }
    
    init() {
        self.id = -1
        self.noticeNum = ""
        self.receiptDate = ""
        self.place = ""
        self.period = ""
        self.animal = Animal()
        self.shelter = Shelter()
    }
}

extension AbandonedNotice {

    func titleAtIndex(_ index: Int) -> String {
        let str = ["1. 동물 정보", "축종 :", "품종 :", "성별 :", "색상 :", "중성화 여부 :", "특징 :", "2. 구조 정보", "공고번호 :", "발생장소 :", "접수일시 :" ,"공고기간 :", "3. 동물보호센터 안내", "관할보호센터명 :", "전화번호 :", "보호장소 :", "4. 기타", ""]
        return str[index]
    }
    
    func contentAtIndex(_ index: Int) -> String {
        let str = ["*", animal.kind, animal.breed, animal.sex, animal.color, animal.neuter, animal.feature, "*", noticeNum,place,receiptDate,period, "*", shelter.name, shelter.phone, shelter.county+" " + shelter.city + " " + shelter.address, "*", "위 동물을 잃어버린 소유자는 보호 센터로 문의하시어 동물을 찾아가시기 바랍니다. 다만, 「동물보호법」 제19조 및 같은 법 시행규칙 제21조에 따라 소유자에게 보호 비용이 청구될 수 있습니다. 또한 「동물보호법」 제17조에 따른 공고가 있는 날부터 10일이 경과하여도 소유자 등을 알 수 없는 경우에는 「유실물법」 제12조 및 「민법」 제253조의 규정에도 불구하고 해당 시·도지사 또는 시장·군수·구청장이 그 동물의 소유권을 취득하게 됩니다."]

        return str[index]
    }
}
