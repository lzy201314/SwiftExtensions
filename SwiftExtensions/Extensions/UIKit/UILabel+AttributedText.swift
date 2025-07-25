import UIKit

extension UILabel {
    /// 设置金额富文本，¥符号和数字部分字体、颜色均可自定义
    func setAmountText(
        _ amount: Double,
        numberFont: UIFont = .systemFont(ofSize: 30, weight: .semibold),
        symbolFont: UIFont? = nil,
        numberColor: UIColor = UIColor.black,
        symbolColor: UIColor? = nil
    ) {
        let symbolFont = symbolFont ?? .boldSystemFont(ofSize: numberFont.pointSize / 2)
        let symbolColor = symbolColor ?? numberColor
        let amountStr = String(format: "%.2f", amount)
        let fullStr = "¥" + amountStr
        let attr = NSMutableAttributedString(string: fullStr)
        attr.addAttribute(.font, value: symbolFont, range: NSRange(location: 0, length: 1))
        attr.addAttribute(.font, value: numberFont, range: NSRange(location: 1, length: amountStr.count))
        attr.addAttribute(.foregroundColor, value: symbolColor, range: NSRange(location: 0, length: 1))
        attr.addAttribute(.foregroundColor, value: numberColor, range: NSRange(location: 1, length: amountStr.count))
        self.attributedText = attr
    }
    // 未来可在此添加更多UILabel富文本相关扩展
} 
