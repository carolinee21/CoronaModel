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

class ViewController: UIViewController {
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
    //let scene = MapScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        getInitialCases(numCases: 25, numSick: 1)
//        scene.scaleMode = .aspectFill
//        GameSKView.presentScene(scene)
        GameSKView.allowsTransparency = true
        GameSKView.backgroundColor = .clear
        if let mapScene = SKScene(fileNamed: "MapScene")
        {
            print("oi")
            mapScene.scaleMode = .aspectFill
            mapScene.backgroundColor = .clear
            GameSKView.presentScene(mapScene)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnPenn()
    
    }
    
    /*
     When the user taps the simulate button,
     we link to the storyboard to run a timestep
     of the simulation. Kind of a playground to try out new things
     and see how they work when you press the button, sorry it's
     messy and gross
     */
    @IBAction func tapSimulate(_ sender: UIButton) {
        for annotation in annotations {
            // distance parameter configures how far the case moves in one
            // "step", sideMovement is how much the case moves to "the side"
            // (i.e. if it is on a lateral path how much does it move vertically)
            // to give some variation in the movement
            animateAnnotation(annotation, distance: 0.0009, sideMovement: 0.0005)
        }
        
        // the idea here is just to animate the annotations, use the
        // computeDistances() function to update the relative distance
        // of cases, and then trasnmit based on that
    
    }
    
    
    
    func centerMapOnPenn() {
        let region = MKCoordinateRegion(center: centralCoord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func getInitialAnnotations(_ numCases: Int) {
        let variance = 0.005
        let x = 4
        outerloop: for _ in (-x-2)..<x+3 {
            for _ in (-x)..<x+1 {
                let lat = centralCoord.latitude + Double.random(in: -variance ..< variance)
                let lon = centralCoord.longitude + Double.random(in: -variance ..< variance)
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                // sets each of the current cases to healthy on the initial map 
                let currCase : CaseAnnotation = CaseAnnotation(coordinate: coord, currentStatus: caseStatus.healthy, isMe: false, direction: caseDirection.allCases.randomElement()!)
                self.annotations.append(currCase)
                updateHealthyCount(by: 1, increase: true)
                if self.annotations.count == numCases {
                    break outerloop
                }
            }
        }
        
    }
    
    
    /*
     Draws initial cases.
     */
    func getInitialCases(numCases : Int, numSick : Int) {
        getInitialAnnotations(numCases)
        getSickCases(numSick)
        self.mapView.addAnnotations(self.annotations)
        
    }
    
    /*
     Loops through array and pairwise compares cases for
     possible transmission.
     */
    func computeDistances() {
        for i in 1..<self.annotations.count {
            for j in i + 1..<self.annotations.count {
                compareCases(self.annotations[i], self.annotations[j])
            }
        }
    }
    
    /*
     Computes Euclidean Distance between two coordinates
     and possibly transmits based on the case type.
     */
    func compareCases(_ case1: MKAnnotation, _ case2: MKAnnotation) {
        let longDifference = abs(case1.coordinate.longitude - case2.coordinate.longitude)
        let latDifference = abs(case1.coordinate.latitude - case2.coordinate.latitude)
        let distance = (longDifference * longDifference + latDifference * latDifference).squareRoot()
        
        // Downcast from MKAnnotation to access CaseStatus Enum
        // and check status of cases
        if let case1 = case1 as? CaseAnnotation {
            if let case2 = case2 as? CaseAnnotation {
                switch (case1.status, case2.status) {
                case (.infected, .healthy):
                    transmit(case1, case2, distance)
                case (.healthy, .infected):
                    transmit(case2, case1, distance)
                default:
                    break
                }
            }
        }
    }
    
    /*
     Transmits the disease from Case 1 -> Case 2
     */
    func transmit(_ case1 : CaseAnnotation, _ case2 : CaseAnnotation, _ distance: Double) {
        if (distance < 0.002) {
            case2.status = .infected
            updateInfectedCount(by: 1, increase: true)
            updateHealthyCount(by: 1, increase: false)
        }
    }
    
    /*
     Modify healthyCount label in UI by some offset
     */
    func updateHealthyCount(by: Int, increase : Bool) {
        healthyCount = increase ? healthyCount + by : healthyCount - by
        healthyLabel.text = "Healthy: \(healthyCount)"
    }
    
    /*
     Modify infectedCount label in UI by some offset
     */
    func updateInfectedCount(by: Int, increase: Bool) {
        infectedCount = increase ? infectedCount + by : infectedCount - by
        infectedLabel.text = "Infected: \(infectedCount)"
    }
    
    func getSickCases(_ numSick : Int) {
        let variance = 0.005
        for _ in 1...numSick {
            let lat = centralCoord.latitude + Double.random(in: -variance ..< variance)
            let lon = centralCoord.longitude + Double.random(in: -variance ..< variance)
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            // sets each of these cases to sick
            let currCase : CaseAnnotation = CaseAnnotation(coordinate: coord, currentStatus: caseStatus.infected, isMe: true, direction: caseDirection.allCases.randomElement()!)
            self.annotations.append(currCase)
            updateInfectedCount(by: 1, increase: true)
        }
    }
    
    
    
    func animateAnnotation(_ annotation : MKPointAnnotation, distance : Double,
                           sideMovement : Double) {
        var lat = annotation.coordinate.latitude
        var lon = annotation.coordinate.longitude

        UIView.animate(withDuration: 1.2, animations: {
            if var annotation = annotation as? CaseAnnotation {
                while self.goingOutOfBounds(annotation, northOffset: 0.004, southOffset: 0.005, horizontalOffset: 0.001, distance) {
                    annotation.switchDirection()
                }
                switch annotation.direction {
                case .north:
                    lat += distance
                    // add some variation movement with probability function
                    if (Bool.random()) {
                        lon += sideMovement
                    }
                case .south:
                    lat -= distance
                    if (Bool.random()) {
                        lon -= sideMovement
                    }
                case .east:
                    lon -= distance
                    if (Bool.random()) {
                        lat += sideMovement
                    }
                case .west:
                    lon += distance
                    if (Bool.random()) {
                        lat -= sideMovement
                    }
                }
            }
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.coordinate = coord
            self.mapView.addAnnotation(annotation)
            
        })
        
    }
    
    
    /*
     Check if the annotation is about to fly off the screen if it
     keeps going.
     */
    func goingOutOfBounds(_ annotation: CaseAnnotation, northOffset : Double, southOffset : Double, horizontalOffset : Double, _ distance : Double) -> Bool {
        let lat = annotation.coordinate.latitude
        let lon = annotation.coordinate.longitude
        var goingOut = false
        switch annotation.direction {
        case .north:
            if lat + distance >= centralCoord.latitude + northOffset {
                goingOut = true
                
            }
            
        case .south:
            if lat - distance <= centralCoord.latitude - southOffset {
                goingOut = true
            }
            
        case .east:
            if lon - distance <= centralCoord.longitude - horizontalOffset {
                goingOut = true
            }
        
        case .west:
            if lon + distance >= centralCoord.longitude + horizontalOffset {
                goingOut = true
                
            }
            
        }
        
        return goingOut
        
      
    }
    
    /*
     For an annotation that is about to hit the edges of the map,
     this function allows it to complete the residual movement
     to make the views as smooth as possible
     */
    func finishMovement(_ annotation : CaseAnnotation, _ distanceLeft : Double) {
        UIView.animate(withDuration: 1.2, animations: {
            var lat = annotation.coordinate.latitude
            var lon = annotation.coordinate.longitude
            switch annotation.direction {
            case .north:
                lat += distanceLeft
            case .south:
                lat -= distanceLeft
            case .east:
                lon += distanceLeft
            case .west:
                lon -= distanceLeft
            }
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.coordinate = coord
            self.mapView.addAnnotation(annotation)
            
        })
    }
    
    

}

// MARK: MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        let identifier = "CaseAnnotationIdentifier"
        guard let caseAnnotation = annotation as? CaseAnnotation else { return nil }
        var annotationView : MKAnnotationView?

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
            annotationView?.annotation = caseAnnotation
        } else {
            annotationView = MKPinAnnotationView(annotation: caseAnnotation, reuseIdentifier: identifier)
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = getIcon(status: caseAnnotation.status)
            if caseAnnotation.isMe {
                annotationView.isDraggable = true
            } else {
                annotationView.isDraggable = false
            }
        }
        return annotationView
        
    }
    
