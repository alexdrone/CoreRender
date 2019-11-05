import Foundation
import UIKit
import CoreRenderObjC

// MARK: - Common Nodes

public struct UIKit {
  public static func View(
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UIView> {
    Node(UIView.self, builder: builder)
  }

  public static func HStack (
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

  public static func VStack(
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

  public static func Label(
    text: String,
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UILabel> {
    Node(UILabel.self, builder: builder).withLayoutSpec { spec in
      guard let view = spec.view else { return }
      view.text = text
    }
  }
  
  public static func Button(
    key: String,
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UIButton> {
    Node(UIButton.self, builder: builder).withKey(key)
  }
  
  public static func None() -> NullNodeBuilder {
    return NullNodeBuilder()
  }
}


