//
//  AdiminModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/02/02.
//

import Foundation

struct Admin: Codable{
    var id: Int
    var adminId: String
    var adminPw: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "pk"
        case adminId = "id"
        case adminPw = "pw"
    }
}
