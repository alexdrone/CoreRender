#import "CRController+Private.h"
#import "CRMacros.h"
#import "CRNode.h"

NSString *CRControllerStatelessKey = @"_CRControllerStatelessKey";
NSString *CRIllegalControllerTypeExceptionName = @"IllegalControllerType";

#pragma mark - Props & State

@implementation CRProps
@end

@implementation CRState
@end

#pragma mark - Controller

@implementation CRController

- (CRNodeHierarchy *)nodeHierarchy {
  return _node.nodeHierarchy;
}

// By default controllers are *stateful*.
// Override @c CRStatelessController for a *stateless* controller.
+ (BOOL)isStateless {
  return NO;
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

#pragma mark - StatelessController

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

@implementation CRStatelessController

+ (BOOL)isStateless {
  return YES;
}

@end
