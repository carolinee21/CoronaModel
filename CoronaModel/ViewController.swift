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

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var healthyLabel: UILabel!
    @IBOutlet var infectedLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    var healthyCount = 0
    var infectedCount = 0
    var recoveredCount = 0
    var annotations : [MKAnnotation] = []
    let centralCoord = CLLocationCoordinate2D(latitude: 39.950908, longitude: -75.196032)
    let regionRadius: CLLocationDistance = 1000 // meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        runSimulation(numCases: 50, numSick: 1)
        
    }
    
    /*
     When the user taps the simulate button,
     we link to the storyboard to run a timestep
     of the simulation
     */
    @IBAction func tapSimulate(_ sender: UIButton) {
        self.mapView.removeAnnotations(self.annotations)
        computeDistances()
        // Redraw the cases to account for
        // any new infections that
        // occurred in previous timestep
        self.mapView.addAnnotations(self.annotations)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnPenn()
        
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
                let currCase : CaseAnnotation = CaseAnnotation(coordinate: coord, currentStatus: caseStatus.healthy)
                self.annotations.append(currCase)
                updateHealthyCount(by: 1, increase: true)
                if self.annotations.count == numCases {
                    break outerloop
                }
            }
        }
        
    }
    
    
    func runSimulation(numCases : Int, numSick : Int) {
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
     
     TODO: Because we're implementing on a real map background,
     we have to make the transmission realistic. For example,
     even if we went with the 2D Grid approach but put it on a big map
     of Philadelphia, it wouldn't make much sense if someone in Center City
     had a neighbor that was standing at the Button at Penn but somehow because
     they were neighbors in the 2D grid, overcame the miles between them
     and managed to transmit the virus. Meaning
     you have to be pretty close to transmit the disease, and because we're
     using a Map background that kind of has real implications for the project.
     
     It seems like we're going to have to zoom in on the map pretty
     close if we want to capture the true tranmission and stuff. Def doable.
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
    
    func updateHealthyCount(by: Int, increase : Bool) {
        healthyCount = increase ? healthyCount + by : healthyCount - by
        healthyLabel.text = "Healthy: \(healthyCount)"
    }
    
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
            let currCase : CaseAnnotation = CaseAnnotation(coordinate: coord, currentStatus: caseStatus.infected)
            self.annotations.append(currCase)
            updateInfectedCount(by: 1, increase: true)
        }
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
        }
        return annotationView
        
    }
    
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
        
        let size = CGSize(width: 25, height: 25)
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


