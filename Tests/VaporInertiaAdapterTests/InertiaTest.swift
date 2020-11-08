import XCTest
import VaporInertiaAdapter
import Vapor

class InertiaTest: XCTestCase {
    
    func testSingletonPatternWorks() {
        let inertia = Inertia.instance()
        let another = Inertia.instance()
        
        XCTAssertTrue(inertia === another)
    }
    
}
