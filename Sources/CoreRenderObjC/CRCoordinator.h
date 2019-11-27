#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CRContext;
@class CRNode;
@class CRNodeHierarchy;
@class CRCoordinatorDescriptor;
@protocol CRNodeDelegate;

extern NSString *CRCoordinatorStatelessKey;

NS_SWIFT_NAME(Coordinator)
@interface CRCoordinator : NSObject
/// The context associated with this coordinator.
@property(nonatomic, readonly, nullable, weak) CRContext *context;
/// The key for this coordinator.
/// If this coordinator is @c transient the value of this property is @c CRCoordinatorStatelessKey.
@property(nonatomic, readonly) NSString *key;
/// The UI node assigned to this coordinator.
@property(nonatomic, readonly, nullable, weak) CRNodeHierarchy *body;
/// The UI node assigned to this coordinator.
@property(nonatomic, readonly, nullable, weak) CRNode *node;
/// Returns the coordinator descriptor.
@property(nonatomic, readonly) CRCoordinatorDescriptor *prototype;

/// Coordinators are instantiated from @c CRContext.
- (instancetype)init;

/// Called whenever the coordinator is constructed.
- (void)onInit;

/// The UI node  associated to this coordinator has just been added to the view hierarchy.
/// @note: This is similiar to @c viewDidAppear on @c UIViewController.
- (void)onMount;

@end

NS_ASSUME_NONNULL_END
