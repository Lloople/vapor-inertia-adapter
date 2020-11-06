import XCTest
import Vapor
import VaporInertiaAdapter
import XCTVapor

final class InertiaMiddlewareTest: XCTestCase {
    
    var app: Application!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        
        app.middleware.use(InertiaMiddleware())
        
        app.get("ok") { req -> Response in
            return Response(status: .ok)
        }
        
        app.put("found") { req -> Response in
            return Response(status: .found)
        }
        
        app.get("found") { req -> Response in
            return Response(status: .found)
        }
        
        app.put("not-modified") { req -> Response in
            return Response(status: .notModified)
        }
    }
    
    override func tearDownWithError() throws {
        self.app.shutdown()
    }
    
    func testDoesNothingWithoutInertiaHeaders() throws {
        try app.test(.GET, "ok", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
        })
    }
    
    func testReturnsConflictWhenVersionExpired() throws {
        try app.test(.GET, "ok", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "1")
            request.headers.add(name: "X-Inertia-Version", value: "expired-version")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .conflict)
            XCTAssertEqual(response.body, ByteBuffer())
            XCTAssertEqual(response.headers.first(name:"X-Inertia-Location"), "/ok")
        })
    }
    
    func testDoesNotReturnConflictWhenVersionExpiredButMethodIsNotGet() throws {
        
        try app.test(.PUT, "not-modified", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "1")
            request.headers.add(name: "X-Inertia-Version", value: "expired-version")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notModified)
            XCTAssertFalse(response.headers.contains(name: "X-Inertia-Location"))
        })
    }
    
    func testReplacesFoundWithSeeOther() throws {
        try app.test(.PUT, "found", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "1")
            
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .seeOther)
        })
    }
    
    func testDoesNotReplaceFoundIfTheMethodIsNotCorrect() throws {
        
        Inertia.instance.version = "testing"
        
        try app.test(.GET, "found", beforeRequest: { request in
            request.headers.add(name: "X-inertia", value: "1")
            request.headers.add(name: "X-Inertia-Version", value: "testing")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .found)
        })
        
    }
    
    func testDoesNotReplaceFoundIfTheHeaderIsNotPresent() throws {

        try app.test(.PUT, "found", afterResponse: { response in
            XCTAssertEqual(response.status, .found)
        })
        
    }
    
    func testDoesNotReplaceFoundIfTheResponseStatusIsNotFound() throws {
        
        try app.test(.PUT, "not-modified", beforeRequest: { request in
            request.headers.add(name: "X-Inertia", value: "1")
        }, afterResponse: { response in
            XCTAssertEqual(response.status, .notModified)
        })
    }
}
