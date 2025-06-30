//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Philips on 24/06/25.
//

import UIKit
protocol NewTaskDelegate: AnyObject {
    func closeView()
    func presentErrorAlert(title: String, message: String)
}
class NewTaskViewController: UIViewController {
    
    lazy var modelView: NewTaskModelView = {
        let modalWidth = view.frame.width - CGFloat(30)
        let modalHeight: CGFloat = 430
        let frame = CGRect(x: 15, y: view.center.y - (modalHeight / 2), width: modalWidth, height: modalHeight)
        let modelView = NewTaskModelView(frame: frame, task: task)
        modelView.delegate = self
        return modelView
    }()
    
    private var task: Task?
    
    init(task: Task? = nil){
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(modelView)
        
    }
    
    
}

//MARK: - Conformance to New Task Delegate
extension NewTaskViewController: NewTaskDelegate {
    func closeView() {
        dismiss(animated: true)
    }
    
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
