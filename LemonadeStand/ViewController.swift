//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Tyler Simko on 10/4/14.
//  Copyright (c) 2014 O8 Labs. All rights reserved.
//
//Make it so we are able to purchase, and un-purchase, lemons for $2 and ice cubes at $1. When the user presses the corresponding buttons "+" and "-".

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var moneyRemainingLabel: UILabel!
    @IBOutlet weak var lemonsRemainingLabel: UILabel!
    @IBOutlet weak var iceCubesRemainingLabel: UILabel!

    @IBOutlet weak var lemonPurchaseCount: UILabel!
    @IBOutlet weak var iceCubePurchaseCount: UILabel!
    
    @IBOutlet weak var lemonMixCount: UILabel!
    @IBOutlet weak var iceCubeMixCount: UILabel!
    
    var supplies = Supplies(money: 10, lemons: 1, iceCubes: 1)
    var price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    var weatherArray: [[Int]] = [[-10, -9, -5, -7], [5,8,10,9], [22, 25, 27, 23]] //cold, mild, warm
    var weatherToday: [Int] = [0,0,0,0]
    
    var weatherImageView: UIImageView = UIImageView(frame: CGRectMake(50, 100, 50, 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(weatherImageView) //adds image
        simulateWeatherToday()
        updateMainView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyLemonButtonPressed(sender: UIButton) {
        if supplies.moneyRemaining >= price.lemon {
            lemonsToPurchase += 1
            supplies.moneyRemaining -= price.lemon
            supplies.lemonsRemaining += 1
        } else {
            showAlertWithText(header: "Low Cash Flow", message: "You don't have enough money to do that. :(")
        }
        updateMainView()
    }
    
    @IBAction func sellLemonButtonPressed(sender: UIButton) {
        if lemonsToPurchase > 0 {
            lemonsToPurchase -= 1
            supplies.moneyRemaining += price.lemon
            supplies.lemonsRemaining -= 1
        } else {
            showAlertWithText(message: "You don't have any lemons to sell!")
        }
        updateMainView()
    }
    
    @IBAction func buyIceCubeButtonPressed(sender: UIButton) {
        if supplies.moneyRemaining >= price.iceCube {
            iceCubesToPurchase += 1
            supplies.moneyRemaining -= price.iceCube
            supplies.iceCubesRemaining += 1
        } else {
            showAlertWithText(header: "Low Cash Flow", message: "You don't have enough money to do that. :(")
        }
        updateMainView()
    }
    
    @IBAction func sellIceCubeButtonPressed(sender: UIButton) {
        if iceCubesToPurchase > 0 {
            iceCubesToPurchase -= 1
            supplies.moneyRemaining += price.iceCube
            supplies.iceCubesRemaining -= 1
        }
        else {
            showAlertWithText(message: "You don't have any cubes to sell.")
        }
        updateMainView()
    }
    
    @IBAction func mixLemonButtonPressed(sender: UIButton) {
        if supplies.lemonsRemaining > 0 {
            supplies.lemonsRemaining -= 1
            lemonsToMix += 1
        } else {
            showAlertWithText(message: "You don't have enough inventory.")
        }
        updateMainView()
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: UIButton) {
        if supplies.iceCubesRemaining > 0 {
            supplies.iceCubesRemaining -= 1
            iceCubesToMix += 1
        } else {
            showAlertWithText(message: "You don't have enough inventory.")
        }
        updateMainView()
    }
    
    @IBAction func unmixLemonButtonPressed(sender: UIButton) {
        if lemonsToMix > 0 {
            lemonsToMix -= 1
            supplies.lemonsRemaining += 1
        } else {
            showAlertWithText(message: "You have nothing to return.")
        }
        updateMainView()
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: UIButton) {
        if iceCubesToMix > 0 {
            iceCubesToMix -= 1
            supplies.iceCubesRemaining += 1
        } else {
            showAlertWithText(message: "You have nothing to return.")
        }
        updateMainView()
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
        let average = findAverage(weatherToday)
        let customers = Int(arc4random_uniform(UInt32(average))) //random from 0:N-1
        println("customers: \(customers)")
        
        let lemonadeRatio = Float(lemonsToMix) / Float(iceCubesToMix)
        println("lemonade ratio: \(lemonadeRatio)")
        for x in 0...customers {
            let preference = Double(arc4random_uniform(100)) / 100.0
            
            if preference < 0.4 && lemonadeRatio > 1 {
                supplies.moneyRemaining += 1
                println("paid!")
            } else if preference > 0.6 && lemonadeRatio < 1 {
                supplies.moneyRemaining += 1
                println("paid!")
            } else if preference <= 0.6 && preference >= 0.4 && lemonadeRatio == 1 {
                supplies.moneyRemaining += 1
                println("paid!")
            } else {
                println("No match, no revenue")
            }
        }
        
        lemonsToPurchase = 0
        iceCubesToPurchase = 0
        lemonsToMix = 0
        iceCubesToMix = 0
        simulateWeatherToday()
        updateMainView()
    }
    
    func updateMainView() {
        moneyRemainingLabel.text = "$\(supplies.moneyRemaining)"
        lemonsRemainingLabel.text = "\(supplies.lemonsRemaining) Lemons"
        iceCubesRemainingLabel.text = "\(supplies.iceCubesRemaining) Ice Cubes"
        
        lemonPurchaseCount.text = "\(lemonsToPurchase)"
        iceCubePurchaseCount.text = "\(iceCubesToPurchase)"
        
        lemonMixCount.text = "\(lemonsToMix)"
        iceCubeMixCount.text = "\(iceCubesToMix)"
    }

    func showAlertWithText(header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func simulateWeatherToday() {
        var randomIndex = Int(arc4random_uniform(UInt32(weatherArray.count)))
        weatherToday = weatherArray[randomIndex]
        switch randomIndex {
        case 0: weatherImageView.image = UIImage(named: "Cold")
        case 1: weatherImageView.image = UIImage(named: "Mild")
        case 2: weatherImageView.image = UIImage(named: "Warm")
        default: weatherImageView.image = UIImage(named: "Warm")
        }
    }
    
    func findAverage(data: [Int]) -> Int {
        var sum = 0
        for entry in data {
            sum += entry
        }
        var average: Double = Double(sum) / Double(data.count)
        var rounded: Int = Int(ceil(average))
        return rounded
    }
}

