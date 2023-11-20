//
//  FormModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/01/30.
//

import Foundation
import Alamofire
import SwiftyJSON

class FormModel{
    static let shared = FormModel()
    
    private init() {}

    var form = Form()
    var formList : [Form] = []
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func insertForm(type:String, approval: String, abandoned:AbandonedNotice, member: Member){
        let url = APIConstrants.baseURL + "/form/createForm"
        
        let body : Parameters = [
            "type" : type,
            "approval" : approval,
            "abandonedNotice": ["id":abandoned.id,
                          "noticeNum" : abandoned.noticeNum,
                          "receiptDate" : abandoned.receiptDate,
                          "place" : abandoned.place,
                          "period" : abandoned.period,
                          "animal" : [
                            "id": abandoned.animal.id,
                            "kind" : abandoned.animal.kind,
                            "sex" : abandoned.animal.sex,
                            "age" : abandoned.animal.age,
                            "color" : abandoned.animal.color,
                            "feature" : abandoned.animal.feature,
                            "breed" : abandoned.animal.breed,
                            "neuter" : abandoned.animal.neuter,
                            "isUrl" : abandoned.animal.isUrl,
                            "img" : abandoned.animal.img],
                          "shelterListId" : abandoned.shelter.id],
            "member" : ["id" : member.id,
                        "memberId" : member.memberId,
                        "memberPw" : member.memberPw,
                        "name": member.name,
                        "phone": member.phone,
                        "email": member.email]
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    let json1 = JSON(data)
                    print(json1)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func updateForm(id:Int, type:String, approval: String, abandoned:AbandonedNotice, member: Member)
    {
        let url = APIConstrants.baseURL + "/form/updateForm/\(id)"
        
        let body : Parameters = [
            "type" : type,
            "approval" : approval,
            "abandonedNotice": ["id":abandoned.id,
                          "noticeNum" : abandoned.noticeNum,
                          "receiptDate" : abandoned.receiptDate,
                          "place" : abandoned.place,
                          "period" : abandoned.period,
                          "animal" : [
                            "id": abandoned.animal.id,
                            "kind" : abandoned.animal.kind,
                            "sex" : abandoned.animal.sex,
                            "age" : abandoned.animal.age,
                            "color" : abandoned.animal.color,
                            "feature" : abandoned.animal.feature,
                            "breed" : abandoned.animal.breed,
                            "neuter" : abandoned.animal.neuter,
                            "isUrl" : abandoned.animal.isUrl,
                            "img" : abandoned.animal.img],
                          "shelterListId" : abandoned.shelter.id],
            "member" : ["id" : member.id,
                        "memberId" : member.memberId,
                        "memberPw" : member.memberPw,
                        "name": member.name,
                        "phone": member.phone,
                        "email": member.email]
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

    func deleteForm()
    {
        let url =  APIConstrants.baseURL+"/form/deleteForm/\(self.form.id)"
    
        let dataRequest = AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                print("delete Form")
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }

    
    func readFormList(str:String,completion: @escaping() -> ())
    {
        let url = APIConstrants.baseURL + str
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    print(JSON(data))
                    guard let decodedData = try? JSONDecoder().decode([Form].self, from: data) else {
                        print("Error: readFormList JSON parsing failed")
                        return
                    }
                    self.formList = decodedData
                    completion()
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func readFormOne(id:Int, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/form/selectOne/\(id)"
        
        let dataRequest = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    guard let decodedData = try? JSONDecoder().decode(Form.self, from: data) else {
                        print("Error: readFormOne JSON parsing failed")
                        return
                    }
                    self.form = decodedData
                    completion(true)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func formApproval(approval: String, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/form/approval/\(self.form.id)/\(approval)"
        
        let dataRequest = AF.request(url, method: .put, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result{
            case .success:
                if let data = response.value {
                    guard let decodedData = try? JSONDecoder().decode(Bool.self, from: data) else {
                        print("Error: formApproval JSON parsing failed")
                        return
                    }
                    if decodedData {
                        self.form.approval = approval
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
}
