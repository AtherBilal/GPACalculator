
import Foundation

typealias JsonDictionary = [String:Any]

protocol FileStoragePersistence {
    var directoryUrl: URL { get }
    var fileType: String { get }
}

extension FileStoragePersistence {
    
    var files: [URL] {
        return FileManager.default.contentsOfDirectory(atUrl: directoryUrl, matchingType: fileType) ?? []
    }
    
    var names: [String] {
        return files.map { $0.baseName }
    }
    
    @discardableResult
    func addFile(withName name: String) -> Bool {
        let url = FileManager.default.createFile(atUrl: directoryUrl, withName: name, ofType: fileType)
        return url != nil
    }
    
    @discardableResult
    func removeFile(withName name: String) -> Bool {
        let fileUrl = directoryUrl.appendingPathComponent("\(name).\(fileType)")
        return FileManager.default.deleteFile(atUrl: fileUrl)
    }
    
}

protocol JsonStoragePersistence: FileStoragePersistence {
    
}

extension JsonStoragePersistence {
    var fileType: String { return "json" }
    
    @discardableResult
    func save(data: JsonDictionary, withId id: String) -> Bool {
        return FileManager.default.save(jsonDict: data, to: directoryUrl, withId: id)
    }
    
    func read(jsonFileWithId id: String) -> JsonDictionary? {
        return FileManager.default.readJsonDict(withId: id, at: directoryUrl)
    }
}
