# iOS import-only module (stable)

Use only files under `FocusBrick/iOS/**` in your Xcode iOS target.
Do NOT import `FocusBrick/watchOS/**` or `FocusBrick/Widgets/**` in the same target.

This avoids duplicate `@main` and platform API conflicts.
