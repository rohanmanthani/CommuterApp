import SwiftUI
import CoreLocation
import CoreMotion
import UIKit
import MapKit
import Charts

// MARK: - Design System
struct DesignSystem {
    // Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color(.systemBlue)
        static let accent = Color.green
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let background = Color(.systemGroupedBackground)
        static let cardBackground = Color(.secondarySystemGroupedBackground)
        static let text = Color.primary
        static let secondaryText = Color.secondary
        static let borderColor = Color(.systemGray4)
        
        // Driving score colors
        static let excellent = Color.green
        static let good = Color.blue
        static let fair = Color.orange
        static let poor = Color.red
        
        // Speed category colors
        static let speedStopped = Color.red
        static let speedCrawling = Color.orange
        static let speedSlow = Color.yellow
        static let speedNormal = Color.green
        static let speedFast = Color.blue
        static let speedVeryFast = Color.purple
    }
    
    // Typography
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.medium)
        static let headline = Font.headline.weight(.medium)
        static let subheadline = Font.subheadline.weight(.regular)
        static let body = Font.body
        static let callout = Font.callout
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
    
    // Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }
    
    // Shadows
    struct Shadow {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.15)
        static let heavy = Color.black.opacity(0.25)
    }
    
    // Glass morphism materials
    struct Materials {
        static let ultraThin = Material.ultraThin
        static let thin = Material.thin
        static let regular = Material.regular
        static let thick = Material.thick
        static let ultraThick = Material.ultraThick
    }
    
    // Enhanced glass effects
    struct Glass {
        static func background(material: Material = .regular) -> some View {
            Rectangle()
                .fill(material)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                )
        }
        
        static func card(material: Material = .thin) -> some View {
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .fill(material)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.lg)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Shadow.medium, radius: 10, x: 0, y: 4)
        }
        
        static func button(material: Material = .regular, isPressed: Bool = false) -> some View {
            RoundedRectangle(cornerRadius: CornerRadius.md)
                .fill(material)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .fill(Color.white.opacity(isPressed ? 0.2 : 0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.md)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .shadow(color: Shadow.light, radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 2 : 4)
        }
    }
}

// Legacy CardView for sections that prefer the original design
struct LegacyCardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(DesignSystem.Spacing.md)
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(color: DesignSystem.Shadow.light, radius: 2, x: 0, y: 1)
    }
}

// MARK: - Reusable UI Components
struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
            Text(message)
                .font(DesignSystem.Typography.subheadline)
                .foregroundColor(DesignSystem.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.background)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(DesignSystem.Colors.secondaryText)
            
            VStack(spacing: DesignSystem.Spacing.sm) {
                Text(title)
                    .font(DesignSystem.Typography.title3)
                    .foregroundColor(DesignSystem.Colors.text)
                
                Text(message)
                    .font(DesignSystem.Typography.body)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.lg)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle) {
                    action()
                }
                .font(DesignSystem.Typography.headline)
                .foregroundColor(.white)
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.vertical, DesignSystem.Spacing.md)
                .background(DesignSystem.Colors.primary)
                .cornerRadius(DesignSystem.CornerRadius.md)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.Colors.background)
    }
}

struct CardView<Content: View>: View {
    let content: Content
    var material: Material
    var intensity: Double
    
    init(material: Material = .thin, intensity: Double = 1.0, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.material = material
        self.intensity = intensity
    }
    
    var body: some View {
        content
            .padding(DesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                    .fill(material)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .fill(Color.white.opacity(0.1 * intensity))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                            .stroke(Color.white.opacity(0.2 * intensity), lineWidth: 1)
                    )
            )
            .shadow(color: DesignSystem.Shadow.medium, radius: 12, x: 0, y: 6)
            .shadow(color: DesignSystem.Shadow.light, radius: 4, x: 0, y: 2)
    }
}

struct AnimatedButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    var material: Material
    @State private var isPressed = false
    
    init(material: Material = .regular, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
        self.material = material
    }
    
    var body: some View {
        Button(action: action) {
            content
                .padding(DesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                        .fill(material)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .fill(Color.white.opacity(isPressed ? 0.25 : 0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .shadow(color: DesignSystem.Shadow.light, radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 2 : 4)
                .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct SettingToggle: View {
    let title: String
    let description: String
    let icon: String?
    @Binding var isOn: Bool
    let action: (Bool) -> Void
    
    init(title: String, description: String, icon: String? = nil, isOn: Binding<Bool>, action: @escaping (Bool) -> Void) {
        self.title = title
        self.description = description
        self.icon = icon
        self._isOn = isOn
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                Text(title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(DesignSystem.Colors.text)
                
                Text(description)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .scaleEffect(0.9)
                .onChange(of: isOn) { _, newValue in
                    action(newValue)
                }
        }
        .padding(DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                .fill(DesignSystem.Colors.background.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                        .stroke(DesignSystem.Colors.borderColor, lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Settings Manager
class SettingsManager: ObservableObject {
    @Published var speedLimitThreshold: Double = 80.0 // km/h
    @Published var keepScreenOn: Bool = true // Keep screen on during trips
    @Published var useLocationBasedOrdering: Bool = true // Order trips by location relevance
    
    // Sensor preferences for new trips
    @Published var enableGPS: Bool = true // Enable GPS tracking
    @Published var enableMotionSensors: Bool = true // Enable accelerometer/gyroscope
    @Published var enableMicrophone: Bool = true // Enable sound analysis for horns/sirens
    
    private let userDefaults = UserDefaults.standard
    private let speedLimitKey = "SpeedLimitThreshold"
    private let keepScreenOnKey = "KeepScreenOn"
    private let locationOrderingKey = "UseLocationBasedOrdering"
    private let enableGPSKey = "EnableGPS"
    private let enableMotionSensorsKey = "EnableMotionSensors"
    private let enableMicrophoneKey = "EnableMicrophone"
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        let savedSpeedLimit = userDefaults.double(forKey: speedLimitKey)
        if savedSpeedLimit > 0 {
            speedLimitThreshold = savedSpeedLimit
        }
        
        keepScreenOn = userDefaults.object(forKey: keepScreenOnKey) as? Bool ?? true
        useLocationBasedOrdering = userDefaults.object(forKey: locationOrderingKey) as? Bool ?? true
        
        // Load sensor preferences (default to enabled)
        enableGPS = userDefaults.object(forKey: enableGPSKey) as? Bool ?? true
        enableMotionSensors = userDefaults.object(forKey: enableMotionSensorsKey) as? Bool ?? true
        enableMicrophone = userDefaults.object(forKey: enableMicrophoneKey) as? Bool ?? true
        
    }
    
    func saveSpeedLimit(_ limit: Double) {
        speedLimitThreshold = limit
        userDefaults.set(limit, forKey: speedLimitKey)
        userDefaults.synchronize()  // Enable iCloud sync
    }
    
    func saveKeepScreenOn(_ enabled: Bool) {
        keepScreenOn = enabled
        userDefaults.set(enabled, forKey: keepScreenOnKey)
        userDefaults.synchronize()  // Enable iCloud sync
    }
    
    func saveLocationOrdering(_ useLocationOrdering: Bool) {
        useLocationBasedOrdering = useLocationOrdering
        userDefaults.set(useLocationOrdering, forKey: locationOrderingKey)
        userDefaults.synchronize()  // Enable iCloud sync
    }
    
    func saveGPSSetting(_ enabled: Bool) {
        enableGPS = enabled
        userDefaults.set(enabled, forKey: enableGPSKey)
        userDefaults.synchronize()
    }
    
    func saveMotionSensorsSetting(_ enabled: Bool) {
        enableMotionSensors = enabled
        userDefaults.set(enabled, forKey: enableMotionSensorsKey)
        userDefaults.synchronize()
    }
    
    func saveMicrophoneSetting(_ enabled: Bool) {
        enableMicrophone = enabled
        userDefaults.set(enabled, forKey: enableMicrophoneKey)
        userDefaults.synchronize()
    }
}

// MARK: - Data Models
struct DrivingMetrics: Codable {
    // Store counts instead of full arrays for memory efficiency
    var brakingEventCount: Int = 0
    var hardBrakingEventCount: Int = 0 // intensity > 0.8
    var maxSpeed: Double = 0.0
    var averageSpeed: Double = 0.0
    var roughRoadEvents: Int = 0
    var sharpTurns: Int = 0
    var speedViolations: Int = 0
    var totalDistance: Double = 0.0
    var slowTrafficTime: TimeInterval = 0.0 // Time spent under 15 km/h
    var accelerationEvents: Int = 0 // Number of significant acceleration events
    var phoneDistractions: Int = 0 // Phone interaction events (touches + orientation changes)
    var hornEvents: Int = 0 // Number of horn detections
    var sirenEvents: Int = 0 // Number of siren detections
    
    // Custom CodingKeys for backward compatibility
    private enum CodingKeys: String, CodingKey {
        case brakingEventCount, hardBrakingEventCount, maxSpeed, averageSpeed
        case roughRoadEvents, sharpTurns, speedViolations, totalDistance, slowTrafficTime
        case accelerationEvents, phoneDistractions, hornEvents, sirenEvents
        case carHornEvents = "carHornEvents" // Legacy key for backward compatibility
    }
    
    // Custom decoder for backward compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required legacy fields
        brakingEventCount = try container.decodeIfPresent(Int.self, forKey: .brakingEventCount) ?? 0
        hardBrakingEventCount = try container.decodeIfPresent(Int.self, forKey: .hardBrakingEventCount) ?? 0
        maxSpeed = try container.decodeIfPresent(Double.self, forKey: .maxSpeed) ?? 0.0
        averageSpeed = try container.decodeIfPresent(Double.self, forKey: .averageSpeed) ?? 0.0
        roughRoadEvents = try container.decodeIfPresent(Int.self, forKey: .roughRoadEvents) ?? 0
        sharpTurns = try container.decodeIfPresent(Int.self, forKey: .sharpTurns) ?? 0
        speedViolations = try container.decodeIfPresent(Int.self, forKey: .speedViolations) ?? 0
        totalDistance = try container.decodeIfPresent(Double.self, forKey: .totalDistance) ?? 0.0
        slowTrafficTime = try container.decodeIfPresent(TimeInterval.self, forKey: .slowTrafficTime) ?? 0.0
        
        // Optional newer fields (may not exist in older formats)
        accelerationEvents = try container.decodeIfPresent(Int.self, forKey: .accelerationEvents) ?? 0
        phoneDistractions = try container.decodeIfPresent(Int.self, forKey: .phoneDistractions) ?? 0
        
        // Handle backward compatibility for hornEvents (was carHornEvents)
        if let newHornEvents = try container.decodeIfPresent(Int.self, forKey: .hornEvents) {
            hornEvents = newHornEvents
        } else if let oldCarHornEvents = try container.decodeIfPresent(Int.self, forKey: .carHornEvents) {
            hornEvents = oldCarHornEvents
        } else {
            hornEvents = 0
        }
        
        sirenEvents = try container.decodeIfPresent(Int.self, forKey: .sirenEvents) ?? 0
    }
    
    // Custom encoder to use new field names
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(brakingEventCount, forKey: .brakingEventCount)
        try container.encode(hardBrakingEventCount, forKey: .hardBrakingEventCount)
        try container.encode(maxSpeed, forKey: .maxSpeed)
        try container.encode(averageSpeed, forKey: .averageSpeed)
        try container.encode(roughRoadEvents, forKey: .roughRoadEvents)
        try container.encode(sharpTurns, forKey: .sharpTurns)
        try container.encode(speedViolations, forKey: .speedViolations)
        try container.encode(totalDistance, forKey: .totalDistance)
        try container.encode(slowTrafficTime, forKey: .slowTrafficTime)
        try container.encode(accelerationEvents, forKey: .accelerationEvents)
        try container.encode(phoneDistractions, forKey: .phoneDistractions)
        try container.encode(hornEvents, forKey: .hornEvents) // Always use new key for encoding
        try container.encode(sirenEvents, forKey: .sirenEvents)
    }
    
    // Default initializer
    init() {
        // All properties already have default values
    }
    
    var drivingScore: Int {
        let baseScore = 100
        let brakingPenalty = min(brakingEventCount * 2, 20)
        let hardBrakingPenalty = min(hardBrakingEventCount * 3, 10)
        let roughRoadPenalty = min(Int(Double(roughRoadEvents) * 0.5), 5)
        let sharpTurnPenalty = min(sharpTurns * 3, 15)
        let speedViolationPenalty = min(speedViolations * 4, 25)
        let accelerationPenalty = min(accelerationEvents * 2, 15) // 2 points per acceleration event, max 15
        let distractionPenalty = min(phoneDistractions * 3, 20) // 3 points per distraction, max 20
        let hornPenalty = min(hornEvents * 1, 10) // 1 point per horn event, max 10
        let slowTrafficPenalty = min(Int(slowTrafficTime / 180.0) * 2, 10) // 2 points per 3-minute block in slow traffic, max 10
        
        return max(baseScore - brakingPenalty - hardBrakingPenalty - roughRoadPenalty - sharpTurnPenalty - speedViolationPenalty - accelerationPenalty - distractionPenalty - hornPenalty - slowTrafficPenalty, 0)
    }
    
    var qualityDescription: String {
        switch drivingScore {
        case 90...100: return "Excellent"
        case 80...89: return "Good"
        case 70...79: return "Fair" 
        case 60...69: return "Poor"
        default: return "Needs Improvement"
        }
    }
}

struct BrakingEvent {
    let timestamp: Date
    let intensity: Double
    let location: CLLocation?
}

struct AccelerationEvent {
    let timestamp: Date
    let intensity: Double
    let type: AccelerationType
}

enum AccelerationType {
    case acceleration
    case deceleration
    case roughRoad
    case sharpTurn
}

struct LocationPoint: Codable {
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    let speed: Double // km/h
    let accuracy: Double // meters
}

struct HeavyTrafficPeriod: Codable {
    let startTime: Date
    let endTime: Date
    let startIndex: Int // Index in pathPoints array
    let endIndex: Int
    let averageSpeed: Double // km/h during this period
    let duration: TimeInterval // seconds
    
    var durationMinutes: Double {
        return duration / 60.0
    }
    
    var formattedDuration: String {
        let minutes = Int(duration / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

struct DrivingEvent: Codable, Identifiable {
    let id: UUID
    let type: EventType
    let location: LocationPoint
    let intensity: Double // 0.0 to 1.0 representing event severity
    let timestamp: Date
    
    init(type: EventType, location: LocationPoint, intensity: Double, timestamp: Date) {
        self.id = UUID()
        self.type = type
        self.location = location
        self.intensity = intensity
        self.timestamp = timestamp
    }
    
    // Convenience initializer for CLLocation
    init(type: EventType, location: CLLocation, intensity: Double, timestamp: Date) {
        self.id = UUID()
        self.type = type
        self.location = LocationPoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: timestamp,
            speed: max(0, location.speed * 3.6), // Convert m/s to km/h
            accuracy: location.horizontalAccuracy
        )
        self.intensity = intensity
        self.timestamp = timestamp
    }
    
    enum EventType: String, Codable, CaseIterable {
        case braking = "braking"
        case hardBraking = "hardBraking"
        case acceleration = "acceleration"
        case sharpTurn = "sharpTurn"
        case roughRoad = "roughRoad"
        case phoneDistraction = "phoneDistraction"
        case horn = "horn"
        case siren = "siren"
        
        // Custom decoder for backward compatibility
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            
            // Handle backward compatibility
            switch stringValue {
            case "carHorn":
                self = .horn
            default:
                if let standardCase = EventType(rawValue: stringValue) {
                    self = standardCase
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown EventType: \(stringValue)")
                }
            }
        }
        
        // Custom encoder to always use new field names
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.rawValue) // Always encode using current raw value
        }
        
        var displayName: String {
            switch self {
            case .braking: return "Braking"
            case .hardBraking: return "Hard Braking"
            case .acceleration: return "Acceleration"
            case .sharpTurn: return "Sharp Turn"
            case .roughRoad: return "Rough Road"
            case .phoneDistraction: return "Phone Use"
            case .horn: return "Horn"
            case .siren: return "Siren"
            }
        }
        
        var iconName: String {
            switch self {
            case .braking: return "exclamationmark.triangle"
            case .hardBraking: return "exclamationmark.triangle.fill"
            case .acceleration: return "forward.fill"
            case .sharpTurn: return "arrow.triangle.turn.up.right.circle"
            case .roughRoad: return "road.lanes"
            case .phoneDistraction: return "iphone"
            case .horn: return "speaker.wave.3.fill"
            case .siren: return "music.note"
            }
        }
        
        var color: UIColor {
            switch self {
            case .braking: return .systemOrange
            case .hardBraking: return .systemRed
            case .acceleration: return .systemGreen
            case .sharpTurn: return .systemYellow
            case .roughRoad: return .systemBrown
            case .phoneDistraction: return .systemRed
            case .horn: return .systemBlue
            case .siren: return .systemPurple
            }
        }
    }
}

struct CommuteRecord: Codable, Identifiable {
    let id: UUID
    let type: CommuteType
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let drivingMetrics: DrivingMetrics
    let startLocation: LocationPoint?
    let endLocation: LocationPoint?
    let pathPoints: [LocationPoint]
    let totalDistance: Double // meters
    let heavyTrafficPeriods: [HeavyTrafficPeriod]
    let drivingEvents: [DrivingEvent] // Key driving events with locations
    
    // Custom decoder for backward compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields (present in all versions)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        type = try container.decode(CommuteType.self, forKey: .type)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date.self, forKey: .endTime)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        drivingMetrics = try container.decode(DrivingMetrics.self, forKey: .drivingMetrics)
        
        // Optional location fields (may not exist in older formats)
        startLocation = try container.decodeIfPresent(LocationPoint.self, forKey: .startLocation)
        endLocation = try container.decodeIfPresent(LocationPoint.self, forKey: .endLocation)
        pathPoints = try container.decodeIfPresent([LocationPoint].self, forKey: .pathPoints) ?? []
        totalDistance = try container.decodeIfPresent(Double.self, forKey: .totalDistance) ?? 0.0
        
        // Optional newer fields (may not exist in older formats)
        heavyTrafficPeriods = try container.decodeIfPresent([HeavyTrafficPeriod].self, forKey: .heavyTrafficPeriods) ?? []
        drivingEvents = try container.decodeIfPresent([DrivingEvent].self, forKey: .drivingEvents) ?? []
    }
    
    
    init(type: CommuteType, startTime: Date, endTime: Date, duration: TimeInterval, drivingMetrics: DrivingMetrics, startLocation: LocationPoint?, endLocation: LocationPoint?, pathPoints: [LocationPoint], totalDistance: Double, heavyTrafficPeriods: [HeavyTrafficPeriod] = [], drivingEvents: [DrivingEvent] = []) {
        self.id = UUID()
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.drivingMetrics = drivingMetrics
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.pathPoints = pathPoints
        self.totalDistance = totalDistance
        self.heavyTrafficPeriods = heavyTrafficPeriods
        self.drivingEvents = drivingEvents
    }
    
    // Static formatters to avoid repeated creation
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var formattedDuration: String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
    
    var formattedStartTime: String {
        return Self.timeFormatter.string(from: startTime)
    }
    
    var formattedDate: String {
        return Self.dateFormatter.string(from: startTime)
    }
}

struct CommuteType: Codable, Hashable {
    let id: String
    let displayName: String
    let isDefault: Bool
    let isOneOff: Bool // For custom one-time trips
    
    static let homeToOffice = CommuteType(id: "home-to-office", displayName: "Home to Office", isDefault: true, isOneOff: false)
    static let officeToHome = CommuteType(id: "office-to-home", displayName: "Office to Home", isDefault: true, isOneOff: false)
    
    // Custom decoder for backward compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        displayName = try container.decode(String.self, forKey: .displayName)
        isDefault = try container.decode(Bool.self, forKey: .isDefault)
        isOneOff = try container.decodeIfPresent(Bool.self, forKey: .isOneOff) ?? false
    }
    
    // Regular initializer
    init(id: String, displayName: String, isDefault: Bool, isOneOff: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.isDefault = isDefault
        self.isOneOff = isOneOff
    }
}

struct CommuteFilterOption: Identifiable, Hashable {
    let id: String
    let displayName: String
    
    static let all = CommuteFilterOption(id: "all", displayName: "All Trips")
    static let oneOff = CommuteFilterOption(id: "one-off", displayName: "One-Off Trips")
    
    func matches(_ commuteType: CommuteType) -> Bool {
        if id == "all" {
            return true
        } else if id == "one-off" {
            return commuteType.isOneOff
        } else {
            return id == commuteType.id
        }
    }
}

// MARK: - Export/Import Data Models
struct AppDataExport: Codable {
    let commutes: [CommuteRecord]
    let settings: AppSettings
    let customTrips: [CommuteType]
    let exportDate: Date
    let appVersion: String
    
    // Custom decoder for backward compatibility
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields (present in all versions)
        commutes = try container.decode([CommuteRecord].self, forKey: .commutes)
        settings = try container.decode(AppSettings.self, forKey: .settings)
        
        // Optional fields (may not exist in older formats)
        customTrips = try container.decodeIfPresent([CommuteType].self, forKey: .customTrips) ?? []
        exportDate = try container.decodeIfPresent(Date.self, forKey: .exportDate) ?? Date()
        appVersion = try container.decodeIfPresent(String.self, forKey: .appVersion) ?? "legacy"
    }
    
    init(commutes: [CommuteRecord], settings: AppSettings, customTrips: [CommuteType]) {
        self.commutes = commutes
        self.settings = settings
        self.customTrips = customTrips
        self.exportDate = Date()
        self.appVersion = "1.0"
    }
}

struct AppSettings: Codable {
    let speedLimitThreshold: Double
    let keepScreenOn: Bool
    let useLocationBasedOrdering: Bool
}

enum ImportResult {
    case success(String)
    case failure(String)
}

enum CSVImportResult {
    case success(Int) // number of imported records
    case failure(String)
}

// MARK: - Trip Manager
class TripManager: ObservableObject {
    @Published var availableTrips: [CommuteType] = []
    
    private let userDefaults = UserDefaults.standard
    private let tripsKey = "CustomTrips"
    private let firstLaunchKey = "HasLaunchedBefore"
    
    init() {
        loadTrips()
    }
    
    private func loadTrips() {
        let hasLaunchedBefore = userDefaults.bool(forKey: firstLaunchKey)
        
        if !hasLaunchedBefore {
            // First launch - use default trips
            availableTrips = [CommuteType.homeToOffice, CommuteType.officeToHome]
            
            // Mark as launched and save defaults as user trips for future use
            userDefaults.set(true, forKey: firstLaunchKey)
            saveTripsAsCustom()
        } else {
            // Load saved trips from previous sessions
            if let data = userDefaults.data(forKey: tripsKey),
               let savedTrips = try? JSONDecoder().decode([CommuteType].self, from: data) {
                availableTrips = savedTrips
            } else {
                // Fallback if no saved trips found
                availableTrips = [CommuteType.homeToOffice, CommuteType.officeToHome]
            }
        }
    }
    
    func saveTrips() {
        do {
            let data = try JSONEncoder().encode(availableTrips)
            userDefaults.set(data, forKey: tripsKey)
            userDefaults.synchronize()  // Enable iCloud sync
        } catch {
        }
    }
    
    private func saveTripsAsCustom() {
        // Convert default trips to custom trips so they can be edited
        availableTrips = availableTrips.map { trip in
            CommuteType(id: trip.id, displayName: trip.displayName, isDefault: false, isOneOff: trip.isOneOff)
        }
        saveTrips()
    }
    
    func addTrip(name: String) {
        let customId = "custom-\(UUID().uuidString)"
        let newTrip = CommuteType(id: customId, displayName: name, isDefault: false)
        availableTrips.append(newTrip)
        saveTrips()
    }
    
    func updateTrip(tripId: String, newName: String) {
        if let index = availableTrips.firstIndex(where: { $0.id == tripId }) {
            let trip = availableTrips[index]
            // All trips are now treated as custom after first launch
            availableTrips[index] = CommuteType(id: trip.id, displayName: newName, isDefault: false, isOneOff: trip.isOneOff)
            saveTrips()
        }
    }
    
    func deleteTrip(tripId: String) {
        availableTrips.removeAll { $0.id == tripId }
        saveTrips()
    }
    
    func createOneOffTrip(name: String) -> CommuteType {
        let oneOffId = "one-off-\(UUID().uuidString.prefix(8))"
        return CommuteType(id: oneOffId, displayName: name, isDefault: false, isOneOff: true)
    }
    
    // Get trips for display (excludes one-off trips)
    var regularTrips: [CommuteType] {
        return availableTrips.filter { !$0.isOneOff }
    }
    
    // Get all trips including one-off for analytics
    var allTrips: [CommuteType] {
        return availableTrips
    }
    
    func isTripNameTaken(_ name: String, excludingTripId: String? = nil) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return availableTrips.contains { trip in
            trip.id != excludingTripId && 
            trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedName.lowercased()
        }
    }
    
    func canAddMoreTrips() -> Bool {
        return availableTrips.count < 8
    }
    
    func filterOptions(withCommutes commutes: [CommuteRecord]) -> [CommuteFilterOption] {
        var options = [CommuteFilterOption.all]
        
        // Add regular trips (excludes one-off trips)
        options.append(contentsOf: regularTrips.map { trip in
            CommuteFilterOption(id: trip.id, displayName: trip.displayName)
        })
        
        // Add one-off trips as a single option if any exist in commute history
        if commutes.contains(where: { $0.type.isOneOff }) {
            options.append(CommuteFilterOption.oneOff)
        }
        
        return options
    }
    
    // Backward compatibility - this version checks availableTrips only
    var filterOptions: [CommuteFilterOption] {
        var options = [CommuteFilterOption.all]
        
        // Add regular trips (excludes one-off trips)
        options.append(contentsOf: regularTrips.map { trip in
            CommuteFilterOption(id: trip.id, displayName: trip.displayName)
        })
        
        // Add one-off trips as a single option if any exist
        if availableTrips.contains(where: { $0.isOneOff }) {
            options.append(CommuteFilterOption.oneOff)
        }
        
        return options
    }
}

// MARK: - Sensor Manager
class SensorManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let altimeter = CMAltimeter()
    
    @Published var currentAcceleration: CMAcceleration?
    @Published var currentGyroscope: CMRotationRate?
    @Published var currentMagnetometer: CMMagneticField?
    @Published var currentAltitude: Double?
    @Published var isMotionAvailable = false
    
    private var accelerationHistory: [CMAcceleration] = []
    private let maxHistorySize = 100
    private var lastAccelerationEventTime: Date?
    private var lastDistractionEventTime: Date?
    
    // Orientation detection and coordinate transformation
    @Published var currentOrientation: DeviceOrientation = .unknown
    @Published var vehicleOrientation: VehicleOrientation = .unknown
    private var orientationHistory: [DeviceOrientation] = []
    private let orientationHistorySize = 10
    
    enum DeviceOrientation {
        case portrait, landscapeLeft, landscapeRight, portraitUpsideDown, faceUp, faceDown, unknown
    }
    
    enum VehicleOrientation {
        case dashboard, cupholder, seat, pocket, unknown
    }
    
    init() {
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        isMotionAvailable = motionManager.isDeviceMotionAvailable && 
                          motionManager.isAccelerometerAvailable &&
                          motionManager.isGyroAvailable
        
        if isMotionAvailable {
            // Optimize update intervals for battery life
            motionManager.deviceMotionUpdateInterval = 0.2  // Reduced from 0.1
            motionManager.accelerometerUpdateInterval = 0.2  
            motionManager.gyroUpdateInterval = 0.2
        }
    }
    
    func startSensorUpdates() {
        guard isMotionAvailable else { 
            return 
        }
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            if let error = error {
                return
            }
            
            guard let motion = motion else {
                return
            }
            
            // Detect device orientation using gravity vector
            let orientation = self?.detectOrientation(from: motion.gravity) ?? .unknown
            self?.updateOrientation(orientation)
            
            // Get gravity-compensated acceleration (userAcceleration already has gravity removed)
            // But we also need to transform gravity to vehicle coordinates for better understanding
            let transformedGravity = self?.transformAcceleration(motion.gravity, orientation: orientation) ?? motion.gravity
            let transformedAcceleration = self?.transformAcceleration(motion.userAcceleration, orientation: orientation) ?? motion.userAcceleration
            
            // Apply additional filtering to remove noise and get vehicle-relative acceleration
            let vehicleAcceleration = self?.applyVehicleAccelerationFilter(transformedAcceleration, gravity: transformedGravity) ?? transformedAcceleration
            
            self?.currentAcceleration = vehicleAcceleration
            self?.currentGyroscope = motion.rotationRate
            self?.currentMagnetometer = motion.magneticField.field
            
            self?.processAccelerationData(vehicleAcceleration)
        }
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] altitudeData, error in
                if let error = error {
                    return
                }
                
                if let altitude = altitudeData?.relativeAltitude {
                    self?.currentAltitude = altitude.doubleValue
                }
            }
        } else {
        }
    }
    
    func stopSensorUpdates() {
        motionManager.stopDeviceMotionUpdates()
        altimeter.stopRelativeAltitudeUpdates()
        accelerationHistory.removeAll()
        orientationHistory.removeAll()
        currentOrientation = .unknown
        vehicleOrientation = .unknown
    }
    
    private func processAccelerationData(_ acceleration: CMAcceleration) {
        accelerationHistory.append(acceleration)
        if accelerationHistory.count > maxHistorySize {
            accelerationHistory.removeFirst()
        }
    }
    
    func detectBrakingEvent() -> (isBraking: Bool, isHardBraking: Bool, intensity: Double) {
        guard accelerationHistory.count >= 5 else { return (false, false, 0) }
        
        let recentAccelerations = Array(accelerationHistory.suffix(5))
        
        // Calculate forward/backward acceleration (X-axis) and lateral acceleration (Y-axis)
        let avgForwardDeceleration = recentAccelerations.reduce(0) { $0 + $1.x } / Double(recentAccelerations.count)
        let avgLateralAcceleration = recentAccelerations.reduce(0) { $0 + abs($1.y) } / Double(recentAccelerations.count)
        
        // Combined intensity considering both forward braking and lateral movement
        let forwardIntensity = abs(avgForwardDeceleration)
        let combinedIntensity = sqrt(pow(forwardIntensity, 2) + pow(avgLateralAcceleration, 2))
        
        // More sensitive thresholds to detect even lighter braking
        let isHardBraking = avgForwardDeceleration < -0.25 || combinedIntensity > 0.35
        let isBraking = avgForwardDeceleration < -0.1 || combinedIntensity > 0.15
        
        return (isBraking, isHardBraking, combinedIntensity)
    }
    
    func detectRoughRoad() -> Bool {
        guard accelerationHistory.count >= 15 else { return false }
        
        let recentAccelerations = Array(accelerationHistory.suffix(15)) // 3 seconds of data
        let verticalValues = recentAccelerations.map { $0.z }
        
        // Calculate both variance and peak-to-peak amplitude for better detection
        let mean = verticalValues.reduce(0, +) / Double(verticalValues.count)
        let variance = verticalValues.reduce(0) { $0 + pow($1 - mean, 2) } / Double(verticalValues.count)
        
        // Also check for sudden spikes in vertical acceleration
        let maxValue = verticalValues.max() ?? 0
        let minValue = verticalValues.min() ?? 0
        let peakToPeak = maxValue - minValue
        
        return variance > 0.2 || peakToPeak > 0.8 // Less sensitive to avoid false positives on minor bumps
    }
    
    func detectSharpTurn() -> Bool {
        guard let gyroscope = currentGyroscope,
              accelerationHistory.count >= 3 else { return false }
        
        // Combine gyroscope rotation data with lateral acceleration for better detection
        let rotationMagnitude = abs(gyroscope.z)
        
        // Check recent lateral acceleration to complement gyroscope data
        let recentAccelerations = Array(accelerationHistory.suffix(3))
        let avgLateralAcceleration = recentAccelerations.reduce(0) { $0 + abs($1.y) } / Double(recentAccelerations.count)
        
        // Detect even moderate cornering (much more sensitive)
        let isSharpRotation = rotationMagnitude > 0.6 // Reduced from 1.2 to catch lighter turns
        let isHighLateralForce = avgLateralAcceleration > 0.25 // Reduced from 0.5 to catch gentler cornering
        
        return isSharpRotation || isHighLateralForce
    }
    
    func detectSpeedViolation(currentSpeed: Double, speedLimit: Double) -> Bool {
        return currentSpeed > speedLimit
    }
    
    func detectAccelerationEvent() -> Bool {
        guard accelerationHistory.count >= 5 else { return false }
        
        // Prevent duplicate detection within 2 seconds
        let now = Date()
        if let lastTime = lastAccelerationEventTime, now.timeIntervalSince(lastTime) < 2.0 {
            return false
        }
        
        let recentAccelerations = Array(accelerationHistory.suffix(5))
        
        // Calculate forward acceleration (positive X-axis indicates acceleration)
        let avgForwardAcceleration = recentAccelerations.reduce(0) { $0 + $1.x } / Double(recentAccelerations.count)
        
        // Detect even light acceleration events (positive forward acceleration)
        let isAccelerating = avgForwardAcceleration > 0.15 // More sensitive threshold for detecting acceleration
        
        if isAccelerating {
            lastAccelerationEventTime = now
        }
        
        return isAccelerating
    }
    
    func detectPhoneDistraction() -> Bool {
        guard let gyroscope = currentGyroscope else { return false }
        
        // Prevent duplicate detection within 3 seconds
        let now = Date()
        if let lastTime = lastDistractionEventTime, now.timeIntervalSince(lastTime) < 3.0 {
            return false
        }
        
        // Detect significant phone rotation/movement that indicates handling the phone
        let rotationMagnitude = sqrt(pow(gyroscope.x, 2) + pow(gyroscope.y, 2) + pow(gyroscope.z, 2))
        
        // High rotation values indicate phone manipulation during driving
        let isDistracted = rotationMagnitude > 2.0
        
        if isDistracted {
            lastDistractionEventTime = now
        }
        
        return isDistracted
    }
    
    // MARK: - Orientation Detection and Coordinate Transformation
    
    private func detectOrientation(from gravity: CMAcceleration) -> DeviceOrientation {
        let x = gravity.x
        let y = gravity.y
        let z = gravity.z
        
        // Use gravity vector to determine orientation
        // Based on dominant gravity component
        if abs(z) > abs(x) && abs(z) > abs(y) {
            return z > 0.7 ? .faceDown : .faceUp
        } else if abs(y) > abs(x) {
            return y > 0.7 ? .portraitUpsideDown : .portrait
        } else {
            return x > 0.7 ? .landscapeRight : .landscapeLeft
        }
    }
    
    private func updateOrientation(_ newOrientation: DeviceOrientation) {
        orientationHistory.append(newOrientation)
        if orientationHistory.count > orientationHistorySize {
            orientationHistory.removeFirst()
        }
        
        // Use most common orientation in recent history to avoid jitter
        let mostCommon = orientationHistory.max(by: { orientation1, orientation2 in
            orientationHistory.filter { $0 == orientation1 }.count < orientationHistory.filter { $0 == orientation2 }.count
        })
        
        if let stable = mostCommon {
            currentOrientation = stable
            vehicleOrientation = inferVehicleOrientation(from: stable)
        }
    }
    
    private func inferVehicleOrientation(from deviceOrientation: DeviceOrientation) -> VehicleOrientation {
        // Infer how phone is positioned in vehicle based on device orientation
        switch deviceOrientation {
        case .portrait:
            return .dashboard // Phone mounted upright on dashboard
        case .landscapeLeft, .landscapeRight:
            return .cupholder // Phone lying sideways in cupholder
        case .faceUp:
            return .seat // Phone lying flat on seat
        case .faceDown:
            return .pocket // Phone face down, likely in pocket
        case .portraitUpsideDown:
            return .dashboard // Upside down mount
        case .unknown:
            return .unknown
        }
    }
    
    private func transformAcceleration(_ acceleration: CMAcceleration, orientation: DeviceOrientation) -> CMAcceleration {
        // Transform acceleration data to vehicle coordinate system
        // Vehicle coordinates: X = forward/backward, Y = left/right, Z = up/down
        
        switch orientation {
        case .portrait:
            // Phone upright: X stays X, Y stays Y, Z stays Z
            return acceleration
            
        case .landscapeLeft:
            // Phone rotated 90° counterclockwise: X becomes Y, Y becomes -X
            return CMAcceleration(x: acceleration.y, y: -acceleration.x, z: acceleration.z)
            
        case .landscapeRight:
            // Phone rotated 90° clockwise: X becomes -Y, Y becomes X
            return CMAcceleration(x: -acceleration.y, y: acceleration.x, z: acceleration.z)
            
        case .portraitUpsideDown:
            // Phone upside down: X becomes -X, Y becomes -Y
            return CMAcceleration(x: -acceleration.x, y: -acceleration.y, z: acceleration.z)
            
        case .faceUp:
            // Phone flat face up: X stays X, Y stays Y, Z becomes -Z
            return CMAcceleration(x: acceleration.x, y: acceleration.y, z: -acceleration.z)
            
        case .faceDown:
            // Phone flat face down: X becomes -X, Y stays Y, Z stays Z
            return CMAcceleration(x: -acceleration.x, y: acceleration.y, z: acceleration.z)
            
        case .unknown:
            // No transformation if orientation unknown
            return acceleration
        }
    }
    
    private func applyVehicleAccelerationFilter(_ acceleration: CMAcceleration, gravity: CMAcceleration) -> CMAcceleration {
        // Apply additional filtering and compensation for vehicle dynamics
        
        // Low-pass filter to reduce high-frequency noise
        let alpha = 0.8 // Smoothing factor
        
        // Simple low-pass filtering (in real implementation, you'd want a proper filter)
        let filteredX = acceleration.x * alpha
        let filteredY = acceleration.y * alpha  
        let filteredZ = acceleration.z * alpha
        
        // Compensate for vehicle tilt by considering gravity orientation
        // This helps distinguish between vehicle acceleration and phone movement
        let gravityMagnitude = sqrt(pow(gravity.x, 2) + pow(gravity.y, 2) + pow(gravity.z, 2))
        
        // Apply gravity compensation factor based on vehicle orientation
        var compensatedX = filteredX
        let compensatedY = filteredY
        let compensatedZ = filteredZ
        
        // If vehicle is on an incline, adjust forward/backward acceleration
        if gravityMagnitude > 0.8 { // Reasonable gravity magnitude
            let tiltFactor = abs(gravity.x) / gravityMagnitude
            compensatedX = filteredX * (1.0 + tiltFactor * 0.1) // Small compensation
        }
        
        return CMAcceleration(x: compensatedX, y: compensatedY, z: compensatedZ)
    }
    
    func getOrientationDescription() -> String {
        switch vehicleOrientation {
        case .dashboard:
            return "📱 Dashboard Mount"
        case .cupholder:
            return "🥤 Cupholder"  
        case .seat:
            return "💺 On Seat"
        case .pocket:
            return "👖 In Pocket"
        case .unknown:
            return "❓ Unknown Position"
        }
    }
    
    private func calculateVariance(_ values: [Double]) -> Double {
        guard !values.isEmpty else { return 0 }
        
        let mean = values.reduce(0, +) / Double(values.count)
        let squaredDifferences = values.map { pow($0 - mean, 2) }
        return squaredDifferences.reduce(0, +) / Double(values.count)
    }
}

