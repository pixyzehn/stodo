import XCTest
import Quick

@testable import TodoTests

Quick.QCKMain([
    ActionTypeSpec.self,
    KeyedArchiverSpec.self
])
