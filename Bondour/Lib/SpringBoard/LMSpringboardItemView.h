//
//  LMSpringboardItemView.h
//  WatchSpringboard
//
//  Created by Lucas Menge on 10/24/14.
//  Copyright (c) 2014 Lucas Menge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LMSpringboardItemView : UIView

@property (readonly) UIImageView* icon;
@property (readonly) UILabel* label;
@property (nonatomic) CGFloat scale;
- (void)setScale:(CGFloat)scale animated:(BOOL)animated;
@property (nonatomic) BOOL isFolderLike;

@property (nonatomic, copy) NSString* bundleIdentifier;
@property (nonatomic, copy) NSString* objectId;
@property (nonatomic, copy) PFObject* object;

- (void)setTitle:(NSString*)title;
- (void)setObjectId:(NSString *)objectId;
- (void)setObject:(PFObject *)object;

@end



