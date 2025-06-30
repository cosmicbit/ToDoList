//
//  Colors.swift
//  ToDoList
//
//  Created by Philips on 27/06/25.
//

import Foundation
import UIKit

extension UIColor {
    
    static var workTheme: UIColor {
        return UIColor(named: "work")!
    }
    
    static var secondaryWorkTheme: UIColor {
        return UIColor(named: "work")!.withAlphaComponent(0.2)
    }
    
    static var exerciseTheme: UIColor {
        return UIColor(named: "exercise")!
    }
    
    static var secondaryExerciseTheme: UIColor {
        return UIColor(named: "exercise")!.withAlphaComponent(0.2)
    }
    
    static var studyTheme: UIColor {
        return UIColor(named: "study")!
    }
    
    static var secondaryStudyTheme: UIColor {
        return UIColor(named: "study")!.withAlphaComponent(0.2)
    }
    
    static var secondaryLinkTheme: UIColor {
        return UIColor(named: "secondaryLink")! 
    }
}
