import UIKit

public enum HapticFeedbackStyle: Int {
  case light
  case medium
  case heavy
}

public enum HapticFeedbackType: Int {
  case success
  case warning
  case error
}

public enum Haptic {
  case impact(HapticFeedbackStyle)
  case notification(HapticFeedbackType)
  case selection

  // Generate a haptic feedback.
  public func generate() {
    guard #available(iOS 10, *) else { return }
    switch self {
    case .impact(let style):
      let generator = UIImpactFeedbackGenerator(style: style.value)
      generator.prepare()
      generator.impactOccurred()
    case .notification(let type):
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(type.value)
    case .selection:
      let generator = UISelectionFeedbackGenerator()
      generator.prepare()
      generator.selectionChanged()
    }
  }
}

@available(iOS 10.0, *)
extension HapticFeedbackStyle {
  var value: UIImpactFeedbackGenerator.FeedbackStyle {
    return UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
  }
}

@available(iOS 10.0, *)
extension HapticFeedbackType {
  var value: UINotificationFeedbackGenerator.FeedbackType {
    return UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
  }
}
