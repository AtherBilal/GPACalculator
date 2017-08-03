

import UIKit

protocol WorkoutCreationViewControllerDelegate: class {
    func save(workout: classEntry)
    func delete(classEntrytoDelete: classEntry)

}

class WorkoutCreationViewController: UIViewController {
    


    weak var delegate: WorkoutCreationViewControllerDelegate?
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var gradeNumberValue: UILabel!
    @IBOutlet private weak var gradeLetterValue: UILabel!
    @IBOutlet private weak var gradeStepper: UIStepper!
    @IBOutlet private weak var creditHourStepper: UIStepper!
    @IBOutlet private weak var creditHourValueLabel: UILabel!
    @IBOutlet private weak var customGradeSwitch: UISwitch!
    
    @IBOutlet weak var gradeNumberOrOldGradeNumberLabel: UILabel!
    @IBOutlet private weak var repeatCourseGradeEntryStackView: UIStackView!
    
    @IBOutlet private weak var customGradeEntryStackView: UIStackView!
    @IBOutlet private weak var gradeStepperEntryStackView: UIStackView!
    @IBOutlet fileprivate weak var tappableBackgroundView: UIView!
    @IBOutlet private weak var customGradeEntryTextField: UITextField!
    @IBOutlet private weak var newGradeNumberValueLabel: UILabel!
    @IBOutlet private weak var newGradeLetterValueLabel: UILabel!
    
    @IBOutlet private weak var isRepeatSwitch: UISwitch!
    @IBOutlet private weak var isProjectedClassSwitch: UISwitch!
    @IBOutlet private weak var newGradeStepper: UIStepper!
    @IBOutlet private weak var isProjectedLabel: UILabel!
    
    

    
    var selectedClass: classEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if let classEntrytoEdit = selectedClass {
            updateUIComponents(classEntry: classEntrytoEdit)
            } else {
            gradeStepper.value = Double(GradeValue.allCases.count - 1)
            gradeNumberValue.text = "\(GradeValue.allCases[Int(gradeStepper.value)].rawValue)"
            
            
            
            newGradeStepper.value = Double(GradeValue.allCases.count - 1)
            newGradeLetterValueLabel.text = "\(GradeValue.allCases[Int(newGradeStepper.value)].gradeLetter)"
            
            newGradeNumberValueLabel.text = "\(GradeValue.allCases[Int(newGradeStepper.value)].rawValue)"

            
            creditHourStepper.value = 3
            creditHourValueLabel.text = "\(Int(creditHourStepper.value))"


        }
        // Configure minutes stepper and label
        
        
        gradeStepper.minimumValue = 0
        gradeStepper.maximumValue = Double(GradeValue.allCases.count - 1)
        


        newGradeStepper.minimumValue = 0
        newGradeStepper.maximumValue = Double(GradeValue.allCases.count - 1)
        
        // Calories per minute
        creditHourStepper.minimumValue = 1
        creditHourStepper.maximumValue = 90

        
        // Configure tappable background when keyboard or picker is displayed
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tappableBackgroundView.addGestureRecognizer(tapGestureRecognizer)
        tappableBackgroundView.isHidden = true

