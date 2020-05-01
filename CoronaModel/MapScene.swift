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
    func updateCount(healthy: Int, infected: Int, recovered: Int)
    func updateR0(rNaught: Double)
}

class MapScene : SKScene, SKPhysicsContactDelegate {
    var countInfected : Int = 0
    var countHealthy : Int = 0
    var countRecovered : Int = 0
    // User input as passed in from the root LaunchViewController
    var socialDistance : Int = 0
    var initialCases : Int = 0
    var initialSick : Int = 0
    var RNought : Double = 0
    weak var updateCountDelegate : UpdateCountDelegate? = nil
    let timer = CountdownLabel()


    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.collisionBitMask = 2
        physicsBody?.categoryBitMask = 2
        physicsWorld.gravity = .zero
        physicsBody?.friction = 0
        physicsWorld.contactDelegate = self
        getInitialCases(numHealthy: initialCases - initialSick, numInfected: initialSick)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in self.children {
            if let node = node as? Case {
                var didRecover = node.update()
                if didRecover {
                    self.countRecovered += 1
                    self.countInfected -= 1
                }
            }
        }
        updateR0()
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
        updateCountDelegate?.updateCount(healthy: countHealthy, infected: countInfected, recovered: countRecovered)

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
    /*
     @Caroline: The user passes in the social distance slider, and this is
     the variable @socialDistance which determines the distances of the nodes and
     their speed. Also kinda arbitrary feel free to mess w
     */
    func getRandomActionSequence() -> SKAction {
        // as socialDistance goes up, the speed at which nodes travel gets slower
        let speed : Double = Double.random(in: 1.5..<2) + Double(socialDistance / 30)
        // as socialDistance goes up, total distance traveled by nodes goes down
        let dist = 200 - (2 * socialDistance)
        
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
        curr.name = "case"

        let action = getRandomActionSequence()
        curr.run(action)
        
        addChild(curr)
    }
    /*
        This function is a sort of listener for contacts between cases.
        Right now it is configured using SKPhysics things for each sprite so
        that only "case" nodes will contact each other.
     
     @Caroline: I want to keep track of R0, the amount of people a single person
     infects. It's supposedly like the most telling stat for infectious diseases.
     Anyway the function updateRO() just iterates through the nodes and computes the
     R0 by summing up, for each node, how many people that node infected and then
     dividing out by the number of total nodes. I ended up dividing out the number
     of totalNodes by 2, I think it's just harder to map b/c we have a very finite amount
     of nodes in our simulation.
     
     Ideally we'd compute R0 once, after the simulation is over. But
     since we're not yet sure abt when the simulation will "finish" I just
     put it in this func and it computes a bunch of times as it goes.
     
     Not sure a more efficient way to do this rn.
     */
    func didBegin(_ contact: SKPhysicsContact) {
        guard let caseA = contact.bodyA.node as? Case else { return }
        guard let caseB = contact.bodyB.node as? Case else { return }
        
        let bInfectedA : Bool = caseA.didContact(withCase: caseB)
        let aInfectedB : Bool = caseB.didContact(withCase: caseA)
        
        if bInfectedA || aInfectedB {
            countInfected += 1
            countHealthy -= 1
            updateCountDelegate?.updateCount(healthy: countHealthy, infected: countInfected, recovered: countRecovered)
        }
        

    }
    
    func updateR0() {
        var totalInfectedCases = 0
        var infectedBy = 0
        //print(String(self.children.count) + " is the count")
        for node in self.children {
            if let node = node as? Case {
                //print("Ive infected " + String(node.infectedByMe))
                if (node.status == .infected || node.status == .recovered) {
                    totalInfectedCases += 1
                }
                infectedBy += node.infectedByMe
            }
        }
        //print("In total we've infected " + String(infectedBy))
        //print("There are " + String(totalCases) + " total Cases")
        RNought = Double(infectedBy) / Double(totalInfectedCases / 2)
        updateCountDelegate?.updateR0(rNaught: RNought)
        //print(RNought)
    }
    

    
}
