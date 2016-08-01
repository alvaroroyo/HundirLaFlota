//
//  ViewController.swift
//  HundirLaFlota
//
//  Created by Alvaro Royo on 28/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,TableDelegate,PanelDelegate {

    var panel:Panel? = nil
    var table:Table? = nil
    
    var player: Player? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panel = Panel(frame: CGRectMake(0,0, self.view.frame.size.width - self.view.frame.size.height, self.view.frame.size.height))
        self.panel?.delegate = self
        
        self.table = Table(frame: CGRectMake(CGRectGetMaxX((self.panel?.frame)!),0,self.view.frame.size.height,self.view.frame.size.height))
        self.table?.delegate = self
        
        self.view.addSubview(self.panel!)
        self.view.addSubview(self.table!)
        
    }
    
    //** TABLE DELEGATE **//
    
    func tableClick(position: Int) {
        if let player = self.player {
            player.oponent!.shot(position)
        }
    }
    
    //** PANEL DELEGATE **//
    
    func startNewGame() {
        self.table?.delegate = self
    }
    
    func turnFor(player: Player) {
        self.player = player
        self.table?.clearTable()
        self.table?.setTable(player)
        
        let turnLabel = UILabel(frame: self.view.frame)
        turnLabel.textAlignment = .Center
        turnLabel.text = String(format: "Turn for %@",player.name)
        turnLabel.font = UIFont(name: "Cooper Black", size: 45)
        self.view.addSubview(turnLabel)
        
        turnLabel.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(2.5) {
            turnLabel.transform = CGAffineTransformMakeScale(1, 1)
            turnLabel.alpha = 0
        }
    }
    
    func shotResult(position: Int, event: BoatsEvents) {
        self.table?.drawShotResult(position, event: event)
    }
    
    func gameWon(player: Player) {
        self.table?.gameWon(player)
    }
    
}

