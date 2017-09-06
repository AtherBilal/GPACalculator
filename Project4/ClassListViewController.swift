

import UIKit
import os.log

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class ClassListViewController: UIViewController {

    @IBOutlet weak var CurrentGPALabel: UILabel!
    @IBOutlet weak var projectedGPALabel: UILabel!
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    fileprivate var model: ClassListModelInterface = ClassListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        updateLabels()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "addItem":
            os_log("Adding a new class.", log: OSLog.default, type: .debug)
        case "editItem":
            os_log("Editing a new class.", log: OSLog.default, type: .debug)
             guard let WorkoutCreationViewController = segue.destination as? ClassCreationViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedClassCell = sender as? ClassListTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedClassCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedClass = model.ClassEntry(atIndex: indexPath.row)
            WorkoutCreationViewController.selectedClass = selectedClass

            
        case "sort":
            os_log("Sorting class.", log: OSLog.default, type: .debug)
        default:
            os_log("ERROR", log: OSLog.default, type: .debug)

        }
        

        if let creationViewController = segue.destination as? ClassCreationViewController {
            creationViewController.delegate = self
        } 
    }



}

extension ClassListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell",
                                                     for: indexPath) as? ClassListTableViewCell,
            let workout = model.ClassEntry(atIndex: indexPath.row)
        else { return UITableViewCell() }
    
        cell.decorate(with: workout)
//        print("HERE IT IS COMPLETED")
//        print(model.currentCompletedGPA!)
//        print("HERE IT IS Projected")
//        print(model.currentProjectedGPA!)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.delete(classEntrytoDelete: model.ClassEntry(atIndex: indexPath.row)!)
        }
    }
}

extension ClassListViewController: WorkoutCreationViewControllerDelegate {
    func delete(classEntrytoDelete classEntry: classEntry) {
        model.delete(classEntrytoDelete: classEntry)
    }

    func save(workout: classEntry) {
        model.save(workout: workout)
    }
    func updateLabels() {
        if let currentCompletedGPA = model.currentCompletedGPA {
            CurrentGPALabel.text = "Completed GPA: \(currentCompletedGPA.roundTo(places: 3))"
        } else {
            CurrentGPALabel.text = "Completed GPA:"
        }
        if let currentProjectedGPA = model.currentProjectedGPA {
            print("BEING DISPLAYED HERE")
            projectedGPALabel.text = "Projected GPA: \(currentProjectedGPA.roundTo(places: 3))"
        } else {
            projectedGPALabel.text = "Projected GPA:"
            
        }
        
    }
}

extension ClassListViewController: ClassListModelDelegate {
    func dataRefreshed() {
        tableView.reloadData()
        updateLabels()


    }
}

