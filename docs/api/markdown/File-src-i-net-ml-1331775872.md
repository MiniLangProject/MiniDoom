# `src/i_net.ml`

[Home](README.md) · [Files](Files.md)

Bridges Doom's doomcom/ticcmd packets to the validated multiplayer UDP transport.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `d_net.ml` → [src/d_net.ml](File-src-d-net-ml-529296669.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency

## Declarations

<a id="function-function-inet-decodetonetbuffer-function-inet-decodetonetbuffer-payload-src-i-net-ml-1487371019"></a>
### _INet_DecodeToNetbuffer

```ml
function _INet_DecodeToNetbuffer(payload)
```

Deserializes payload bytes into global netbuffer fields.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `_INet_DecodeToNetbuffer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L131)

<a id="function-function-inet-encodedoomdata-function-inet-encodedoomdata-d-src-i-net-ml-1031919413"></a>
### _INet_EncodeDoomData

```ml
function _INet_EncodeDoomData(d)
```

Serializes doomdata struct into network payload bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `d` | `dynamic` | — | Divisor or direction value used by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L91)

<a id="function-function-inet-ensureslotmobj-function-inet-ensureslotmobj-slot-src-i-net-ml-2012147207"></a>
### _INet_EnsureSlotMobj

```ml
function _INet_EnsureSlotMobj(slot)
```

Ensures active player slots have a spawned mobj in running level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_INet_EnsureSlotMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L197)

<a id="constant-constant-inet-magic0-const-inet-magic0-68-src-i-net-ml-1460027884"></a>
### _INET_MAGIC0

```ml
const _INET_MAGIC0 = 68
```

Defines inet magic0 for the i net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L30)

<a id="constant-constant-inet-magic1-const-inet-magic1-78-src-i-net-ml-879644993"></a>
### _INET_MAGIC1

```ml
const _INET_MAGIC1 = 78
```

Defines inet magic1 for the i net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L33)

<a id="constant-constant-inet-magic2-const-inet-magic2-69-src-i-net-ml-2021324725"></a>
### _INET_MAGIC2

```ml
const _INET_MAGIC2 = 69
```

Defines inet magic2 for the i net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L36)

<a id="constant-constant-inet-magic3-const-inet-magic3-84-src-i-net-ml-2077601288"></a>
### _INET_MAGIC3

```ml
const _INET_MAGIC3 = 84
```

Defines inet magic3 for the i net subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L39)

<a id="function-function-inet-readi32le-inline-function-inet-readi32le-buf-off-src-i-net-ml-180213182"></a>
### _INet_ReadI32LE

```ml
inline function _INet_ReadI32LE(buf, off)
```

Reads a signed 32-bit integer from a byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_INet_ReadI32LE`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L78)

<a id="function-function-inet-removeslotmobj-inline-function-inet-removeslotmobj-slot-src-i-net-ml-1814716378"></a>
### _INet_RemoveSlotMobj

```ml
inline function _INet_RemoveSlotMobj(slot)
```

Removes mobj for inactive player slots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_INet_RemoveSlotMobj`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L242)

<a id="function-function-inet-slotisactive-function-inet-slotisactive-activeslots-slot-src-i-net-ml-661025110"></a>
### _INet_SlotIsActive

```ml
function _INet_SlotIsActive(activeSlots, slot)
```

Returns whether a slot index exists in the active slot list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activeSlots` | `dynamic` | — | Active slots value supplied to `_INet_SlotIsActive`. |
| `slot` | `dynamic` | — | Slot value supplied to `_INet_SlotIsActive`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L184)

<a id="function-function-inet-syncruntimefromplatform-function-inet-syncruntimefromplatform-src-i-net-ml-193128259"></a>
### _INet_SyncRuntimeFromPlatform

```ml
function _INet_SyncRuntimeFromPlatform()
```

Synchronizes doom net runtime globals from mp platform role/state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L256)

<a id="function-function-inet-toint-function-inet-toint-v-fallback-src-i-net-ml-1700000845"></a>
### _INet_ToInt

```ml
function _INet_ToInt(v, fallback)
```

Converts values to integers with deterministic rounding.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L45)

<a id="function-function-inet-writei32le-inline-function-inet-writei32le-buf-off-v-src-i-net-ml-1245780518"></a>
### _INet_WriteI32LE

```ml
inline function _INet_WriteI32LE(buf, off, v)
```

Writes a signed 32-bit integer to a byte buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_INet_WriteI32LE`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L65)

<a id="function-function-bindtolocalport-function-bindtolocalport-sock-port-src-i-net-ml-852378268"></a>
### BindToLocalPort

```ml
function BindToLocalPort(sock, port)
```

Legacy compatibility stub that rejects external bind attempts to preserve mp_platform socket ownership.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | Sock value supplied to `BindToLocalPort`. |
| `port` | `dynamic` | — | Port value supplied to `BindToLocalPort`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L410)

<a id="function-function-getlocaladdress-function-getlocaladdress-src-i-net-ml-692022017"></a>
### GetLocalAddress

```ml
function GetLocalAddress()
```

Returns the IPv4 loopback identity used by the legacy single-host API surface.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L443)

<a id="function-function-i-initnetwork-function-i-initnetwork-src-i-net-ml-452360835"></a>
### I_InitNetwork

```ml
function I_InitNetwork()
```

Resets doomcom and tic queues to deterministic single-player defaults before any MP role starts.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L363)

<a id="function-function-i-netcmd-function-i-netcmd-src-i-net-ml-118273743"></a>
### I_NetCmd

```ml
function I_NetCmd()
```

Executes one Doom CMD_GET/CMD_SEND operation through the validated platform packet queue.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L371)

<a id="function-function-packetget-function-packetget-sock-nodeout-dataout-lengthout-src-i-net-ml-2043169165"></a>
### PacketGet

```ml
function PacketGet(sock, nodeOut, dataOut, lengthOut)
```

Legacy compatibility stub that returns an empty receive result without touching caller payload storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | Sock value supplied to `PacketGet`. |
| `nodeOut` | `dynamic` | — | Node out value supplied to `PacketGet`. |
| `dataOut` | `dynamic` | — | Data out value supplied to `PacketGet`. |
| `lengthOut` | `dynamic` | — | Length out value supplied to `PacketGet`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L434)

<a id="function-function-packetsend-function-packetsend-sock-node-data-length-src-i-net-ml-626423415"></a>
### PacketSend

```ml
function PacketSend(sock, node, data, length)
```

Legacy compatibility stub; callers must submit structured Doom packets through I_NetCmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sock` | `dynamic` | — | Sock value supplied to `PacketSend`. |
| `node` | `dynamic` | — | Node value supplied to `PacketSend`. |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `length` | `dynamic` | — | Number of bytes or elements in the associated value. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L421)

<a id="function-function-udpsocket-function-udpsocket-src-i-net-ml-234044483"></a>
### UDPsocket

```ml
function UDPsocket()
```

Legacy compatibility stub; sockets are owned exclusively by mp_platform and no raw handle is exposed.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_net.ml#L403)
