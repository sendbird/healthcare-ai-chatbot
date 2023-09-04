//
//  SBUUserMessageCell.swift
//  SendbirdUIKit
//
//  Created by Harry Kim on 2020/02/20.
//  Copyright © 2020 Sendbird, Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import SendbirdChatSDK

@IBDesignable
open class SBUUserMessageCell: SBUContentBaseMessageCell, SBUUserMessageTextViewDelegate {

    // MARK: - Public property
    public lazy var messageTextView: UIView = SBUUserMessageTextView()
    
    public var userMessage: UserMessage? {
        self.message as? UserMessage
    }
    
    public var channel: GroupChannel?
    
    // + ------------ +
    // | reactionView |
    // + ------------ +
    /// A ``SBUSelectableStackView`` that contains `reactionView`.
    public private(set) var additionContainerView: SBUSelectableStackView = {
        let view = SBUSelectableStackView()
        return view
    }()
    
    /// A ``SBUMessageWebView`` which represents a preview of the web link
    public var webView: SBUMessageWebView = {
        let webView = SBUMessageWebView()
        return webView
    }()
    
    // MARK: - Quick Reply
    
    /// The boolean value whether the ``quickReplyView`` instance should appear or not. The default is `true`
    /// - Important: If it's true, ``quickReplyView`` never appears even if the ``userMessage`` has quick reply options.
    /// - Since: 3.7.0
    public private(set) var shouldHideQuickReply: Bool = true
    
    /// ``SBUQuickReplyView`` instance.
    /// - Since: 3.7.0
    public private(set) var quickReplyView: SBUQuickReplyView?
    
    /// The action of ``SBUQuickReplyView`` that is called when a ``SBUQuickReplyOptionView`` is selected.
    /// - Parameter selectedOptionView: The selected ``SBUQuickReplyOptionView`` object.
    /// - Since: 3.7.0
    public var quickReplySelectHandler: ((_ selectedOptionView: SBUQuickReplyOptionView) -> Void)?
    
    // MARK: - Card List
    
    /// ``SBUCardListView`` instance.
    /// - Since: 3.7.0
    public private(set) var cardListView: SBUCardListView?
    
    /// - Since: 3.7.0
    public var cardSelectHandler: ((_ text: String) -> Void)?
    // MARK: - Button
    
