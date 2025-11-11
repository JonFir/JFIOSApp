import ProjectDescription

public enum Constants {
    public static let appName = "LLIos"
    public static let modulesFolder = "\(appName)"
    public static let moduleType = Product.framework
    public static let remoteDependenciesType = Product.framework
    public static let bundleId = "academy.lazyload" + ".\(appName)"
    public static let qaConfigurationName = ConfigurationName(stringLiteral: "QA") 
}