// MARK: - Sound Analysis Manager
import SoundAnalysis
import AVFoundation

class SoundAnalysisManager: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var requests: [SNRequest] = []
    private var isAudioSessionActive = false
    
    @Published var isListening = false
    @Published var lastDetectedSound: String?
    @Published var audioSessionInterrupted = false
    
    // Callbacks for detected events
    var onCarHornDetected: (() -> Void)?
    var onSirenDetected: (() -> Void)?
    
    // Rate limiting for audio event detection
    private var lastSirenDetectionTime: Date?
    private let sirenDetectionCooldown: TimeInterval = 60.0 // 1 minute between siren detections
    private var lastHornDetectionTime: Date?
    private let hornDetectionCooldown: TimeInterval = 1.0 // 1 second between horn detections (appropriate for Indian traffic)
    
    override init() {
        super.init()
        setupAudioEngine()
        setupAudioSessionNotifications()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else { return }
        
        inputNode = audioEngine.inputNode
        
        // Request microphone permission
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                } else {
                }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                } else {
                }
            }
        }
    }
    
    private func setupAudioSessionNotifications() {
        // Listen for audio session interruptions (phone calls, etc.)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )
        
        // Listen for route changes (headphones, bluetooth, etc.)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioSessionRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
    }
    
    @objc private func audioSessionInterruption(notification: Notification) {
        guard let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        DispatchQueue.main.async {
            switch type {
            case .began:
                self.audioSessionInterrupted = true
                self.pauseListening()
                
            case .ended:
                self.audioSessionInterrupted = false
                
                // Check if we should resume
                if let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt {
                    let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                    if options.contains(.shouldResume) {
                        self.resumeListening()
                    }
                }
                
            @unknown default:
                break
            }
        }
    }
    
    @objc private func audioSessionRouteChange(notification: Notification) {
        // Handle route changes gracefully - just log for now
    }
    
    private func pauseListening() {
        if audioEngine?.isRunning == true {
            audioEngine?.pause()
        }
    }
    
    private func resumeListening() {
        if isListening && audioEngine?.isRunning == false {
            do {
                try audioEngine?.start()
            } catch {
            }
        }
    }
    
    func startListening() {
        guard let audioEngine = audioEngine,
              let inputNode = inputNode else { 
            return 
        }
        
        do {
            // Configure audio session for background recording with interruption handling
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(
                .playAndRecord,
                mode: .measurement,
                options: [.duckOthers, .allowBluetooth, .allowBluetoothA2DP, .mixWithOthers]
            )
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            isAudioSessionActive = true
            
            // Get and validate input format
            let inputFormat = inputNode.outputFormat(forBus: 0)
            
            // Validate audio format to prevent crash
            guard inputFormat.channelCount > 0 && inputFormat.sampleRate > 0 else {
                
                // Mark as listening but skip actual audio processing
                DispatchQueue.main.async {
                    self.isListening = true
                }
                return
            }
            
            streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
            
            // Set up sound classification requests
            setupSoundClassificationRequests()
            
            // Install tap on input node
            inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat) { [weak self] buffer, time in
                self?.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
            
            // Start audio engine with additional validation
            guard !audioEngine.isRunning else {
                DispatchQueue.main.async {
                    self.isListening = true
                }
                return
            }
            
            try audioEngine.start()
            
            DispatchQueue.main.async {
                self.isListening = true
            }
            
            
        } catch {
            
            // Graceful fallback - mark as listening but without actual audio processing
            DispatchQueue.main.async {
                self.isListening = true
            }
            
            // Deactivate audio session on failure
            if isAudioSessionActive {
                do {
                    try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
                    isAudioSessionActive = false
                } catch {
                }
            }
        }
    }
    
    func stopListening() {
        // Only stop if audio engine was actually started
        if audioEngine?.isRunning == true {
            audioEngine?.stop()
        }
        
        // Only remove tap if it was installed
        if inputNode?.inputFormat(forBus: 0).channelCount ?? 0 > 0 {
            inputNode?.removeTap(onBus: 0)
        }
        
        streamAnalyzer = nil
        requests.removeAll()
        
        // Deactivate audio session
        if isAudioSessionActive {
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
                isAudioSessionActive = false
            } catch {
            }
        }
        
        DispatchQueue.main.async {
            self.isListening = false
            self.audioSessionInterrupted = false
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopListening()
    }
    
    private func setupSoundClassificationRequests() {
        do {
            // Use Apple's built-in sound classifier as a starting point
            // This provides basic sound classification capabilities
            // Note: SNClassifySoundRequest() requires iOS 15+ and proper setup
            if #available(iOS 15.0, *) {
                let classifyRequest = try SNClassifySoundRequest(classifierIdentifier: .version1)
                requests.append(classifyRequest)
                
                try streamAnalyzer?.add(classifyRequest, withObserver: self)
                
            } else {
            }
            
        } catch {
        }
    }
}

