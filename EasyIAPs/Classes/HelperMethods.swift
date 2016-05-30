//
//  HelperMethods.swift
//  Pods
//
//  Created by Alvin Varghese on 5/30/16.
//
//

import Foundation
import UIKit

//MARK: Check current platform

struct Platform {
    static let isSimulator : Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}