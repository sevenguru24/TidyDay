# TidyDay

A beautiful, modern to-do list app for iOS built with SwiftUI, featuring Apple's design language and optional Liquid Glass effects.

## Features

- ✅ **Clean Task Management** - Create, edit, complete, and delete tasks with smooth animations
- 📅 **Due Dates & Times** - Optional date and time picker for each task
- 🎨 **Apple-like Design** - Inspired by iOS Reminders app with refined aesthetics
- 🔮 **Liquid Glass Effects** - Toggle enhanced translucent materials (iOS 18.2+ ready)
- 📱 **Intuitive Navigation** - Floating tab bar with smooth transitions
- 💫 **Rich Animations** - Spring animations, haptic feedback, and pop effects
- 🃏 **Card-based UI** - Individual task cards with glass-morphism
- ↔️ **Swipe Actions** - Delete, edit, and view info with natural gestures
- 🏠 **Dashboard** - Home screen with stats, recent tasks, and insights
- ⚙️ **Settings** - Appearance options and app configuration

## Screenshots

*Coming soon*

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/TidyDay.git
cd TidyDay
```

2. Open `TidyDay.xcodeproj` in Xcode

3. Build and run on your device or simulator

## Architecture

- **SwiftUI** - Modern declarative UI framework
- **Observable** - Data flow with @Observable macro
- **UserDefaults** - Persistent storage for tasks and settings
- **Codable** - JSON encoding/decoding for data persistence

## Key Components

### Views
- `MainTabView` - Tab navigation container
- `HomeView` - Dashboard with stats and recent tasks
- `TasksListView` - Task list with create/edit functionality
- `SettingsView` - App settings and preferences
- `FloatingTabBar` - Custom tab bar with liquid glass effect

### Models
- `TodoItem` - Task data model with title, completion, dates
- `AppSettings` - App preferences (liquid glass toggle, etc.)
- `LiquidGlassStyle` - Custom material effect implementation

### Features
- **Date/Time Picker** - Appears when creating tasks, optional selection
- **Swipe Actions** - Left swipe: Delete | Right swipe: Info, Edit
- **Context Menu** - Long-press for additional options
- **Haptic Feedback** - Tactile responses for interactions
- **Empty States** - Friendly messages when no tasks exist

## Design System

### Colors
- Primary actions: System Blue
- Destructive actions: System Red
- Info actions: System Blue
- Edit actions: System Orange

### Materials
- **Standard Mode**: `.regularMaterial` and `.ultraThinMaterial`
- **Liquid Glass Mode**: Custom translucent effect with enhanced depth

### Typography
- SF Pro Rounded for titles and numbers
- System font for body text
- Dynamic type support

### Spacing
- Consistent 12-16px padding
- 16px card corners
- 12px spacing between cards

## Liquid Glass

The app includes a custom Liquid Glass implementation that mimics Apple's upcoming iOS 18.2 feature:
- Toggle in Settings → Appearance
- Enhanced translucency and depth
- Applied to tab bar, task cards, and panels
- Future-proof for native `.liquidGlass` API

## Roadmap

- [ ] iCloud sync
- [ ] Categories/lists
- [ ] Priority levels
- [ ] Subtasks
- [ ] Widgets
- [ ] Search functionality
- [ ] Dark mode refinements
- [ ] iPad support
- [ ] macOS version

## License

MIT License - Feel free to use this project for learning or as a template for your own apps.

## Acknowledgments

- Design inspiration from iOS Reminders app
- Liquid Glass concept from Apple's iOS 18.2 preview
- Built with ❤️ using SwiftUI

---

**Made with SwiftUI** | **Designed for iOS**
