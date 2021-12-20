//
//  Groups API.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 20.12.2021.
//

import UIKit
import Foundation
import Alamofire

final class MyGroupsAPI {
    
    private init() {}
    
    static func myGroupsRequestAlamofire() {

        let baseUrl = "https://api.vk.com/method"
        let userId =  Account.shared.userID
        let accessToken = Account.shared.token
        let version = "5.131"
        let path = "/groups.get"
        let url = baseUrl + path
        
        let params: [String: String] = [
                     "user_id": userId,
                     "order": "name",
                     "count": "50",
                     "fields": "description, photo_200_orig, domain",
                     "extended": "1",
                     "access_token": accessToken,
                     "v": version
                 ]

        AF.request(url, method: .get, parameters: params).responseJSON {
            response in
//            print(response.result)
            print(response.value as Any)
            print(response.request as Any)
        }
    }
}
