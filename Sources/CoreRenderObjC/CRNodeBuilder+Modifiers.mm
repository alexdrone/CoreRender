#import "CRController.h"
#import "CRMacros.h"
#import "CRNodeBuilder+Modifiers.h"
#import "CRNodeLayoutSpec.h"
#import "YGLayout.h"

@implementation CRNodeBuilder (Modifiers)

- (instancetype)padding:(CGFloat)padding {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.padding) value:@(padding)];
  }];
}

- (instancetype)paddingInsets:(UIEdgeInsets)padding {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.paddingTop) value:@(padding.top)];
    [spec set:CR_KEYPATH(spec.view, yoga.paddingBottom) value:@(padding.bottom)];
    [spec set:CR_KEYPATH(spec.view, yoga.paddingLeft) value:@(padding.left)];
    [spec set:CR_KEYPATH(spec.view, yoga.paddingRight) value:@(padding.right)];
  }];
}

- (instancetype)margin:(CGFloat)margin {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.margin) value:@(margin)];
  }];
}

- (instancetype)marginInsets:(UIEdgeInsets)margin {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.marginTop) value:@(margin.top)];
    [spec set:CR_KEYPATH(spec.view, yoga.marginBottom) value:@(margin.bottom)];
    [spec set:CR_KEYPATH(spec.view, yoga.marginLeft) value:@(margin.left)];
    [spec set:CR_KEYPATH(spec.view, yoga.marginRight) value:@(margin.right)];
  }];
}

- (instancetype)border:(UIEdgeInsets)border {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.borderTopWidth) value:@(border.top)];
    [spec set:CR_KEYPATH(spec.view, yoga.borderBottomWidth) value:@(border.bottom)];
    [spec set:CR_KEYPATH(spec.view, yoga.borderLeftWidth) value:@(border.left)];
    [spec set:CR_KEYPATH(spec.view, yoga.borderRightWidth) value:@(border.right)];
  }];
}

- (instancetype)background:(UIColor *)color {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, backgroundColor) value:color];
  }];
}

- (instancetype)cornerRadius:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, clipsToBounds) value:@(YES)];
    [spec set:CR_KEYPATH(spec.view, layer.cornerRadius) value:@(value)];
  }];
}

- (instancetype)clipped:(BOOL)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, clipsToBounds) value:@(value)];
  }];
}

- (instancetype)hidden:(BOOL)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, hidden) value:@(value)];
  }];
}

- (instancetype)opacity:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, alpha) value:@(YES)];
  }];
}

- (instancetype)flexDirection:(YGFlexDirection)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.flexDirection) value:@(value)];
  }];
}

- (instancetype)justifyContent:(YGJustify)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.justifyContent) value:@(value)];
  }];
}

- (instancetype)alignContent:(YGAlign)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.alignContent) value:@(value)];
  }];
}

- (instancetype)alignItems:(YGAlign)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.alignItems) value:@(value)];
  }];
}

- (instancetype)alignSelf:(YGAlign)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.alignSelf) value:@(value)];
  }];
}

- (instancetype)position:(YGPositionType)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.position) value:@(value)];
  }];
}

- (instancetype)flexWrap:(YGWrap)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.flexWrap) value:@(value)];
  }];
}

- (instancetype)overflow:(YGOverflow)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.overflow) value:@(value)];
  }];
}

- (instancetype)flex {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec.view.yoga flex];
  }];
}

- (instancetype)flexGrow:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.flexGrow) value:@(value)];
  }];
}

- (instancetype)flexShrink:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.flexShrink) value:@(value)];
  }];
}

- (instancetype)flexBasis:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.flexBasis) value:@(value)];
  }];
}

- (instancetype)width:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.width) value:@(value)];
  }];
}

- (instancetype)height:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.height) value:@(value)];
  }];
}

- (instancetype)minWidth:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.minWidth) value:@(value)];
  }];
}

- (instancetype)minHeight:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.minHeight) value:@(value)];
  }];
}

- (instancetype)maxWidth:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.maxWidth) value:@(value)];
  }];
}

- (instancetype)maxHeight:(CGFloat)value {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.maxHeight) value:@(value)];
  }];
}

- (instancetype)matchParentWidthWithMargin:(CGFloat)margin {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.width) value:@(spec.size.width - 2 * margin)];
  }];
}

- (instancetype)matchParentHeightWithMargin:(CGFloat)margin {
  return [self withLayoutSpec:^(CRNodeLayoutSpec *spec) {
    [spec set:CR_KEYPATH(spec.view, yoga.height) value:@(spec.size.height - 2 * margin)];
  }];
}


@end
