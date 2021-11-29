# Services

This file contians all of the service logic. Each `abstract` service will require a specific `concrete` service. This is to help with testability.

Each service should also have a `completionHandler` function and an `async` function. Completion handler for backwards compatibility and async for later versions of iOS.

Each service should also fully embrace/follow the Single Responsibilty Principle.

### AuthService

This service is used for authentication. 
