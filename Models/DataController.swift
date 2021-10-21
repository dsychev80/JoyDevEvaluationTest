//
//  DataController.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import UIKit
import CoreData

final class DataController {
    
    private let networkController: NetworkController = NetworkController()
    private let backgroundContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    private let managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var isLoadedBefore = false
    
    init() {}
    
    // MARK: - Methods
    public func fetchBooks(page: Int, completion: @escaping (Result<[JSONBook], JDETAppError>) -> Void) {
        var booksResource = BooksResource()
        booksResource.page(page)
        
        networkController.loadBooks(for: booksResource.url) { [unowned self] (result) in
                switch result {
                case .failure(let error):
                    // Fetching from CoreData only once 
                    if !isLoadedBefore {
                        // Try to load from CoreData, if can't send failure
                        do {
                            isLoadedBefore.toggle()
                            let books = try fetchPersistantBooks()
                            completion(.success(books))
                        } catch {
                            completion(.failure(.coreDataError(error.localizedDescription)))
                        }
                    }
                    completion(.failure(error))
                case .success(let books):
                    // Data syncing through CoreData's merge policy (Entity Book has constraint for isbn attribute)
                    do {
                        try saveBooks(books, to: self.managedObjectContext)
                    } catch {
                        completion(.failure(.coreDataError(error.localizedDescription)))
                    }
                    completion(.success(books))
            }
        }
    }
        
    private func saveBooks(_ books: [JSONBook], to context: NSManagedObjectContext) throws {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        for jsonBook in books {
            let book = Book(context: context)
            book.configure(with: jsonBook, context: context)
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw JDETAppError.coreDataError(error.localizedDescription)
            }
            DispatchQueue.main.async {
                context.reset()
            }
        }
    }
    
    private func fetchPersistantBooks() throws -> [JSONBook] {
        
        guard let fetchedBooks = try? managedObjectContext.fetch(Book.fetchRequest()) as? [Book] else {
            throw JDETAppError.coreDataError("Can't fetch books. \(#file) func: \(#function) line: \(#line)")
        }
        var jsonBooks: [JSONBook] = []
        
        for book in fetchedBooks {
            jsonBooks.append(book.jsonBook())
        }
        return jsonBooks
    }
}


