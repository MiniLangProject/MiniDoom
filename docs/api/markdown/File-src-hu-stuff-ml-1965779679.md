# `src/hu_stuff.ml`

[Home](README.md) · [Files](Files.md)

Owns level-title/message widgets, localized chat entry, and authoritative directed-chat submission.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_englsh.ml` → [src/d_englsh.ml](File-src-d-englsh-ml-970368195.md)
- `d_event.ml` → [src/d_event.ml](File-src-d-event-ml-1995118760.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `dstrings.ml` → [src/dstrings.ml](File-src-dstrings-ml-567491523.md)
- `hu_lib.ml` → [src/hu_lib.ml](File-src-hu-lib-ml-937975676.md)
- `m_menu.ml` → [src/m_menu.ml](File-src-m-menu-ml-331716860.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `s_sound.ml` → [src/s_sound.ml](File-src-s-sound-ml-1485495390.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-hu-buildbaseshiftmap-function-hu-buildbaseshiftmap-src-hu-stuff-ml-944432222"></a>
### _HU_BuildBaseShiftMap

```ml
function _HU_BuildBaseShiftMap()
```

Creates the ASCII chat transform with identity punctuation and uppercase alphabetic keys.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L296)

<a id="function-function-hu-buildenglishshiftmap-function-hu-buildenglishshiftmap-src-hu-stuff-ml-252506978"></a>
### _HU_BuildEnglishShiftMap

```ml
function _HU_BuildEnglishShiftMap()
```

Adds US-keyboard shifted punctuation and digits to the common chat transform.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L313)

<a id="function-function-hu-buildfrenchshiftmap-function-hu-buildfrenchshiftmap-src-hu-stuff-ml-502939132"></a>
### _HU_BuildFrenchShiftMap

```ml
function _HU_BuildFrenchShiftMap()
```

Adds the French layout's supported shifted punctuation to the common chat transform.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L343)

<a id="function-function-hu-currentplayer-inline-function-hu-currentplayer-src-hu-stuff-ml-849753163"></a>
### _HU_CurrentPlayer

```ml
inline function _HU_CurrentPlayer()
```

Resolves and caches the console player's current HUD message source.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L372)

<a id="function-function-hu-ensureinputbuffers-function-hu-ensureinputbuffers-src-hu-stuff-ml-1659229002"></a>
### _HU_EnsureInputBuffers

```ml
function _HU_EnsureInputBuffers()
```

Allocates one bounded HUlib input widget per possible remote chat sender.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L442)

<a id="function-function-hu-fontheight-inline-function-hu-fontheight-src-hu-stuff-ml-418488323"></a>
### _HU_FontHeight

```ml
inline function _HU_FontHeight()
```

Returns the loaded HUD font height with an eight-pixel fallback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L229)

<a id="function-function-hu-initdestinationkeys-inline-function-hu-initdestinationkeys-src-hu-stuff-ml-1608886867"></a>
### _HU_InitDestinationKeys

```ml
inline function _HU_InitDestinationKeys()
```

Maps the four localized player-color destination keys to responder key codes.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L430)

<a id="function-function-hu-itextstring-inline-function-hu-itextstring-it-src-hu-stuff-ml-1703431336"></a>
### _HU_ITextString

```ml
inline function _HU_ITextString(it)
```

Copies the live HU input widget bytes into an immutable chat string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `it` | `dynamic` | — | It value supplied to `_HU_ITextString`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L285)

<a id="function-function-hu-keycodefromstring-inline-function-hu-keycodefromstring-s-src-hu-stuff-ml-190628240"></a>
### _HU_KeyCodeFromString

```ml
inline function _HU_KeyCodeFromString(s)
```

Extracts the first byte used by localized one-character chat key bindings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_HU_KeyCodeFromString`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L239)

<a id="global-global-hu-lastmessage-hu-lastmessage-src-hu-stuff-ml-309214904"></a>
### _hu_lastmessage

```ml
_hu_lastmessage
```

Stores the mutable hu lastmessage text used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L183)

