//
//  ViewController.swift
//  Powerups
//
//  Created by Sean Orelli on 11/1/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

}

class DemoController: TableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        func addItem(title: String, controller:ViewController){
            let item = add(tableItem: title)
            item.selectedAction = { [unowned self] in
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        addItem(title: "Camera", controller: CameraController())

        addItem(title: "Map", controller: MapController())
        addItem(title: "Sprite", controller: SpriteController())
        addItem(title: "Scene", controller: SceneController())
        addItem(title: "Bluetooth", controller: BluetoothController())
        addItem(title: "NFC", controller: NFCController())

        addItem(title: "Collection", controller: Demo2Controller())

        add(tableItem: "Session")

/*
        add(tableItem: "Session")
        add(tableItem: "Image")

        add(tableItem: "Alerts")
        add(tableItem: "Dates")
        add(tableItem: "Pin")
        add(tableItem: "Colors")
        add(tableItem: "Fonts")
        add(tableItem: "Image")
        add(tableItem: "Camera")
        add(tableItem: "Location")
        add(tableItem: "Bluetooth")
        add(tableItem: "NFC")
        add(tableItem: "Gyroscope")
        add(tableItem: "CoreData")
        add(tableItem: "Cloudkit")*/

    }


}

class Demo2Controller: CollectionController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        add(collectionItem: "Alerts")
    }
    
    
}

