# Ride Assure

## Goal: Enable users to carpool with each other, even if they don't know each other.
- It can be a one-time ride, or the start of a long-term carpool agreement between strangers.
- For one-time rides in particular, riders would pay drivers depending on the length of the ride and the detour required.
- For very long drives with a small detour, the driver wouldn't expect a large payment, while the rider would probably be willing to pay a lot for the convenience.
  - There is a large difference in these two price expectations that could be profited from.
- For example: If someone is commuting to work and someone else needs to go to the grocery store, they may need to follow very similar paths. It would be useful and environmentally friendly for the commuter to pick up and drop off the shopper, provided it is not much of a detour.

## Use
1. Settings for drivers:
   - Maximum number of riders
   - Maximum detour length
   - Whether they're willing to exit a freeway for a pickup
2. Settings for riders:
   - Whether they're willing to walk to a spot to make pickup easier
3. Drivers will enter their destination, turn on searching for riders on the app, and start driving.
4. When a rider is found, the driver will be notified and re-routed to the pickup.
5. The driver will drop the rider off, and continue to their destination.
6. The fee will be calculated based on the difficulty of pickup/dropoff (variables like detour length, exiting freeways, etc.) and the length of the ride.
7. They can pick up as many riders as they wish along the way.
8. Once the driver approaches their destination, rider search will turn off automatically.

## Backend
- Request: contains destination and current location
- Response: matches driver and rider and tells the frontend where to reroute to
- Given a destination and current location for a bunch of drivers and riders, match them based on shortest detour.
- Uses an array of drivers and an array of riders.
- Look through at regular intervals to find detours shorter than 10 minutes (or whatever drivers prefer)
- Detour length = time to destination with added stops - time to destination with no stops
- When a match is found, send the rider's info to the driver and vice versa.

## Frontend
- Will route drivers to their destination and provide directions.
- Riders will be able to track where they are on the map.