//
//  VaccineModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/13.
//

import Foundation

struct Vaccine: Codable{
    var id: Int
    var name: String
    var basicVaccine: String
    var addVaccine: String
    var boosterVaccine: String
    var animalType: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case basicVaccine = "basic_vaccine"
        case addVaccine = "add_vaccine"
        case boosterVaccine = "booster_vaccine"
        case animalType = "animal_type"
    }
    
    init(id: Int, name: String, basicVaccine: String, addVaccine: String, boosterVaccine: String, animalType: String) {
        self.id = id
        self.name = name
        self.basicVaccine = basicVaccine
        self.addVaccine = addVaccine
        self.boosterVaccine = boosterVaccine
        self.animalType = animalType
    }
    
    init() {
        self.id = -1
        self.name = ""
        self.basicVaccine = ""
        self.addVaccine = ""
        self.boosterVaccine = ""
        self.animalType = ""
    }
}
