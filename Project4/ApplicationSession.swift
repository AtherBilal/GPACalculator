
import Foundation

// Application Session singleton
class ApplicationSession {
    static let sharedInstance = ApplicationSession()
    
    var persistence: WorkoutPersistenceInterface?
    
    private init() {
        if let appStorageUrl = FileManager.default.createDirectoryInUserLibrary(atPath: "WorkoutApp"),
            let persistence = WorkoutPersistence(atUrl: appStorageUrl, withDirectoryName: "workouts") {
            self.persistence = persistence
        }
    }
}
