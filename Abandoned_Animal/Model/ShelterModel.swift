//
//  ShelterModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/30.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShelterModel {
    
    static let shared = ShelterModel()
    
    private init() {}
    
    var shelter = Shelter()
    var shelterList : [Shelter] = []
    var filterShelterList : [Shelter] = []
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func getFilterShelterList(text: String) {
        filterShelterList = shelterList.filter({(shelter: Shelter) -> Bool in
            return shelter.name.contains(text)
        })
    }
    
    func readShelterList(str: String, page:Int, completion: @escaping() -> ()) {

        let urlString = APIConstrants.baseURL + str + "/\(page)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!

        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
                switch response.result{
                case .success:
                    if let data = response.data {
                        guard let decodedData = try? JSONDecoder().decode([Shelter].self, from: data) else {
                            print("Error: readShelterList JSON parsing failed")
                            return
                        }
                        if page == 0 {
                            self.shelterList = decodedData
                        } else {
                            self.shelterList.append(contentsOf: decodedData)
                        }
                        completion()
                    }
                case .failure:
                    print("error : \(response.error!)")
                }
            }
    }
    
    func readShelterOne(id:Int)
    {
        let url = APIConstrants.baseURL + "/shelter/selectOne/\(id)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(Shelter.self, from: data) else {
                        print("Error: readShelterOne JSON parsing failed")
                        return
                    }
                    self.shelter = decodedData
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func insertShelter(name:String, phone: String, county: String, city: String, address: String, type: String, openTime: String, closeTime: String)
    {
        let url = APIConstrants.baseURL + "/shelter/createShelter"
        
        let body : Parameters = [
            "shelter_name" : name,
            "shelter_phone" : phone,
            "shelter_county": county,
            "shelter_city" : city,
            "shelter_address" : address,
            "shelter_type" : type,
            "shelter_open_time" : openTime,
            "shelter_close_time" : closeTime,
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
    
    func deleteShelter(id:Int)
    {
        let url =  APIConstrants.baseURL+"/shelter/deleteShelter/\(id)"
    
        let dataRequest = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                print("delete Shlter")
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
}
