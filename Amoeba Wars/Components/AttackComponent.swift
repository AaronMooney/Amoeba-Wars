//
//  AttackComponent.swift
//  Amoeba Wars
//
//  Created by 20072163 on 02/01/2019.
//  Copyright © 2019 20072163. All rights reserved.
//

import GameplayKit

class AttackComponent :  GKComponent
{
    let damage: Int
    let entityManager: EntityManager
    let hitRate: CGFloat
    var cooldown: TimeInterval
    
    init(damage: Int, entityManager: EntityManager, hitRate: CGFloat){
        self.damage = damage
        self.entityManager = entityManager
        self.hitRate = hitRate
        self.cooldown = 0
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        guard let teamComponent = entity?.component(ofType: TeamComponent.self) else {return}
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {return}
        
        let enemies = entityManager.entities(for: teamComponent.team.oppositeTeam())
        for enemy in enemies{
            guard let enemySpriteComponent = enemy.component(ofType: SpriteComponent.self) else {continue}
            guard let enemyHealthComponent = enemy.component(ofType: HealthComponent.self) else {continue}
            
            if(spriteComponent.node.calculateAccumulatedFrame().intersects(enemySpriteComponent.node.calculateAccumulatedFrame())){
                if (CGFloat(CACurrentMediaTime() - cooldown) > hitRate){
                    enemyHealthComponent.takeDamage(value: damage)
                    
                    if (enemyHealthComponent.currentHealth <= 0){
                        entityManager.remove(entity!)
                    }
                    cooldown = CACurrentMediaTime()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
