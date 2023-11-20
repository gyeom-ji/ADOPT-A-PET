//
//  ShelterStaffModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct ShelterStaff: Codable{
    var id: Int
    var staffId: String
    var staffPw: String
    var phone: String
    var name: String
    var shelter: Shelter
    
    private enum CodingKeys: String, CodingKey {
        case id
        case staffId
        case staffPw
        case phone = "staffPhone"
        case name = "staffName"
        case shelter
    }
    
    init(id: Int, staffId: String, staffPw: String, phone: String, name: String, shelter: Shelter) {
        self.id = id
        self.staffId = staffId
        self.staffPw = staffPw
        self.phone = phone
        self.name = name
        self.shelter = shelter
    }
    
    init() {
        self.id = -1
        self.staffId = ""
        self.staffPw = ""
        self.phone = ""
        self.name = ""
        self.shelter = Shelter()
    }
}
