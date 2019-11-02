#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CRNodeBuilder.h"
#import "YGLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRNodeBuilder (Modifiers)

/// Padding for the view.
- (instancetype)padding:(CGFloat)padding;

/// Pads the view using the specified edge insets.
- (instancetype)paddingInsets:(UIEdgeInsets)padding;

/// Margins for the view.
- (instancetype)margin:(CGFloat)padding;

/// Margins for the view using the specified edge insets.
- (instancetype)marginInsets:(UIEdgeInsets)padding;

/// Borders for the view using the specified edge insets.
- (instancetype)border:(UIEdgeInsets)border;

/// The view background color.
- (instancetype)background:(UIColor *)color;

/// Clips the view to its bounding frame, with the specified corner radius.
- (instancetype)cornerRadius:(CGFloat)value;

/// Clips the view to its bounding rectangular frame.
- (instancetype)clipped:(BOOL)value;

/// Whether the view is hidden or not.
- (instancetype)hidden:(BOOL)value;

/// Sets the transparency of the view.
- (instancetype)opacity:(CGFloat)value;

/// Controls the direction in which the children of a node are laid out.
/// This is also referred to as the main axis. The cross axis is the axis perpendicular to
/// the main axis, or the axis which the wrapping lines are laid out in.
- (instancetype)flexDirection:(YGFlexDirection)value;

/// Defines how to distribute space between and around content
/// items along the main-axis of a flex container, and the inline axis of a grid container.
- (instancetype)justifyContent:(YGJustify)value;

/// Controls how rows align in the cross direction, overriding the @c alignContent
/// of the parent.
- (instancetype)alignContent:(YGAlign)value;

/// Aligns children in the cross direction. For example, if children are flowing
/// vertically, @c alignItems controls how they align horizontally.
- (instancetype)alignItems:(YGAlign)value;

/// Controls how a child aligns in the cross direction, overriding the
/// @c alignItems of the parent.
- (instancetype)alignSelf:(YGAlign)value;

/// Absolute positioning is always relative to the parent.
/// If you want to position a child using specific numbers of logical pixels relative to its
/// parent, set the child to have absolute position.
/// If you want to position a child relative to something that is not its parent, don't use
/// styles for that. Use the component tree.
- (instancetype)position:(YGPositionType)value;

/// Controls whether children can wrap around after they hit the end of a flex container.
- (instancetype)flexWrap:(YGWrap)value;

/// Controls how children are measured and displayed
- (instancetype)overflow:(YGOverflow)value;

/// Default flex appearance.
- (instancetype)flex;

/// Sets the flex grow factor of a flex item main size. It specifies how much of the remaining
/// space in the flex container should be assigned to the item (the flex grow factor).
/// The main size is either width or height of the item which is dependent on the @c
/// flexDirection value.
/// The remaining space is the size of the flex container minus the size of all flex items' sizes
/// together. If all sibling items have the same flex grow factor, then all items will receive
/// the same share of remaining space, otherwise it is distributed according to the ratio
/// defined by the different flex grow factors.
- (instancetype)flexGrow:(CGFloat)value;

/// Sets the flex shrink factor of a flex item.
- (instancetype)flexShrink:(CGFloat)value;

/// Sets the initial main size of a flex item.
- (instancetype)flexBasis:(CGFloat)value;

/// The view fixed width.
- (instancetype)width:(CGFloat)value;

/// The view fixed height.
- (instancetype)height:(CGFloat)value;

/// The view minimum width.
- (instancetype)minWidth:(CGFloat)value;

/// The view minimum height.
- (instancetype)minHeight:(CGFloat)value;

/// The view maximum width.
- (instancetype)maxWidth:(CGFloat)value;

/// The view maximum height.
- (instancetype)maxHeight:(CGFloat)value;

/// Matches the parent width.
- (instancetype)matchHostingViewWithMargin:(CGFloat)margin;

/// Matches the parent height.
- (instancetype)matchHostingViewWithMargin:(CGFloat)margin;

@end

NS_ASSUME_NONNULL_END
