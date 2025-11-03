import UIKit

let container = Container()

public func run() {
    autoreleasepool {
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            NSStringFromClass(Application.self),
            NSStringFromClass(ApplicationDelegate.self)
        )
    }
}
