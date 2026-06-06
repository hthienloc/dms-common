# DMS Developer & AI Agent Guide: System Theme & Colors

To maintain a cohesive look and feel across the Dank Material Shell (DMS) desktop environment, all custom components and plugins **must** adhere strictly to the system's dynamic design tokens. This guide explains how to integrate the dynamic theme and avoid hardcoded colors/dimensions.

---

## 1. Importing the Theme Singleton
All theme values are provided by the `Theme` singleton, which must be imported from the `qs.Common` module:

```qml
import QtQuick
import qs.Common

Item {
    // Access properties like Theme.primary, Theme.surfaceContainer, etc.
}
```

---

## 2. Strict Theme Rules
- **No Hex Colors:** Never use hex strings (e.g., `#FF1744`, `#1A1A1A`) or browser color names (e.g., `"white"`, `"blue"`).
- **No Hardcoded Sizes:** Do not hardcode font sizes, padding/margins, corner radii, or icon sizes. Always map them to the corresponding `Theme` properties.
- **Support Light/Dark Mode:** Dynamic colors adjust automatically. Using hardcoded values will break layouts when switching modes.

---

## 3. Reference Tokens

### A. Semantic & Accent Colors
Use these to color key interactive elements, states, or categorized items:
- `Theme.primary`: Main accent color (respects user selection).
- `Theme.secondary`: Secondary accent color (subtle actions).
- `Theme.error`: For destructive actions, errors, or critical alerts (e.g., PDFs).
- `Theme.warning`: For warnings, pending actions, or archives (e.g., Zip files).
- `Theme.success`: For completed actions, checkmarks, or positive states.

### B. Surface & Text Colors
- `Theme.surface`: Default base surface.
- `Theme.surfaceContainer`: Standard container background (cards, panels).
- `Theme.surfaceContainerHigh`: Slightly lighter/elevated container.
- `Theme.surfaceText` (or `Theme.onSurface`): Color for primary text.
- `Theme.surfaceVariantText` (or `Theme.onSurfaceVariant`): Color for secondary/muted text or labels.
- `Theme.outline`: Standard boundary, border, or divider color.

### C. Spacing, Font Sizes, and Radii
- **Margins & Padding:** `Theme.spacingXS`, `Theme.spacingS`, `Theme.spacingM`, `Theme.spacingL`, `Theme.spacingXL`
- **Font Sizes:** `Theme.fontSizeSmall`, `Theme.fontSizeMedium`, `Theme.fontSizeLarge`, `Theme.fontSizeXLarge`
- **Corner Radii:** `Theme.cornerRadiusSmall`, `Theme.cornerRadius`, `Theme.cornerRadiusLarge`
- **Icon Sizes:** `Theme.iconSizeSmall` (16px), `Theme.iconSize` (24px), `Theme.iconSizeLarge` (32px)

---

## 4. Best Practices & Common Patterns

### A. Implementing Transparency & Alpha Blends
Never hardcode transparent hex values (like `#12ThemePrimary`). Use `Theme.withAlpha()` to create semi-transparent color variants dynamically:

```qml
Rectangle {
    anchors.fill: parent
    // Use 8% opacity of the system accent color for grouped backgrounds
    color: Theme.withAlpha(Theme.primary, 0.08)
    // Use 25% opacity for boundaries
    border.color: Theme.withAlpha(Theme.primary, 0.25)
    border.width: 1
    radius: Theme.cornerRadius
}
```

### B. Interactive/Hover States
Use `Theme.withAlpha` or `Qt.lighter` for hover backgrounds to ensure compatibility with light/dark modes:

```qml
Rectangle {
    id: button
    color: mouseArea.containsMouse 
        ? Theme.withAlpha(Theme.primary, 0.2) 
        : "transparent"
    radius: Theme.cornerRadiusSmall

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
```

### C. Standard Card Container
Use a nested structure of surface container and outline colors:

```qml
Rectangle {
    color: Theme.surfaceContainer
    border.color: Theme.withAlpha(Theme.outline, 0.15)
    border.width: 1
    radius: Theme.cornerRadius
}
```
