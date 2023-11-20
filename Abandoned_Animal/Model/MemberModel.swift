//
//  MemberModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/14.
//

import Foundation
import Alamofire
import SwiftyJSON

class MemberModel {
    static let shared = MemberModel()
    
    private init() {}
    
    var member = Member()
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func loginMember(id:String, pw: String, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/member/memberLogin"
        
        let body : Parameters = [
            "memberId" : id,
            "memberPw" : pw
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData(completionHandler: { response in
            switch response.result {
            case .success:
                if let data = response.value {
                    print(data)
                    guard let decodedData = try? JSONDecoder().decode(Member.self, from: data) else {
                        completion(false)
                        return
                    }
                    self.member = decodedData
                        UserDefaults.standard.set(2, forKey: "userType")
                    UserDefaults.standard.set(decodedData.name, forKey: "name")
                    UserDefaults.standard.set(decodedData.id, forKey: "pk")
                        UserDefaults.standard.set(-1, forKey: "shelterPk")
    
                    completion(true)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        })
    }
    
    func insertMember(id:String, pw: String, name:String, phone: String, email:String, completion: @escaping(Bool?) -> ()){
        let url = APIConstrants.baseURL + "/member/createMember"
        
        let body : Parameters = [
            "memberId" : id,
            "memberPw" : pw,
            "name": name,
            "phone": phone,
            "email": email,
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData(completionHandler: { response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json1 = JSON(data)
                    completion(json1.boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
                
            }
        })
    }
    
    func checkExistMember(id: String, completion: @escaping(Bool?) -> ()){

        let urlString = APIConstrants.baseURL + "/member/isExistRoll/\(id)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData(completionHandler: { response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json1 = JSON(data)
                    completion(json1.boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
                
            }
        })
    }
    
    func readMember(id:Int, completion: @escaping() -> ())
    {
        let url = APIConstrants.baseURL + "/member/findOne/\(id)"
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(Member.self, from: data) else {
                        print("Error: readMember JSON parsing failed")
                        return
                    }
                    self.member = decodedData
                    completion()
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func updateMember(id:Int,memberId:String, pw:String, name:String, phone: String, email:String, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/member/updateRoll/\(id)"
        
        let body : Parameters = [
            "memberId" : memberId,
            "memberPw" : pw,
            "name": name,
            "phone": phone,
            "email": email
        ]
        
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)

        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json = JSON(data)
                    if json.boolValue {
                        self.member = Member(id: id, memberId: memberId, memberPw: pw, name: name, phone: phone, email: email)
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

    func deleteMember(id:Int)
    {
        let url =  APIConstrants.baseURL+"/member/deleteRoll/\(id)"
    
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
    
    func findIdMember(name:String, phone:String, completion: @escaping(String?) -> ())
    {
        let url = APIConstrants.baseURL + "/member/findId"
        
        let body : Parameters = [
            "name": name,
            "phone": phone,
        ]
        
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
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
    
    func findPwMember(memberId:String, name:String, phone:String, completion: @escaping(Int?) -> ())
    {
        let url = APIConstrants.baseURL + "/member/isFindPw"
        
        let body : Parameters = [
            "memberId": memberId,
            "name": name,
            "phone": phone,
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
    
    func updatePwMember(id:Int, pw:String,completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/member/updatePw/\(id)"
        
        let body : Parameters = [
            "memberPw": pw
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
    
    func isPwMember(id:Int, pw:String,completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/member/isPw/\(id)"
        
        let body : Parameters = [
            "memberPw": pw
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
}
