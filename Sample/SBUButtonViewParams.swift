//
//  SBUButtonViewParams.swift
//  QuickStart
//
//  Created by Luke Cha on 2023/08/09.
//  Copyright © 2023 SendBird, Inc. All rights reserved.
//

import Foundation

/// The data model used for configuring ``SBUButtonView``.
/// - Since: 3.7.0
public struct SBUButtonViewParams {
    /// The text of the action button
    /// - Since: 3.7.0
    public let actionText: String?
    
    /// The description of the card
    /// - Since: 3.7.0
    public let description: String?
    
    /// The action handler for the button click
    /// - Since: 3.7.0
    public let actionHandler: (() -> Void)?

    /// Indicates if the button should be enabled or not
    /// - Since: 3.7.1  // Adjust the version number as needed
    public let enableButton: Bool
    
    /// The text that replaces descriptionText when the button is disabled
    /// - Since: 3.7.1  // Adjust the version number as needed
    public let disableButtonText: String?
    
    /// Initializes ``SBUButtonViewParams``.
    /// - Since: 3.7.0
    public init(
        actionText: String? = nil,
        description: String? = nil,
        actionHandler: (() -> Void)? = nil,
        enableButton: Bool = true,
        disableButtonText: String? = nil
    ) {
        self.actionText = actionText
        self.description = description
        self.actionHandler = actionHandler
        self.enableButton = enableButton
        self.disableButtonText = disableButtonText
    }
}
