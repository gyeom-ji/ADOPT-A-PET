//
//  AbandonedNoticeModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import Foundation
import Alamofire
import SwiftyJSON

class AbandonedNoticeModel {
    
    static let shared = AbandonedNoticeModel()
    
    private init() {}
    
    var abandonedNotice = AbandonedNotice()
    var abandonedNoticeList : [AbandonedNotice] = []
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func readAbandonedNotices(str: String, page: Int, completion: @escaping() -> ()) {
        
        let urlString = APIConstrants.baseURL + str + "/\(page)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)

        dataRequest.responseData{
            response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        guard let decodedData = try? JSONDecoder().decode([AbandonedNotice].self, from: data) else {
                            print("Error: readAbandonedNotices JSON parsing failed")
                            return
                        }
                        if page == 0 {
                            self.abandonedNoticeList = decodedData
                        } else {
                            self.abandonedNoticeList.append(contentsOf: decodedData)
                        }
                        completion()
                    }
                case .failure:
                    print("error : \(response.error!)")
                }
            }
    }
    
    func readAbandonedOne(id:Int, completion: @escaping() -> ())
    {
        let url = APIConstrants.baseURL + "/abandoned_notice/selectOne/\(id)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(AbandonedNotice.self, from: data) else {
                        print("Error: readAbandonedOne JSON parsing failed")
                        return
                    }
                    self.abandonedNotice = decodedData
                    completion()
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func checkNoticeNum(noticeNum: String, completion: @escaping(Bool?) -> ()){
        
        let urlString = APIConstrants.baseURL + "/abandoned_notice/isNotice_num/"+noticeNum
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json1 = JSON(data)
                    completion(json1.boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func insertAbandoned(noticeNum: String, receiptDate: String, place: String, period: String, animal: Animal, shelterListId: Int, completion: @escaping(Bool?) -> ())
    {
        
        let url = APIConstrants.baseURL+"/abandoned_notice/createNotice"
        
        let body : Parameters = [
            "noticeNum" : noticeNum,
            "receiptDate" : receiptDate,
            "place" : place,
            "period" : period,
            "animal" : ["kind" : animal.kind, "sex" : animal.sex, "age" : animal.age, "color" : animal.color, "feature" : animal.feature, "breed" : animal.breed, "neuter" : animal.neuter, "isUrl" : animal.isUrl, "img" : animal.img],
            "shelterListId" : shelterListId
        ]
        
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json1 = JSON(data)
                    
                    completion(json1.boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func deleteAbandoned()
    {
        let url =  APIConstrants.baseURL+"/abandoned_notice/deleteNotice/\(self.abandonedNotice.animal.id)"

        let dataRequest = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                print("delete Abandoned")
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func updateAbandoned(abandonedId:Int, noticeNum: String, receiptDate: String, place: String, period: String, animal: Animal, shelterListId: Int, completion: @escaping(Bool?) -> ())
    {
        let url =  APIConstrants.baseURL+"/abandoned_notice/updateNotice"
        
        let body : Parameters = [
            "id":abandonedId,
            "noticeNum" : noticeNum,
            "receiptDate" : receiptDate,
            "place" : place,
            "period" : period,
            "animal" : ["id": animal.id, "kind" : animal.kind, "sex" : animal.sex, "age" : animal.age, "color" : animal.color, "feature" : animal.feature, "breed" : animal.breed, "neuter" : animal.neuter, "isUrl" : animal.isUrl, "img" : animal.img],
            "shelterListId" : shelterListId
        ]
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json1 = JSON(data)
                    completion(json1.boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
}
