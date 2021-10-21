//
//  BookCellTableViewCell.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import UIKit

class BookCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 25
        cellView.layer.borderColor = UIColor.darkGray.cgColor
        cellView.layer.borderWidth = 0.5
    }
    
    func configure(with book: JSONBook) {
        titleLabel.text = book.description
        authorLabel.text = book.author
    }
}
