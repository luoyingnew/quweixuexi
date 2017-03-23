//
//  UITextField+LimitLength.h
//  JRFProject
//
//  Created by feng jia on 15-2-6.
//  Copyright (c) 2015年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xp_EditEndBlock)(NSString *text
                                );

@interface UITextField (LimitLength)

///**
// *  Create an UITextField and set some parameters
// *
// *  @param frame                         TextField's frame
// *  @param placeholder                   TextField's text placeholder
// *  @param color                         TextField's text color
// *  @param fontName                      TextField's text font
// *  @param size                          TextField's text size
// *  @param returnType                    TextField's return key type
// *  @param keyboardType                  TextField's keyboard type
// *  @param secure                        Set if the TextField is secure or not
// *  @param borderStyle                   TextField's border style
// *  @param capitalization                TextField's text capitalization
// *  @param keyboardAppearence            TextField's keyboard appearence
// *  @param enablesReturnKeyAutomatically Set if the TextField has to automatically enables the return key
// *  @param clearButtonMode               TextField's clear button mode
// *  @param autoCorrectionType            TextField's auto correction type
// *  @param delegate                      TextField's delegate. Set nil if it has no delegate
// *
// *  @return Return the created UITextField
// */
//+ (UITextField *)   initWithFrame:(CGRect)frame
//                      placeholder:(NSString *)placeholder
//                            color:(UIColor *)color
//                             font:(FontName)fontName
//                             size:(float)size
//                       returnType:(UIReturnKeyType)returnType
//                     keyboardType:(UIKeyboardType)keyboardType
//                           secure:(BOOL)secure
//                      borderStyle:(UITextBorderStyle)borderStyle
//               autoCapitalization:(UITextAutocapitalizationType)capitalization
//               keyboardAppearance:(UIKeyboardAppearance)keyboardAppearence
//    enablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically
//                  clearButtonMode:(UITextFieldViewMode)clearButtonMode
//               autoCorrectionType:(UITextAutocorrectionType)autoCorrectionType
//                         delegate:(id <UITextFieldDelegate> )delegate;


/**
 *  使用时只要调用此方法，加上一个长度(int)，就可以实现了字数限制, block是编辑结束后会调用
 *
 *  @param length
 *  @param block
 */
- (void)xp_limitTextLength:(int)length block:(xp_EditEndBlock)block;
/**
 *  uitextField 抖动效果
 */
- (void)xp_shake;
@end
