//
//  processModel.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 19/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import Foundation
//import UIKit

enum sides:Int, Codable {
    //Changed the left from 4 to 0. while building new working arrow points
    case left = 0
    case top = 1
    case right = 2
    case bottom = 3
    case onArrow = 8
}

class helperDatabase {
    var idAndAny = [Int: Any]()
    var viewsAndData = [processView: uiViewData]()
    var views = [processView]()
    var arrowsAndData = [ArrowShape: arrowData]()
    var arrows = [ArrowShape]()
    
    func reset(){
        idAndAny.removeAll()
        viewsAndData.removeAll()
        views.removeAll()
        arrowsAndData.removeAll()
        arrows.removeAll()
    }
}

class entireData: Codable {
    var allViews = [uiViewData]()
    var allArrows = [arrowData]()
}

struct uiViewData: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    var shape: String
    var text: String
    var id: Int
    var leftID: Int
    var topID: Int
    var rightID: Int
    var bottomID: Int
}

struct lineData: Codable{
    //    var side: sides.RawValue
    var id: Int
    var isSrc: Bool
}

struct arrowData: Codable {
    var id: Int
    var circleID: Int
    var srcID: Int
    var dstID: Int
    var isExpanded: Bool
    var okText: String
    var timeText: String
}
