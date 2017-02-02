//
//  ViewController.swift
//  NLChallenge
//
//  Created by Thom Pijnenburg on 01/02/2017.
//  Copyright © 2017 Thom Pijnenburg. All rights reserved.
//

import UIKit

// Define global UI colors
let darkGrey = UIColor(red: 48/255, green: 52/255, blue: 63/255, alpha: 1.0)
let lightGrey = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
let green = UIColor(red:37/255, green: 180/255, blue: 107/255, alpha:1.0)


// main view
class ViewController: UIViewController, UITextFieldDelegate {

//  variables storing the lightbulbs, its sample, the estimate of the number of columns
    var bulbReservoir: [Lightbulb]?
    var bulbSamples: [Lightbulb]?
    var estimatedNumberColors: Float?
    var iterations: Int?
    
//  view with user input
    var inputWindow = InputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "BulbSampler"
        view.backgroundColor = darkGrey
        
        // call the populate function to construct the 70 lightbulbs
        bulbReservoir = Lightbulb.populate()
        
        // set textfield delegate to self to control user input
        inputWindow.textField.delegate = self
        inputWindow.textField.keyboardType = .numberPad
        
        // call function to set up views
        setupViews()
        
        // dismiss keyboard when tapping screen
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // call configuration function on lightbulb button to give circular shape
    override func viewDidLayoutSubviews() {
        inputWindow.configureButton()
    }
    
