# Focus Brick — Target Membership Map

## Targets
- `FocusBrick` (iOS app)
- `FocusBrickWidgetExtension` (Widget)
- `FocusBrickWatchApp` (watchOS app)

## Folder-to-target rule
- `FocusBrick/iOS/**` -> `FocusBrick`
- `FocusBrick/WidgetExtension/**` -> `FocusBrickWidgetExtension`
- `FocusBrick/WatchApp/**` -> `FocusBrickWatchApp`
- `FocusBrick/Shared/**` -> shared across targets as needed

## Entrypoints (`@main`) — one per module only
- iOS: `FocusBrick/iOS/App/FocusBrickApp.swift` -> `FocusBrick`
- Widget: `FocusBrick/WidgetExtension/FocusBrickWidgets.swift` -> `FocusBrickWidgetExtension`
- Watch: `FocusBrick/WatchApp/FocusBrickWatchApp.swift` -> `FocusBrickWatchApp`

## Critical checks before build
1. In each target, open **Build Phases > Compile Sources**
2. Ensure no duplicate files with same type name are included in same target
3. Ensure each `@main` file belongs only to its module target

## Suggested naming convention
- `FocusBrickiOSApp.swift`
- `FocusBrickWidgetBundle.swift`
- `FocusBrickWatchApp.swift`

## Migration note
Current repository keeps legacy paths for compatibility. Prefer importing from modular folders above when configuring/rebuilding Xcode project.
