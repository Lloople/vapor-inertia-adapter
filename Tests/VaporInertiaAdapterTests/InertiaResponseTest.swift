import VaporInertiaAdapter
import XCTVapor

class InertiaResponseTest: XCTestCase {
    
    var app: Application!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        
        app.get("test") { req -> EventLoopFuture<Response> in
            
            let component = Component(name: "FirstComponent", properties: ["first": "value"])
            
            return InertiaResponse(component: component, rootView: "index", version: "1.0.0")
                .encodeResponse(for: req)
        }
    }
    
    override func tearDownWithError() throws {
        self.app.shutdown()
    }
    
    func testItReturnsJsonResponseIfHeaderIsPresent() throws {
        
        try self.app.test(.GET, "test", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "true")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.first(name: "Vary"), "Accept")
            XCTAssertEqual(response.headers.first(name: "X-Inertia"), "true")
        })

    }
    
}
