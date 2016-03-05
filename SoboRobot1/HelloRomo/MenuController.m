//
//  MenuController.m
//  HelloRomo
//
//  Created by Laura on 28/02/2016.
//  Copyright © 2016 Romotive. All rights reserved.
//

#import "MenuController.h"


//static const CGFloat titleLabelCenterY = 32.0;

//static const CGFloat helpButtonSize = 64.0;
//static const CGFloat helpButtonPaddingUR = 16.0;
//static const CGFloat helpButtonPaddingBL = 20.0;

@interface MenuController()

@property (nonatomic, strong) UIImageView *helpButtonIcon;
@property (nonatomic, strong, readwrite) UIButton *helpButton;

@end

@implementation MenuController


- (UIButton *)helpButton
{
//    if (!self.showsHelpButton) {
//        return nil;
//    }
//    
//    if (!_helpButton) {
//        _helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, helpButtonSize, helpButtonSize)];
//        _helpButton.imageEdgeInsets = UIEdgeInsetsMake(helpButtonPaddingUR, helpButtonPaddingBL, helpButtonPaddingBL - 1, helpButtonPaddingUR);
//        [_helpButton setImage:[UIImage imageNamed:@"helpButtonBg.png"] forState:UIControlStateNormal];
//        _helpButton.accessibilityLabel = NSLocalizedString(@"Help-Button-Accessibility-Label", @"Help Button");
//        _helpButton.isAccessibilityElement = YES;
//    }
    return _helpButton;
}

//- (void)setShowsHelpButton:(BOOL)showsHelpButton
//{
//    _showsHelpButton = showsHelpButton;
//    if (_helpButton.superview) {
//        [self.helpButton removeFromSuperview];
//        self.helpButton = nil;
//    }
//}

- (UIImageView *)helpButtonIcon
{
    if (!_helpButtonIcon) {
        _helpButtonIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robot.png"]];
    }
    return _helpButtonIcon;
}

@end