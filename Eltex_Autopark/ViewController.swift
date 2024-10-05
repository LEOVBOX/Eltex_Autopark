//
//  ViewController.swift
//  Eltex_Autopark
//
//  Created by Леонид Шайхутдинов on 01.10.2024.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let truckMan = Truck(make: "Man", model: "TGS", year: 1987, capacity: 1000,
                             trailerCapacity: 1000, trailerTypes: [.bulk],
                             fuelTankCapacity: 1000, fuelConsumptionPerKm: 0.4)
        let truckKamaz = Truck(make: "Kamaz", model: "5350", year: 2022, capacity: 200, types: [.fragile],
                               trailerCapacity: 2000, trailerTypes: [.bulk, .perishable()],
                               fuelTankCapacity: 950, fuelConsumptionPerKm: 0.3)
        let truckFord = Truck(make: "Ford", model: "F50", year: 2020, capacity: 500, types: [.fragile],
                               fuelTankCapacity: 182, fuelConsumptionPerKm: 0.3)
        let vehicleLada = Vehicle(make: "Lada", model: "Granta", year: 2022, capacity: 300, types: [.fragile], 
                                  fuelTankCapacity: 50, fuelConsumptionPerKm: 0.53)
        
        let trucks = [truckMan, truckKamaz, truckFord]
        
        let wheat = Cargo(description: "Wheat", weight: 500, type: CargoType.bulk)
        let bread = Cargo(description: "Bread", weight: 1000, type: .perishable())
        let glass = Cargo(description: "Glass", weight: 200, type: .fragile)
        
        
        let fleet = Fleet(vehicles: trucks)
        fleet.addVehicle(vehicleLada)
    
        truckMan.safeLoadCargo(cargo: wheat)
        truckKamaz.safeLoadCargo(cargo: wheat)
        truckKamaz.safeLoadCargo(cargo: bread)
        truckFord.safeLoadCargo(cargo: bread)
        truckFord.safeLoadCargo(cargo: wheat)
        vehicleLada.safeLoadCargo(cargo: bread)
        vehicleLada.safeLoadCargo(cargo: glass)
        
        fleet.info()
        let cargos = [wheat!, bread!]
        let path = 100
        
        print("Can go:\(fleet.canGo(cargo: cargos, path: path))")
        
        print(truckMan.typeCapacity(type: .bulk)!)
        
    }


}