    /// ``SBUButtonView`` instance.
    /// - Since: 3.7.0
    public private(set) var buttonView: SBUButtonView?
    public private(set) var shouldHideButton: Bool = true
    public private(set) var buttonClicked: Bool = false
    public var buttonSelectHandler: (() -> Void)?
    // MARK: - View Lifecycle
    open override func setupViews() {
        super.setupViews()
        
        (self.messageTextView as? SBUUserMessageTextView)?.delegate = self

        // + --------------- +
        // | messageTextView |
        // + --------------- +
        // | reactionView    |
        // + --------------- +
        
        self.mainContainerView.setStack([
            self.messageTextView,
            self.additionContainerView.setStack([
                self.reactionView
            ])
        ])
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    open override func setupActions() {
        super.setupActions()

        if let messageTextView = self.messageTextView as? SBUUserMessageTextView {
            messageTextView.longPressHandler = { [weak self] _ in
                guard let self = self else { return }
                self.onLongPressContentView(sender: nil)
            }
        }
        
        self.messageTextView.addGestureRecognizer(self.contentLongPressRecognizer)
        self.messageTextView.addGestureRecognizer(self.contentTapRecognizer)

        self.webView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(self.onTapWebview(sender:))
        ))
    }

    open override func setupStyles() {
        super.setupStyles()
        
        let isWebviewVisible = !self.webView.isHidden
        self.additionContainerView.leftBackgroundColor = isWebviewVisible
            ? self.theme.contentBackgroundColor
            : self.theme.leftBackgroundColor
        self.additionContainerView.leftPressedBackgroundColor = isWebviewVisible
            ? self.theme.pressedContentBackgroundColor
            : self.theme.leftPressedBackgroundColor
        self.additionContainerView.rightBackgroundColor = isWebviewVisible
            ? self.theme.contentBackgroundColor
            : self.theme.rightBackgroundColor
        self.additionContainerView.rightPressedBackgroundColor = isWebviewVisible
            ? self.theme.pressedContentBackgroundColor
            : self.theme.rightPressedBackgroundColor

        self.additionContainerView.setupStyles()
        
        self.webView.setupStyles()
        
        self.additionContainerView.layer.cornerRadius = 8
    }
  
    open override func configure(with configuration: SBUBaseMessageCellParams) {
        guard let configuration = configuration as? SBUUserMessageCellParams else { return }
        guard let message = configuration.userMessage else { return }
        var customText: String? = nil
        var disableWebview = false
        // Set using reaction
        self.useReaction = configuration.useReaction
        
        self.useQuotedMessage = configuration.useQuotedMessage
        
        self.useThreadInfo = configuration.useThreadInfo
        self.shouldHideQuickReply = configuration.shouldHideQuickReply
        self.shouldHideButton = configuration.shouldHideButton
        
        // Configure Content base message cell
        super.configure(with: configuration)
        
        print("Message: \(message.message), Message data: \(message.data)")
        // Parse JSON from received message data
        let json = JSON(parseJSON: message.data)
        
        // MARK: Quick Reply
        if let quickReplyView = self.quickReplyView {
            quickReplyView.removeFromSuperview()
            self.quickReplyView = nil
        }

        if let quickReplies = json["quick_replies"].arrayObject as? [String], !quickReplies.isEmpty {
            self.updateQuickReplyView(with: quickReplies)
        }
        
        // MARK: ButtonView
        if let buttonView = self.buttonView {
            self.contentVStackView.removeArrangedSubview(buttonView)
        }
        
        // MARK: Card List
        if let cardListView = self.cardListView {
            self.contentVStackView.removeArrangedSubview(cardListView)
        }

        let functionResponse = json["function_calls"][0]

        if functionResponse.type != .null {
            let statusCode = functionResponse["status_code"].intValue
            let functionName = functionResponse["name"].stringValue
            let response = functionResponse["response_text"]

            if statusCode == 200 {
                if functionName.contains("check_doctors_availability") {
                    // Replace the message text with the custom text
                    customText = "Yes, you can talk to a doctor. "
                    
                    let buttonParams = SBUButtonViewParams(
                        actionText: "Invite a Doctor",
                        description: "If you want to talk to a doctor, please click the button!",
                        actionHandler: {
                            self.buttonClicked = true
                            self.buttonSelectHandler!()
                            self.layoutIfNeeded()
                        },
                        enableButton: !shouldHideButton && !self.buttonClicked,
                        disableButtonText: "In Progress"
                    )
                    self.updateButtonView(with: buttonParams)
                } else if functionName.contains("post_appointments") {
                    // Replace the message text with the custom text
                    customText = "Your appointment has been successfully scheduled. Here are the details"
                    SBUGlobalCustomParams.cardViewParamsCollectionBuilder = { messageData in
                        guard
                            let data = messageData.data(using: .utf8),
                            let json = try? JSON(data: data)
                        else { return [] }
                        // Convert the single order object into a SBUCardViewParams object
                        let orderParams = SBUCardViewParams(
                            imageURL: nil,
                            title: "Date: \(json["appointmentDetails"]["date"].stringValue) \(json["appointmentDetails"]["time"].stringValue)",
                            subtitle: nil,
                            description: "- ID: \(json["appointmentDetails"]["appointmentId"].stringValue)\n- Department: \(json["appointmentDetails"]["department"].stringValue)\n- Doctor: \(json["appointmentDetails"]["doctor"].stringValue)",
                            link: nil
                        )

                        return [orderParams]
                    }
                    if let items = try?SBUGlobalCustomParams.cardViewParamsCollectionBuilder?(response.rawString()!){
                        self.addCardListView(with: items)
                    }
                } else if functionName.contains("get_recommend_date") {
                    // Replace the message text with the custom text
                    customText = "Here are the available appointment date and time. Click the card if you have a desired appointment."
                    disableWebview = true
                    SBUGlobalCustomParams.cardViewParamsCollectionBuilder = { messageData in
                        guard
                            let data = messageData.data(using: .utf8),
                            let json = try? JSON(data: data)
                        else { return [] }
                        return json.arrayValue.compactMap { item in
                            return SBUCardViewParams(
                                    imageURL: nil,
                                    title: "\(item["doctor"].stringValue)",
                                    subtitle: "Date: \(item["recommended_date"].stringValue)",
                                    description: nil,
                                    link: nil,
                                    actionHandler: {
                                        self.cardSelectHandler!("Please reserve a reservation with \(item["doctor"].stringValue), \(item["recommended_date"].stringValue)")
                                    }
                            )
                        }
                    }
                    if let items = try?SBUGlobalCustomParams.cardViewParamsCollectionBuilder?(response.rawString()!){
                        self.addCardListView(with: items)
                    }
                }
            }
        } else {
            self.cardListView = nil
        }
        
        // Set up message position of additionContainerView(reactionView)
        self.additionContainerView.position = self.position
        self.additionContainerView.isSelected = false
        
        // Set up SBUUserMessageTextView
        if let messageTextView = messageTextView as? SBUUserMessageTextView, configuration.withTextView {
            messageTextView.configure(
                model: SBUUserMessageTextViewModel(
                    message: message,
                    position: configuration.messagePosition,
                    customText: customText
                )
            )
            messageTextView.updateHeightConstraint()
        }

        // Set up WebView with OG meta data
        if let ogMetaData = configuration.message.ogMetaData, SBUAvailable.isSupportOgTag() && !disableWebview {
            self.additionContainerView.insertArrangedSubview(self.webView, at: 0)
            self.webView.isHidden = false
            let model = SBUMessageWebViewModel(metaData: ogMetaData)
            self.webView.configure(model: model)
        } else {
            self.additionContainerView.removeArrangedSubview(self.webView)
            self.webView.isHidden = true
        }

        self.layoutIfNeeded()
    }
    
    @available(*, deprecated, renamed: "configure(with:)") // 2.2.0
    open func configure(_ message: UserMessage,
                        hideDateView: Bool,
                        groupPosition: MessageGroupPosition,
                        receiptState: SBUMessageReceiptState?,
                        useReaction: Bool) {
        let configuration = SBUUserMessageCellParams(
            message: message,
            hideDateView: hideDateView,
            useMessagePosition: true,
            groupPosition: groupPosition,
            receiptState: receiptState ?? .none,
            useReaction: false,
            withTextView: true
        )
        self.configure(with: configuration)
    }
    
    @available(*, deprecated, renamed: "configure(with:)") // 2.2.0
    open func configure(_ message: BaseMessage,
                        hideDateView: Bool,
                        receiptState: SBUMessageReceiptState?,
                        groupPosition: MessageGroupPosition,
                        withTextView: Bool) {
        guard let userMessage = message as? UserMessage else {
            SBULog.error("The message is not a type of UserMessage")
            return
        }

        let configuration = SBUUserMessageCellParams(
            message: userMessage,
            hideDateView: hideDateView,
            useMessagePosition: true,
            groupPosition: groupPosition,
            receiptState: receiptState ?? .none,
            useReaction: self.useReaction,
            withTextView: withTextView
        )
        self.configure(with: configuration)
    }
    
    /// Adds highlight attribute to the message
    open override func configure(highlightInfo: SBUHighlightMessageInfo?) {
        // Only apply highlight for the given message, that's not edited (updatedAt didn't change)
        guard let message = self.message,
              message.messageId == highlightInfo?.messageId,
              message.updatedAt == highlightInfo?.updatedAt else { return }

        guard let messageTextView = messageTextView as? SBUUserMessageTextView else { return }

        messageTextView.configure(
            model: SBUUserMessageTextViewModel(
                message: message,
                position: position,
                highlightKeyword: highlightInfo?.keyword
            )
        )
    }
    
    // MARK: - Action
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.additionContainerView.isSelected = selected
    }

    @objc
    open func onTapWebview(sender: UITapGestureRecognizer) {
        guard
            let ogMetaData = self.userMessage?.ogMetaData,
            let urlString = ogMetaData.url,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        url.open()
    }
    
    // MARK: - Quick Reply
    public func updateQuickReplyView(with options: [String]) {
        if shouldHideQuickReply { return }
        guard let messageId = self.message?.messageId else { return }
        let quickReplyView = SBUQuickReplyView()
        let configuration = SBUQuickReplyViewParams(
            messageId: messageId,
            replyOptions: options
        )
        quickReplyView.configure(with: configuration, delegate: self)
        self.userNameStackView.addArrangedSubview(quickReplyView)
        quickReplyView.sbu_constraint(equalTo: self.userNameStackView, leading: 0, trailing: 0)
        
        self.quickReplyView = quickReplyView
        
        self.layoutIfNeeded()
    }
    
    // MARK: - Card List
    public func addCardListView(with items: [SBUCardViewParams]) {
        guard let messageId = self.message?.messageId else { return }
        let cardListView = SBUCardListView()
        let configuration = SBUCardListViewParams(
            messageId: messageId,
            items: items
        )
        cardListView.configure(with: configuration)
        self.contentVStackView.addArrangedSubview(cardListView)
        
        if let constraints = self.cardListView?.constraints {
            self.cardListView?.removeConstraints(constraints)            
        }
        switch self.position {
        case .right:
            cardListView.sbu_constraint(equalTo: self.mainContainerView, leading: 0)
            cardListView.sbu_constraint(equalTo: self.contentVStackView, trailing: 0)
        default:
            cardListView.sbu_constraint(equalTo: self.contentVStackView, leading: 0)
            cardListView.sbu_constraint(equalTo: self.mainContainerView, trailing: 0)
        }
        
        self.cardListView = cardListView
        
        self.layoutIfNeeded()
    }
    
    // MARK: - Button View Update
    public func updateButtonView(with params: SBUButtonViewParams) {
        // If the button view already exists, remove it.
        self.buttonView?.removeFromSuperview()

        let buttonView = SBUButtonView()
        buttonView.configure(with: params)
            
        let topSpacer: UIView = {
             let spacer = UIView()
             spacer.sbu_constraint(height: 15)
             return spacer
        }()
            
        self.contentVStackView.addArrangedSubview(topSpacer)
        self.contentVStackView.addArrangedSubview(buttonView)
            
        if let constraints = self.buttonView?.constraints {
            self.buttonView?.removeConstraints(constraints)
        }
            
        switch self.position {
        case .right:
            buttonView.sbu_constraint(equalTo: self.mainContainerView, leading: 0)
            buttonView.sbu_constraint(equalTo: self.contentVStackView, trailing: 0)
        default:
            buttonView.sbu_constraint(equalTo: self.contentVStackView, leading: 0)
            buttonView.sbu_constraint(equalTo: self.mainContainerView, trailing: 0)
        }
            
        self.buttonView = buttonView

        self.layoutIfNeeded()
    }
    
    // MARK: - Mention
    /// As a default, it calls `groupChannelModule(_:didTapMentionUser:)` in ``SBUGroupChannelModuleListDelegate``.
    open func userMessageTextView(_ textView: SBUUserMessageTextView, didTapMention user: SBUUser) {
        self.mentionTapHandler?(user)
    }
}

extension SBUUserMessageCell: SBUQuickReplyViewDelegate {
    public func quickReplyView(_ view: SBUQuickReplyView, didSelectOption optionView: SBUQuickReplyOptionView) {
        self.quickReplyView?.removeFromSuperview()
        self.quickReplyView = nil
        
        self.layoutIfNeeded()
        
        self.quickReplySelectHandler?(optionView)
    }
}
