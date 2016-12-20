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

    @IBOutlet weak var imageView: UIImageView!

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
                }
            }
        }
    }


}
