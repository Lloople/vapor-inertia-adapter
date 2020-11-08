# Vapor Inertia Adapter

<p align="center">
    <a href="https://vapor.codes">
        <img src="http://img.shields.io/badge/Vapor-4-brightgreen.svg" alt="Vapor Logo">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/Swift-5.2-brightgreen.svg" alt="Swift 5.2 Logo">
    </a>
    <a href="https://github.com/lloople/vapor-inertia-adapter/actions">
        <img src="https://github.com/lloople/vapor-inertia-adapter/workflows/Swift/badge.svg?branch=main" alt="Build Status">
    </a>
    <a href="https://raw.githubusercontent.com/lloople/vapor-inertia-adapter/main/LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License">
    </a>
</p>

This package is meant to help you using [Inertia JS](https://inertiajs.com) in your Vapor 4 project.

## Installation

Add the adapter in your dependencies array in **Package.swift**:

```swift
dependencies: [
    // ...,
    .package(name: "VaporInertiaAdapter", url: "https://github.com/lloople/vapor-inertia-adapter.git", from: "1.0.0")
],
```

Also ensure you add it as a dependency to your target:

```swift
targets: [
    .target(name: "App", dependencies: [
        .product(name: "Vapor", package: "vapor"), 
        // ..., 
        "VaporInertiaAdapter"]),
    // ...
]
```

## Usage

### Middleware

This package provides a middleware that checks the responses before returning them to the client for further adjustements. You should apply this middleware to all your application routes in **configure.swift**:

```swift
app.middleware.use(InertiaMiddleware())
```

### Version

Inertia will reload the whole page when it detects the assets changed. This is handled by a version token sent from the server. When the client detects that the previous token it has is different from the one returned from the server, it knows it's time to download the assets again.

This version token should be configured in **configure.swift**:

```swift
Inertia.instance().version = "v1.0.1"
```

Ideally, you should use some kind of hash generated via your assets files, or change it manually in each update of your CSS or JS files.

### Creating responses

> TODO: Explain what `Inertia.instance().render` will do: view or json

```swift

struct EventsController
public func show(req: Request) -> EventLoopFuture<Response> {

    return Event.query(on: req.db)
        .filter(\.$id == req.parameters.get("eventId", as: Int)
        .first()
        .unwrap(or: Abort(.notFound))
        .map { event in
            return Inertia.instance().render(
                Component(
                    name: "Event/Show", 
                    properties: [
                        "event" : event,
                        "categories": ["Social", "Climate Change", "Studies"]
                    ]
                )
        }
}
```
