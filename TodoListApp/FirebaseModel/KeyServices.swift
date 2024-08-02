//
//  KeyServices.swift
//  TodoListApp
//
//  Created by Arsalan Daud on 30/07/2024.
//

import Foundation
import Security

struct keychainService{
    enum keychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    static func saveCredentials(service: String ,email: String, password: Data) throws {
//        guard let passwordData = password.data(using: .utf8) else {
//            print("Error Converting Password to Data")
//            return
//        }
        print("Saving Data....")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: email as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        let status = SecItemAdd(query as CFDictionary, nil )
        
        guard status != errSecDuplicateItem else {
            throw keychainError.duplicateEntry
        }
        print("Data is \(query)")
        guard status == errSecSuccess else {
            print("Error Saving Credentials")
            print("Status is \(status)")
            throw keychainError.unknown(status)
        }
        print("Credential Saved")
        print("Status is \(status)")
    }
}
