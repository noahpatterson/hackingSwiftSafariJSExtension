//
//  ActionViewController.swift
//  Extension
//
//  Created by Noah Patterson on 12/20/16.
//  Copyright © 2016 noahpatterson. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavascript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavascript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavascript]
        
        extensionContext!.completeRequest(returningItems: [item])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //when the extension is created, the extensionContext allows us to control how it interacts with the parent app.
        //inputItems = array of data parent apps sends
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                //ask the provider to load a item aysnchranously
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    // ask for the dict provided by the itemProvider and any errors if they occured
                    [unowned self] (dict, error) in
                    //do stuff
                    let itemDictionary = dict as! NSDictionary
                    let javascriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
//                    print(javascriptValues)
                    
                    self.pageTitle = javascriptValues["title"] as! String
                    self.pageURL   = javascriptValues["URL"] as! String
                    
                    DispatchQueue.main.async {
                        self.title = self.pageTitle
                    }
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        //handle changes to keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }

    func adjustForKeyboard(notification: Notification) {
        //my attempt
        /*if let frameNSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let frame = frameNSValue.cgRectValue
            let convertedFrame = view.convert(frame, from: view.window)
            script.contentInset.bottom = convertedFrame.height
            script.scrollIndicatorInsets.bottom = convertedFrame.height
            
            let selectedRange = script.selectedRange
            script.scrollRangeToVisible(selectedRange)
            
        }*/
        
        //book code
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame   = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            script.contentInset = UIEdgeInsets.zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
