//
//  Constants.swift
//  Amoeba Wars
//
//  Created by 20072163 on 23/11/2018.
//  Copyright © 2018 20072163. All rights reserved.
//

import SpriteKit


import UIKit

struct ImageName {
    static let Background = "Background"
    static let Button = "Button"
    static let Coin = "Coin"
    static let ProteusLeft = "ProteusLeft"
    static let FowleriLeft = "FowleriLeft"
    static let HistolyticaLeft = "HistolyticaLeft"
    static let Base_Left_Defence = "Base_Left_Defence"
    static let Base_Right_Defence = "Base_Right_Defence"
    static let Base_Left_Attack = "Base_Left_Attack"
    static let Base_Right_Attack = "Base_Right_Attack"
    static let HistolyticaRight = "HistolyticaRight"
}

struct Layer {
    static let Background: CGFloat = 0
    static let Button: CGFloat = 1
    static let HUD: CGFloat = 2
    static let Amoeba: CGFloat = 2
}

struct PhysicsCategory {
}

struct GameConfig {
    static let HistolyticaCost = 10
    static let FowleriCost = 25
    static let ProteusCost = 50
}
