//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    var Stack = [String]()
    var Check = false
    var Check2 = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    
    //
    
    func updateResultLabel(_ content: String) {
        print("Adding to Label")
        if resultLabel.text == nil || resultLabel.text == "0"{
            resultLabel.text = content
        }
        else if resultLabel.text!.characters.count < 7{
            resultLabel.text = resultLabel.text! + content
        }
    }
    func ResetResultLabel() {
       resultLabel.text = "0"
       Stack = [String]()
       Check = false
       Check2 = false
        
        
    }
    
    func FlipResultLabel() {
        if resultLabel.text!.characters.count == 7{
            return
        }
        if resultLabel.text![resultLabel.text!.startIndex] == "-"{
            resultLabel.text!.remove(at: resultLabel.text!.startIndex)
        }
        else {
            resultLabel.text = "-" + resultLabel.text!
        }
    }
    func addDot(){
        if resultLabel.text!.characters.count == 7{
            return
        }
        else{
            resultLabel.text = resultLabel.text! + "."
        }
    }
    
    func CheckVals(a:String, b:String) -> Bool{
        let toA = Double(a)
        let toB = Double(b)
        if toA == round(toA!) && toB==round(toB!){
            return true
        }
        return false
        
    }
    
    func CreateScience(a: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.scientific
        numberFormatter.exponentSymbol = "e"
        numberFormatter.positiveFormat = "0.##E+0"
        return numberFormatter.string(from: NSNumber(value: a))!
    }
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        var val = Int()
        switch operation {
            case "+":
                val = a + b
            case "-":
                val = a - b
            case "*":
                val = a * b
            default:
                val = 100
        }
        return val
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation Double requested for \(a) \(operation) \(b)")
        var val = Double()
        switch operation {
        case "+":
            val = Double(a)! + Double(b)!
        case "-":
            val = Double(a)! - Double(b)!
        case "*":
            val = Double(a)! * Double(b)!
        case "/":
            val = Double(a)! / Double(b)!
        default:
            val = 100
        }
        return val
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        Check = false
        for i in ["/", "*", "-", "+"]{
            if Stack.last == i && Check2{
                resultLabel.text = "0"
            }
        }
        Check2 = false
        updateResultLabel(sender.content)
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        print("The operator \(sender.content) was pressed")
        if sender.content == "C"{
            ResetResultLabel()
        }
        else if sender.content == "+/-"{
            FlipResultLabel()
        }
        else if sender.content == "+" || sender.content == "-" || sender.content == "*" || sender.content == "/"{
            if Check{
                Stack[Stack.count - 1] = sender.content
                return
                    //want to do nothing and move on.
            }
            Stack.append(resultLabel.text!)
            if Stack.count == 3{
                if CheckVals(a: Stack[0], b: Stack[2]) && Stack[1] != "/"{
                    let value = intCalculate(a: Int(Stack[0])!, b: Int(Stack[2])!, operation: Stack[1])
                    if value < 9999999 && value > 0{
                        resultLabel.text = String(value)
                    }
                    else if value > -999999 && value < 0{
                        resultLabel.text = String(value)
                    }
                    else{
                        print("ok it tried")
                        resultLabel.text = CreateScience(a: Double(value))
                    }
                }
                else{
                    let value = calculate(a: Stack[0], b: Stack[2], operation: Stack[1])
                    if round(value) == value{
                        resultLabel.text = String(Int(value))
                    }
                    else{
                        var want = String(value)
                        if want.characters.count > 7{
                           want = String(format: "%.5f", value)
                        }
                        if want == "0.00000"{
                            want = CreateScience(a: value)
                            resultLabel.text = want
                        }
                        else{
                            resultLabel.text = want
                        }
                    }
                }
                Stack = [String]()
                Stack.append(resultLabel.text!)
            }
            Check = true
            Check2 = true
            Stack.append(sender.content)
        }
        else if sender.content == "="{
            if Check{
                return
                //want to do nothing and move on
            }
            Stack.append(resultLabel.text!)
            if CheckVals(a: Stack[0], b: Stack[2]) && Stack[1] != "/"{
                let value = intCalculate(a: Int(Stack[0])!, b: Int(Stack[2])!, operation: Stack[1])
                if value < 9999999 && value > 0{
                    resultLabel.text = String(value)
                }
                else if value > -999999 && value < 0{
                    resultLabel.text = String(value)
                }
                else{
                    print("ok it tried")
                    resultLabel.text = CreateScience(a: Double(value))
                }
            }
            else{
                let value = calculate(a: Stack[0], b: Stack[2], operation: Stack[1])
                if round(value) == value{
                    resultLabel.text = String(Int(value))
                }
                else{
                    var want = String(value)
                    if want.characters.count > 7{
                        want = String(format: "%.5f", value)
                    }
                    if want == "0.00000"{
                        want = CreateScience(a: value)
                        resultLabel.text = want
                    }
                    else{
                        resultLabel.text = want
                    }
                }
            }
            Stack = [String]()
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        if sender.content == "."{
            addDot()
        }
        if sender.content == "0"{
            Check = false
            for i in ["/", "*", "-", "+"]{
                if Stack.last == i && Check2{
                    resultLabel.text = "0"
                }
            }
            Check2 = false
            updateResultLabel(sender.content)
        }
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

