//
//  GameScene.swift
//  Changing Lanes Challenge
//
//  Created by Andy Gray on 17/08/2018.
//  Copyright © 2018 Andy Gray. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // Creating the palyer cars as variables
    var leftCar = SKSpriteNode()
    var rightCar = SKSpriteNode()
    
    
    // setting up boolean values to assign to sprites to know what car sprites can move
    var canMove = false
    var leftCarToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    
    // setting up center point of screen
    var centerPoint: CGFloat!
    
    var score = 0
    
    // Setting up min and max distance left car can move
    let leftCarMinimumX: CGFloat = -280
    let leftCarMaximumX: CGFloat = -100
    
    // Setting up min and max distance right car can move
    let rightMinimumX: CGFloat = 100
    let rightMaximumX: CGFloat = 280
    
    var countDown = 1
    var stopEverything = true
    
    var scoreText = SKLabelNode()
    
    
    // Setting up the high score and linking to the settings class
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView)
    {
       
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        
        physicsWorld.contactDelegate = self
        
        createRoadStrip()
        
        // calls on create road strip on a timer to make multiple line shapes in scene.
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        
        let deadTime = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: deadTime) {
            
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
            
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        //Func is called in every screen refresh (60fps as default)
        
        if canMove
        {
            
            move(leftSide: leftCarToMoveLeft)
            moveRightCar(rightSide: rightCarToMoveRight)
            
        }
        
        showRoadStrip()
        //removeItems()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        
        // Checking for collisions
        if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar"
        {
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        }
        else
        {
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
        }
        
        // Removes sprite if collision occurs
        firstBody.node?.removeFromParent()
        
        afterCollision()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        // Main logic of the game
        for touch in touches
        {
            
            // find out where user touches the screen
            let touchLocation = touch.location(in: self)
            
            if touchLocation.x > centerPoint
            {
                
                if rightCarAtLeft
                {
                    // changing cars position in the lanes
                    rightCarAtLeft = false
                    rightCarToMoveRight = true
                    
                }
                else
                {
                    
                    // changing cars position in the lanes
                    rightCarAtLeft = true
                    rightCarToMoveRight = false
                    
                }
                
            }
            else
            {
                
                if leftCarAtRight
                {
                    // changing cars position in the lanes
                    leftCarAtRight = false
                    leftCarToMoveLeft = true
                    
                }
                else
                {
                    
                    // changing cars position in the lanes
                    leftCarAtRight = true
                    leftCarToMoveLeft = false
                    
                }
                
            }
            
            canMove = true
            
        }
    
    }
    
    func setUp()
    {
        
        // Adding Cars to the scene
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        
        // Setting up Center point of the screen
        centerPoint = self.frame.size.width / self.frame.size.height
        
        //Setting up Physics to the sprites
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        rightCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER_1
        rightCar.physicsBody?.collisionBitMask = 0
        
        let scoreBackGround = SKShapeNode(rect: CGRect(x: -self.size.width / 2 + 70, y: self.size.height / 2, width: 180, height: 80), cornerRadius: 20)
        
        scoreBackGround.zPosition = 4
        scoreBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        
        addChild(scoreBackGround)
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width / 2 + 160, y: self.size.height / 2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        
        addChild(scoreText)
        
    }
    
    @objc func createRoadStrip()
    {
        
        // Creating the Left Road lines
        let leftRoadStrip = SKShapeNode(rectOf:CGSize(width: 10, height: 40))
        
        //Adding attributes to the left road strip.
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        
        // Adding left road strip to the scene
        addChild(leftRoadStrip)
        
        // Creating the Right Road lines
        let rightRoadStrip = SKShapeNode(rectOf:CGSize(width: 10, height: 40))
        
        //Adding attributes to the left road strip.
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        
        // Adding right road strip to the scene
        addChild(rightRoadStrip)

    }
    
    func showRoadStrip()
    {
        
        enumerateChildNodes(withName: "leftRoadStrip", using: {(roadStrip, stop) in
            
            // adds left road strip to the collection.
            let strip = roadStrip as! SKShapeNode
            
            // will make the road lines go down the screen
            strip.position.y -= 30
            
        })
        
        enumerateChildNodes(withName: "rightRoadStrip", using: {(roadStrip, stop) in
            
            // adds right road strip to the collection.
            let strip = roadStrip as! SKShapeNode
            
            // will make the road lines go down the screen
            strip.position.y -= 30
            
        })
        
        enumerateChildNodes(withName: "orangeCar", using: {(leftCar, stop) in
            
            // adds Orange car to left side.
            let strip = leftCar as! SKSpriteNode
            
            // will make the road lines go down the screen
            strip.position.y -= 15
            
        })
        
        enumerateChildNodes(withName: "greenCar", using: {(rightCar, stop) in
            
            // adds Green car to left side.
            let strip = rightCar as! SKSpriteNode
            
            // will make the road lines go down the screen
            strip.position.y -= 15
            
        })
        
    }
    
    @objc func removeItems()
    {
        
        // creating a loop to check all sprite childs on the scene
        for child in children
        {
            
            // checking if the sprite position is off the screen
            if child.position.y < -self.size.height - 100
            {
                
                // will remove sprite from scene (improves optimsation)
                child.removeFromParent()
                
            }
        }
        
    }
    
    func move(leftSide:Bool)
    {
        if leftSide
        {
            
            // Moves car accross the screen
            leftCar.position.x -= 20
            
            if leftCar.position.x < leftCarMinimumX
            {
                
                leftCar.position.x = leftCarMinimumX
                
            }
            
        }
        else
        {
            
            // Moves car accross the screen
            leftCar.position.x += 20
            
            if leftCar.position.x > leftCarMaximumX
            {
                
                leftCar.position.x = leftCarMaximumX
                
            }
            
        }
    }
    
    func moveRightCar(rightSide: Bool)
    {
        
        if rightSide
        {
            
            rightCar.position.x += 20
            if rightCar.position.x > rightMaximumX
            {
                
                rightCar.position.x = rightMaximumX
                
            }
            
        }
        else
        {
            rightCar.position.x -= 20
            if rightCar.position.x < rightMinimumX
            {
                
                rightCar.position.x = rightMinimumX
                
            }
        }
        
    }
    
    @objc func leftTraffic()
    {
        
        if !stopEverything
        {
            let leftTrafficItem: SKSpriteNode!
            let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
            
            switch Int(randomNumber) {
            case 1...4:
                leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
                leftTrafficItem.name = "orangeCar"
                break
            case 5...8:
                leftTrafficItem = SKSpriteNode(imageNamed: "greenCar")
                leftTrafficItem.name = "greenCar"
                break
            default:
                leftTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
                leftTrafficItem.name = "orangeCar"
            }
            
            leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            leftTrafficItem.zPosition = 10
            
            let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
            switch Int(randomNum) {
            case 1...5:
                leftTrafficItem.position.x = -280
                break
            case 5...10:
                leftTrafficItem.position.x = -100
                break
            default:
                leftTrafficItem.position.x = -280
            }
            
            leftTrafficItem.position.y = 700
            leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height / 2)
            leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
            leftTrafficItem.physicsBody?.collisionBitMask = 0
            leftTrafficItem.physicsBody?.affectedByGravity = false
            
            addChild(leftTrafficItem)
        
        }
    }
    
    @objc func rightTraffic()
    {
        if !stopEverything
        {
            
            let rightTrafficItem: SKSpriteNode!
            let randomNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
            
            switch Int(randomNumber) {
            case 1...4:
                rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
                rightTrafficItem.name = "orangeCar"
                break
            case 5...8:
                rightTrafficItem = SKSpriteNode(imageNamed: "greenCar")
                rightTrafficItem.name = "greenCar"
                break
            default:
                rightTrafficItem = SKSpriteNode(imageNamed: "orangeCar")
                rightTrafficItem.name = "orangeCar"
            }
            
            rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            rightTrafficItem.zPosition = 10
            
            let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
            switch Int(randomNum) {
            case 1...5:
                rightTrafficItem.position.x = 280
                break
            case 5...10:
                rightTrafficItem.position.x = 100
                break
            default:
                rightTrafficItem.position.x = 280
            }
            
            rightTrafficItem.position.y = 700
            rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height / 2)
            rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER_1
            rightTrafficItem.physicsBody?.collisionBitMask = 0
            rightTrafficItem.physicsBody?.affectedByGravity = false
            
            addChild(rightTrafficItem)
        }
        
    }
    
    func afterCollision()
    {
        
        
        // Updating the high score value
        if gameSettings.highScore < score
        {
            gameSettings.highScore = score
        }
        
        // Plays Google Ad
        
        
        
        
        // Returns to main menu
        let menuScene = SKScene(fileNamed: "GameMenu")
        menuScene?.scaleMode = .aspectFill
        view?.presentScene(menuScene!, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
        
        let controller = self.view?.window?.rootViewController as! GameViewController
        
        controller.playAd()
        
    }
    
    @objc func startCountDown()
    {
        
        if countDown > 0
        {
            if countDown < 4
            {
                
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenirNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.position = CGPoint(x: 0, y: 0)
                countDownLabel.zPosition = 300
                countDownLabel.name = "cLabel"
                countDownLabel.horizontalAlignmentMode = .center
                
                addChild(countDownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                    countDownLabel.removeFromParent()
                })
                
            }
            
            countDown += 1
            
            if countDown == 4
            {
                
                self.stopEverything = false
                
            }
            
        }
        
    }
    
    @objc func increaseScore()
    {
        
        if !stopEverything
        {
            
            score += 1
            scoreText.text = String(score)
        }
    }
    
}
