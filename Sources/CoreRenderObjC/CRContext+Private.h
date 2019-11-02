#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CRContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface CRContext (Private)

/// Returns the coordinator (or instantiate a new one) of type @c type for the unique identifier
/// passed as argument.
/// @note: Returns @c nil if @c type is not a subclass of @c CRCoordinator (or if it's a statelss
/// coordinator).
- (nullable __kindof CRCoordinator *)coordinatorOfType:(Class)type withKey:(NSString *)key;

/// Returns the coordinator (or instantiate a new one) of type @c type.
/// @note: Returns @c nil if @c type is not a subclass of @c CRStatelessCoordinator.
- (nullable __kindof CRStatelessCoordinator *)coordinatorOfType:(Class)type;

@end

NS_ASSUME_NONNULL_END
