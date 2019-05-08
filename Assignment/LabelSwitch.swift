//
//  LabelSwitch.swift
//  Assignment
//
//  Created by Ellen Wang on 2019/2/19.
//  Copyright © 2019 ellen. All rights reserved.
//


import UIKit

class LabelSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.TintColor = .black
        self.onTintColor = .Mainblue()
        self.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @obj fileprivate func handleSwitch(){
        if self.isOn {
            print("ON")
        } else {
            print("OFF")
        }
    }
}
