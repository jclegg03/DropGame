//
//  GameScene.swift
//  DropGame
//
//  Created by Clegg, Jay on 11/15/21.
//

import Foundation
import SpriteKit
import SwiftUI

class GameScene : SKScene, SKPhysicsContactDelegate
{
    //MARK: Data members
    private let scoreNode : SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
    private var score : Int = -0
    {
        didSet
        {
            scoreNode.text = "Score: \(score)"
        }
    }
    private var colorMask : Int = 0b0000
    
    let texture = SKTexture(imageNamed: "NewRevan")
    
    var gameBlocks : [SKSpriteNode] = []
    
    
    //MARK: - SKScene methods
    override func didMove(to view : SKView) -> Void
    {
        physicsBody = SKPhysicsBody(edgeLoopFrom : frame)
        physicsWorld.contactDelegate = self
        
        //Add the score label
        scoreNode.zPosition = 2
        scoreNode.position.x = 120
        scoreNode.position.y = 385
        scoreNode.fontSize = 20
        scoreNode.fontName = "Times New Roman"
        addChild(scoreNode)
        score = 0 //Forces a call to the didSet observer
        
        //add audio
        let backgroundMusic = SKAudioNode(fileNamed: "music")
        backgroundMusic.name = "music"
        addChild(backgroundMusic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) -> Void
    {
        guard let touch = touches.first
        else { return }
        let currentColor = assignColorAndBitmask()
        let width = Int(arc4random() % 50) + 3
        let height = Int(arc4random() % 50) + 3
        let location = touch.location(in: self)
    
        let node : SKSpriteNode
       
        
        node = SKSpriteNode(texture: texture, color: currentColor, size: CGSize(width: width, height: height))
        node.colorBlendFactor = 1.0
        node.position = location
        
        node.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: width, height: height))
        
        node.physicsBody?.contactTestBitMask = UInt32(colorMask)
        
        addChild(node)
    }
    
    //MARK: - Custom methods
    private func assignColorAndBitmask() -> UIColor
    {
        let colors : [UIColor] = [.purple, .red, .blue, .green, .darkGray, .cyan, .brown, .yellow, .orange, .black]
        let randomIndex = Int(arc4random()) % colors.count
        
        colorMask = randomIndex + 1
        
        return colors[randomIndex]
    }
    
    private func annihilate(deadNode : SKNode) -> Void
    {
        score += Int(deadNode.frame.size.height * deadNode.frame.size.width)
        explosionEffect(at: CGPoint(x: deadNode.position.x, y: deadNode.position.y))
        updateSound()
        deadNode.removeFromParent()
    }
    
    private func collisionBetween(_ nodeOne : SKNode, and nodeTwo : SKNode) -> Void
    {
        if(nodeOne.physicsBody?.contactTestBitMask == nodeTwo.physicsBody?.contactTestBitMask)
        {
            annihilate(deadNode: nodeOne)
            annihilate(deadNode: nodeTwo)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) -> Void
    {
        guard let first = contact.bodyA.node else { return }
        guard let second = contact.bodyB.node else { return }
        
        collisionBetween(first, and: second)
    }
    
    public func getScore() -> Int
    {
        return self.score
    }
    
    private func explosionEffect(at location: CGPoint) -> Void
    {
        if let explosion = SKEmitterNode(fileNamed: "SparkParticle")
        {
            explosion.position = location
            addChild(explosion)
            let waitTime = SKAction.wait(forDuration: 5)
            let removeExplosion = SKAction.removeFromParent()
            let explosiveSequence = SKAction.sequence([waitTime, removeExplosion])
            
            let effectSound = SKAction.playSoundFileNamed("drop bass", waitForCompletion: false)
            run(effectSound)
            
            explosion.run(explosiveSequence)
        }
    }
    private func updateSound() -> Void
    {
        if let sound = childNode(withName: "music")
        {
            let speedUp = SKAction.changePlaybackRate(by: 2, duration: 1000)
            sound.run(speedUp)
        }
    }
    
    private func loadBlocks() -> Void
    {
        for _ in 1 ... 100
        {
            let currentColor = assignColorAndBitmask()
            let width = Int(arc4random()) % 50 + 1
            let height = Int(arc4random()) % 50 + 1
            let block = SKSpriteNode(color: currentColor, size: CGSize(width: width, height: height))
            block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height))
            block.physicsBody?.contactTestBitMask = UInt32(colorMask)
            
            let bounciness = CGFloat(Double.random(in: 0.00 ... 0.999))
            block.physicsBody?.restitution = bounciness
            gameBlocks.append(block)
        }
    }
}