// MARK: - SNResultsObserving
extension SoundAnalysisManager: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        
        // Process classification results
        for classification in result.classifications {
            let confidence = classification.confidence
            let identifier = classification.identifier.lowercased()
            
            // Debug logging for all sound classifications above 0.2 confidence
            if confidence > 0.2 {
            }
            
            // Look for siren sounds with high sensitivity
            if confidence > 0.2 && (identifier.contains("siren") || identifier.contains("emergency")) {
                // Apply rate limiting for siren detection
                let now = Date()
                if let lastDetection = self.lastSirenDetectionTime,
                   now.timeIntervalSince(lastDetection) < self.sirenDetectionCooldown {
                    return
                }
                
                self.lastSirenDetectionTime = now
                DispatchQueue.main.async {
                    self.lastDetectedSound = "Siren"
                    self.onSirenDetected?()
                }
            }
            // Look for horn sounds with moderate sensitivity
            else if confidence > 0.35 { // Slightly higher threshold to reduce false positives
                if identifier.contains("horn") || 
                   identifier.contains("car horn") ||
                   identifier.contains("vehicle horn") ||
                   identifier.contains("honk") ||
                   identifier.contains("beep") ||
                   identifier.contains("automotive") ||
                   identifier.contains("truck horn") ||
                   identifier.contains("car beep") ||
                   identifier.contains("vehicle beep") {
                    
                    // Apply rate limiting for horn detection
                    let now = Date()
                    if let lastDetection = self.lastHornDetectionTime,
                       now.timeIntervalSince(lastDetection) < self.hornDetectionCooldown {
                        return
                    }
                    
                    self.lastHornDetectionTime = now
                    DispatchQueue.main.async {
                        self.lastDetectedSound = "Horn"
                        self.onCarHornDetected?()
                    }
                }
                // Secondary tier for potential horn sounds with lower confidence
                else if confidence > 0.2 && (
                    identifier.contains("whistle") ||
                    identifier.contains("toot") ||
                    identifier.contains("blast") ||
                    identifier.contains("warning") ||
                    identifier.contains("alert") ||
                    identifier.contains("signal") ||
                    identifier.contains("noise") && identifier.contains("car") ||
                    identifier.contains("noise") && identifier.contains("vehicle") ||
                    identifier.contains("sound") && identifier.contains("automotive")
                ) {
                    // Apply rate limiting for possible horn detection too
                    let now = Date()
                    if let lastDetection = self.lastHornDetectionTime,
                       now.timeIntervalSince(lastDetection) < self.hornDetectionCooldown {
                        return
                    }
                    
                    self.lastHornDetectionTime = now
                    DispatchQueue.main.async {
                        self.lastDetectedSound = "Possible Horn"
                        self.onCarHornDetected?()
                    }
                }
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
    }
    
    func requestDidComplete(_ request: SNRequest) {
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var isTracking = false
    @Published var locationError: String?
    @Published var currentSpeed: Double = 0.0
    @Published var totalDistance: Double = 0.0
    
    private var lastLocation: CLLocation?
    private var speedHistory: [Double] = []
    private var pathPoints: [LocationPoint] = []
    var startLocation: LocationPoint?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        // Configure for background location tracking during phone calls/app switching
        locationManager.pausesLocationUpdatesAutomatically = false
        
        // Enable background location updates if we have "Always" authorization
        // This will be set properly when authorization is granted
        if authorizationStatus == .authorizedAlways {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        
        authorizationStatus = locationManager.authorizationStatus
        
        // Listen for app lifecycle changes to restart location tracking if needed
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func appDidBecomeActive() {
        // Restart location updates if we were tracking and app becomes active
        if isTracking {
            locationManager.startUpdatingLocation()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func requestLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            locationError = "Location access denied. Please enable in Settings."
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        default:
            break
        }
    }
    
    func startLocationUpdates() {
        // Always initialize tracking state regardless of permissions
        isTracking = true
        totalDistance = 0.0
        speedHistory.removeAll()
        pathPoints.removeAll()
        startLocation = nil
        
        // Check permissions and start location updates if available
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        // Configure background location if authorized
        if authorizationStatus == .authorizedAlways {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
        }
        
        // Check if location services are enabled on background queue to avoid main thread blocking
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard CLLocationManager.locationServicesEnabled() else {
                DispatchQueue.main.async {
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func stopLocationUpdates() -> [LocationPoint] {
        isTracking = false
        locationManager.stopUpdatingLocation()
        lastLocation = nil
        let recordedPath = pathPoints
        pathPoints.removeAll()
        return recordedPath
    }
    
    func getStartLocation() -> LocationPoint? {
        return startLocation
    }
    
    func getCurrentLocationPoint() -> LocationPoint? {
        guard let location = currentLocation else { return nil }
        return LocationPoint(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: location.timestamp,
            speed: max(0, location.speed * 3.6), // Convert m/s to km/h
            accuracy: location.horizontalAccuracy
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Filter out inaccurate GPS readings
        guard location.horizontalAccuracy <= 50.0 && location.horizontalAccuracy > 0 else {
            return // Skip readings with poor accuracy (>50m) or invalid readings
        }
        
        DispatchQueue.main.async {
            self.currentLocation = location
            self.locationError = nil
            
            if location.speed >= 0 {
                let speedKmh = location.speed * 3.6
                
                // Apply simple smoothing to GPS speed readings to reduce noise
                if !self.speedHistory.isEmpty {
                    let lastSpeed = self.speedHistory.last ?? 0
                    let smoothedSpeed = (speedKmh + lastSpeed * 2) / 3 // Weighted average
                    self.currentSpeed = smoothedSpeed
                } else {
                    self.currentSpeed = speedKmh
                }
                
                self.speedHistory.append(self.currentSpeed)
                if self.speedHistory.count > 100 {
                    self.speedHistory.removeFirst()
                }
            }
            
            // Record start location
            if self.startLocation == nil && self.isTracking {
                self.startLocation = LocationPoint(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    timestamp: location.timestamp,
                    speed: max(0, location.speed * 3.6),
                    accuracy: location.horizontalAccuracy
                )
            }
            
            // Record path points during tracking
            if self.isTracking {
                let newPoint = LocationPoint(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    timestamp: location.timestamp,
                    speed: max(0, location.speed * 3.6),
                    accuracy: location.horizontalAccuracy
                )
                self.pathPoints.append(newPoint)
                
                // Limit path points to prevent memory issues (keep last 1000 points)
                if self.pathPoints.count > 1000 {
                    self.pathPoints.removeFirst()
                }
            }
            
            if let lastLocation = self.lastLocation {
                let horizontalDistance = location.distance(from: lastLocation)
                if horizontalDistance > 0 {
                    // Calculate 3D distance including elevation change if available
                    var totalDistance3D = horizontalDistance
                    
                    if location.verticalAccuracy <= 20.0 && lastLocation.verticalAccuracy <= 20.0 {
                        let elevationChange = abs(location.altitude - lastLocation.altitude)
                        totalDistance3D = sqrt(pow(horizontalDistance, 2) + pow(elevationChange, 2))
                    }
                    
                    self.totalDistance += totalDistance3D
                }
            }
            
            self.lastLocation = location
        }
    }
    
    var averageSpeed: Double {
        guard !speedHistory.isEmpty else { return 0.0 }
        return speedHistory.reduce(0, +) / Double(speedHistory.count)
    }
    
    var maxSpeed: Double {
        return speedHistory.max() ?? 0.0
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error.localizedDescription
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        switch status {
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.locationError = "Location access denied"
                self.isTracking = false
            }
            locationManager.stopUpdatingLocation()
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                self.locationError = nil
            }
            // Enable background location updates if we have "Always" authorization
            if status == .authorizedAlways {
                locationManager.allowsBackgroundLocationUpdates = true
            } else {
                locationManager.allowsBackgroundLocationUpdates = false
            }
        default:
            break
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Commute Tracker
class CommuteTracker: ObservableObject {
    @Published var commutes: [CommuteRecord] = []
    @Published var activeCommute: (type: CommuteType, startTime: Date)?
    @Published var currentMetrics = DrivingMetrics()
    private var currentDrivingEvents: [DrivingEvent] = []
    
    // iCloud sync status tracking
    @Published var isSyncInProgress: Bool = false
    @Published var lastSyncTime: Date?
    @Published var syncDataSize: String = "0 KB"
    
    private var sensorManager: SensorManager?
    private var locationManager: LocationManager?
    private var settingsManager: SettingsManager?
    private var metricsTimer: Timer?
    private var lastSpeedViolationTime: Date?
    private var _slowTrafficStartTime: Date?
    @Published var isCurrentlyInSlowTraffic = false
    
    var slowTrafficStartTime: Date? {
        return _slowTrafficStartTime
    }
    
    // Analytics caching
    private var cachedWeeklyInsights: [String: [CommuteRecord]]?
    private var lastInsightsUpdate: Date?
    
    // Persistence
    private let userDefaults = UserDefaults.standard
    private let commutesKey = "SavedCommutes"
    
    init() {
        loadCommutes()
    }
    
    func startCommute(type: CommuteType, sensorManager: SensorManager, locationManager: LocationManager, settingsManager: SettingsManager) {
        activeCommute = (type: type, startTime: Date())
        currentMetrics = DrivingMetrics()
        self.sensorManager = sensorManager
        self.locationManager = locationManager
        self.settingsManager = settingsManager
        self.lastSpeedViolationTime = nil
        self._slowTrafficStartTime = nil
        self.isCurrentlyInSlowTraffic = false
        
        startMetricsCollection()
    }
    
    func stopCommute(onCompletion: ((UUID) -> Void)? = nil) {
        guard let active = activeCommute else { return }
        let endTime = Date()
        let duration = endTime.timeIntervalSince(active.startTime)
        
        stopMetricsCollection()
        
        // Handle case where trip ends while in slow traffic
        if isCurrentlyInSlowTraffic, let startTime = _slowTrafficStartTime {
            let slowTrafficDuration = endTime.timeIntervalSince(startTime)
            currentMetrics.slowTrafficTime += slowTrafficDuration
        }
        
        var startLoc: LocationPoint?
        var endLoc: LocationPoint?
        var pathPoints: [LocationPoint] = []
        var totalDistance: Double = 0.0
        
        if let locationManager = locationManager {
            currentMetrics.maxSpeed = locationManager.maxSpeed
            currentMetrics.averageSpeed = locationManager.averageSpeed
            currentMetrics.totalDistance = locationManager.totalDistance
            
            // Get GPS data
            startLoc = locationManager.getStartLocation()
            endLoc = locationManager.getCurrentLocationPoint()
            pathPoints = locationManager.stopLocationUpdates()
            totalDistance = locationManager.totalDistance
        }
        
        // Analyze path for heavy traffic periods
        let heavyTrafficPeriods = analyzeHeavyTraffic(pathPoints: pathPoints)
        
        let commute = CommuteRecord(
            type: active.type,
            startTime: active.startTime,
            endTime: endTime,
            duration: duration,
            drivingMetrics: currentMetrics,
            startLocation: startLoc,
            endLocation: endLoc,
            pathPoints: pathPoints,
            totalDistance: totalDistance,
            heavyTrafficPeriods: heavyTrafficPeriods,
            drivingEvents: currentDrivingEvents
        )
        
        // Ensure UI updates happen on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.commutes.insert(commute, at: 0)
            self.activeCommute = nil
            self.currentMetrics = DrivingMetrics()
            self.currentDrivingEvents = [] // Reset driving events for next trip
            
            // Invalidate analytics cache when new commute is added
            self.cachedWeeklyInsights = nil
            
            if self.commutes.count > 100 {
                self.commutes = Array(self.commutes.prefix(100))
            }
            
            // Save after UI state is updated
            self.saveCommutes()
            
            // Notify completion with the commute ID
            onCompletion?(commute.id)
        }
        
        
        // Test encoding the commute before adding to array
        do {
            let testData = try JSONEncoder().encode([commute])
        } catch {
            return // Don't save if we can't encode
        }
    }
    
    private func startMetricsCollection() {
        // Reduce timer frequency for better battery life
        metricsTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.collectSensorMetrics()
        }
    }
    
    private func stopMetricsCollection() {
        metricsTimer?.invalidate()
        metricsTimer = nil
    }
    
    func addDrivingEvent(_ event: DrivingEvent) {
        currentDrivingEvents.append(event)
        
        // Update metrics counters
        switch event.type {
        case .horn:
            currentMetrics.hornEvents += 1
        case .siren:
            currentMetrics.sirenEvents += 1
        default:
            break
        }
        
    }
    
    private func collectSensorMetrics() {
        guard let sensorManager = sensorManager,
              let locationManager = locationManager,
              let settingsManager = settingsManager else { return }
        
        // Get current location for event recording
        let currentLocation = locationManager.currentLocation
        
        // Optimized braking detection with separate counts
        let brakingResult = sensorManager.detectBrakingEvent()
        if brakingResult.isBraking {
            currentMetrics.brakingEventCount += 1
            
            // Store event with location
            if let location = currentLocation {
                let eventType: DrivingEvent.EventType = brakingResult.isHardBraking ? .hardBraking : .braking
                let event = DrivingEvent(
                    type: eventType,
                    location: LocationPoint(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        timestamp: Date(),
                        speed: max(0, location.speed * 3.6),
                        accuracy: location.horizontalAccuracy
                    ),
                    intensity: brakingResult.intensity,
                    timestamp: Date()
                )
                currentDrivingEvents.append(event)
            }
            
            if brakingResult.isHardBraking {
                currentMetrics.hardBrakingEventCount += 1
            }
        }
        
        if sensorManager.detectRoughRoad() {
            currentMetrics.roughRoadEvents += 1
            
            // Store rough road event
            if let location = currentLocation {
                let event = DrivingEvent(
                    type: .roughRoad,
                    location: LocationPoint(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        timestamp: Date(),
                        speed: max(0, location.speed * 3.6),
                        accuracy: location.horizontalAccuracy
                    ),
                    intensity: 0.5, // Default intensity for rough road
                    timestamp: Date()
                )
                currentDrivingEvents.append(event)
            }
        }
        
        if sensorManager.detectSharpTurn() {
            currentMetrics.sharpTurns += 1
            
            // Store sharp turn event
            if let location = currentLocation {
                let event = DrivingEvent(
                    type: .sharpTurn,
                    location: LocationPoint(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        timestamp: Date(),
                        speed: max(0, location.speed * 3.6),
                        accuracy: location.horizontalAccuracy
                    ),
                    intensity: 0.6, // Default intensity for sharp turn
                    timestamp: Date()
                )
                currentDrivingEvents.append(event)
            }
        }
        
        // Acceleration event detection
        if sensorManager.detectAccelerationEvent() {
            currentMetrics.accelerationEvents += 1
            
            // Store acceleration event
            if let location = currentLocation {
                let event = DrivingEvent(
                    type: .acceleration,
                    location: LocationPoint(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        timestamp: Date(),
                        speed: max(0, location.speed * 3.6),
                        accuracy: location.horizontalAccuracy
                    ),
                    intensity: 0.4, // Default intensity for acceleration
                    timestamp: Date()
                )
                currentDrivingEvents.append(event)
            }
        }
        
        // Phone distraction detection
        if sensorManager.detectPhoneDistraction() {
            currentMetrics.phoneDistractions += 1
            
            // Store phone distraction event
            if let location = currentLocation {
                let event = DrivingEvent(
                    type: .phoneDistraction,
                    location: LocationPoint(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude,
                        timestamp: Date(),
                        speed: max(0, location.speed * 3.6),
                        accuracy: location.horizontalAccuracy
                    ),
                    intensity: 0.8, // High intensity for phone distraction
                    timestamp: Date()
                )
                currentDrivingEvents.append(event)
            }
        }
        
        // Speed violation detection with reduced cooldown for better accuracy
        if sensorManager.detectSpeedViolation(currentSpeed: locationManager.currentSpeed, speedLimit: settingsManager.speedLimitThreshold) {
            let now = Date()
            if let lastViolation = lastSpeedViolationTime {
                // Reduced cooldown to 5 seconds - better balance between accuracy and spam prevention
                if now.timeIntervalSince(lastViolation) > 5.0 {
                    currentMetrics.speedViolations += 1
                    lastSpeedViolationTime = now
                }
            } else {
                currentMetrics.speedViolations += 1
                lastSpeedViolationTime = now
            }
        }
        
        // Slow traffic time tracking (under 15 km/h)
        let currentSpeed = locationManager.currentSpeed
        let now = Date()
        let slowTrafficThreshold: Double = 15.0
        
        if currentSpeed < slowTrafficThreshold {
            if !isCurrentlyInSlowTraffic {
                // Just entered slow traffic
                isCurrentlyInSlowTraffic = true
                _slowTrafficStartTime = now
            }
            // Continue tracking slow traffic time
        } else {
            if isCurrentlyInSlowTraffic {
                // Just exited slow traffic
                isCurrentlyInSlowTraffic = false
                if let startTime = _slowTrafficStartTime {
                    let slowTrafficDuration = now.timeIntervalSince(startTime)
                    currentMetrics.slowTrafficTime += slowTrafficDuration
                }
                _slowTrafficStartTime = nil
            }
        }
        
        // Remove expensive acceleration event storage - not needed for metrics
    }
    
    func exportToCSV() -> String {
        var csvContent = "Date,Type,Start Time,End Time,Duration (minutes),Driving Score,Quality,Braking Events,Hard Braking,Max Speed (km/h),Average Speed (km/h),Distance (m),Rough Road Events,Sharp Turns,Speed Violations,Acceleration Events,Phone Distractions,Horn Events,Siren Events,Slow Traffic Time (min),Slow Traffic %,Start Latitude,Start Longitude,End Latitude,End Longitude,Path Points Count,Heavy Traffic Periods,Total Heavy Traffic Duration (min)\n"
        
        // Use shared formatters from CommuteRecord
        for commute in commutes.reversed() {
            let date = commute.formattedDate
            let type = commute.type.displayName
            let startTime = commute.formattedStartTime
            let endTime = CommuteRecord.timeFormatter.string(from: commute.endTime)
            let duration = String(format: "%.1f", commute.duration / 60.0)
            let metrics = commute.drivingMetrics
            
            let startLat = commute.startLocation?.latitude.description ?? ""
            let startLng = commute.startLocation?.longitude.description ?? ""
            let endLat = commute.endLocation?.latitude.description ?? ""
            let endLng = commute.endLocation?.longitude.description ?? ""
            let pathCount = commute.pathPoints.count
            let heavyTrafficCount = commute.heavyTrafficPeriods.count
            let totalHeavyTrafficDuration = commute.heavyTrafficPeriods.reduce(0) { $0 + $1.duration } / 60.0
            let slowTrafficTimeMin = metrics.slowTrafficTime / 60.0
            let slowTrafficPercentage = commute.duration > 0 ? (metrics.slowTrafficTime / commute.duration) * 100 : 0
            
            csvContent += "\(date),\(type),\(startTime),\(endTime),\(duration),\(metrics.drivingScore),\(metrics.qualityDescription),\(metrics.brakingEventCount),\(metrics.hardBrakingEventCount),\(String(format: "%.1f", metrics.maxSpeed)),\(String(format: "%.1f", metrics.averageSpeed)),\(String(format: "%.0f", commute.totalDistance)),\(metrics.roughRoadEvents),\(metrics.sharpTurns),\(metrics.speedViolations),\(metrics.accelerationEvents),\(metrics.phoneDistractions),\(metrics.hornEvents),\(metrics.sirenEvents),\(String(format: "%.1f", slowTrafficTimeMin)),\(String(format: "%.1f", slowTrafficPercentage)),\(startLat),\(startLng),\(endLat),\(endLng),\(pathCount),\(heavyTrafficCount),\(String(format: "%.1f", totalHeavyTrafficDuration))\n"
        }
        
        return csvContent
    }
    
    func importFromCSV(_ csvContent: String) throws -> Int {
        
        let lines = csvContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        guard lines.count > 1 else {
            throw ImportError.invalidFormat("CSV file is empty or contains only header")
        }
        
        let header = lines[0]
        let dataLines = Array(lines[1...])
        
        
        // Detect format based on header
        let isOldFormat = header.contains("Car Horn Events")
        let expectedColumns = isOldFormat ? 27 : 27 // Same number of columns, just different names
        
        
        var importedCount = 0
        var skippedCount = 0
        var errorCount = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"  // Handle "Aug 22, 2025" format
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        for (index, line) in dataLines.enumerated() {
            do {
                let columns = parseCSVLine(line)
                
                guard columns.count >= expectedColumns else {
                    skippedCount += 1
                    continue
                }
                
                // Parse date and times
                guard let date = dateFormatter.date(from: columns[0]),
                      let startTime = parseTimeWithDate(columns[2], date: date),
                      let endTime = parseTimeWithDate(columns[3], date: date) else {
                    skippedCount += 1
                    continue
                }
                
                // Parse commute type
                let typeString = columns[1]
                let commuteType = CommuteType(id: typeString.lowercased().replacingOccurrences(of: " ", with: "-"), displayName: typeString, isDefault: false, isOneOff: false)
                
                // Parse metrics with backward compatibility
                let metrics = try parseMetricsFromCSV(columns: columns, isOldFormat: isOldFormat)
                
                // Create commute record using custom initializer
                let commute = CommuteRecord(
                    type: commuteType,
                    startTime: startTime,
                    endTime: endTime,
                    duration: endTime.timeIntervalSince(startTime),
                    drivingMetrics: metrics,
                    startLocation: parseLocation(lat: columns[20], lng: columns[21]),
                    endLocation: parseLocation(lat: columns[22], lng: columns[23]),
                    pathPoints: [], // CSV doesn't contain full path data
                    totalDistance: Double(columns[11]) ?? 0.0,
                    heavyTrafficPeriods: [], // CSV doesn't contain detailed traffic data
                    drivingEvents: [] // CSV doesn't contain event details
                )
                
                // Add to commutes if not duplicate
                if !isDuplicateCommute(commute) {
                    commutes.append(commute)
                    importedCount += 1
                } else {
                    skippedCount += 1
                }
                
            } catch {
                errorCount += 1
                continue
            }
        }
        
        
        // Sort by start time
        commutes.sort { $0.startTime < $1.startTime }
        
        // Save to disk
        saveCommutes()
        
        return importedCount
    }
    
    private func parseCSVLine(_ line: String) -> [String] {
        // Special handling for our date format "Aug 22, 2025" which contains commas
        // Use regex to handle the date pattern properly
        
        let datePattern = #"^(\w+\s+\d+,\s+\d+),"#
        let regex = try? NSRegularExpression(pattern: datePattern)
        
        var processedLine = line
        if let match = regex?.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)) {
            let dateRange = Range(match.range(at: 1), in: line)!
            let datePart = String(line[dateRange])
            // Replace commas in the date with a placeholder
            let quotedDate = "\"\(datePart)\""
            processedLine = line.replacingCharacters(in: dateRange, with: quotedDate)
        }
        
        // Now parse the CSV normally
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        
        for char in processedLine {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                fields.append(currentField.trimmingCharacters(in: .whitespacesAndNewlines))
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        
        // Add the last field
        fields.append(currentField.trimmingCharacters(in: .whitespacesAndNewlines))
        
        // Debug: print first few fields to see parsing
        
        return fields
    }
    
    private func parseTimeWithDate(_ timeString: String, date: Date) -> Date? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        guard let time = timeFormatter.date(from: timeString) else { return nil }
        
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents)
    }
    
    private func parseLocation(lat: String, lng: String) -> LocationPoint? {
        guard let latitude = Double(lat), let longitude = Double(lng) else { return nil }
        return LocationPoint(latitude: latitude, longitude: longitude, timestamp: Date(), speed: 0.0, accuracy: 0.0)
    }
    
    private func parseMetricsFromCSV(columns: [String], isOldFormat: Bool) throws -> DrivingMetrics {
        var metrics = DrivingMetrics()
        
        // Parse common fields (same in both formats)
        metrics.brakingEventCount = Int(columns[7]) ?? 0
        metrics.hardBrakingEventCount = Int(columns[8]) ?? 0
        metrics.maxSpeed = Double(columns[9]) ?? 0.0
        metrics.averageSpeed = Double(columns[10]) ?? 0.0
        metrics.roughRoadEvents = Int(columns[12]) ?? 0
        metrics.sharpTurns = Int(columns[13]) ?? 0
        metrics.speedViolations = Int(columns[14]) ?? 0
        metrics.accelerationEvents = Int(columns[15]) ?? 0
        metrics.phoneDistractions = Int(columns[16]) ?? 0
        metrics.sirenEvents = Int(columns[18]) ?? 0
        metrics.slowTrafficTime = (Double(columns[19]) ?? 0.0) * 60.0 // Convert minutes to seconds
        
        // Handle horn events with backward compatibility
        if isOldFormat {
            // Old format: "Car Horn Events" at column 17
            metrics.hornEvents = Int(columns[17]) ?? 0
        } else {
            // New format: "Horn Events" at column 17
            metrics.hornEvents = Int(columns[17]) ?? 0
        }
        
        return metrics
    }
    
    private func isDuplicateCommute(_ newCommute: CommuteRecord) -> Bool {
        return commutes.contains { existingCommute in
            existingCommute.type == newCommute.type &&
            abs(existingCommute.startTime.timeIntervalSince(newCommute.startTime)) < 60 && // Within 1 minute
            abs(existingCommute.duration - newCommute.duration) < 60 // Duration within 1 minute
        }
    }
    
    enum ImportError: LocalizedError {
        case invalidFormat(String)
        case parseError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidFormat(let message):
                return "Invalid CSV format: \(message)"
            case .parseError(let message):
                return "Parse error: \(message)"
            }
        }
    }
    
    func exportDetailedGPSData() -> String {
        var csvContent = "Trip ID,Trip Type,Trip Date,Point Index,Timestamp,Latitude,Longitude,Speed (km/h),Accuracy (m)\n"
        
        for commute in commutes.reversed() {
            let tripId = commute.id.uuidString
            let tripType = commute.type.displayName
            let tripDate = commute.formattedDate
            
            for (index, point) in commute.pathPoints.enumerated() {
                let timestamp = CommuteRecord.timeFormatter.string(from: point.timestamp)
                let lat = String(format: "%.6f", point.latitude)
                let lng = String(format: "%.6f", point.longitude)
                let speed = String(format: "%.1f", point.speed)
                let accuracy = String(format: "%.1f", point.accuracy)
                
                csvContent += "\(tripId),\(tripType),\(tripDate),\(index),\(timestamp),\(lat),\(lng),\(speed),\(accuracy)\n"
            }
        }
        
        return csvContent
    }
    
    func exportDrivingEvents() -> String {
        var csvContent = "Trip ID,Trip Type,Trip Date,Event Type,Event Timestamp,Latitude,Longitude,Intensity\n"
        
        for commute in commutes.reversed() {
            let tripId = commute.id.uuidString
            let tripType = commute.type.displayName
            let tripDate = commute.formattedDate
            
            for event in commute.drivingEvents {
                let eventType = event.type.displayName
                let timestamp = CommuteRecord.timeFormatter.string(from: event.timestamp)
                let lat = String(format: "%.6f", event.location.latitude)
                let lng = String(format: "%.6f", event.location.longitude)
                let intensity = String(format: "%.2f", event.intensity)
                
                csvContent += "\(tripId),\(tripType),\(tripDate),\(eventType),\(timestamp),\(lat),\(lng),\(intensity)\n"
            }
        }
        
        return csvContent
    }
    
    func deleteCommute(at offsets: IndexSet) {
        commutes.remove(atOffsets: offsets)
        cachedWeeklyInsights = nil  // Invalidate cache
        saveCommutes()  // Save after deletion
    }
    
    func deleteCommute(commute: CommuteRecord) {
        commutes.removeAll { $0.id == commute.id }
        cachedWeeklyInsights = nil  // Invalidate cache
        saveCommutes()  // Save after deletion
    }
    
    func deleteAllCommutes() {
        commutes.removeAll()
        cachedWeeklyInsights = nil  // Invalidate cache
        saveCommutes()  // Save after deletion
    }
    
    // MARK: - Persistence Methods
    private func saveCommutes() {
        
        // Test each commute individually to find the problematic one
        for (index, commute) in commutes.enumerated() {
            do {
                let testData = try JSONEncoder().encode(commute)
            } catch {
                return // Don't proceed if any commute can't be encoded
            }
        }
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970
            
            let data = try encoder.encode(commutes)
            
            userDefaults.set(data, forKey: commutesKey)
            
            
            // Update sync data size
            syncDataSize = formatBytes(data.count)
            
            // Perform iCloud sync
            userDefaults.synchronize()
            lastSyncTime = Date()
            
        } catch {
            
            // Reset sync properties on error
            syncDataSize = "0 KB"
        }
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        guard bytes >= 0 else { return "0 KB" }
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        
        let result = formatter.string(fromByteCount: Int64(bytes))
        return result.isEmpty ? "0 KB" : result
    }
    
    
    private func loadCommutes() {
        // Extra safety wrapper to prevent any crashes during startup
        defer {
            // Ensure sync data size is always set
            if syncDataSize.isEmpty {
                syncDataSize = "0 KB"
            }
        }
        
        guard let data = userDefaults.data(forKey: commutesKey),
              !data.isEmpty else {
            // Initialize empty sync data size
            syncDataSize = "0 KB"
            commutes = []
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            commutes = try decoder.decode([CommuteRecord].self, from: data)
            
            // Update sync data size safely
            syncDataSize = formatBytes(data.count)
            
            // Set initial sync time if not already set (for existing installations)
            if lastSyncTime == nil {
                lastSyncTime = Date()
            }
            
            
        } catch let DecodingError.keyNotFound(key, context) {
            clearCorruptedData()
        } catch let DecodingError.typeMismatch(type, context) {
            clearCorruptedData()
        } catch let DecodingError.valueNotFound(type, context) {
            clearCorruptedData()
        } catch let DecodingError.dataCorrupted(context) {
            clearCorruptedData()
        } catch {
            clearCorruptedData()
        }
    }
    
    private func clearCorruptedData() {
        // Clear corrupted data from UserDefaults
        userDefaults.removeObject(forKey: commutesKey)
        userDefaults.synchronize()
        
        // Reset to empty state
        commutes = []
        syncDataSize = "0 KB"
        lastSyncTime = nil
        
    }
    
    func clearAllData() {
        
        // Clear all UserDefaults data
        userDefaults.removeObject(forKey: commutesKey)
        
        // Reset all state
        commutes = []
        activeCommute = nil
        currentMetrics = DrivingMetrics()
        currentDrivingEvents = []
        syncDataSize = "0 KB"
        lastSyncTime = nil
        
        // Sync the cleared state to iCloud
        userDefaults.synchronize()
        
    }
    
    // MARK: - Backup and Restore Methods
    func exportAllData() -> Data? {
        let exportData = AppDataExport(
            commutes: commutes,
            settings: AppSettings(
                speedLimitThreshold: settingsManager?.speedLimitThreshold ?? 80.0,
                keepScreenOn: settingsManager?.keepScreenOn ?? true,
                useLocationBasedOrdering: settingsManager?.useLocationBasedOrdering ?? true
            ),
            customTrips: []  // Will be populated from TripManager if needed
        )
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970
            let jsonData = try encoder.encode(exportData)
            
            // Compress the data to reduce file size
            let compressedData = try (jsonData as NSData).compressed(using: .lzfse)
            let compressionRatio = Double(compressedData.count) / Double(jsonData.count)
            
            
            return compressedData as Data
        } catch {
            return nil
        }
    }
    
    func importData(_ data: Data, tripManager: TripManager? = nil) -> Bool {
        
        // Accept both modern and legacy AppDataExport formats with backward compatibility
        return tryModernFormat(data, tripManager: tripManager)
    }
    
    private func tryModernFormat(_ data: Data, tripManager: TripManager? = nil) -> Bool {
        do {
            
            // Try to decompress the data first (for compressed exports)
            var jsonData: Data = data
            do {
                let decompressedData = try (data as NSData).decompressed(using: .lzfse)
                jsonData = decompressedData as Data
            } catch {
                // If decompression fails, assume it's uncompressed data
                jsonData = data
            }
            
            let decoder = JSONDecoder()
            
            // Try multiple date decoding strategies for backward compatibility
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                
                // Try to decode as double (seconds since 1970)
                if let timestamp = try? container.decode(Double.self) {
                    // Check if this looks like milliseconds instead of seconds
                    if timestamp > 1_000_000_000_000 {
                        // This looks like milliseconds, convert to seconds
                        let date = Date(timeIntervalSince1970: timestamp / 1000.0)
                        return date
                    } else {
                        // This looks like seconds
                        let date = Date(timeIntervalSince1970: timestamp)
                        return date
                    }
                }
                
                // Try to decode as string in ISO8601 format
                if let dateString = try? container.decode(String.self) {
                    let isoFormatter = ISO8601DateFormatter()
                    if let date = isoFormatter.date(from: dateString) {
                        return date
                    }
                    
                    // Try other common date formats
                    let commonFormatters: [DateFormatter] = {
                        let formatStrings = [
                            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                            "yyyy-MM-dd'T'HH:mm:ssZ", 
                            "yyyy-MM-dd HH:mm:ss"
                        ]
                        return formatStrings.map { formatString in
                            let formatter = DateFormatter()
                            formatter.dateFormat = formatString
                            return formatter
                        }
                    }()
                    
                    for formatter in commonFormatters {
                        if let date = formatter.date(from: dateString) {
                            return date
                        }
                    }
                }
                
                // Fallback: try default decoding
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date")
            }
            
            let importData = try decoder.decode(AppDataExport.self, from: jsonData)
            
            commutes.append(contentsOf: importData.commutes)
            saveCommutes()
            
            // Import custom trip types if they exist and add them to available types
            if !importData.customTrips.isEmpty, let tripManager = tripManager {
                for customTrip in importData.customTrips {
                    // Check if this custom trip doesn't already exist
                    if !tripManager.availableTrips.contains(where: { $0.id == customTrip.id }) {
                        tripManager.availableTrips.append(customTrip)
                    }
                }
                tripManager.saveTrips()
            }
            
            return true
        } catch {
            return false
        }
    }
    
    
    
    // Analyze path points to identify heavy traffic periods (sustained speeds under 15 km/h for at least 1 minute)
    private func analyzeHeavyTraffic(pathPoints: [LocationPoint]) -> [HeavyTrafficPeriod] {
        guard pathPoints.count >= 2 else { return [] }
        
        var heavyTrafficPeriods: [HeavyTrafficPeriod] = []
        let speedThreshold: Double = 15.0 // km/h
        let minimumDuration: TimeInterval = 60.0 // 1 minute
        
        var slowPeriodStart: Int?
        var slowPeriodSpeeds: [Double] = []
        
        for (index, point) in pathPoints.enumerated() {
            let isSlowSpeed = point.speed < speedThreshold
            
            if isSlowSpeed {
                if slowPeriodStart == nil {
                    // Start of a potential heavy traffic period
                    slowPeriodStart = index
                    slowPeriodSpeeds = [point.speed]
                } else {
                    // Continue tracking the slow period
                    slowPeriodSpeeds.append(point.speed)
                }
            } else {
                // Speed is above threshold, check if we had a slow period
                if let startIndex = slowPeriodStart {
                    let endIndex = index - 1
                    let duration = pathPoints[endIndex].timestamp.timeIntervalSince(pathPoints[startIndex].timestamp)
                    
                    // Only count as heavy traffic if sustained for at least 1 minute
                    if duration >= minimumDuration {
                        let averageSpeed = slowPeriodSpeeds.reduce(0, +) / Double(slowPeriodSpeeds.count)
                        
                        let period = HeavyTrafficPeriod(
                            startTime: pathPoints[startIndex].timestamp,
                            endTime: pathPoints[endIndex].timestamp,
                            startIndex: startIndex,
                            endIndex: endIndex,
                            averageSpeed: averageSpeed,
                            duration: duration
                        )
                        heavyTrafficPeriods.append(period)
                    }
                }
                
                // Reset tracking
                slowPeriodStart = nil
                slowPeriodSpeeds = []
            }
        }
        
        // Handle case where trip ends in heavy traffic
        if let startIndex = slowPeriodStart, !slowPeriodSpeeds.isEmpty {
            let endIndex = pathPoints.count - 1
            let duration = pathPoints[endIndex].timestamp.timeIntervalSince(pathPoints[startIndex].timestamp)
            
            if duration >= minimumDuration {
                let averageSpeed = slowPeriodSpeeds.reduce(0, +) / Double(slowPeriodSpeeds.count)
                
                let period = HeavyTrafficPeriod(
                    startTime: pathPoints[startIndex].timestamp,
                    endTime: pathPoints[endIndex].timestamp,
                    startIndex: startIndex,
                    endIndex: endIndex,
                    averageSpeed: averageSpeed,
                    duration: duration
                )
                heavyTrafficPeriods.append(period)
            }
        }
        
        return heavyTrafficPeriods
    }
    
    // Optimized weekly insights with caching
    func getWeeklyInsights() -> [String: [CommuteRecord]] {
        let now = Date()
        
        // Return cached result if less than 5 minutes old
        if let cached = cachedWeeklyInsights,
           let lastUpdate = lastInsightsUpdate,
           now.timeIntervalSince(lastUpdate) < 300 {  // 5 minutes
            return cached
        }
        
        let calendar = Calendar.current
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        var insights: [String: [CommuteRecord]] = [:]
        
        for commute in commutes {
            let weekday = calendar.weekdaySymbols[calendar.component(.weekday, from: commute.startTime) - 1]
            if weekdays.contains(weekday) {
                insights[weekday, default: []].append(commute)
            }
        }
        
        // Cache the result
        cachedWeeklyInsights = insights
        lastInsightsUpdate = now
        
        return insights
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var commuteTracker = CommuteTracker()
    @StateObject private var sensorManager = SensorManager()
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var tripManager = TripManager()
    @StateObject private var soundAnalysisManager = SoundAnalysisManager()
    @State private var selectedTab = 0
    @State private var isTracking = false
    @State private var trackingDuration: TimeInterval = 0
    @State private var timer: Timer?
    @State private var completedTripId: UUID?
    @State private var showingTripCompletion = false
    @State private var showDeleteAllAlert = false
    @State private var selectedCommuteFilter: CommuteFilterOption = .all
    @State private var showTripEditor = false
    @State private var expandedCommuteIds: Set<UUID> = []
    @State private var showSplashScreen = true
    @State private var showOnboarding = false
    @State private var showDocumentPicker = false
    @State private var showCSVImporter = false
    @State private var isImportingCSV = false
    @State private var importResult: ImportResult?
    @State private var csvImportResult: CSVImportResult?
    @State private var fullScreenMapCommute: CommuteRecord?
    @State private var showDrivingEvents = true
    @State private var visibleEventTypes: Set<DrivingEvent.EventType> = Set(DrivingEvent.EventType.allCases)
    @State private var showOneOffTripSheet = false
    @State private var oneOffTripName = ""
    @State private var showDriveQualityExplanation = false
    @State private var showDepartureTimeExplanation = false
    
    var body: some View {
        if showSplashScreen {
            SplashScreenView()
                .onAppear {
                    initializeApp()
                }
        } else if showOnboarding {
            OnboardingView {
                showOnboarding = false
                UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
            }
        } else {
            ZStack {
                // Liquid glass background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.05),
                        Color.indigo.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                TabView(selection: $selectedTab) {
                    TrackingView()
                        .tabItem {
                            Image(systemName: "location.circle")
                            Text("Track")
                        }
                        .tag(0)
                    
                    HistoryView()
                        .tabItem {
                            Image(systemName: "clock")
                            Text("History")
                        }
                        .tag(1)
                    
                    AnalyticsView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Analytics")
                        }
                        .tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(3)
                }
                .background(.ultraThinMaterial)
            }
        .environmentObject(locationManager)
        .environmentObject(commuteTracker)
        .environmentObject(sensorManager)
        .environmentObject(settingsManager)
        .environmentObject(tripManager)
        .environmentObject(soundAnalysisManager)
        .accentColor(.blue)
        .onAppear {
            locationManager.requestLocationPermission()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // Re-enable screen sleep if app goes to background
            if !isTracking {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            // Clean up when app is terminated
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                
                // Start accessing security-scoped resource
                let hasAccess = url.startAccessingSecurityScopedResource()
                defer {
                    if hasAccess {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                do {
                    
                    let data = try Data(contentsOf: url)
                    
                    handleImportedData(data)
                } catch {
                    importResult = .failure("Failed to read backup file: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                importResult = .failure("Failed to select file: \(error.localizedDescription)")
            }
        }
        .fileImporter(
            isPresented: $showCSVImporter,
            allowedContentTypes: [.plainText, .text],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                
                // Start accessing security-scoped resource
                let hasAccess = url.startAccessingSecurityScopedResource()
                defer {
                    if hasAccess {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                do {
                    
                    // Try different encodings if UTF-8 fails
                    var csvContent: String
                    if let utf8Content = try? String(contentsOf: url, encoding: .utf8) {
                        csvContent = utf8Content
                    } else if let asciiContent = try? String(contentsOf: url, encoding: .ascii) {
                        csvContent = asciiContent
                    } else {
                        throw NSError(domain: "CSVImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not read file with UTF-8 or ASCII encoding"])
                    }
                    
                    
                    let importedCount = try commuteTracker.importFromCSV(csvContent)
                    
                    DispatchQueue.main.async {
                        csvImportResult = .success(importedCount)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        csvImportResult = .failure("Failed to import CSV: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                csvImportResult = .failure("Failed to select CSV file: \(error.localizedDescription)")
            }
        }
        .alert("CSV Import Result", isPresented: .constant(csvImportResult != nil)) {
            Button("OK") {
                csvImportResult = nil
            }
        } message: {
            if let result = csvImportResult {
                switch result {
                case .success(let count):
                    Text("Successfully imported \(count) commute record\(count == 1 ? "" : "s")")
                case .failure(let error):
                    Text(error)
                }
            }
        }
        .alert("Import Result", isPresented: .constant(importResult != nil)) {
            Button("OK") {
                importResult = nil
            }
        } message: {
            if let result = importResult {
                switch result {
                case .success(let message):
                    Text(message)
                case .failure(let error):
                    Text(error)
                }
            }
        }
        .sheet(item: $fullScreenMapCommute, onDismiss: {
            // Clean up is automatic with item-based sheet
        }) { commute in
            FullScreenMapView(commute: commute)
        }
        .sheet(isPresented: $showDriveQualityExplanation) {
            DriveQualityExplanationView()
        }
        .sheet(isPresented: $showDepartureTimeExplanation) {
            DepartureTimeExplanationView()
        }
        .overlay(
            Group {
                if showingTripCompletion {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.primary))
                            
                            Text("Saving Trip...")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.text)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: showingTripCompletion)
                }
            }
        )
        }
    }
    
    // MARK: - App Initialization
    private func initializeApp() {
        // Start GPS location fetching immediately
        locationManager.requestLocationPermission()
        
        // Hide splash screen after 2 seconds and check if onboarding is needed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplashScreen = false
                // Check if user has seen onboarding
                let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
                if !hasSeenOnboarding {
                    showOnboarding = true
                }
            }
        }
    }
    
    // MARK: - Tracking View
    func TrackingView() -> some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: DesignSystem.Spacing.lg) {
                    if isTracking {
                        StatusCard()
                        LiveMetricsCard()
                        
                        if !sensorManager.isMotionAvailable {
                            SensorWarningCard()
                        }
                        
                        Button(action: {
                            stopTracking()
                        }) {
                            HStack {
                                Image(systemName: "stop.fill")
                                    .font(.headline)
                                
                                Text("Stop Commute")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                    } else {
                        VStack(spacing: 20) {
                            // One-Off Trip Section
                            VStack(spacing: 12) {
                                Button(action: {
                                    showOneOffTripSheet = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("One-Off Trip")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .fontWeight(.medium)
                                            
                                            Text("Create a one-time trip")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.orange.opacity(0.8))
                                    .cornerRadius(12)
                                    .contentShape(Rectangle())
                                }
                            }
                            
                            // My Commutes Section
                            VStack(spacing: 15) {
                                HStack {
                                    Text("My Commutes")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(DesignSystem.Colors.text)
                                    
                                    Spacer()
                                    
                                    Button("Edit") {
                                        showTripEditor = true
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                }
                                .padding(.horizontal, 4)
                                
                                // Smart ordering indicator
                                if settingsManager.useLocationBasedOrdering && 
                                   !commuteTracker.commutes.isEmpty && 
                                   locationManager.currentLocation != nil {
                                    Label {
                                        Text("Ordered by location relevance")
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundColor(DesignSystem.Colors.secondaryText)
                                    } icon: {
                                        Image(systemName: "location.fill")
                                            .font(.caption)
                                            .foregroundColor(DesignSystem.Colors.primary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 4)
                                }
                                
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    ForEach(Array(getSmartOrderedTrips().enumerated()), id: \.element.id) { index, trip in
                                        Button(action: {
                                            startTracking(trip)
                                        }) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(trip.displayName)
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                        .fontWeight(.medium)
                                                    
                                                    Text("Tap to start tracking")
                                                        .font(.caption)
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "play.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.white.opacity(0.9))
                                            }
                                            .padding(16)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(tripButtonColor(for: index))
                                            .cornerRadius(12)
                                            .contentShape(Rectangle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(DesignSystem.Spacing.md)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Track")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showTripEditor) {
                TripEditorView()
                    .environmentObject(tripManager)
                    .environmentObject(commuteTracker)
            }
            .sheet(isPresented: $showOneOffTripSheet) {
                OneOffTripSheet(
                    tripName: $oneOffTripName,
                    onStart: { name in
                        let oneOffTrip = tripManager.createOneOffTrip(name: name)
                        startTracking(oneOffTrip)
                        showOneOffTripSheet = false
                        oneOffTripName = ""
                    },
                    onCancel: {
                        showOneOffTripSheet = false
                        oneOffTripName = ""
                    }
                )
            }
        }
    }
    
    // MARK: - One-Off Trip Sheet
    struct OneOffTripSheet: View {
        @Binding var tripName: String
        let onStart: (String) -> Void
        let onCancel: () -> Void
        
        var body: some View {
            NavigationView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Custom Trip")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Enter a name for your one-time trip. This won't be saved to your regular trips list.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Trip Name")
                            .font(.headline)
                        
                        TextField("e.g., Airport Trip, Friend's House", text: $tripName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .submitLabel(.done)
                            .onSubmit {
                                if !tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    onStart(tripName.trimmingCharacters(in: .whitespacesAndNewlines))
                                }
                            }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            let trimmedName = tripName.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmedName.isEmpty {
                                onStart(trimmedName)
                            }
                        }) {
                            HStack {
                                Image(systemName: "play.circle.fill")
                                Text("Start Trip")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.green)
                            .cornerRadius(12)
                        }
                        .disabled(tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        
                        Button("Cancel") {
                            onCancel()
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
                .navigationTitle("Custom Trip")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func tripButtonColor(for index: Int) -> Color {
        let colors: [Color] = [.green, .blue, .orange, .purple, .pink, .indigo, .teal, .mint]
        return colors[index % colors.count]
    }
    
    func StatusCard() -> some View {
        CardView {
            if isTracking, let active = commuteTracker.activeCommute {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text(active.type.displayName)
                                .font(DesignSystem.Typography.title2)
                                .foregroundColor(DesignSystem.Colors.text)
                            
                            Text("Active Trip")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                            Text(formatDuration(trackingDuration))
                                .font(DesignSystem.Typography.title3)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .fontWeight(.bold)
                            
                            HStack(spacing: DesignSystem.Spacing.xs) {
                                Circle()
                                    .fill(DesignSystem.Colors.success)
                                    .frame(width: 8, height: 8)
                                    .opacity(0.8)
                                
                                Text("LIVE")
                                    .font(DesignSystem.Typography.caption2)
                                    .foregroundColor(DesignSystem.Colors.success)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    
                    if locationManager.currentSpeed > 0 {
                        Divider()
                            .background(DesignSystem.Colors.borderColor)
                        
                        HStack {
                            Label {
                                Text("\(Int(locationManager.currentSpeed)) km/h")
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.text)
                                    .fontWeight(.semibold)
                            } icon: {
                                Image(systemName: "speedometer")
                                    .foregroundColor(DesignSystem.Colors.accent)
                            }
                            
                            Spacer()
                            
                            if commuteTracker.currentMetrics.slowTrafficTime > 0 {
                                Label {
                                    Text(formatDuration(commuteTracker.currentMetrics.slowTrafficTime))
                                        .font(DesignSystem.Typography.callout)
                                        .foregroundColor(DesignSystem.Colors.warning)
                                        .fontWeight(.medium)
                                } icon: {
                                    Image(systemName: "tortoise.fill")
                                        .foregroundColor(DesignSystem.Colors.warning)
                                }
                            }
                        }
                        
                        // Phone orientation information
                        if sensorManager.vehicleOrientation != .unknown {
                            Divider()
                                .background(DesignSystem.Colors.borderColor)
                            
                            HStack {
                                Text(sensorManager.getOrientationDescription())
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(DesignSystem.Colors.secondaryText)
                                
                                Spacer()
                                
                                Text("Sensor calibrated")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(DesignSystem.Colors.success)
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: DesignSystem.Spacing.md) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 40))
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                    
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text("Ready to Track")
                            .font(DesignSystem.Typography.title3)
                            .foregroundColor(DesignSystem.Colors.text)
                        
                        Text("Select a trip below to start")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.md)
            }
        }
    }
    
    func LiveMetricsCard() -> some View {
        CardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text("Driving Metrics")
                            .font(DesignSystem.Typography.title2)
                            .foregroundColor(DesignSystem.Colors.text)
                        
                        Text(commuteTracker.currentMetrics.qualityDescription)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text("\(commuteTracker.currentMetrics.drivingScore)")
                            .font(DesignSystem.Typography.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text("SCORE")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(.white.opacity(0.8))
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.md)
                    .padding(.vertical, DesignSystem.Spacing.sm)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                            .fill(scoreColor(commuteTracker.currentMetrics.drivingScore))
                            .shadow(color: scoreColor(commuteTracker.currentMetrics.drivingScore).opacity(0.3), radius: 4, x: 0, y: 2)
                    )
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignSystem.Spacing.md) {
                    MetricTile(title: "Braking Events", value: "\(commuteTracker.currentMetrics.brakingEventCount)", color: DesignSystem.Colors.error)
                    MetricTile(title: "Sharp Turns", value: "\(commuteTracker.currentMetrics.sharpTurns)", color: DesignSystem.Colors.warning)
                    MetricTile(title: "Accelerations", value: "\(commuteTracker.currentMetrics.accelerationEvents)", color: DesignSystem.Colors.accent)
                    MetricTile(title: "Phone Use", value: "\(commuteTracker.currentMetrics.phoneDistractions)", color: DesignSystem.Colors.error)
                    MetricTile(title: "Horns", value: "\(commuteTracker.currentMetrics.hornEvents)", color: DesignSystem.Colors.primary)
                    MetricTile(title: "Sirens", value: "\(commuteTracker.currentMetrics.sirenEvents)", color: DesignSystem.Colors.accent)
                    MetricTile(title: "Rough Roads", value: "\(commuteTracker.currentMetrics.roughRoadEvents)", color: DesignSystem.Colors.speedSlow)
                    MetricTile(title: "Speed Violations", value: "\(commuteTracker.currentMetrics.speedViolations)", color: DesignSystem.Colors.speedVeryFast)
                }
                
                SlowTrafficTimer(commuteTracker: commuteTracker)
                
                if locationManager.totalDistance > 0 {
                    Divider()
                        .background(DesignSystem.Colors.borderColor)
                    
                    HStack {
                        Label {
                            Text("\(String(format: "%.1f", locationManager.totalDistance/1000)) km")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.text)
                                .fontWeight(.semibold)
                        } icon: {
                            Image(systemName: "map")
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    func MetricTile(title: String, value: String, color: Color) -> some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Text(value)
                .font(DesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    func SlowTrafficTimer(commuteTracker: CommuteTracker) -> some View {
        HStack(spacing: 12) {
            // Current slow traffic status indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(commuteTracker.isCurrentlyInSlowTraffic ? Color.red : Color.green)
                    .frame(width: 8, height: 8)
                
                Text(commuteTracker.isCurrentlyInSlowTraffic ? "In Slow Traffic" : "Normal Speed")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(commuteTracker.isCurrentlyInSlowTraffic ? .red : .green)
            }
            
            Spacer()
            
            // Total slow traffic time
            VStack(alignment: .trailing, spacing: 2) {
                Text("Slow Traffic Time")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(formatSlowTrafficTime(commuteTracker.currentMetrics.slowTrafficTime, commuteTracker.slowTrafficStartTime))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private func formatSlowTrafficTime(_ totalTime: TimeInterval, _ currentStartTime: Date?) -> String {
        var displayTime = totalTime
        
        // Add current slow traffic session if ongoing
        if let startTime = currentStartTime {
            displayTime += Date().timeIntervalSince(startTime)
        }
        
        let minutes = Int(displayTime / 60)
        let seconds = Int(displayTime.truncatingRemainder(dividingBy: 60))
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    private func formatSlowTrafficDisplayTime(_ slowTrafficTime: TimeInterval, totalTripDuration: TimeInterval) -> String {
        let minutes = Int(slowTrafficTime / 60)
        let seconds = Int(slowTrafficTime.truncatingRemainder(dividingBy: 60))
        
        // Calculate percentage of trip spent in slow traffic
        let percentage = totalTripDuration > 0 ? (slowTrafficTime / totalTripDuration) * 100 : 0
        
        var timeString: String
        if minutes > 0 {
            timeString = "\(minutes)m \(seconds)s"
        } else {
            timeString = "\(seconds)s"
        }
        
        return "\(timeString) (\(Int(percentage))% of trip)"
    }
    
    func SensorWarningCard() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.title2)
            
            Text("Limited Sensor Access")
                .font(.headline)
                .foregroundColor(.orange)
            
            Text("Some motion sensors are not available. Driving metrics may be limited.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func scoreColor(_ score: Int) -> Color {
        switch score {
        case 90...100: return .green
        case 80...89: return .blue
        case 70...79: return .orange
        default: return .red
        }
    }
    
    private func startTracking(_ type: CommuteType) {
        
        // Safety checks before starting
        guard !isTracking else {
            return
        }
        
        // CORE TRIP FUNCTIONALITY - Always start these first
        isTracking = true
        trackingDuration = 0
        
        // Start commute tracking (core functionality)
        commuteTracker.startCommute(type: type, sensorManager: sensorManager, locationManager: locationManager, settingsManager: settingsManager)
        
        // Start duration timer (essential for trip tracking)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = commuteTracker.activeCommute?.startTime {
                trackingDuration = Date().timeIntervalSince(startTime)
            }
        }
        
        // OPTIONAL SENSOR FUNCTIONALITY - Handle failures gracefully
        
        // Start location updates only if GPS is enabled
        if settingsManager.enableGPS {
            locationManager.startLocationUpdates()
        } else {
        }
        
        // Start motion sensors only if enabled
        if settingsManager.enableMotionSensors {
            sensorManager.startSensorUpdates()
            if sensorManager.isMotionAvailable {
            } else {
            }
        } else {
        }
        
        // Start sound analysis only if microphone is enabled
        if settingsManager.enableMicrophone {
            soundAnalysisManager.startListening()
            setupSoundEventCallbacks()
        } else {
        }
        
        // Keep screen on during active trip
        if settingsManager.keepScreenOn {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        
        if locationManager.authorizationStatus != .authorizedWhenInUse && locationManager.authorizationStatus != .authorizedAlways {
        }
        if !sensorManager.isMotionAvailable {
        }
    }
    
    private func setupSoundEventCallbacks() {
        soundAnalysisManager.onCarHornDetected = {
            guard let location = locationManager.currentLocation else { return }
            
            // Add horn event to active commute
            let event = DrivingEvent(
                type: .horn,
                location: location,
                intensity: 1.0,
                timestamp: Date()
            )
            
            commuteTracker.addDrivingEvent(event)
        }
        
        soundAnalysisManager.onSirenDetected = {
            guard let location = locationManager.currentLocation else { return }
            
            // Add siren event to active commute
            let event = DrivingEvent(
                type: .siren,
                location: location,
                intensity: 1.0,
                timestamp: Date()
            )
            
            commuteTracker.addDrivingEvent(event)
        }
    }
    
    private func stopTracking() {
        isTracking = false
        trackingDuration = 0
        timer?.invalidate()
        timer = nil
        
        // Re-enable screen sleep when trip ends
        UIApplication.shared.isIdleTimerDisabled = false
        
        
        commuteTracker.stopCommute { [self] completedTripId in
            // Store the completed trip ID and navigate to history
            self.completedTripId = completedTripId
            self.showingTripCompletion = true
            
            // Add a small delay for loading state, then navigate
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedTab = 1 // Navigate to History tab
                self.expandedCommuteIds = [completedTripId] // Expand the completed trip
                self.showingTripCompletion = false
            }
        }
        sensorManager.stopSensorUpdates()
        soundAnalysisManager.stopListening()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let totalSeconds = Int(duration)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // MARK: - Data Management Helper Functions
    private func shareData(_ data: Data, filename: String) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: tempURL)
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        } catch {
        }
    }
    
    private func handleImportedData(_ data: Data) {
        
        // Try to peek at the data structure
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let preview = String(jsonString.prefix(200))
        }
        
        if commuteTracker.importData(data, tripManager: tripManager) {
            importResult = .success("Successfully imported \(commuteTracker.commutes.count) trips and settings")
        } else {
            importResult = .failure("Failed to import backup file. Please check the file format.")
        }
    }
    
    // Helper function to build commute row ID
    private func buildCommuteRowId(for commute: CommuteRecord) -> String {
        let tripCount = tripManager.availableTrips.count
        let tripNames = tripManager.availableTrips.map { $0.displayName }.joined()
        return "\(commute.id.uuidString)-\(tripCount)-\(tripNames)"
    }
    
    // MARK: - History View
    func HistoryView() -> some View {
        NavigationView {
            Group {
                if commuteTracker.commutes.isEmpty {
                    EmptyStateView(
                        icon: "clock.arrow.circlepath",
                        title: "No Commutes Yet",
                        message: "Start tracking your commutes to see them here with detailed maps and analytics."
                    )
                } else {
                    List {
                        ForEach(commuteTracker.commutes, id: \.id) { commute in
                            let rowId = buildCommuteRowId(for: commute)
                            CommuteRow(commute: commute)
                                .id(rowId)
                                .listRowBackground(DesignSystem.Colors.cardBackground)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: DesignSystem.Spacing.xs, leading: DesignSystem.Spacing.md, bottom: DesignSystem.Spacing.xs, trailing: DesignSystem.Spacing.md))
                        }
                        .onDelete(perform: deleteCommutes)
                    }
                    .listStyle(.plain)
                    .background(DesignSystem.Colors.background)
                }
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !commuteTracker.commutes.isEmpty {
                        Menu {
                            ShareLink("Export Summary", item: createCSVFile())
                            
                            Button(role: .destructive) {
                                showDeleteAllAlert = true
                            } label: {
                                Label("Delete All", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(DesignSystem.Colors.primary)
                        }
                    }
                }
            }
            .alert("Delete All Trips", isPresented: $showDeleteAllAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete All", role: .destructive) {
                    commuteTracker.deleteAllCommutes()
                }
            } message: {
                Text("This will permanently delete all your commute history. This action cannot be undone.")
            }
        }
    }
    
    private func deleteCommutes(at offsets: IndexSet) {
        commuteTracker.deleteCommute(at: offsets)
    }
    
    
    func CommuteRow(commute: CommuteRecord) -> some View {
        // Force refresh when tripManager changes by using @ObservedObject
        let tripDisplayName = tripManager.availableTrips.first(where: { $0.id == commute.type.id })?.displayName ?? commute.type.displayName
        let isExpanded = expandedCommuteIds.contains(commute.id)
        
        return LegacyCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                        Text(tripDisplayName)
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.text)
                        
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                            
                            Text(commute.formattedDate)
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xs) {
                        HStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "clock")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text(commute.formattedDuration)
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .fontWeight(.semibold)
                        }
                        
                        Text(commute.formattedStartTime)
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if isExpanded {
                                // Collapse this trip
                                expandedCommuteIds.remove(commute.id)
                            } else {
                                // Collapse all other trips and expand this one
                                expandedCommuteIds.removeAll()
                                expandedCommuteIds.insert(commute.id)
                            }
                        }
                    }) {
                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.title3)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
                    }
                    .buttonStyle(.plain)
                }
                
                
                if isExpanded {
                    Divider()
                        .background(DesignSystem.Colors.borderColor)
                    
                    // Full driving metrics in expanded state
                    DrivingSummaryBar(metrics: commute.drivingMetrics)
                    
                    TripDetailView(commute: commute)
                        .id("expanded-\(commute.id)")
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .offset(y: -10)),
                            removal: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .offset(y: 10))
                        ))
                }
            }
        }
        .id("commute-row-\(commute.id)-\(isExpanded)")
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isExpanded)
    }
    
    private func getTripIcon(for tripId: String) -> String {
        // No longer showing icons in history
        return ""
    }
    
    func DrivingSummaryBar(metrics: DrivingMetrics) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                    Text("Driving Quality")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                    
                    Text(metrics.qualityDescription)
                        .font(DesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(scoreColor(metrics.drivingScore))
                }
                
                Spacer()
                
                HStack(spacing: DesignSystem.Spacing.xs) {
                    Text("\(metrics.drivingScore)")
                        .font(DesignSystem.Typography.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("/100")
                        .font(DesignSystem.Typography.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, DesignSystem.Spacing.sm)
                .padding(.vertical, DesignSystem.Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                        .fill(scoreColor(metrics.drivingScore))
                )
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: DesignSystem.Spacing.sm) {
                CompactMetric(icon: "exclamationmark.triangle.fill", value: "\(metrics.brakingEventCount)", color: DesignSystem.Colors.error, title: "Braking")
                CompactMetric(icon: "arrow.triangle.turn.up.right.circle", value: "\(metrics.sharpTurns)", color: DesignSystem.Colors.warning, title: "Turns")
                CompactMetric(icon: "forward.fill", value: "\(metrics.accelerationEvents)", color: DesignSystem.Colors.accent, title: "Accel")
                CompactMetric(icon: "iphone", value: "\(metrics.phoneDistractions)", color: DesignSystem.Colors.error, title: "Phone")
                CompactMetric(icon: "road.lanes", value: "\(metrics.roughRoadEvents)", color: DesignSystem.Colors.speedSlow, title: "Rough")
                CompactMetric(icon: "speedometer", value: "\(metrics.speedViolations)", color: DesignSystem.Colors.speedVeryFast, title: "Speed")
                CompactMetric(icon: "speaker.wave.3.fill", value: "\(metrics.hornEvents)", color: DesignSystem.Colors.primary, title: "Horns")
                CompactMetric(icon: "music.note", value: "\(metrics.sirenEvents)", color: DesignSystem.Colors.accent, title: "Sirens")
            }
            
            if metrics.maxSpeed > 0 || metrics.totalDistance > 0 {
                HStack(spacing: DesignSystem.Spacing.lg) {
                    if metrics.maxSpeed > 0 {
                        Label {
                            Text("\(Int(metrics.maxSpeed)) km/h")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        } icon: {
                            Image(systemName: "speedometer")
                                .font(.caption2)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                    }
                    
                    Spacer()
                    
                    if metrics.totalDistance > 0 {
                        Label {
                            Text("\(String(format: "%.1f", metrics.totalDistance/1000)) km")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        } icon: {
                            Image(systemName: "map")
                                .font(.caption2)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                    }
                }
            }
        }
        .padding(DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                .fill(DesignSystem.Colors.background.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                        .stroke(DesignSystem.Colors.borderColor, lineWidth: 0.5)
                )
        )
    }
    
    func CompactMetric(icon: String, value: String, color: Color, title: String? = nil) -> some View {
        VStack(spacing: DesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(DesignSystem.Typography.caption)
                .fontWeight(.bold)
                .foregroundColor(DesignSystem.Colors.text)
            
            if let title = title {
                Text(title)
                    .font(.system(size: 9))
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.xs)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                .fill(color.opacity(0.1))
        )
    }
    
    // MARK: - Analytics View
    func AnalyticsView() -> some View {
        // Create a safe copy of commutes to prevent memory access issues
        let commutesSnapshot = Array(commuteTracker.commutes)
        let filteredCommutes = commutesSnapshot.filter { selectedCommuteFilter.matches($0.type) }
        
        return NavigationView {
            AnalyticsContent(filteredCommutes: filteredCommutes)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AnalyticsFilterMenu()
                    }
                }
        }
    }
    
    private func AnalyticsContent(filteredCommutes: [CommuteRecord]) -> some View {
        Group {
            if commuteTracker.commutes.isEmpty {
                EmptyStateView(
                    icon: "chart.bar.xaxis",
                    title: "No Analytics Yet",
                    message: "Complete a few commutes to see your patterns and get personalized recommendations."
                )
            } else {
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: DesignSystem.Spacing.lg) {
                            if filteredCommutes.isEmpty {
                                EmptyStateView(
                                    icon: "line.3.horizontal.decrease.circle",
                                    title: "No Data for Filter",
                                    message: "Try selecting a different commute type to see analytics."
                                )
                                .padding(.top, DesignSystem.Spacing.xxl)
                            } else {
                                // Ensure filteredCommutes is safe to access
                                let safeFilteredCommutes = Array(filteredCommutes)
                                
                                OverallStats(filteredCommutes: safeFilteredCommutes)
                                TrafficAnalysisInsights(filteredCommutes: safeFilteredCommutes)
                                DriveQualityInsights(filteredCommutes: safeFilteredCommutes)
                                WeeklyInsights(filteredCommutes: safeFilteredCommutes)
                            }
                        }
                        .padding(DesignSystem.Spacing.md)
                    }
                    .background(DesignSystem.Colors.background)
                }
            }
        }
        .background(DesignSystem.Colors.background)
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func AnalyticsFilterMenu() -> some View {
        Group {
            if !commuteTracker.commutes.isEmpty {
                Menu {
                    ForEach(tripManager.filterOptions(withCommutes: commuteTracker.commutes), id: \.id) { option in
                        Button(action: {
                            selectedCommuteFilter = option
                        }) {
                            HStack {
                                Text(option.displayName)
                                if selectedCommuteFilter.id == option.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedCommuteFilter.displayName)
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.primary)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                }
            }
        }
    }
    
    func EmptyAnalyticsView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Analytics Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Complete a few commutes to see your patterns and get personalized recommendations")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    func CommuteFilterPicker() -> some View {
        HStack {
            Text("Filter:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Menu {
                ForEach(tripManager.filterOptions(withCommutes: commuteTracker.commutes), id: \.id) { option in
                    Button(action: {
                        selectedCommuteFilter = option
                    }) {
                        HStack {
                            Text(option.displayName)
                            if selectedCommuteFilter.id == option.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedCommuteFilter.displayName)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
    
    func FilteredEmptyView() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No \(selectedCommuteFilter.displayName) Data")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("You haven't completed any trips of this type yet. Try a different filter or complete more commutes.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
    
    func OverallStats(filteredCommutes: [CommuteRecord]) -> some View {
        // Guard against empty or invalid input
        guard !filteredCommutes.isEmpty else {
            return AnyView(
                Text("No data available")
                    .foregroundColor(.secondary)
                    .padding()
            )
        }
        
        // Safely compute statistics with extensive error handling
        var safeCommutes: [CommuteRecord] = []
        
        for commute in filteredCommutes {
            // Validate each commute before including it
            guard commute.duration > 0 && commute.duration.isFinite else {
                continue
            }
            
            safeCommutes.append(commute)
        }
        
        // If no valid commutes after filtering, return empty state
        guard !safeCommutes.isEmpty else {
            return AnyView(
                Text("No valid trip data")
                    .foregroundColor(.secondary)
                    .padding()
            )
        }
        
        let totalCommutes = safeCommutes.count
        
        // Calculate totals with comprehensive error checking
        var totalDuration: TimeInterval = 0
        var totalDrivingScore: Int = 0
        var totalBrakingEvents: Int = 0
        var totalAccelerationEvents: Int = 0
        var totalPhoneDistractions: Int = 0
        var totalHorns: Int = 0
        var totalSirens: Int = 0
        var totalSlowTrafficTime: TimeInterval = 0
        
        for commute in safeCommutes {
            // Safely access each property with validation
            let duration = commute.duration
            if duration.isFinite && duration >= 0 {
                totalDuration += duration
            }
            
            let score = commute.drivingMetrics.drivingScore
            if score >= 0 && score <= 100 {
                totalDrivingScore += score
            }
            
            totalBrakingEvents += max(0, commute.drivingMetrics.brakingEventCount)
            totalAccelerationEvents += max(0, commute.drivingMetrics.accelerationEvents)
            totalPhoneDistractions += max(0, commute.drivingMetrics.phoneDistractions)
            totalHorns += max(0, commute.drivingMetrics.hornEvents)
            totalSirens += max(0, commute.drivingMetrics.sirenEvents)
            
            let slowTraffic = commute.drivingMetrics.slowTrafficTime
            if slowTraffic.isFinite && slowTraffic >= 0 {
                totalSlowTrafficTime += slowTraffic
            }
        }
        
        // Calculate averages with division by zero protection
        let count = Double(safeCommutes.count)
        let averageDuration = count > 0 ? totalDuration / count / 60.0 : 0
        let averageDrivingScore = count > 0 ? totalDrivingScore / safeCommutes.count : 0
        let averageBrakingEvents = count > 0 ? Double(totalBrakingEvents) / count : 0
        let averageAccelerationEvents = count > 0 ? Double(totalAccelerationEvents) / count : 0
        let averagePhoneDistractions = count > 0 ? Double(totalPhoneDistractions) / count : 0
        let averageHorns = count > 0 ? Double(totalHorns) / count : 0
        let averageSirens = count > 0 ? Double(totalSirens) / count : 0
        let averageSlowTrafficTime = count > 0 ? totalSlowTrafficTime / count / 60.0 : 0
        
        return AnyView(CardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Overview")
                            .font(DesignSystem.Typography.headline)
                            .foregroundColor(DesignSystem.Colors.text)
                        
                        Text("\(totalCommutes) commute\(totalCommutes == 1 ? "" : "s")")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    
                    Spacer()
                    
                    CompactStatItem(
                        title: "Score", 
                        value: "\(averageDrivingScore)", 
                        color: scoreColor(averageDrivingScore),
                        icon: "star.fill"
                    )
                }
                
                HStack(spacing: DesignSystem.Spacing.lg) {
                    CompactStatItem(
                        title: "Duration", 
                        value: "\(Int(averageDuration))m", 
                        color: DesignSystem.Colors.success,
                        icon: "clock"
                    )
                    
                    CompactStatItem(
                        title: "Traffic", 
                        value: "\(Int(averageSlowTrafficTime))m", 
                        color: DesignSystem.Colors.warning,
                        icon: "tortoise"
                    )
                    
                    Spacer()
                }
                
                // Individual event metrics in compact rows
                if averageBrakingEvents > 0 || averageAccelerationEvents > 0 || averagePhoneDistractions > 0 || averageHorns > 0 || averageSirens > 0 {
                    HStack(spacing: DesignSystem.Spacing.md) {
                        if averageBrakingEvents > 0 {
                            CompactStatItem(
                                title: "Braking", 
                                value: String(format: "%.1f", averageBrakingEvents), 
                                color: DesignSystem.Colors.error,
                                icon: "exclamationmark.triangle.fill"
                            )
                        }
                        
                        if averageAccelerationEvents > 0 {
                            CompactStatItem(
                                title: "Acceleration", 
                                value: String(format: "%.1f", averageAccelerationEvents), 
                                color: DesignSystem.Colors.accent,
                                icon: "forward.fill"
                            )
                        }
                        
                        if averagePhoneDistractions > 0 {
                            CompactStatItem(
                                title: "Phone Use", 
                                value: String(format: "%.1f", averagePhoneDistractions), 
                                color: DesignSystem.Colors.error,
                                icon: "iphone"
                            )
                        }
                        
                        Spacer()
                    }
                    
                    if averageHorns > 0 || averageSirens > 0 {
                        HStack(spacing: DesignSystem.Spacing.md) {
                            if averageHorns > 0 {
                                CompactStatItem(
                                    title: "Horns", 
                                    value: String(format: "%.1f", averageHorns), 
                                    color: DesignSystem.Colors.primary,
                                    icon: "speaker.wave.3.fill"
                                )
                            }
                            
                            if averageSirens > 0 {
                                CompactStatItem(
                                    title: "Sirens", 
                                    value: String(format: "%.1f", averageSirens), 
                                    color: DesignSystem.Colors.accent,
                                    icon: "music.note"
                                )
                            }
                            
                            Spacer()
                        }
                    }
                }
                
                if averageBrakingEvents > 0 || averageSlowTrafficTime > 0 || averageAccelerationEvents > 0 || averagePhoneDistractions > 0 || averageHorns > 0 || averageSirens > 0 {
                    Divider()
                        .background(DesignSystem.Colors.borderColor)
                    
                    DrivingEventsChart(filteredCommutes: safeCommutes)
                }
            }
        })
    }
    
    func TrafficAnalysisInsights(filteredCommutes: [CommuteRecord]) -> some View {
        let bestTrafficCommute = filteredCommutes.min { $0.drivingMetrics.slowTrafficTime < $1.drivingMetrics.slowTrafficTime }
        let worstTrafficCommute = filteredCommutes.max { $0.drivingMetrics.slowTrafficTime < $1.drivingMetrics.slowTrafficTime }
        let averageTrafficPercentage = calculateAverageTrafficPercentage(filteredCommutes)
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Traffic Analysis")
                .font(.title2)
                .fontWeight(.bold)
            
            // Traffic percentage overview
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Average Traffic Impact")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("\(String(format: "%.1f", averageTrafficPercentage))% of trip time")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(trafficPercentageColor(averageTrafficPercentage))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Traffic Level")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(trafficLevelDescription(averageTrafficPercentage))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(trafficPercentageColor(averageTrafficPercentage))
                }
            }
            .padding()
            .background(trafficPercentageColor(averageTrafficPercentage).opacity(0.1))
            .cornerRadius(12)
            
            // Traffic Trends Chart
            TrafficAnalysisChart(filteredCommutes: filteredCommutes)
            
            // Best vs Worst traffic comparison
            if let bestCommute = bestTrafficCommute, let worstCommute = worstTrafficCommute, 
               bestCommute.id != worstCommute.id {
                VStack(spacing: 12) {
                    TrafficComparisonRow(
                        title: "Best Traffic Day",
                        slowTrafficTime: bestCommute.drivingMetrics.slowTrafficTime,
                        tripDuration: bestCommute.duration,
                        date: bestCommute.formattedDate,
                        color: .green
                    )
                    
                    TrafficComparisonRow(
                        title: "Worst Traffic Day",
                        slowTrafficTime: worstCommute.drivingMetrics.slowTrafficTime,
                        tripDuration: worstCommute.duration,
                        date: worstCommute.formattedDate,
                        color: .red
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.md)
        .shadow(radius: 2)
    }
    
    func DriveQualityInsights(filteredCommutes: [CommuteRecord]) -> some View {
        let bestCommute = filteredCommutes.max { $0.drivingMetrics.drivingScore < $1.drivingMetrics.drivingScore }
        let worstCommute = filteredCommutes.min { $0.drivingMetrics.drivingScore < $1.drivingMetrics.drivingScore }
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Drive Quality Insights")
                .font(.title2)
                .fontWeight(.bold)
            
            if let best = bestCommute, let worst = worstCommute, best.id != worst.id {
                VStack(spacing: 12) {
                    QualityComparisonRow(
                        title: "Best Drive",
                        score: best.drivingMetrics.drivingScore,
                        quality: best.drivingMetrics.qualityDescription,
                        date: best.formattedDate,
                        color: .green
                    )
                    
                    QualityComparisonRow(
                        title: "Needs Improvement",
                        score: worst.drivingMetrics.drivingScore,
                        quality: worst.drivingMetrics.qualityDescription,
                        date: worst.formattedDate,
                        color: .red
                    )
                }
            }
            
            DrivingTrendsChart(filteredCommutes: filteredCommutes)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.md)
        .shadow(radius: 2)
    }
    
    func QualityComparisonRow(title: String, score: Int, quality: String, date: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(score)/100")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Text(quality)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    func TrafficComparisonRow(title: String, slowTrafficTime: TimeInterval, tripDuration: TimeInterval, date: String, color: Color) -> some View {
        let trafficMinutes = Int(slowTrafficTime / 60)
        let trafficSeconds = Int(slowTrafficTime.truncatingRemainder(dividingBy: 60))
        let trafficPercentage = tripDuration > 0 ? (slowTrafficTime / tripDuration) * 100 : 0
        
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(trafficMinutes > 0 ? "\(trafficMinutes)m \(trafficSeconds)s" : "\(trafficSeconds)s")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                Text("\(String(format: "%.1f", trafficPercentage))% of trip")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    
    private func calculateAverageTrafficPercentage(_ commutes: [CommuteRecord]) -> Double {
        guard !commutes.isEmpty else { return 0 }
        
        let totalPercentage = commutes.reduce(0.0) { total, commute in
            let percentage = commute.duration > 0 ? (commute.drivingMetrics.slowTrafficTime / commute.duration) * 100 : 0
            return total + percentage
        }
        
        return totalPercentage / Double(commutes.count)
    }
    
    private func trafficPercentageColor(_ percentage: Double) -> Color {
        switch percentage {
        case 0..<5: return .green
        case 5..<15: return .yellow
        case 15..<25: return .orange
        default: return .red
        }
    }
    
    private func trafficLevelDescription(_ percentage: Double) -> String {
        switch percentage {
        case 0..<5: return "Excellent"
        case 5..<15: return "Good"
        case 15..<25: return "Heavy"
        default: return "Very Heavy"
        }
    }
    
    
    func DrivingTrendsChart(filteredCommutes: [CommuteRecord]) -> some View {
        let recentCommutes = Array(filteredCommutes.suffix(10))
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Recent Driving Trend")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if !recentCommutes.isEmpty {
                Chart(recentCommutes.indices, id: \.self) { index in
                    let commute = recentCommutes[index]
                    BarMark(
                        x: .value("Trip", index + 1),
                        y: .value("Score", commute.drivingMetrics.drivingScore)
                    )
                    .foregroundStyle(scoreColor(commute.drivingMetrics.drivingScore))
                    .cornerRadius(2)
                }
                .frame(height: 120)
                .chartYScale(domain: 0...100)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: min(recentCommutes.count, 5))) { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                        AxisGridLine()
                        AxisValueLabel("\(value.as(Int.self) ?? 0)")
                    }
                }
                
                Text("Showing last \(recentCommutes.count) commutes • Score out of 100")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func StatCard(title: String, value: String, color: Color, icon: String = "") -> some View {
        VStack(spacing: DesignSystem.Spacing.sm) {
            if !icon.isEmpty {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            
            Text(value)
                .font(DesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
            
            Text(title)
                .font(DesignSystem.Typography.caption)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                        .fill(color.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.lg)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    color.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: DesignSystem.Shadow.light, radius: 8, x: 0, y: 4)
        .shadow(color: color.opacity(0.1), radius: 12, x: 0, y: 6)
    }
    
    func WeeklyInsights(filteredCommutes: [CommuteRecord]) -> some View {
        let weeklyInsights = getWeeklyInsights(from: filteredCommutes)
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Analysis")
                .font(.title2)
                .fontWeight(.bold)
            
            if weeklyInsights.isEmpty {
                Text("Complete more commutes throughout the week to see patterns and recommendations")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack(spacing: 16) {
                    BestDepartureTimesTable(weeklyData: weeklyInsights)
                    WeeklyAverageScoreChart(weeklyData: weeklyInsights)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignSystem.Spacing.md)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.md)
        .shadow(radius: 2)
    }
    
    func InsightRow(day: String, commutes: [CommuteRecord]) -> some View {
        let recommendation = getRecommendation(for: commutes)
        let recommendationLines = recommendation.components(separatedBy: "\n")
        
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(day)
                    .font(.headline)
                    .frame(width: 80, alignment: .leading)
                Spacer()
            }
            
            ForEach(Array(recommendationLines.enumerated()), id: \.offset) { index, line in
                Text(line)
                    .font(index == 0 ? .subheadline : .caption)
                    .foregroundColor(index == 0 ? .secondary : .orange)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func getWeeklyInsights(from commutes: [CommuteRecord]) -> [String: [CommuteRecord]] {
        let calendar = Calendar.current
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        var insights: [String: [CommuteRecord]] = [:]
        
        for commute in commutes {
            let weekday = calendar.weekdaySymbols[calendar.component(.weekday, from: commute.startTime) - 1]
            if weekdays.contains(weekday) {
                insights[weekday, default: []].append(commute)
            }
        }
        
        return insights
    }
    
    private func getRecommendation(for commutes: [CommuteRecord]) -> String {
        guard commutes.count >= 2 else {
            return "Need more data (only \(commutes.count) commute\(commutes.count == 1 ? "" : "s"))"
        }
        
        let optimalWindow = calculateOptimalDepartureWindow(for: commutes)
        let trafficSummary = getTrafficSummary(for: commutes)
        return "\(optimalWindow)\n\(trafficSummary)"
    }
    
    private func getTrafficSummary(for commutes: [CommuteRecord]) -> String {
        let avgTrafficTime = commutes.reduce(0) { $0 + $1.drivingMetrics.slowTrafficTime } / Double(commutes.count)
        let avgTrafficPercentage = commutes.reduce(0.0) { total, commute in
            let percentage = commute.duration > 0 ? (commute.drivingMetrics.slowTrafficTime / commute.duration) * 100 : 0
            return total + percentage
        } / Double(commutes.count)
        
        let trafficMinutes = Int(avgTrafficTime / 60)
        return "Traffic: \(trafficMinutes)m avg (\(String(format: "%.0f", avgTrafficPercentage))%)"
    }
    
    private func calculateOptimalDepartureWindow(for commutes: [CommuteRecord]) -> String {
        let calendar = Calendar.current
        
        // Create 10-minute time windows throughout the day
        var windowData: [Int: (totalDuration: Double, heavyTrafficTime: Double, count: Int)] = [:]
        
        for commute in commutes {
            let startHour = calendar.component(.hour, from: commute.startTime)
            let startMinute = calendar.component(.minute, from: commute.startTime)
            
            // Convert to 10-minute windows (0-143 representing 00:00-23:50)
            let windowIndex = startHour * 6 + startMinute / 10
            
            // Calculate heavy traffic time for this commute
            let heavyTrafficDuration = commute.heavyTrafficPeriods.reduce(0) { $0 + $1.duration }
            
            if windowData[windowIndex] != nil {
                windowData[windowIndex]!.totalDuration += commute.duration
                windowData[windowIndex]!.heavyTrafficTime += heavyTrafficDuration
                windowData[windowIndex]!.count += 1
            } else {
                windowData[windowIndex] = (commute.duration, heavyTrafficDuration, 1)
            }
        }
        
        // Find the optimal window based on shortest duration and least traffic
        var bestWindow: Int?
        var bestScore = Double.infinity
        
        for (windowIndex, data) in windowData {
            guard data.count >= 1 else { continue }
            
            let avgDuration = data.totalDuration / Double(data.count)
            let avgHeavyTraffic = data.heavyTrafficTime / Double(data.count)
            
            // Score combines duration and traffic (lower is better)
            // Weight traffic time more heavily as it's usually the main concern
            let score = avgDuration + (avgHeavyTraffic * 2.0)
            
            if score < bestScore {
                bestScore = score
                bestWindow = windowIndex
            }
        }
        
        guard let optimalWindow = bestWindow,
              let data = windowData[optimalWindow] else {
            return "Insufficient data for recommendations"
        }
        
        // Convert back to time format
        let hour = optimalWindow / 6
        let minute = (optimalWindow % 6) * 10
        let endMinute = minute + 10
        
        let avgDuration = Int(data.totalDuration / Double(data.count) / 60.0)
        let avgTrafficTime = Int(data.heavyTrafficTime / Double(data.count) / 60.0)
        
        let startTime = String(format: "%02d:%02d", hour, minute)
        let endTime = String(format: "%02d:%02d", hour + (endMinute / 60), endMinute % 60)
        
        var recommendation = "Best: \(startTime)-\(endTime) (\(avgDuration)min avg"
        if avgTrafficTime > 0 {
            recommendation += ", \(avgTrafficTime)min traffic"
        }
        recommendation += ")"
        
        return recommendation
    }
    
    // MARK: - Chart Views
    func BestDepartureTimesTable(weeklyData: [String: [CommuteRecord]]) -> some View {
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Best Departure Times")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    DepartureTimeRow(day: day, commutes: weeklyData[day] ?? [])
                    
                    if day != weekdays.last {
                        Divider()
                            .background(DesignSystem.Colors.borderColor)
                    }
                }
            }
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(DesignSystem.Colors.borderColor, lineWidth: 1)
            )
            
            Text("Based on shortest trip duration and least traffic")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    func DepartureTimeRow(day: String, commutes: [CommuteRecord]) -> some View {
        HStack {
            Text(day)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.text)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            if commutes.isEmpty {
                Text("No data")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                let insight = calculateOptimalDepartureWindow(for: commutes)
                Text(insight)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
    
    func WeeklyAverageScoreChart(weeklyData: [String: [CommuteRecord]]) -> some View {
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        let chartData = weekdays.compactMap { day -> (day: String, score: Double)? in
            guard let commutes = weeklyData[day], !commutes.isEmpty else { return nil }
            let averageScore = commutes.map { Double($0.drivingMetrics.drivingScore) }.reduce(0, +) / Double(commutes.count)
            return (day: String(day.prefix(3)), score: averageScore)
        }
        
        guard !chartData.isEmpty else {
            return AnyView(
                Text("No data available for weekly score trends")
                    .foregroundColor(.secondary)
                    .font(.caption)
            )
        }
        
        return AnyView(VStack(alignment: .leading, spacing: 8) {
            Text("Average Score by Day")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Chart(chartData, id: \.day) { data in
                LineMark(
                    x: .value("Day", data.day),
                    y: .value("Score", data.score)
                )
                .foregroundStyle(DesignSystem.Colors.accent)
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                PointMark(
                    x: .value("Day", data.day),
                    y: .value("Score", data.score)
                )
                .foregroundStyle(DesignSystem.Colors.accent)
                .symbol(Circle())
                .symbolSize(60)
            }
            .frame(height: 120)
            .chartYScale(domain: 0...100)
            .chartYAxis {
                AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                    AxisGridLine()
                    AxisValueLabel("\(value.as(Int.self) ?? 0)")
                }
            }
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
        })
    }
    
    func TrafficAnalysisChart(filteredCommutes: [CommuteRecord]) -> some View {
        let recentCommutes = Array(filteredCommutes.suffix(10))
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Traffic Impact Over Time")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if !recentCommutes.isEmpty {
                Chart(recentCommutes.indices, id: \.self) { index in
                    let commute = recentCommutes[index]
                    let trafficPercentage = commute.duration > 0 ? (commute.drivingMetrics.slowTrafficTime / commute.duration) * 100 : 0
                    
                    AreaMark(
                        x: .value("Trip", index + 1),
                        y: .value("Traffic %", trafficPercentage)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [DesignSystem.Colors.warning.opacity(0.3), DesignSystem.Colors.warning.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    LineMark(
                        x: .value("Trip", index + 1),
                        y: .value("Traffic %", trafficPercentage)
                    )
                    .foregroundStyle(DesignSystem.Colors.warning)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
                .frame(height: 100)
                .chartYScale(domain: 0...100)
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine()
                        AxisValueLabel("\(Int(value.as(Double.self) ?? 0))%")
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: min(recentCommutes.count, 5))) { _ in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                
                Text("Traffic time as % of total trip duration")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func DrivingEventsChart(filteredCommutes: [CommuteRecord]) -> some View {
        let recentCommutes = Array(filteredCommutes.suffix(5))
        let maxEventTotal = recentCommutes.map { commute in
            commute.drivingMetrics.brakingEventCount + 
            commute.drivingMetrics.accelerationEvents + 
            commute.drivingMetrics.phoneDistractions + 
            commute.drivingMetrics.hornEvents
        }.max() ?? 0
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Recent Events Breakdown")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if !recentCommutes.isEmpty {
                Chart(recentCommutes.indices, id: \.self) { index in
                    let commute = recentCommutes[index]
                    
                    BarMark(
                        x: .value("Trip", "Trip \(index + 1)"),
                        y: .value("Braking", commute.drivingMetrics.brakingEventCount),
                        stacking: .standard
                    )
                    .foregroundStyle(DesignSystem.Colors.error)
                    
                    BarMark(
                        x: .value("Trip", "Trip \(index + 1)"),
                        y: .value("Acceleration", commute.drivingMetrics.accelerationEvents),
                        stacking: .standard
                    )
                    .foregroundStyle(DesignSystem.Colors.accent)
                    
                    BarMark(
                        x: .value("Trip", "Trip \(index + 1)"),
                        y: .value("Phone", commute.drivingMetrics.phoneDistractions),
                        stacking: .standard
                    )
                    .foregroundStyle(Color.orange)
                    
                    BarMark(
                        x: .value("Trip", "Trip \(index + 1)"),
                        y: .value("Horn", commute.drivingMetrics.hornEvents),
                        stacking: .standard
                    )
                    .foregroundStyle(DesignSystem.Colors.primary)
                }
                .frame(height: 120)
                .chartYScale(domain: 0...max(maxEventTotal + 2, 10))
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine()
                        AxisValueLabel("\(value.as(Int.self) ?? 0)")
                    }
                }
                .chartForegroundStyleScale([
                    "Braking": DesignSystem.Colors.error,
                    "Acceleration": DesignSystem.Colors.accent,
                    "Phone": Color.orange,
                    "Horn": DesignSystem.Colors.primary
                ])
                .chartLegend(position: .bottom, alignment: .center) {
                    HStack(spacing: 16) {
                        LegendItem(color: DesignSystem.Colors.error, text: "Braking")
                        LegendItem(color: DesignSystem.Colors.accent, text: "Acceleration")
                        LegendItem(color: Color.orange, text: "Phone")
                        LegendItem(color: DesignSystem.Colors.primary, text: "Horn")
                    }
                }
                
                Text("Stacked events per trip (last 5 commutes)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func CompactStatItem(title: String, value: String, color: Color, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 12)
            
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
        }
    }
    
    func LegendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Settings View
    func SettingsView() -> some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: DesignSystem.Spacing.lg) {
                    // Driving Preferences Section
                    CardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Label {
                                    Text("Driving Preferences")
                                        .font(DesignSystem.Typography.title3)
                                        .foregroundColor(DesignSystem.Colors.text)
                                } icon: {
                                    Image(systemName: "car.fill")
                                        .foregroundColor(DesignSystem.Colors.primary)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(spacing: DesignSystem.Spacing.md) {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                    Text("Speed Limit")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.text)
                                    
                                    Text("Speed violations detected above this limit")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundColor(DesignSystem.Colors.secondaryText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: DesignSystem.Spacing.xs) {
                                    Button(action: {
                                        let newValue = max(30, settingsManager.speedLimitThreshold - 5)
                                        settingsManager.speedLimitThreshold = newValue
                                        settingsManager.saveSpeedLimit(newValue)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(DesignSystem.Colors.primary)
                                    }
                                    .disabled(settingsManager.speedLimitThreshold <= 30)
                                    
                                    VStack(spacing: 1) {
                                        Text("\(Int(settingsManager.speedLimitThreshold))")
                                            .font(DesignSystem.Typography.title3)
                                            .foregroundColor(DesignSystem.Colors.primary)
                                            .fontWeight(.bold)
                                        
                                        Text("km/h")
                                            .font(.caption2)
                                            .foregroundColor(DesignSystem.Colors.secondaryText)
                                            .fontWeight(.medium)
                                    }
                                    .frame(minWidth: 50)
                                    .padding(.horizontal, DesignSystem.Spacing.xs)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                            .fill(DesignSystem.Colors.primary.opacity(0.1))
                                    )
                                    
                                    Button(action: {
                                        let newValue = min(150, settingsManager.speedLimitThreshold + 5)
                                        settingsManager.speedLimitThreshold = newValue
                                        settingsManager.saveSpeedLimit(newValue)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(DesignSystem.Colors.primary)
                                    }
                                    .disabled(settingsManager.speedLimitThreshold >= 150)
                                }
                            }
                            .padding(DesignSystem.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                    .fill(DesignSystem.Colors.cardBackground)
                                    .shadow(color: DesignSystem.Shadow.light, radius: 1, x: 0, y: 1)
                            )
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                SettingToggle(
                                    title: "Keep Screen On During Trips",
                                    description: "Prevent device from sleeping while tracking",
                                    isOn: $settingsManager.keepScreenOn,
                                    action: { newValue in
                                        settingsManager.saveKeepScreenOn(newValue)
                                        if isTracking {
                                            UIApplication.shared.isIdleTimerDisabled = newValue
                                        }
                                    }
                                )
                                
                                SettingToggle(
                                    title: "Smart Trip Ordering",
                                    description: "Order trips by location relevance and history",
                                    isOn: $settingsManager.useLocationBasedOrdering,
                                    action: { newValue in
                                        settingsManager.saveLocationOrdering(newValue)
                                    }
                                )
                            }
                        }
                    }
                    
                    // Location Permissions Section
                    CardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Label {
                                    Text("Location Permissions")
                                        .font(DesignSystem.Typography.title3)
                                        .foregroundColor(DesignSystem.Colors.text)
                                } icon: {
                                    Image(systemName: "location.circle.fill")
                                        .foregroundColor(DesignSystem.Colors.primary)
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                    Text("Current Status")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.text)
                                    
                                    Text("Required for GPS tracking and trip location data")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundColor(DesignSystem.Colors.secondaryText)
                                }
                                
                                Spacer()
                                
                                Text(authorizationStatusText)
                                    .font(DesignSystem.Typography.callout)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, DesignSystem.Spacing.sm)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                            .fill(authorizationStatusColor)
                                    )
                            }
                            
                            // Only show request button if permission is denied, restricted, or not determined
                            let needsPermission = locationManager.authorizationStatus == .denied || 
                                                locationManager.authorizationStatus == .restricted || 
                                                locationManager.authorizationStatus == .notDetermined
                            
                            if needsPermission {
                                AnimatedButton(action: {
                                    locationManager.requestLocationPermission()
                                }) {
                                    HStack {
                                        Image(systemName: "location.fill.viewfinder")
                                            .font(.headline)
                                        
                                        Text("Request Location Permission")
                                            .font(DesignSystem.Typography.headline)
                                            .fontWeight(.medium)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(DesignSystem.Spacing.md)
                                    .background(DesignSystem.Colors.primary)
                                    .cornerRadius(DesignSystem.CornerRadius.md)
                                }
                            } else {
                                // Show helpful message when permission is already granted
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        Text("Permission Granted")
                                            .font(DesignSystem.Typography.headline)
                                            .foregroundColor(.green)
                                        
                                        Text("Location services are enabled for trip tracking")
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundColor(DesignSystem.Colors.secondaryText)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(DesignSystem.Spacing.md)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(DesignSystem.CornerRadius.md)
                            }
                        }
                    }
                    
                    // Sensor Preferences Section
                    CardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Label {
                                    Text("Sensor Preferences")
                                        .font(DesignSystem.Typography.title3)
                                        .foregroundColor(DesignSystem.Colors.text)
                                } icon: {
                                    Image(systemName: "sensor.fill")
                                        .foregroundColor(DesignSystem.Colors.primary)
                                }
                                
                                Spacer()
                            }
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                SettingToggle(
                                    title: "GPS Tracking",
                                    description: "Record trip routes, distances, and speed data",
                                    isOn: $settingsManager.enableGPS,
                                    action: { newValue in
                                        settingsManager.saveGPSSetting(newValue)
                                    }
                                )
                                
                                SettingToggle(
                                    title: "Motion Sensors",
                                    description: "Detect braking, acceleration, and rough road conditions",
                                    isOn: $settingsManager.enableMotionSensors,
                                    action: { newValue in
                                        settingsManager.saveMotionSensorsSetting(newValue)
                                    }
                                )
                                
                                SettingToggle(
                                    title: "Microphone",
                                    description: "Detect horns and sirens for safety analysis",
                                    isOn: $settingsManager.enableMicrophone,
                                    action: { newValue in
                                        settingsManager.saveMicrophoneSetting(newValue)
                                    }
                                )
                            }
                            
                            // Info about sensor usage
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                Text("Disabled sensors will reduce battery usage but limit trip analysis features.")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(DesignSystem.Colors.secondaryText)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(DesignSystem.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                    .fill(DesignSystem.Colors.primary.opacity(0.1))
                            )
                        }
                    }
                    
                    // Data Management Section
                    CardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Label {
                                    Text("Data Management")
                                        .font(DesignSystem.Typography.title3)
                                        .foregroundColor(DesignSystem.Colors.text)
                                } icon: {
                                    Image(systemName: "externaldrive.fill")
                                        .foregroundColor(DesignSystem.Colors.primary)
                                }
                                
                                Spacer()
                            }
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                HStack {
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                        Text("Backup & Restore")
                                            .font(DesignSystem.Typography.headline)
                                            .foregroundColor(DesignSystem.Colors.text)
                                        
                                        Text("Export your trips and settings or restore from a backup")
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundColor(DesignSystem.Colors.secondaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(commuteTracker.commutes.count)")
                                        .font(DesignSystem.Typography.callout)
                                        .foregroundColor(DesignSystem.Colors.secondaryText)
                                        .padding(.horizontal, DesignSystem.Spacing.sm)
                                        .padding(.vertical, DesignSystem.Spacing.xs)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                                .fill(DesignSystem.Colors.background)
                                        )
                                }
                                
                                VStack(spacing: DesignSystem.Spacing.sm) {
                                    // Export Button
                                    AnimatedButton(action: {
                                        if let data = commuteTracker.exportAllData() {
                                            let filename = "MyCommute_Backup_\(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none).replacingOccurrences(of: "/", with: "_")).json"
                                            shareData(data, filename: filename)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "square.and.arrow.up")
                                                .font(.subheadline)
                                            Text("Export Data")
                                                .font(DesignSystem.Typography.subheadline)
                                                .fontWeight(.medium)
                                            Spacer()
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, DesignSystem.Spacing.lg)
                                        .padding(.vertical, DesignSystem.Spacing.md)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                                .fill(DesignSystem.Colors.primary)
                                        )
                                    }
                                    
                                    // Import Button
                                    Menu {
                                        Button(action: {
                                            showDocumentPicker = true
                                        }) {
                                            Label("Import Backup (JSON)", systemImage: "doc.text")
                                        }
                                        
                                        Button(action: {
                                            showCSVImporter = true
                                        }) {
                                            Label("Import CSV Data", systemImage: "tablecells")
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "square.and.arrow.down")
                                                .font(.subheadline)
                                            Text("Import Data")
                                                .font(DesignSystem.Typography.subheadline)
                                                .fontWeight(.medium)
                                            Spacer()
                                        }
                                        .foregroundColor(DesignSystem.Colors.primary)
                                        .padding(.horizontal, DesignSystem.Spacing.lg)
                                        .padding(.vertical, DesignSystem.Spacing.md)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                                .fill(DesignSystem.Colors.primary.opacity(0.1))
                                        )
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    // iCloud Sync Status Section
                    iCloudSyncSection
                    
                    
                    // About Section
                    CardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                            HStack {
                                Label {
                                    Text("About Time To Go")
                                        .font(DesignSystem.Typography.title3)
                                        .foregroundColor(DesignSystem.Colors.text)
                                } icon: {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(DesignSystem.Colors.primary)
                                }
                                
                                Spacer()
                            }
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                HStack {
                                    Text("Version")
                                        .font(DesignSystem.Typography.headline)
                                        .foregroundColor(DesignSystem.Colors.text)
                                    
                                    Spacer()
                                    
                                    Text("1.0")
                                        .font(DesignSystem.Typography.callout)
                                        .foregroundColor(DesignSystem.Colors.secondaryText)
                                        .padding(.horizontal, DesignSystem.Spacing.sm)
                                        .padding(.vertical, DesignSystem.Spacing.xs)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                                .fill(DesignSystem.Colors.background)
                                        )
                                }
                                
                                Text("Track your daily commutes with GPS precision, analyze driving patterns, and get personalized recommendations.")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundColor(DesignSystem.Colors.secondaryText)
                                    .multilineTextAlignment(.leading)
                                
                                Divider()
                                    .background(DesignSystem.Colors.borderColor)
                                
                                // Algorithm explanation links
                                VStack(spacing: DesignSystem.Spacing.sm) {
                                    Button(action: {
                                        showDriveQualityExplanation = true
                                    }) {
                                        HStack {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .foregroundColor(DesignSystem.Colors.primary)
                                                .frame(width: 20)
                                            
                                            Text("How Drive Quality is Calculated")
                                                .font(DesignSystem.Typography.subheadline)
                                                .foregroundColor(DesignSystem.Colors.text)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                        }
                                        .padding(.vertical, DesignSystem.Spacing.xs)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Button(action: {
                                        showDepartureTimeExplanation = true
                                    }) {
                                        HStack {
                                            Image(systemName: "clock.arrow.circlepath")
                                                .foregroundColor(DesignSystem.Colors.primary)
                                                .frame(width: 20)
                                            
                                            Text("How We Find the Best Time to Leave")
                                                .font(DesignSystem.Typography.subheadline)
                                                .foregroundColor(DesignSystem.Colors.text)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(DesignSystem.Colors.secondaryText)
                                        }
                                        .padding(.vertical, DesignSystem.Spacing.xs)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    // Attribution
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Text("Made for and by Rohan Manthani")
                            .font(DesignSystem.Typography.caption)
                            .foregroundColor(DesignSystem.Colors.secondaryText.opacity(0.7))
                    }
                    .padding(.top, DesignSystem.Spacing.lg)
                }
                .padding(DesignSystem.Spacing.md)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var authorizationStatusText: String {
        switch locationManager.authorizationStatus {
        case .notDetermined: return "Not Determined"
        case .denied: return "Denied"
        case .restricted: return "Restricted"
        case .authorizedWhenInUse: return "When In Use"
        case .authorizedAlways: return "Always"
        @unknown default: return "Unknown"
        }
    }
    
    private var authorizationStatusColor: Color {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: return .green
        case .denied, .restricted: return .red
        case .notDetermined: return .orange
        default: return .secondary
        }
    }
    
    private func relativeDateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private var iCloudSyncSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
                HStack {
                    Label {
                        Text("iCloud Sync")
                            .font(DesignSystem.Typography.title3)
                            .foregroundColor(DesignSystem.Colors.text)
                    } icon: {
                        Image(systemName: "icloud.fill")
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        if commuteTracker.lastSyncTime != nil {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                            Text("Synced")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            Text("Not synced")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                VStack(spacing: DesignSystem.Spacing.md) {
                    HStack {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text("Data Size")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.text)
                            
                            Text("Amount of trip data synced to iCloud")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                        
                        Spacer()
                        
                        Text(commuteTracker.syncDataSize)
                            .font(DesignSystem.Typography.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.horizontal, DesignSystem.Spacing.sm)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.sm)
                                    .fill(DesignSystem.Colors.primary.opacity(0.1))
                            )
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                            Text("Last Sync")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.text)
                            
                            Text("When data was last synced to iCloud")
                                .font(DesignSystem.Typography.caption)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        }
                        
                        Spacer()
                        
                        if let lastSync = commuteTracker.lastSyncTime {
                            Text(relativeDateString(from: lastSync))
                                .font(DesignSystem.Typography.callout)
                                .foregroundColor(DesignSystem.Colors.secondaryText)
                        } else {
                            Text("Never synced")
                                .font(DesignSystem.Typography.callout)
                                .foregroundColor(DesignSystem.Colors.warning)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Trip Detail View
    func TripDetailView(commute: CommuteRecord) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Traffic Analysis
            Text("Traffic Analysis")
                .font(.headline)
                .foregroundColor(.primary)
                
                // Slow Traffic Time Summary
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.red)
                            Text("Time in Slow Traffic (<15 km/h)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        Text(formatSlowTrafficDisplayTime(commute.drivingMetrics.slowTrafficTime, totalTripDuration: commute.duration))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // Heavy Traffic Periods Detail
                if !commute.heavyTrafficPeriods.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundColor(.orange)
                            Text("\(commute.heavyTrafficPeriods.count) heavy traffic period\(commute.heavyTrafficPeriods.count == 1 ? "" : "s") detected")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    
                        ForEach(Array(commute.heavyTrafficPeriods.enumerated()), id: \.offset) { index, period in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Period \(index + 1): \(period.formattedDuration)")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Text("Avg Speed: \(String(format: "%.1f", period.averageSpeed)) km/h")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(CommuteRecord.timeFormatter.string(from: period.startTime))
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            
            if !commute.pathPoints.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Route Map")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    // Speed Legend
                    SpeedLegendView()
                    
                    Button(action: {
                        fullScreenMapCommute = commute
                    }) {
                        TripMapView(commute: commute)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                            .overlay(
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.6)).frame(width: 32, height: 32))
                                            .padding(8)
                                    }
                                }
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Full Screen Map View
    func FullScreenMapView(commute: CommuteRecord) -> some View {
        NavigationView {
            VStack(spacing: 0) {
                // Trip info header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tripManager.availableTrips.first(where: { $0.id == commute.type.id })?.displayName ?? commute.type.displayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("\(commute.formattedDate) • \(commute.formattedDuration)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Event toggle controls
                        Menu {
                            Toggle("Show Events", isOn: $showDrivingEvents)
                            
                            if showDrivingEvents {
                                Divider()
                                
                                ForEach(DrivingEvent.EventType.allCases, id: \.self) { eventType in
                                    Toggle(eventType.displayName, isOn: Binding(
                                        get: { visibleEventTypes.contains(eventType) },
                                        set: { isOn in
                                            if isOn {
                                                visibleEventTypes.insert(eventType)
                                            } else {
                                                visibleEventTypes.remove(eventType)
                                            }
                                        }
                                    ))
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: showDrivingEvents ? "eye.fill" : "eye.slash")
                                    .font(.caption)
                                Text("Events")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(showDrivingEvents ? Color.blue : Color.gray)
                            )
                        }
                    }
                    
                    // Speed Legend
                    SpeedLegendView()
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                
                // Full screen map
                ZStack {
                    // Background
                    Color(.systemBackground)
                    
                    // Full screen map
                    TripMapView(
                        commute: commute,
                        showEvents: showDrivingEvents,
                        visibleEventTypes: visibleEventTypes
                    )
                    .id("fullscreen-map-\(commute.id)-\(showDrivingEvents)-\(visibleEventTypes.count)")
                    
                }
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .navigationTitle("Route Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        fullScreenMapCommute = nil
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .onAppear {
        }
        .onDisappear {
        }
    }

    // MARK: - Import/Export Buttons
    func ShareButton() -> some View {
        Menu {
            ShareLink("Export Summary", item: createCSVFile())
            ShareLink("Export GPS Data", item: createDetailedGPSFile())
            
            Divider()
            
            Button {
                showCSVImporter = true
            } label: {
                Label("Import CSV", systemImage: "square.and.arrow.down")
            }
        } label: {
            Text("Data")
        }
    }
    
    private func createCSVFile() -> URL {
        let csvContent = commuteTracker.exportToCSV()
        let fileName = "commute-data-\(Date().formatted(date: .abbreviated, time: .omitted)).csv"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            // File creation error handled silently - ShareLink will still work
        }
        
        return fileURL
    }
    
    private func createDetailedGPSFile() -> URL {
        let csvContent = commuteTracker.exportDetailedGPSData()
        let fileName = "commute-gps-data-\(Date().formatted(date: .abbreviated, time: .omitted)).csv"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try csvContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            // File creation error handled silently - ShareLink will still work
        }
        
        return fileURL
    }
    
    // MARK: - Smart Trip Ordering
    private func getSmartOrderedTrips() -> [CommuteType] {
        // Check if user has enabled location-based ordering
        guard settingsManager.useLocationBasedOrdering,
              !commuteTracker.commutes.isEmpty,
              let currentLocation = locationManager.currentLocation else {
            return tripManager.regularTrips // Return regular trips only (excludes one-off)
        }
        
        // Calculate relevance scores for each trip
        let tripScores = tripManager.regularTrips.map { trip in
            let score = calculateTripRelevanceScore(trip: trip, currentLocation: currentLocation)
            return (trip: trip, score: score)
        }
        
        // Sort by relevance score (higher score = more relevant)
        let sortedTrips = tripScores.sorted { $0.score > $1.score }
        
        return sortedTrips.map { $0.trip }
    }
    
    private func calculateTripRelevanceScore(trip: CommuteType, currentLocation: CLLocation) -> Double {
        // Find all historical trips matching this trip type
        let historicalTrips = commuteTracker.commutes.filter { $0.type.id == trip.id }
        
        guard !historicalTrips.isEmpty else {
            return 0.0 // No history for this trip
        }
        
        var totalScore = 0.0
        var validTrips = 0
        
        for historicalTrip in historicalTrips {
            guard let startLocation = historicalTrip.startLocation else { continue }
            
            let historicalStartLocation = CLLocation(
                latitude: startLocation.latitude,
                longitude: startLocation.longitude
            )
            
            // Calculate distance from current location to historical start location
            let distance = currentLocation.distance(from: historicalStartLocation)
            
            // Convert distance to a relevance score
            // Closer locations get higher scores, with exponential decay
            let maxRelevantDistance: Double = 5000 // 5km max relevant distance
            
            if distance <= maxRelevantDistance {
                // Score decreases exponentially with distance
                let normalizedDistance = distance / maxRelevantDistance
                let distanceScore = exp(-normalizedDistance * 3) // Exponential decay
                
                // Weight recent trips more heavily
                let daysSinceTrip = abs(historicalTrip.startTime.timeIntervalSinceNow) / (24 * 3600)
                let recencyWeight = exp(-daysSinceTrip / 30) // Decay over 30 days
                
                totalScore += distanceScore * recencyWeight
                validTrips += 1
            }
        }
        
        // Average score with bonus for frequency
        let averageScore = validTrips > 0 ? totalScore / Double(validTrips) : 0.0
        let frequencyBonus = min(Double(validTrips) * 0.1, 1.0) // Up to 100% bonus for frequent trips
        
        return averageScore + frequencyBonus
    }
}

