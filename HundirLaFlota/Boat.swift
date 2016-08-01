//
//  Boat.swift
//  HundirLaFlota
//
//  Created by Alvaro Royo on 28/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation

protocol BoatDelegate {
    func boatHit(text:String, boatlong:Int)
}

class Boat {
    
    var delegate:BoatDelegate! = nil
    
    var positions:[Int] = Array()
    
    private var touches: Int = 0
    
    init(positions:[Int]){
        self.positions = positions
    }
    
    func isTouched(position:Int) -> Bool{
        var isTouched = false
        if self.positions.indexOf(position) >= 0 {
            isTouched = true
            self.touches += 1
            delegate.boatHit(String(format: "%i/%i",self.touches,self.positions.count), boatlong: self.positions.count)
        }
        return isTouched
    }
    
    func getLong() -> Int{
        return self.positions.count
    }
    
    func setPositions(positions:[Int]){
        self.positions.removeAll()
        self.positions = positions
    }
    
    func haveColision(positions:[Int]) -> Bool{
        var colision = false
        for pos in positions{
            if self.positions.indexOf(pos) >= 0 {
                colision = true
            }
        }
        return colision
    }
    
}