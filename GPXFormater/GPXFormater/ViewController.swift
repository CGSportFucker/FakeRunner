//
//  ViewController.swift
//  GPXFormater
//
//  Created by FakeRunner on 2019/7/25.
//  Copyright © 2019 FakeRunner. All rights reserved.
//

import Cocoa

class ViewController : NSViewController,NSTextFieldDelegate {
    
    @IBOutlet weak var InputField: NSTextField!
    @IBOutlet weak var StatusLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InputField.delegate = self
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        
        if let filed : NSTextField = obj.object as! NSTextField {
            print(filed.stringValue)
            if isGpx(in: filed.stringValue){
                print("isGpx")
                
                let path = filed.stringValue
                
                filed.isEditable = false
                StatusLabel.stringValue = "         Now Patching..."
                filed.stringValue = ""
                
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: path){
                    do {
                        // Get the contents
                        let contents = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                        var contentsString = String(contents)
                        contentsString = deleteHead(of: contentsString)
                        contentsString = replaceTRKPT(of: contentsString)
                        contentsString = deleteELE(of: contentsString)
                        print(contentsString)
                        
                        do{
                            let url = URL(fileURLWithPath: path)
                            try contentsString.write(to: url, atomically: false, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                            
                            let answer = alertOfFileNotExist(question: "Patch finished", text: "all done, enjoy!")
                            
                            filed.isEditable = true
                            StatusLabel.stringValue = "Drag & Drop here to patch"
                            filed.stringValue = ""
                            
                        }catch {
                            print("some error occured while write to file")
                        }
                        
                        
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                }else{
                    
                    let answer = alertOfFileNotExist(question: "NO File exits in this path", text: "please type in the true path or drag in the existing file")
                    
                    filed.isEditable = true
                    StatusLabel.stringValue = "Drag & Drop here to patch"
                    filed.stringValue = ""
                }
                
            }
            
        }
        
        
    }
    
    func isGpx(in path : String) -> Bool {
        
        if path.count > 3 {
            let temp = path.suffix(3)
            if temp == "gpx"{
                return true
            }
        }
        
        
        return false
    }
    
    func alertOfFileNotExist(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    func deleteHead(of content : String) -> String{
        var count = 0
        var output = ""
        for char in content{
            
            if char.isNewline {
                count += 1
            }
            
            if count < 1 || count > 11 {
                output.append(char)
            }
            
        }
        
        output = deleteBack(of: output, maxCount: count-11)
//        print("\(count)")
        return output
    }
    
    func deleteBack(of content : String , maxCount : Int) -> String {
        var count = 0
        var output = ""
        for char in content{
            
            if char.isNewline {
                count += 1
            }
            
            if count < maxCount - 4 || count > maxCount - 3 {
                output.append(char)
            }
            
        }
        
        //        print("\(count)")
        return output
    }
    
    func replaceTRKPT (of content : String) -> String {
        var output = ""
        
        output = content.replacingOccurrences(of: "trkpt", with: "wpt")
        
        return output
    }
    
    func deleteELE(of content : String) -> String{
        var output = ""
        var count = 0
        for char in content {
            if char.isNewline == true {
                count += 1
            }
            
            if count%4 == 2 {
                
            }else{
                output.append(char)
            }
            
            
        }
        return output
    }
    
    
}
