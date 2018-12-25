#import <UIKit/UIKit.h>
#import "CRNode.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(NodeBuilder)
@interface CRNodeBuilder<__covariant V : UIView *> : NSObject
- (instancetype)init NS_UNAVAILABLE;
/// The view type of the desired @c CRNode.
- (instancetype)initWithType:(Class)type;
/// Optional reuse identifier.
/// @note: This is required if the node has a custom @c viewInit.
- (instancetype)withReuseIdentifier:(NSString *)reuseIdentifier;
/// Unique node key (required for stateful components).
/// @note: This is required if @c controllerType or @c state is set.
- (instancetype)withKey:(NSString *)key;
/// Manually assign a controller to this node.
/// @note: The node will automatically have the same node of the controller passed as argument.
- (instancetype)withController:(id)controller;
/// The controller type assigned to this node.
- (instancetype)withControllerType:(Class)controllerType;
/// Custom view initialization code.
- (instancetype)withViewInit:(UIView * (^)(void))viewInit;
/// Defines the node configuration and layout.
- (instancetype)withLayoutSpec:(void (^)(CRNodeLayoutSpec<V> *))layoutSpec;
/// Assign the node children.
- (instancetype)withChildren:(NSArray *)children;
/// Externally defined props.
- (instancetype)withProps:(CRProps *)props;
/// The initial state for this node (if applicable).
- (instancetype)withInitialState:(CRState *)state;
/// Add a child to the node children list.
- (instancetype)addChild:(CRNode *)node;
/// Build the concrete node.
- (CRNode<V> *)build;
@end
NS_ASSUME_NONNULL_END
