//
//  NewGame.swift
//  HundirLaFlota
//
//  Created by Alvaro Royo on 29/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit

protocol NewGameDelegate {
    func setPlayer(player:Int, boatsPositions:[Boat])
}

class NewGame: UIView,TableDelegate {
    
    private let settingNewGame = true
    
    private var boats = [2:UIImageView(),3:UIImageView(),4:UIImageView(),5:UIImageView(),6:UIImageView()]
    
    private let playerTitle = UILabel()
    
    private var boatsPositions:[Boat] = Array()
    
    private var selectedBoat = 0
    private var horizontal = false
    
    private let nextBtn = UIButton()
    private let rotateBtn = UIButton()
    
    private var player = 1
    
    var delegate:NewGameDelegate! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Table.sharedInstance?.delegate = self
        
        let blurEffect = UIBlurEffect(style: .Light)
        let newGame = UIVisualEffectView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        newGame.effect = blurEffect
        self.addSubview(newGame)
        
        let newGameLabel = UILabel(frame: CGRectMake(0,0,newGame.frame.size.width,25))
        newGameLabel.text = "New Game"
        newGameLabel.font = UIFont(name: "Cooper Black", size: 24)
        newGameLabel.textAlignment = .Center
        self.addSubview(newGameLabel)
        
        self.playerTitle.frame = CGRectMake(10, newGameLabel.frame.maxY + 10, 70, 20)
        self.playerTitle.text = "Player 1"
        self.playerTitle.font = UIFont(name: "Cooper Black", size: 14)
        self.playerTitle.textColor = UIColor.colorWithHex("#848C8D", alpha: 1)
        self.playerTitle.textAlignment = .Center
        self.addSubview(self.playerTitle)
        
        let maxHeight = frame.size.height * 0.42
        
        self.boats[6]?.image = UIImage(named: "boat6.png")
        self.boats[6]?.frame = CGRectMake(0, 0, self.boats[6]!.image!.size.width, maxHeight)
        self.boats[6]?.contentMode = .ScaleAspectFit
        self.addSubview(self.boats[6]!)
        
        let newImageWidth = (self.boats[6]!.image?.size.width)! * maxHeight / (self.boats[6]!.image?.size.height)!
        let boatHeight = { (newWidth:CGFloat, oldSize:CGSize) -> CGFloat in return newWidth * oldSize.height / oldSize.width }
        let boatsMargins = (frame.size.width / 5) - newImageWidth
        
        self.boats[6]!.frame = CGRectMake(CGRectGetMaxX(frame) - newImageWidth - boatsMargins, newGameLabel.frame.maxY + 20, newImageWidth, maxHeight)
        
        self.boats[5]?.image = UIImage(named: "boat5.png")
        self.boats[5]?.frame = CGRectMake(self.boats[6]!.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(self.boats[6]!.frame) - boatHeight(newImageWidth,self.boats[5]!.image!.size), newImageWidth, boatHeight(newImageWidth,self.boats[5]!.image!.size))
        self.boats[5]?.contentMode = .ScaleAspectFit
        self.addSubview(self.boats[5]!)

        self.boats[4]?.image = UIImage(named: "boat4.png")
        self.boats[4]?.frame = CGRectMake(self.boats[5]!.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(self.boats[5]!.frame) - boatHeight(newImageWidth,self.boats[4]!.image!.size), newImageWidth, boatHeight(newImageWidth,self.boats[4]!.image!.size))
        self.boats[4]?.contentMode = .ScaleAspectFit
        self.addSubview(self.boats[4]!)

        self.boats[3]?.image = UIImage(named: "boat3.png")
        self.boats[3]?.frame = CGRectMake(self.boats[4]!.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(self.boats[4]!.frame) - boatHeight(newImageWidth,self.boats[3]!.image!.size), newImageWidth, boatHeight(newImageWidth,self.boats[3]!.image!.size))
        self.boats[3]?.contentMode = .ScaleAspectFit
        self.addSubview(self.boats[3]!)
        
        self.boats[2]?.image = UIImage(named: "boat2.png")
        self.boats[2]?.frame = CGRectMake(self.boats[3]!.frame.origin.x - newImageWidth - boatsMargins, CGRectGetMaxY(self.boats[3]!.frame) - boatHeight(newImageWidth,self.boats[2]!.image!.size), newImageWidth, boatHeight(newImageWidth,self.boats[2]!.image!.size))
        self.boats[2]?.contentMode = .ScaleAspectFit
        self.addSubview(self.boats[2]!)
        
