import Vapor

public class InertiaResponse: ResponseEncodable {
    
    let component: Component
    let rootView: String
    let version: String
    
    let inertiaHeaders: [(String, String)] = [("Vary", "Accept"), ("X-Inertia", "true")]
    
    public init(component: Component, rootView: String, version: String) {
        self.component = component
        self.rootView = rootView
        self.version = version
    }
    
    public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
        
        guard let json = try? self.component.toJson() else {
            return request.eventLoop.future(self.getErrorResponse())
        }
        
        let context = InertiaContext(
            component: json,
            version: self.version,
            url: request.url.string
        )
        
        if request.isInertia() {
            do {
                let response: Response = .init(
                    status: .ok,
                    headers: .init(self.inertiaHeaders)
                )
                
                try response.content.encode(context, as: .json)
            
                return request.eventLoop.future(response)
            } catch {
                return request.eventLoop.future(self.getErrorResponse())
            }
        }
        
        return request.view.render(self.rootView, context)
            .flatMap { $0.encodeResponse(for: request) }
    }
    
    private func getErrorResponse() -> Response {
        return .init(
            status: .internalServerError,
            headers: .init(self.inertiaHeaders),
            body: .init(string: "Component could not be encoded to JSON object.")
        )
    }
    
}
