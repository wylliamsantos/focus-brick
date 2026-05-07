import SwiftUI

enum FBColors {
    static let primary = Color(red: 0.07, green: 0.45, blue: 0.95)
    static let secondary = Color(red: 0.26, green: 0.37, blue: 0.52)
    static let background = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let card = Color.white
    static let success = Color(red: 0.11, green: 0.70, blue: 0.44)
}

enum FBTypography {
    static let title = Font.system(size: 34, weight: .bold, design: .rounded)
    static let timer = Font.system(size: 64, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
}

enum FBSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}
