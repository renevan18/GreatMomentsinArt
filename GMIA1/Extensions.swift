//
//  Extensions.swift
//  GMIA1
//
//  Created by Sam Ritchie on 22/1/19.
//  Copyright © 2019 Rene Van Meeuwen. All rights reserved.
//

import UIKit

extension CGSize {
    func toPortrait() -> CGSize {
        if height >= width {
            return self
        } else {
            return CGSize(width: height, height: width)
        }
    }
    
    func toLandscape() -> CGSize {
        if height <= width {
            return self
        } else {
            return CGSize(width: height, height: width)
        }
    }
}
