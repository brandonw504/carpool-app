import UIKit
import PusherSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PusherDelegate {
    // You must retain a strong reference to the Pusher instance
    var pusher: Pusher!

    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

      let options = PusherClientOptions(
        host: .cluster("us3")
      )

      pusher = Pusher(
        key: "3270f926804e72e9cb55",
        options: options
      )

      pusher.delegate = self

      // subscribe to channel
      let channel = pusher.subscribe("my-channel")

      // bind a callback to handle an event
      let _ = channel.bind(eventName: "my-event", eventCallback: { (event: PusherEvent) in
          if let data = event.data {
            // you can parse the data as necessary
            print(data)
          }
      })

      pusher.connect()

      return true
    }

    // print Pusher debug messages
    func debugLog(message: String) {
      print(message)
    }
}
