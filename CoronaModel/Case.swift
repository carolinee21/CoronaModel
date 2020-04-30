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
    var status : caseStatus = .healthy
    // Keep track of how many people I infect 
    var infectedByMe : Int
    
    override init(texture: SKTexture!, color: SKColor!, size: CGSize) {
        self.infectedByMe = 0
        super.init(texture: texture, color: color, size: size)
        /*
            This physicsBody stuff defines how the sprites interact with other
            sprites in the mapScene.
         */
        super.physicsBody = SKPhysicsBody(rectangleOf: size)
        super.physicsBody!.isDynamic = true
        super.physicsBody!.collisionBitMask = 2 // should bounce off of edges but not other people
        super.physicsBody!.contactTestBitMask = 1 // contacts other cases
        super.physicsBody!.categoryBitMask = 1 // is personally of "category" case
    }
    
    convenience init(at position: CGPoint, status: caseStatus) {
        let radius = 11
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
        self.status = status
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.status = .healthy
        self.infectedByMe = 0
        super.init(coder: aDecoder)
    }
    
    func didContact (withCase otherCase : Case) -> Bool {
        
        let otherStatus = otherCase.status
        if otherStatus == .infected && self.status == .healthy {
            self.status = .infected
            super.color = .red
            otherCase.infectedByMe += 1
            return true
        }
        return false
    }
    
    
}
