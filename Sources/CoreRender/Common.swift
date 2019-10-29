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
      yoga.flex()
    }
  }

  public static func VStack(
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UIView> {
    Node(UIView.self, builder: builder).withLayoutSpec { spec in
      guard let yoga = spec.view?.yoga else { return }
      yoga.flexDirection = .column
      yoga.flex()
    }
  }

  public static func Label(
    text: String,
    font: UIFont = UIFont.systemFont(ofSize: 12),
    foregroundColor: UIColor = UIColor.black,
    alignment: NSTextAlignment = .left,
    lineLimit: Int = 0,
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UILabel> {
    Node(UILabel.self, builder: builder).withLayoutSpec { spec in
      guard let view = spec.view else { return }
      view.text = text
      view.font = font
      view.textColor = foregroundColor
      view.textAlignment = alignment
      view.numberOfLines = lineLimit
    }
  }
  
  public static func Button(
    title: String,
    action: @escaping () -> Void,
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UIButton> {
    Node(UIButton.self, builder: builder).withLayoutSpec { spec in
      guard let view = spec.view else { return }
      view.setTitle(title, for: .normal)
      view.onTap { _ in action() }
    }
  }

  public static func Button(
    key: String,
    title: String,
    target: Any? = nil,
    action: Selector = #selector(NSObject.doesNotRecognizeSelector(_:)),
    @_ContentBuilder builder: () -> _Builder = _Builder.default
  ) -> NodeBuilder<UIButton> {
    Node(UIButton.self, builder: builder).withKey(key).withViewInit { _ in
      let button = UIButton()
      button.addTarget(target, action: action, for: .touchUpInside)
      return button
    }.withLayoutSpec { spec in
      guard let view = spec.view else { return }
      view.setTitle(title, for: .normal)
    }
  }
  
  public static func None() -> NullNode {
    return NullNode.nullNode
  }
}


