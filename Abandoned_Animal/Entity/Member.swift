//
//  Member.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct Member: Codable{
    var id: Int
    var memberId: String
    var memberPw: String
    var name: String
    var phone: String
    var email: String
    
    init(id: Int, memberId: String, memberPw: String, name: String, phone: String, email: String) {
        self.id = id
        self.memberId = memberId
        self.memberPw = memberPw
        self.name = name
        self.phone = phone
        self.email = email
    }
    
    init() {
        self.id = -1
        self.memberId = ""
        self.memberPw = ""
        self.name = ""
        self.phone = ""
        self.email = ""
    }
}

