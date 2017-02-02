//
//  models.swift
//  NLChallenge
//
//  Created by Thom Pijnenburg on 01/02/2017.
//  Copyright © 2017 Thom Pijnenburg. All rights reserved.
//

import UIKit


// define a class lightbulb with one variable that is the color
class Lightbulb: NSObject {
    var color: String?
    var id: Int?
    
    // generate the set of 70 bulbs in which there are 10 bulbs of each of 7 unique colors
    static func populate() -> [Lightbulb] {
        var bulbs = [Lightbulb]()
        
        // define the different colors
        let colors = [
            "Red",
            "Green",
            "Blue",
            "Yellow",
            "Orange",
            "Purple",
            "Pink"
        ]
        
        // fill the list of lightbulbs
        for i in 0..<70 {
            let bulb = Lightbulb()
            let colorIndex = i/10
            bulb.id = i + 1
            bulb.color = colors[colorIndex]
            bulbs.append(bulb)
        }
        
        // return the list of lightbulbs
        return bulbs
    }
}

