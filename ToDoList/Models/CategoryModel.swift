//
//  CategoryModel.swift
//  ToDoList
//
//  Created by Philips on 25/06/25.
//

import Foundation
import UIKit
import RealmSwift

enum Category: String, CaseIterable, PersistableEnum {
    case work = "Work",
         study = "Study",
         exercise = "Exercise"
    
    var color: UIColor {
        switch self {
        case .work:
            return UIColor.workTheme
        case .study:
            return UIColor.studyTheme
        case .exercise:
            return UIColor.exerciseTheme
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .work:
            return UIColor.secondaryWorkTheme
        case .study:
            return UIColor.secondaryStudyTheme
        case .exercise:
            return UIColor.secondaryExerciseTheme
        }
    }
    
}
