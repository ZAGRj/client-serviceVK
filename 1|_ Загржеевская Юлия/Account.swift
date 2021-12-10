//
//  Account.swift
//  1|_ Загржеевская Юлия
//
//  Created by Julie Zagr on 09.12.2021.
//

import Foundation

final class Account {
    
    private init() {}
    
    static let user = Account()
    
    var token: String = ""
    var userID: Int = 0
}
