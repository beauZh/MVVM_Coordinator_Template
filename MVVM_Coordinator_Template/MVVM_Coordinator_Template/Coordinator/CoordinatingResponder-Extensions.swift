//
//  CoordinatingResponder-Extensions.swift
//  MyTMDB
//
//  Created by Bo Zhang on 2024-01-12.
//

import UIKit

extension UIResponder {
    @objc func openFlow(_ flow: AppFlowBox, keepHierarchy: Bool = false, userData: [String: Any]? = nil, sender: Any?) {
        coordinatingResponder?.openFlow(flow, keepHierarchy: keepHierarchy, userData: userData, sender: sender)
    }
}
