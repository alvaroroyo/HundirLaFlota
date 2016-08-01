//
//  Panel.swift
//  HundirLaFlota
//
//  Created by Alvaro Royo on 28/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit

protocol PanelDelegate {
    func startNewGame()
    func turnFor(player:Player)
    func shotResult(position:Int, event: BoatsEvents)
    func gameWon(player:Player)
}

class Panel: UIView,NewGameDelegate,PlayerDelegate {
    
    var delegate:PanelDelegate! = nil
    
    private var newGameView:NewGame? = nil
    
    private let turnPlayer1 = UIView()
    private let turnPlayer2 = UIView()
    
    private var player1: Player? = nil
    private var player2: Player? = nil
    
    private var turn = ("#D32F2F","#64DD17")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        super.backgroundColor = UIColor.colorWithHex("#FFE082", alpha: 1)
        
        let newGameBtn = UIButton(frame: CGRectMake(0,CGRectGetMaxY(frame) - frame.size.height * 0.1, frame.size.width, frame.size.height * 0.1))
        newGameBtn.backgroundColor = UIColor.colorWithHex("#FFB300", alpha: 1)
        newGameBtn.setTitle("New Game", forState: .Normal)
        newGameBtn.titleLabel?.font = UIFont(name: "Cooper Black", size: 20)
        newGameBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        newGameBtn.addTarget(self, action: #selector(newGameClick), forControlEvents: .TouchUpInside)
        self.addSubview(newGameBtn)
        
        let playersContent = UIView(frame: CGRectMake(0,0,frame.size.width,frame.size.height - newGameBtn.frame.size.height))
        self.addSubview(playersContent)
        
        let sepWith = frame.size.width * 0.007
        
        let turnContent = UIView(frame: CGRectMake(CGRectGetMaxX(frame) - frame.size.width * 0.06, 0, frame.size.width * 0.06, frame.size.height * 0.1))
        turnContent.layer.borderColor = UIColor.blackColor().CGColor
        turnContent.layer.borderWidth = sepWith
        turnContent.center = CGPointMake(turnContent.center.x, playersContent.center.y)
        playersContent.addSubview(turnContent)
        
        let sepLine = UIView(frame: CGRectMake(0,0,frame.size.width - turnContent.frame.size.width, sepWith))
        sepLine.backgroundColor = UIColor.blackColor()
        sepLine.center = CGPointMake(sepLine.center.x, turnContent.center.y)
        playersContent.addSubview(sepLine)
        
        turnPlayer1.frame = CGRectMake(0,0, turnContent.frame.size.width, turnContent.frame.size.height / 2)
        turnPlayer1.backgroundColor = UIColor.greenColor()
        
        turnPlayer2.frame = CGRectMake(0, CGRectGetMaxY(turnPlayer1.frame), turnContent.frame.size.width, turnContent.frame.size.height / 2)
        turnPlayer2.backgroundColor = UIColor.redColor()
        
        turnContent.addSubview(turnPlayer1)
        turnContent.addSubview(turnPlayer2)
        
        self.player1 = Player(frame: CGRectMake(0, 0, frame.size.width, playersContent.frame.size.height / 2), name: "Player 1", playerNumber: 1)
        self.player1?.delegate = self
        playersContent.addSubview(self.player1!)
        
        self.player2 = Player(frame: CGRectMake(0, CGRectGetMaxY(self.player1!.frame), frame.size.width, playersContent.frame.size.height / 2), name: "Player 2", playerNumber: 2)
        self.player2?.delegate = self
        self.player1?.oponent = self.player2
        self.player2?.oponent = self.player1
        playersContent.addSubview(self.player2!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newGameClick(sender:UIButton){
        Table.sharedInstance?.clearTable()
        //Reset players
        self.player1?.newGameReset()
        self.player2?.newGameReset()
        
        if let oldNewGameView = self.newGameView {
            oldNewGameView.removeFromSuperview()
        }
        
        self.newGameView = NewGame(frame: CGRectMake(0,0,self.frame.width,frame.height - frame.size.height * 0.1))
        self.newGameView?.delegate = self
        self.addSubview(self.newGameView!)
    }
    
    func changeTurn(){
        turnPlayer1.backgroundColor = UIColor.colorWithHex(turn.0, alpha: 1)
        turnPlayer2.backgroundColor = UIColor.colorWithHex(turn.1, alpha: 1)
        let color = turn.0
        turn.0 = turn.1
        turn.1 = color
    }
    
    func changeTurnFor(player:Int){
        if(player == 1){
            if(self.turn.0 != "#D32F2F"){
                changeTurn()
            }
            self.player1?.changeTurn(true)
            self.player2?.changeTurn(false)
            self.delegate.turnFor(self.player1!)
        }else{
            if(self.turn.1 != "#D32F2F"){
                changeTurn()
            }
            self.player1?.changeTurn(false)
            self.player2?.changeTurn(true)
            self.delegate.turnFor(self.player2!)
        }
    }
    
    //** NEW GAME DELEGATE **//
    func setPlayer(player: Int, boatsPositions: [Boat]) {
        switch player {
        case 1:
            self.player1?.boats = boatsPositions
            break
        case 2:
            self.player2?.boats = boatsPositions
            
            //Remove from superview
            self.newGameView?.removeFromSuperview()
            
            changeTurnFor(Int(arc4random_uniform(100)) < 50 ? 1 : 2)
            
            self.delegate.startNewGame()
            
            break
        default:
            break
        }
    }
    
    //** PLAYER DELEGATE **//
    func shotResult(position: Int, event: BoatsEvents) {
        self.delegate.shotResult(position, event: event)
    }
    
    func finishTurn(forPlayer: Int) {
        changeTurnFor(forPlayer)
    }
    
    func gameWon(player: Player) {
        self.delegate.gameWon(player)
    }
    
}