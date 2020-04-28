//
//  MapScene.swift
//  CoronaModel
//
//  Created by Caroline on 4/27/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import Foundation
import SpriteKit

protocol UpdateCountDelegate : class {
    func updateCount(healthy: Int, infected: Int)
}

class MapScene : SKScene, SKPhysicsContactDelegate {
    let ballRadius: CGFloat = 15
    var countInfected : Int = 0
    var countHealthy : Int = 0
    weak var updateCountDelegate : UpdateCountDelegate? = nil


    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.collisionBitMask = 2
        physicsBody?.categoryBitMask = 2
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        getInitialCases(numHealthy: 98, numInfected: 2)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // I think this is where we could handle user input/touch, if we want
    }
    
    func getInitialCases(numHealthy: Int, numInfected: Int) {
        for _ in 0..<numHealthy {
            addRandomCase(status: .healthy)
        }
        for _ in 0..<numInfected {
            addRandomCase(status: .infected)
        }
        updateCountDelegate?.updateCount(healthy: countHealthy, infected: countInfected)
    }
    
    /*
     @JJ: This method is pretty weird lol basically there's no good way
     to repeatedly generate new random movement for each Sprite while
     still allowing it to function in the background. So basically, for
     each node, I made a sequence of random events that it does on a loop
     forever. It essentially does three random moves, then reverses those moves
     in the original order (i.e. first follows vectors A, B, C, then -A, -B, -C).
     Feel free to play around with it - I just thought this semi-randomness
     was enough to represent random movement visually
     */
    func getRandomActionSequence() -> SKAction {
        let speed : Double = Double.random(in: 2..<4)
        let dist = 100
        
        var sequence : [SKAction]  = []
        var sequenceBack : [SKAction]  = []
        for _ in 0..<3 {
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

    /*
     This function instantiates one random case on the map with the given status
     */
    func addRandomCase(status : caseStatus) {
        // Assuming we won't be instantiating nodes as "recovered"
        if status == .infected {
            countInfected += 1
        } else {
            countHealthy += 1
        }
        let xVariance : CGFloat = frame.width/2
        let yVariance : CGFloat = frame.height/2
        let xInfected = frame.midX + CGFloat.random(in: -xVariance ..< xVariance)
        let yInfected = frame.midY + CGFloat.random(in: -yVariance ..< yVariance)
        let position = CGPoint(x: xInfected, y: yInfected)
        
        let curr : Case = Case(at : position, status: status)

        let action = getRandomActionSequence()
        curr.run(action)
        
        addChild(curr)
    }
    /*
        This function is a sort of listener for contacts between cases.
        Right now it is configured using SKPhysics things for each sprite so
        that only "case" nodes will contact each other.
     */
    func didBegin(_ contact: SKPhysicsContact) {
        guard let caseA = contact.bodyA.node as? Case else { return }
        guard let caseB = contact.bodyB.node as? Case else { return }
        
        let bInfectedA : Bool = caseA.didContact(withCase: caseB)
        let aInfectedB : Bool = caseB.didContact(withCase: caseA)
        
        if bInfectedA || aInfectedB {
            countInfected += 1
            countHealthy -= 1
            updateCountDelegate?.updateCount(healthy: countHealthy, infected: countInfected)
        }

    }
    
}
