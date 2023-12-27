//
//  Car+CoreDataProperties.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 26.12.23.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var model: String?

}

extension Car : Identifiable {

}
