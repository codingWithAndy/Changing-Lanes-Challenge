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
    var bestScore = SKLabelNode()
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView)
    {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        startGame = self.childNode(withName: "startGame") as! SKLabelNode
        bestScore = self.childNode(withName: "bestScore") as! SKLabelNode
        bestScore.text = "Highest Score: \(gameSettings.highScore)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            
            let touchLocation = touch.location(in: self)
            
            if atPoint(touchLocation).name == "startGame"
            {
                
                let gameScene = SKScene(fileNamed: "GameScene")
                //gameScene?.scaleMode = .resizeFill
                gameScene?.size.height = (self.view?.frame.height)!
                gameScene?.size.width = (self.view?.frame.width)!
                view?.presentScene(gameScene!, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(2)))
                
            }
        }
    }
    
}
