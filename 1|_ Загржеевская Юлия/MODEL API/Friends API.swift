//
//  Reqwest to VK.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 20.12.2021.
//

import UIKit
import Foundation
import Alamofire

final class FriendsAPI {
    
    private init() {}
    
    static func friendsRequestAlamofire() {

        let baseUrl = "https://api.vk.com/method"
        let userId =  Account.shared.userID
        let accessToken = Account.shared.token
        let version = "5.131"
        let path = "/friends.get"
        let url = baseUrl + path
        
        let params: [String: String] = [
                     "user_id": userId,
                     "order": "name",
                     "count": "50",
                     "fields": "surname, photo_200_orig, city, domain",
                     "access_token": accessToken,
                     "v": version
                 ]

        AF.request(url, method: .get, parameters: params).responseJSON { response in
//            print(response.result)
            print(response.value as Any)
            print(response.request as Any)
            
        }
    }
}
