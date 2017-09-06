
import Foundation


enum GradeValue: Double {
    case a = 4.0
    case aMinus = 3.7
    case bPlus = 3.3
    case b = 3.0
    case bMinus = 2.7
    case cPlus = 2.3
    case c = 2.0
    case cMinus = 1.7
    case dPlus = 1.3
    case d = 1.0
    case dMinus = 0.7
    case f = 0
    
    static var allCases: [GradeValue] {
        return [f, dMinus, d, dPlus,cMinus, c, cPlus,bMinus, b, bPlus, aMinus, a]
    }
    
    var gradeLetter: String {
        switch self {
        case .a : return "A"
        case .aMinus : return "A-"
        case .bPlus : return "B+"
        case .b : return "B"
        case .bMinus : return "B-"
        case .cPlus : return "C+"
        case .c : return "C"
        case .cMinus : return "C-"
        case .dPlus : return "D+"
        case .d : return "D"
        case .dMinus : return "D-"
        case .f: return "F"
        }
    }
    
}


struct classEntry {
    let id: UUID
    let name: String
    let grade: Double
    let newGrade: Double?
    let newGradeLetter: String?
    let gradeLetter: String
    let creditHours: Int
    let isProjectedGrade: Bool
    let isRepeat: Bool
    
    func gradeScore () -> Double {
        return Double(creditHours) * grade
    }
    func projectedNewGradeScore() -> Double? {
        if isRepeat && isProjectedGrade {
            return Double(creditHours) * newGrade!
        } else {
            return nil
        }
    }
    func completedNewGradeScore() -> Double? {
        if isRepeat && !isProjectedGrade {
            return Double(creditHours) * newGrade!
        } else {
            return nil
        }
    }
    
    
}
extension classEntry {
    func toDictionary() -> JsonDictionary {
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "grade": self.grade,
            "newGrade": self.newGrade as Any,
            "newGradeLetter": self.newGradeLetter as Any,
            "gradeLetter": self.gradeLetter,
            "creditHours": self.creditHours,
            "isProjectedGrade": self.isProjectedGrade,
            "isRepeat": self.isRepeat
        ]
    }
    
    static func createFrom(dict: JsonDictionary) -> classEntry? {
        guard
            let idString = dict["id"] as? String,
            let id = UUID(uuidString: idString),
            let name = dict["name"] as? String,
            let grade = dict["grade"] as? Double,
            let newGrade = dict["newGrade"] as? Double?,
            let newGradeLetter = dict["newGradeLetter"] as? String?,
            let creditHours = dict["creditHours"] as? Int,
            let gradeLetter = dict["gradeLetter"] as? String,
            let isProjectedGrade = dict["isProjectedGrade"] as? Bool,
            let isRepeat = dict["isRepeat"] as? Bool
        else {
            return nil
        }
        return classEntry(id: id, name: name, grade: grade, newGrade: newGrade,newGradeLetter: newGradeLetter, gradeLetter: gradeLetter, creditHours: creditHours, isProjectedGrade: isProjectedGrade, isRepeat: isRepeat)
    }
}