<a id="global-global-hu-local-chat-dest-hu-local-chat-dest-src-hu-stuff-ml-1204726232"></a>
### _hu_local_chat_dest

```ml
_hu_local_chat_dest
```

Tracks the mutable hu local chat dest value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L186)

<a id="function-function-hu-maptitle-function-hu-maptitle-src-hu-stuff-ml-1706407490"></a>
### _HU_MapTitle

```ml
function _HU_MapTitle()
```

Selects the localized automap title for the current episode/map marker.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L408)

<a id="function-function-hu-mpsendchatmessage-inline-function-hu-mpsendchatmessage-dest-msg-src-hu-stuff-ml-2027964392"></a>
### _HU_MPSendChatMessage

```ml
inline function _HU_MPSendChatMessage(dest, msg)
```

Submits one complete HUD chat line to the authoritative channel, including private destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dest` | `dynamic` | — | Dest value supplied to `_HU_MPSendChatMessage`. |
| `msg` | `dynamic` | — | Msg value supplied to `_HU_MPSendChatMessage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L265)

<a id="function-function-hu-mpusepacketchat-inline-function-hu-mpusepacketchat-src-hu-stuff-ml-806766775"></a>
### _HU_MPUsePacketChat

```ml
inline function _HU_MPUsePacketChat()
```

Enables chat only for the host-authoritative platform session that owns D_Net routing.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L255)

<a id="function-function-hu-playername-inline-function-hu-playername-idx-src-hu-stuff-ml-800349398"></a>
### _HU_PlayerName

```ml
inline function _HU_PlayerName(idx)
```

Resolves a checked local player-name entry for directed chat prompts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L277)

<a id="function-function-hu-popcurrentplayermessage-function-hu-popcurrentplayermessage-src-hu-stuff-ml-2102497440"></a>
### _HU_PopCurrentPlayerMessage

```ml
function _HU_PopCurrentPlayerMessage()
```

Reads and clears current player HUD message from authoritative player state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L381)

<a id="function-function-hu-setchaton-inline-function-hu-setchaton-v-src-hu-stuff-ml-660705073"></a>
### _HU_SetChatOn

```ml
inline function _HU_SetChatOn(v)
```

Keeps chat-entry visibility synchronized with the mutable reference consumed by HUlib.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L218)

<a id="function-function-hu-setmessageon-inline-function-hu-setmessageon-v-src-hu-stuff-ml-1389851785"></a>
### _HU_SetMessageOn

```ml
inline function _HU_SetMessageOn(v)
```

Keeps the HUD message visibility flag and HUlib's shared boolean reference in lockstep.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L206)

<a id="function-function-hu-shiftchar-inline-function-hu-shiftchar-c-src-hu-stuff-ml-545413456"></a>
### _HU_ShiftChar

```ml
inline function _HU_ShiftChar(c)
```

Applies the active keyboard shift map to one printable chat byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `c` | `dynamic` | — | C value supplied to `_HU_ShiftChar`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L362)

<a id="function-function-hu-showmessagesenabled-inline-function-hu-showmessagesenabled-src-hu-stuff-ml-1365532107"></a>
### _HU_ShowMessagesEnabled

```ml
inline function _HU_ShowMessagesEnabled()
```

Normalizes the integer showMessages setting to a HUD visibility decision.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L248)

<a id="function-function-hu-toint-inline-function-hu-toint-v-fallback-src-hu-stuff-ml-787734787"></a>
### _HU_ToInt

```ml
inline function _HU_ToInt(v, fallback)
```

Normalizes numeric HUD fields to truncating integers or a caller-supplied fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L192)

<a id="global-global-altdown-altdown-src-hu-stuff-ml-2003333936"></a>
### altdown

```ml
altdown
```

Tracks whether altdown is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L178)

<a id="global-global-always-off-always-off-src-hu-stuff-ml-782735354"></a>
### always_off

```ml
always_off
```

Tracks whether always off is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L144)

<a id="global-global-always-off-ref-always-off-ref-src-hu-stuff-ml-2146917294"></a>
### always_off_ref