    // make sure user only puts in numerical values in textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    // set iteration variable to user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        iterations = Int(textField.text!)
    }
    
    // dismiss keyboard when tapping view
    func didTapView(){
        self.view.endEditing(true)
    }
    
    // set up subviews
    func setupViews() {

        view.addSubview(inputWindow)
        
        let viewsDictionary = ["inpVw": inputWindow] as [String : Any]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[inpVw]-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[inpVw(300)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        // asign target to button
        inputWindow.bulbBtn.addTarget(self, action: #selector(pressBulbButton), for: .touchUpInside)
    }
    
    // on press button
    func pressBulbButton() {
        //dismiss numberpad
        self.view.endEditing(true)
        
        // call averaging function
        calculateAverageNumberOfColours()
        return
    }
    
    // this function takes the users input as number of iterations of sampling
    // and calculates the expected number of unique colours
    func calculateAverageNumberOfColours() {
        
        //variables to keep track of quantities
        var total = Float(0)
        var reps = 1
        var maxReps = 0
        var oldAverage = Float(0)
        var newAverage = Float(0)
        
        // if user input is defined set the number of loops to user input
        if iterations != nil {
            reps = iterations!
            print(reps)
        }
        // if user presses button without input, return nothing
        else {
            return
        }
        
        // Start doing a number of sample routines defined by users input
        for _ in 0..<reps {
            
            // take new sample from lightbulb reservoir, which returns the number of colors
            let newSample = sampleAndCalculateUniqueColors()
            
            // calculate new average
            total += Float(newSample)
            newAverage = Float(total) / Float(reps)
            
            // reassign variables
            oldAverage = newAverage
            maxReps += 1
            print(maxReps)
        }
        
        // set expected number of colors to calculated average
        let colorCount = newAverage
        
        // set labels to corresponding values to communicate to user
        setLabelToColorCount(count: colorCount, reps: maxReps)
        return
    }
    
    // change label text to found number of colors
    func setLabelToColorCount(count: Float, reps: Int) {
        let roundedCount = String(format: "%.2f", count)
        inputWindow.resultView.colorLabel.text = roundedCount
        inputWindow.resultView.simulationLabel.text = String(format: "%d", reps)
        return
    }
    
    // take samples from resevoir and calculate number of colors
    func sampleAndCalculateUniqueColors() -> Int {
        bulbSamples = takeSamples(bulbList: bulbReservoir!)
        let uniqueColorsCount = numberOfUniqueColors(samples: bulbSamples!)
        return uniqueColorsCount
    }
    
    // take 20 unique bulbs out of tvoirhe rese
    func takeSamples(bulbList: [Lightbulb]) -> [Lightbulb] {

        // list of lightbulbs
        var sampleBulbs = [Lightbulb]()
        
        // construct list of unique ids
        let bulbIds = uniqueRandoms(numberOfRandoms: 20, minNum: 1, maxNum: 70)
        
        // pick the bulbs out of the resevoir corresponding to the unique ids
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
    
    // calculate the bumber of unique colors of the bulbs in the sample
    func numberOfUniqueColors(samples: [Lightbulb]) -> Int {
        
        // remember the unique colors
        var uniqueColors = [String]()
        
        // loop over sample
        for sample in samples {
            
            //get color
            let sampleColor = sample.color
            
            var found = false
            
            // add color of first sample
            if uniqueColors.count == 0 {
                found = false
            }
            
            // loop over colors in list
            for color in uniqueColors {
                //if bulbs color is present in list go to next bulb
                if color == sampleColor {
                    found = true
                    break
                }
            }
            // if new color append to color list
            if found == false {
                uniqueColors.append(sampleColor!)
            }
        }
        // return length of color list
        return uniqueColors.count
    }
    
    // construct list of unique numbers
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        
        var uniqueNumbers = [Int]()
        
        // loop until you have enough numbers
        while uniqueNumbers.count < numberOfRandoms {
            
            //get random number
            let randomNumber = Int(arc4random_uniform(maxNum + 1)) + minNum
            var found = false
            
            // check if number is already in list
            for index in 0 ..< uniqueNumbers.count {
                if uniqueNumbers[index] == randomNumber {
                    found = true
                    break
                }
            }
            
            //if not append it
            if found == false {
                uniqueNumbers.append(randomNumber)
            }
            
        }
        // return result
        return uniqueNumbers
    }

}

// construct UI
class InputView: UIView {
    
    var bulbBtn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    var instructionLabel = InsetLabel()
    
    var textField = UITextField()

    var resultView = ResultView()
    
    // set up subviews
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        
        //set properties
        instructionLabel.text = "Insert the number of simulations"
        instructionLabel.textAlignment = .left
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.backgroundColor = green
        instructionLabel.textColor = .white
        instructionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        instructionLabel.sizeToFit()
        instructionLabel.numberOfLines = 0
        
        let paddingView = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = lightGrey
        textField.clearButtonMode = .always
        textField.contentHorizontalAlignment = .center
        
        bulbBtn.translatesAutoresizingMaskIntoConstraints = false
        
        resultView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // Setup Constraints
    private func setup() {
        // 1. Setup the properties of the view it's self
        self.translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor.white
        
        // 2. Setup your subviews
        addSubview(instructionLabel)
        addSubview(bulbBtn)
        addSubview(textField)
        addSubview(resultView)
        
        // useful dimensions
        let screenSize = UIScreen.main.bounds
        let screenWidth = Float(screenSize.width)
        let bulbWidth = Float(80)
        let bulbMargin = screenWidth/2 - bulbWidth/2
        let labelHeight = 80
        
        
        let viewsDictionary = [ "instrLbl": instructionLabel, "bulbBtn": bulbBtn, "resvw": resultView, "textvw": textField] as [String : Any]
        let metricsDictionary = ["lbHeight": labelHeight,"bbtn": bulbWidth, "bmargin": bulbMargin] as [String : Any]
        
        // constraints on elements
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[instrLbl(lbHeight)]-20-[textvw(bbtn)]-20-[resvw]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[instrLbl(lbHeight)]-20-[bulbBtn(bbtn)]-20-[resvw]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[resvw(300)]", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[instrLbl]|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textvw]-[bulbBtn(bbtn)]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
    }
    
    // configure circular shape of button
    func configureButton()
    {
        bulbBtn.setImage(UIImage(named: "bulb")?.withRenderingMode(.alwaysTemplate),  for: UIControlState())
        bulbBtn.imageEdgeInsets = UIEdgeInsetsMake(15,15,15,15)
        bulbBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        bulbBtn.tintColor = green
        bulbBtn.layer.cornerRadius = 0.5 * bulbBtn.bounds.size.width
        bulbBtn.layer.borderColor = green.cgColor as CGColor
        bulbBtn.layer.borderWidth = 3.0
        bulbBtn.clipsToBounds = true
    }
    
    // label with padding
    class InsetLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)))
        }
    }
    
    // view with results of computations
    class ResultView: UIView  {
        
        var simulationLabel = UILabel()
        var simulationTitle = UILabel()
        var colorLabel = UILabel()
        var colorTitle = UILabel()
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //setup properties of elements and constraints
        
        func setup() {
            // 1. Setup the properties of the view it's self
            self.translatesAutoresizingMaskIntoConstraints = false
            clipsToBounds = true
            
            colorTitle.text = "Colors"
            colorTitle.textAlignment = .left
            colorTitle.translatesAutoresizingMaskIntoConstraints = false
            colorTitle.sizeToFit()
            colorTitle.numberOfLines = 0
            colorTitle.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
            
            colorLabel.text = "0"
            colorLabel.textAlignment = .left
            colorLabel.translatesAutoresizingMaskIntoConstraints = false
            colorLabel.sizeToFit()
            colorLabel.numberOfLines = 0

            simulationTitle.text = "Simulations"
            simulationTitle.textAlignment = .left
            simulationTitle.translatesAutoresizingMaskIntoConstraints = false
            simulationTitle.sizeToFit()
            simulationTitle.numberOfLines = 0
            simulationTitle.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
            
            simulationLabel.text = "0"
            simulationLabel.textAlignment = .left
            simulationLabel.translatesAutoresizingMaskIntoConstraints = false
            simulationLabel.sizeToFit()
            simulationLabel.numberOfLines = 0
            
            // 2. Setup your subviews
            addSubview(simulationTitle)
            addSubview(colorTitle)
            addSubview(simulationLabel)
            addSubview(colorLabel)
            
            let metricsDictionary = ["labelWidth": 150, "titleHeight":40]
            
            let viewsDictionary = [ "simTtl": simulationTitle, "simLbl": simulationLabel, "colorLbl": colorLabel, "colorTtl": colorTitle] as [String : Any]
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[simTtl(labelWidth)][colorTtl(labelWidth)]", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[simLbl(labelWidth)][colorLbl(labelWidth)]", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[simTtl(titleHeight)][simLbl]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[colorTtl(titleHeight)][colorLbl]-|", options: NSLayoutFormatOptions(), metrics: metricsDictionary, views: viewsDictionary))
            
            
        }
    }
    
}


