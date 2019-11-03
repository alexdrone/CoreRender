#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CRNode.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(TypeErasedNodeBuilder)
@interface CRTypeErasedNodeBuilder : NSObject
/// The coordinator type assigned to this node.
- (instancetype)withCoordinatorDescriptor:(CRCoordinatorDescriptor *)descriptor;
/// Defines the node configuration and layout.
- (instancetype)withLayoutSpec:(void (^)(CRNodeLayoutSpec<UIView *> *))layoutSpec;
/// Build the concrete node.
- (CRNode *)build;
@end

NS_SWIFT_NAME(NodeBuilder)
@interface CRNodeBuilder<__covariant V : UIView *> : CRTypeErasedNodeBuilder
- (instancetype)init NS_UNAVAILABLE;
/// The view type of the desired @c CRNode.
- (instancetype)initWithType:(Class)type;
/// Optional reuse identifier.
/// @note: This is required if the node has a custom @c viewInit.
- (instancetype)withReuseIdentifier:(NSString *)reuseIdentifier;
/// Unique node key (required for stateful components).
/// @note: This is required if @c coordinatorType or @c state is set.
- (instancetype)withKey:(NSString *)key;
/// The coordinator type assigned to this node.
- (instancetype)withCoordinatorDescriptor:(CRCoordinatorDescriptor *)desc;
/// Custom view initialization code.
- (instancetype)withViewInit:(UIView * (^)(NSString *))viewInit;
/// Defines the node configuration and layout.
- (instancetype)withLayoutSpec:(void (^)(CRNodeLayoutSpec<V> *))layoutSpec;
/// Assign the node children.
- (instancetype)withChildren:(NSArray *)children;
/// Add a child to the node children list.
- (instancetype)addChild:(CRNode *)node;
/// Build the concrete node.
- (CRNode<V> *)build;
@end

NS_ASSUME_NONNULL_END
