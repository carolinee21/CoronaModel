//
//  CountdownLabel.swift
//  CoronaModel
//
//  Created by Jonathan Julius Kampf on 4/29/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import Foundation
import SpriteKit

/*
 A timer if we end up needing one 
 */

class CountdownLabel : SKLabelNode {
    var endsAt : Date!
    
    func update() {
        let timeLeft = Int(remainingTime())
        text = String(timeLeft)
    }
    
    func startWithDuration(duration: TimeInterval) {
        let timeNow = Date()
        endsAt = timeNow.addingTimeInterval(duration)
        
    }
    
    func hasFinished() -> Bool {
        return remainingTime() == 0
    }
    
    private func remainingTime() -> TimeInterval {
        let rightNow = Date()
        let remainingSeconds = endsAt.timeIntervalSince(rightNow)
        return max(remainingSeconds, 0)
    }
}
