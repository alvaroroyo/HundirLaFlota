//
//  Player.swift
//  HundirLaFlota
//
//  Created by Alvaro Royo on 28/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum BoatsEvents {
    case Touched
    case Water
    case NoShot
}

protocol PlayerDelegate {
    func shotResult(position:Int, event:BoatsEvents)
    func finishTurn(forPlayer:Int)
    func gameWon(player:Player)
}

class Player: UIView,BoatDelegate{
    
    var delegate:PlayerDelegate! = nil
    
    var player:AVAudioPlayer?
    
    private let myTurnView = UIView()
    private let oponentTurnView = UIView()
    
    var turn = false
    
    var name = "Player"
    
    var oponent:Player? = nil
    
    private var _boats:[Boat] = Array()
    var boats:[Boat]{
        get{
            return self._boats
        }
        set{
            self._boats = newValue
            for boat in newValue {
                boat.delegate = self
            }
        }
    }
    
    var enemyWater = 0
    
    private var _enemyTouched = 0
    var enemyTouched:Int{
        get{
            return self._enemyTouched
        }
        set{
            self._enemyTouched = newValue
            if newValue >= 20 {
                delegate.gameWon(self.oponent!)
            }
        }
    }
    
    var positions:[BoatsEvents] = Array()
    
    private var playerNumber = 0
    private var canShot = true
    
    //** My turn vars **//
    let waterShotLabel = UILabel()
    
    let boatsStatics = [ 2 : UILabel(), 3 : UILabel(), 4 : UILabel(), 5 : UILabel(), 6 : UILabel() ]
    
    //** Oponent turn vars **//
    
    let waterShotOponent = UILabel()
    let touchedShotOponent = UILabel()
    
