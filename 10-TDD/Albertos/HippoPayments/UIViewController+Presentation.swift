//
//  UIViewController+Presentation.swift
//  HippoPayments
//
//  Created by Jungman Bae on 4/18/25.
//

import UIKit

extension UIViewController {

  /// Travels the `presentedViewController` hierarchy backwards till it finds the topmost one.
  var viewControllerPresentationSource: UIViewController {
    guard let presentedViewController = self.presentedViewController else { return self }

    return presentedViewController.viewControllerPresentationSource
  }
}
