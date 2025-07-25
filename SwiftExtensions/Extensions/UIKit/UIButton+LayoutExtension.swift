import UIKit

// MARK: - UIButton 图片文字常见布局扩展
extension UIButton {
    /// 图片在上，文字在下，垂直居中，间距可调
    func setImageAboveTitle(spacing: CGFloat = 4) {
        guard let image = self.imageView?.image, let title = self.titleLabel?.text, let font = self.titleLabel?.font else { return }
        let imageSize = image.size
        let titleSize = (title as NSString).size(withAttributes: [.font: font])
        let totalHeight = imageSize.height + spacing + titleSize.height
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
        self.contentEdgeInsets = UIEdgeInsets(
            top: (totalHeight - imageSize.height - titleSize.height)/2,
            left: 0,
            bottom: (totalHeight - imageSize.height - titleSize.height)/2,
            right: 0
        )
    }
    /// 图片在左，文字在右，水平居中，间距可调
    func setImageLeftTitleRight(spacing: CGFloat = 4) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
    }
    /// 文字在左，图片在右，水平居中，间距可调
    func setTitleLeftImageRight(spacing: CGFloat = 4) {
        guard let image = self.imageView?.image, let title = self.titleLabel?.text, let font = self.titleLabel?.font else { return }
        let imageSize = image.size
        let titleSize = (title as NSString).size(withAttributes: [.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + spacing/2, bottom: 0, right: -(titleSize.width + spacing/2))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + spacing/2), bottom: 0, right: imageSize.width + spacing/2)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
    }
    /// 文字在上，图片在下，垂直居中，间距可调
    func setTitleAboveImageBelow(spacing: CGFloat = 4) {
        guard let image = self.imageView?.image, let title = self.titleLabel?.text, let font = self.titleLabel?.font else { return }
        let imageSize = image.size
        let titleSize = (title as NSString).size(withAttributes: [.font: font])
        let totalHeight = imageSize.height + spacing + titleSize.height
        self.titleEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - titleSize.height),
            left: -imageSize.width,
            bottom: 0,
            right: 0
        )
        self.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: -(totalHeight - imageSize.height),
            right: -titleSize.width
        )
        self.contentEdgeInsets = UIEdgeInsets(
            top: (totalHeight - imageSize.height - titleSize.height)/2,
            left: 0,
            bottom: (totalHeight - imageSize.height - titleSize.height)/2,
            right: 0
        )
    }
    /// 只显示图片
    func setImageOnly() {
        self.setTitle(nil, for: .normal)
        self.titleEdgeInsets = .zero
        self.imageEdgeInsets = .zero
        self.contentEdgeInsets = .zero
    }
    /// 只显示文字
    func setTitleOnly() {
        self.setImage(nil, for: .normal)
        self.titleEdgeInsets = .zero
        self.imageEdgeInsets = .zero
        self.contentEdgeInsets = .zero
    }
} 