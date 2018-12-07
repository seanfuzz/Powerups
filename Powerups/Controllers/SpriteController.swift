//
//  SpriteController.swift
//  Powerups
//
//  Created by Sean Orelli on 12/7/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit
import SpriteKit

class SpriteController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SKScene(size: view.bounds.size)
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        skView.pin()
        
 //       skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    
        let player = SKSpriteNode(imageNamed: "blob")
    
        skView.backgroundColor = SKColor.white
        player.position = CGPoint(x: view.bounds.size.width * 0.25, y: view.bounds.size.height * 0.5)
        player.xScale = 0.5
        player.yScale = 0.5
        scene.addChild(player)
    }
    
}
