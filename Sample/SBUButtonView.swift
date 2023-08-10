import UIKit

public class SBUButtonView: SBUView {
    // MARK: - Properties
    public var theme: SBUMessageCellTheme = SBUTheme.messageCellTheme

    public var actionText: String? { self.params?.actionText }
    public var descriptionText: String? { self.params?.description }
    public var enableButton: Bool = true
    public var disableButtonText: String?
    
    public private(set) var params: SBUButtonViewParams?
    
    public var contentStackView = SBUStackView(
        axis: .vertical,
        alignment: .leading,
        spacing: 0
    )

    public var titleLabel = UILabel()
    
    public var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .init(top: 0, left: 12, bottom: 12, right: 12)
        return textView
    }()

    public var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        return button
    }()

    let view = UIView()
    
    public var spacerView: UIView = {
        let view = UIView()
        view.sbu_constraint(height: 12)
        return view
    }()
        
    public override func setupViews() {
        super.setupViews()
        
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        actionButton.setTitle(self.actionText, for: .normal)

        self.descriptionTextView.isHidden = self.descriptionText == nil
        self.actionButton.isHidden = self.actionText == nil

        self.titleLabel.numberOfLines = 0

        self.contentStackView.alignment = .center

        self.contentStackView.setVStack([
            self.titleLabel,
            self.descriptionTextView,
            self.actionButton,
            self.spacerView
        ])
        
        self.addSubview(contentStackView)
    }
    
    public override func setupLayouts() {
        super.setupLayouts()
        
        self.contentStackView
            .sbu_constraint(equalTo: self, leading: 0, trailing: 0, top: 8, bottom: 0)
    }
    
    public override func setupStyles() {
        super.setupStyles()

        self.backgroundColor = self.theme.leftBackgroundColor

        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = self.theme.leftBackgroundColor.cgColor

        actionButton.backgroundColor = self.theme.buttonTitleColor
        actionButton.layer.cornerRadius = 16
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = self.theme.buttonTitleColor.cgColor
        actionButton.setTitleColor(self.theme.userMessageRightTextColor, for: .normal)

        self.titleLabel.textColor = self.theme.userMessageLeftTextColor
        self.titleLabel.font = self.theme.selectableTitleFont
        
        self.descriptionTextView.layer.cornerRadius = 16
        self.descriptionTextView.backgroundColor = self.theme.leftBackgroundColor
        self.descriptionTextView.textColor = self.theme.userMessageLeftTextColor
        self.descriptionTextView.font = self.theme.userMessageFont
    }
    
    public func configure(with configuration: SBUButtonViewParams) {
        self.params = configuration
        
        self.setupViews()
        self.setupLayouts()
        self.setupStyles()
        
        self.layoutIfNeeded()

        // Check the enableButton value and adjust the actionButton and descriptionTextView
        if let enableButton = self.params?.enableButton, !enableButton {
            self.actionButton.isHidden = true
            self.spacerView.isHidden = true 
            if let disableButtonText = self.params?.disableButtonText {
                self.descriptionTextView.text = disableButtonText
            }
        } else {
            self.descriptionTextView.text = self.descriptionText
            self.actionButton.setTitle(self.actionText, for: .normal)
        }
    }
    
    @objc public func handleAction() {
        self.params?.actionHandler?()
    }
}
