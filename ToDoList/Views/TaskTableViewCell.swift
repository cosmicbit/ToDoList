//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Philips on 24/06/25.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func editTask(id: String)
    func markTask(id: String, complete: Bool)
}

class TaskTableViewCell: UITableViewCell {

    static let identifier = "TaskTableViewCell"
    
    @IBOutlet weak var stripView: UIView!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var isCompleteImageView: UIImageView!
    private weak var delegate: TaskTableViewCellDelegate?
    private var task: Task!
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryContainerView.layer.cornerRadius = categoryContainerView.frame.height / 2
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    func configure(withTask task: Task, delegate: TaskTableViewCellDelegate){
        stripView.backgroundColor = task.category.color
        categoryContainerView.backgroundColor = task.category.secondaryColor
        categoryLabel.textColor = task.category.color
        categoryLabel.text = task.category.rawValue
        captionLabel.text = task.caption
        isCompleteImageView.image = task.isComplete ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        dateLabel.text = dateFormatter.string(from: task.createdDate)
        selectionStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCompletion))
        isCompleteImageView.addGestureRecognizer(tap)
        isCompleteImageView.isUserInteractionEnabled = true
        self.task = task
        self.delegate = delegate
    }
    
    @objc func toggleCompletion() {
        task.isComplete.toggle()
        delegate?.markTask(id: task.id, complete: task.isComplete)
    }
    @IBAction func editTaskButtonTapped(_ sender: Any) {
        delegate?.editTask(id: task.id)
    }
    

}
