//
//  BooksDataSource.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import UIKit

protocol BooksDataSourceProtocol: UITableViewDataSource, UITableViewDelegate {
    func loadBooks(completion: @escaping (JDETAppError?) -> Void)
}

class BooksDataSource: NSObject, BooksDataSourceProtocol {
    
    struct Constants {
        static let cellIdentifier = "cell"
        static let cellHeight: CGFloat = 150
    }
    
    private var page: Int = 1
    private var isLoading: Bool = false
    private let dataController: DataController
    private var books: [JSONBook] = []
    
    init(with dataController: DataController) {
        self.dataController = dataController
    }
    
    func loadBooks(completion: @escaping (JDETAppError?) -> Void) {
        dataController.fetchBooks(page: page) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error): completion(error)
                case .success(let books):
                    self.books = books
                    completion(nil)
                }                    
            }
        }
    }
}

extension BooksDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? BookCellTableViewCell {
            let book = books[indexPath.row]
            reusableCell.configure(with: book)
            cell = reusableCell
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (books.count - 1) == indexPath.row && !isLoading {
            isLoading = true
            page += 1
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
            tableView.tableFooterView = spinner
            dataController.fetchBooks(page: page) { (result) in
                DispatchQueue.main.async { [weak self] in
                    spinner.stopAnimating()
                    tableView.tableFooterView = nil
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let books):
                        self?.books.append(contentsOf: books)
                        tableView.reloadData()
                        self?.isLoading = false
                    }
                }
            }
        }
    }
}

extension BooksDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