```ml
always_off_ref
```

Stores the always off ref collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L146)

<a id="global-global-chat-char-chat-char-src-hu-stuff-ml-986819840"></a>
### chat_char

```ml
chat_char
```

Tracks the mutable chat char value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L130)

<a id="global-global-chat-dest-chat-dest-src-hu-stuff-ml-55945080"></a>
### chat_dest

```ml
chat_dest
```

Stores the chat dest collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L148)

<a id="global-global-chat-macros-chat-macros-src-hu-stuff-ml-1688828448"></a>
### chat_macros

```ml
chat_macros
```

Stores the chat macros collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L69)

<a id="global-global-chat-on-chat-on-src-hu-stuff-ml-750149344"></a>
### chat_on

```ml
chat_on
```

Tracks whether chat on is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L164)

<a id="global-global-chat-on-ref-chat-on-ref-src-hu-stuff-ml-1225747772"></a>
### chat_on_ref

```ml
chat_on_ref
```

Stores the chat on ref collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L166)

<a id="global-global-destination-keys-destination-keys-src-hu-stuff-ml-198497866"></a>
### destination_keys

```ml
destination_keys
```

Stores the destination keys collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L150)

<a id="function-function-foreigntranslation-function-foreigntranslation-ch-src-hu-stuff-ml-1441955351"></a>
### ForeignTranslation

```ml
function ForeignTranslation(ch)
```

