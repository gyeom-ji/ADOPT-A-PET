//
//  ShelterStaffModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShelterStaffModel {
    static let shared = ShelterStaffModel()
    
    private init() {}

    var staff = ShelterStaff()
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func loginStaff(id:String, pw: String, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/staff/staffLogin"
        
        let body : Parameters = [
            "staffId" : id,
            "staffPw" : pw,
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData(completionHandler: { response in
            switch response.result {
            case .success:
                if let data = response.value {
                    guard let decodedData = try? JSONDecoder().decode(ShelterStaff.self, from: data) else {
                        print("Error: loginStaff JSON parsing failed")
                        return
                    }
                    self.staff = decodedData
                    UserDefaults.standard.set(1, forKey: "userType")
                    UserDefaults.standard.set(decodedData.name, forKey: "name")
                        UserDefaults.standard.set(decodedData.id, forKey: "pk")
                    UserDefaults.standard.set(decodedData.shelter.id, forKey: "shelterPk")
                    completion(true)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        })
    }
    
    func checkExistStaff(id: String, completion: @escaping(Bool?) -> ()){
        let url = APIConstrants.baseURL+"/staff/isExistStaff/\(id)"
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData(completionHandler: { response in
            switch response.result{
            case .success:
                if let data = response.data {
                    let json1 = JSON(data)
                    completion(json1.boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
                
            }
        })
    }
    
    func readStaff(id:Int, completion: @escaping() -> ())
    {
        let url = APIConstrants.baseURL + "/staff/findOne/\(id)"
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(ShelterStaff.self, from: data) else {
                        print("Error: readStaff JSON parsing failed")
                        return
                    }
                    self.staff = decodedData
                    completion()
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func updateStaff(id:Int, staffId:String, staffPw:String, name:String, phone: String, shelterId: Int,completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/staff/updateStaff/\(id)"
        
        let body : Parameters = [
            "staffId": staffId,
            "staffPw" : staffPw,
            "staffName": name,
            "staffPhone": phone,
            "shelter": ["id":shelterId]
        ]
        
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json = JSON(data)
                    if json.boolValue {
                        self.staff = ShelterStaff(id: id, staffId: staffId, staffPw: staffPw, phone: phone, name: name, shelter: self.staff.shelter)
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }

    func deleteStaff(id:Int)
    {
        let url =  APIConstrants.baseURL+"/staff/deleteStaff/\(id)"
        
        let dataRequest = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                print("delete member")
            case .failure:
                print("fail")
            }
        }
    }
    
    func findIdStaff(name:String, phone:String, completion: @escaping(String?) -> ())
    {
        let url = APIConstrants.baseURL + "/staff/findId"
        
        let body : Parameters = [
            "staffName": name,
            "staffPhone": phone,
        ]
        
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData {
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    let json = JSON(data)
                    if json["true"].boolValue {
                        completion(json["id"].stringValue)
                    } else {
                        completion("")
                    }
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func findPwStaff(staffId:String, name:String, phone:String, completion: @escaping(Int?) -> ())
    {
        let url = APIConstrants.baseURL + "/staff/isFindPw"
        
        let body : Parameters = [
            "staffId": staffId,
            "staffName": name,
            "staffPhone": phone,
        ]
        
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json = JSON(data)
                    if json["true"].boolValue {
                        completion(json["pk"].intValue)
                    } else {
                        completion(-1)
                    }
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func updatePwStaff(id:Int, pw:String,completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/staff/updatePw/\(id)"
        
        let body : Parameters = [
            "staffPw": pw
        ]
        
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json = JSON(data)
                    if json["true"].boolValue {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func isPwStaff(id:Int, pw:String,completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/staff/isPw/\(id)"

        let body : Parameters = [
            "staffPw": pw
        ]
        
        let dataRequest = AF.request(url, method: .get, parameters: body, encoding: JSONEncoding.default, headers: header)
        
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
