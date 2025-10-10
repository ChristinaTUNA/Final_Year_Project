# CooKit - Smart Grocery Assistant

A Flutter app featuring a splash screen with Chef Mato character, converted from Figma design.

## Features

- **Splash Screen**: Animated splash screen with Chef Mato character
- **Custom Character**: Hand-drawn Chef Mato with chef hat, spoon, and friendly face
- **Status Bar**: iOS-style status bar with time, battery, WiFi, and cellular indicators
- **Smooth Animations**: Fade and scale animations for the character and text
- **Responsive Design**: Optimized for mobile devices

## Design Details

The app is based on a Figma design featuring:

- **Chef Mato Character**: A red circular character with white chef hat, green accents, and a spoon
- **COOKIT Branding**: Large red text with custom typography
- **Status Indicators**: Battery, WiFi, and cellular signal indicators
- **Home Indicator**: iOS-style home indicator at the bottom

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- iOS Simulator or Android Emulator (for testing)

### Installation

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd CooKit_app
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                 # Main app entry point
├── splash_screen.dart       # Splash screen with animations
└── chef_mato_painter.dart   # Custom painter for Chef Mato character
```

## Customization

### Colors

- **Primary Red**: `#E02200` (Chef Mato body and text)
- **Green Accents**: `#008F0E` and `#005C09` (Chef hat decorations)
- **White**: `#FFFFFF` (Chef hat and spoon)
- **Dark Text**: `#181725` (Status bar text)

### Animations

- **Fade Animation**: 0-60% of animation duration
- **Scale Animation**: 20-80% of animation duration with elastic curve
- **Total Duration**: 2000ms

### Character Details

The Chef Mato character includes:

- Red circular body
- White chef hat with green and red decorations
- Friendly face with red eyes and smile
- White spoon in hand
- Various body details and accents

## Dependencies

- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons

## Development

The app uses custom painting for the Chef Mato character to match the Figma design exactly. The character is drawn using Flutter's `CustomPainter` class with precise positioning and colors.

## License

This project is for educational purposes. Please ensure you have the proper rights to use the Figma design and any associated assets.
