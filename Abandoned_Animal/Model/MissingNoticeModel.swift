//
//  MissingNoticeModel.swift
//  Missing_Animal
//
//  Created by 윤겸지 on 2023/01/29.
//

import Foundation
import Alamofire
import SwiftyJSON

class MissingNoticeModel {
    
    static let shared = MissingNoticeModel()
    
    private init() {}
    
    var missingNotice = MissingNotice()
    var missingNoticeList : [MissingNotice] = []
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func readMissingNotices(str: String, page: Int, completion: @escaping() -> ()) {
        
        let urlString = APIConstrants.baseURL + str + "/\(page)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!

        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
                switch response.result{
                case .success:
                    if let data = response.data {
                        guard let decodedData = try? JSONDecoder().decode([MissingNotice].self, from: data) else {
                            print("Error: readMissingNotices JSON parsing failed")
                            return
                        }
                        if page == 0 {
                            self.missingNoticeList = decodedData
                        } else {
                            self.missingNoticeList.append(contentsOf: decodedData)
                        }
                        completion()
                    }
                case .failure:
                    print("error : \(response.error!)")
                }
            }
    }
    
    func readMissingOne(id:Int, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/missing_notice/selectOne/\(id)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(MissingNotice.self, from: data) else {
                        print("Error: readMissingOne JSON parsing failed")
                        return
                    }
                    self.missingNotice = decodedData
                    completion(true)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func readMissingRandom()
    {
        let url = APIConstrants.baseURL + "/missing_notice/selectRandomOne"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(MissingNotice.self, from: data) else {
                        print("Error: readMissingRandom JSON parsing failed")
                        return
                    }
                    self.missingNotice = decodedData
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func insertMissing(memberId:Int, personName: String, animalName: String, email: String, phone: String, date: String, place: String, animal: Animal)
    {
        
        let url = APIConstrants.baseURL+"/missing_notice/createNotice"

        let body : Parameters = [
            "memberId" : memberId,
            "personName" : personName,
            "animalName" : animalName,
            "email" : email,
            "phone" : phone,
            "date" : date,
            "place" : place,
            "animal" : ["kind" : animal.kind, "sex" : animal.sex, "age" : animal.age, "color" : animal.color, "feature" : animal.feature, "breed" : animal.breed, "neuter" : animal.neuter, "isUrl" : animal.isUrl, "img" : animal.img]
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
    
    func deleteMissing(animalId:Int)
    {
        let url =  APIConstrants.baseURL+"/missing_notice/deleteNotice/\(animalId)"

        let dataRequest = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                print("delete Missing")
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func updateMissing(memberId:Int, missingId:Int,personName: String, animalName: String, email: String, phone: String, date: String, place: String, animal: Animal)
    {
        let url =  APIConstrants.baseURL+"/missing_notice/updateNotice"
        
        let body : Parameters = [
            "id" : missingId,
            "memberId" : memberId,
            "personName" : personName,
            "animalName" : animalName,
            "email" : email,
            "phone" : phone,
            "date" : date,
            "place" : place,
            "animal" : ["id":animal.id, "kind" : animal.kind, "sex" : animal.sex, "age" : animal.age, "color" : animal.color, "feature" : animal.feature, "breed" : animal.breed, "neuter" : animal.neuter, "isUrl" : animal.isUrl, "img" : animal.img]
        ]
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
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
}
