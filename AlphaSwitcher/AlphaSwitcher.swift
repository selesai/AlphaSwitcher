import UIKit

public final class AlphaSwitcher: UIControl {
    public override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: - Properties
    public private(set) var isOn: Bool = false
    private var widthConstraint: NSLayoutConstraint?
    private var iconSize: CGFloat = 14.0
    private var enableFeedback: Bool = true
    private var size: CGSize = CGSize(width: 36, height: 20)
    private var switcherSize: CGSize = CGSize(width: 16, height: 16)
    
    public var title: AlphaSwitcher.Title? {
        didSet {
            titleOnLabel.text = title?.titleOn
            titleOffLabel.text = title?.titleOff
            self.applyStyles()
        }
    }
    
    public var icon: AlphaSwitcher.Icon? {
        didSet {
            iconOnImageView.image = icon?.iconOn
            iconOffImageView.image = icon?.iconOff
            self.applyStyles()
        }
    }
    
    public var configuration: AlphaSwitcher.Configuration = .init(
        background: .init(
            colorOn: UIColor(red: 0.0, green: 101.0 / 255.0, blue: 209.0 / 255.0, alpha: 1.0),
            colorOff: UIColor(red: 231.0 / 255.0, green: 231.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
        ),
        foreground: .init(
            colorOn: .white,
            colorOff: .white
        ),
        border: .init(
            colorOn: .clear,
            colorOff: UIColor(red: 13.0 / 255.0, green: 17.0 / 255.0, blue: 23.0 / 255.0, alpha: 0.05)
        ),
        cornerRadius: 10
    ) {
        didSet {
            self.applyStyles()
        }
    }
    
    // MARK: - Components
    private lazy var generator: UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator.init(style: .light)
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var iconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var switcherView: UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 2, y: 2), size: self.switcherSize))
        return view
    }()
    
    private lazy var titleOnLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleOffLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var iconOnImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var iconOffImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public init() {
        super.init(frame: .zero)
        self.setupView()
        self.setupConstraint()
        self.applyStyles()
        self.invalidateIntrinsicContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyStyles()
    }
    
    private func setupView() {
        addSubview(titleStackView)
        addSubview(iconStackView)
        titleStackView.addArrangedSubview(titleOnLabel)
        titleStackView.addArrangedSubview(titleOffLabel)
        
        addSubview(iconStackView)
        iconStackView.addArrangedSubview(iconOnImageView)
        iconStackView.addArrangedSubview(iconOffImageView)
        
        // add switcher
        addSubview(switcherView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(switcherTapHandler))
        addGestureRecognizer(gesture)
    }
    
    private func setupConstraint() {
        widthConstraint = self.widthAnchor.constraint(equalToConstant: self.size.width)
        widthConstraint?.isActive = true
        NSLayoutConstraint.activate(
            [
                iconStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                iconStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                iconStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                iconStackView.topAnchor.constraint(equalTo: topAnchor),
                titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                titleStackView.topAnchor.constraint(equalTo: topAnchor),
                iconOnImageView.widthAnchor.constraint(equalToConstant: iconSize),
                iconOnImageView.heightAnchor.constraint(equalToConstant: iconSize),
                iconOffImageView.widthAnchor.constraint(equalToConstant: iconSize),
                iconOffImageView.heightAnchor.constraint(equalToConstant: iconSize)
            ]
        )
    }
    
    private func applyStyles() {
        layer.cornerRadius = configuration.cornerRadius
        layer.borderWidth = 1
        widthConstraint?.constant = self.size.width
        
        /// switcher
        switcherView.backgroundColor = .white
        switcherView.frame.size = switcherSize
        switcherView.layer.cornerRadius = configuration.cornerRadius - 2
        
        /// Title and icon
        titleStackView.isHidden = title == nil
        iconStackView.isHidden = icon == nil
        titleOnLabel.font = .systemFont(ofSize: 8)
        titleOffLabel.font = .systemFont(ofSize: 8)
        titleOnLabel.textColor = configuration.foreground.colorOn
        titleOffLabel.textColor = configuration.foreground.colorOff
        iconOnImageView.tintColor = configuration.foreground.colorOn
        iconOffImageView.tintColor = configuration.foreground.colorOff
        
        iconStackView.layer.zPosition = 1
        titleStackView.layer.zPosition = 2
        switcherView.layer.zPosition = 3
        
        setSwitcherPosition()
        updateColor()
        setTitle()
        setIcon()
        invalidateIntrinsicContentSize()
    }
    
    private func updateColor() {
        backgroundColor = isOn ? configuration.background.colorOn : configuration.background.colorOff
        layer.borderColor = isOn ? configuration.border.colorOn.cgColor : configuration.border.colorOff.cgColor
    }
    
    private func setTitle() {
        guard let title = title
        else { return }
        titleOnLabel.text = String(title.titleOn.prefix(2))
        titleOffLabel.text = String(title.titleOff.prefix(2))
    }
    
    private func setIcon() {
        guard let icon else { return }
        iconOnImageView.image = icon.iconOn
        iconOffImageView.image = icon.iconOff
    }
    
    private func setSwitcherPosition() {
        let x: CGFloat = isOn ? size.width - 2 - switcherSize.width : 2.0
        let y: CGFloat = 2.0
        switcherView.frame.origin = CGPoint(x: x, y: y)
    }
    
    private func updateSwitcherPosition() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [
                .curveEaseIn,
                .allowUserInteraction
            ],
            animations: {
                let x: CGFloat = self.isOn ? self.size.width - 2 - self.switcherSize.width : 2.0
                let y: CGFloat = 2.0
                self.switcherView.frame.origin = CGPoint(x: x, y: y)
                self.updateColor()
            }
        )
    }
    
    @objc private func switcherTapHandler() {
        self.performImpact()
        self.isOn = !self.isOn
        self.updateSwitcherPosition()
        sendActions(for: .valueChanged)
    }
    
    
    private func performImpact() {
        guard #available(iOS 10.0, *) else { return }
        guard enableFeedback else { return }
        generator.prepare()
        generator.impactOccurred()
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.size
    }
}

