//
//  Base.swift
//  Amoeba Wars
//
//  Created by 20072163 on 23/11/2018.
//  Copyright © 2018 20072163. All rights reserved.
//

import SpriteKit
import GameplayKit

// 1
class Base: GKEntity {
    
    init(imageName: String, team: Team, entityManager: EntityManager, AI: Bool) {
        super.init()
        
        // 2
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName),name: "base")
        spriteComponent.node.zPosition = Layer.Base
        addComponent(spriteComponent)
        if (AI) {
            addComponent(AIComponent(team: team, entityManager: entityManager))
        }
        addComponent(TeamComponent(team: team))
        addComponent(BaseComponent())
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent.node.size.width / 2), entityManager: entityManager))
        addComponent(HealthComponent(maxHealth: 500))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
