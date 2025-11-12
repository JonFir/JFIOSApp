import Swinject
import FirstModuleImpl
import LoggerImpl

public let assembler = Assembler([
    FirstModuleAssembly(),
    LoggerAssembly(),
])
