import Foundation

public class Component: JSONSerialization {
    
    let name: String
    var properties: [String:Any]
    
    public init(name: String, properties: [String:Any]) {
        self.name = name
        self.properties = properties
    }
    
    public func with(name: String, property: Any) -> Self {
        self.properties[name] = property
        
        return self
    }
}
