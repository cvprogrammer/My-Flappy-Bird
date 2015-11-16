//
//  GameScene.swift
//  Flapy bird Bonako
//
//  Created by Robertson Brito on 7/13/15.
//  Copyright (c) 2015 Ihaba Bonako. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var pipesMoveAndRemove = SKAction()
    let pipeGap = 150
    
    override func didMoveToView(view: SKView) {
        
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0);
        //Bird
        var birdTexture = SKTexture(imageNamed: "Bird")
        birdTexture.filteringMode = SKTextureFilteringMode.Nearest
        bird = SKSpriteNode(texture: birdTexture)
        bird.setScale(0.5)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y: self.frame.size.height * 0.6)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2.0)
        bird.physicsBody!.dynamic = true
        bird.physicsBody!.allowsRotation = false
        
        
        
        self.addChild(bird)
        
        //Ground
        var groundTexture = SKTexture(imageNamed: "Flappy-Ground")
        var sprite = SKSpriteNode(texture: groundTexture)
        sprite.setScale(2.0)
        sprite.position = CGPointMake(self.size.width/2, sprite.size.height/2)
        self.addChild(sprite)
        
        
        var ground = SKNode()
        ground.position = CGPointMake(0, groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, groundTexture.size().height * 2.0))
        ground.physicsBody?.dynamic = false
        self.addChild(ground)
        
        
        // Pipes
        // Create Pipes
        
        pipeUpTexture = SKTexture(imageNamed: "pipeUp")
        pipeDownTexture = SKTexture(imageNamed: "pipeDown")
        
        //Actions
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        pipesMoveAndRemove = SKAction.sequence([movePipes,removePipes])
        
        //spawn Pipes
        
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn,delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        

        
    }
    
    func spawnPipes(){
    let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        pipePair.zPosition = -10
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)

        pipeDown.physicsBody?.dynamic = false
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipePair.addChild(pipeUp)
        
        
        pipePair.runAction(pipesMoveAndRemove)
        self.addChild(pipePair)
    
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            
            let location = touch.locationInNode(self)
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0.2, 25))
            
           
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
