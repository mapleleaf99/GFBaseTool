//
//  UIImageExtension.swift
//  GFBaseTool
//
//  UIImage 扩展：拉伸、颜色图、缩放、压缩、圆角。
//

import UIKit

public extension UIImage {

    /// 对当前图片进行九宫格中心拉伸
    func resizableImageWithCenter() -> UIImage {
        let imageWidth = size.width * 0.5
        let imageHeight = size.height * 0.5
        return resizableImage(
            withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth)
        )
    }

    @available(*, deprecated, renamed: "resizableImageWithCenter()")
    func resizableImage(name: String) -> UIImage {
        guard let image = UIImage(named: name) else { return self }
        return image.resizableImageWithCenter()
    }

    /// 用纯色生成指定尺寸的图片
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    @available(*, deprecated, renamed: "imageWithColor(color:size:)")
    static func imageWithColor(color: UIColor, sizes: CGSize) -> UIImage {
        return imageWithColor(color: color, size: sizes)
    }

    /// 按比例缩放图片
    func imageSize(scale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// 压缩为 JPEG Data，可指定最大字节数（逐步降低质量）
    func gf_compressedJPEGData(compressionQuality: CGFloat = 0.7, maxBytes: Int? = nil) -> Data? {
        var quality = compressionQuality
        guard var data = jpegData(compressionQuality: quality) else { return nil }
        guard let maxBytes = maxBytes else { return data }
        while data.count > maxBytes && quality > 0.1 {
            quality -= 0.1
            guard let newData = jpegData(compressionQuality: quality) else { break }
            data = newData
        }
        return data
    }

    /// 生成圆角图片
    func roundedImage(cornerRadius: CGFloat) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            draw(in: rect)
        }
    }
}
