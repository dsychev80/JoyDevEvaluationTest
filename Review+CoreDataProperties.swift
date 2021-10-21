//
//  Review+CoreDataProperties.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/20/21.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var body: String?
    @NSManaged public var book: Book?

}

extension Review : Identifiable {

}
