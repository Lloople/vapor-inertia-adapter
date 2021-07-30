import Vapor

public class InertiaResponse: ResponseEncodable
{
    
    let component: String
    let properties: [String:Any]
    let rootView: String
    let version: String
    
    let inertiaHeaders: [(String, String)] = [("Vary", "Accept"), ("X-Inertia", "true"), ("Content-Type", "application/json")]
    
    public init(component: String, properties: [String:Any], rootView: String, version: String) {
        self.component = component
        self.properties = properties
        self.rootView = rootView
        self.version = version
    }
    
    public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {

        // this is what I need to send to the view or the JSON response
        guard let json = try? JSONSerialization.data(withJSONObject:[
            "component": self.component,  // String
            "props": self.properties,     // Dictionary key:value, can be anything, even dictionaries inside dictionaries
            "version": self.version,      // String
            "url": request.url.string     //String
        ], options: []) else {
            return request.eventLoop.future(self.getErrorResponse())
        }

        let jsonString = String(decoding: json, as: UTF8.self)
        
        // The route was directly accessed from the browser
        // must render the view using leaf and setting the json
        // as a param
        if !request.isInertia() {
            let jsonprop : [String: String] = ["json": jsonString]
            return request.view.render(self.rootView, jsonprop)
                .flatMap { $0.encodeResponse(for: request) }
        }

        // We received a request from Inertia to load a component
        // must return a json with the proper params
        let response: Response = .init(
                status: .ok,
                headers: .init(self.inertiaHeaders),
                body: .init(string: jsonString)
        )

        return request.eventLoop.makeSucceededFuture(response)
    }
    
    private func getErrorResponse() -> Response {
        return .init(
            status: .internalServerError,
            headers: .init(self.inertiaHeaders),
            body: .init(string: "{\"error\":\"Component could not be encoded to JSON object.\"}")
        )
    }
    
}
