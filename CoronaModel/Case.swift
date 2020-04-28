//
//  Case.swift
//  CoronaModel
//
//  Created by Caroline on 4/28/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit
import SpriteKit



class Case: SKSpriteNode {
    

    override init(texture: SKTexture!, color: SKColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        super.physicsBody = SKPhysicsBody(circleOfRadius: size.width)
        
    }

    convenience init(color: SKColor) {
        let radius = 20
        let size = CGSize(width: radius, height: radius)
        
        self.init(texture:nil, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        // Decoding length here would be nice...
        super.init(coder: aDecoder)
    }
}
