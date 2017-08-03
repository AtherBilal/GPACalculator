
import UIKit


class WorkoutListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var gradeScoreLabel: UILabel!

    @IBOutlet weak var creditHoursLabel: UILabel!
    
    func decorate(with classEntry: classEntry) {
        nameLabel.text = classEntry.name
        
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
        gradeScoreLabel.text = "\(classEntry.gradeScore()) Score"
        creditHoursLabel.text = "\(classEntry.creditHours) Credit Hours"
    }
}
