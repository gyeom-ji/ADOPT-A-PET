//
//  RecommendMaterialsModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct RecommendMaterials: Codable{
    var id: Int
    var name: String
    var type: String
    var url: String
    var feature: String
    var img: String
    var animalKind: String
    var animalBreed: String
    var animalAge: String
}
