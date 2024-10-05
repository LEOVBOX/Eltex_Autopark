//
//  LoadError.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import Foundation
enum LoadError: Error {
    case overWieght(Cargo, Vehicle)
    case wrongType(Cargo, Vehicle)
    case splitError(Cargo, Vehicle)
}
