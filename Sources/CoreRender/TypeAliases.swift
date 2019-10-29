import Foundation
import UIKit
import CoreRenderObjC

// MARK: - Alias types

// Drops the YG prefix.
public typealias FlexDirection = YGFlexDirection
public typealias Align = YGAlign
public typealias Edge = YGEdge
public typealias Wrap = YGWrap
public typealias Display = YGDisplay
public typealias Overflow = YGOverflow

public typealias LayoutOptions = CRNodeLayoutOptions

// Ensure that Yoga's C-enums are accessibly through KeyPathRefs.
public protocol WritableKeyPathBoxableEnum {
  var rawValue: Int32 { get }
}

extension YGFlexDirection: WritableKeyPathBoxableEnum { }
extension YGAlign: WritableKeyPathBoxableEnum { }
extension YGEdge: WritableKeyPathBoxableEnum { }
extension YGWrap: WritableKeyPathBoxableEnum { }
extension YGDisplay: WritableKeyPathBoxableEnum { }
extension YGOverflow: WritableKeyPathBoxableEnum { }

// MARK: - Type Erasure

// Convenience type-erased protocols.
@objc public protocol AnyController: class { }
@objc public protocol AnyProps: class { }
@objc public protocol AnyState: class { }

/// Swift-only compliance protocol.
public protocol ControllerProtocol: AnyController {
  /// The type of the props that will be passed down to this controller.
  associatedtype PropsType: AnyProps
  /// The type of its internal state
  associatedtype StateType: AnyState
}

extension Controller: AnyController { }
extension Props: AnyProps { }
extension State: AnyState { }
