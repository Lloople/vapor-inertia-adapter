import XCTest
import VaporInertiaAdapter

class ComponentTest: XCTestCase {
    
    func testComponentCanBeDeclaredWithAnyProperty() {
        let c = self.createComponent()
        
        XCTAssertEqual(c.getName(), "FirstComponent")
        XCTAssertEqual(c.getProperties().count, 3)
    }
    
    func testComponentCanBeConvertedToJson() throws {
        let component = self.createComponent()
        
        let json = try JSONSerialization.jsonObject(with: component.toJson(), options: []) as? [String:Any]
        
        let properties = json?["props"] as? [String: Any]

        XCTAssertEqual(json?["component"] as? String, "FirstComponent")
        
        XCTAssertEqual(properties?["name"] as? String, "John")
        XCTAssertEqual(properties?["age"] as? Int, 34)
        XCTAssertEqual(properties?["alive"] as? Bool, true)
    }
    

    func testPropertiesCanBeAddedToComponent() throws {
        let component = Component(name: "FirstComponent")

        XCTAssertEqual(component.getProperties().count, 0)

        component.with(key: "name", value: "Alfred")

        XCTAssertEqual(component.getProperties().count, 1)
        
        let json = try JSONSerialization.jsonObject(with: component.toJson(), options: []) as? [String:Any]
        let properties = json?["props"] as? [String: AnyObject]
        
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
