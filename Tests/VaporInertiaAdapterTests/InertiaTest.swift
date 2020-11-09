import VaporInertiaAdapter
import XCTVapor

class InertiaTest: XCTestCase {
    
    var app: Application!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        
        app.get("test") { req throws -> EventLoopFuture<Response> in
            
            let component = Component(name: "MyComponent", properties: ["alive": true])
            
            return try Inertia.instance().render(for: req, with: component)
        }
    }
    
    override func tearDownWithError() throws {
        self.app.shutdown()
    }
    
    func testSingletonPatternWorks() {
        let inertia = Inertia.instance()
        let another = Inertia.instance()
        
        XCTAssertTrue(inertia === another)
    }
    
    func testVersionCanBeSetFromOutside() {
        XCTAssertFalse(Inertia.instance().version == "my-version")
        
        Inertia.instance().version = "my-version"
        
        XCTAssertTrue(Inertia.instance().version == "my-version")
    }
    
    func testContainerCanBeRenderer() throws {
        let component = Component(name: "Event/Show", properties: ["name": "Climate Change Global Action"])
        let content = try component.toJson()
        let container = Inertia.instance().container(content:content)
        
        XCTAssertEqual(container, "<div id='app' data-page='\(content)'></div>")
    }
    
    func testCanShareVariables() {
        Inertia.instance().share(key: "language", value: "en")
        
        XCTAssertEqual(1, Inertia.instance().getAllShared().count)
        
        XCTAssertEqual(Inertia.instance().getShared(key: "language") as? String, "en")
    }
    
    func testCanCreateRedirection() {
        let response = Inertia.instance().location(url: "https://myurl.com")
        
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
