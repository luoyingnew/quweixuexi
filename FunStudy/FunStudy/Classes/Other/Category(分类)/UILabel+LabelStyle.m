//
//  UILabel+labelStyle.m
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "UILabel+LabelStyle.h"

@implementation UILabel (LabelStyle)

- (void)jj_setLableStyleWithBackgroundColor:(UIColor *)backgroungColor
                                       font:(UIFont *)font
                                       text:(NSString *)text
                                  textColor:(UIColor *)textColor
                              textAlignment:(NSTextAlignment)textAlignment {
    self.backgroundColor = backgroungColor;
    self.font = font;
    self.text = text;
    self.textColor = textColor;
    self.textAlignment = textAlignment;
}

+ (CGSize)jj_sizeToFitWithText:(NSString *)text Font:(UIFont *)font {
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize textSize = [text boundingRectWithSize:size
                                         options:NSStringDrawingTruncatesLastVisibleLine|
                       NSStringDrawingUsesLineFragmentOrigin|
                       NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil].size;
    
    return textSize;
}

//每一句距离左边距离
- (void)headIndentLength:(CGFloat)length {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.headIndent = length;
    paragraphStyle.firstLineHeadIndent = length * KWIDTH_IPHONE6_SCALE;
    //    paragraphStyle.tailIndent = 10 * KWIDTH_IPHONE6_SCALE;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;

}
//每一句距离右边距离
- (void)tailIndentLength:(CGFloat)length {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.tailIndent = length;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}
//每一句距离左边和右边的距离
- (void)headIndentLength:(CGFloat)headlength tailIndentLength:(CGFloat)taillength {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.tailIndent = taillength;
    paragraphStyle.headIndent = headlength;
    paragraphStyle.firstLineHeadIndent = headlength;

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;

}

@end
