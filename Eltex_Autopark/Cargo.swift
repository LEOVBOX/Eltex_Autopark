//
//  Cargo.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import Foundation

struct Cargo {
    var description: String
    var weight: Int
    var type: CargoType
    
    init? (description: String, weight: Int, type: CargoType) {
        if (weight < 0) {
            return nil
        }
        
        self.description = description
        self.weight = weight
        self.type = type
    }
}
