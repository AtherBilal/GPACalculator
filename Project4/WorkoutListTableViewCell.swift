
import UIKit


class WorkoutListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var gradeScoreLabel: UILabel!

    @IBOutlet weak var oldGradeLabel: UILabel!
    @IBOutlet weak var creditHoursLabel: UILabel!
    
    func decorate(with classEntry: classEntry) {
        oldGradeLabel.isHidden = classEntry.isRepeat ? false: true
        nameLabel.text = classEntry.name
        oldGradeLabel.text = classEntry.isRepeat ? "Old Grade: \(classEntry.grade) or \(classEntry.gradeLetter)" : ""
        
        
        if classEntry.isRepeat {
            
            gradeLabel.text = classEntry.isProjectedGrade ?
                "Projected: \(classEntry.newGradeLetter!) or \(classEntry.newGradeLetter!)": "New Grade: \(classEntry.newGrade!) or \(classEntry.newGradeLetter!)"
            
        } else {
            var gradeLabelValue: String = ""
            if classEntry.isProjectedGrade {
                gradeLabelValue += "Projected: "
            }
            if classEntry.gradeLetter != "custom" {
                gradeLabelValue += "\(classEntry.grade) or \(classEntry.gradeLetter)"
            } else {
                gradeLabelValue += "\(classEntry.grade)"
    
            }
            gradeLabel.text = gradeLabelValue
        }

        gradeScoreLabel.text = "\(classEntry.gradeScore()) Score"
        creditHoursLabel.text = "\(classEntry.creditHours) Credit Hours"
    }
}
