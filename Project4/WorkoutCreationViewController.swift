

import UIKit

protocol WorkoutCreationViewControllerDelegate: class {
    func save(workout: classEntry)
}

class WorkoutCreationViewController: UIViewController {
    


    weak var delegate: WorkoutCreationViewControllerDelegate?
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var gradeNumberValue: UILabel!
    @IBOutlet private weak var gradeLetterValue: UILabel!
    @IBOutlet private weak var gradeStepper: UIStepper!
    @IBOutlet private weak var creditHourStepper: UIStepper!
    @IBOutlet private weak var creditHourValueLabel: UILabel!
    
    @IBOutlet weak var customGradeEntryStackView: UIStackView!
    @IBOutlet private weak var gradeStepperEntryStackView: UIStackView!
    @IBOutlet fileprivate weak var tappableBackgroundView: UIView!
    @IBOutlet weak var customGradeEntryTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Configure minutes stepper and label
        gradeStepper.minimumValue = 0
        gradeStepper.maximumValue = Double(GradeValue.allCases.count - 1)
        gradeStepper.value = Double(GradeValue.allCases.count - 1)

        gradeNumberValue.text = "\(GradeValue.allCases[Int(gradeStepper.value)].rawValue)"

        // Calories per minute
        creditHourStepper.minimumValue = 1
        creditHourStepper.maximumValue = 90
        creditHourStepper.value = 3
        creditHourValueLabel.text = "\(Int(creditHourStepper.value))"

        
        // Configure tappable background when keyboard or picker is displayed
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tappableBackgroundView.addGestureRecognizer(tapGestureRecognizer)
        tappableBackgroundView.isHidden = true

        // Configure delegates
        customGradeEntryTextField.delegate = self
        nameField.delegate = self
        
    }
    @IBAction func customSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            customGradeEntryStackView.isHidden = false
            gradeStepperEntryStackView.isHidden = true
        } else {
            customGradeEntryStackView.isHidden = true
            gradeStepperEntryStackView.isHidden = false
        }
        
    }
    
    @IBAction func gradeValueChanged(_ sender: UIStepper) {
        gradeNumberValue.text =  "\(GradeValue.allCases[Int(gradeStepper.value)].rawValue)"
        gradeLetterValue.text = "\(GradeValue.allCases[Int(gradeStepper.value)].gradeLetter)"
    }

    
    @IBAction private func creditHourValueChanged(_ sender: UIStepper) {
        creditHourValueLabel.text = "\(Int(sender.value))"

    }

    @IBAction func addClassButtonPressed(_ sender: Any) {
        var name = nameField.text ?? ""
        if name == "" { name = "No Name" }
        let grade: Double
        let gradeLetter: String
        let creditHours = Int(creditHourStepper.value)

        if customGradeEntryStackView.isHidden == false {
            
            if let customGradeEntered = Double(customGradeEntryTextField.text!) {
                print(customGradeEntered)
                if Double(customGradeEntered) < 0.0 || Double(customGradeEntered) > 4.0 {
                    sendAlert(message: "Please enter a number between 0.0 and 4.0")
                }
                grade = Double(customGradeEntryTextField.text!)!
                gradeLetter = "custom"
                let currentClassEntry = classEntry(id: UUID(), name: name,  grade: grade, gradeLetter: gradeLetter, creditHours: creditHours)
                delegate?.save(workout: currentClassEntry)

            }
            else {
                if (customGradeEntryTextField.text!.components(separatedBy: ".").count) > 1 {
                    sendAlert(message: "Please make sure you have only one decimal point")
                } else {
                sendAlert(message: "Please enter a grade")
                }
            }

        } else {
            grade = GradeValue.allCases[Int(gradeStepper.value)].rawValue
            gradeLetter = "\(GradeValue.allCases[Int(gradeStepper.value)].gradeLetter)"
            let currentClassEntry = classEntry(id: UUID(), name: name,  grade: grade, gradeLetter: gradeLetter, creditHours: creditHours)
            delegate?.save(workout: currentClassEntry)

        }
//        let gradeLetter = "\(GradeValue.allCases[Int(gradeStepper.value)].gradeLetter)"
        

        
        let _ = navigationController?.popViewController(animated: true)
    }
    

    
    @objc private func backgroundTapped() {
        self.view.endEditing(true)  // this actually loops through all this view's subviews and resigns the first responder on all of them
        tappableBackgroundView.isHidden = true
    }


}

extension WorkoutCreationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tappableBackgroundView.isHidden = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        tappableBackgroundView.isHidden = true
        return true
    }
    
    func sendAlert (message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(ok)
        
        if let presented = self.presentedViewController {
            presented.removeFromParentViewController()
        }
        
        if presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}




