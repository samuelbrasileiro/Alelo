//
//  UIViewController+showError.swift
//  Core
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Service
import UIKit

public extension UIViewController {
    func showError(_ error: Error) {
        let error = ServiceError.map(error)
        let dialogMessage = UIAlertController(title: error.errorDescription,
                                              message: error.failureReason,
                                              preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK",
                               style: .default,
                               handler: { (action) -> Void in
            dialogMessage.dismiss(animated: true)
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true)
    }
}
