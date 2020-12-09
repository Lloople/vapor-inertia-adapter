import Vapor

extension Application {

    public class Inertia {
        
        let app: Application
                        
        public var rootView: String = "index"
        
        public var version: String = "no-version-configured"
        
        init(app: Application) {
            self.app = app
            
            self.app.leaf.tags["inertia"] = InertiaContainerTag()
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
            
            return InertiaResponse(
                component: name,
                properties: properties,
                rootView: self.rootView,
                version: self.version
            )
        }
    }
    
    public var inertia: Inertia {
        .init(app: self)
    }

}
