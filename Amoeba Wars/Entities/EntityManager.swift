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
        return [baseSystem, moveSystem]
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
    
//    func spawnHistolytica(team: Team) {
//        // 1
//        guard let teamEntity = base(for: team),
//            let teamBaseComponent = teamEntity.component(ofType: BaseComponent.self),
//            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
//                return
//        }
//
//        // 2
//        if teamBaseComponent.coins < GameConfig.HistolyticaCost {
//            return
//        }
//        teamBaseComponent.coins -= GameConfig.HistolyticaCost
//        scene.run(SoundManager.sharedInstance.soundSpawn)
//
//        // 3
//        let amoeba = Histolytica(team: team, entityManager: self)
//        if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
//            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
//            spriteComponent.node.zPosition = Layer.Amoeba
//        }
//        add(amoeba)
//    }
//
//    func spawnFowleri(team: Team) {
//        // 1
//        guard let teamEntity = base(for: team),
//            let teamBaseComponent = teamEntity.component(ofType: BaseComponent.self),
//            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
//                return
//        }
//
//        // 2
//        if teamBaseComponent.coins < GameConfig.FowleriCost {
//            return
//        }
//        teamBaseComponent.coins -= GameConfig.FowleriCost
//        scene.run(SoundManager.sharedInstance.soundSpawn)
//
//        // 3
//        let amoeba = Fowleri(team: team, entityManager: self)
//        if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
//            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
//            spriteComponent.node.zPosition = Layer.Amoeba
//        }
//        add(amoeba)
//    }
//
//    func spawnProteus(team: Team) {
//        // 1
//        guard let teamEntity = base(for: team),
//            let teamBaseComponent = teamEntity.component(ofType: BaseComponent.self),
//            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
//                return
//        }
//
//        // 2
//        if teamBaseComponent.coins < GameConfig.ProteusCost {
//            return
//        }
//        teamBaseComponent.coins -= GameConfig.ProteusCost
//        scene.run(SoundManager.sharedInstance.soundSpawn)
//
//        // 3
//        let amoeba = Proteus(team: team, entityManager: self)
//        if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
//            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
//            spriteComponent.node.zPosition = Layer.Amoeba
//        }
//        add(amoeba)
//    }
    
    func spawnAmoeba(team: Team, type: String){
        guard let teamEntity = base(for: team),
            let teamBaseComponent = teamEntity.component(ofType: BaseComponent.self),
            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
                return
            }
        switch(type){
        case("histolytica"):
            if teamBaseComponent.coins < GameConfig.HistolyticaCost {
                return
            }
            teamBaseComponent.coins -= GameConfig.HistolyticaCost
            scene.run(SoundManager.sharedInstance.soundSpawn)
            
            let amoeba = Histolytica(team: team, entityManager: self)
            if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
                spriteComponent.node.zPosition = Layer.Amoeba
            }
            add(amoeba)
            break
        case("fowleri"):
            if teamBaseComponent.coins < GameConfig.FowleriCost {
                return
            }
            teamBaseComponent.coins -= GameConfig.FowleriCost
            scene.run(SoundManager.sharedInstance.soundSpawn)
            
            let amoeba = Fowleri(team: team, entityManager: self)
            if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
                spriteComponent.node.zPosition = Layer.Amoeba
            }
            add(amoeba)
            break
        case("proteus"):
            if teamBaseComponent.coins < GameConfig.ProteusCost {
                return
            }
            teamBaseComponent.coins -= GameConfig.ProteusCost
            scene.run(SoundManager.sharedInstance.soundSpawn)
            
            let amoeba = Proteus(team: team, entityManager: self)
            if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
                spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
                spriteComponent.node.zPosition = Layer.Amoeba
            }
            add(amoeba)
            break
        default:
            break;
        }
    }
    
//    func createAmoeba(cost: Int, type: String, team: Team){
//        guard let teamEntity = base(for: team),
//            let teamBaseComponent = teamEntity.component(ofType: BaseComponent.self),
//            let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
//                return
//        }
//
//        if teamBaseComponent.coins < cost {
//            return
//        }
//        teamBaseComponent.coins -= cost
//        scene.run(SoundManager.sharedInstance.soundSpawn)
//
//        var amoeba//todo - try refactor this to one method
//
//        switch (type) {
//        case ("histolytica"):
//            amoeba = Histolytica(team: team, entityManager: self)
//            break
//        case ("fowleri"):
//            amoeba = Fowleri(team: team, entityManager: self)
//            break
//        case ("proteus"):
//            amoeba = Proteus(team: team, entityManager: self)
//            break
//        default:
//            break
//        }
//
//        if let spriteComponent = amoeba.component(ofType: SpriteComponent.self) {
//            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
//            spriteComponent.node.zPosition = Layer.Amoeba
//        }
//        add(amoeba)
//    }
}
