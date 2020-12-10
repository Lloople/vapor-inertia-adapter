import VaporInertiaAdapter
import XCTVapor

class InertiaTest: XCTestCase {
    
    var app: Application!
    
    var request: Request!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        
        app.get("test") { req -> EventLoopFuture<Response> in
            
            return req.inertia.render("MyComponent", ["alive": "true"]).encodeResponse(for: req)
        }
        
        self.request = Request(application: self.app, on: self.app.eventLoopGroup.next())
    }
    
    override func tearDownWithError() throws {
        self.app.shutdown()
    }
    
    func testSingletonPatternWorks() {
        
        let inertia = self.request.inertia
        let another = self.request.inertia
        
        XCTAssertTrue(inertia === another)
    }
    
    func testVersionCanBeSetFromOutside() {
        XCTAssertFalse(self.request.inertia.version == "my-version")
        
        self.request.inertia.version = "my-version"
        
        XCTAssertTrue(self.request.inertia.version == "my-version")
    }
    
    func testCanShareVariables() {
        self.request.inertia.share(key: "language", value: "en")
        
        XCTAssertEqual(1, self.request.inertia.getAllShared().count)
        
        XCTAssertEqual(self.request.inertia.getAllShared()["language"], "en")
    }
    
    func testCanCreateRedirection() {
        let response = self.request.inertia.location(url: "https://myurl.com")
        
        XCTAssertEqual(response.status, .conflict)
        XCTAssertEqual(response.headers.first(name:"X-Inertia-Location"), "https://myurl.com")
    }
    
    func testCanRenderComponent() throws {
        
        try self.app.test(.GET, "test", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "true")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.first(name: "Vary"), "Accept")
            XCTAssertEqual(response.headers.first(name: "X-Inertia"), "true")
            // TODO: Test the body of the response
        })
    }
}
