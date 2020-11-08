import XCTest
import VaporInertiaAdapter

class ComponentTest: XCTestCase {
    
    func testComponentCanBeDeclaredWithAnyProperty() {
        let c = self.createComponent()
        
        XCTAssertEqual(c.getName(), "FirstComponent")
        XCTAssertEqual(c.getProperties().count, 3)
    }
    
    func testComponentCanBeConvertedToJson() {
        let component = self.createComponent()
        
        let json = component.toJson() as? [String: AnyObject]
        let properties = json?["properties"] as? [String: AnyObject]
        
        XCTAssertEqual(json?["name"] as? String, "FirstComponent")
        
        XCTAssertEqual(properties?["name"] as? String, "John")
        XCTAssertEqual(properties?["age"] as? Int, 34)
        XCTAssertEqual(properties?["alive"] as? Bool, true)
    }
    

    func testPropertiesCanBeAddedToComponent() {
        let component = Component(name: "FirstComponent")

        XCTAssertEqual(component.getProperties().count, 0)

        component.with(key: "name", value: "Alfred")

        XCTAssertEqual(component.getProperties().count, 1)
        
        let json = component.toJson() as? [String: AnyObject]
        let properties = json?["properties"] as? [String: AnyObject]
        
        XCTAssertEqual(properties?["name"] as? String, "Alfred")


    }
    
    private func createComponent() -> Component {
        return Component(
            name: "FirstComponent",
            properties: [
                "name": "John",
                "age": 34,
                "alive": true
            ]
        )
    }
    
}
