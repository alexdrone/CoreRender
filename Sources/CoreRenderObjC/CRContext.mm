#import "CRContext+Private.h"
#import "CRController+Private.h"
#import "CRMacros.h"
#import "CRNode.h"

#pragma mark - CRControllerProvider

void CRControllerProviderException(NSString *reason) {
  //@throw [NSException exceptionWithName:@"ControllerProviderException" reason:reason
  // userInfo:nil];
  NSLog(@"%@", reason);
}

@implementation CRControllerProvider {
  NSString *_key;
  Class _type;
}

- (instancetype)initWithContext:(CRContext *)context
                           type:(Class)controllerType
                  controllerKey:(NSString *)controllerKey {
  if (self = [super init]) {
    _context = context;
    _key = controllerKey;
    _type = controllerType;
  }
  return self;
}

- (CRController *)controller {
  CRController *controller;
  if (_key) {
    controller = [_context controllerOfType:_type withKey:_key];
  } else {
    controller = [_context controllerOfType:_type];
  }
  if (!controller.props || !controller.state) {
    CRControllerProviderException(@"The controller has not yet been init'd (no props/ state set)");
  }
  if (!controller.node) {
    CRControllerProviderException(@"The controller has no node.");
  }
  return controller;
}

@end

#pragma mark - CRContext

@implementation CRContext {
  NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, CRController *> *> *_controllers;
  NSPointerArray *_delegates;
}

- (instancetype)init {
  if (self = [super init]) {
    _controllers = @{}.mutableCopy;
    _delegates = [NSPointerArray weakObjectsPointerArray];
  }
  return self;
}

- (__kindof CRController *)controllerOfType:(Class)type withKey:(NSString *)key {
  CR_ASSERT_ON_MAIN_THREAD();
  if (![type isSubclassOfClass:CRController.self]) return nil;
  const auto container = [self _containerForType:type];
  if (const auto controller = container[key]) return controller;
  const auto controller = CR_DYNAMIC_CAST(CRController, [[type alloc] initWithKey:key]);
  controller.context = self;
  container[key] = controller;
  return controller;
}

- (__kindof CRStatelessController *)controllerOfType:(Class)type {
  CR_ASSERT_ON_MAIN_THREAD();
  if (![type isStateless]) return nil;
  return [self controllerOfType:type withKey:CRControllerStatelessKey];
}

- (CRControllerProvider *)controllerProviderOfType:(Class)type withKey:(NSString *)key {
  return [[CRControllerProvider alloc] initWithContext:self type:type controllerKey:key];
}

- (CRControllerProvider *)controllerProviderOfType:(Class)type {
  return [[CRControllerProvider alloc] initWithContext:self type:type controllerKey:nil];
}

- (NSMutableDictionary<NSString *, CRController *> *)_containerForType:(Class)type {
  const auto str = NSStringFromClass(type);
  if (const auto container = _controllers[str]) return container;
  const auto container = [[NSMutableDictionary<NSString *, CRController *> alloc] init];
  _controllers[str] = container;
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
