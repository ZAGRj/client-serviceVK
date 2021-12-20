//
//  Search Group API.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 20.12.2021.
//

import UIKit
import Foundation
import Alamofire

final class SearchGroupsAPI {
    
    private init() {}
    
    static func searchGroupsRequestAlamofire() {

        let baseUrl = "https://api.vk.com/method"
        let userId =  Account.shared.userID
        let accessToken = Account.shared.token
        let version = "5.131"
        let path = "/groups.search"
        let url = baseUrl + path
        
        let params: [String: String] = [
                     "user_id": userId,
                     "q": "IOS",
                     "order": "name",
                     "count": "10",
                     "sort": "0",
                     "fields": "description, photo_200_orig, domain",
                     "type": "qroup,page",
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
