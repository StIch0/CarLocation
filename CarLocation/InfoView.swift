//
//  InfoView.swift
//  CarLocation
//
//  Created by Pavel Burdukovskii on 01/06/2018.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//

import Foundation
import UIKit
class InfoView : UIView{
    var modelLabel : UILabel!
    var photo : UIImageView!
    var buttonChoose : UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpView(){
         modelLabel = UILabel(frame: CGRect.init(x: 8, y: 8, width: frame.size.width - 16, height: 15))
         photo = UIImageView(frame: CGRect.init(x: modelLabel.frame.origin.x, y: modelLabel.frame.origin.y + modelLabel.frame.size.height + 3, width: frame.size.width/1.5, height: frame.size.height/1.5))
        
        buttonChoose = UIButton(frame: CGRect.init(x: photo.frame.origin.x, y: photo.frame.origin.y + photo.frame.size.height + 3, width: frame.size.width - 16, height: 30))
        addSubview(modelLabel)
        addSubview(photo)
        addSubview(buttonChoose)
    }
}
