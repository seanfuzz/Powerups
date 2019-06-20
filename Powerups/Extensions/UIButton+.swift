//
// Created by Andrew Grosner on 2018-09-13.
// Copyright (c) 2018 Fuzz. All rights reserved.
//

import Foundation
import UIKit

class Action
{
    var index:Int
    var block:Block
    
    init(index:Int, block: @escaping Block)
    {
        self.index = index
        self.block = block
    }
}



extension UIButton
{
    /* __________________________________________
     
                Touch Up and Down
     
     are not yet cancellable
     there will only be one
     associated block for each
     __________________________________________*/
    @objc private func doTouchUp()
    {
        touchUpActions.forEach { $0.block() }
    }
    
    private var touchUpActions:[Action]
    {
        get
        {
            if let actions:[Action] = associatedValue("touchUpActions")
            {
                return actions
            }else
            {
                addTarget(self, action: #selector(doTouchUp), for: .touchUpInside)
                let actions = [Action]()
                associatedObjects["touchUpActions"] = actions
                return actions
            }
        }
        
        set(a)
        {
            associatedObjects["touchUpActions"] = a
        }
    }
    
    @discardableResult
    func touchUp( _ action: @escaping Block) -> Action
    {
        let  a = Action(index: touchUpActions.count, block: action)
        touchUpActions.append(a)
        return a
    }
    
    func removeAllTouchUps()
    {
        touchUpActions.removeAll()
    }
    
    func removeTouchUp(action:Action)
    {
        var actions = touchUpActions
        if action.index < actions.count
        {
            actions.remove(at: action.index)
            for i in 0..<actions.count
            {
                actions[i].index = i
            }
            touchUpActions = actions
        }
    }
    

    @objc private func doTouchDown()
    {
        touchDownActions.forEach { $0.block() }
    }
    
    private var touchDownActions:[Action]
    {
        get
        {
            if let actions:[Action] = associatedValue("touchDownActions")
            {
                return actions
            }else
            {
                addTarget(self, action: #selector(doTouchDown), for: .touchDown)
                let actions = [Action]()
                associatedObjects["touchDownActions"] = actions
                return actions
            }
        }
        
        set(a)
        {
            associatedObjects["touchDownActions"] = a
        }
    }
    

    
    @discardableResult
    func touchDown( _ action: @escaping Block) -> Action
    {
        let  a = Action(index: touchDownActions.count, block: action)
        touchDownActions.append(a)
        return a
    }

}

//----------------------------------------




//----------------------------------------
extension UIButton
{
    var title: String?
    {
        get { return titleLabel?.text }
        set(t) { setTitle(t, for: .normal)}
    }
    
    func setBackgroundColor(_ color: UIColor) {
        let image = UIImage(color: color, size: CGSize(width: 1, height: 1))
        setBackgroundImage(image, for: .normal)
    }
    
    func solidBlueButton() {
        setBackgroundImage(nil, for: .normal)
        backgroundColor = .blinkWave
        layer.cornerRadius = 5.0
        layer.borderColor = .none
        layer.borderWidth = 0.0
        setTitleColor(.white, for: .normal)
        setTitleColor(.inputGray, for: .disabled)
        titleLabel?.font = .mediumBoldLight
    }
    
    func outlineButton() {
        backgroundColor = .clear
        let image = UIImage(color: .blackHaze, size: CGSize(width: 1, height: 1))
        setBackgroundImage(image, for: .normal)
        layer.borderWidth = 3.0
        layer.cornerRadius = 5.0
        clipsToBounds = true
        layer.borderColor = UIColor.blinkWave.cgColor
        setTitleColor(.blinkWave, for: .normal)
        setTitleColor(.inputGray, for: .disabled)
        titleLabel?.font = .mediumBoldBlue
    }
    
    // New button
    func solidBlueButton2() {
        setBackgroundImage(nil, for: .normal)
        backgroundColor = .wave
        layer.cornerRadius = 25.0
        layer.borderColor = .none
        layer.borderWidth = 0.0
        setTitleColor(.white, for: .normal)
        setTitleColor(.inputGray, for: .disabled)
        titleLabel?.font = .buttonWhite
    }
    
    // New button
    func whiteOutlineButton() {
        backgroundColor = .clear
        layer.borderWidth = 1.0
        layer.cornerRadius = 25.0
        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .disabled)
        titleLabel?.font = .buttonBlue
    }
    
    // New button
    func blueOutlineButton() {
        backgroundColor = .clear
        layer.borderWidth = 1.0
        layer.cornerRadius = 25.0
        clipsToBounds = true
        layer.borderColor = UIColor.wave.cgColor
        setTitleColor(UIColor.wave, for: .normal)
        setTitleColor(UIColor.wave, for: .disabled)
        titleLabel?.font = .buttonBlue
    }
    
    func transparentButton() {
        backgroundColor = .clear
        layer.borderColor = .none
        layer.borderWidth = 0.0
        layer.cornerRadius = 0.0
        clipsToBounds = true
        setTitleColor(.wave, for: .normal)
        setTitleColor(.textDarkGray, for: .disabled)
        titleLabel?.font = .buttonBlue
    }
    
    func roundButton(radius: CGFloat, image: UIImage) {
        backgroundColor = .wave
        cornerRadius = radius
        setImage(image, for: .normal)
    }
    
}
