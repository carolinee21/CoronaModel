//
//  CaseAnnotation.swift
//  CoronaModel
//
//  Created by Caroline on 4/14/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import MapKit

enum caseStatus : CaseIterable {
    case healthy
    case infected
    case recovered
}

class CaseAnnotation: MKPointAnnotation {
    var status: caseStatus
    
    init(coordinate: CLLocationCoordinate2D, currentStatus : caseStatus) {
        self.status = currentStatus
        super.init()
        self.coordinate = coordinate
    }
}

