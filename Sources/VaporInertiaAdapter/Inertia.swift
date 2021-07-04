import Vapor

public class Inertia {

    static let sharedInstance = Inertia()

    public var rootView: String = "index"
    
    public var version: String = "no-version-configured"
    
    var shared: [String:Any] = [:]
    
    public static func instance() -> Inertia {
        return sharedInstance
    }

    public func setVersion(_ version: String) -> Void {
        self.version = version
    }
    
    public func share(key: String, value: Any) -> Void {
        self.shared[key] = value
    }

    public func share(_ dict : [String: Any]) -> Void {
        self.shared = dict
    }
    
    public func sharedData() -> [String:Any] {
        return self.shared
    }
    
    public func location(url: String) -> Response {
        return .init(
            status: .conflict,
            headers: .init([("X-Inertia-Location", url)]),
            body: .empty
        )
    }
    
    public func render(_ name: String, _ properties: [String:Any]) -> InertiaResponse
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

    public func render(_ name: String, _ properties: [String:Any], for req:Request) -> EventLoopFuture<Response>
    {
        return self.render(name, properties).encodeResponse(for:req)
    }
    
}