    init(frame: CGRect, name:String, playerNumber:Int) {
        super.init(frame: frame)
        
        for _ in 0...99{
            self.positions.append(.NoShot)
        }
        
        self.playerNumber = playerNumber
        self.name = name
        
        self.myTurnView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.oponentTurnView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        
        self.addSubview(self.myTurnView)
        self.addSubview(self.oponentTurnView)
        
        let waterWidth = frame.size.width * 0.11
        
        let nameLabel = UILabel(frame: CGRectMake(12 + waterWidth,10,100,20))
        nameLabel.textColor = UIColor.colorWithHex("#848C8D", alpha: 1)
        nameLabel.text = self.name
        nameLabel.font = UIFont(name: "Cooper Black", size: 17)
        self.addSubview(nameLabel)
        
        //** MY TURN VIEW **//
        let waterView = UIView(frame: CGRectMake(6,6,waterWidth,waterWidth))
        waterView.backgroundColor = UIColor.colorWithHex("#00B8D4", alpha: 1)
        self.myTurnView.addSubview(waterView)
        
        self.waterShotLabel.frame = CGRectMake(0,-1,waterWidth,waterWidth)
        self.waterShotLabel.textColor = UIColor.whiteColor()
        self.waterShotLabel.textAlignment = .Center
        self.waterShotLabel.text = "0"
        self.waterShotLabel.font = UIFont(name: "Cooper Black", size: 17)
        waterView.addSubview(self.waterShotLabel)
        
        
        //BOATS IMAGES
        
        let maxHeight = frame.size.height * 0.7
        
        let boat6 = UIImageView(image: UIImage(named: "boat6.png"))
        boat6.frame = CGRectMake(0, 0, boat6.image!.size.width, maxHeight)
        boat6.contentMode = .ScaleAspectFit
        self.myTurnView.addSubview(boat6)
        
        let newImageWidth = (boat6.image?.size.width)! * maxHeight / (boat6.image?.size.height)!
        let boatHeight = { (newWidth:CGFloat, oldSize:CGSize) -> CGFloat in return newWidth * oldSize.height / oldSize.width }
        
        boat6.frame = CGRectMake(CGRectGetMaxX(frame) - newImageWidth - 20, (frame.size.height / 2) - (maxHeight / 2), newImageWidth, maxHeight)
        
        let boatsMargins = ((frame.size.width - 20) / 5) - newImageWidth
        
        let boat5 = UIImageView(image: UIImage(named: "boat5.png"))
        boat5.frame = CGRectMake(boat6.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(boat6.frame) - boatHeight(newImageWidth,boat5.image!.size), newImageWidth, boatHeight(newImageWidth,boat5.image!.size))
        boat5.contentMode = .ScaleAspectFit
        self.myTurnView.addSubview(boat5)
        
        let boat4 = UIImageView(image: UIImage(named: "boat4.png"))
        boat4.frame = CGRectMake(boat5.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(boat5.frame) - boatHeight(newImageWidth,boat4.image!.size), newImageWidth, boatHeight(newImageWidth,boat4.image!.size))
        boat4.contentMode = .ScaleAspectFit
        self.myTurnView.addSubview(boat4)
        
        let boat3 = UIImageView(image: UIImage(named: "boat3.png"))
        boat3.frame = CGRectMake(boat4.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(boat4.frame) - boatHeight(newImageWidth,boat3.image!.size), newImageWidth, boatHeight(newImageWidth,boat3.image!.size))
        boat3.contentMode = .ScaleAspectFit
        self.myTurnView.addSubview(boat3)
        
        let boat2 = UIImageView(image: UIImage(named: "boat2.png"))
        boat2.frame = CGRectMake(boat3.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(boat3.frame) - boatHeight(newImageWidth,boat2.image!.size), newImageWidth, boatHeight(newImageWidth,boat2.image!.size))
        boat2.contentMode = .ScaleAspectFit
        self.myTurnView.addSubview(boat2)
        
        //Boats Statics
        let staticsHeight = (frame.size.height - maxHeight) / 2
        
        self.boatsStatics[2]!.frame = CGRectMake(boat2.frame.origin.x, boat2.frame.maxY, boat2.frame.size.width, staticsHeight)
        self.boatsStatics[2]!.textAlignment = .Center
        self.boatsStatics[2]!.text = "0/2"
        self.boatsStatics[2]!.font = UIFont(name: "Cooper Black", size: 12)
        self.myTurnView.addSubview(self.boatsStatics[2]!)
        
        self.boatsStatics[3]!.frame = CGRectMake(boat3.frame.origin.x, boat3.frame.maxY, boat3.frame.size.width, staticsHeight)
        self.boatsStatics[3]!.textAlignment = .Center
        self.boatsStatics[3]!.text = "0/3"
        self.boatsStatics[3]!.font = UIFont(name: "Cooper Black", size: 12)
        self.myTurnView.addSubview(self.boatsStatics[3]!)
        
        self.boatsStatics[4]!.frame = CGRectMake(boat4.frame.origin.x, boat4.frame.maxY, boat4.frame.size.width, staticsHeight)
        self.boatsStatics[4]!.textAlignment = .Center
        self.boatsStatics[4]!.text = "0/4"
        self.boatsStatics[4]!.font = UIFont(name: "Cooper Black", size: 12)
        self.myTurnView.addSubview(self.boatsStatics[4]!)
        
        self.boatsStatics[5]!.frame = CGRectMake(boat5.frame.origin.x, boat5.frame.maxY, boat5.frame.size.width, staticsHeight)
        self.boatsStatics[5]!.textAlignment = .Center
        self.boatsStatics[5]!.text = "0/5"
        self.boatsStatics[5]!.font = UIFont(name: "Cooper Black", size: 12)
        self.myTurnView.addSubview(self.boatsStatics[5]!)
        
        self.boatsStatics[6]!.frame = CGRectMake(boat6.frame.origin.x + 5, boat6.frame.maxY, boat6.frame.size.width, staticsHeight)
        self.boatsStatics[6]!.textAlignment = .Center
        self.boatsStatics[6]!.text = "0/6"
        self.boatsStatics[6]!.font = UIFont(name: "Cooper Black", size: 12)
        self.myTurnView.addSubview(self.boatsStatics[6]!)
        
        //**************** Debug
//        self.myTurnView.hidden = true
        
        //** OPONENT TURN VIEW **//
        
        let squareMargin = (frame.size.width - (frame.size.height * 0.33 * 2)) / 3
        
        let waterShotOponent = UIView(frame: CGRectMake(squareMargin,0,frame.size.height * 0.33, frame.size.height * 0.33))
        waterShotOponent.backgroundColor = UIColor.colorWithHex("#00B8D4", alpha: 1)
        waterShotOponent.center = CGPointMake(waterShotOponent.center.x, self.oponentTurnView.center.y + 10)
        self.oponentTurnView.addSubview(waterShotOponent)
        
        let shotOponent = UIView(frame: CGRectMake(waterShotOponent.frame.maxX + squareMargin,0,frame.size.height * 0.33, frame.size.height * 0.33))
        shotOponent.backgroundColor = UIColor.colorWithHex("#D32F2F", alpha: 1)
        shotOponent.center = CGPointMake(shotOponent.center.x, self.oponentTurnView.center.y + 10)
        self.oponentTurnView.addSubview(shotOponent)
        
        //Text labels
        
        let watersOponentLabel = UILabel(frame: CGRectMake(waterShotOponent.frame.minX, waterShotOponent.frame.minY - 20, waterShotOponent.frame.size.width, 20))
        watersOponentLabel.textAlignment = .Center
        watersOponentLabel.text = "Waters"
        watersOponentLabel.font = UIFont(name: "Cooper Black", size: 10)
        self.oponentTurnView.addSubview(watersOponentLabel)
        
        let shotsOponentLabel = UILabel(frame: CGRectMake(shotOponent.frame.minX, shotOponent.frame.minY - 20, shotOponent.frame.size.width, 20))
        shotsOponentLabel.textAlignment = .Center
        shotsOponentLabel.text = "Touched"
        shotsOponentLabel.font = UIFont(name: "Cooper Black", size: 10)
        self.oponentTurnView.addSubview(shotsOponentLabel)
        
        self.waterShotOponent.frame = CGRectMake(0, 0, waterShotOponent.frame.width, waterShotOponent.frame.height)
        self.waterShotOponent.text = "0"
        self.waterShotOponent.textAlignment = .Center
        self.waterShotOponent.textColor = UIColor.whiteColor()
        self.waterShotOponent.font = UIFont(name: "Cooper Black", size: 20)
        waterShotOponent.addSubview(self.waterShotOponent)
        
        self.touchedShotOponent.frame = CGRectMake(0, 0, waterShotOponent.frame.width, waterShotOponent.frame.height)
        self.touchedShotOponent.text = "0"
        self.touchedShotOponent.textAlignment = .Center
        self.touchedShotOponent.textColor = UIColor.whiteColor()
        self.touchedShotOponent.font = UIFont(name: "Cooper Black", size: 20)
        shotOponent.addSubview(self.touchedShotOponent)
        
        //**************** Debug
        self.oponentTurnView.hidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //** Functions **//
    
    func changeTurn(){
        self.turn = !self.turn
        self.myTurnView.hidden = self.turn ? false : true
        self.oponentTurnView.hidden = self.turn ? true : false
    }
    
    func changeTurn(turn:Bool){
        self.turn = turn
        self.myTurnView.hidden = self.turn ? false : true
        self.oponentTurnView.hidden = self.turn ? true : false
    }
    
    func newGameReset(){
        self.boats.removeAll()
        self.positions.removeAll()
        self.enemyWater = 0
        self.enemyTouched = 0
        self.waterShotOponent.text = "0"
        self.waterShotLabel.text = "0"
        self.touchedShotOponent.text = "0"
        for _ in 0...99{
            self.positions.append(.NoShot)
        }
        for i in 2...6{
            self.boatsStatics[i]?.text = String(format: "0/%i",i)
        }
    }
    
    func shot(position:Int){
        //Shot logic
        if self.oponent!.positions[position] == .NoShot && self.canShot {
            var isTouched = false
            for boat in self.boats{
                if boat.isTouched(position) {
                    isTouched = true
                    break
                }
            }
            self.oponent!.positions[position] = isTouched ? .Touched : .Water
            delegate.shotResult(position, event: isTouched ? .Touched : .Water)
            playSound(isTouched ? .Touched : .Water)
            if isTouched == false {
                self.enemyWater += 1
                self.waterShotOponent.text = String(format: "%i",self.enemyWater)
                self.waterShotLabel.text = String(format: "%i",self.enemyWater)
                self.canShot = false
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(delegateTimer), userInfo: nil, repeats: false)
            }
        }
    }
    
    private func playSound(event:BoatsEvents){
        let audio_path = NSBundle.mainBundle().pathForResource(event == .Touched ? "bomb" : "water" , ofType: "wav")
        let audio_file = NSURL(fileURLWithPath: audio_path!)
        
        do{
            player = try AVAudioPlayer(contentsOfURL: audio_file)
            guard let player = player else {return}
            player.prepareToPlay()
            player.play()
        }catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func delegateTimer(){
        self.canShot = true
        self.delegate.finishTurn(self.playerNumber)
    }
    
    //** BOAT DELEGATE **//
    func boatHit(text: String, boatlong: Int) {
        self.boatsStatics[boatlong]?.text = text
        self.enemyTouched += 1
        self.touchedShotOponent.text = String(format: "%i",self.enemyTouched)
    }
    
}