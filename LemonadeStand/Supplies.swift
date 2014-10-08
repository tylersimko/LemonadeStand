//
//  Supplies.swift
//  LemonadeStand
//
//  Created by Tyler Simko on 10/4/14.
//  Copyright (c) 2014 O8 Labs. All rights reserved.
//

import Foundation

struct Supplies {
    
    var moneyRemaining = 0
    var lemonsRemaining = 0
    var iceCubesRemaining = 0
    
    // can't use self keyword in a struct
    
    init(money: Int, lemons: Int, iceCubes: Int) { //Custom initializer
        moneyRemaining = money
        lemonsRemaining = lemons
        iceCubesRemaining = iceCubes
    }
}