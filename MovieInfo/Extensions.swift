//
//  Extensions.swift
//  MovieInfo
//
//  Created by Syed Hashmi on 4/29/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
extension BehaviorRelay where Element: RangeReplaceableCollection {
    func acceptAppending(_ elements: [Element.Element]) {
        accept(value + elements)
    }
}
extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
   
}
}
