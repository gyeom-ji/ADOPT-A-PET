//
//  VaccineModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/31.
//

import Foundation
import Alamofire
import SwiftyJSON

class VaccineModel{
    static let shared = VaccineModel()
    
    private init() {}
    
    var vaccine = Vaccine()
    var vaccineList : [Vaccine] = []
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func readVaccineList( completion: @escaping() -> ()){
        let url = APIConstrants.baseURL + "/vaccine/selectAll"
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode([Vaccine].self, from: data) else {
                        print("Error: readVaccineList JSON parsing failed")
                        return
                    }
                    self.vaccineList = decodedData
                    completion()
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func readVaccine(id: Int){
        let url = APIConstrants.baseURL + "/vaccine/selectOne/\(id)"
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(Vaccine.self, from: data) else {
                        print("Error: readVaccine JSON parsing failed")
                        return
                    }
                    self.vaccine = decodedData
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func insertVaccine(name:String, basicVaccine: String, addVaccine: String, boosterVaccine: String, animalType: String)
    {
        let url = APIConstrants.baseURL + "/vaccine/createVaccine"
        
        let body : Parameters = [
            "name" : name,
            "basic_vaccine" : basicVaccine,
            "add_vaccine": addVaccine,
            "booster_vaccine" : boosterVaccine,
            "animal_type" : animalType
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let _ = JSON(data)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func deleteVaccine(id:Int)
    {
        let url =  APIConstrants.baseURL+"/vaccine/deleteVaccine/\(id)"
        
        let dataRequest = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                print("delete Vaccine")
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
}
