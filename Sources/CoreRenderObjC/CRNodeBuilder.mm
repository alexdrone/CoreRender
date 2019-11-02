#import "CRNodeBuilder.h"
#import "CRCoordinator.h"
#import "CRMacros.h"

void CRNodeBuilderException(NSString *reason) {
  @throw [NSException exceptionWithName:@"NodeBuilderException" reason:reason userInfo:nil];
}

@implementation CRTypeErasedNodeBuilder

- (CRNode *)build {
  CR_ASSERT_ON_MAIN_THREAD();
  NSAssert(NO, @"Called on abstract super class.");
}

@end

@implementation CRNodeBuilder {
  Class _type;
  NSString *_reuseIdentifier;
  NSString *_key;
  CRCoordinator *_coordinator;
  Class _coordinatorType;
  UIView * (^_viewInit)(void);
  NSMutableArray *_layoutSpecBlocks;
  void (^_layoutSpec)(CRNodeLayoutSpec *);
  NSMutableArray<CRNode *> *_mutableChildren;
  CRProps *_volatileProps;
  CRState *_initialState;
}

- (instancetype)initWithType:(Class)type {
  CR_ASSERT_ON_MAIN_THREAD();
  if (self = [super init]) {
    _type = type;
    _layoutSpecBlocks = @[].mutableCopy;
    _mutableChildren = @[].mutableCopy;
    _volatileProps = [[CRNullProps alloc] init];
    _initialState = [[CRNullState alloc] init];
  }
  return self;
}

- (instancetype)withReuseIdentifier:(NSString *)reuseIdentifier {
  CR_ASSERT_ON_MAIN_THREAD();
  _reuseIdentifier = reuseIdentifier;
  return self;
}

- (instancetype)withKey:(NSString *)key {
  CR_ASSERT_ON_MAIN_THREAD();
  _key = key;
  return self;
}

- (instancetype)withCoordinator:(id)obj initialState:(CRState *)state props:(CRProps *)props {
  CR_ASSERT_ON_MAIN_THREAD();
  const auto coordinator = CR_DYNAMIC_CAST_OR_ASSERT(CRCoordinator, obj);
  _coordinator = coordinator;
  _key = coordinator.key;
  _initialState = state;
  _volatileProps = props;
  return self;
}

- (instancetype)withCoordinatorType:(Class)coordinatorType
                                key:(NSString *)key
                       initialState:(CRState *)state
                              props:(CRProps *)props {
  CR_ASSERT_ON_MAIN_THREAD();
  NSAssert([coordinatorType isSubclassOfClass:CRCoordinator.class], @"");
  _coordinatorType = coordinatorType;
  _key = key;
  _initialState = state;
  _volatileProps = props;
  return self;
}

- (instancetype)withViewInit:(UIView * (^)(NSString *))viewInit {
  CR_ASSERT_ON_MAIN_THREAD();
  NSString *key = _key;
  _viewInit = ^UIView *(void) { return viewInit(key); };
  return self;
}

- (instancetype)withLayoutSpec:(void (^)(CRNodeLayoutSpec *))layoutSpec {
  CR_ASSERT_ON_MAIN_THREAD();
  [_layoutSpecBlocks addObject:[layoutSpec copy]];
  return self;
}

- (instancetype)withProps:(CRProps *)props {
  CR_ASSERT_ON_MAIN_THREAD();
  _volatileProps = props;
  return self;
}

- (instancetype)withChildren:(NSArray *)children {
  CR_ASSERT_ON_MAIN_THREAD();
  _mutableChildren = children.mutableCopy;
  CR_FOREACH(child, _mutableChildren) { NSAssert([child isKindOfClass:CRNode.class], @""); }
  return self;
}

- (instancetype)addChild:(CRNode *)node {
  CR_ASSERT_ON_MAIN_THREAD();
  [_mutableChildren addObject:node];
  return self;
}

- (CRNode *)build {
  CR_ASSERT_ON_MAIN_THREAD();
  if (_coordinator) {
    _coordinatorType = _coordinator.class;
    _key = _coordinator.key;
  }
  if (_viewInit && !_reuseIdentifier) {
    CRNodeBuilderException(@"The node has a custom view initializer but no reuse identifier.");
    return CRNullNode.nullNode;
  }
  if (_coordinatorType && ![_coordinatorType isSubclassOfClass:CRCoordinator.class]) {
    CRNodeBuilderException(@"Illegal coordinator type.");
    return CRNullNode.nullNode;
  }
  if ((_coordinatorType && ![(id)_coordinatorType isStateless]) && !_key) {
    CRNodeBuilderException(@"Stateful coordinator withou a key.");
    return CRNullNode.nullNode;
  }
  if ((_coordinatorType && ![(id)_coordinatorType isStateless]) && !_initialState) {
    CRNodeBuilderException(@"Stateful coordinator withou an initial state.");
    return CRNullNode.nullNode;
  }
  __block const auto blocks = _layoutSpecBlocks;
  _layoutSpec = ^(CRNodeLayoutSpec *spec) {
    for (id obj in blocks) {
      void (^block)(CRNodeLayoutSpec *) = obj;
      block(spec);
    }
  };
  const auto node = [[CRNode alloc] initWithType:_type
                                 reuseIdentifier:_reuseIdentifier
                                             key:_key
                                        viewInit:_viewInit
                                      layoutSpec:_layoutSpec];
  if (_coordinatorType) {
    [node bindCoordinator:_coordinatorType initialState:_initialState props:_volatileProps];
  }
  [node appendChildren:_mutableChildren];
  return node;
}

@end
