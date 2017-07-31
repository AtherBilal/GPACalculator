//
//  WorkoutSortByViewController.swift
//  Project4
//
//  Created by Bilal Ather on 7/22/17.
//  Copyright © 2017 umsl. All rights reserved.
//

import UIKit

protocol WorkoutSortByViewControllerDelegate: class {
//    func sortByDuration()
//    func sortByCaloriesBurned()
}


class WorkoutSortByViewController: UIViewController {

    weak var delegate: WorkoutSortByViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dateAscendingButtonPressed(_ sender: Any) {
//        delegate?.sortByDate(ascending: true)
//        let _ = navigationController?.popViewController(animated: true)
//        print("Sort By Date")

    }
    
    @IBAction func dateDescendingButtonPressed(_ sender: Any) {
//        print("Sort By Date Descending")
//        delegate?.sortByDate(ascending: false)
//        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func durationDescendingButtonPressed(_ sender: Any) {
//        print("Sort By Duration Descending")
//        delegate?.sortByDuration()
//        let _ = navigationController?.popViewController(animated: true)

    }
    
    @IBAction func caloriesBurnedDescendingButtonPressed(_ sender: Any) {
//        print("Sort By Calories Burned")
//        delegate?.sortByCaloriesBurned()
//        let _ = navigationController?.popViewController(animated: true)

    }

}
