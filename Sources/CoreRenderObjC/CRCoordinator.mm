#import "CRContext.h"
#import "CRCoordinator+Private.h"
#import "CRMacros.h"
#import "CRNode.h"

NSString *CRCoordinatorStatelessKey = @"_CRCoordinatorStatelessKey";
NSString *CRIllegalCoordinatorTypeExceptionName = @"IllegalCoordinatorType";

#pragma mark - Props & State

@implementation CRProps
@end

@implementation CRState
@end

#pragma mark - Coordinator

@implementation CRCoordinator

- (instancetype)init {
  if (self = [super init]) {
  }
  return self;
}

- (CRNodeHierarchy *)body {
  return _node.nodeHierarchy;
}

- (CRCoordinatorDescriptor *)prototype {
  return [[CRCoordinatorDescriptor
      alloc] initWithType:self.class key:self.key initialState:self.anyState props:self.anyProps];
}

// By default coordinators are *stateful*.
// Override @c CRStatelessCoordinator for a *stateless* coordinator.
+ (BOOL)isStateless {
  return false;
}

// Private constructor.
- (instancetype)initWithKey:(NSString *)key {
  if (self = [super init]) {
    _key = key;
  }
  return self;
}

- (void)onInit {
  // Override in subclasses.
}

- (void)onMount {
  // Override in subclasses.
}

@end

#pragma mark - StatelessCoordinator

@implementation CRNullState

+ (CRNullState *)null {
  static CRNullState *shared;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^() {
    shared = [[CRNullState alloc] init];
  });
  return shared;
}

@end

@implementation CRNullProps

+ (CRNullProps *)null {
  static CRNullProps *shared;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^() {
    shared = [[CRNullProps alloc] init];
  });
  return shared;
}

@end

@implementation CRStatelessCoordinator

+ (BOOL)isStateless {
  return YES;
}

@end
