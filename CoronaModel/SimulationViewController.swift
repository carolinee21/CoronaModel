//
//  ViewController.swift
//  CoronaModel
//
//  Created by Caroline on 4/14/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit
import MapKit
import SpriteKit

class ViewController: UIViewController, SimulationUIDelegate, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var healthyLabel: UILabel!
    @IBOutlet var infectedLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var deadLabel: UILabel!
    @IBOutlet var rNaughtLabel: UILabel!
    @IBOutlet var GameSKView : SKView!
    @IBOutlet weak var durationLabel: UILabel!
    
    // User input as passed in from the root LaunchViewController
    var socialDistance = 0
    var initialCases = 0
    var initialSick = 0
    var duration = 0
    
    let centralCoord = CLLocationCoordinate2D(latitude: 39.950908, longitude: -75.196032)
    let regionRadius: CLLocationDistance = 1000 // meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        centerMapOnPenn()
        
        GameSKView.allowsTransparency = true
        GameSKView.backgroundColor = .clear
        if let mapScene = SKScene(fileNamed: "MapScene")
        {
            mapScene.scaleMode = .aspectFill
            mapScene.backgroundColor = .clear
            mapScene.scaleMode = SKSceneScaleMode.resizeFill
            if let mapScene = mapScene as? MapScene {
                mapScene.socialDistance = self.socialDistance
                mapScene.initialCases = self.initialCases
                mapScene.initialSick = self.initialSick
                mapScene.duration = TimeInterval(self.duration)
                // This gives the "mapScene" aka all the Sprite scene stuff
                // a way to communicate back with the UI to display counts
                mapScene.updateCountDelegate = self
            }
            GameSKView.presentScene(mapScene)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnPenn()
        
    }

    func centerMapOnPenn() {
        let region = MKCoordinateRegion(center: centralCoord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func updateCount(healthy: Int, infected: Int, recovered: Int, dead : Int) {
        healthyLabel.text = "Healthy: \(healthy)"
        infectedLabel.text = "Infected: \(infected)"
        recoveredLabel.text = "Recovered: \(recovered)"
        deadLabel.text = "Fatalities: \(dead)"

    }

    func updateR0(rNaught: Double) {
        rNaughtLabel.text = String(format: "R0: %.2f", rNaught)
    }
    
    func endSimulation(healthy: Int, infected: Int, recovered: Int, dead: Int, rNaught: Double) {
        //print("over")
        // here, can either segue to a results page, or present these to the user in a bubble pop-up.
        
        // this calls the segue with a small delay just so it looks a little better
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute: {
            self.performSegue(withIdentifier: "results", sender: self)
        })
        

    }
    
    // Passes in input information to the results controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "results" {
            var vc = segue.destination as! ResultsViewController
            vc.modalPresentationStyle = .fullScreen
            
            let fatalities = deadLabel.text!.components(separatedBy: ":")[1]
            print("fatalities is " + fatalities)
            if Int(fatalities) == nil {
                print("the int of fatalities is nil")
            } else {
                print("hey its not nil")
            }
            vc.fatalities = fatalities
            
            let rNaught = rNaughtLabel.text!.components(separatedBy: ":")[1]
            vc.rNaught = rNaught
            
            let healthy = healthyLabel.text!.components(separatedBy: ":")[1]
            vc.healthy = healthy
           
            let recovered = recoveredLabel.text!.components(separatedBy: ":")[1]
            vc.recovered = recovered
            
            let infected = infectedLabel.text!.components(separatedBy: ":")[1]
            vc.infected = infected
        }

    }
        
    func updateDuration(timeLeft : Int) {
        durationLabel.text = "Days Left: \(timeLeft)"
    }
    
    
}

