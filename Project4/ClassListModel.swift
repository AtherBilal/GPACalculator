
import Foundation

protocol ClassListModelDelegate: class {
    func dataRefreshed()
}

protocol ClassListModelInterface {
    weak var delegate: ClassListModelDelegate? { get set }
    var count: Int { get }
    func ClassEntry(atIndex index: Int) -> classEntry?
    func save(workout: classEntry)
    func sortByDuration()
    var currentCompletedGPA: Double? { get }
    var currentProjectedGPA: Double? { get }
    func delete(classEntrytoDelete: classEntry)
}

class ClassListModel: ClassListModelInterface {
    
    weak var delegate: ClassListModelDelegate?
    
    private var ClassEntries = [classEntry]()
    private let persistence: WorkoutPersistenceInterface?
    
    init() {
        self.persistence = ApplicationSession.sharedInstance.persistence
        ClassEntries = self.persistence?.savedWorkouts ?? []
    }
    
    var count: Int {
        return ClassEntries.count
    }
    var totalCompletedGradeScore: Double? {
        if ClassEntries.count != 0 {
            var total = 0.0
            ClassEntries.forEach {
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
        if ClassEntries.count != 0 {
            var total = 0.0
            ClassEntries.forEach {
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
        if ClassEntries.count != 0 {
            var total = 0.0
            ClassEntries.forEach {
                total += $0.gradeScore()
            }
            return total
        } else {
            return nil
        }
    }
    
    var totalOverallCreditHours: Int? {
        if ClassEntries.count != 0 {
            var total = 0
            ClassEntries.forEach {
                total += $0.creditHours
            }
            return total
        } else {
            return nil
        }

    }
    
    var totalCompletedCreditHours: Int? {
        if ClassEntries.count != 0 {
            var total = 0
            ClassEntries.forEach {
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
        if ClassEntries.count != 0 {
            var total = 0
            ClassEntries.forEach {
                if $0.isProjectedGrade {
                    total += $0.creditHours
                }
            }
            return total
        } else {
            return nil
        }
    }
    
    
    func ClassEntry(atIndex index: Int) -> classEntry? {
        return ClassEntries.element(at: index)
    }
    
    func save(workout: classEntry) {
        ClassEntries.append(workout)
        persistence?.save(workout: workout)
        delegate?.dataRefreshed()
    }
    
    func delete(classEntrytoDelete: classEntry) {
        let indexToDelete = ClassEntries.index(where: {$0.id == classEntrytoDelete.id})
        ClassEntries.remove(at: indexToDelete!)
        persistence?.delete(classEntry: classEntrytoDelete)
        delegate?.dataRefreshed()
    }
    
    func sortByDuration () {
        ClassEntries = ClassEntries.sorted { $0.grade > $1.grade}
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

}


