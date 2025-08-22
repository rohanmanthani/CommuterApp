# CommuterApp

A comprehensive iOS commute tracking application that provides real-time trip analytics, driving behavior monitoring, and environmental awareness through advanced sensor integration.

## Features

### 🚗 Trip Tracking
- **GPS-based route tracking** with real-time speed and distance monitoring
- **Automatic trip categorization** (Home to Work, Work to Home, Custom destinations)
- **Background location updates** for uninterrupted tracking during phone calls
- **Manual trip entry** when GPS is unavailable

### 📊 Driving Analytics
- **Motion sensor integration** using Core Motion framework
- **Real-time driving behavior analysis**:
  - Hard braking and acceleration detection
  - Distracted driving patterns
  - Rough road condition monitoring
  - Speed violation tracking
- **Weekly insights and patterns** with trend analysis

### 🔊 Environmental Awareness
- **SoundML integration** using Apple's SoundAnalysis framework
- **Real-time audio event detection**:
  - Car horn detection during trips
  - Emergency siren identification
- **Audio events mapped to GPS coordinates** for safety analysis

### 📱 Smart Features
- **Resilient architecture** - trips continue even when individual sensors fail
- **Audio session management** with phone call interruption handling
- **iCloud backup integration** for trip data persistence
- **Customizable user settings** for sensor preferences
- **Export functionality** (CSV and JSON) including all sensor data

## Technical Architecture

### Frameworks Used
- **SwiftUI** - Modern declarative UI framework
- **Core Location** - GPS tracking and location services
- **Core Motion** - Accelerometer, gyroscope, and motion analysis
- **SoundAnalysis** - Real-time audio classification
- **AVFoundation** - Audio session and microphone management
- **MapKit** - Route visualization and mapping

### Key Components

#### SensorManager
Handles all motion sensor data processing with graceful failure handling:
```swift
class SensorManager: ObservableObject {
    private let motionManager = CMMotionManager()
    // Robust sensor initialization with availability checks
}
```

#### SoundAnalysisManager
Manages real-time audio analysis with interruption handling:
```swift
class SoundAnalysisManager: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    // Phone call interruption management
}
```

#### LocationManager
Provides resilient GPS tracking with permission management:
```swift
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Background location updates and graceful degradation
}
```

## Installation

### Requirements
- iOS 15.0+
- Xcode 14.0+
- Device with GPS, accelerometer, and microphone (for full functionality)

### Setup
1. Clone the repository:
```bash
git clone https://github.com/rohanmanthani/CommuterApp.git
```

2. Open `CommuterApp.xcodeproj` in Xcode

3. Configure signing and capabilities:
   - Set your development team
   - Ensure the following capabilities are enabled:
     - Location (Always and When In Use)
     - Background Modes (Location updates, Background processing)
     - Microphone access

4. Build and run on a physical device (recommended for full sensor functionality)

## Permissions Required

The app requests the following permissions for optimal functionality:

- **Location (Always)** - For continuous GPS tracking during trips
- **Microphone** - For car horn and siren detection
- **Motion & Fitness** - For driving behavior analysis

**Note:** The app is designed to function gracefully even when permissions are denied, with reduced functionality.

## Usage

### Starting a Trip
1. Select trip type (Home to Work, Work to Home, or Custom)
2. Tap "Start Tracking"
3. The app will begin monitoring:
   - GPS location and route
   - Driving behavior (if motion sensors available)
   - Audio events (if microphone access granted)

### Viewing Analytics
- **Real-time metrics** displayed during active trips
- **Trip history** with detailed analytics
- **Weekly insights** showing patterns and trends
- **Export options** for data analysis

### Settings
- **GPS Tracking** - Enable/disable location services
- **Motion Sensors** - Control driving behavior analysis
- **Microphone** - Toggle audio event detection
- **Screen On** - Keep display active during trips
- **iCloud Backup** - Sync trip data across devices

## Data Export

The app supports comprehensive data export in multiple formats:

### CSV Export
- Trip summaries with all metrics
- Detailed event logs with timestamps and GPS coordinates
- Audio events (car horns, sirens) with location data

### JSON Export
- Complete trip data including raw sensor readings
- Structured format for data analysis and visualization

## Architecture Highlights

### Resilient Design
The app is built with resilience as a core principle:
- **Graceful sensor failure handling** - trips continue even when GPS, motion sensors, or microphone fail
- **Detailed error logging** for debugging and status monitoring
- **Fallback modes** for each sensor type

### Performance Optimizations
- **Efficient battery usage** with optimized sensor update intervals
- **Memory management** with bounded data structures
- **Background processing** for uninterrupted tracking

### Privacy & Security
- **Local data storage** with optional iCloud sync
- **Clear permission requests** with usage descriptions
- **No third-party analytics** or data sharing

## Contributing

Contributions are welcome!

### Development Guidelines
- Follow existing code patterns and architecture
- Maintain graceful error handling for all sensor operations
- Add appropriate logging for debugging
- Test on physical devices for sensor functionality

## License

[Add your preferred license here]

## Acknowledgments

- Uses Apple's SoundAnalysis framework for audio classification
- Incorporates iOS best practices for location and motion sensing

---

**Note:** This app is designed for personal use and trip analysis. Always follow local laws and regulations regarding device usage while driving.