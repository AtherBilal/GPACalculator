
import Foundation


//var gradeValues: [(String, Double)] = [ ("A", 4.0),("A-", 3.70), ("B+", 3.3), ("B", 3.3), ("B-", 2.7), ("C+", 2.3), ("C", 2.0), ("C-", 1.7), ("D+", 1.3), ("D", 1.0), ("D-", 0.7), ("F", 0),("FN", 0)]
//
//enum gradeValues {
//    case a, aMinus, bPlus, b, bMinus, cPlus, c, cMinus, dPlus, d, dMinus, f
//    var gradeValue: Double {
//        switch self {
//        case .a : return 4.0
//        case .aMinus : return 3.7
//        case .bPlus : return 3.3
//        case .b : return 3.0
//        case .bMinus : return 2.7
//        case .cPlus : return 2.3
//        case .c : return 2.0
//        case .cMinus : return 1.7
//        case .dPlus : return 1.3
//        case .d : return 1.0
//        case .dMinus : return 0.7
//        case .f: return 0
//        }
//    }
//    var gradeLetter: String {
//        switch self {
//        case .a : return "A"
//        case .aMinus : return "A-"
//        case .bPlus : return "B+"
//        case .b : return "B"
//        case .bMinus : return "B-"
//        case .cPlus : return "C+"
//        case .c : return "C"
//        case .cMinus : return "C-"
//        case .dPlus : return "D+"
//        case .d : return "D"
//        case .dMinus : return "D-"
//        case .f: return "F"
//        }
//    }
//    
//}

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

//    let gradeValueArray: [gradeValues] =
//        [gradeValues.f,
//         gradeValues.dMinus,
//         gradeValues.d,
//         gradeValues.dPlus,
//         gradeValues.cMinus,
//         gradeValues.c,
//         gradeValues.cPlus,
//         gradeValues.bMinus,
//         gradeValues.b,
//         gradeValues.bPlus,
//         gradeValues.aMinus,
//         gradeValues.a]


struct classEntry {
    let id: UUID
    let name: String
    let grade: Double
    let gradeLetter: String
    let creditHours: Int
    let isProjectedGrade: Bool
    func gradeScore () -> Double {
        return Double(creditHours) * grade
    }
    
}
extension classEntry {
    func toDictionary() -> JsonDictionary {
        return [
            "id": self.id.uuidString,
            "name": self.name,
            "grade": self.grade,
            "gradeLetter": self.gradeLetter,
            "creditHours": self.creditHours,
            "isProjectedGrade": self.isProjectedGrade
        ]
    }
    
    static func createFrom(dict: JsonDictionary) -> classEntry? {
        guard
            let idString = dict["id"] as? String,
            let id = UUID(uuidString: idString),
            let name = dict["name"] as? String,
            let grade = dict["grade"] as? Double,
            let creditHours = dict["creditHours"] as? Int,
            let gradeLetter = dict["gradeLetter"] as? String,
            let isProjectedGrade = dict["isProjectedGrade"] as? Bool
        else {
            return nil
        }
        return classEntry(id: id, name: name, grade: grade, gradeLetter: gradeLetter, creditHours: creditHours, isProjectedGrade: isProjectedGrade)
    }
}
