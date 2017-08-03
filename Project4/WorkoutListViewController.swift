

import UIKit
import os.log

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class WorkoutListViewController: UIViewController {

    @IBOutlet weak var CurrentGPALabel: UILabel!
    @IBOutlet weak var projectedGPALabel: UILabel!
    @IBOutlet weak fileprivate var tableView: UITableView!
    
    fileprivate var model: WorkoutListModelInterface = WorkoutListModel()
    
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
             guard let WorkoutCreationViewController = segue.destination as? WorkoutCreationViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedClassCell = sender as? WorkoutListTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedClassCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedClass = model.workout(atIndex: indexPath.row)
            WorkoutCreationViewController.selectedClass = selectedClass

            
        case "sort":
            os_log("Sorting class.", log: OSLog.default, type: .debug)
        default:
            os_log("ERROR", log: OSLog.default, type: .debug)

        }
        

        if let creationViewController = segue.destination as? WorkoutCreationViewController {
            creationViewController.delegate = self
        } else if let destination = segue.destination as?
        WorkoutSortByViewController {
            destination.delegate = self

        }
    }



}

extension WorkoutListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell",
                                                     for: indexPath) as? WorkoutListTableViewCell,
            let workout = model.workout(atIndex: indexPath.row)
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
            model.delete(classEntrytoDelete: model.workout(atIndex: indexPath.row)!)
        }
    }
}

extension WorkoutListViewController: WorkoutCreationViewControllerDelegate {
    func delete(classEntrytoDelete classEntry: classEntry) {
        model.delete(classEntrytoDelete: classEntry)
    }

    func save(workout: classEntry) {
        model.save(workout: workout)
    }
}

extension WorkoutListViewController: WorkoutListModelDelegate {
    func dataRefreshed() {
        tableView.reloadData()
        updateLabels()


    }
}

extension WorkoutListViewController: WorkoutSortByViewControllerDelegate {
    func sortByDuration() {
        model.sortByDuration()
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
//    func sortByCaloriesBurned() {
//        model.sortByCaloriesBurnedDescending()
//    }
//    func sortByDate(ascending: Bool) {
//        if ascending {
//            model.sortByDate(ascending: true)
//        } else {
//            model.sortByDate(ascending: false)
//        }
//    }
    
}
