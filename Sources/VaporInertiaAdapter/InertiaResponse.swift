import Vapor

public class InertiaResponse: ResponseEncodable
{
    
    let component: String
    let properties: [String:String]
    let rootView: String
    let version: String
    
    let inertiaHeaders: [(String, String)] = [("Vary", "Accept"), ("X-Inertia", "true")]
    
    public init(component: String, properties: [String:String], rootView: String, version: String) {
        self.component = component
        self.properties = properties
        self.rootView = rootView
        self.version = version
    }
    
    public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
        

//        this is what I need to send to the view or the JSON response
        guard let json = try? JSONEncoder().encode([
            "component": self.component,  // String
            "props": "[]",//self.properties,     // Dictionary key:value, can be anything, even dictionaries inside dictionaries, String for now...
            "version": self.version,      // String
            "url": request.url.string     //String
        ]) else {
            return request.eventLoop.future(self.getErrorResponse())
        }
        
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
    
    private func getErrorResponse() -> Response {
        return .init(
            status: .internalServerError,
            headers: .init(self.inertiaHeaders),
            body: .init(string: "Component could not be encoded to JSON object.")
        )
    }
    
}
