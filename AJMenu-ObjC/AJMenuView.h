//
//  AJMenuView.h
//  AJMenu-ObjC
//
//  Created by Ajay Lalwani on 7/9/14.
//  Copyright (c) 2014 The Red Voice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJMenuView;

@protocol AJMenuViewDelegate <NSObject>

- (void) ajMenuView: (AJMenuView *) ajMenuView didTapButtonAtIndex: (NSInteger) index;

@end

@protocol AJMenuViewDataSource <NSObject>

- (UIImage *) imageForMenuButton;
- (UIImage *) imageForMenuItem;

@end


@interface AJMenuView : UIView

@property (nonatomic, weak) id<AJMenuViewDelegate> delegate;
@property (nonatomic, weak) id<AJMenuViewDataSource> datasource;

- (instancetype)initWithMenuItems: (NSArray *)menuItems andParentView: (UIView *) parentView;
- (void) configureView;

@end