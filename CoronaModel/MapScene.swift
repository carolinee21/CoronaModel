//
//  MapScene.swift
//  CoronaModel
//
//  Created by Caroline on 4/27/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import Foundation
import SpriteKit

class MapScene : SKScene {
    let ballRadius: CGFloat = 15
    
    override func didMove(to view: SKView) {
        
        getInitialCases(5)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    
    func getInitialCases(_ numCases: Int) {
        let x = 3
        outerloop: for _ in (-x-2)..<x+3 {
            for _ in (-x)..<x+1 {
                addRandomCase(status: .healthy)
            }
        }
        addRandomCase(status: .infected)
    }
    
    
    func getRandomActionSequence() -> SKAction {
        let speed : Double = Double.random(in: 1..<4)
        let dist = 80
        
        var sequence : [SKAction]  = []
        var sequenceBack : [SKAction]  = []
        for _ in 0..<2 {
            let xRand = Int.random(in: -dist..<dist)
            let yRand = Int.random(in: -dist..<dist)
            let direction : CGVector = CGVector(dx: xRand, dy: yRand)
            let directionBack : CGVector = CGVector(dx: -xRand, dy: -yRand)
            let move = SKAction.move(by: direction, duration: speed)
            let moveBack = SKAction.move(by: directionBack, duration: speed)
            sequence.append(move)
            sequenceBack.append(moveBack)
        }

        let allActions = sequence + sequenceBack
        let actionSequence = SKAction.sequence(allActions)
        let repeatedSequence = SKAction.repeatForever(actionSequence)
        return repeatedSequence
    }

    func addRandomCase(status : caseStatus) {
        let xVariance : CGFloat = 400
        let yVariance : CGFloat = 600
        
        let xInfected = frame.midX + CGFloat.random(in: -xVariance ..< xVariance)
        let yInfected = frame.midY + CGFloat.random(in: -yVariance ..< yVariance)
        let position = CGPoint(x: xInfected, y: yInfected)
        
        let curr : Case = Case(at : position, status: status)
        let action = getRandomActionSequence()
        curr.run(action)
        addChild(curr)
        
    }
    
}


