/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 3
  Author: Ngo Ngoc Thinh
  ID: s3879364
  Created  date: 05/09/2024
  Last modified: 16/09/2024
  Acknowledgement:
     https://rmit.instructure.com/courses/138616/modules/items/6274581
     https://rmit.instructure.com/courses/138616/modules/items/6274582
     https://rmit.instructure.com/courses/138616/modules/items/6274583
     https://rmit.instructure.com/courses/138616/modules/items/6274584
     https://rmit.instructure.com/courses/138616/modules/items/6274585
     https://rmit.instructure.com/courses/138616/modules/items/6274586
     https://rmit.instructure.com/courses/138616/modules/items/6274588
     https://rmit.instructure.com/courses/138616/modules/items/6274589
     https://rmit.instructure.com/courses/138616/modules/items/6274590
     https://rmit.instructure.com/courses/138616/modules/items/6274591
     https://rmit.instructure.com/courses/138616/modules/items/6274592
     https://developer.apple.com/documentation/swift/
     https://developer.apple.com/documentation/swiftui/
*/

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
