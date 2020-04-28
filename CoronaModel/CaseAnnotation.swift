//
//  CaseAnnotation.swift
//  CoronaModel
//
//  Created by Caroline on 4/14/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import MapKit


enum caseDirection : CaseIterable {
    case north, south, east, west
}
//enum caseStatus : CaseIterable {
//    case healthy
//    case infected
//    case recovered
//}

class CaseAnnotation: MKPointAnnotation {
    var status: caseStatus
    var direction : caseDirection
    // is this the main character in the simulation?
    var isMe: Bool
    
    init(coordinate: CLLocationCoordinate2D, currentStatus : caseStatus, isMe: Bool,
         direction : caseDirection) {
        self.status = currentStatus
        self.direction = direction
        self.isMe = isMe
        super.init()
        self.coordinate = coordinate
    
    }
    
    /*
     Changes the direction of the annotation
     to a randomly selected new one 
     */
    func switchDirection() {
        let direction = self.direction
        while (self.direction == direction) {
            self.direction = caseDirection.allCases.randomElement()!
        }
    }
    
}

