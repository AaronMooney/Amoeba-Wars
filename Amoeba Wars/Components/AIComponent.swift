//
//  AIComponent.swift
//  Amoeba Wars
//
//  Created by 20072163 on 05/12/2018.
//  Copyright © 2018 20072163. All rights reserved.
//

import GameplayKit

class AIComponent: GKComponent {
    let entityManager: EntityManager
    let team: Team
    var previousAmoeba: AmoebaType = .Histolytica
    var amoebaSelected = false
    var lastSpawn = TimeInterval(0)
    
    let markovChain = [AmoebaType.Histolytica : [0.5, 0.3, 0.2],
                       AmoebaType.Fowleri: [0.6, 0.3, 0.1],
                       AmoebaType.Proteus: [0.7, 0.2, 0.1]]
    
    init(team: Team, entityManager: EntityManager) {
        self.entityManager = entityManager
        self.team = team
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        let cooldown = TimeInterval(0.5)
        if (CACurrentMediaTime() - lastSpawn > cooldown) {
            lastSpawn = CACurrentMediaTime()
            next()
        }
    }
    
    func next() {
        if (amoebaSelected) {
            amoebaSelected = !entityManager.spawnAmoeba(team: team, type: previousAmoeba)
            return
        }
        
        let val = drand48()
        let probabilities = markovChain[previousAmoeba]!
        
        if val <= probabilities[0]{
            previousAmoeba = AmoebaType.Histolytica
        } else if val > probabilities[0] && val <= probabilities[0]+probabilities[1]{
            previousAmoeba = AmoebaType.Fowleri
        } else {
            previousAmoeba = AmoebaType.Proteus
        }
        amoebaSelected = true
        next()
    }
}
