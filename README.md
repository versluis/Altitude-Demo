# Altitude Demo
iOS 9 project demonstrating how to access barometer data on compatibel devices.

The project has two buttons at the top of the screen: Start and Stop. These start and stop relative altitude tracking of the CMAltimeter class (aka The Barometer). If a barometer is not available on the current hardware, an error is shown and nothing happens.

When active, three labels are populated: 
 * a Time Interval for the current update (in seconds, since the device was booted)
 * the Relative Altitude (in meters) since the altimeter was started
 * the current Air Pressure (in kilopascals)
 
When started, the Relative Altitude is always around 0 and changes when the device is taken to higher or lower ground.
