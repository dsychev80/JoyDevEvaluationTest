//
//  Model.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import Foundation
import CoreData

struct BooksJSONResult: Codable {
    let booksCount: Int
    let books: [JSONBook]
    
    enum CodingKeys: String, CodingKey {
        case booksCount = "hydra:totalItems"
        case books = "hydra:member"
    }
}

struct JSONBook: Codable {
    let isbn: String
    let title: String
    let description: String
    let author: String
    let publicationDate: String
    let reviews: [JSONReview]
}

struct JSONReview: Codable {
    let body: String
}

final class Book: NSManagedObject, Nameable {
    @NSManaged fileprivate(set) var author: String
    @NSManaged fileprivate(set) var descriptionText: String
    @NSManaged fileprivate(set) var isbn: String
    @NSManaged fileprivate(set) var publicationDate: String
    @NSManaged fileprivate(set) var title: String
    @NSManaged fileprivate(set) var reviews: NSSet?

    
    public func configure(with jsonBook: JSONBook, context: NSManagedObjectContext) {
        self.author = jsonBook.author
        self.descriptionText = jsonBook.description
        self.isbn = jsonBook.isbn
        self.publicationDate = jsonBook.publicationDate
        self.title = jsonBook.title
        
        for jsonReview in jsonBook.reviews {
            let review = Review(context: context)
            review.body = jsonReview.body
            review.book = self
        }
    }
    
    public func jsonBook() -> JSONBook {
        var jsonReviews: [JSONReview] = []
        if let reviews = self.reviews, reviews.count > 0 {
            for (_, review) in reviews.enumerated() {
                if let review = review as? Review {
                    jsonReviews.append(review.jsonReview())
                }
            }
        }
        return JSONBook(isbn: self.isbn,
                                title: self.title,
                                description: self.descriptionText,
                                author: self.author,
                                publicationDate: self.publicationDate,
                                reviews: jsonReviews)
    }
}

extension Book {
    @nonobjc public func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest(entityName: Book.name)
    }
}

final class Review: NSManagedObject, Nameable {
    @NSManaged fileprivate(set) var body: String
    @NSManaged fileprivate(set) var book: Book
    
    func jsonReview() -> JSONReview {
        return JSONReview(body: self.body)
    }
}

extension Review {
    @nonobjc public func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest(entityName: Review.name)
    }
}
