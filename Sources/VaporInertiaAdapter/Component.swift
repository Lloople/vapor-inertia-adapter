import Foundation

public class Component {
    
    let name: String
    var properties: [String:Any]
    
    public init(name: String, properties: [String:Any] = [:]) {
        self.name = name
        self.properties = properties
    }
    
    public func with(key: String, value: Any) {
        self.properties[key] = value
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getProperties() -> [String:Any] {
        return self.properties
    }
    
    public func toJson() throws -> Data {
        return try JSONSerialization.data(withJSONObject: [
            "component": self.name,
            "props": self.properties
        ])
    }
}
