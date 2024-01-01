//
//  Car+CoreDataProperties.swift
//  CarsTestTask
//
//  Created by Vitaliy Halai on 28.12.23.
//
//

import UIKit
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var model: String?
    @NSManaged public var producer: String?
    @NSManaged public var year: Int16
    @NSManaged public var picture: UIImage?
    @NSManaged public var color: UIColor?

}

extension Car : Identifiable {

}