public extension AlphaSwitcher {
    @discardableResult
    func setTitle(title: AlphaSwitcher.Title) -> Self {
        self.title = title
        return self
    }
    
    @discardableResult
    func removeTitle() -> Self {
        self.title = nil
        return self
    }
    
    @discardableResult
    func setIcon(icon: AlphaSwitcher.Icon) -> Self {
        self.icon = icon
        return self
    }
    
    @discardableResult
    func removeIcon() -> Self {
        self.icon = nil
        return self
    }
    
    @discardableResult
    func setConfiguration(configuration: AlphaSwitcher.Configuration) -> Self {
        self.configuration = configuration
        return self
    }
    
    @discardableResult
    func enableFeedback(_ status: Bool = true) -> Self {
        self.enableFeedback = status
        return self
    }
    
    func isOn(_ status: Bool = true) {
        self.isOn = status
        self.applyStyles()
    }
    
    @discardableResult
    func enabled(_ status: Bool = true) -> Self {
        self.isEnabled = status
        return self
    }
    
    @discardableResult
    func isReadOnly(_ status: Bool = true) -> Self {
        self.switcherView.isUserInteractionEnabled = status
        return self
    }
}

extension AlphaSwitcher {
    public struct Icon {
        let iconOn: UIImage
        let iconOff: UIImage
        
        public init(iconOn: UIImage, iconOff: UIImage) {
            self.iconOn = iconOn
            self.iconOff = iconOff
        }
    }
    
    public struct Title {
        let titleOn: String
        let titleOff: String
        
        public init(titleOn: String, titleOff: String) {
            self.titleOn = titleOn
            self.titleOff = titleOff
        }
    }
}

extension AlphaSwitcher {
    public struct Configuration {
        let background: Background
        let foreground: Foreground
        let border: Border
        let cornerRadius: CGFloat
        
        public struct Background {
            let colorOn: UIColor
            let colorOff: UIColor
        }
        
        public struct Foreground {
            let colorOn: UIColor
            let colorOff: UIColor
        }
        
        public struct Border {
            let colorOn: UIColor
            let colorOff: UIColor
        }
        
        public init(background: Background, foreground: Foreground, border: Border, cornerRadius: CGFloat) {
            self.background = background
            self.foreground = foreground
            self.border = border
            self.cornerRadius = cornerRadius
        }
    }
}
