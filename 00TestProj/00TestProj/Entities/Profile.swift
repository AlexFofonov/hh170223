//
//  Profile.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.02.2023.
//

import Foundation

struct Profile: Codable {
    
    typealias ID = String
    
    let id: ID
    let name: String
    let firstName: String
    let birthday: Date
    
}

extension Profile: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "id: \(id), name: \(name), first name: \(firstName), birthday: \(Assembly().dateFormatter(format: .kebab_yyyyMMdd).string(from: birthday) )"
        }
    
}
