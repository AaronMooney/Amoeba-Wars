//
//  EntityManager.swift
//  Amoeba Wars
//
//  Created by 20072163 on 23/11/2018.
//  Copyright © 2018 20072163. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityManager {
    
    lazy var componentSystems: [GKComponentSystem] = {
        let baseSystem = GKComponentSystem(componentClass: BaseComponent.self)
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        let aiSytem = GKComponentSystem(componentClass: AIComponent.self)
        return [baseSystem, moveSystem, aiSytem]
    } ()
    // 1
    var entities = Set<GKEntity>()
    let scene: SKScene
    var toRemove = Set<GKEntity>()
    
    // 2
    init(scene: SKScene) {
        self.scene = scene
    }
    
    // 3
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    // 4
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        // 1
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        // 2
        for currentRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: currentRemove)
            }
        }
        toRemove.removeAll()
    }
    
    func base(for team: Team) -> GKEntity? {
        for entity in entities {
            if let teamComponent = entity.component(ofType: TeamComponent.self),
                let _ = entity.component(ofType: BaseComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
        }
        return nil
    }
    
    func entities(for team: Team) -> [GKEntity] {
        return entities.compactMap{ entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
    }
    
    func moveComponents(for team: Team) -> [MoveComponent] {
        let entitiesToMove = entities(for: team)
        var moveComponents = [MoveComponent]()
        for entity in entitiesToMove {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        return moveComponents
    }
    
    func spawnAmoeba(team: Team, type: AmoebaType) -> Bool{
        switch(type){
        case(AmoebaType.Histolytica):
            return createAmoeba(cost: GameConfig.HistolyticaCost, type: "histolytica", team: team)
        case(AmoebaType.Fowleri):
            return createAmoeba(cost: GameConfig.FowleriCost, type: "fowleri", team: team)
        case(AmoebaType.Proteus):
            return createAmoeba(cost: GameConfig.ProteusCost, type: "proteus", team: team)
        }
    }
    
    func createAmoeba(cost: Int, type: String, team: Team) -> Bool {
        guard let teamEntity = base(for: team),
            let teamBaseComponent = teamEntity.component(ofType: BaseComponent.self),
            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
                return false
        }

        if teamBaseComponent.coins < cost {
            return false
        }
        teamBaseComponent.coins -= cost
        scene.run(SoundManager.sharedInstance.soundSpawn)

        var amoeba = Amoeba()

        switch (type) {
        case ("histolytica"):
            amoeba = Histolytica(team: team, entityManager: self)
            break
        case ("fowleri"):
            amoeba = Fowleri(team: team, entityManager: self)
            break
        case ("proteus"):
            amoeba = Proteus(team: team, entityManager: self)
            break
        default:
            break
        }

        if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
            spriteComponent.node.zPosition = Layer.Amoeba
        }
        add(amoeba)
        return true
    }
}
