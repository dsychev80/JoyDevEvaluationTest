//
//  Global.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/20/21.
//

import CoreData

extension Constants {
    static let coreDataFileName = "JoyDevEvaluationTest"
}

func createJoyDevContainer(completion: @escaping (NSPersistentContainer) -> Void) {
    let container = NSPersistentContainer(name: Constants.coreDataFileName)
    container.loadPersistentStores { (_, error) in
        guard error == nil else { fatalError("Failed to load store: \(error!)") }
        DispatchQueue.main.async {
            completion(container)
        }
    }
}
