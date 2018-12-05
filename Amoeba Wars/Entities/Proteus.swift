//
//  Proteus.swift
//  Amoeba Wars
//
//  Created by 20072163 on 28/11/2018.
//  Copyright © 2018 20072163. All rights reserved.
//

import SpriteKit
import GameplayKit

class Proteus: Amoeba {
    
    init(team: Team, entityManager: EntityManager) {
        super.init()
        let imageName = team.rawValue=="Left" ? ImageName.ProteusLeft : ImageName.ProteusRight
        let texture = SKTexture(imageNamed: imageName)
        let spriteComponent = SpriteComponent(texture: texture)
        addComponent(spriteComponent)
        addComponent(TeamComponent(team: team))
        addComponent(MoveComponent(maxSpeed: 50, maxAcceleration: 1, radius: Float(texture.size().width * 0.3), entityManager: entityManager))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

