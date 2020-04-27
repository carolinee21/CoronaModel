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
    let ballRadius: CGFloat = 20
    
    override func didMove(to view: SKView) {
        print("----")
//        let label = SKLabelNode()
//        label.text = "Hello World!"
//        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//        label.fontSize = 30
//        label.fontColor = SKColor.red
//        self.addChild(label)
        
//        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
//        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
//        topSky.position = CGPoint(x: frame.midX, y: frame.height)
//        addChild(topSky)
//        topSky.zPosition = -40
        
        
        let redBall = SKShapeNode(circleOfRadius: ballRadius)
        redBall.fillColor = .red
        redBall.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(redBall)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}
