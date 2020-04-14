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
    @IBOutlet var fatalitiesLabel: UILabel!
    @IBOutlet var daysLabel: UILabel!
    var annotations : [MKAnnotation] = []
    let centralCoord = CLLocationCoordinate2D(latitude: 39.952085, longitude: -75.194928)
    let regionRadius: CLLocationDistance = 10000 // meters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getAnnotations()
        self.mapView.addAnnotations(self.annotations)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnPhiladelphia()
    }
    
    func centerMapOnPhiladelphia() {
        let region = MKCoordinateRegion(center: centralCoord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func getAnnotations() {
        let radiusLatLon = 0.05
        let x = 4
        for i in (-x)..<x+1 {
            for j in (-x)..<x+1 {
                let lat = centralCoord.latitude + (radiusLatLon)*Double(i)/Double(x)
                let lon = centralCoord.longitude + (radiusLatLon)*Double(j)/Double(x)
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                // TODO: Randomizing initial cases (placeholder)
                let currCase : CaseAnnotation = CaseAnnotation(coordinate: coord, currentStatus: caseStatus.allCases.randomElement()!)
                self.annotations.append(currCase)
            }
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
            case .dead:
                icon = UIImage(systemName:"xmark.circle.fill")!.withTintColor(.black)
                break
        case .recovered:
                icon = UIImage(systemName:"checkmark.circle.fill")!.withTintColor(.systemYellow)
        }
        
        let size = CGSize(width: 30, height: 30)
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