        self.rotateBtn.frame = CGRectMake(0, 0, newImageWidth - 25, newImageWidth - 25)
        self.rotateBtn.setImage(UIImage(named: "rotate.png"), forState: .Normal)
        self.rotateBtn.hidden = true
        self.rotateBtn.addTarget(self, action: #selector(rotateBtnClick), forControlEvents: .TouchUpInside)
        self.addSubview(self.rotateBtn)
        
        let boat2Button = UIButton(frame: self.boats[2]!.frame)
        boat2Button.tag = 2
        boat2Button.addTarget(self, action: #selector(boatClick), forControlEvents: .TouchUpInside)
        self.addSubview(boat2Button)
        
        let boat3Button = UIButton(frame: self.boats[3]!.frame)
        boat3Button.tag = 3
        boat3Button.addTarget(self, action: #selector(boatClick), forControlEvents: .TouchUpInside)
        self.addSubview(boat3Button)
        
        let boat4Button = UIButton(frame: self.boats[4]!.frame)
        boat4Button.tag = 4
        boat4Button.addTarget(self, action: #selector(boatClick), forControlEvents: .TouchUpInside)
        self.addSubview(boat4Button)
        
        let boat5Button = UIButton(frame: self.boats[5]!.frame)
        boat5Button.tag = 5
        boat5Button.addTarget(self, action: #selector(boatClick), forControlEvents: .TouchUpInside)
        self.addSubview(boat5Button)
        
        let boat6Button = UIButton(frame: self.boats[6]!.frame)
        boat6Button.tag = 6
        boat6Button.addTarget(self, action: #selector(boatClick), forControlEvents: .TouchUpInside)
        self.addSubview(boat6Button)
        
        self.nextBtn.frame = CGRectMake(frame.maxX - 75, self.frame.maxY - 35, 65, 25)
        self.nextBtn.backgroundColor = UIColor.colorWithHex("#0091EA", alpha: 1)
        self.nextBtn.setTitle("Continue", forState: .Normal)
        self.nextBtn.layer.cornerRadius = 5
        self.nextBtn.layer.shadowColor = UIColor.blackColor().CGColor
        self.nextBtn.layer.shadowOffset = CGSizeMake(0, 3)
        self.nextBtn.layer.shadowOpacity = 0.5
        self.nextBtn.titleLabel?.font = UIFont(name: "Cooper Black", size: 12)
        self.nextBtn.addTarget(self, action: #selector(nextBtnClick), forControlEvents: .TouchUpInside)
        self.addSubview(self.nextBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func boatClick(sender:UIButton){
        self.horizontal = false
        self.rotateBtn.center = CGPoint(x: self.boats[sender.tag]!.center.x, y: self.boats[sender.tag]!.frame.maxY + self.rotateBtn.frame.size.width / 2 + 5)
        self.rotateBtn.hidden = false
        if self.selectedBoat != 0 {
            self.boats[self.selectedBoat]!.backgroundColor = UIColor.clearColor()
        }
        self.selectedBoat = sender.tag
        self.boats[sender.tag]!.backgroundColor = UIColor.colorWithHex("#FFB300", alpha: 1)
    }
    
    func rotateBtnClick(){
        self.horizontal = self.horizontal ? false : true
        self.boats[self.selectedBoat]!.backgroundColor = UIColor.colorWithHex(self.horizontal ? "#B8FCD6" : "#FFB300", alpha: 1)
    }
    
    private func canPutBoatIn(position:Int) -> (canPut:Bool,positions:[Int]){
        var canPut = true
        var positions:[Int] = [position]
        var pos = position
        
        if self.horizontal && position % 10 == 0 {
            return (false,positions)
        }
        
        for i in 2...self.selectedBoat{
            if self.horizontal{
                pos -= 1
            }else{
                pos += 10
            }
            if pos % 10 == 0 && self.horizontal && i < self.selectedBoat || pos > 99 {
                return (false,positions)
            }
            
            positions.append(pos)
        }
        
        for boat in self.boatsPositions{
            if boat.getLong() == self.selectedBoat {
                canPut = false
                boat.setPositions(positions)
                Table.sharedInstance?.removeBoat(boat.getLong())
                Table.sharedInstance?.putBoat(boat, horizontal: self.horizontal)
                break
            }else if boat.haveColision(positions) {
                return (false,positions)
            }
        }
        
        return (canPut,positions)
    }
    
    func nextBtnClick(){
        if self.boatsPositions.count == 5 {
            self.boats[self.selectedBoat]!.backgroundColor = UIColor.clearColor()
            self.delegate.setPlayer(self.player, boatsPositions: self.boatsPositions)
            Table.sharedInstance?.clearTable()
            if self.player == 1 {
                self.playerTitle.text = "Player 2"
                self.nextBtn.setTitle("Finish", forState: .Normal)
                self.boatsPositions.removeAll()
                self.player = 2
                self.selectedBoat = 0
            }
        }
    }
    
    //** TABLE DELAGATE **//
    
    func tableClick(position: Int) {
        if self.settingNewGame && self.selectedBoat > 0{
            let (canPut,positions) = canPutBoatIn(position)
            if canPut{
                let boat = Boat(positions: positions)
                self.boatsPositions.append(boat)
                Table.sharedInstance?.putBoat(boat, horizontal: self.horizontal)
            }
        }
    }
    
}