Maps one key byte through the French keyboard table while preserving other languages.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ch` | `dynamic` | — | Ch value supplied to `ForeignTranslation`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L629)

<a id="global-global-frenchkeymap-frenchkeymap-src-hu-stuff-ml-533429030"></a>
### frenchKeyMap

```ml
frenchKeyMap
```

Stores the french key map collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L112)

<a id="global-global-headsupactive-headsupactive-src-hu-stuff-ml-758052132"></a>
### headsupactive

```ml
headsupactive
```

Tracks whether headsupactive is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L169)

<a id="constant-constant-hu-broadcast-const-hu-broadcast-5-src-hu-stuff-ml-1962621960"></a>
### HU_BROADCAST

```ml
const HU_BROADCAST = 5
```

Defines hu broadcast for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L42)

<a id="function-function-hu-drawer-function-hu-drawer-src-hu-stuff-ml-960711168"></a>
### HU_Drawer

```ml
function HU_Drawer()
```

Draws message history, map title, and active chat input when the HUD is visible.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L549)

<a id="function-function-hu-erase-function-hu-erase-src-hu-stuff-ml-494926250"></a>
### HU_Erase

```ml
function HU_Erase()
```

Restores view-border pixels previously occupied by HUD text in reduced-screen mode.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L557)

<a id="global-global-hu-font-hu-font-src-hu-stuff-ml-1170123448"></a>
### hu_font

```ml
hu_font
```

Stores the hu font collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L127)

<a id="constant-constant-hu-fontend-const-hu-fontend-95-src-hu-stuff-ml-1430451969"></a>
### HU_FONTEND

```ml
const HU_FONTEND = 95
```

Defines hu fontend for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L37)

<a id="constant-constant-hu-fontsize-const-hu-fontsize-hu-fontend-hu-fontstart-1-src-hu-stuff-ml-73767393"></a>
### HU_FONTSIZE

```ml
const HU_FONTSIZE = HU_FONTEND - HU_FONTSTART + 1
```

Defines hu fontsize for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L39)

<a id="constant-constant-hu-fontstart-const-hu-fontstart-33-src-hu-stuff-ml-432712079"></a>
### HU_FONTSTART

```ml
const HU_FONTSTART = 33
```

Defines hu fontstart for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L35)

<a id="function-function-hu-init-function-hu-init-src-hu-stuff-ml-1193802138"></a>
### HU_Init

```ml
function HU_Init()
```

Builds keyboard shift maps, shared visibility references, and the STCFN font-lump cache.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L455)

<a id="constant-constant-hu-inputtoggle-const-hu-inputtoggle-116-src-hu-stuff-ml-39024493"></a>
### HU_INPUTTOGGLE

```ml
const HU_INPUTTOGGLE = 116
```

Defines hu inputtoggle for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L62)

<a id="constant-constant-hu-inputx-const-hu-inputx-hu-msgx-src-hu-stuff-ml-144718820"></a>
### HU_INPUTX

```ml
const HU_INPUTX = HU_MSGX
```

Defines hu inputx for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L64)

<a id="constant-constant-hu-mpchat-maxbytes-const-hu-mpchat-maxbytes-120-src-hu-stuff-ml-1885095282"></a>
### HU_MPCHAT_MAXBYTES

```ml
const HU_MPCHAT_MAXBYTES = 120
```

Defines the maximum hu mpchat maxbytes accepted by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L46)

<a id="constant-constant-hu-mpmsg-chat-const-hu-mpmsg-chat-7-src-hu-stuff-ml-238564298"></a>
### HU_MPMSG_CHAT

```ml
const HU_MPMSG_CHAT = 7
```

Defines hu mpmsg chat for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L44)

<a id="constant-constant-hu-msgheight-const-hu-msgheight-1-src-hu-stuff-ml-1837540026"></a>
### HU_MSGHEIGHT

```ml
const HU_MSGHEIGHT = 1
```

Defines hu msgheight for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L57)

<a id="constant-constant-hu-msgrefresh-const-hu-msgrefresh-key-enter-src-hu-stuff-ml-1450496065"></a>
### HU_MSGREFRESH

```ml
const HU_MSGREFRESH = KEY_ENTER
```

Defines hu msgrefresh for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L49)

<a id="constant-constant-hu-msgtimeout-const-hu-msgtimeout-4-ticrate-src-hu-stuff-ml-875110163"></a>
### HU_MSGTIMEOUT

```ml
const HU_MSGTIMEOUT = 4 * TICRATE
```

Defines hu msgtimeout for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L59)

<a id="constant-constant-hu-msgwidth-const-hu-msgwidth-64-src-hu-stuff-ml-567953399"></a>
### HU_MSGWIDTH

```ml
const HU_MSGWIDTH = 64
```

Defines hu msgwidth for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L55)

<a id="constant-constant-hu-msgx-const-hu-msgx-0-src-hu-stuff-ml-1444826347"></a>
### HU_MSGX

```ml
const HU_MSGX = 0
```

Defines hu msgx for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L51)

<a id="constant-constant-hu-msgy-const-hu-msgy-0-src-hu-stuff-ml-1353089855"></a>
### HU_MSGY

```ml
const HU_MSGY = 0
```

Defines hu msgy for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L53)

<a id="function-function-hu-netaddmessage-function-hu-netaddmessage-msg-src-hu-stuff-ml-1211802131"></a>
### HU_NetAddMessage

```ml
function HU_NetAddMessage(msg)
```

Pushes one network-originated chat/feed line directly into HUD message area.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `msg` | `dynamic` | — | Msg value supplied to `HU_NetAddMessage`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L565)

<a id="function-function-hu-responder-function-hu-responder-ev-src-hu-stuff-ml-1833774927"></a>
### HU_Responder

```ml
function HU_Responder(ev)
```

Owns chat activation, destination selection, macros, editing, and final packet submission.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ev` | `dynamic` | — | Input event to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L639)

<a id="function-function-hu-start-function-hu-start-src-hu-stuff-ml-524594290"></a>
### HU_Start

```ml
function HU_Start()
```

Rebinds HUD widgets to the current player and clears messages/chat buffers for the new level.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L502)

<a id="global-global-hu-started-hu-started-src-hu-stuff-ml-323643606"></a>
### hu_started

```ml
hu_started
```

Tracks whether hu started is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L171)

<a id="function-function-hu-stop-function-hu-stop-src-hu-stuff-ml-860128090"></a>
### HU_Stop

```ml
function HU_Stop()
```

Deactivates level HUD rendering and cancels any partially entered chat line.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L493)

