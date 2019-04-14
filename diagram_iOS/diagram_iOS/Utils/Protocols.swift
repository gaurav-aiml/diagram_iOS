//
// Protocols.swift
//  Main
//
//  Created by Gaurav Pai on 18/03/19.
//  Copyright © 2019 Gaurav Pai. All rights reserved.
//
import Foundation

protocol resizeDropzoneDelegate {
    func resizeDropZone()
}


protocol HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}
protocol menuControllerDelegate {
    
    func saveViewState()
    func saveViewStateAsNew()
    func takeScreenShot()
    func exportAsPDF()
    func moveToTrash()
    func listTrashItems()
    
}
 // end protocol AppDirectoryNames

protocol AppDirectoryNames {
    func documentsDirectoryURL() -> URL
    
    func inboxDirectoryURL() -> URL
    
    func libraryDirectoryURL() -> URL
    
    func tempDirectoryURL() -> URL
    
    func sharedDirectoryURL() -> URL?
    
    func applicationInSharedDirectoryURL() -> URL?
    
    func projectInSharedDirectoryURL() -> URL?
    
    func getURL(for directory: AppDirectories) -> URL
    
    func buildFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL
}

protocol AppFileStatusChecking
{
    func isWritable(file at: URL) -> Bool
    
    func isReadable(file at: URL) -> Bool
    
    func exists(file at: URL) -> Bool
}

protocol AppFileSystemMetaData
{
    func list(directory at: URL) -> [String]
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
}

protocol AppFileManipulation : AppDirectoryNames
{
    func createDirectory(at path: AppDirectories, withName name: String) -> Bool
    
    func createSharedDirectory(withName name: String) -> Bool
    
    func writeFile(containing: String, to path: URL, withName name: String) -> Bool
    
    func readFile(at path: AppDirectories, withName name: String) -> String
    
    func deleteFile(at path: AppDirectories, withName name: String) -> Bool
    
    func renameFile(at path: AppDirectories, with oldName: String, to newName: String) -> Bool
    
    func moveFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    
    func copyFile(withName name: String, inDirectory: AppDirectories, toDirectory directory: AppDirectories) -> Bool
    
    func changeFileExtension(withName name: String, inDirectory: AppDirectories, toNewExtension newExtension: String) -> Bool
}

protocol setTimeControllerDelegate {
    func setCountdown(with value : Double)
}
