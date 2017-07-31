
import UIKit


class WorkoutListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var gradeScoreLabel: UILabel!

    @IBOutlet weak var creditHoursLabel: UILabel!
    
    func decorate(with classEntry: classEntry) {
        nameLabel.text = classEntry.name
        if classEntry.gradeLetter != "custom" {
            gradeLabel.text = "\(classEntry.grade) or \(classEntry.gradeLetter)"
        } else {
            gradeLabel.text = "\(classEntry.grade)"

        }
        gradeScoreLabel.text = "\(classEntry.gradeScore()) Score"
        creditHoursLabel.text = "\(classEntry.creditHours) Credit Hours"
    }
}
