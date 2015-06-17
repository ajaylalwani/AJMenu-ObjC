//
//  AJMenuView.m
//  AJMenu-ObjC
//
//  Created by Ajay Lalwani on 7/9/14.
//  Copyright (c) 2014 The Red Voice. All rights reserved.
//

#import "AJMenuView.h"
#import "AJMenuConstants.h"

@interface AJMenuView ()

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSMutableArray *menuButtons;
@property (nonatomic, strong) NSMutableArray *menuLabels;
@property (nonatomic, strong) UIButton *btnMainMenu;
@property (nonatomic, strong) UIView *overlayView;

@end

@implementation AJMenuView

- (instancetype)initWithMenuItems: (NSArray *)menuItems andParentView: (UIView *) parentView
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        if (menuItems && menuItems.count > 0) {
            self.parentView = parentView;
            self.menuItems = menuItems;
            self.menuButtons = [[NSMutableArray alloc] initWithCapacity:menuItems.count];
            self.menuLabels = [[NSMutableArray alloc] initWithCapacity:menuItems.count];
        }
    }
    return self;
}

- (void) configureView {
    CGRect viewBounds = self.bounds;
    
    self.backgroundColor = [UIColor clearColor];
    //self.userInteractionEnabled = NO;
    
    self.overlayView = [[UIView alloc] initWithFrame:viewBounds];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.7;
    self.overlayView.userInteractionEnabled = NO;
    
    self.btnMainMenu = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBounds) - menuItemWidth- horizontalPadding, (3 * verticalPadding), menuItemWidth, menuItemHeight)];
    [self.btnMainMenu setBackgroundImage:[self.datasource imageForMenuButton] forState:UIControlStateNormal];
    [self.btnMainMenu addTarget:self action:@selector(mainMenuButtonDragged:forEvent:) forControlEvents:UIControlEventTouchDragInside];

    self.btnMainMenu.layer.masksToBounds = false;
    self.btnMainMenu.layer.shadowColor = [UIColor blackColor].CGColor;
    self.btnMainMenu.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    self.btnMainMenu.layer.shadowOpacity = 1.0;
    self.btnMainMenu.layer.shadowRadius = 3.0;
    
    [self addSubview:self.overlayView];
    [self addSubview:self.btnMainMenu];
    
    UIButton *menuButton = nil;
    UILabel *menuLabel = nil;
    
    
    for (NSInteger i = 0; i < self.menuItems.count; i++) {
        
        // Button
        menuButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBounds) - menuItemWidth - horizontalPadding, ((i + 4) * verticalPadding) + ((i + 1) * menuItemHeight), menuItemWidth, menuItemHeight)];
        [menuButton setBackgroundImage:[self.datasource imageForMenuItem] forState:UIControlStateNormal];
        menuButton.tag = i;
        [menuButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // Label
        menuLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetWidth(viewBounds) - menuItemWidth - horizontalPadding - labelPadding - labelWidth, ((i + 4) * verticalPadding) + ((i + 1) * menuItemHeight) + labelHeight/2, labelWidth, labelHeight)];
        menuLabel.text = self.menuItems[i];
        menuLabel.textAlignment = NSTextAlignmentRight;
        menuLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
        menuLabel.textColor = [UIColor whiteColor];
        

        [self addSubview:menuButton];
        [self addSubview:menuLabel];
        
        [self.menuButtons addObject:menuButton];
        [self.menuLabels addObject:menuLabel];
    }
    
    [self animateMenuToHideControls];
}

#pragma mark - Action Methods

- (void) mainMenuButtonDragged:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch locationInView:self].x > CGRectGetWidth(self.bounds) - (0.8 * menuItemWidth)) {
        [self animateMenuToHideControls];
        
    } else {
        [self animateMenuToShowControls];
    }
}

- (void) buttonClicked: (UIButton *) sender {
    [self animateMenuToHideControls];
    [self.delegate ajMenuView:self didTapButtonAtIndex:sender.tag];
}

#pragma mark - Animations
- (void) animateMenuToHideControls {
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         self.btnMainMenu.transform = CGAffineTransformMakeRotation(0);
                         
                         self.btnMainMenu.transform = CGAffineTransformMakeTranslation((menuItemWidth * 0.2) + horizontalPadding, 0);
                         for (UILabel *menuLabel in self.menuLabels) {
                             menuLabel.alpha = 0;
                         }
                         
                         for (UIButton *menuButton in self.menuButtons) {
                             menuButton.transform = CGAffineTransformMakeTranslation(menuItemWidth + horizontalPadding, 0);
                         }
                         
                         self.overlayView.alpha = 0;
                     }];
    self.overlayView.userInteractionEnabled = NO;
}


- (void) animateMenuToShowControls {
    
    self.overlayView.alpha = 0.7;
    
    for (NSInteger i = 0; i < self.menuItems.count; i++) {
        [UIView animateWithDuration:(5 + i)/10.0
                         animations:^{
                             ((UIButton *)self.menuButtons[i]).transform = CGAffineTransformMakeTranslation(0, 0);
                             ((UILabel *)self.menuLabels[i]).alpha = 1;
                             self.btnMainMenu.transform = CGAffineTransformMakeRotation(M_PI);
                         }];
        
    }
    self.overlayView.userInteractionEnabled = YES;
}


// To ensure that the view does not respond to touches.
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
        return nil;
    else
        return hitView;
}


@end
