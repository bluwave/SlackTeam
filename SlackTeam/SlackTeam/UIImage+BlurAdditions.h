//
//  UIImage+GRAdditions.h
//  GRProfiles
//
//  Created by Garrett Richards on 6/7/15.
//  Copyright (c) 2015 Acme. All rights reserved.
//

@import UIKit;

@interface UIImage (BlurAdditions)

- (UIImage *)gr_blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
