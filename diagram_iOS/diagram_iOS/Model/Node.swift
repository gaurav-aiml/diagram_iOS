//
//  Node.swift
//  Main
//
//  Created by Gaurav Pai on 22/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import Foundation

class Node: NSObject
{
    
    //MARK:- Properties
    private var realType: BlockType = .Free
    var x = 0
    var y = 0
    
    var g = -100
    var h = -100
    var f: Int{get{return g+h}}
    
    var previous: Node!
    var type: BlockType
    {
        get{return realType}
        set{realType = newValue}
    }
}
