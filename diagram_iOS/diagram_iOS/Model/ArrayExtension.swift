//
//  ArrayExtension.swift
//  Main
//
//  Created by Gaurav Pai on 22/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import Darwin

extension Array{
    mutating func removeObjFromArray<U: Equatable>(object: U){
        var index: Int?
        for (idx, objectToCompare) in self.enumerated(){
            if let to = objectToCompare as? U{
                if object == to{
                    index = idx
                }
            }
        }
        
        if index != nil {
            self.remove(at: index!)
        }
    }
    
    
    
    func checkIndex(num: Int) -> Bool{
        if 0 <= num && num < count{
            return true
        }
        else{
            return false
        }
    }
    
    
}