// MARK: - Splash Screen
struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0.0
    @State private var logoRotation: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    
    // Driving tips array
    private let drivingTips = [
        "Anticipate traffic patterns - most slowdowns happen at the same spots daily",
        "Keep a 3-second following distance to reduce harsh braking",
        "Use cruise control on highways to maintain steady speeds",
        "Plan lane changes early rather than waiting until the last moment",
        "Coast to red lights instead of accelerating then braking hard",
        "Check traffic apps before leaving, but take alternate routes sparingly",
        "Merge at highway speed, not slower - it's safer and smoother",
        "Use gentle acceleration - jackrabbit starts waste fuel and stress drivetrain",
        "In stop-and-go traffic, maintain steady slow speeds vs constant stopping",
        "Pre-cool or pre-heat your car while plugged in to save energy",
        "Keep tires properly inflated - underinflated tires reduce efficiency",
        "Remove roof racks when not in use to reduce drag",
        "Combine errands into one trip rather than multiple short trips",
        "Park in shade during summer to reduce AC load when starting",
        "Use eco-mode in city driving, normal mode on highways",
        "Avoid rush hour peaks by leaving 30 minutes earlier or later",
        "Learn your engine's power band for efficient highway merging",
        "Use downhill momentum to maintain speed instead of accelerating",
        "Keep windows closed above 45mph - AC is more efficient than drag",
        "Warm up modern cars by driving gently, not idling",
        "Use GPS predictively - slow down before turns rather than during",
        "Master the zipper merge - wait until the merge point",
        "Choose middle lanes on multi-lane roads for fewer lane changes",
        "Scan 12-15 seconds ahead to anticipate traffic changes",
        "Use light throttle inputs - heavy acceleration uses more fuel exponentially",
        "Time parking lot searches during off-peak hours when possible",
        "Learn traffic signal timing on your regular routes",
        "Maintain steady speeds uphill rather than surging and coasting",
        "Use regenerative braking effectively in hybrids and EVs",
        "Plan fuel stops during off-peak hours to avoid crowded stations"
    ]
    
    private var currentTip: String {
        let tipIndex = UserDefaults.standard.integer(forKey: "CurrentTipIndex")
        return drivingTips[tipIndex % drivingTips.count]
    }
    
    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App Logo/Icon with enhanced animations
                Image("SplashIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140, height: 140)
                    .cornerRadius(25)
                    .scaleEffect(logoScale * pulseScale)
                    .opacity(logoOpacity)
                    .rotationEffect(.degrees(logoRotation))
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0),
                        value: logoScale
                    )
                    .animation(
                        .easeInOut(duration: 0.6),
                        value: logoOpacity
                    )
                    .animation(
                        .easeInOut(duration: 0.4),
                        value: logoRotation
                    )
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: pulseScale
                    )
                
                // App Name
                Text("Rohan's Commute")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(logoOpacity)
                    .animation(
                        .easeInOut(duration: 0.6).delay(0.2),
                        value: logoOpacity
                    )
                
                // Driving tip
                if isAnimating {
                    Text(currentTip)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .opacity(0.8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .animation(
                            .easeInOut(duration: 0.5).delay(0.5),
                            value: isAnimating
                        )
                }
            }
        }
        .onAppear {
            startAnimation()
            updateTipIndex()
        }
    }
    
    private func startAnimation() {
        // Initial logo bounce animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
            logoScale = 1.2
            logoOpacity = 1.0
            logoRotation = 5.0
        }
        
        // Scale back to normal with rotation reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                logoScale = 1.0
                logoRotation = 0.0
            }
        }
        
        // Start pulsing animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
            }
        }
        
        // Show loading text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isAnimating = true
        }
    }
    
    private func updateTipIndex() {
        let currentIndex = UserDefaults.standard.integer(forKey: "CurrentTipIndex")
        let nextIndex = (currentIndex + 1) % drivingTips.count
        UserDefaults.standard.set(nextIndex, forKey: "CurrentTipIndex")
    }
}

