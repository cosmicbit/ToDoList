//
//  RoundedButton.swift
//  ToDoList
//
//  Created by Philips on 27/06/25.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.style(.body)
        self.backgroundColor = UIColor.link
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }

}
