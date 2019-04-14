//
//  BottleneckFiles.swift
//  diagram_iOS
//
//  Created by Vishal Hosakere on 03/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import Foundation

class BottleneckFiles {
    
    var FilesArray = [(String, Int)]()
    
    init() {
        let directory = FileHandling(name: "")
        var DocumentDirURL = directory.getURL(for: .ProjectInShared)
//        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("notes.txt")
//        let fileURL2 = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("count.txt")
        
        let fileManager = FileManager.default
        let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: DocumentDirURL.path)!
        while let element = enumerator.nextObject() as? String {
            guard element.hasSuffix("count") else { continue }
            /*use the element here*/
            let fileURL = DocumentDirURL.appendingPathComponent(element)
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                let splitText = text.components(separatedBy: "$$")
                print(splitText)
                if splitText.count == 2{
                    FilesArray.append((String(splitText[0]), Int(splitText[1])!))
                }
            }
            catch {
                print("failed with error: \(error)")
            }
        }
        print(FilesArray.count)
    }
    
    
}