// MARK: - Speed Legend View
struct SpeedLegendView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                SpeedLegendItem(category: .stopped, label: "0-5")
                SpeedLegendItem(category: .crawling, label: "5-15")
                SpeedLegendItem(category: .slow, label: "15-30")
                SpeedLegendItem(category: .normal, label: "30-60")
                SpeedLegendItem(category: .fast, label: "60-80")
                SpeedLegendItem(category: .veryFast, label: "80+")
            }
            .padding(.horizontal, 4)
        }
    }
}

struct SpeedLegendItem: View {
    let category: SpeedCategory
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(Color(category.color))
                .frame(width: 12, height: 3)
                .cornerRadius(1.5)
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Custom Speed Polyline
class SpeedPolyline: MKPolyline {
    var averageSpeed: Double = 0.0
    var speedCategory: SpeedCategory = .normal
}

enum SpeedCategory {
    case stopped      // 0-5 km/h - Red
    case crawling     // 5-15 km/h - Dark Orange  
    case slow         // 15-30 km/h - Orange
    case normal       // 30-60 km/h - Green
    case fast         // 60-80 km/h - Blue
    case veryFast     // 80+ km/h - Purple
    
    var color: UIColor {
        switch self {
        case .stopped: return .systemRed
        case .crawling: return .systemOrange
        case .slow: return UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0) // Light orange
        case .normal: return .systemGreen
        case .fast: return .systemBlue
        case .veryFast: return .systemPurple
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .stopped, .crawling: return 6.0 // Thicker for problem areas
        case .slow: return 5.0
        case .normal: return 4.0
        case .fast: return 4.0
        case .veryFast: return 5.0 // Thicker for high speeds
        }
    }
    
