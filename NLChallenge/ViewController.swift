//
//  ViewController.swift
//  NLChallenge
//
//  Created by Thom Pijnenburg on 01/02/2017.
//  Copyright © 2017 Thom Pijnenburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    var bulbReservoir: [Lightbulb]?
    var bulbSamples: [Lightbulb]?
    var estimatedNumberColors: Float?
    var iterations: Int?
    
    var bulbBtn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    var label = UILabel()
    
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "BulbSampler"
        view.backgroundColor = .white
        
        bulbReservoir = Lightbulb.populate()
        
        
        textField.delegate = self
        textField.keyboardType = .numberPad
        
        setupViews()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        configureButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        iterations = Int(textField.text!)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func setupViews() {
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .green
        
        label.text = "labelelel"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        bulbBtn.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(bulbBtn)
        view.addSubview(textField)
        
        let viewsDictionary = ["bulbBtn": bulbBtn, "label": label, "textvw": textField] as [String : Any]
        let metricsDictionary = ["bbtn": 100]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[bulbBtn]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textvw]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[textvw(bbtn)]-[bulbBtn(bbtn)]-[label]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        
        bulbBtn.addTarget(self, action: #selector(pressBulbButton), for: .touchUpInside)
    }
    
    func configureButton()
    {
        bulbBtn.setImage(UIImage(named: "bulb")?.withRenderingMode(.alwaysTemplate),  for: UIControlState())
        bulbBtn.imageEdgeInsets = UIEdgeInsetsMake(15,15,15,15)
        bulbBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        bulbBtn.tintColor = .red
        bulbBtn.layer.cornerRadius = 0.5 * bulbBtn.bounds.size.width
        bulbBtn.layer.borderColor = UIColor(red:0.0/255.0, green:122.0/255.0, blue:255.0/255.0, alpha:1).cgColor as CGColor
        bulbBtn.layer.borderWidth = 2.0
        bulbBtn.clipsToBounds = true
    }
    
    func pressBulbButton() {
        //dismiss numberpad
        self.view.endEditing(true)
        var total = 0
        var reps = 1
        
        if iterations != nil {
            reps = iterations!
            print(reps)
        }
        // Start doing a number of sample routines defined by users input
        for _ in 0..<reps {
            let newSample = sampleAndCalculateUniqueColors()
            total += newSample
        }
        
        let colorCount = Float(total)/Float(reps)
        
        print(colorCount)
        print(total / reps)
        print(total % reps)
        setLabelToColorCount(count: colorCount)
    }
    
    func setLabelToColorCount(count: Float) {
        label.text = String(count)
        return
    }
    
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

