import XCTest
import VaporInertiaAdapter
import Vapor

class InertiaResponseTest: XCTestCase {
    
    func testItReturnsJsonResponseIfHeaderIsPresent() throws {
        let app: Application = Application(.testing)
        
        defer { app.shutdown() }
        
        app.get("test") { req -> EventLoopFuture<Response> in
            
            let component = Component(name: "FirstComponent", properties: ["first": "value"])
            let response = InertiaResponse(component: component, rootView: "index", version: "1.0.0")
            
            return try response.toResponse(for: req)
            // ERROR: *** +[NSJSONSerialization dataWithJSONObject:options:error:]: Invalid top-level type in JSON write (NSInvalidArgumentException)
        }
        
        try app.test(.GET, "test", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "true")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
        })

    }
}