    static func categorize(speed: Double) -> SpeedCategory {
        switch speed {
        case 0..<5: return .stopped
        case 5..<15: return .crawling
        case 15..<30: return .slow
        case 30..<60: return .normal
        case 60..<80: return .fast
        default: return .veryFast
        }
    }
}

// MARK: - Driving Event Annotation
class DrivingEventAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let event: DrivingEvent
    
    init(event: DrivingEvent) {
        self.event = event
        self.coordinate = CLLocationCoordinate2D(
            latitude: event.location.latitude,
            longitude: event.location.longitude
        )
        self.title = event.type.displayName
        self.subtitle = "Speed: \(Int(event.location.speed)) km/h"
        super.init()
    }
}

// MARK: - Trip Map View
struct TripMapView: UIViewRepresentable {
    let commute: CommuteRecord
    var showEvents: Bool = false
    var visibleEventTypes: Set<DrivingEvent.EventType> = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        // Ensure the coordinator is properly initialized before setting delegate
        DispatchQueue.main.async {
            mapView.delegate = context.coordinator
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Ensure map operations are performed safely
        guard mapView.delegate != nil else {
            DispatchQueue.main.async {
                mapView.delegate = context.coordinator
                self.updateUIView(mapView, context: context)
            }
            return
        }
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        guard !commute.pathPoints.isEmpty else { return }
        
        // Create coordinates from path points
        let coordinates = commute.pathPoints.map { 
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        // Create route polylines with different colors based on speed
        createSpeedBasedRouteSegments(coordinates: coordinates, mapView: mapView)
        
        // Add start and end annotations
        if let startLocation = commute.startLocation {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = CLLocationCoordinate2D(
                latitude: startLocation.latitude,
                longitude: startLocation.longitude
            )
            startAnnotation.title = "Start"
            startAnnotation.subtitle = CommuteRecord.timeFormatter.string(from: startLocation.timestamp)
            mapView.addAnnotation(startAnnotation)
        }
        
        if let endLocation = commute.endLocation {
            let endAnnotation = MKPointAnnotation()
            endAnnotation.coordinate = CLLocationCoordinate2D(
                latitude: endLocation.latitude,
                longitude: endLocation.longitude
            )
            endAnnotation.title = "End"
            endAnnotation.subtitle = CommuteRecord.timeFormatter.string(from: endLocation.timestamp)
            mapView.addAnnotation(endAnnotation)
        }
        
        // Add driving event annotations if enabled
        if showEvents {
            for event in commute.drivingEvents {
                if visibleEventTypes.contains(event.type) {
                    let eventAnnotation = DrivingEventAnnotation(event: event)
                    mapView.addAnnotation(eventAnnotation)
                }
            }
        }
        
        // Set the map region to fit the route
        if coordinates.count > 1 {
            // Calculate bounds from all coordinates
            var minLat = coordinates[0].latitude
            var maxLat = coordinates[0].latitude
            var minLng = coordinates[0].longitude
            var maxLng = coordinates[0].longitude
            
            for coordinate in coordinates {
                minLat = min(minLat, coordinate.latitude)
                maxLat = max(maxLat, coordinate.latitude)
                minLng = min(minLng, coordinate.longitude)
                maxLng = max(maxLng, coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLng + maxLng) / 2
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.3, // Add 30% padding
                longitudeDelta: (maxLng - minLng) * 1.3
            )
            
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: false)
        } else if let firstPoint = coordinates.first {
            let region = MKCoordinateRegion(
                center: firstPoint,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
            mapView.setRegion(region, animated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func createSpeedBasedRouteSegments(coordinates: [CLLocationCoordinate2D], mapView: MKMapView) {
        guard coordinates.count > 1 && commute.pathPoints.count == coordinates.count else { 
            // Fallback: create single segment if no speed data
            let polyline = SpeedPolyline(coordinates: coordinates, count: coordinates.count)
            polyline.speedCategory = .normal
            mapView.addOverlay(polyline)
            return 
        }
        
        // Define segment size for speed averaging (about 5-10 GPS points per segment)
        let segmentSize = max(1, min(10, coordinates.count / 20)) // Adaptive segment size
        
        var currentSegmentStart = 0
        
        while currentSegmentStart < coordinates.count - 1 {
            let segmentEnd = min(currentSegmentStart + segmentSize, coordinates.count - 1)
            
            // Calculate average speed for this segment
            let segmentSpeeds = Array(commute.pathPoints[currentSegmentStart...segmentEnd]).map { $0.speed }
            let averageSpeed = segmentSpeeds.reduce(0, +) / Double(segmentSpeeds.count)
            
            // Create segment coordinates (ensure we have at least 2 points for a line)
            let endIndex = segmentEnd == currentSegmentStart ? segmentEnd + 1 : segmentEnd
            let segmentCoordinates = Array(coordinates[currentSegmentStart...min(endIndex, coordinates.count - 1)])
            
            // Create polyline with speed-based styling
            let polyline = SpeedPolyline(coordinates: segmentCoordinates, count: segmentCoordinates.count)
            polyline.averageSpeed = averageSpeed
            polyline.speedCategory = SpeedCategory.categorize(speed: averageSpeed)
            mapView.addOverlay(polyline)
            
            currentSegmentStart = segmentEnd
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let speedPolyline = overlay as? SpeedPolyline {
                let renderer = MKPolylineRenderer(polyline: speedPolyline)
                renderer.strokeColor = speedPolyline.speedCategory.color
                renderer.lineWidth = speedPolyline.speedCategory.lineWidth
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let eventAnnotation = annotation as? DrivingEventAnnotation {
                let identifier = "DrivingEvent"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                    annotationView?.displayPriority = .required
                }
                
                annotationView?.annotation = annotation
                annotationView?.markerTintColor = eventAnnotation.event.type.color
                annotationView?.glyphImage = UIImage(systemName: eventAnnotation.event.type.iconName)
                
                // Make markers smaller for events
                annotationView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                
                return annotationView
            }
            
            if annotation is MKPointAnnotation {
                let identifier = "TripPoint"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                }
                
                annotationView?.annotation = annotation
                
                // Customize marker colors
                if annotation.title == "Start" {
                    annotationView?.markerTintColor = .systemGreen
                    annotationView?.glyphText = "S"
                } else if annotation.title == "End" {
                    annotationView?.markerTintColor = .systemRed  
                    annotationView?.glyphText = "E"
                }
                
                return annotationView
            }
            
            return nil
        }
    }
}

// MARK: - Trip Editor View
struct TripEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var tripManager: TripManager
    @EnvironmentObject var commuteTracker: CommuteTracker
    @State private var newTripName = ""
    @State private var editingTripId: String?
    @State private var editingTripName = ""
    @State private var deletingTripId: String?
    @State private var activeAlert: AlertType?
    @State private var showAddTripSheet = false
    @State private var addTripErrorMessage = ""
    @State private var tempTripNames: [String: String] = [:]
    @State private var validationErrors: [String: String] = [:]
    
    enum AlertType: Identifiable {
        case deleteTrip
        
        var id: String {
            switch self {
            case .deleteTrip: return "delete"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Available Commutes") {
                    ForEach(tripManager.regularTrips, id: \.id) { trip in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                TextField("Commute name", text: Binding(
                                    get: { tempTripNames[trip.id] ?? trip.displayName },
                                    set: { newValue in
                                        tempTripNames[trip.id] = newValue
                                        validateTripName(tripId: trip.id, name: newValue)
                                    }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onSubmit {
                                    saveTripName(tripId: trip.id)
                                }
                                
                                if let error = validationErrors[trip.id] {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                if tempTripNames[trip.id] != nil && tempTripNames[trip.id] != trip.displayName {
                                    Button(action: {
                                        saveTripName(tripId: trip.id)
                                    }) {
                                        Text("Save")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue)
                                            .cornerRadius(4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .disabled(validationErrors[trip.id] != nil)
                                    
                                    Button(action: {
                                        tempTripNames[trip.id] = nil
                                        validationErrors[trip.id] = nil
                                    }) {
                                        Text("Cancel")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.gray)
                                            .cornerRadius(4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Button(action: {
                                        deletingTripId = trip.id
                                        activeAlert = .deleteTrip
                                    }) {
                                        Text("Delete")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.red)
                                            .cornerRadius(4)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                if tripManager.canAddMoreTrips() {
                    Section("Add New Commute") {
                        Button("Add Custom Commute") {
                            newTripName = ""
                            addTripErrorMessage = ""
                            showAddTripSheet = true
                        }
                        .foregroundColor(.blue)
                    }
                } else {
                    Section("Limit Reached") {
                        Text("You can have up to 8 commutes total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Edit Commutes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTripSheet) {
            AddTripSheet(
                tripName: $newTripName,
                errorMessage: $addTripErrorMessage,
                onSave: { name in
                    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if trimmedName.isEmpty {
                        addTripErrorMessage = "Trip name cannot be empty"
                        return false
                    }
                    
                    if trimmedName.count > 30 {
                        addTripErrorMessage = "Trip name must be 30 characters or less"
                        return false
                    }
                    
                    if tripManager.isTripNameTaken(trimmedName) {
                        addTripErrorMessage = "A trip with this name already exists"
                        return false
                    }
                    
                    tripManager.addTrip(name: trimmedName)
                    newTripName = ""
                    addTripErrorMessage = ""
                    return true
                }
            )
            .environmentObject(tripManager)
        }
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .deleteTrip:
                return Alert(
                    title: Text("Delete Trip"),
                    message: Text("This will permanently delete this trip and all associated trip data. This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let tripId = deletingTripId {
                            // Delete associated commute data
                            commuteTracker.commutes.removeAll { $0.type.id == tripId }
                            // Delete the trip
                            tripManager.deleteTrip(tripId: tripId)
                            deletingTripId = nil
                        }
                    },
                    secondaryButton: .cancel {
                        deletingTripId = nil
                    }
                )
            }
        }
    }
    
    private func validateTripName(tripId: String, name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            validationErrors[tripId] = "Trip name cannot be empty"
        } else if trimmedName.count > 30 {
            validationErrors[tripId] = "Trip name must be 30 characters or less"
        } else if tripManager.isTripNameTaken(trimmedName, excludingTripId: tripId) {
            validationErrors[tripId] = "A trip with this name already exists"
        } else {
            validationErrors[tripId] = nil
        }
    }
    
    private func saveTripName(tripId: String) {
        guard let newName = tempTripNames[tripId],
              validationErrors[tripId] == nil else { return }
        
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Clear any potential alert state before saving
        activeAlert = nil
        
        tripManager.updateTrip(tripId: tripId, newName: trimmedName)
        tempTripNames[tripId] = nil
        validationErrors[tripId] = nil
    }
}

// MARK: - Add Commute Sheet
struct AddTripSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var tripManager: TripManager
    @Binding var tripName: String
    @Binding var errorMessage: String
    let onSave: (String) -> Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Commute Name")
                        .font(.headline)
                    
                    TextField("Enter commute name", text: $tripName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            if onSave(tripName) {
                                dismiss()
                            }
                        }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Text("Maximum 30 characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Custom Commute")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if onSave(tripName) {
                            dismiss()
                        }
                    }
                    .disabled(tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            errorMessage = ""
        }
    }
    
}

// MARK: - Onboarding View
struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    private let pages = 4
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.05),
                    Color.indigo.opacity(0.08)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        onComplete()
                    }
                    .foregroundColor(.secondary)
                    .padding()
                }
                
                Spacer()
                
                // Page content
                TabView(selection: $currentPage) {
                    // Page 1: Welcome
                    OnboardingPageView(
                        icon: "car.fill",
                        title: "Welcome to Time To Go",
                        subtitle: "Your smart commute optimization companion",
                        description: "Time To Go helps you find the perfect departure time for your daily commutes by analyzing traffic patterns and travel times."
                    )
                    .tag(0)
                    
                    // Page 2: Regular Commutes
                    OnboardingPageView(
                        icon: "repeat.circle.fill",
                        title: "For Regular Commutes",
                        subtitle: "Designed for trips you take repeatedly",
                        description: "This app works best for your daily commutes - like home to office or regular trips to school. It learns from your repeated journeys, not one-off trips."
                    )
                    .tag(1)
                    
                    // Page 3: Optimal Timing
                    OnboardingPageView(
                        icon: "clock.circle.fill",
                        title: "Find Your Perfect Window",
                        subtitle: "Discover the best 10-minute departure window",
                        description: "For each day of the week, Time To Go analyzes your travel data to recommend the optimal 10-minute window to leave for the fastest, most reliable trip."
                    )
                    .tag(2)
                    
                    // Page 4: Insights & Analytics
                    OnboardingPageView(
                        icon: "chart.bar.fill",
                        title: "Comprehensive Insights",
                        subtitle: "Driving insights and traffic analytics",
                        description: "Get detailed driving insights including speed analysis, harsh braking detection, and comprehensive traffic insights to understand road conditions and optimize your routes."
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 500)
                
                Spacer()
                
                // Bottom section
                VStack(spacing: 20) {
                    // Page indicator dots
                    HStack(spacing: 8) {
                        ForEach(0..<pages, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(index == currentPage ? .blue : .gray.opacity(0.3))
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    // Action button
                    Button(action: {
                        if currentPage < pages - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        Text(currentPage < pages - 1 ? "Next" : "Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 30) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding(.top, 40)
            
            // Content
            VStack(spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

// MARK: - Drive Quality Explanation View
struct DriveQualityExplanationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How Drive Quality is Calculated")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.text)
                        
                        Text("A comprehensive analysis of your driving behavior using real-time sensor data")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    
                    // Overview Section
                    ExplanationSection(
                        title: "Algorithm Overview",
                        icon: "brain.head.profile",
                        content: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Our drive quality algorithm combines multiple data sources to provide a comprehensive assessment of your driving:")
                                    .font(.body)
                                
                                ForEach([
                                    "📱 Motion sensors (accelerometer, gyroscope)",
                                    "🗺️ GPS data (speed, location, route)",
                                    "🎤 Audio analysis (horn/siren detection)",
                                    "🚦 Traffic conditions and timing"
                                ], id: \.self) { item in
                                    Text(item)
                                        .font(.callout)
                                        .padding(.leading, 16)
                                }
                            }
                        }
                    )
                    
                    // Scoring Components
                    ExplanationSection(
                        title: "Scoring Components",
                        icon: "chart.bar.fill",
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                ScoreComponent(
                                    name: "Smooth Driving",
                                    weight: "40%",
                                    description: "Measures sudden accelerations, hard braking, and jerky movements using device motion sensors",
                                    color: .green
                                )
                                
                                ScoreComponent(
                                    name: "Speed Management",
                                    weight: "25%",
                                    description: "Evaluates adherence to speed limits and consistent speed maintenance",
                                    color: .blue
                                )
                                
                                ScoreComponent(
                                    name: "Traffic Adaptation",
                                    weight: "20%",
                                    description: "Assesses how well you handle slow traffic and congested conditions",
                                    color: .orange
                                )
                                
                                ScoreComponent(
                                    name: "Environmental Awareness",
                                    weight: "10%",
                                    description: "Considers phone usage, horn/siren events, and external factors",
                                    color: .purple
                                )
                                
                                ScoreComponent(
                                    name: "Route Efficiency",
                                    weight: "5%",
                                    description: "Evaluates path optimization and turn smoothness",
                                    color: .teal
                                )
                            }
                        }
                    )
                    
                    // Technical Details
                    ExplanationSection(
                        title: "Technical Implementation",
                        icon: "gearshape.2.fill",
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                TechnicalDetail(
                                    title: "Motion Analysis",
                                    details: [
                                        "Samples accelerometer data at 50Hz",
                                        "Applies low-pass filter to reduce noise",
                                        "Detects acceleration spikes > 0.3g",
                                        "Uses gyroscope for turn smoothness"
                                    ]
                                )
                                
                                TechnicalDetail(
                                    title: "GPS Processing",
                                    details: [
                                        "Updates location every 2 seconds",
                                        "Calculates real-time speed and direction",
                                        "Maps speed against regional limits",
                                        "Identifies traffic patterns"
                                    ]
                                )
                                
                                TechnicalDetail(
                                    title: "Audio Recognition",
                                    details: [
                                        "Real-time audio classification using Core ML",
                                        "Detects car horns with 85% accuracy",
                                        "Identifies emergency sirens",
                                        "Filters background noise automatically"
                                    ]
                                )
                            }
                        }
                    )
                    
                    // Score Calculation
                    ExplanationSection(
                        title: "Final Score Calculation",
                        icon: "function",
                        content: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("The final score is calculated using a weighted formula:")
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Score = (Smooth × 0.4) + (Speed × 0.25) + (Traffic × 0.2) + (Awareness × 0.1) + (Route × 0.05)")
                                        .font(.system(.body, design: .monospaced))
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                    
                                    Text("Each component is normalized to 0-100, then penalties are applied for:")
                                        .font(.callout)
                                    
                                    ForEach([
                                        "Hard braking events (-5 points each)",
                                        "Rapid acceleration (-3 points each)",
                                        "Phone usage during driving (-10 points)",
                                        "Excessive time in slow traffic (-2 points per minute)",
                                        "Horn usage in dense areas (-1 point each)"
                                    ], id: \.self) { penalty in
                                        Text("• \(penalty)")
                                            .font(.caption)
                                            .padding(.leading, 12)
                                    }
                                }
                            }
                        }
                    )
                    
                    // Quality Ranges
                    ExplanationSection(
                        title: "Quality Ratings",
                        icon: "star.fill",
                        content: {
                            VStack(spacing: 12) {
                                QualityRange(range: "90-100", label: "Excellent", description: "Exceptional driving with minimal events", color: .green)
                                QualityRange(range: "80-89", label: "Good", description: "Solid driving with minor improvements needed", color: .blue)
                                QualityRange(range: "70-79", label: "Average", description: "Acceptable driving with room for improvement", color: .orange)
                                QualityRange(range: "60-69", label: "Fair", description: "Some concerning driving behaviors detected", color: .yellow)
                                QualityRange(range: "0-59", label: "Poor", description: "Significant driving issues requiring attention", color: .red)
                            }
                        }
                    )
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Departure Time Explanation View
struct DepartureTimeExplanationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How We Find the Best Time to Leave")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.text)
                        
                        Text("Advanced temporal analysis to optimize your commute timing")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                    
                    // Algorithm Overview
                    ExplanationSection(
                        title: "Time Window Analysis",
                        icon: "clock.arrow.circlepath",
                        content: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Our algorithm analyzes your historical commute data to identify optimal departure windows:")
                                    .font(.body)
                                
                                ForEach([
                                    "⏰ Divides each day into 10-minute windows",
                                    "📊 Analyzes trip duration patterns",
                                    "🚦 Measures traffic impact per window",
                                    "🎯 Identifies consistent optimal times"
                                ], id: \.self) { item in
                                    Text(item)
                                        .font(.callout)
                                        .padding(.leading, 16)
                                }
                            }
                        }
                    )
                    
                    // Data Collection
                    ExplanationSection(
                        title: "Data Collection Process",
                        icon: "chart.line.uptrend.xyaxis",
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                DataCollectionStep(
                                    step: "1",
                                    title: "Trip Segmentation",
                                    description: "Each trip is categorized by day of week and departure time",
                                    technical: "Maps startTime to window index: (hour × 6) + (minute ÷ 10)"
                                )
                                
                                DataCollectionStep(
                                    step: "2",
                                    title: "Duration Tracking",
                                    description: "Records total trip time from start to destination",
                                    technical: "Measures endTime - startTime with GPS precision"
                                )
                                
                                DataCollectionStep(
                                    step: "3",
                                    title: "Traffic Analysis",
                                    description: "Calculates time spent in slow-moving traffic",
                                    technical: "Detects speeds < 15 km/h for > 30 seconds"
                                )
                                
                                DataCollectionStep(
                                    step: "4",
                                    title: "Pattern Recognition",
                                    description: "Identifies recurring delays and optimal windows",
                                    technical: "Requires minimum 3 trips per window for reliability"
                                )
                            }
                        }
                    )
                    
                    // Scoring Algorithm
                    ExplanationSection(
                        title: "Optimal Time Scoring",
                        icon: "function",
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Each 10-minute window receives a score based on:")
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    ScoreFormula(
                                        component: "Average Duration",
                                        weight: "60%",
                                        description: "Lower trip times score better"
                                    )
                                    
                                    ScoreFormula(
                                        component: "Traffic Time",
                                        weight: "40%",
                                        description: "Less slow traffic is heavily weighted"
                                    )
                                }
                                
                                Text("Final Formula:")
                                    .font(.headline)
                                    .padding(.top, 8)
                                
                                Text("Score = avgDuration + (avgTrafficTime × 2.0)")
                                    .font(.system(.body, design: .monospaced))
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Text("The window with the lowest score is recommended as optimal.")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.secondaryText)
                                    .italic()
                            }
                        }
                    )
                    
                    // Example Calculation
                    ExplanationSection(
                        title: "Example Calculation",
                        icon: "chart.bar.doc.horizontal",
                        content: {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Monday Morning Analysis:")
                                    .font(.headline)
                                
                                VStack(spacing: 8) {
                                    TimeWindowExample(
                                        time: "7:00-7:10",
                                        avgDuration: "28 min",
                                        trafficTime: "8 min",
                                        score: "44.0",
                                        isOptimal: false
                                    )
                                    
                                    TimeWindowExample(
                                        time: "7:10-7:20",
                                        avgDuration: "25 min",
                                        trafficTime: "5 min",
                                        score: "35.0",
                                        isOptimal: true
                                    )
                                    
                                    TimeWindowExample(
                                        time: "7:20-7:30",
                                        avgDuration: "32 min",
                                        trafficTime: "12 min",
                                        score: "56.0",
                                        isOptimal: false
                                    )
                                }
                                
                                Text("✅ Recommendation: Leave between 7:10-7:20 AM")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(.green)
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    )
                    
                    // Machine Learning
                    ExplanationSection(
                        title: "Adaptive Learning",
                        icon: "brain.head.profile",
                        content: {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("The algorithm continuously improves its recommendations:")
                                    .font(.body)
                                
                                ForEach([
                                    "🔄 Updates with each new trip",
                                    "📈 Weighs recent data more heavily",
                                    "🗓️ Accounts for seasonal patterns",
                                    "🚧 Adapts to route changes",
                                    "📊 Considers traffic variability"
                                ], id: \.self) { feature in
                                    Text(feature)
                                        .font(.callout)
                                        .padding(.leading, 16)
                                }
                                
                                Text("Minimum Data Requirements:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .padding(.top, 8)
                                
                                Text("• At least 5 trips on the same weekday\n• Minimum 3 trips in a specific time window\n• Data from last 30 days weighted most heavily")
                                    .font(.caption)
                                    .padding(.leading, 12)
                            }
                        }
                    )
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Helper Views for Explanations
struct ExplanationSection<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .font(.title2)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.text)
            }
            
            content()
        }
        .padding()
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ScoreComponent: View {
    let name: String
    let weight: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(weight)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(color.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
        }
    }
}

