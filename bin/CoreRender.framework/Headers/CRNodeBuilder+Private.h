#import <UIKit/UIKit.h>
#import "CRNode.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(_NodeBuilder)
@interface _CRNodeBuilder: NSObject
/// Assign the node children.
- (instancetype)withChildren:(NSArray *)children;
/// Build the concrete node.
- (CRNode *)build;
@end

NS_ASSUME_NONNULL_END