/*
     TODO: Implement draggable annotations.
     */
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange
//        newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
//        setDragState(newState, false)
//
//    }
//
//    func setDragState(_ newDragState:MKAnnotationView.DragState, _ animated: Bool) {
//
//        setStateHelper(_)
//        switch (newDragState) {
//
//        case MKAnnotationView.DragState.starting:
//            let endPoint = CGPoint(x: 5, y: -20)
//            UIView.animate(withDuration: 0.2, animations: { self.center = endPoint }, completion: { self.dragState = MKAnnotationView.DragState.Dragging })
//
//        default:
//            break
//        }
//    }
    
    func getIcon (status : caseStatus) -> UIImage {
        var icon: UIImage
        switch(status) {
            case .healthy:
                icon = UIImage(systemName:"circle.fill")!.withTintColor(.systemGreen)
                break
            case .infected:
                icon = UIImage(systemName:"plus.circle.fill")!.withTintColor(.systemRed)
                break
            case .recovered:
                icon = UIImage(systemName:"checkmark.circle.fill")!.withTintColor(.systemYellow)
        }
        
        let size = CGSize(width: 20, height: 20)
        let image = UIGraphicsImageRenderer(size:size).image {
            _ in icon.draw(in:CGRect(origin:.zero, size:size))
        }
        
        return image
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if let button = view.rightCalloutAccessoryView as? UIButton {
            if let caseAnnotation = view.annotation as? CaseAnnotation {
                button.setTitle((caseAnnotation.status == caseStatus.healthy ? "Healthy" : "nope"), for: .normal)
            }
        }
    }

}






