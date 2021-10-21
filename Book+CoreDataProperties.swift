//
//  Book+CoreDataProperties.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/20/21.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var isbn: String?
    @NSManaged public var publicationDate: String?
    @NSManaged public var title: String?
    @NSManaged public var reviews: NSSet?

}

// MARK: Generated accessors for reviews
extension Book {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}

extension Book : Identifiable {

}
