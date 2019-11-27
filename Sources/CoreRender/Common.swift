import Foundation
import UIKit
import CoreRenderObjC

// MARK: - Common Nodes

public func UIViewNode(
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UIView> {
  Node(UIView.self, builder: builder)
}

public func UIViewHStackNode (
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UIView> {
  Node(UIView.self, builder: builder).withLayoutSpec { spec in
    guard let yoga = spec.view?.yoga else { return }
    yoga.flexDirection = .row
    yoga.justifyContent = .flexStart
    yoga.alignItems = .flexStart
    yoga.flex()
  }
}

public func UIViewVStackNode(
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UIView> {
  Node(UIView.self, builder: builder).withLayoutSpec { spec in
    guard let yoga = spec.view?.yoga else { return }
    yoga.flexDirection = .column
    yoga.justifyContent = .flexStart
    yoga.alignItems = .flexStart
    yoga.flex()
  }
}

public func UILabelNode(
  text: String,
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UILabel> {
  Node(UILabel.self, builder: builder).withLayoutSpec { spec in
    guard let view = spec.view else { return }
    view.text = text
  }
}

public func UIButtonNode(
  key: String,
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UIButton> {
  Node(UIButton.self, builder: builder).withKey(key)
}

public func NullNode() -> NullNodeBuilder {
  return NullNodeBuilder()
}



