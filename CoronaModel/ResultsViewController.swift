//
//  ResultsViewController.swift
//  CoronaModel
//
//  Created by Caroline on 5/3/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var rNaught : String = ""
    var fatalities : String = ""
    var healthy : String = ""
    var recovered : String = ""
    var infected : String = ""
    

    @IBOutlet weak var rNaughtLabel: UILabel!
    
    @IBOutlet weak var healthyLabel: UILabel!
    
    
    @IBOutlet weak var infectedLabel: UILabel!
    
    
    @IBOutlet weak var recoveredLabel: UILabel!
    
    @IBOutlet weak var fatalitiesLabel: UILabel!
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)
        print("I'm getting called")
        rNaughtLabel.text = "R0: \(rNaught)"
        healthyLabel.text = "Healthy: \(healthy)"
        infectedLabel.text = "Infected: \(infected)"
        recoveredLabel.text = "Recovered: \(recovered)"
        fatalitiesLabel.text = "Fatalities: \(fatalities)"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
