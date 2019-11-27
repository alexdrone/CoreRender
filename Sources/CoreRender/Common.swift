import Foundation
import UIKit
import CoreRenderObjC

// MARK: - Common Nodes

public func ViewNode(
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UIView> {
  Node(UIView.self, builder: builder)
}

public func HStackNode (
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

public func VStackNode(
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

public func LabelNode(
  text: String,
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UILabel> {
  Node(UILabel.self, builder: builder).withLayoutSpec { spec in
    guard let view = spec.view else { return }
    view.text = text
  }
}

public func ButtonNode(
  key: String,
  @_ContentBuilder builder: () -> _Builder = _Builder.default
) -> NodeBuilder<UIButton> {
  Node(UIButton.self, builder: builder).withKey(key)
}

public func SpacerNode() -> NullNodeBuilder {
  return NullNodeBuilder()
}



