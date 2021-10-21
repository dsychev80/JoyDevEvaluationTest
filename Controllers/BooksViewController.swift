//
//  ViewController.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import UIKit

class BooksViewController: UIViewController {
    
    var dataController: DataController = DataController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var errorMessage: MessageView = MessageView()
    
    private var booksDataSource: BooksDataSourceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksDataSource = BooksDataSource(with: dataController)
        
        tableView.dataSource = booksDataSource
        tableView.delegate = booksDataSource
        tableView.backgroundView = errorMessage
        tableView.separatorStyle = .none
        
        activityIndicator.hidesWhenStopped = true
        updataTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updataTableView()
    }
    
    func updataTableView() {
        activityIndicator.startAnimating()
        booksDataSource?.loadBooks() { (error) in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                if error != nil, let error = error {
                    self?.errorMessage.configure(with: error.localizedDescription)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

