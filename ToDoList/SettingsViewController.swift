//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Philips on 27/06/25.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var appThemeLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    
    @IBOutlet weak var appThemeSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTitleLabel.font = UIFont.style(.h1)
        appThemeLabel.font = UIFont.style(.caption)
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? []}.first { $0.isKeyWindow }
        if window?.overrideUserInterfaceStyle == .light {
            appThemeSegmentedControl.selectedSegmentIndex = 0
        }
        else if window?.overrideUserInterfaceStyle == .dark {
            appThemeSegmentedControl.selectedSegmentIndex = 1
        }
        else {
            appThemeSegmentedControl.selectedSegmentIndex = 2
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        modalView.layer.cornerRadius = 5
    }
    

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
     @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
         let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? []}.first { $0.isKeyWindow }
         
         if sender.selectedSegmentIndex == 0 {
             window?.overrideUserInterfaceStyle = .light
         }
         else if sender.selectedSegmentIndex == 1 {
             window?.overrideUserInterfaceStyle = .dark
         }
         else {
             window?.overrideUserInterfaceStyle = .unspecified
         }
     }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
