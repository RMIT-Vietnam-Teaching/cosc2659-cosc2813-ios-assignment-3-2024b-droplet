//
//  TopViewController.swift
//  pharmacist_project
//
//  Created by Thinh Ngo on 6/9/24.
//

import Foundation
import UIKit

final class TopViewControllerUtil {
    static let shared = TopViewControllerUtil()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
//        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        let controller = controller ?? UIApplication
                                        .shared
                                        .connectedScenes
                                        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                                        .last { $0.isKeyWindow }?.rootViewController
        
        if let nav = controller as? UINavigationController {
            return self.topViewController(controller: nav.visibleViewController)

        } else if let tab = controller as? UITabBarController, let selected = tab.selectedViewController {
            return self.topViewController(controller: selected)

        } else if let presented = controller?.presentedViewController {
            return self.topViewController(controller: presented)
        }
        return controller
    }
}
