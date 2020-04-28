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
        
        let redBall = SKShapeNode(circleOfRadius: ballRadius)
        redBall.fillColor = .red
        redBall.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(redBall)
        getInitialCases(5)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    
    func getInitialCases(_ numCases: Int) {
        let xVariance : CGFloat = 400
        let yVariance : CGFloat = 600
        let x = 3
        outerloop: for _ in (-x-2)..<x+3 {
            for _ in (-x)..<x+1 {
                let x = frame.midX + CGFloat.random(in: -xVariance ..< xVariance)
                let y = frame.midY + CGFloat.random(in: -yVariance ..< yVariance)
                
                //updateHealthyCount(by: 1, increase: true)
                
                //let curr : Case = Case(color: SKColor.green)
                let curr = SKShapeNode(circleOfRadius: ballRadius)
                curr.fillColor = .blue
                curr.position = CGPoint(x: x, y: y)
                
                // cases can collide with each other; have same bit mask
                curr.physicsBody?.collisionBitMask = 1
                print("eep")
                addChild(curr)
//                if self.annotations.count == numCases {
//                    break outerloop
//                }
            }
        }
    }
}
