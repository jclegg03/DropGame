//
//  EndGameScene.swift
//  DropGame
//
//  Created by Clegg, Jay on 11/19/21.
//

import Foundation
import SpriteKit

class EndGameScene : SKScene
{
    var gameScore : Int = 0
    
    override public func didMove(to view : SKView) -> Void
    {
        backgroundColor = .blue
        
        let scoreNode : SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        let endNode : SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        let restartNode : SKLabelNode = SKLabelNode(fontNamed: "Copperplate-Bold")
        
        scoreNode.position.x = frame.midX
        scoreNode.position.y = frame.midY + 30
        scoreNode.text = "Score: \(gameScore)"
        
        endNode.position.x = frame.midX
        endNode.position.y = frame.midY + 10
        endNode.text = "Game Over!"
        
        restartNode.position.x = frame.midX
        restartNode.position.y = frame.midY - 10
        restartNode.text = "Pinch to restart"
        
        addChild(scoreNode)
        addChild(endNode)
        addChild(restartNode)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.view?.addGestureRecognizer(pinchRecognizer)
    }
    
    private func restart() -> Void
    {
        let transition = SKTransition.fade(with: .orange, duration: 15)
        let restartScene = GameScene()
        restartScene.size = CGSize(width: 300, height: 400)
        restartScene.scaleMode = .fill
        self.view?.presentScene(restartScene, transition: transition)
    }
    
    //MARK: - Handle Pinch
    @objc
    private func handlePinch(recognizer : UIPinchGestureRecognizer) -> Void
    {
        if(recognizer.state == .ended)
        {
            restart()
        }
    }
}
