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
    

        // Passes in input information to the main ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startOver") {
            if let vc = segue.destination as? LaunchViewController {
                vc.modalPresentationStyle = .fullScreen
            }
        }
    }

}
