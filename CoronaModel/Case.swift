//
//  Case.swift
//  CoronaModel
//
//  Created by Caroline on 4/28/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit
import SpriteKit


enum caseStatus : CaseIterable {
    case healthy
    case infected
    case recovered
}

class Case: SKSpriteNode {
    

    override init(texture: SKTexture!, color: SKColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        super.physicsBody = SKPhysicsBody(circleOfRadius: size.width)
        super.physicsBody?.isDynamic = false
        super.physicsBody?.collisionBitMask = 1
        
    }

    convenience init(at position: CGPoint, status: caseStatus) {
        let radius = 20
        let size = CGSize(width: radius, height: radius)
        
        var color: SKColor
        switch(status) {
            case .healthy:
                color = .green
                break
            case .infected:
                color = .red
                break
            case .recovered:
                color = .yellow
        }
        
        self.init(texture:nil, color: color, size: size)
        super.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
}