<a id="function-function-hu-ticker-function-hu-ticker-src-hu-stuff-ml-1028332794"></a>
### HU_Ticker

```ml
function HU_Ticker()
```

Ages the current HUD message and consumes one authoritative player message per UI tic.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L597)

<a id="constant-constant-hu-titlex-const-hu-titlex-0-src-hu-stuff-ml-1264301163"></a>
### HU_TITLEX

```ml
const HU_TITLEX = 0
```

Defines hu titlex for the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L67)

<a id="global-global-mapnames-mapnames-src-hu-stuff-ml-1483408840"></a>
### mapnames

```ml
mapnames
```

Stores the mapnames collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L86)

<a id="global-global-mapnames2-mapnames2-src-hu-stuff-ml-1553001948"></a>
### mapnames2

```ml
mapnames2
```

Stores the mapnames2 collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L94)

<a id="global-global-mapnamesp-mapnamesp-src-hu-stuff-ml-661967120"></a>
### mapnamesp

```ml
mapnamesp
```

Stores the mapnamesp collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L100)

<a id="global-global-mapnamest-mapnamest-src-hu-stuff-ml-579436360"></a>
### mapnamest

```ml
mapnamest
```

Stores the mapnamest collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L106)

<a id="global-global-message-counter-message-counter-src-hu-stuff-ml-1039503248"></a>
### message_counter

```ml
message_counter
```

Tracks the mutable message counter value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L161)

<a id="global-global-message-dontfuckwithme-message-dontfuckwithme-src-hu-stuff-ml-1561466376"></a>
### message_dontfuckwithme

```ml
message_dontfuckwithme
```

Tracks whether message dontfuckwithme is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L157)

<a id="global-global-message-nottobefuckedwith-message-nottobefuckedwith-src-hu-stuff-ml-1678327564"></a>
### message_nottobefuckedwith

```ml
message_nottobefuckedwith
```

Tracks whether message nottobefuckedwith is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L159)

<a id="global-global-message-on-message-on-src-hu-stuff-ml-928680126"></a>
### message_on

```ml
message_on
```

Tracks whether message on is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L153)

<a id="global-global-message-on-ref-message-on-ref-src-hu-stuff-ml-661556886"></a>
### message_on_ref

```ml
message_on_ref
```

Stores the message on ref collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L155)

<a id="global-global-num-nobrainers-num-nobrainers-src-hu-stuff-ml-1876292824"></a>
### num_nobrainers

```ml
num_nobrainers
```

Tracks the mutable num nobrainers value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L180)

<a id="global-global-player-names-player-names-src-hu-stuff-ml-1637890792"></a>
### player_names

```ml
player_names
```

Stores the player names collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L83)

<a id="global-global-plr-plr-src-hu-stuff-ml-368471880"></a>
### plr

```ml
plr
```

Holds the optional plr resource used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L132)

<a id="global-global-shiftdown-shiftdown-src-hu-stuff-ml-1411767220"></a>
### shiftdown

```ml
shiftdown
```

Tracks whether shiftdown is active in the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L176)

<a id="global-global-shiftxform-shiftxform-src-hu-stuff-ml-1726563272"></a>
### shiftxform

```ml
shiftxform
```

Stores the shiftxform collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L174)

<a id="global-global-w-chat-w-chat-src-hu-stuff-ml-962375432"></a>
### w_chat

```ml
w_chat
```

Tracks the mutable w chat value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L139)

<a id="global-global-w-inputbuffer-w-inputbuffer-src-hu-stuff-ml-223162380"></a>
### w_inputbuffer

```ml
w_inputbuffer
```

Stores the w inputbuffer collection used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L141)

<a id="global-global-w-message-w-message-src-hu-stuff-ml-553708544"></a>
### w_message

```ml
w_message
```

Tracks the mutable w message value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L137)

<a id="global-global-w-title-w-title-src-hu-stuff-ml-1296623776"></a>
### w_title

```ml
w_title
```

Tracks the mutable w title value used by the hu stuff subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/hu_stuff.ml#L135)
