//
//  GameMenu.swift
//  Changing Lanes Challenge
//
//  Created by Andy Gray on 17/08/2018.
//  Copyright © 2018 Andy Gray. All rights reserved.
//

import Foundation
import SpriteKit

class GameMenu: SKScene
{
   
    var startGame = SKLabelNode()
    
    override func didMove(to view: SKView)
    {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            
            let touchLocation = touch.location(in: self)
            
            if atPoint(touchLocation).name == "startGame"
            {
                
                let gameScene = SKScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                view?.presentScene(gameScene!, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
                
            }
        }
    }
    
}
