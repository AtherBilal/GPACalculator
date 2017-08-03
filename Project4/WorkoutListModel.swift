
import Foundation

protocol WorkoutListModelDelegate: class {
    func dataRefreshed()
}

protocol WorkoutListModelInterface {
    weak var delegate: WorkoutListModelDelegate? { get set }
    var count: Int { get }
    func workout(atIndex index: Int) -> classEntry?
    func save(workout: classEntry)
    func sortByDuration()
    var currentCompletedGPA: Double? { get }
    var currentProjectedGPA: Double? { get }
    func delete(classEntrytoDelete: classEntry)


//    func sortByCaloriesBurnedDescending()
//    func sortByDate(ascending: Bool)
}

class WorkoutListModel: WorkoutListModelInterface {
    
    weak var delegate: WorkoutListModelDelegate?
    
    private var workouts = [classEntry]()
    private let persistence: WorkoutPersistenceInterface?
    
    init() {
        self.persistence = ApplicationSession.sharedInstance.persistence
        workouts = self.persistence?.savedWorkouts ?? []
    }
    
    var count: Int {
        return workouts.count
    }
    var totalCompletedGradeScore: Double? {
        if workouts.count != 0 {
            var total = 0.0
            workouts.forEach {
                if $0.isProjectedGrade == false {
                    if $0.isRepeat {
                        total += $0.completedNewGradeScore()!
                    } else {
                        total += $0.gradeScore()
                    }
                } else if $0.isProjectedGrade && $0.isRepeat {
                    print("projected and repeaat")
                    total += $0.gradeScore()
                }
            }
            return total
        } else {
            return nil
        }
        

    }
    
    var totalProjectedGradeScore: Double? {
        if workouts.count != 0 {
            var total = 0.0
            workouts.forEach {
                if $0.isProjectedGrade {
                    if $0.isRepeat {
                        total += $0.projectedNewGradeScore()!
                    } else {
                        total += $0.gradeScore()
                    }
                }
            }
            return total
        } else {
            return nil
        }

    }
    
    var totalOverallGradeScore: Double? {
        if workouts.count != 0 {
            var total = 0.0
            workouts.forEach {
                total += $0.gradeScore()
            }
            return total
        } else {
            return nil
        }
    }
    
    var totalOverallCreditHours: Int? {
        if workouts.count != 0 {
            var total = 0
            workouts.forEach {
                total += $0.creditHours
            }
            return total
        } else {
            return nil
        }

    }
    
    var totalCompletedCreditHours: Int? {
        if workouts.count != 0 {
            var total = 0
            workouts.forEach {
                if $0.isProjectedGrade == false {
                    total += $0.creditHours
                } else if $0.isProjectedGrade && $0.isRepeat {
                    total += $0.creditHours
                }
            }
            return total
        } else {
            return nil
        }
        

    }
    
    var totalProjectedCreditHours: Int? {
        if workouts.count != 0 {
            var total = 0
            workouts.forEach {
                if $0.isProjectedGrade {
                    total += $0.creditHours
                }
            }
            return total
        } else {
            return nil
        }
    }
    
    
    func workout(atIndex index: Int) -> classEntry? {
        return workouts.element(at: index)
    }
    
    func save(workout: classEntry) {
        workouts.append(workout)
        persistence?.save(workout: workout)
        delegate?.dataRefreshed()
    }
    
    func delete(classEntrytoDelete: classEntry) {
        let indexToDelete = workouts.index(where: {$0.id == classEntrytoDelete.id})
        workouts.remove(at: indexToDelete!)
        persistence?.delete(classEntry: classEntrytoDelete)
        delegate?.dataRefreshed()
    }
    
    func sortByDuration () {
        workouts = workouts.sorted { $0.grade > $1.grade}
        delegate?.dataRefreshed()
    }
    var currentCompletedGPA: Double? {
        if let totalGradeScore = totalCompletedGradeScore,
            let totalCreditHours = totalCompletedCreditHours {
            return totalGradeScore / Double(totalCreditHours)
        } else {
            return nil
        }
    }
    var currentProjectedGPA: Double? {
        if let totalGradeScore = totalProjectedGradeScore,
            let totalCreditHours = totalProjectedCreditHours,
            totalCreditHours > 0 {
            print("totalGradeScore: \(totalGradeScore)")
            print("totalCreditHours: \(totalCreditHours)")

            return totalGradeScore / Double(totalCreditHours)
        } else {
            return nil
        }
    }
//    func sortByCaloriesBurnedDescending() {
//        workouts = workouts.sorted { $0.caloriesBurned() > $1.caloriesBurned()}
//        delegate?.dataRefreshed()
//    }
//    func sortByDate(ascending: Bool) {
//        if ascending {
//            workouts = workouts.sorted { $0.date < $1.date }
//
//        } else {
//            workouts = workouts.sorted { $0.date > $1.date }
//        }
//        delegate?.dataRefreshed()
//    }
}


