import UIKit
import CoreImage

// MARK: - YYKit风格 UIImage 扩展
extension UIImage {
    /// 由颜色生成图片
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    /// 缩放到指定尺寸
    func scaled(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 按比例缩放
    func scaled(by scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        return scaled(to: newSize)
    }
    /// 裁剪到指定rect
    func cropped(to rect: CGRect) -> UIImage? {
        guard let cg = cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cg, scale: scale, orientation: imageOrientation)
    }
    /// 圆角图片
    func withCornerRadius(_ radius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: radius)
        path.addClip()
        draw(in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 旋转图片（角度，单位：弧度）
    func rotated(by radians: CGFloat) -> UIImage? {
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let t = CGAffineTransform(rotationAngle: radians)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2)
        ctx.rotate(by: radians)
        draw(in: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 水平/垂直翻转
    func flipped(horizontal: Bool = false, vertical: Bool = false) -> UIImage? {
        var t = CGAffineTransform.identity
        if horizontal { t = t.scaledBy(x: -1, y: 1) }
        if vertical { t = t.scaledBy(x: 1, y: -1) }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.concatenate(t)
        draw(in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 灰度图片
    func grayscaled() -> UIImage? {
        let ci = CIImage(image: self)
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ci, forKey: kCIInputImageKey)
        guard let output = filter?.outputImage else { return nil }
        return UIImage(ciImage: output)
    }
    /// 高斯模糊
    func blurred(radius: CGFloat) -> UIImage? {
        let ci = CIImage(image: self)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ci, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        guard let output = filter?.outputImage else { return nil }
        let context = CIContext(options: nil)
        guard let cgimg = context.createCGImage(output, from: ci!.extent) else { return nil }
        return UIImage(cgImage: cgimg)
    }
    /// 合成图片（叠加）
    func composited(over image: UIImage, at point: CGPoint = .zero) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        draw(in: CGRect(origin: point, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 加水印
    func watermarked(with watermark: UIImage, at point: CGPoint) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        watermark.draw(in: CGRect(origin: point, size: watermark.size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 转base64字符串
    func toBase64() -> String? {
        pngData()?.base64EncodedString()
    }
    /// 转data
    func toData(compressionQuality: CGFloat = 1.0) -> Data? {
        jpegData(compressionQuality: compressionQuality)
    }
    /// 转CIImage
    var ciImage: CIImage? {
        if let ci = self.ciImage { return ci }
        if let cg = self.cgImage { return CIImage(cgImage: cg) }
        return nil
    }
    /// 解码图片（解压缩，提升首次显示性能）
    func decoded() -> UIImage? {
        guard let cg = cgImage else { return nil }
        let size = CGSize(width: cg.width, height: cg.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIImage(cgImage: cg).draw(in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    /// 取主色（平均色）
    var averageColor: UIColor? {
        guard let cg = cgImage else { return nil }
        let context = CIContext(options: nil)
        let inputImage = CIImage(cgImage: cg)
        let extent = inputImage.extent
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: extent)])
        guard let outputImage = filter?.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x:0,y:0,width:1,height:1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0])/255, green: CGFloat(bitmap[1])/255, blue: CGFloat(bitmap[2])/255, alpha: CGFloat(bitmap[3])/255)
    }
    /// 便捷静态图：纯色
    static func solid(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        image(with: color, size: size)
    }
    /// 便捷静态图：占位
    static var placeholder: UIImage {
        image(with: UIColor(white: 0.9, alpha: 1), size: CGSize(width: 40, height: 40))
    }
} 