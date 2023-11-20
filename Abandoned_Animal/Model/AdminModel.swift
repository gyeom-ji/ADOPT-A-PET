//
//  AdminModel.swift
//  Abandoned_Animal
//
//  Created by 윤겸지 on 2023/02/02.
//

import Foundation
import Alamofire
import SwiftyJSON

class AdminModel{
    static let shared = AdminModel()
    
    private init() {}
    
    let header : HTTPHeaders = ["Content-Type" : "application/json" ]
    
    func loginAdmin(id:String, pw: String, completion: @escaping(Bool?) -> ())
    {
        let url = APIConstrants.baseURL + "/admin/adminLogin"
        
        let body : Parameters = [
            "id" : id,
            "pw" : pw
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                if let data = response.value {
                    let json = JSON(data)
                    if json["true"].boolValue {
                        UserDefaults.standard.set(0, forKey: "userType")
                        UserDefaults.standard.set(json["name"].stringValue, forKey: "name")
                        UserDefaults.standard.set(json["id"].intValue, forKey: "pk")
                        UserDefaults.standard.set(-1, forKey: "shelterPk")
                    }
                    completion(json["true"].boolValue)
                }
            case .failure:
                print("error : \(response.error!)")
            }
        }
    }
    
    func insertStaff(shelterId: Int, completion: @escaping(Bool?) -> ()){

        let urlString = APIConstrants.baseURL + "/admin/createStaff/\(shelterId)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        let dataRequest = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        
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
}
