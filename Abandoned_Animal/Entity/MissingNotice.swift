//
//  MissingNoticeModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct MissingNotice: Codable{
    var id: Int
    var memberId: Int
    var personName: String
    var animalName: String
    var email: String
    var phone: String
    var date: String
    var place: String
    var animal: Animal
    
    init(id: Int, memberId: Int, personName: String, animalName: String, email: String, phone: String, date: String, place: String, animal: Animal) {
        self.id = id
        self.memberId = memberId
        self.personName = personName
        self.animalName = animalName
        self.email = email
        self.phone = phone
        self.date = date
        self.place = place
        self.animal = animal
    }
    
    init() {
        self.id = -1
        self.memberId = -1
        self.personName = ""
        self.animalName = ""
        self.email = ""
        self.phone = ""
        self.date = ""
        self.place = ""
        self.animal = Animal()
    }
}

extension MissingNotice {
    func titleAtIndex(_ index: Int) -> String {
        let str = ["1. 동물정보", "이름 :", "품종 :", "성별 :","나이 :", "색상 :", "특징 :", "분실날짜 :" , "분실장소 : ", "2. 작성자 정보", "작성자 :", "이메일 :", "연락처 :"]
        return str[index]
    }
    
    func contentAtIndex(_ index: Int) -> String {
        let str = ["*", animalName, animal.breed, animal.sex, animal.age, animal.color, animal.feature,  date, place, "*", personName, email, phone]

        return str[index]
    }
}
