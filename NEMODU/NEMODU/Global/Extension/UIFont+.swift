//
//  UIFont+.swift
//  NEMODU
//
//  Created by 황윤경 on 2022/08/09.
//

import UIKit

extension UIFont {
    // Heading
    @nonobjc class var number1: UIFont{
        PretendardExtraBold(size: 48)
    }
    
    @nonobjc class var number2: UIFont{
        PretendardSemiBold(size: 32)
    }
    
    @nonobjc class var title1: UIFont{
        PretendardSemiBold(size: 28)
    }
    
    @nonobjc class var title2: UIFont{
        PretendardSemiBold(size: 22)
    }
    
    @nonobjc class var title3SB: UIFont{
        PretendardSemiBold(size: 20)
    }
    
    @nonobjc class var title3M: UIFont{
        PretendardMedium(size: 20)
    }
    
    @nonobjc class var headline1: UIFont{
        PretendardSemiBold(size: 17)
    }
    
    @nonobjc class var headline2: UIFont{
        PretendardSemiBold(size: 13)
    }
    
    // Paragraph
    @nonobjc class var body1: UIFont{
        PretendardRegular(size: 17)
    }
    
    @nonobjc class var body2: UIFont{
        PretendardRegular(size: 16)
    }
    
    @nonobjc class var body3: UIFont{
        PretendardRegular(size: 15)
    }
    
    @nonobjc class var body4: UIFont{
        PretendardRegular(size: 13)
    }
    
    @nonobjc class var caption1: UIFont{
        PretendardRegular(size: 12)
    }
    
    
    // Basic
    class func PretendardBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Black", size: size)!
    }
    
    class func PretendardBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size)!
    }
    
    class func PretendardExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-ExtraBold", size: size)!
    }
    
    class func PretendardMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size)!
    }
    
    class func PretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }
    
    class func PretendardSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
}
