//
//  ShadowButton.swift
//  ToDoList
//
//  Created by Philips on 30/06/25.
//

import UIKit


@IBDesignable
class ShadowButton: UIButton {

    
    var cornerRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    
    var background: UIColor = .link {
        didSet {
            self.backgroundColor = background
        }
    }
    var shadowColor: UIColor = UIColor(named: "secondaryLink")! {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        self.titleLabel?.font = UIFont.style(.body)
        self.backgroundColor = background
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 0
        self.layer.shadowColor = shadowColor.cgColor
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        
    }

}
