//
//  UIImage+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/15.
//

import UIKit

extension UIImage {
    /// NEMODU의 기본 썸네일 이미지를 반환하는 변수
    @nonobjc class var defaultThumbnail: UIImage {
        return UIImage(named: "defaultThumbnail")!
    }
    
    /**
     Returns the flat colorized version of the image, or self when something was wrong
     
     - Parameters:
     - color: The colors to user. By defaut, uses the ``UIColor.white`
     
     - Returns: the flat colorized version of the image, or the self if something was wrong
     */
    func colorized(with color: UIColor = .white) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext(),
              let cgImage = cgImage
        else { return self }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: rect, mask: cgImage)
        context.fill(rect)
        
        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        
        return colored
    }
    
    /**
     Returns the stroked version of the fransparent image with the given stroke color and the thickness.
     
     - Parameters:
     - color: The colors to user.
     - thickness: the thickness of the border. Default to `2`
     - quality: The number of degrees (out of 360): the smaller the best, but the slower. Defaults to `10`.
     
     - Returns: the stroked version of the image, or self if something was wrong
     */
    
    func stroked(with color: UIColor, thickness: CGFloat = 2, quality: CGFloat = 10) -> UIImage {
        
        guard let cgImage = cgImage else { return self }
        
        // Colorize the stroke image to reflect border color
        let strokeImage = colorized(with: color)
        
        guard let strokeCGImage = strokeImage.cgImage else { return self }
        
        /// Rendering quality of the stroke
        let step = quality == 0 ? 10 : abs(quality)
        
        let oldRect = CGRect(x: thickness, y: thickness, width: size.width, height: size.height).integral
        let newSize = CGSize(width: size.width + 2 * thickness, height: size.height + 2 * thickness)
        let translationVector = CGPoint(x: thickness, y: 0)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        defer { UIGraphicsEndImageContext() }
        
        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.interpolationQuality = .high
        
        for angle: CGFloat in stride(from: 0, to: 360, by: step) {
            let vector = translationVector.rotated(around: .zero, byDegrees: angle)
            let transform = CGAffineTransform(translationX: vector.x, y: vector.y)
            
            context.concatenate(transform)
            
            context.draw(strokeCGImage, in: oldRect)
            
            let resetTransform = CGAffineTransform(translationX: -vector.x, y: -vector.y)
            context.concatenate(resetTransform)
        }
        
        context.draw(cgImage, in: oldRect)
        
        guard let stroked = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        
        return stroked
    }
}
