// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AWSSigner",
    products: [
        .library(name: "AWSSigner", targets: ["AWSSigner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client", .upToNextMajor(from: "1.0.0-alpha.1"))
    ],
    targets: [
        .target(name: "AWSSigner", dependencies: ["AsyncHTTPClient"]),
        .testTarget(name: "AWSSignerTests", dependencies: ["AWSSigner"]),
    ]
)

// switch for whether to use CAWSSDKOpenSSL to shim between OpenSSL versions
#if os(Linux)
let useOpenSSLShim = true
#else
let useOpenSSLShim = false
#endif

// AWSSDKSwiftCore target
let awsSdkSwiftCoreTarget = package.targets.first(where: {$0.name == "AWSSigner"})

// Decide on where we get our SSL support from. Linux usses NIOSSL to provide SSL. Linux also needs CAWSSDKOpenSSL to shim across different OpenSSL versions for the HMAC functions.
if useOpenSSLShim {
    package.targets.append(.target(name: "CAWSSigner"))
    awsSdkSwiftCoreTarget?.dependencies.append("CAWSSigner")
    package.dependencies.append(.package(url: "https://github.com/apple/swift-nio-ssl-support.git", from: "1.0.0"))
}
