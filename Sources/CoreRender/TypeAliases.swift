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
@objc public protocol AnyProps: class { }
@objc public protocol AnyState: class { }

extension Props: AnyProps { }
extension State: AnyState { }
