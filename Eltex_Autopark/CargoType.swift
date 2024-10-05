//
//  CargoType.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import Foundation

enum CargoType: Hashable {
    case fragile
    case perishable (minTemp: Float? = nil, maxTemp: Float? = nil)
    case bulk
}
