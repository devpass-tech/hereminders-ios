// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Home {
    /// Settings
    internal static let settings = L10n.tr("Localizable", "Home.Settings")
    /// Hereminders
    internal static let title = L10n.tr("Localizable", "Home.Title")
  }

  internal enum Notification {
    /// Done
    internal static let done = L10n.tr("Localizable", "Notification.Done")
    /// Hereminder for you!
    internal static let hereminderForYou = L10n.tr("Localizable", "Notification.HereminderForYou")
  }

  internal enum PlaceDetails {
    /// Address
    internal static let address = L10n.tr("Localizable", "PlaceDetails.Address")
    /// Name
    internal static let name = L10n.tr("Localizable", "PlaceDetails.Name")
    /// Type the place name
    internal static let namePlaceholder = L10n.tr("Localizable", "PlaceDetails.NamePlaceholder")
    /// Radius
    internal static let radius = L10n.tr("Localizable", "PlaceDetails.Radius")
    /// Place Details
    internal static let title = L10n.tr("Localizable", "PlaceDetails.Title")
  }

  internal enum PlaceList {
    /// Place List
    internal static let title = L10n.tr("Localizable", "PlaceList.Title")
  }

  internal enum PlaceSearch {
    /// Type an address or place name
    internal static let namePlaceholder = L10n.tr("Localizable", "PlaceSearch.NamePlaceholder")
    /// Place Search
    internal static let title = L10n.tr("Localizable", "PlaceSearch.Title")
  }

  internal enum Reminder {
    /// Add new Hereminder
    internal static let addNewReminder = L10n.tr("Localizable", "Reminder.AddNewReminder")
    /// Description
    internal static let description = L10n.tr("Localizable", "Reminder.Description")
    /// Type the Hereminder description
    internal static let descriptionPlaceholder = L10n.tr("Localizable", "Reminder.DescriptionPlaceholder")
    /// No description
    internal static let noDescription = L10n.tr("Localizable", "Reminder.NoDescription")
    /// On entry
    internal static let onEntry = L10n.tr("Localizable", "Reminder.OnEntry")
    /// On exit
    internal static let onExit = L10n.tr("Localizable", "Reminder.OnExit")
    /// New Hereminder
    internal static let title = L10n.tr("Localizable", "Reminder.Title")
    /// When
    internal static let when = L10n.tr("Localizable", "Reminder.When")
  }

  internal enum ReminderList {
    /// Add new place
    internal static let addNewPlace = L10n.tr("Localizable", "ReminderList.AddNewPlace")
    /// Add Hereminder
    internal static let addReminder = L10n.tr("Localizable", "ReminderList.AddReminder")
    /// Done
    internal static let done = L10n.tr("Localizable", "ReminderList.Done")
    /// No Hereminders here!
    internal static let noHereminders = L10n.tr("Localizable", "ReminderList.NoHereminders")
    /// On entry
    internal static let onEntry = L10n.tr("Localizable", "ReminderList.OnEntry")
    /// On exit
    internal static let onExit = L10n.tr("Localizable", "ReminderList.OnExit")
    /// Select or add a new place
    internal static let selectOrAddPlace = L10n.tr("Localizable", "ReminderList.SelectOrAddPlace")
    /// Welcome to Hereminders!
    internal static let welcome = L10n.tr("Localizable", "ReminderList.Welcome")
  }

  internal enum Settings {
    /// About
    internal static let about = L10n.tr("Localizable", "Settings.About")
    /// Become Premium 🤩
    internal static let becomePremium = L10n.tr("Localizable", "Settings.BecomePremium")
    /// Contributors
    internal static let contributors = L10n.tr("Localizable", "Settings.Contributors")
    /// Credits
    internal static let credits = L10n.tr("Localizable", "Settings.Credits")
    /// Icons made by Smashicons (www.flaticon.com)
    internal static let logoCredit = L10n.tr("Localizable", "Settings.LogoCredit")
    /// Manage places
    internal static let managePlaces = L10n.tr("Localizable", "Settings.ManagePlaces")
    /// Places
    internal static let places = L10n.tr("Localizable", "Settings.Places")
    /// Premium
    internal static let premium = L10n.tr("Localizable", "Settings.Premium")
    /// Settings
    internal static let title = L10n.tr("Localizable", "Settings.Title")
    /// Version %@ (%@)
    internal static func version(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Settings.Version", String(describing: p1), String(describing: p2))
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
