import XCTest
import VaporInertiaAdapter
import Vapor

class InertiaTest: XCTestCase {
    
    func testSingletonPatternWorks() {
        let inertia = Inertia.instance()
        let another = Inertia.instance()
        
        XCTAssertTrue(inertia === another)
    }
    
    func testVersionCanBeSetFromOutside() {
        XCTAssertFalse(Inertia.instance().version == "my-version")
        
        Inertia.instance().version = "my-version"
        
        XCTAssertTrue(Inertia.instance().version == "my-version")
    }
    
    func testContainerCanBeRenderer() throws {
        let component = Component(name: "Event/Show", properties: ["name": "Climate Change Global Action"])
        let content = try JSONSerialization.data(withJSONObject: component.toJson())
        let container = Inertia.instance().container(content:content)
        
        XCTAssertEqual(container, "<div id='app' data-page='\(content)'></div>")
    }
}
