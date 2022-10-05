//
//  PharmacyData.swift
//  Mask
//
//  Created by 何安竺 on 2022/10/5.
//

import Foundation

struct PharmacyData: Codable{
    var features : [feature]
    
    struct feature : Codable{
        var properties : Detail
        
        struct Detail : Codable{
            var id : String
            var county : String
            var name : String
            var address : String
            var mask_adult : Int
            var mask_child : Int
            var town : String
        }
    }
    
}
