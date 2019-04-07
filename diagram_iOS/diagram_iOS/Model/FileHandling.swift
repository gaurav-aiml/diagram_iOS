//
//  LandingPage.swift
//  diagram_iOS
//
//  Created by Gaurav Pai on 03/04/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//

import Foundation
import UIKit

enum AppDirectories: String {
    case Documents = "Documents"
    case Inbox = "Inbox"
    case Library = "Library"
    case Temp = "tmp"
}


struct FileHandling : AppFileManipulation, AppFileStatusChecking, AppFileSystemMetaData
{

    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func createNewProjectDirectory() -> Bool
    {
        if createDirectory(at: .Documents, withName: name)
        {
            print("Success")
            return true
        }
        print("Did not create directory")
        return false
    }
    
    func list() -> [String]
    {
        return list(directory: getURL(for: .Documents))
    }
    
    
    
    
}

extension AppDirectoryNames
{
    func documentsDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func inboxDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AppDirectories.Inbox.rawValue) // "Inbox")
    }
    
    func libraryDirectoryURL() -> URL
    {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask).first!
    }
    
    func tempDirectoryURL() -> URL
    {
        return FileManager.default.temporaryDirectory
        //urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(AppDirectories.Temp.rawValue) //"tmp")
    }
    
    func getURL(for directory: AppDirectories) -> URL
    {
        switch directory
        {
        case .Documents:
            return documentsDirectoryURL()
        case .Inbox:
            return inboxDirectoryURL()
        case .Library:
            return libraryDirectoryURL()
        case .Temp:
            return tempDirectoryURL()
        }
    }
    
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
    {
        return getURL(for: directory).appendingPathComponent(name)
    }
}




extension AppFileStatusChecking
{
    func isWritable(file at: URL) -> Bool
    {
        if FileManager.default.isWritableFile(atPath: at.path)
        {
            print(at.path)
            return true
        }
        else
        {
            print(at.path)
            return false
        }
    }
    
    func isReadable(file at: URL) -> Bool
    {
        if FileManager.default.isReadableFile(atPath: at.path)
        {
            print(at.path)
            return true
        }
        else
        {
            print(at.path)
            return false
        }
    }
    
    func exists(file at: URL) -> Bool
    {
        if FileManager.default.fileExists(atPath: at.path)
        {
            return true
        }
        else
        {
            return false
        }
    }
}



extension AppFileSystemMetaData
{
    func list(directory at: URL) -> [String]
    {
        let listing = try! FileManager.default.contentsOfDirectory(atPath: at.path)
        
        if listing.count > 0
        {
            print("\n----------------------------")
            print("LISTING: \(at.path)")
            print("")
            for file in listing
            {
                print("File: \(file.debugDescription)")
            }
            print("")
            print("----------------------------\n")
        }
        return listing
    }
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
    {
        return try! FileManager.default.attributesOfItem(atPath: atFullPath.path)
    }
}




extension AppFileManipulation
{
    
    
    func createDirectory(at path: AppDirectories, withName name: String) -> Bool
    {
        let directoryPath = getURL(for: path).path + "/" + name
        print(directoryPath)
        if !FileManager.default.fileExists(atPath: directoryPath)
        {
            do
            {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                return true
            }
            catch
            {
                NSLog("Path already exists. Choose a unique name for the Project")
            }
        }
        print("Directory already exists. Choose a unique name for the project")
        return false
    }
    func writeFile(containing: String, to path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data? = containing.data(using: .utf8)
        return FileManager.default.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }
    
    func readFile(at path: AppDirectories, withName name: String) -> String
    {
        let filePath = getURL(for: path).path + "/" + name
        let fileContents = FileManager.default.contents(atPath: filePath)
        let fileContentsAsString = String(bytes: fileContents!, encoding: .utf8)
        print(fileContentsAsString!)
        return fileContentsAsString!
    }
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    {
        let filePath = buildFullPath(forFileName: name, inDirectory: path)
        try! FileManager.default.removeItem(at: filePath)
        return true
    }
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    {
        let oldPath = getURL(for: path).appendingPathComponent(oldName)
        let newPath = getURL(for: path).appendingPathComponent(newName)
        try! FileManager.default.moveItem(at: oldPath, to: newPath)
        
        // highlights the limitations of using return values
        return true
    }
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name, inDirectory: directory)
        // warning: constant 'success' inferred to have type '()', which may be unexpected
        // let success =
        try! FileManager.default.moveItem(at: originURL, to: destinationURL)
        return true
    }
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name+"1", inDirectory: directory)
        try! FileManager.default.copyItem(at: originURL, to: destinationURL)
        return true
    }
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
    {
        var newFileName = NSString(string:name)
        newFileName = newFileName.deletingPathExtension as NSString
        newFileName = (newFileName.appendingPathExtension(newExtension) as NSString?)!
        let finalFileName:String =  String(newFileName)
        
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: finalFileName, inDirectory: inDirectory)
        
        try! FileManager.default.moveItem(at: originURL, to: destinationURL)
        
        return true
    }
}


