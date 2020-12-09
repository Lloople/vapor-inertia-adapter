import VaporInertiaAdapter
import XCTVapor

class InertiaTest: XCTestCase {
    
    var app: Application!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        
        app.get("test") { req -> EventLoopFuture<Response> in
            
            return self.app.inertia.render("MyComponent", ["alive": true]).encodeResponse(for: req)
        }
    }
    
    override func tearDownWithError() throws {
        self.app.shutdown()
    }
    
    func testSingletonPatternWorks() {
        let inertia = self.app.inertia
        let another = self.app.inertia
        
        XCTAssertTrue(inertia === another)
    }
    
    func testVersionCanBeSetFromOutside() {
        XCTAssertFalse(self.app.inertia.version == "my-version")
        
        self.app.inertia.version = "my-version"
        
        XCTAssertTrue(self.app.inertia.version == "my-version")
    }
    
    func testCanShareVariables() {
        self.app.inertia.share(key: "language", value: "en")
        
        XCTAssertEqual(1, self.app.inertia.getAllShared().count)
        
        XCTAssertEqual(self.app.inertia.getShared(key: "language") as? String, "en")
    }
    
    func testCanCreateRedirection() {
        let response = self.app.inertia.location(url: "https://myurl.com")
        
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
        })
    }
}
