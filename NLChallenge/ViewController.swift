//
//  ViewController.swift
//  NLChallenge
//
//  Created by Thom Pijnenburg on 01/02/2017.
//  Copyright © 2017 Thom Pijnenburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var bulbReservoir: [Lightbulb]?
    var bulbSamples: [Lightbulb]?
    var estimatedNumberColors: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .blue
        
        self.title = "BulbSampler"
        
        bulbReservoir = Lightbulb.populate()
        var total = 0
        let iterations = 30
        
        // Start doing a number of sample routines defined by users input
        for _ in 0..<iterations {
            let newSample = sampleAndCalculateUniqueColors()
            total += newSample
        }
        
        calculateNumberOfColors(
        
        print(Double(total)/Double(iterations))
        print(total / iterations)
        print(total % iterations)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateNumberOfColors
    
    func sampleAndCalculateUniqueColors() -> Int {
        bulbSamples = takeSamples(bulbList: bulbReservoir!)
        let uniqueColorsCount = numberOfUniqueColors(samples: bulbSamples!)
        return uniqueColorsCount
    }
    
    func takeSamples(bulbList: [Lightbulb]) -> [Lightbulb] {

        var sampleBulbs = [Lightbulb]()
        
        let bulbIds = uniqueRandoms(numberOfRandoms: 20, minNum: 1, maxNum: 70)
        
        for id in bulbIds {
            
            for bulb in bulbList {
                if bulb.id == id {
                    let sample = bulb
                    sampleBulbs.append(sample)
                    break
                }
            }
        }
        return sampleBulbs
    }
    
    func numberOfUniqueColors(samples: [Lightbulb]) -> Int {
        
        var uniqueColors = [String]()
        
        for sample in samples {
            
            let sampleColor = sample.color
            
            var found = false
            
            if uniqueColors.count == 0 {
                found = false
            }
            
            for color in uniqueColors {
                if color == sampleColor {
                    found = true
                    break
                }
            }
            if found == false {
                uniqueColors.append(sampleColor!)
            }
        }
        
        return uniqueColors.count
    }
    
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        
        var uniqueNumbers = [Int]()
        
        while uniqueNumbers.count < numberOfRandoms {
            
            let randomNumber = Int(arc4random_uniform(maxNum + 1)) + minNum
            var found = false
            
            for index in 0 ..< uniqueNumbers.count {
                if uniqueNumbers[index] == randomNumber {
                    found = true
                    break
                }
            }
            
            if found == false {
                uniqueNumbers.append(randomNumber)
            }
            
        }
        
        return uniqueNumbers
    }


}

