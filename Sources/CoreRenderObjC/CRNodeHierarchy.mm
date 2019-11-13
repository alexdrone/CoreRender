#import "CRNodeHierarchy.h"
#import "CRContext.h"
#import "CRMacros.h"

@implementation CRNodeHierarchy {
  __weak CRContext *_context;
  __weak UIView *_containerView;
  CGSize _size;
  CRNodeLayoutOptions _options;
  CRNode * (^_buildNodeHierarchy)(CRContext *);
}

- (instancetype)initWithContext:(CRContext *)context
           nodeHierarchyBuilder:(CRNode * (^)(CRContext *))buildNodeHierarchy {
  if (self = [super init]) {
    _context = context;
    _buildNodeHierarchy = buildNodeHierarchy;
  }
  return self;
}

#pragma mark Render

- (void)buildHierarchyInView:(UIView *)view
           constrainedToSize:(CGSize)size
                 withOptions:(CRNodeLayoutOptions)options {
  CR_ASSERT_ON_MAIN_THREAD();
  _containerView = view;
  _size = size;
  _options = options;
  _root = _buildNodeHierarchy(_context);
  [_root registerNodeHierarchyInContext:_context];
  [_root setNodeHierarchy:self];
  [_root reconcileInView:view constrainedToSize:size withOptions:options];
  [_root layoutConstrainedToSize:size withOptions:options];
}

- (void)reconcileInView:(nullable UIView *)view
      constrainedToSize:(CGSize)size
            withOptions:(CRNodeLayoutOptions)options {
  CR_ASSERT_ON_MAIN_THREAD();
  _containerView = view;
  _size = size;
  _options = options;
  [_root reconcileInView:view constrainedToSize:size withOptions:options];
}

- (void)layoutConstrainedToSize:(CGSize)size withOptions:(CRNodeLayoutOptions)options {
  _size = size;
  _options = options;
  CR_ASSERT_ON_MAIN_THREAD();
  [_root layoutConstrainedToSize:size withOptions:options];
}

- (void)setNeedsReconcile {
  CR_ASSERT_ON_MAIN_THREAD();
  [self buildHierarchyInView:_containerView constrainedToSize:_size withOptions:_options];
}

- (void)setNeedsLayout {
  CR_ASSERT_ON_MAIN_THREAD();
  [self layoutConstrainedToSize:_size withOptions:_options];
}

@end
