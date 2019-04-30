import UIKit

public class Label: UILabel {
  /// The typographic style for this label.
  public var style: Typography.Style? = nil {
    didSet { updateView() }
  }

  public convenience init(
    style: Typography.Style,
    text: String? = nil,
    color: UIColor = Theme.palette.text,
    lines: Int = 0
  ) {
    self.init()
    self.style = style
    self.textColor = color
    self.numberOfLines = lines
    self.text = text
    updateView()
  }

  public override var text: String? {
    didSet { updateView() }
  }

  public override var textColor: UIColor! {
    didSet { updateView() }
  }

  private func updateView() {
    if let style = style, let text = text {
      attributedText = Theme.typography.style(style).withColor(textColor).asAttributedString(text)
    }
  }
}
