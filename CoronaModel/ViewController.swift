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
    @IBOutlet var daysLabel: UILabel!
    @IBOutlet var GameSKView : SKView!
    
    var healthyCount = 0
    var infectedCount = 0
    var recoveredCount = 0
    var annotations : [MKPointAnnotation] = []
    let centralCoord = CLLocationCoordinate2D(latitude: 39.950908, longitude: -75.196032)
    let regionRadius: CLLocationDistance = 1000 // meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        centerMapOnPenn()
        
        GameSKView.allowsTransparency = true
        GameSKView.backgroundColor = .clear
        if let mapScene = SKScene(fileNamed: "MapScene")
        {
            mapScene.scaleMode = .aspectFill
            mapScene.backgroundColor = .clear
            if let mapScene = mapScene as? MapScene {
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
    
    func updateCount(healthy: Int, infected: Int) {
        healthyLabel.text = "Healthy: \(healthy)"
        infectedLabel.text = "Infected: \(infected)"
        
    }
    
    
    
    
}

// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    
}
