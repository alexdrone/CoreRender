/**
 * Copyright (c) 2014-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>
#import "Yoga.h"

static CGSize YGNaNSize = {
  .width = YGUndefined,
  .height = YGUndefined,
};

typedef NS_OPTIONS(NSInteger, YGDimensionFlexibility) {
  YGDimensionFlexibilityFlexibleWidth = 1 << 0,
  YGDimensionFlexibilityFlexibleHeigth = 1 << 1,
};

@interface YGLayout : NSObject

/**
  The property that decides if we should include this view when calculating layout. Defaults to YES.
 */
@property (nonatomic, readwrite, assign, setter=setIncludedInLayout:) BOOL isIncludedInLayout;

/**
 The property that decides during layout/sizing whether or not styling properties should be applied.
 Defaults to NO.
 */
@property (nonatomic, readwrite, assign, setter=setEnabled:) BOOL isEnabled;

@property (nonatomic, readwrite, assign) YGDirection direction;
@property (nonatomic, readwrite, assign) YGFlexDirection flexDirection;
@property (nonatomic, readwrite, assign) YGJustify justifyContent;
@property (nonatomic, readwrite, assign) YGAlign alignContent;
@property (nonatomic, readwrite, assign) YGAlign alignItems;
@property (nonatomic, readwrite, assign) YGAlign alignSelf;
@property (nonatomic, readwrite, assign) YGPositionType position;
@property (nonatomic, readwrite, assign) YGWrap flexWrap;
@property (nonatomic, readwrite, assign) YGOverflow overflow;
@property (nonatomic, readwrite, assign) YGDisplay display;

@property (nonatomic, readwrite, assign) CGFloat flexGrow;
@property (nonatomic, readwrite, assign) CGFloat flexShrink;
@property (nonatomic, readwrite, assign) CGFloat flexBasis;

@property (nonatomic, readwrite, assign) CGFloat left;
@property (nonatomic, readwrite, assign) CGFloat top;
@property (nonatomic, readwrite, assign) CGFloat right;
@property (nonatomic, readwrite, assign) CGFloat bottom;
@property (nonatomic, readwrite, assign) CGFloat start;
@property (nonatomic, readwrite, assign) CGFloat end;

@property (nonatomic, readwrite, assign) CGFloat marginLeft;
@property (nonatomic, readwrite, assign) CGFloat marginTop;
@property (nonatomic, readwrite, assign) CGFloat marginRight;
@property (nonatomic, readwrite, assign) CGFloat marginBottom;
@property (nonatomic, readwrite, assign) CGFloat marginStart;
@property (nonatomic, readwrite, assign) CGFloat marginEnd;
@property (nonatomic, readwrite, assign) CGFloat marginHorizontal;
@property (nonatomic, readwrite, assign) CGFloat marginVertical;
@property (nonatomic, readwrite, assign) CGFloat margin;

@property (nonatomic, readwrite, assign) CGFloat paddingLeft;
@property (nonatomic, readwrite, assign) CGFloat paddingTop;
@property (nonatomic, readwrite, assign) CGFloat paddingRight;
@property (nonatomic, readwrite, assign) CGFloat paddingBottom;
@property (nonatomic, readwrite, assign) CGFloat paddingStart;
@property (nonatomic, readwrite, assign) CGFloat paddingEnd;
@property (nonatomic, readwrite, assign) CGFloat paddingHorizontal;
@property (nonatomic, readwrite, assign) CGFloat paddingVertical;
@property (nonatomic, readwrite, assign) CGFloat padding;

@property (nonatomic, readwrite, assign) CGFloat borderLeftWidth;
@property (nonatomic, readwrite, assign) CGFloat borderTopWidth;
@property (nonatomic, readwrite, assign) CGFloat borderRightWidth;
@property (nonatomic, readwrite, assign) CGFloat borderBottomWidth;
@property (nonatomic, readwrite, assign) CGFloat borderStartWidth;
@property (nonatomic, readwrite, assign) CGFloat borderEndWidth;
@property (nonatomic, readwrite, assign) CGFloat borderWidth;

@property (nonatomic, readwrite, assign) CGFloat width;
@property (nonatomic, readwrite, assign) CGFloat height;
@property (nonatomic, readwrite, assign) CGFloat minWidth;
@property (nonatomic, readwrite, assign) CGFloat minHeight;
@property (nonatomic, readwrite, assign) CGFloat maxWidth;
@property (nonatomic, readwrite, assign) CGFloat maxHeight;

// Yoga specific properties, not compatible with flexbox specification
@property (nonatomic, readwrite, assign) CGFloat aspectRatio;

/**
 Get the resolved direction of this node. This won't be YGDirectionInherit
 */
@property (nonatomic, readonly, assign) YGDirection resolvedDirection;

/**
 Perform a layout calculation and update the frames of the views in the hierarchy with the results.
 If the origin is not preserved, the root view's layout results will applied from {0,0}.
 */
- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin
    NS_SWIFT_NAME(applyLayout(preservingOrigin:));

/**
 Perform a layout calculation and update the frames of the views in the hierarchy with the results.
 If the origin is not preserved, the root view's layout results will applied from {0,0}.
 */
- (void)applyLayoutPreservingOrigin:(BOOL)preserveOrigin
               dimensionFlexibility:(YGDimensionFlexibility)dimensionFlexibility
    NS_SWIFT_NAME(applyLayout(preservingOrigin:dimensionFlexibility:));

/**
 Returns the size of the view if no constraints were given. This could equivalent to calling [self
 sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
 */
@property (nonatomic, readonly, assign) CGSize intrinsicSize;

/**
 Returns the number of children that are using Flexbox.
 */
@property (nonatomic, readonly, assign) NSUInteger numberOfChildren;

/**
 Return a BOOL indiciating whether or not we this node contains any subviews that are included in
 Yoga's layout.
 */
@property (nonatomic, readonly, assign) BOOL isLeaf;

/**
 Return's a BOOL indicating if a view is dirty. When a node is dirty
 it usually indicates that it will be remeasured on the next layout pass.
 */
@property (nonatomic, readonly, assign) BOOL isDirty;

/** Analogous to flexShrink = 1 and flexGrow = 1 */
- (void)flex;

/**
 Mark that a view's layout needs to be recalculated. Only works for leaf views.
 */
- (void)markDirty;

@end

@interface YGLayout ()

@property (nonatomic, assign, readonly) YGNodeRef node;

/** Constructs a new layout object associated to the view passed as argument. */
- (instancetype)initWithView:(UIView *)view;
@end

// UIView+Yoga

NS_ASSUME_NONNULL_BEGIN

typedef void (^YGLayoutConfigurationBlock)(YGLayout *);

@interface UIView (Yoga)

/**
 The YGLayout that is attached to this view. It is lazily created.
 */
@property (nonatomic, readonly, strong) YGLayout *yoga;
/**
 Indicates whether or not Yoga is enabled
 */
@property (nonatomic, readonly, assign) BOOL isYogaEnabled;

/**
 In ObjC land, every time you access `view.yoga.*` you are adding another `objc_msgSend`
 to your code. If you plan on making multiple changes to YGLayout, it's more performant
 to use this method, which uses a single objc_msgSend call.
 */
- (void)configureLayoutWithBlock:(YGLayoutConfigurationBlock)block
NS_SWIFT_NAME(configureLayout(block:));

@end

NS_ASSUME_NONNULL_END
