

import UIKit

protocol WorkoutCreationViewControllerDelegate: class {
    func save(workout: classEntry)
}

class WorkoutCreationViewController: UIViewController {
    
    
//    
//    enum gradeValues {
//        case a, aMinus, bPlus, b, bMinus, cPlus, c, cMinus, dPlus, d, dMinus, f
//        var gradeValue: Double {
//            switch self {
//            case .a : return 4.0
//            case .aMinus : return 3.7
//            case .bPlus : return 3.3
//            case .b : return 3.0
//            case .bMinus : return 2.7
//            case .cPlus : return 2.3
//            case .c : return 2.0
//            case .cMinus : return 1.7
//            case .dPlus : return 1.3
//            case .d : return 1.0
//            case .dMinus : return 0.7
//            case .f: return 0
//            }
//        }
//        var gradeLetter: String {
//            switch self {
//            case .a : return "A"
//            case .aMinus : return "A-"
//            case .bPlus : return "B+"
//            case .b : return "B"
//            case .bMinus : return "B-"
//            case .cPlus : return "C+"
//            case .c : return "C"
//            case .cMinus : return "C-"
//            case .dPlus : return "D+"
//            case .d : return "D"
//            case .dMinus : return "D-"
//            case .f: return "F"
//            }
//        }
//        
//    }
//  


    weak var delegate: WorkoutCreationViewControllerDelegate?
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var gradeNumberValue: UILabel!
    @IBOutlet private weak var gradeLetterValue: UILabel!
    @IBOutlet private weak var gradeStepper: UIStepper!
    @IBOutlet private weak var creditHourStepper: UIStepper!
    @IBOutlet private weak var creditHourValueLabel: UILabel!
    
    @IBOutlet fileprivate weak var tappableBackgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Configure minutes stepper and label
        gradeStepper.minimumValue = 0
        gradeStepper.maximumValue = Double(gradeValueArray.count - 1)
        gradeStepper.value = Double(gradeValueArray.count - 1)

        gradeNumberValue.text = "\(gradeValueArray[Int(gradeStepper.value)].gradeValue)"

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
        nameField.delegate = self
        
    }
    
    @IBAction func gradeValueChanged(_ sender: UIStepper) {
        gradeNumberValue.text =  "\(gradeValueArray[Int(gradeStepper.value)].gradeValue)"
        gradeLetterValue.text = "\(gradeValueArray[Int(gradeStepper.value)].gradeLetter)"
    }

    
    @IBAction private func creditHourValueChanged(_ sender: UIStepper) {
        creditHourValueLabel.text = "\(Int(sender.value))"

    }

    @IBAction func addClassButtonPressed(_ sender: Any) {
        var name = nameField.text ?? ""
        if name == "" { name = "No Name" }
        
        let grade = gradeValueArray[Int(gradeStepper.value)].gradeValue
        let gradeLetter = gradeValueArray[Int(gradeStepper.value)].gradeLetter
        let creditHours = Int(creditHourStepper.value)
        
        let currentClassEntry = classEntry(id: UUID(), name: name,  grade: grade, gradeLetter: gradeLetter, creditHours: creditHours)
        
        delegate?.save(workout: currentClassEntry)
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
}




