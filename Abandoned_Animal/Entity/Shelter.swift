//
//  ShelterListModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct Shelter: Codable{
    var id: Int
    var name: String
    var phone: String
    var county: String
    var city: String
    var address: String
    var type: String
    var openTime: String
    var closeTime: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "shelter_name"
        case phone = "shelter_phone"
        case county = "shelter_county"
        case city = "shelter_city"
        case address = "shelter_address"
        case type = "shelter_type"
        case openTime = "shelter_open_time"
        case closeTime = "shelter_close_time"
    }
    
    init(id: Int, name: String, phone: String, county: String, city: String, address: String, type: String, openTime: String, closeTime: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.county = county
        self.city = city
        self.address = address
        self.type = type
        self.openTime = openTime
        self.closeTime = closeTime
    }
    
    init(){
        self.id = -1
        self.name = ""
        self.phone = ""
        self.county = ""
        self.city = ""
        self.address = ""
        self.type = ""
        self.openTime = ""
        self.closeTime = ""
    }
    
    func titleAtIndex(_ index: Int) -> String {
        let str = ["","보호센터 명 :", "전화번호 :", "주소 :", "운영 시작 시각 :", "운영 종료 시각 :", "동물보호센터 유형 :"]
        return str[index]
    }
    
    func contentAtIndex(_ index: Int) -> String {
        let str = ["",name, phone, county + " " + city + " " + address,  openTime, closeTime, type]

        return str[index]
    }
}
