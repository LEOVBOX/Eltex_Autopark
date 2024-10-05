//
//  Fleet.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import Foundation

class Fleet {
    var vehicles: [Vehicle]
    
    init(vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }
    
    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
    }
    
    func totalCapacity() -> Int {
        var totalFleetCapacity: Int = 0
        for vehicle in vehicles {
            totalFleetCapacity += vehicle.totalCapacity
        }
        return totalFleetCapacity
    }
    
    func totalCurrentLoad() -> Int {
        var result: Int = 0
        for vehicle in vehicles {
            if let currentLoad = vehicle.currentLoad {
                result += currentLoad
            }
        }
        return result
    }
    
    func info() {
        print("Vehicles count: \(vehicles.count)")
        print("Total capacity: \(self.totalCapacity())")
        print("Total current load: \(self.totalCurrentLoad())");
        print("Vehicles:")
        for vehicle in vehicles {
            vehicle.info()
        }
    }
    
    // Сгруппировать грузы по типу
        private func groupCargoByType(cargo: [Cargo]) -> [CargoType: [Cargo]] {
            var groupedCargo = [CargoType: [Cargo]]()
            
            for item in cargo {
                if groupedCargo[item.type] != nil {
                    groupedCargo[item.type]?.append(item)
                } else {
                    groupedCargo[item.type] = [item]
                }
            }
            return groupedCargo
        }

        // Подсчет общей вместимости для транспорта, который может перевозить конкретный тип груза
        private func totalCapacityForCargoType(cargoType: CargoType, distance: Int) -> Int {
            var totalCapacity = 0
            for vehicle in vehicles {
                // Проверяем, может ли транспортное средство преодолеть путь
                if vehicle.canCompleteTrip(distance: distance) {
                    // Если у транспорта есть ограничения по типу груза
                    if let allowedTypes = vehicle.types {
                        if allowedTypes.contains(cargoType) {
                            totalCapacity += vehicle.freeSpace
                        }
                    }
                    // Если у транспорта нет ограничений по типу груза
                    else {
                        totalCapacity += vehicle.freeSpace
                    }
                }
            }
            return totalCapacity
        }

        // Метод для проверки, можно ли перевезти грузы на указанное расстояние
        func canGo(cargo: [Cargo], path: Int) -> Bool {
            let groupedCargo = groupCargoByType(cargo: cargo)
            
            // Проверяем вместимость для каждого типа груза
            for (cargoType, cargoItems) in groupedCargo {
                let totalCargoWeight = cargoItems.reduce(0) { $0 + $1.weight }
                let availableCapacity = totalCapacityForCargoType(cargoType: cargoType, distance: path)
                
                if availableCapacity < totalCargoWeight {
                    return false // Если нет достаточной вместимости для какого-то типа груза
                }
            }
            
            // Если для всех типов груза найдена достаточная вместимость
            return true
        }
}
