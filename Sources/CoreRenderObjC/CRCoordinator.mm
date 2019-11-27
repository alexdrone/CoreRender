#import "CRContext.h"
#import "CRCoordinator+Private.h"
#import "CRMacros.h"
#import "CRNode.h"

NSString *CRCoordinatorStatelessKey = @"_CRCoordinatorStatelessKey";
NSString *CRIllegalCoordinatorTypeExceptionName = @"IllegalCoordinatorType";

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
  return [[CRCoordinatorDescriptor alloc] initWithType:self.class key:self.key];
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
