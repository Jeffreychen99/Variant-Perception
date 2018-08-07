//
//  GameController.swift
//  Variant Perception
//
//  Created by Jeffrey Chen on 7/11/18.
//  Copyright © 2018 Jeffrey Chen. All rights reserved.
//

import Foundation
import UIKit

class GameController: UIViewController {
    
    let backButton = UIButton()
    
    let green = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
    let red = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
    
    let buyButton = UIButton()
    let holdButton = UIButton()
    let sellButton = UIButton()
    
    let buyAllButton = UIButton()
    let sellAllButton = UIButton()
    
    let highScoreLabel = UIButton()
    let priceLabel = UILabel()
    let changeLabel = UILabel()
    let sharesLabel = UILabel()
    let cashLabel = UILabel()
    let dayLabel = UILabel()
    
    let graph = Chart()
    var firstAdvance = true
    
    var currentHighScore = Double(0.00)
    
    var trueValue = Double()
    
    var currentScore = Double(0.00)
    var priceArr = [Double(drand48() * 110 + 15.0)]
    var sharesOwned = 0
    var cashNum = 1000.00
    var dayNum = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let time = UInt32(NSDate().timeIntervalSinceReferenceDate)
        srand48(Int(time))
        trueValue = Double(drand48() * 80) - 5

        let width = self.view.frame.width
        let height = self.view.frame.height
        self.view.backgroundColor = UIColor.black
        
