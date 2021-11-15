//
//  GameScene.swift
//  DropGame
//
//  Created by Clegg, Jay on 11/15/21.
//

import Foundation
import SpriteKit

class GameScene : SKScene
{
    override func didMove(to view : SKView) -> Void
    {
        physicsBody = SKPhysicsBody(edgeLoopFrom : frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) -> Void
    {
        guard let touch = touches.first
        else { return }
        let currentColor = UIColor.purple
        let width = Int(arc4random() % 50)
        let height = Int(arc4random() % 50)
        let location = touch.location(in: self)
    
        let node : SKSpriteNode
        node = SKSpriteNode(color: currentColor, size: CGSize(width: width, height: height))
        node.position = location
    
        addChild(node)
    }
}
