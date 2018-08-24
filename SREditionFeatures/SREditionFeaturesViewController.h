//
//  SREditionFeatures.h
//  SREditionFeaturesDemo
//
//  Created by https://github.com/guowilling on 2017/9/26.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SREditionFeaturesViewController : UIViewController

/**
 If you want a start button in the final feature image, set this property with a button's image name or pass nil to create a placeholder button for user action.
 */
@property (nonatomic, copy) NSString *startBtnImageName;

/**
 Whether to hide pageControl, default is NO which means show pageControl.
 */
@property (nonatomic, assign) BOOL hidePageControl;

/**
 Whether to hide skip Button, default is YES which means hide skip Button.
 */
@property (nonatomic, assign) BOOL hideSkipButton;

/**
 The current page indicator tint color, default is [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 The other page indicator tint color, default is [UIColor lightGrayColor].
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Only the first start app need show edition features.
 
 @return YES to show, NO not to show.
 */
+ (BOOL)sr_shouldShowEditionFeatures;

/**
 Creates and returns new features view controller with images.
 
 @param imageNames The image's name array.
 @param rootVC     The key window's true root view controller.
 @param completion A block object to be executed when finish read edition features and switch root view controller.
 
 @return EditionFeaturesViewController
 */
+ (instancetype)sr_editionFeaturesWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC completion:(void (^)(void))completion;

@end