        backButton.frame = CGRect(x: width*0.3, y: height*0.91, width: width*0.4, height: height*0.05)
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.backgroundColor = UIColor.black
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font =  UIFont(name: "EBGaramond08-Regular", size: 18)
        backButton.setTitle("Back",for: .normal)
        backButton.layer.cornerRadius = 12.5
        backButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(self.downsizeButton(_:)), for: .touchDown)
        backButton.addTarget(self, action: #selector(self.upsizeButton(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(self.upsizeButton(_:)), for: .touchUpOutside)
        //self.view.addSubview(backButton)
        
        highScoreLabel.frame = CGRect(x: width*0.05, y: height*0.075, width: width*0.9, height: height*0.075)
        highScoreLabel.setTitle("Highscore:   $\(String(format: "%.2f", currentHighScore))", for: .normal)
        highScoreLabel.backgroundColor = UIColor.black
        highScoreLabel.setTitleColor(UIColor.white, for: .normal)
        setupButton(button: highScoreLabel)
        highScoreLabel.titleLabel?.font =  UIFont(name: "EBGaramond08-Regular", size: 35)
        loadHighScore()
        self.view.addSubview(highScoreLabel)
        
        let instructions = UILabel()
        instructions.frame = CGRect(x: width*0.05, y: height*0.16, width: width*0.9, height: height*0.05)
        instructions.text = "Start with $1,000 and try to get the highest return you can, buying and selling this mystery stock!"
        instructions.backgroundColor = UIColor.black
        instructions.textColor = UIColor.white
        instructions.font =  UIFont(name: "EBGaramond08-Regular", size: 15)
        instructions.numberOfLines = 0
        instructions.lineBreakMode = NSLineBreakMode.byWordWrapping
        instructions.textAlignment = .center
        self.view.addSubview(instructions)
        
        priceLabel.frame = CGRect(x: width*0.05, y: height*0.22, width: width*0.55, height: height*0.075)
        priceLabel.text = "Price:  $\(String(format: "%.2f", priceArr[0]))"
        priceLabel.backgroundColor = UIColor.black
        priceLabel.textColor = UIColor.white
        priceLabel.font =  UIFont(name: "EBGaramond08-Regular", size: 35)
        priceLabel.textAlignment = .center
        self.view.addSubview(priceLabel) 
        
        changeLabel.frame = CGRect(x: width*0.625, y: height*0.225, width: width*0.3, height: height*0.065)
        changeLabel.text = "(0.00%)"
        changeLabel.backgroundColor = UIColor.black
        changeLabel.textColor = UIColor.white
        changeLabel.font =  UIFont(name: "EBGaramond08-Regular", size: 33)
        changeLabel.textAlignment = .center
        changeLabel.layer.cornerRadius = 5
        changeLabel.clipsToBounds = true
        self.view.addSubview(changeLabel)
        
        dayLabel.frame = CGRect(x: width*0.05, y: height*0.295, width: width*0.2, height: height*0.05)
        dayLabel.text = "Day \(dayNum)"
        dayLabel.backgroundColor = UIColor.black
        dayLabel.textColor = UIColor.white
        dayLabel.font =  UIFont(name: "EBGaramond08-Regular", size: 18)
        dayLabel.textAlignment = .center
        self.view.addSubview(dayLabel)
        
        cashLabel.frame = CGRect(x: width*0.25, y: height*0.295, width: width*0.4, height: height*0.05)
        cashLabel.text = "Cash: $\(String(format: "%.2f", cashNum))"
        cashLabel.backgroundColor = UIColor.black
        cashLabel.textColor = UIColor.white
        cashLabel.font =  UIFont(name: "EBGaramond08-Regular", size: 18)
        cashLabel.textAlignment = .center
        self.view.addSubview(cashLabel)
        
        sharesLabel.frame = CGRect(x: width*0.65, y: height*0.295, width: width*0.3, height: height*0.05)
        sharesLabel.text = "Shares:  \(sharesOwned)"
        sharesLabel.backgroundColor = UIColor.black
        sharesLabel.textColor = UIColor.white
        sharesLabel.font =  UIFont(name: "EBGaramond08-Regular", size: 18)
        sharesLabel.textAlignment = .center
        self.view.addSubview(sharesLabel)
        
        for _ in 0...50 {
            advanceDay()
        }
        dayNum = 0
        dayLabel.text = "Day \(dayNum)"
        getCurrentChart()
        print("*** Start ***")
        graph.frame = CGRect(x: width*0.05, y: height*0.35, width: width*0.9, height: height*0.255)
        graph.layer.borderColor = UIColor.gray.cgColor
        graph.layer.borderWidth = 2
        self.view.addSubview(graph)
        firstAdvance = false
        
        buyButton.frame = CGRect(x: width*0.1, y: height*0.63, width: width*0.39, height: height*0.075)
        buyButton.backgroundColor = green
        buyButton.setTitle("Buy 5 Shares",for: .normal)
        setupButton(button: buyButton)
        
        buyAllButton.frame = CGRect(x: width*0.51, y: height*0.63, width: width*0.39, height: height*0.075)
        buyAllButton.backgroundColor = green
        buyAllButton.setTitle("All In",for: .normal)
        setupButton(button: buyAllButton)
        
        sellButton.frame = CGRect(x: width*0.1, y: height*0.72, width: width*0.39, height: height*0.075)
        sellButton.backgroundColor = red
        sellButton.setTitle("Sell 5 Shares",for: .normal)
        setupButton(button: sellButton)
        
        sellAllButton.frame = CGRect(x: width*0.51, y: height*0.72, width: width*0.39, height: height*0.075)
        sellAllButton.backgroundColor = red
        sellAllButton.setTitle("Cash Out",for: .normal)
        setupButton(button: sellAllButton)
        
        holdButton.frame = CGRect(x: width*0.1, y: height*0.81, width: width*0.8, height: height*0.075)
        holdButton.backgroundColor = UIColor.darkGray
        holdButton.setTitle("Next Day",for: .normal)
        setupButton(button: holdButton)
        advanceDay()
    }
    
    func getCurrentChart() {
        if firstAdvance {
            return
        }
        var temp = [Double]()
        for i in (priceArr.count - 31)...(priceArr.count - 1) {
            temp.append(priceArr[i])
        }
        let series = ChartSeries(temp)
        if (priceArr.last! >= priceArr[priceArr.count - 2]) {
            series.colors = (above: ChartColors.greenColor(), below: ChartColors.redColor(), zeroLevel: 0)
        } else {
            series.colors = (above: ChartColors.redColor(), below: ChartColors.redColor(), zeroLevel: 0)
        }
        series.area = true
        graph.add(series)
    }
    
    func setupButton(button: UIButton) {
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font =  UIFont(name: "EBGaramond08-Regular", size: 25)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.downsizeButton(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(self.upsizeButton(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(self.upsizeButton(_:)), for: .touchUpOutside)
        self.view.addSubview(button)
    }
    
    func loadHighScore() {
        let userDefaults = UserDefaults.standard
        let userHighScore = userDefaults.value(forKey: "highScore")
        if  userHighScore == nil {
            userDefaults.setValue(0.0, forKey: "highScore")
        } else {
            currentHighScore = userHighScore as! Double
        }
        highScoreLabel.setTitle("Highscore:   $\(String(format: "%.2f", currentHighScore))", for: .normal)
    }
    
    func checkHighScore() {
        let userDefaults = UserDefaults.standard
        let userHighScore = userDefaults.value(forKey: "highScore")
        if  userHighScore == nil {
            userDefaults.setValue(currentHighScore, forKey: "highScore")
        } else {
            if currentHighScore > userHighScore as! Double {
                userDefaults.setValue(currentHighScore, forKey: "highScore")
            }
        }
    }
    
    func generatePctChange() -> Double {
        if abs(trueValue - priceArr.last!) <= 0.75 {
            print("DIFFFFF: \(trueValue - priceArr.last!)")
            trueValue = Double(drand48() * 130) - 5
        }
        let trueDiffBool = (trueValue - priceArr.last!) / abs(trueValue - priceArr.last!)
        print("diffBool: \(trueDiffBool)")
        let towardsTrueValue = drand48() * 100
        if towardsTrueValue >= 60 {
            print("option1")
            return drand48() * 0.04 - 0.02
        } else if towardsTrueValue >= 7.5 {
            print("option2")
            return ((drand48() * 0.06) - 0.02) * trueDiffBool
        } else if towardsTrueValue >= 2.5 {
            print("option3")
            return abs(drand48() * 0.175 + 0.1) * trueDiffBool
        }
        print("option4")
        return abs(drand48() * 0.175 + 0.1) * trueDiffBool * -1
    }
    
    func advanceDay() {
        print()
        dayNum += 1
        var pctChange = 0.0
        if priceArr.count < 2 {
            pctChange = drand48() * 0.2 - 0.1
            priceArr.append(priceArr[0] * (1 + pctChange))
        } else {
            pctChange = generatePctChange()
            print("Last: \(priceArr.last!)")
            print("TRUEVALUE: \(trueValue)")
            if priceArr.last! >= 3 {
                priceArr.append(priceArr.last! * (1 + pctChange))
            } else {
                priceArr.append(priceArr.last! + (3 * (1 + pctChange)) )
            }
        }
        
        if (pctChange >= 0.0) {
            changeLabel.text = "+\(String(format: "%.2f", pctChange * 100))%"
            changeLabel.backgroundColor = green
        } else {
            changeLabel.text = "\(String(format: "%.2f", pctChange * 100))%"
            changeLabel.backgroundColor = red
        }
        priceLabel.text = "Price:  $\(String(format: "%.2f", priceArr.last!))"
        currentScore = priceArr.last! * Double(sharesOwned) + cashNum
        dayLabel.text = "Day \(dayNum)"
        if currentScore <= 0 {
            raiseLoseAlert()
            return
        }
        print(currentScore)
        if currentScore > currentHighScore {
            currentHighScore = currentScore
            highScoreLabel.setTitle("Highscore:   $\(String(format: "%.2f", currentHighScore))", for: .normal)
            checkHighScore()
        }
        graph.removeAllSeries()
        getCurrentChart()
    }
    
    func raiseLoseAlert() {
        let alert = UIAlertController(title: "You Lose!", message: "Your variant perception was not variant enough", preferredStyle: UIAlertControllerStyle.alert)
        /**alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.default, handler: { action in 
            //let menu = ViewController(nibName: nil, bundle: nil)
            //self.present(menu, animated: true, completion: nil)
        }))*/
        alert.addAction(UIAlertAction(title: "Play again", style: .default, handler: { action in
            switch action.style{
                
            case .default:
                let nextGame = GameController(nibName: nil, bundle: nil)
                self.present(nextGame, animated: false, completion: nil)
            
            case .cancel:
                print("cancel")
            
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetHighScoreAlert() {
        let alert = UIAlertController(title: "Reset Highscore?", message: "This cannot be undone", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { action in
            switch action.style{
                
            case .default:
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(0.0, forKey: "highScore")
                self.currentHighScore = 0.0
                self.highScoreLabel.setTitle("Highscore:   $\(String(format: "%.2f", self.currentHighScore))", for: .normal)
                let nextGame = GameController(nibName: nil, bundle: nil)
                self.present(nextGame, animated: false, completion: nil)
            
            case .cancel:
                print("cancel")
            
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        if sender === backButton {
            //quitGameAlert()
        } else if sender === highScoreLabel {
            resetHighScoreAlert()
        } else if sender === buyButton {
            let gain = 5 * priceArr.last!
            if (gain <= cashNum) {
                sharesOwned += 5
                cashNum -= gain
                self.cashLabel.text = "Cash: $\(String(format: "%.2f", cashNum))"
                self.sharesLabel.text = "Shares:  \(sharesOwned)"
            }
        } else if sender === buyAllButton {
            let sharesBought = Int((cashNum / priceArr.last!).rounded(.down))
            sharesOwned += sharesBought
            cashNum -= Double(sharesBought) * priceArr.last!
            self.cashLabel.text = "Cash: $\(String(format: "%.2f", cashNum))"
            self.sharesLabel.text = "Shares:  \(sharesOwned)"
        } else if sender === sellButton {
            let gain = 5 * priceArr.last!
            if (sharesOwned >= 5) {
                sharesOwned -= 5
                cashNum += gain
                self.cashLabel.text = "Cash: $\(String(format: "%.2f", cashNum))"
                self.sharesLabel.text = "Shares:  \(sharesOwned)"
            }
        } else if sender === sellAllButton {
            cashNum += Double(sharesOwned) * priceArr.last!
            sharesOwned = 0
            self.cashLabel.text = "Cash: $\(String(format: "%.2f", cashNum))"
            self.sharesLabel.text = "Shares:  \(sharesOwned)"
        } else if sender === holdButton {
            advanceDay()
        } else if sender === highScoreLabel {
            resetHighScoreAlert()
        }
    }  
    
    @objc func downsizeButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) })
    }
    
    @objc func upsizeButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) })
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

extension Int {
    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter
    }()

    var delimiter: String {
        return Int.numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}