        // Configure delegates
        customGradeEntryTextField.delegate = self
        nameField.delegate = self
    }

    @IBAction func isRepeatSwitchChanged(_ sender: UISwitch) {
        let wasCustomSwitchOn = customGradeSwitch.isOn
        if sender.isOn {
            customGradeEntryStackView.isHidden = true
            customGradeSwitch.isEnabled = false
            repeatCourseGradeEntryStackView.isHidden = false
            gradeStepper.minimumValue = 0
            gradeStepper.maximumValue = 4
            gradeValueChanged(gradeStepper)
            gradeNumberOrOldGradeNumberLabel.text = "Previous Grade:"
            isProjectedLabel.text = "Projected New Grade?"

        } else {
            customGradeEntryStackView.isHidden = wasCustomSwitchOn ? false : true
            customGradeSwitch.isEnabled = true
            repeatCourseGradeEntryStackView.isHidden = true
            gradeStepper.minimumValue = 0
            gradeStepper.maximumValue = Double(GradeValue.allCases.count - 1)
            gradeNumberOrOldGradeNumberLabel.text = "Grade Value:"
            isProjectedLabel.text = "Projected?"

            
        }

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
    @IBAction func newGradeStepperValueChanged(_ sender: UIStepper) {
        newGradeNumberValueLabel.text =  "\(GradeValue.allCases[Int(newGradeStepper.value)].rawValue)"
        newGradeLetterValueLabel.text = "\(GradeValue.allCases[Int(newGradeStepper.value)].gradeLetter)"
    }
    
    @IBAction func gradeValueChanged(_ sender: UIStepper) {
        gradeNumberValue.text =  "\(GradeValue.allCases[Int(gradeStepper.value)].rawValue)"
        gradeLetterValue.text = "\(GradeValue.allCases[Int(gradeStepper.value)].gradeLetter)"
        
//        isRepeatSwitch.isEnabled = GradeValue.allCases[Int(gradeStepper.value)].rawValue > 1.7 ? true : false

    }

    
    @IBAction private func creditHourValueChanged(_ sender: UIStepper) {
        creditHourValueLabel.text = "\(Int(sender.value))"

    }

    @IBAction func addClassButtonPressed(_ sender: Any) {
        var name = nameField.text ?? ""
        if name == "" { name = "No Name" }
        var grade: Double
        var newGrade: Double?
        let newGradeLetter: String?
        let isRepeat: Bool
        var gradeLetter = "custom"
        let creditHours = Int(creditHourStepper.value)
        let isProjected: Bool
        var meetsConditions = true
        
        isProjected = isProjectedClassSwitch.isOn ? true : false

        enum customInputError: Error {
            case noInput, moreThanOneDecimal, tooHigh, tooLow
        }

        isRepeat = isRepeatSwitch.isOn ? true : false
        
        newGrade = isRepeatSwitch.isOn ? GradeValue.allCases[Int(newGradeStepper.value)].rawValue : nil
        newGradeLetter = isRepeatSwitch.isOn ? GradeValue.allCases[Int(newGradeStepper.value)].gradeLetter : nil

        
        func checkCustomInputValue() throws {
            
            if let customGradeEntered = Double(customGradeEntryTextField.text!) {
                print("THIS IS RUNNIN")
                if Double(customGradeEntered) < 0.0 {
                    throw customInputError.tooLow
                } else if Double(customGradeEntered) > 4.0 {
                    throw customInputError.tooHigh
                }
            } else {
                if (customGradeEntryTextField.text!.components(separatedBy: ".").count) > 1 {
                    throw customInputError.moreThanOneDecimal
//                    sendAlert(message: "Please make sure you have only one decimal point")
                } else {
                    throw customInputError.noInput
                }
            }
        }
        
        do {
            if customGradeSwitch.isOn == true && customGradeSwitch.isEnabled == true {
                try checkCustomInputValue()
                grade = Double(customGradeEntryTextField.text!)!
                gradeLetter = "custom"
            } else {
                grade = GradeValue.allCases[Int(gradeStepper.value)].rawValue
                gradeLetter = GradeValue.allCases[Int(gradeStepper.value)].gradeLetter
            }
            
            if let editingAClass = selectedClass {
                print("should be replacing an item here")
                let currentClassEntry = classEntry(id: editingAClass.id, name: name,  grade: grade, newGrade: newGrade, newGradeLetter: newGradeLetter, gradeLetter: gradeLetter, creditHours: creditHours, isProjectedGrade: isProjected, isRepeat: isRepeat)
                delegate?.delete(classEntrytoDelete: currentClassEntry)
                delegate?.save(workout: currentClassEntry)

            } else {
                let currentClassEntry = classEntry(id: UUID(), name: name,  grade: grade,newGrade: newGrade, newGradeLetter: newGradeLetter, gradeLetter: gradeLetter, creditHours: creditHours, isProjectedGrade: isProjected, isRepeat: isRepeat)
                delegate?.save(workout: currentClassEntry)

            }

        } catch customInputError.moreThanOneDecimal {
            sendAlert(message: "Looks like you have an extra decimal in there")

        } catch customInputError.noInput {
            sendAlert(message: "Please enter your custom grade!")

        } catch customInputError.tooHigh {
            sendAlert(message: "Please enter a number less than or equal to 4.0")
        } catch customInputError.tooLow {
            sendAlert(message: "Please enter a number greater than 0")

        } catch {
            sendAlert(message: "Some occurred, try again")
        }

        let _ = navigationController?.popViewController(animated: true)
    }

    
    @objc private func backgroundTapped() {
        self.view.endEditing(true)  // this actually loops through all this view's subviews and resigns the first responder on all of them
        tappableBackgroundView.isHidden = true
    }
    
    func updateUIComponents (classEntry: classEntry?) {
        
        if let classEntrytoEdit = classEntry {
            print("updating")
            nameField.text = classEntrytoEdit.name
            creditHourStepper.value = Double(classEntrytoEdit.creditHours)
            creditHourValueLabel.text = "\(classEntrytoEdit.creditHours)"
            
            if classEntrytoEdit.isProjectedGrade {
                print("IT IS PROJECTED")
                isProjectedClassSwitch.isOn = true
            } else {
            isProjectedClassSwitch.isOn = false
            }
            if classEntrytoEdit.gradeLetter != "custom" {
                customGradeSwitch.isOn = false
                gradeStepper.value = Double(findGradeIndex(grade: classEntrytoEdit.grade))
                gradeNumberValue.text = "\(GradeValue.allCases[Int(gradeStepper.value)].rawValue)"
                gradeLetterValue.text = "\(GradeValue.allCases[Int(gradeStepper.value)].gradeLetter)"
            } else {
                customGradeSwitch.isOn = true
                customGradeEntryStackView.isHidden = false
                gradeStepperEntryStackView.isHidden = true
                customGradeEntryTextField.text = "\(classEntrytoEdit.grade)"
            }
        }
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



func findGradeIndex(grade: Double) -> Int {
    var index: Int = -1
    var indexCounter = 0
    for gradeValue in GradeValue.allCases {
        if gradeValue.rawValue == grade {
            index = indexCounter
        }
        indexCounter += 1
    }
    return index
}


