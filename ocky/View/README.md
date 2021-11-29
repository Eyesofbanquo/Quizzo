# Views Explained!

***

## Entrypoint.swift

This file is the starting point of the app. It has a button where pressing it signs you into `Game Center` if you haven't already signed in and auto signs in if your session is still available.

This file splits into two paths: `MLGameAuthViewRepresentable` and `GameViewRepresentable`. Both are `UIViewRepresentable` files that link back to `UIKit`.

## MLGameAuthView.swift

This file is a representable that handles the login logic with `Game Center`.

This file has a state handler that relies on `Combine` and `MLGameAuthState` to determine the current state of `MLGameAuthView`.

 * If the app hasn't received input then it will display the `MainView`. Later this can probably be ported over into a sheet that will launch multiplayer.
 * If the app has been authenticated then it will replace `MLGameAuthView` with the `GameRepresentable.swift` file.
 

## GameView.swift

This file contains the logic for the view once you reach the screen containing. It is controlled by the Representable which contains the GameViewController

**Find Match** | **Load Matches**.

**This view in the future should be renamed to MultiplayerView.swift**

## MultiplayerMainView.swift

This is the view that corresponds with the `.idle` state for the `MLGameState` 
