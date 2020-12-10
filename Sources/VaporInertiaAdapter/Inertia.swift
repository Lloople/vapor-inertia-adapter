import Vapor

public class Inertia {
    
    let request: Request
                    
    public var rootView: String = "index"
    
    public var version: String = "no-version-configured"
    
    var shared: [String:String] = [:]
    
    init(_ request: Request) {
        self.request = request
    }
    
    public func setVersion(_ version: String) -> Void {
        self.version = version
    }
    
    public func share(key: String, value: String) -> Void {
        self.shared[key] = value
    }
    
    public func getAllShared() -> [String:String] {
        return self.shared
    }
    
    public func location(url: String) -> Response {
        return .init(
            status: .conflict,
            headers: .init([("X-Inertia-Location", url)]),
            body: .empty
        )
    }
    
    public func render(_ name: String, _ properties: [String:String]) -> InertiaResponse
    {
        var props = properties
        
        props.merge(self.shared) { (_, shared) in shared }
        
        return InertiaResponse(
            component: name,
            properties: props,
            rootView: self.rootView,
            version: self.version
        )
    }
    
}
