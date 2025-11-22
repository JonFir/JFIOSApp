import Foundation
import Logger
import FactoryKit

/// Shared encoder and decoder for PropertyList serialization.
private enum PropertyListCoders {
    static let encoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        return encoder
    }()
    
    static let decoder = PropertyListDecoder()
}

/// Property wrapper that automatically persists Codable values to a file using PropertyList format.
///
/// FilePersistence reads values from a file on first access if no in-memory value exists,
/// and writes values to a file whenever the property is set. The file location is determined
/// by combining the provided directory URL with the filename.
/// All file operations are logged using the injected Logger instance from Container.
///
/// Example usage:
/// ```swift
/// struct UserSettings: Codable {
///     var theme: String
///     var fontSize: Int
/// }
///
/// class AppConfig {
///     let persistenceDir: URL
///     
///     @FilePersistence(
///         filename: "user_settings.plist",
///         directoryURL: persistenceDir,
///         defaultValue: UserSettings(theme: "light", fontSize: 14)
///     )
///     var userSettings: UserSettings
///     
///     @FilePersistence(
///         filename: "required_data.plist",
///         directoryURL: persistenceDir,
///         defaultValue: SomeData.default
///     )
///     var requiredData: SomeData
/// }
/// ```
@propertyWrapper
public struct FilePersistence<Value: Codable> {
    /// Wrapper for PropertyList encoding.
    ///
    /// PropertyListEncoder requires top-level values to be dictionaries or arrays.
    /// Primitive types like String, Int, Bool cannot be encoded directly.
    /// This wrapper allows encoding any Codable type by wrapping it in a structure.
    private struct Wrapper: Codable {
        let value: Value
    }
    
    private let filename: String
    private let directoryURL: URL
    private let defaultValue: Value
    private var cachedValue: Value?
    
    @Injected(\.logger) private var logger: Logger?
    
    private var fileURL: URL {
        directoryURL.appendingPathComponent(filename)
    }
    
    /// Creates a new file persistence property wrapper.
    ///
    /// Logger is automatically injected via @Inject from Container.
    ///
    /// - Parameters:
    ///   - filename: Name of the file to store the value in (should use .plist extension)
    ///   - directoryURL: Directory where the file will be stored
    ///   - defaultValue: Default value used when file doesn't exist or can't be read
    ///
    /// Example:
    /// ```swift
    /// @FilePersistence(
    ///     filename: "config.plist",
    ///     directoryURL: settingsProvider.initialSettings.persistenceDirectory,
    ///     defaultValue: Config.default
    /// )
    /// var config: Config
    /// ```
    public init(
        filename: String,
        directoryURL: URL,
        defaultValue: Value
    ) {
        self.filename = filename
        self.directoryURL = directoryURL
        self.defaultValue = defaultValue
        self.cachedValue = nil
    }
    
    public var wrappedValue: Value {
        mutating get {
            if let cached = cachedValue {
                logger?.debug(
                    "Using cached value",
                    category: .system,
                    module: "LibSwift",
                    parameters: ["filename": filename]
                )
                return cached
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                let wrapper = try PropertyListCoders.decoder.decode(Wrapper.self, from: data)
                cachedValue = wrapper.value
                logger?.debug(
                    "Successfully read from file",
                    category: .system,
                    module: "LibSwift",
                    parameters: ["filename": filename, "path": fileURL.path]
                )
                return wrapper.value
            } catch {
                logger?.critical(
                    "Failed to read file",
                    category: .system,
                    module: "LibSwift",
                    parameters: ["filename": filename, "path": fileURL.path, "error": error.localizedDescription]
                )
                logger?.debug(
                    "Using default value after read error",
                    category: .system,
                    module: "LibSwift",
                    parameters: ["filename": filename]
                )
                cachedValue = defaultValue
                return defaultValue
            }
        }
        
        mutating set {
            cachedValue = newValue
            
            do {
                try FileManager.default.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true
                )
                
                let wrapper = Wrapper(value: newValue)
                let data = try PropertyListCoders.encoder.encode(wrapper)
                try data.write(to: fileURL, options: .atomic)
                
                logger?.debug(
                    "Successfully written to file",
                    category: .system,
                    module: "LibSwift",
                    parameters: ["filename": filename, "path": fileURL.path]
                )
            } catch {
                logger?.critical(
                    "Failed to write file",
                    category: .system,
                    module: "LibSwift",
                    parameters: ["filename": filename, "path": fileURL.path, "error": error.localizedDescription]
                )
            }
        }
    }
}

