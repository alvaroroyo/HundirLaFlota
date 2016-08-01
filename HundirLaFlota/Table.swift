//
//  Table.swift
//  HundirLaFlota
//
//  Created by Alvaro Royo on 28/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit

protocol TableDelegate {
    func tableClick(position: Int)
}

class Table: UIView {
    
    static private(set) var sharedInstance: Table? = nil
    
    private var squares:[CGRect] = Array()
    
    private var separatorMargin:CGFloat = 0
    
    private let gameWonView = UIVisualEffectView()
    
    var delegate:TableDelegate! = nil
    
    private var gameFinished = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Table.sharedInstance = self
        
        self.backgroundColor = UIColor.colorWithHex("#00B8D4", alpha: 1)
        
        let separatorLineWidth = frame.size.width * 0.003
        
        self.separatorMargin = (frame.size.width) / 10
        
        for i in 1...9 {
            
            let sepVert = UIView(frame: CGRectMake(self.separatorMargin * CGFloat(i), 0, separatorLineWidth, self.frame.size.width))
            sepVert.backgroundColor = UIColor.colorWithHex("#B2DFDB", alpha: 1)
            
            let sepHori = UIView(frame: CGRectMake(0, self.separatorMargin * CGFloat(i), self.frame.size.width, separatorLineWidth))
            sepHori.backgroundColor = UIColor.colorWithHex("#B2DFDB", alpha: 1)
            
            self.addSubview(sepVert)
            self.addSubview(sepHori)
        }
        
        var row:CGFloat = 0
        var column:CGFloat = 0
        for i in 0...99{
            squares.append(CGRectMake(self.separatorMargin * column, self.separatorMargin * row, self.separatorMargin, self.separatorMargin))
            
            column += 1
            if (i + 1) % 10 == 0 {
                row += 1
                column = 0
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.addGestureRecognizer(tap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapGesture(sender:UITapGestureRecognizer? = nil){
        if self.gameFinished == false {
            if let tap = sender{
                let location = tap.locationInView(self)
            
                for i in 0...99{
                    if self.squares[i].contains(CGPointMake(location.x, location.y)){
                        delegate.tableClick(i)
                        break
                    }
                }
            
            }
        }
    }
    
    func putBoat(boat:Boat, horizontal:Bool){
        let point = self.squares[boat.positions[0]]
        let boatLong = boat.getLong()
        
        let boatImage = UIImageView(frame: CGRectMake(point.minX ,point.minY,self.separatorMargin, self.separatorMargin * CGFloat(boatLong) ))
        boatImage.image = UIImage(named: String(format: "boat%i.png",boatLong))
        boatImage.tag = boat.getLong()
        self.addSubview(boatImage)
        
        if horizontal {
            boatImage.layer.position = CGPointMake(point.minX + self.separatorMargin, point.minY)
            boatImage.layer.anchorPoint = CGPointMake(0, 0)
            boatImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        }
        
    }
    
    func removeBoat(long:Int){
        for subView in self.subviews{
            if subView.tag == long {
                subView.removeFromSuperview()
            }
        }
    }
    
    func clearTable(){
        self.gameFinished = false
        self.gameWonView.removeFromSuperview()
        for subView in self.subviews{
            if subView.tag == 2 || subView.tag == 3 || subView.tag == 4 || subView.tag == 5 || subView.tag == 6 || subView.tag == 33 {
                subView.removeFromSuperview()
            }
        }
    }
    
    func setTable(player:Player){
        for i in 0...99 {
            let boatEvent:BoatsEvents = player.positions[i]
            
            if boatEvent == .Water || boatEvent == .Touched {
                let shotResult = UIView(frame: self.squares[i])
                shotResult.tag = 33
                shotResult.backgroundColor = UIColor.colorWithHex(boatEvent == .Touched ? "#D32F2F" : "#B2DFDB", alpha: 1)
                self.addSubview(shotResult)
            }
        }
    }
    
    func drawShotResult(position:Int, event:BoatsEvents){
        let shotResult = UIView(frame: self.squares[position])
        shotResult.backgroundColor = UIColor.colorWithHex(event == .Touched ? "#D32F2F" : "#B2DFDB", alpha: 1)
        shotResult.tag = 33
        self.addSubview(shotResult)
        
        shotResult.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(0.3) {
            shotResult.transform = CGAffineTransformMakeScale(1, 1)
        }
        
    }
    
    func gameWon(player:Player){
        self.gameFinished = true
        
        self.gameWonView.frame = CGRectMake(0,0, self.frame.width, self.frame.height)
        self.gameWonView.effect = UIBlurEffect(style: .Light)
        self.addSubview(self.gameWonView)
        
        self.bringSubviewToFront(self.gameWonView)
        
        let playerWon = UILabel(frame: self.gameWonView.frame)
        playerWon.textAlignment = .Center
        playerWon.text = String(format: "%@ won!",player.name)
        playerWon.font = UIFont(name: "Cooper Black", size: 25)
        self.gameWonView.addSubview(playerWon)
        
        playerWon.transform = CGAffineTransformMakeScale(0, 0)
        playerWon.alpha = 0
        UIView.animateWithDuration(2.5, animations: { 
            playerWon.transform = CGAffineTransformMakeScale(1, 1)
            playerWon.alpha = 1
            }) { (true) in
                self.bringSubviewToFront(self.gameWonView)
        }
    }
    
}