//
//  AnimalModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct Animal: Codable {
    var id: Int
    var kind: String
    var sex: String
    var age: String
    var color: String
    var feature: String
    var breed: String
    var neuter: String
    var isUrl: Bool
    var img: String
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case kind
        case sex
        case age
        case color
        case feature
        case breed
        case neuter
        case isUrl = "url"
        case img
    }
    
    init(id: Int, kind: String, sex: String, age: String, color: String, feature: String, breed: String, neuter: String, isUrl: Bool, img: String) {
        self.id = id
        self.kind = kind
        self.sex = sex
        self.age = age
        self.color = color
        self.feature = feature
        self.breed = breed
        self.neuter = neuter
        self.isUrl = isUrl
        self.img = img
    }
    
    init() {
        self.id = -1
        self.kind = ""
        self.sex = ""
        self.age = ""
        self.color = ""
        self.feature = ""
        self.breed = ""
        self.neuter = ""
        self.isUrl = false
        self.img = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.kind = (try? container.decode(String.self, forKey: .kind)) ?? ""
        self.sex = (try? container.decode(String.self, forKey: .sex)) ?? ""
        self.age = (try? container.decode(String.self, forKey: .age)) ?? ""
        self.color = (try? container.decode(String.self, forKey: .color)) ?? ""
        self.feature = (try? container.decode(String.self, forKey: .feature)) ?? ""
        self.breed = (try? container.decode(String.self, forKey: .breed)) ?? ""
        self.neuter = (try? container.decode(String.self, forKey: .neuter)) ?? ""
        self.isUrl = try container.decode(Bool.self, forKey: .isUrl)
        self.img = (try? container.decode(String.self, forKey: .img)) ?? ""
    }
}
