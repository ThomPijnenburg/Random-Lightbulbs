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
    
    // Since we are letting the user initiate the brute force calculation of the expected value
    // of unique colors, here I use a statistic formula to determine this quantity.
    // Note that this formula only holds for a uniform distribution, i.e. the subsets of different
    // colors are of equal size: 10.
    static func expectedValue() -> Double {
        
        // properties of our system: 7 distinct colors, 70 marbles, 20 samples
        let nDis = 7.0
        let nRes = 70.0
        let s = 20.0
        
        // variable storing the probability of bulb not in color
        var probNic = 1.0
        
        // upper limit of product
        let upLimit = Int(nRes/nDis-1)
        
        // represent the product as a loop
        for i in 0..<upLimit+1 {
            probNic = probNic * (1 - s/(nRes-Double(i)))
        }
        
        // calculate expected value and return
        let expectedValue = nDis*(1-probNic)
        return expectedValue
    }
}

