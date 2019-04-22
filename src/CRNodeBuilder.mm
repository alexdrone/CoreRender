
#import "CRNodeBuilder.h"
#import "CRController.h"
#import "CRMacros.h"

void CRNodeBuilderException(NSString *reason) {
  @throw [NSException exceptionWithName:@"NodeBuilderException" reason:reason userInfo:nil];
}

@implementation CRNodeBuilder {
  Class _type;
  NSString *_reuseIdentifier;
  NSString *_key;
  CRController *_controller;
  Class _controllerType;
  UIView * (^_viewInit)(void);
  void (^_layoutSpec)(CRNodeLayoutSpec *);
  NSMutableArray<CRNode *> *_mutableChildren;
  CRProps *_volatileProps;
  CRState *_initialState;
}

- (instancetype)initWithType:(Class)type {
  CR_ASSERT_ON_MAIN_THREAD();
  if (self = [super init]) {
    _type = type;
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

- (instancetype)withController:(id)obj initialState:(CRState *)state props:(CRProps *)props {
  CR_ASSERT_ON_MAIN_THREAD();
  const auto controller = CR_DYNAMIC_CAST_OR_ASSERT(CRController, obj);
  _controller = controller;
  _key = controller.key;
  _initialState = state;
  _volatileProps = props;
  return self;
}

- (instancetype)withControllerType:(Class)controllerType
                               key:(NSString *)key
                      initialState:(CRState *)state
                             props:(CRProps *)props {
  CR_ASSERT_ON_MAIN_THREAD();
  NSAssert([controllerType isSubclassOfClass:CRController.class], @"");
  _controllerType = controllerType;
  _key = key;
  _initialState = state;
  _volatileProps = props;
  return self;
}

- (instancetype)withViewInit:(UIView * (^)(NSString *))viewInit {
  CR_ASSERT_ON_MAIN_THREAD();
  NSString *key = _key;
  _viewInit = ^UIView *(void){
    return viewInit(key);
  };
  return self;
}

- (instancetype)withLayoutSpec:(void (^)(CRNodeLayoutSpec *))layoutSpec {
  CR_ASSERT_ON_MAIN_THREAD();
  _layoutSpec = layoutSpec;
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
  if (_controller) {
    _controllerType = _controller.class;
    _key = _controller.key;
  }
  if (_viewInit && !_reuseIdentifier) {
    CRNodeBuilderException(@"The node has a custom view initializer but no reuse identifier.");
    return CRNullNode.nullNode;
  }
  if (_controllerType && ![_controllerType isSubclassOfClass:CRController.class]) {
    CRNodeBuilderException(@"Illegal controller type.");
    return CRNullNode.nullNode;
  }
  if ((_controllerType && ![(id)_controllerType isStateless]) && !_key) {
    CRNodeBuilderException(@"Stateful controller withou a key.");
    return CRNullNode.nullNode;
  }
  if ((_controllerType && ![(id)_controllerType isStateless]) && !_initialState) {
    CRNodeBuilderException(@"Stateful controller withou an initial state.");
    return CRNullNode.nullNode;
  }
  _layoutSpec = _layoutSpec ?: ^(CRNodeLayoutSpec *) {
  };
  const auto node = [[CRNode alloc] initWithType:_type
                                 reuseIdentifier:_reuseIdentifier
                                             key:_key
                                        viewInit:_viewInit
                                      layoutSpec:_layoutSpec];
  if (_controllerType) {
    [node bindController:_controllerType initialState:_initialState props:_volatileProps];
  }
  [node appendChildren:_mutableChildren];
  return node;
}

@end
