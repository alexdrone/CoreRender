#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CRContext;
@class CRNode;
@class CRNodeHierarchy;
@class CRCoordinatorDescriptor;
@protocol CRNodeDelegate;

extern NSString *CRCoordinatorStatelessKey;

/// Represents the properties that are externally injected into the coordinator.
/// This may contains *arguments*, *model objects*, *delegates* or *injectable services*.
NS_SWIFT_NAME(Props)
@interface CRProps : NSObject
@end

/// Represents the internal state of a coordinator.
NS_SWIFT_NAME(State)
@interface CRState : NSObject
/// The unique key for this state.
@property(nonatomic, readonly) NSString *key;
@end

NS_SWIFT_NAME(Coordinator)
@interface CRCoordinator<__covariant P : CRProps *, __covariant S : CRState *> : NSObject
/// The context associated with this coordinator.
@property(nonatomic, readonly, nullable, weak) CRContext *context;
/// Whether this coordinator is stateful or not.
/// Transient coordinators can be reused for several UI nodes at the same time and can be disposed
/// and rebuilt at any given time.
@property(class, nonatomic, readonly, getter=isStateless) BOOL stateless;
/// The key for this coordinator.
/// If this coordinator is @c transient the value of this property is @c CRCoordinatorStatelessKey.
@property(nonatomic, readonly) NSString *key;
/// The props currently assigned to this coordinator.
@property(nonatomic, readwrite) P props;
/// The current coordinator state.
@property(nonatomic, readwrite) S state;
/// The UI node assigned to this coordinator.
@property(nonatomic, readonly, nullable, weak) CRNodeHierarchy *body;
/// The UI node assigned to this coordinator.
@property(nonatomic, readonly, nullable, weak) CRNode *node;
/// Returns the coordinator descriptor.
@property(nonatomic, readonly) CRCoordinatorDescriptor *descriptor;

/// Called whenever the coordinator is constructed.
- (void)onInit;

/// The UI node  associated to this coordinator has just been added to the view hierarchy.
/// @note: This is similiar to @c viewDidAppear on @c UIViewController.
- (void)onMount;

@end

#pragma mark - Stateless Coordinators

/// Represents a null empty state - used to model @c CRStatelessCoordinator.
NS_SWIFT_NAME(NullState)
@interface CRNullState : CRState
@property(class, nonatomic, readonly) CRNullState *null;
@end

/// No props object.
NS_SWIFT_NAME(NullProps)
@interface CRNullProps : CRProps
@property(class, nonatomic, readonly) CRNullProps *null;
@end

NS_SWIFT_NAME(StatelessCoordinator)
@interface CRStatelessCoordinator<__covariant P : CRProps *> : CRCoordinator <P, CRNullState *>
@end

NS_SWIFT_NAME(ProplessCoordinator)
@interface CRProplessCoordinator<__covariant S : CRState *> : CRCoordinator <CRNullProps *, S>
@end

NS_ASSUME_NONNULL_END
