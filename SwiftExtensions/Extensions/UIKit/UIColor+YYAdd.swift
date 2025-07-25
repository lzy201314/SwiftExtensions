import UIKit

// MARK: - YYKit风格 UIColor 扩展
extension UIColor {
    // MARK: - 初始化
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hex.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    static func colorWithRGB(_ rgb: UInt32) -> UIColor {
        UIColor(hex: rgb)
    }
    static func colorWithRGBA(_ rgba: UInt32) -> UIColor {
        let r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(rgba & 0x000000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    static func colorWithRGB(_ rgb: UInt32, alpha: CGFloat) -> UIColor {
        UIColor(hex: rgb, alpha: alpha)
    }
    static func colorWithHSB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    static func colorWithHSL(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) -> UIColor {
        // HSL转RGB
        let (r, g, b) = UIColor.hsl2rgb(h: hue, s: saturation, l: lightness)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    static func colorWithCMYK(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat, alpha: CGFloat) -> UIColor {
        let r = (1-cyan)*(1-black)
        let g = (1-magenta)*(1-black)
        let b = (1-yellow)*(1-black)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    // MARK: - 分量获取
    var redComponent: CGFloat { var r: CGFloat = 0; getRed(&r, green: nil, blue: nil, alpha: nil); return r }
    var greenComponent: CGFloat { var g: CGFloat = 0; getRed(nil, green: &g, blue: nil, alpha: nil); return g }
    var blueComponent: CGFloat { var b: CGFloat = 0; getRed(nil, green: nil, blue: &b, alpha: nil); return b }
    var alphaComponent: CGFloat { var a: CGFloat = 0; getRed(nil, green: nil, blue: nil, alpha: &a); return a }
    var hueComponent: CGFloat { var h: CGFloat = 0; getHue(&h, saturation: nil, brightness: nil, alpha: nil); return h }
    var saturationComponent: CGFloat { var s: CGFloat = 0; getHue(nil, saturation: &s, brightness: nil, alpha: nil); return s }
    var brightnessComponent: CGFloat {
        var v: CGFloat = 0; getHue(nil, saturation: nil, brightness: &v, alpha: nil); return v
    }
    /// 获取HSL分量
    func getHSL() -> (h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat) {
        let (h, s, l) = UIColor.rgb2hsl(r: redComponent, g: greenComponent, b: blueComponent)
        return (h, s, l, alphaComponent)
    }
    /// 获取CMYK分量
    func getCMYK() -> (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat, a: CGFloat) {
        let r = redComponent, g = greenComponent, b = blueComponent
        let k = 1 - max(r, max(g, b))
        let c = (1 - r - k) / (1 - k + .ulpOfOne)
        let m = (1 - g - k) / (1 - k + .ulpOfOne)
        let y = (1 - b - k) / (1 - k + .ulpOfOne)
        return (c, m, y, k, alphaComponent)
    }
    // MARK: - 颜色空间
    var colorSpaceModel: CGColorSpaceModel {
        cgColor.colorSpace?.model ?? .unknown
    }
    var colorSpaceString: String {
        switch colorSpaceModel {
        case .unknown: return "Unknown"
        case .monochrome: return "Monochrome"
        case .rgb: return "RGB"
        case .cmyk: return "CMYK"
        case .lab: return "Lab"
        case .deviceN: return "DeviceN"
        case .indexed: return "Indexed"
        case .pattern: return "Pattern"
        @unknown default: return "Other"
        }
    }
    // MARK: - 颜色值获取
    var rgbValue: UInt32 {
        let r = UInt32(redComponent * 255)
        let g = UInt32(greenComponent * 255)
        let b = UInt32(blueComponent * 255)
        return (r << 16) | (g << 8) | b
    }
    var rgbaValue: UInt32 {
        let r = UInt32(redComponent * 255)
        let g = UInt32(greenComponent * 255)
        let b = UInt32(blueComponent * 255)
        let a = UInt32(alphaComponent * 255)
        return (r << 24) | (g << 16) | (b << 8) | a
    }
    func toHexString(includeAlpha: Bool = false) -> String {
        let r = Int(redComponent * 255)
        let g = Int(greenComponent * 255)
        let b = Int(blueComponent * 255)
        let a = Int(alphaComponent * 255)
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
    func hexStringWithAlpha() -> String {
        toHexString(includeAlpha: true)
    }
    // MARK: - 颜色混合/调整
    func colorByAddColor(_ add: UIColor, blendMode: CGBlendMode = .normal) -> UIColor? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        self.setFill(); ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        add.setFill(); ctx.setBlendMode(blendMode); ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img?.getPixelColor(at: CGPoint(x: 0, y: 0))
    }
    func colorByChangeHue(_ hueDelta: CGFloat, saturationDelta: CGFloat, brightnessDelta: CGFloat, alphaDelta: CGFloat) -> UIColor {
        var h = hueComponent, s = saturationComponent, v = brightnessComponent, a = alphaComponent
        h = min(max(h + hueDelta, 0), 1)
        s = min(max(s + saturationDelta, 0), 1)
        v = min(max(v + brightnessDelta, 0), 1)
        a = min(max(a + alphaDelta, 0), 1)
        return UIColor(hue: h, saturation: s, brightness: v, alpha: a)
    }
    // MARK: - 辅助判断
    var isDarkColor: Bool { brightnessComponent < 0.5 }
    var isBlackOrWhite: Bool {
        let r = redComponent, g = greenComponent, b = blueComponent
        return (r > 0.91 && g > 0.91 && b > 0.91) || (r < 0.09 && g < 0.09 && b < 0.09)
    }
    var isClear: Bool { alphaComponent == 0 }
    func isEqualToColor(_ color: UIColor, tolerance: CGFloat = 0.01) -> Bool {
        abs(redComponent - color.redComponent) <= tolerance &&
        abs(greenComponent - color.greenComponent) <= tolerance &&
        abs(blueComponent - color.blueComponent) <= tolerance &&
        abs(alphaComponent - color.alphaComponent) <= tolerance
    }
    // MARK: - HSL/CMYK辅助
    private static func hsl2rgb(h: CGFloat, s: CGFloat, l: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        let q = l < 0.5 ? l * (1 + s) : l + s - l * s
        let p = 2 * l - q
        let r = hue2rgb(p: p, q: q, t: h + 1/3)
        let g = hue2rgb(p: p, q: q, t: h)
        let b = hue2rgb(p: p, q: q, t: h - 1/3)
        return (r, g, b)
    }
    private static func hue2rgb(p: CGFloat, q: CGFloat, t: CGFloat) -> CGFloat {
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }
        if t < 1/6 { return p + (q - p) * 6 * t }
        if t < 1/2 { return q }
        if t < 2/3 { return p + (q - p) * (2/3 - t) * 6 }
        return p
    }
    private static func rgb2hsl(r: CGFloat, g: CGFloat, b: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        let maxV = max(r, max(g, b)), minV = min(r, min(g, b))
        var h: CGFloat = 0, s: CGFloat = 0, l: CGFloat = (maxV + minV) / 2
        if maxV == minV {
            h = 0; s = 0
        } else {
            let d = maxV - minV
            s = l > 0.5 ? d / (2 - maxV - minV) : d / (maxV + minV)
            if maxV == r {
                h = (g - b) / d + (g < b ? 6 : 0)
            } else if maxV == g {
                h = (b - r) / d + 2
            } else {
                h = (r - g) / d + 4
            }
            h /= 6
        }
        return (h, s, l)
    }
}

// MARK: - UIImage辅助
private extension UIImage {
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        let width = Int(size.width), height = Int(size.height)
        guard point.x < CGFloat(width), point.y < CGFloat(height) else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        defer { rawData.deallocate() }
        let context = CGContext(data: rawData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        context?.translateBy(x: -point.x, y: -point.y)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        let r = CGFloat(rawData[0]) / 255.0
        let g = CGFloat(rawData[1]) / 255.0
        let b = CGFloat(rawData[2]) / 255.0
        let a = CGFloat(rawData[3]) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
} 