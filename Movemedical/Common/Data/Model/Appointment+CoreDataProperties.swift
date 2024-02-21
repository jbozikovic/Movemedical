//
//  Appointment+CoreDataProperties.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//
//

import Foundation
import CoreData

extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var info: String
    @NSManaged public var date: Date
    @NSManaged public var location: String
}

extension Appointment : Identifiable {}
