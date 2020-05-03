//
//  ViewController.swift
//  CoronaModel
//
//  Created by Caroline on 4/14/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import SpriteKit

class ViewController: UIViewController, UpdateCountDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var healthyLabel: UILabel!
    @IBOutlet var infectedLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var deadLabel: UILabel!
    @IBOutlet var rNaughtLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var GameSKView : SKView!
    
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
    
    
    /*
     Listener for simulate button at the top right 
     */
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        
    }
    
    
    func centerMapOnPenn() {
        let region = MKCoordinateRegion(center: centralCoord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func updateCount(healthy: Int, infected: Int, recovered: Int, dead : Int) {
        healthyLabel.text = "Healthy: \(healthy)"
        infectedLabel.text = "Infected: \(infected)"
        recoveredLabel.text = "Recovered: \(recovered)"
        deadLabel.text = "Dead: \(dead)"

    }

    func updateR0(rNaught: Double) {
        rNaughtLabel.text = String(format: "R0: %.2f", rNaught)
    }
    
    
    
}

// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    
}
