//
//  NewTaskModelView.swift
//  ToDoList
//
//  Created by Philips on 25/06/25.
//

import UIKit
import os

class NewTaskModelView: UIView {

    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var categoryPickerView: UIPickerView!
    
    @IBOutlet private var contentView: UIView!
    weak var delegate: NewTaskDelegate?
    private var task: TaskModel?
    
    var caption: String {
        get { descriptionTextView.text }
        set { descriptionTextView.text = newValue }
    }
    
    init(frame: CGRect, task: TaskModel?){
        super.init(frame: frame)
        self.task = task
        initSubViews()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubViews()
//    }
//    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    func initSubViews() {
        let nib = UINib(nibName: "NewTaskModelView", bundle: nil)
        nib.instantiate(withOwner: self)
        
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.delegate = self
        
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        
        
        if let task = task {
            descriptionTextView.text = task.caption
            descriptionTextView.textColor = UIColor.label
            let taskCategory = Category(rawValue: task.category)!
            if let rowIndex = Category.allCases.firstIndex(of: taskCategory){
                categoryPickerView.selectRow(rowIndex, inComponent: 0, animated: false)
            }
        }
        else {
            descriptionTextView.text = "Adios amigo"
            descriptionTextView.textColor = UIColor.placeholderText
            categoryPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    /*
     This is the appropriate place to change the corner radius  because it will account for layout changes and changes in the size of views
     */
    
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 5
    }
    /*
    the awakeFromNib is not called because the nib's top level object is connected to the file owner
     */
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        
//    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        os_log("Task submit Button Tapped", type: .info)
        
        guard let caption = descriptionTextView.text,
              descriptionTextView.textColor != UIColor.placeholderText,
              caption.count >= 4 && caption.count <= 50
        else {
            
            delegate?.presentErrorAlert(title: "Caption Error", message: "You need to provide a description between 4 and 50 characters.")
            shakeAnimation()
            return
        }
        os_log("Validation of task succeeded", type: .info)
        
        let selectedRow = categoryPickerView.selectedRow(inComponent: 0)
        let category = Category.allCases[selectedRow]
        if let task = task {

            //let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            task.category = category.rawValue
            task.caption = caption
            task.isComplete = task.isComplete
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            let userInfo: [String: Any] = ["updateTask": task]
            os_log("Task posted as part of notification - edit task", type: .info)
            NotificationCenter.default.post(name: NSNotification.Name("com.philipsUIKitTraining.editTask"), object: nil, userInfo: userInfo)
        }
        else {
            
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let newTask = TaskModel(context: managedContext)
            newTask.category = category.rawValue
            newTask.caption = caption
            newTask.createdDate = Date()
            newTask.isComplete = false
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            let userInfo: [String: Any] = ["newTask": newTask ]
            os_log("Task posted as part of notification - new task", type: .info)
            NotificationCenter.default.post(name: NSNotification.Name("com.philipsUIKitTraining.createTask"), object: nil, userInfo: userInfo)
        }
        
        delegate?.closeView()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.closeView()
    }
}

extension NewTaskModelView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.label
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Adios Amigo"
            textView.textColor = UIColor.placeholderText
        }
    }
}


extension NewTaskModelView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
}

extension NewTaskModelView: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return Category.allCases[row].rawValue
//        
//        
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = Category.allCases[row].rawValue
        return pickerLabel!
    }
}
