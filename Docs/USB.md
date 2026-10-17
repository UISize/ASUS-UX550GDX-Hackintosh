# USB map

The USBToolBox map was created using Windows insertion tests. The right-hand USB-A ports work with USB 2 and USB 3 devices in macOS. Rear means nearer the screen when viewed from the normal seated position. Aliases such as HS06 are labels; the controller port number is listed separately.

| Connection | Controller / port | Alias | Connector type |
|---|---|---|---|
| Right rear USB-A, USB 2 | A36D / 1 | HS01 | 3 |
| Right front USB-A, USB 2 | A36D / 2 | HS02 | 3 |
| Left front USB-C, USB 2 | A36D / 8 | HS03 | 8, USB 2-only |
| Internal webcam | A36D / 9 | HS04 | 255 |
| Left rear USB-C, USB 2 | A36D / 13 | HS05 | 8, USB 2-only |
| Internal Intel Bluetooth | A36D / 14 | HS06 | 255 |
| Right rear USB-A, SuperSpeed | A36D / 17 | SS01 | 3 |
| Right front USB-A, SuperSpeed | A36D / 18 | SS02 | 3 |

Eight ports are enabled on XHC. The secondary 8086:15D4 controller has an empty ports dictionary and port-count 0. **USB-C SuperSpeed is not enabled in this map.** USB-C SuperSpeed could not be tested because no suitable device was available.

## Extending the map

Use a known USB 3 peripheral and a SuperSpeed-capable cable/adapter. Test both USB-C sockets, both plug orientations and operation after sleep. A negotiated 480 Mbit/s connection is USB 2.

In Windows, A36D port 13 appeared together with secondary-controller port 3, and A36D port 8 with port 4. Use these as starting points for discovery. Neither secondary path has been tested with a SuperSpeed device.

Record the actual ports before adding them. XhciPortLimit remains disabled. USBInjectAll and UTBDefault are not used alongside this map. Thunderbolt and DisplayPort Alt Mode require separate testing from ordinary USB data transfer.
