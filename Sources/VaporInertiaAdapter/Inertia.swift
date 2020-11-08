import Vapor

public class Inertia {
    
    static let inertiaInstance = Inertia()
    
    var shared: [String: Any] = [:]
    
    var rootView: String = "index"
    
    public var version: String = "no-version-configured"
    
    private init() {}
    
    public static func instance() -> Inertia {
        return inertiaInstance
    }
    
    public func container(content: Data) -> String {
        return "<div id='app' data-page='\(content)'></div>"
    }
    
    public func share(key: String, value: Encodable) -> Self {
        self.shared[key] = value
        
        return self
    }
    
    public func getShared(key: String) -> Any? {
        return self.shared[key]
    }
    
    public func location(url: String) -> Response {
        return Response(
            status: .conflict,
            headers: .init([("X-Inertia-Location", url)]),
            body: .empty
        )
    }
    
    public func render(component: Component) -> InertiaResponse {

        component.properties.merge(self.shared) { (_, shared) in shared }
        
        return InertiaResponse(
            component: component,
            rootView: self.rootView,
            version: self.version
        )
    }
}