struct TechnicalDetail: View {
    let title: String
    let details: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            ForEach(details, id: \.self) { detail in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .foregroundColor(DesignSystem.Colors.primary)
                    Text(detail)
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                }
            }
        }
    }
}

struct QualityRange: View {
    let range: String
    let label: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Text(range)
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color)
                .cornerRadius(6)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
            
            Spacer()
        }
    }
}

struct DataCollectionStep: View {
    let step: String
    let title: String
    let description: String
    let technical: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(step)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(DesignSystem.Colors.primary)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.text)
                
                Text(technical)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
                    .italic()
            }
        }
    }
}

struct ScoreFormula: View {
    let component: String
    let weight: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(component)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.secondaryText)
            }
            
            Spacer()
            
            Text(weight)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(DesignSystem.Colors.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(DesignSystem.Colors.primary.opacity(0.2))
                .cornerRadius(4)
        }
    }
}

struct TimeWindowExample: View {
    let time: String
    let avgDuration: String
    let trafficTime: String
    let score: String
    let isOptimal: Bool
    
    var body: some View {
        HStack {
            Text(time)
                .font(.system(.caption, design: .monospaced))
                .frame(width: 80, alignment: .leading)
            
            Text(avgDuration)
                .font(.caption)
                .frame(width: 50, alignment: .center)
            
            Text(trafficTime)
                .font(.caption)
                .frame(width: 50, alignment: .center)
            
            Text(score)
                .font(.system(.caption, design: .monospaced))
                .frame(width: 40, alignment: .trailing)
            
            if isOptimal {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            } else {
                Spacer()
                    .frame(width: 16)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isOptimal ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(6)
    }
}

#Preview {
    ContentView()
}