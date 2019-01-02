//
//  HealthComponent.swift
//  Amoeba Wars
//
//  Created by 20072163 on 02/01/2019.
//  Copyright © 2019 20072163. All rights reserved.
//

import GameplayKit

class HealthComponent : GKComponent {
    
    var maxHealth: Int
    var currentHealth: Int
    
    init(maxHealth: Int){
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        super.init()
    }
    
    func takeDamage(value: Int){
        currentHealth -= value
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if currentHealth >= maxHealth{
            currentHealth = maxHealth
        }
        if currentHealth <= 0 {
            currentHealth = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
