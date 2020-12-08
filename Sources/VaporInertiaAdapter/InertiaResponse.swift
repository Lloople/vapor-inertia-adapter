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
        
        self.component.properties.merge([
            "errors": [:],
            "flash": [
                "success": nil,
                "error": nil
            ],
            "auth": ["user": nil]
        ]) { (original, _) in original }
        
        guard let context = try? self.getContext(request) else {
            return request.eventLoop.future(self.getErrorResponse())
        }
        
        let json = String(data: context, encoding: .utf8) ?? ""
        
        if !request.isInertia() {
            return request.view.render(self.rootView, ["json": json])
                .flatMap { $0.encodeResponse(for: request) }
        }
        
        do {
            let response: Response = .init(
                status: .ok,
                headers: .init(self.inertiaHeaders)
            )
            
            try response.content.encode(json, as: .json)
        
            return request.eventLoop.future(response)
        } catch {
            return request.eventLoop.future(self.getErrorResponse())
        }
        
        
        
    }
    
    private func getContext(_ request: Request) throws -> Data {
        return try JSONSerialization.data(withJSONObject: [
            "component": self.component.getName(),
            "props": self.component.getProperties(),
            "version": self.version,
            "url": request.url.string
        ])
    }
    
    private func getErrorResponse() -> Response {
        return .init(
            status: .internalServerError,
            headers: .init(self.inertiaHeaders),
            body: .init(string: "Component could not be encoded to JSON object.")
        )
    }
    
}
