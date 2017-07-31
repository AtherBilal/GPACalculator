
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
    
    func workout(atIndex index: Int) -> classEntry? {
        return workouts.element(at: index)
    }
    
    func save(workout: classEntry) {
        workouts.append(workout)
        persistence?.save(workout: workout)
        delegate?.dataRefreshed()
    }
    func sortByDuration () {
        workouts = workouts.sorted { $0.grade > $1.grade}
        delegate?.dataRefreshed()
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


