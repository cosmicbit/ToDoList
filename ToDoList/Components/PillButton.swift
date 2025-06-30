//
//  PillButton.swift
//  ToDoList
//
//  Created by Philips on 30/06/25.
//

import UIKit

class PillButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.style(.body)
        self.backgroundColor = UIColor.link
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }

}
