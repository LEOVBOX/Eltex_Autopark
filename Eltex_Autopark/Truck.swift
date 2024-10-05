//
//  Truck.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import Foundation

class Truck: Vehicle {
    var trailerAttached: Bool {
        if trailerCapacity != nil {
            return true
        }
        else {
            return false
        }
    }
    
    var trailerCapacity: Int?
    var trailerTypes: Set<CargoType>?
    var trailerLoad: Int?
    
    override var freeSpace: Int {
        if let trailerCapacity {
            if let trailerLoad {
                return ((trailerCapacity - trailerLoad) + super.freeSpace)
            }
            return trailerCapacity + super.freeSpace
        }
        return super.freeSpace
    }
    
    var trailerFreeSpace: Int? {
        if let trailerCapacity {
            if let trailerLoad {
                return trailerCapacity - trailerLoad
            }
            return trailerCapacity
        }
        return nil
    }
    
    override var currentLoad: Int? {
        if trailerAttached {
            if let trailerLoad = trailerLoad{
                if let vehicleLoad = vehicleLoad {
                    return vehicleLoad + trailerLoad
                }
                else {
                    return trailerLoad
                }
            }
        }
        return vehicleLoad
    }
    
    override func typeCapacity(type: CargoType?) -> Int? {
        var result: Int?
        let veheicleTypeCapacity = super.typeCapacity(type: type)
        
        var trailerTypeCapacity: Int?
        if let type = type {
            if let trailerCapacity = trailerCapacity {
                if let trailerTypes = trailerTypes, trailerTypes.contains(type) {
                    trailerTypeCapacity = trailerCapacity
                }
                // Прицеп может перевозить любой тип
                else {
                    trailerTypeCapacity = trailerCapacity
                }
            }
        }
        else {
            trailerTypeCapacity = trailerCapacity
        }
        
        
        if let veheicleTypeCapacity = veheicleTypeCapacity {
            result = veheicleTypeCapacity
        }
        
        if let trailerTypeCapacity = trailerTypeCapacity {
            if result != nil{
                result! += trailerTypeCapacity
            }
            else {
                result = trailerTypeCapacity
            }
        }
        
        return result
    }
    
    override var totalCapacity: Int{
        if let trailerCapacity = trailerCapacity {
            return trailerCapacity + capacity
        }
        return capacity
    }
    
    init(make: String, model: String, year: Int, capacity: Int, types: Set<CargoType>? = nil,
         trailerCapacity: Int? = nil, trailerTypes: Set<CargoType>? = nil,
         fuel: Float? = nil, fuelTankCapacity: Float? = nil, fuelConsumptionPerKm: Float) {
        self.trailerCapacity = trailerCapacity
        self.trailerTypes = trailerTypes
        
        super.init(make: make, model: model, year: year, capacity: capacity, types: types, fuelTankCapacity: fuelTankCapacity, fuelConsumptionPerKm: fuelConsumptionPerKm)
    }
    
    func loadCargoTrailer(cargo: Cargo) throws {
        guard let trailerFreeSpace = trailerFreeSpace else {
            throw LoadError.overWieght(cargo, self)
        }
        
        // Груз не помещается в прицеп
        if (trailerFreeSpace < cargo.weight) {
            do {
                try splitLoad(cargo: cargo)
            }
            catch {
                throw LoadError.overWieght(cargo, self)
            }
        }
        
        // Груз помещается в прицеп полностью
        else {
            if trailerLoad != nil {
                trailerLoad! += cargo.weight
            }
            else {
                trailerLoad = cargo.weight
            }
        }
    }
    
    func splitLoad(cargo: Cargo) throws {
        guard let trailerFreeSpace = trailerFreeSpace else {
            throw LoadError.splitError(cargo, self)
        }
        
        let vehicleCargoWheight = cargo.weight - trailerFreeSpace
        // Не можем разделить между прицепом и кабиной
        if (super.freeSpace < vehicleCargoWheight) {
            throw LoadError.overWieght(cargo, self)
        }
        // Делим груз между прицепом и кабиной
        else {
            let vehicleCargo = Cargo(description: cargo.description, weight: vehicleCargoWheight, type: cargo.type)
            if let vehicleCargo = vehicleCargo {
                try super.loadCargo(cargo: vehicleCargo)
            }
            let trailerCargo = Cargo(description: cargo.description, weight: trailerFreeSpace, type: cargo.type)
            if let trailerCargo = trailerCargo {
                try loadCargoTrailer(cargo: trailerCargo)
            }
        }
    }
    
    override func loadCargo(cargo: Cargo) throws {
        // Груз больше чем свободное место
        if (freeSpace < cargo.weight) {
            throw LoadError.overWieght(cargo, self)
        }
        
        // Если есть свободное место в прицепе
        if trailerFreeSpace != nil {
            // Есть ограничения по типам груза в прицепе
            if let trailerTypes = trailerTypes {
                // Если груз не соотвествует типу прицепа
                if !trailerTypes.contains(cargo.type) {
                    try super.loadCargo(cargo: cargo)
                }
                // Груз соответствует типу прицепа
                else {
                    try loadCargoTrailer(cargo: cargo)
                }
            }
            // Нет ограничений по типу груза в прицепе
            else {
                try loadCargoTrailer(cargo: cargo)
            }
        }
        // Нет места в прицепе
        else {
            try super.loadCargo(cargo: cargo)
        }
    }
    
    override func info() {
        super.info()
        if let trailerCapacity = trailerCapacity {
            print("\ttrailer capacity: \(trailerCapacity)")
            
            if let trailerTypes = trailerTypes {
                print("\ttrailer types:", terminator: " ")
                for type in trailerTypes {
                    print("\(type);", terminator: " ")
                }
                print()
            }
        }
        else {
            print("\tno trailer")
        }
    }
        
}
