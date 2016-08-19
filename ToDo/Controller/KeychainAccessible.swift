//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Yemi Ajibola on 8/13/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(password: String, account: String)
    func deletePasswordForAccount(account: String)
    func passwordForAccount(account: String) -> String?
}