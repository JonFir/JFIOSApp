import SwiftUI

@MainActor
protocol FirstModuleViewModel: Observable, AnyObject {
    var title: String { get }
}
