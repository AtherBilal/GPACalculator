import Foundation

protocol WorkoutPersistenceInterface {
    var savedWorkouts: [classEntry] { get }
    func save(workout: classEntry)
    func delete(classEntry: classEntry)
}

class WorkoutPersistence: JsonStoragePersistence, WorkoutPersistenceInterface {
    let directoryUrl: URL
    
    init?(atUrl baseUrl: URL, withDirectoryName name: String) {
        guard let directoryUrl = FileManager.default.createDirectory(atUrl: baseUrl, appendingPath: name) else { return nil }
        self.directoryUrl = directoryUrl
    }
    
    var savedWorkouts: [classEntry] {
        let jsonDicts = names.flatMap { read(jsonFileWithId: $0) }
        return jsonDicts.flatMap { classEntry.createFrom(dict: $0) }
    }
    
    func save(workout: classEntry) {
        save(data: workout.toDictionary(), withId: workout.id.uuidString)
    }
    func delete(classEntry: classEntry) {
        removeJsonFile(withId: classEntry.id.uuidString)
    }
}
