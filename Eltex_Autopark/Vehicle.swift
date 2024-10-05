//
//  Vehicle.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import Foundation

class Vehicle {
    var make: String
    var model: String
    var year: Int
    var capacity: Int
    var types: Set<CargoType>?
    var fuelTankCapacity: Float? // Объем топливного бака
    var fuelConsumptionPerKm: Float // Расход топлива на 1 км (литры на км)

    var freeSpace: Int {
        if let vehicleLoad = vehicleLoad {
            return capacity - vehicleLoad
        }
        return capacity
    }

    var totalCapacity: Int {
        return capacity
    }

    var vehicleLoad: Int?

    var currentLoad: Int? {
        return vehicleLoad
    }

    init(make: String, model: String, year: Int, capacity: Int, types: Set<CargoType>? = nil, vehicleLoad: Int? = nil, fuelTankCapacity: Float? = nil, fuelConsumptionPerKm: Float) {
        self.make = make
        self.model = model
        self.year = year
        self.capacity = capacity
        self.types = types
        self.vehicleLoad = vehicleLoad
        self.fuelTankCapacity = fuelTankCapacity
        self.fuelConsumptionPerKm = fuelConsumptionPerKm
    }

    func canCompleteTrip(distance: Int) -> Bool {
        guard let fuelTankCapacity = fuelTankCapacity else {
            return false
        }
        
        // Можно использовать только половину бака
        let maxDistance = (fuelTankCapacity / 2) / fuelConsumptionPerKm
        
        // Проверяем, можем ли мы проехать туда и обратно
        return Float(distance) <= maxDistance
    }
    
    func safeLoadCargo(cargo: Cargo?) {
            guard let cargo = cargo else {
                print("Load error: trying to load nil cargo")
                return
            }
            
            do {
                try loadCargo(cargo: cargo)
            }
            catch {
                switch error {
                case LoadError.overWieght(let cargo, let vehicle):
                    print("Load error: overweight")
                    print("\tCargo: \"\(cargo.description)\" weight = \(cargo.weight)")
                    print("\tVehicle: \(vehicle.make) \(vehicle.model) \(vehicle.year)")
                    print("\t\ttotal capacity = \(vehicle.totalCapacity)")
                    guard let curLoad = vehicle.currentLoad else {
                        return
                    }
                    print("\t\tcurrent load = \(curLoad)")
                case LoadError.wrongType(let cargo, let vehicle):
                    print("Load error: wrong type \n\tCargo: \"\(cargo.description)\" type = \(cargo.type) \n\tVehicle: \(vehicle.make) \(vehicle.model) \(vehicle.year)")
                default:
                    print("Error \(error)")
                }
            }
        }

    func loadCargo(cargo: Cargo) throws {
        // Проверка на вес
        if (freeSpace < cargo.weight) {
            throw LoadError.overWieght(cargo, self)
        }

        // Проверка на тип
        if let types = types {
            if (!types.contains(cargo.type)) {
                throw LoadError.wrongType(cargo, self)
            }
        }

        if vehicleLoad != nil {
            self.vehicleLoad! += cargo.weight
        } else {
            self.vehicleLoad = cargo.weight
        }
    }

    func unloadCargo() {
        vehicleLoad = 0
    }
    
    func info() {
        print("\(self):")
        print("\tmake: \(make)")
        print("\tmodel: \(model)")
        print("\tyear: \(year)")
        print("\tcapacity: \(capacity)")
        print("\ttypes:", terminator: " ")
        if let types = types {
            for type in types {
                print("\(type);", terminator: " ")
            }
            print()
        } else {
            print("all")
        }
    }
    
    func typeCapacity(type: CargoType?) -> Int?{
        if let type = type {
            if let types = types {
                if types.contains(type) {
                    return capacity
                }
                else {
                    return nil
                }
            }
            return nil
        }
        return capacity
    }
}
