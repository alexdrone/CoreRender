#import "CRContext+Private.h"
#import "CRCoordinator+Private.h"
#import "CRMacros.h"
#import "CRNode.h"

#pragma mark - CRCoordinatorProvider

void CRCoordinatorProviderException(NSString *reason) {
  //@throw [NSException exceptionWithName:@"CoordinatorProviderException" reason:reason
  // userInfo:nil];
  NSLog(@"%@", reason);
}

@implementation CRCoordinatorProvider {
  NSString *_key;
  Class _type;
}

- (instancetype)initWithContext:(CRContext *)context
                           type:(Class)coordinatorType
                 coordinatorKey:(NSString *)coordinatorKey {
  if (self = [super init]) {
    _context = context;
    _key = coordinatorKey;
    _type = coordinatorType;
  }
  return self;
}

- (CRCoordinator *)coordinator {
  CRCoordinator *coordinator;
  if (_key) {
    coordinator = [_context coordinatorOfType:_type withKey:_key];
  } else {
    coordinator = [_context coordinatorOfType:_type];
  }
  if (!coordinator.props || !coordinator.state) {
    CRCoordinatorProviderException(
        @"The coordinator has not yet been init'd (no props/ state set)");
  }
  if (!coordinator.node) {
    CRCoordinatorProviderException(@"The coordinator has no node.");
  }
  return coordinator;
}

@end

#pragma mark - CRContext

@implementation CRContext {
  NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, CRCoordinator *> *>
      *_coordinators;
  NSPointerArray *_delegates;
}

- (instancetype)init {
  if (self = [super init]) {
    _coordinators = @{}.mutableCopy;
    _delegates = [NSPointerArray weakObjectsPointerArray];
  }
  return self;
}

- (__kindof CRCoordinator *)coordinatorOfType:(Class)type withKey:(NSString *)key {
  CR_ASSERT_ON_MAIN_THREAD();
  if (![type isSubclassOfClass:CRCoordinator.self]) return nil;
  const auto container = [self _containerForType:type];
  if (const auto coordinator = container[key]) return coordinator;
  const auto coordinator = CR_DYNAMIC_CAST(CRCoordinator, [[type alloc] initWithKey:key]);
  coordinator.context = self;
  container[key] = coordinator;
  return coordinator;
}

- (__kindof CRStatelessCoordinator *)coordinatorOfType:(Class)type {
  CR_ASSERT_ON_MAIN_THREAD();
  if (![type isStateless]) return nil;
  return [self coordinatorOfType:type withKey:CRCoordinatorStatelessKey];
}

- (CRCoordinatorProvider *)coordinatorProviderOfType:(Class)type withKey:(NSString *)key {
  return [[CRCoordinatorProvider alloc] initWithContext:self type:type coordinatorKey:key];
}

- (CRCoordinatorProvider *)coordinatorProviderOfType:(Class)type {
  return [[CRCoordinatorProvider alloc] initWithContext:self type:type coordinatorKey:nil];
}

- (NSMutableDictionary<NSString *, CRCoordinator *> *)_containerForType:(Class)type {
  const auto str = NSStringFromClass(type);
  if (const auto container = _coordinators[str]) return container;
  const auto container = [[NSMutableDictionary<NSString *, CRCoordinator *> alloc] init];
  _coordinators[str] = container;
  return container;
}

- (void)addDelegate:(id<CRContextDelegate>)delegate {
  CR_ASSERT_ON_MAIN_THREAD();
  [_delegates compact];
  for (NSUInteger i = 0; i < _delegates.count; i++)
    if ([_delegates pointerAtIndex:i] == (__bridge void *)(delegate)) return;
  [_delegates addPointer:(__bridge void *)delegate];
}

- (void)removeDelegate:(id<CRContextDelegate>)delegate {
  CR_ASSERT_ON_MAIN_THREAD();
  [_delegates compact];
  NSUInteger removeIdx = NSNotFound;
  for (NSUInteger i = 0; i < _delegates.count; i++)
    if ([_delegates pointerAtIndex:i] == (__bridge void *)(delegate)) {
      removeIdx = i;
      break;
    }
  if (removeIdx != NSNotFound) [_delegates removePointerAtIndex:removeIdx];
}

@end
