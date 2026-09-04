# `src/s_sound.ml`

[Home](README.md) · [Files](Files.md)

Implements sound and music orchestration on top of the platform audio layer.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_sound.ml` → [src/i_sound.ml](File-src-i-sound-ml-33806980.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_fixed.ml` → [src/m_fixed.ml](File-src-m-fixed-ml-2129187227.md)
- `m_random.ml` → [src/m_random.ml](File-src-m-random-ml-1659574948.md)
- `mp_platform.ml` → [src/mp_platform.ml](File-src-mp-platform-ml-1361006310.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `r_main.ml` → [src/r_main.ml](File-src-r-main-ml-1902335243.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-s-abs-inline-function-s-abs-v-src-s-sound-ml-1249108556"></a>
### _S_Abs

```ml
inline function _S_Abs(v)
```

Returns the non-negative magnitude of an integer coordinate delta, or zero for invalid input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L245)

<a id="function-function-s-angnorm-inline-function-s-angnorm-a-src-s-sound-ml-247835693"></a>
### _S_AngNorm

```ml
inline function _S_AngNorm(a)
```

Normalizes an integer to Doom's unsigned 32-bit binary-angle domain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L254)

<a id="function-function-s-angref-inline-function-s-angref-v-src-s-sound-ml-116865424"></a>
### _S_AngRef

```ml
inline function _S_AngRef(v)
```

Extracts an angle from a positioned struct or its nested mobj, defaulting to zero.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L412)

<a id="function-function-s-clamp-inline-function-s-clamp-v-lo-hi-src-s-sound-ml-792553964"></a>
### _S_Clamp

```ml
inline function _S_Clamp(v, lo, hi)
```

Constrains a numeric sound parameter to the supplied inclusive range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L227)

<a id="global-global-s-debugmusiconce-s-debugmusiconce-src-s-sound-ml-1813829755"></a>
### _s_debugMusicOnce

```ml
_s_debugMusicOnce
```

Tracks whether s debug music once is active in the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L80)

<a id="global-global-s-debugsfxonce-s-debugsfxonce-src-s-sound-ml-236281467"></a>
### _s_debugSfxOnce

```ml
_s_debugSfxOnce
```

Tracks whether s debug sfx once is active in the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L83)

<a id="function-function-s-degradeusefulness-inline-function-s-degradeusefulness-sfx-src-s-sound-ml-262359263"></a>
### _S_DegradeUsefulness

```ml
inline function _S_DegradeUsefulness(sfx)
```

Decrements the canonical SFX entry's cache-use counter after a channel releases that sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L355)

<a id="function-function-s-effectiveconsoleslot-inline-function-s-effectiveconsoleslot-src-s-sound-ml-268660442"></a>
### _S_EffectiveConsoleSlot

```ml
inline function _S_EffectiveConsoleSlot()
```

Resolves the effective local player slot, preferring multiplayer platform slot in client mode.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L295)

<a id="function-function-s-ensurechannels-inline-function-s-ensurechannels-src-s-sound-ml-896088898"></a>
### _S_EnsureChannels

```ml
inline function _S_EnsureChannels()
```

Validates the configured channel count and rebuilds an empty registry whenever its size no longer matches.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L275)

<a id="function-function-s-enumindex-inline-function-s-enumindex-v-limit-src-s-sound-ml-1339446697"></a>
### _S_EnumIndex

```ml
inline function _S_EnumIndex(v, limit)
```

Resolves an integer, numeric value, or enum member to a bounded table index, returning -1 when unsupported.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `limit` | `dynamic` | — | Limit value supplied to `_S_EnumIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L145)

<a id="function-function-s-finesineat-inline-function-s-finesineat-idx-src-s-sound-ml-2113745881"></a>
### _S_FineSineAt

```ml
inline function _S_FineSineAt(idx)
```

Reads a wrapped fine-sine sample for stereo panning, returning zero when the table is unavailable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `idx` | `dynamic` | — | Zero-based element or table index. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L262)

<a id="function-function-s-getlistener-inline-function-s-getlistener-src-s-sound-ml-802656094"></a>
### _S_GetListener

```ml
inline function _S_GetListener()
```

Returns the effective local player's mobj as the positional-audio listener, or void for an invalid slot.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L307)

<a id="function-function-s-getsfxbyid-inline-function-s-getsfxbyid-sound-id-src-s-sound-ml-168677235"></a>
### _S_GetSfxById

```ml
inline function _S_GetSfxById(sound_id)
```

Resolves a valid nonzero sound id to its S_sfx metadata entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sound_id` | `dynamic` | — | Sound id value supplied to `_S_GetSfxById`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L319)

<a id="function-function-s-idiv-inline-function-s-idiv-a-b-src-s-sound-ml-1719114793"></a>
### _S_IDiv

```ml
inline function _S_IDiv(a, b)
```

Returns a signed quotient truncated toward zero, or zero for invalid operands and a zero divisor in `_S_IDiv`

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L215)

<a id="function-function-s-isseq-inline-function-s-isseq-v-src-s-sound-ml-1798949782"></a>
### _S_IsSeq

```ml
inline function _S_IsSeq(v)
```

Recognizes the array and list containers used for sound tables and channel registries.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L117)

<a id="function-function-s-linkof-inline-function-s-linkof-sfx-src-s-sound-ml-277960245"></a>
### _S_LinkOf

```ml
inline function _S_LinkOf(sfx)
```

Resolves an SFX alias link stored either as a direct metadata struct or as a table index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L329)

<a id="function-function-s-loadpulse-inline-function-s-loadpulse-iter-src-s-sound-ml-1526189662"></a>
### _S_LoadPulse

```ml
inline function _S_LoadPulse(iter)
```

Pumps window/audio updates periodically while expensive audio precache loops run.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `iter` | `dynamic` | — | Iter value supplied to `_S_LoadPulse`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L167)

<a id="function-function-s-min-inline-function-s-min-a-b-src-s-sound-ml-1888466169"></a>
### _S_Min

```ml
inline function _S_Min(a, b)
```

Returns the smaller operand for the sound-distance approximation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L237)

<a id="function-function-s-mpsendsoundevent-function-s-mpsendsoundevent-origin-p-sid-volume-targetslot-src-s-sound-ml-881170861"></a>
### _S_MPSendSoundEvent

```ml
function _S_MPSendSoundEvent(origin_p, sid, volume, targetSlot)
```

Sends one positional/non-positional sound event from host (broadcast or target slot).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin_p` | `dynamic` | — | Origin p value supplied to `_S_MPSendSoundEvent`. |
| `sid` | `dynamic` | — | Sid value supplied to `_S_MPSendSoundEvent`. |
| `volume` | `dynamic` | — | Volume value supplied to `_S_MPSendSoundEvent`. |
| `targetSlot` | `dynamic` | — | Target slot value supplied to `_S_MPSendSoundEvent`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L455)

<a id="function-function-s-musicid-inline-function-s-musicid-v-src-s-sound-ml-740846432"></a>
### _S_MusicId

```ml
inline function _S_MusicId(v)
```

Converts a music enum/value into its numeric id using the smaller of NUMMUSIC and the loaded music table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L198)

- [_s_net_origin_t](Type-s-net-origin-t-333212981.md) — struct
<a id="constant-constant-s-netmsg-sound-const-s-netmsg-sound-201-src-s-sound-ml-1001897753"></a>
### _S_NETMSG_SOUND

```ml
const _S_NETMSG_SOUND = 201
```

Defines s netmsg sound for the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L42)

<a id="function-function-s-posref-inline-function-s-posref-v-src-s-sound-ml-2056068700"></a>
### _S_PosRef

```ml
inline function _S_PosRef(v)
```

Normalizes either a positioned struct or a player wrapper to the struct that owns x/y coordinates.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L396)

<a id="function-function-s-readi32-inline-function-s-readi32-buf-off-src-s-sound-ml-1324011560"></a>
### _S_ReadI32

```ml
inline function _S_ReadI32(buf, off)
```

Reads one signed 32-bit integer from multiplayer sound event payload bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_S_ReadI32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L439)

<a id="function-function-s-samexy-inline-function-s-samexy-a-b-src-s-sound-ml-1869235741"></a>
### _S_SameXY

```ml
inline function _S_SameXY(a, b)
```

Reports whether two positional references occupy the same fixed-point x/y location.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L386)

<a id="function-function-s-setsfxusefulnessandlump-inline-function-s-setsfxusefulnessandlump-sid-sfx-src-s-sound-ml-2116297187"></a>
### _S_SetSfxUsefulnessAndLump

```ml
inline function _S_SetSfxUsefulnessAndLump(sid, sfx)
```

Writes modified lump and usefulness metadata back to a validated S_sfx table slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sid` | `dynamic` | — | Sid value supplied to `_S_SetSfxUsefulnessAndLump`. |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L376)

<a id="function-function-s-sfxid-inline-function-s-sfxid-v-src-s-sound-ml-970866184"></a>
### _S_SfxId

```ml
inline function _S_SfxId(v)
```

Converts an SFX enum/value into its numeric id using the smaller of NUMSFX and the loaded SFX table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L183)

<a id="global-global-s-sfxprecached-s-sfxprecached-src-s-sound-ml-1269564639"></a>
### _s_sfxPrecached

```ml
_s_sfxPrecached
```

Tracks whether s sfx precached is active in the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L86)

<a id="function-function-s-sfxpriority-inline-function-s-sfxpriority-sfx-src-s-sound-ml-916113603"></a>
### _S_SfxPriority

```ml
inline function _S_SfxPriority(sfx)
```

Reads an SFX channel-replacement priority with NORM_PRIORITY as the missing-value default.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfx` | `dynamic` | — | Sound-effect descriptor to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L347)

<a id="function-function-s-toint-inline-function-s-toint-v-fallback-src-s-sound-ml-366156502"></a>
### _S_ToInt

```ml
inline function _S_ToInt(v, fallback)
```

Coerces numeric values to truncation-toward-zero integers and returns fallback for invalid inputs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L126)

<a id="function-function-s-writei32-inline-function-s-writei32-buf-off-v-src-s-sound-ml-1574458978"></a>
### _S_WriteI32

```ml
inline function _S_WriteI32(buf, off, v)
```

Writes one signed 32-bit integer into bytes for multiplayer sound event payloads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_S_WriteI32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L426)

- [channel_t](Type-channel-t-271972559.md) — struct
<a id="global-global-channels-channels-src-s-sound-ml-1029610783"></a>
### channels

```ml
channels
```

Stores the channels collection used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L112)

<a id="global-global-mus-paused-mus-paused-src-s-sound-ml-1227538963"></a>
### mus_paused

```ml
mus_paused
```

Tracks whether mus paused is active in the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L66)

<a id="global-global-mus-playing-mus-playing-src-s-sound-ml-217943851"></a>
### mus_playing

```ml
mus_playing
```

Holds the optional mus playing resource used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L68)

<a id="global-global-nextcleanup-nextcleanup-src-s-sound-ml-1059545871"></a>
### nextcleanup

```ml
nextcleanup
```

Tracks the mutable nextcleanup value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L77)

<a id="constant-constant-norm-pitch-const-norm-pitch-128-src-s-sound-ml-552092621"></a>
### NORM_PITCH

```ml
const NORM_PITCH = 128
```

Defines norm pitch for the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L52)

<a id="constant-constant-norm-priority-const-norm-priority-64-src-s-sound-ml-1777055466"></a>
### NORM_PRIORITY

```ml
const NORM_PRIORITY = 64
```

Defines norm priority for the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L54)

<a id="constant-constant-norm-sep-const-norm-sep-128-src-s-sound-ml-209374805"></a>
### NORM_SEP

```ml
const NORM_SEP = 128
```

Defines norm sep for the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L56)

<a id="global-global-numchannels-numchannels-src-s-sound-ml-323947175"></a>
### numChannels

```ml
numChannels
```

Tracks the mutable num channels value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L75)

<a id="function-function-s-adjustsoundparams-function-s-adjustsoundparams-listener-source-vol-sep-pitch-src-s-sound-ml-549454435"></a>
### S_AdjustSoundParams

```ml
function S_AdjustSoundParams(listener, source, vol, sep, pitch)
```

Computes distance attenuation and listener-relative stereo separation, updating caller-owned volume/separation/pitch cells.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `listener` | `dynamic` | — | Listener value supplied to `S_AdjustSoundParams`. |
| `source` | `dynamic` | — | Source value or buffer. |
| `vol` | `dynamic` | — | Vol value supplied to `S_AdjustSoundParams`. |
| `sep` | `dynamic` | — | Sep value supplied to `S_AdjustSoundParams`. |
| `pitch` | `dynamic` | — | Pitch value supplied to `S_AdjustSoundParams`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L846)

<a id="global-global-s-attenuator-s-attenuator-src-s-sound-ml-928907565"></a>
### s_attenuator

```ml
s_attenuator
```

Tracks the mutable s attenuator value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L49)

<a id="function-function-s-changemusic-function-s-changemusic-music-id-looping-src-s-sound-ml-322855176"></a>
### S_ChangeMusic

```ml
function S_ChangeMusic(music_id, looping)
```

Stops the previous track, caches and registers the requested music lump, then starts it with the requested loop mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `music_id` | `dynamic` | — | Music id value supplied to `S_ChangeMusic`. |
| `looping` | `dynamic` | — | Looping value supplied to `S_ChangeMusic`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L960)

<a id="global-global-s-clipping-dist-s-clipping-dist-src-s-sound-ml-258256363"></a>
### s_clipping_dist

```ml
s_clipping_dist
```

Tracks the mutable s clipping dist value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L45)

<a id="global-global-s-close-dist-s-close-dist-src-s-sound-ml-26216389"></a>
### s_close_dist

```ml
s_close_dist
```

Tracks the mutable s close dist value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L47)

<a id="global-global-s-currentmusic-s-currentmusic-src-s-sound-ml-469887995"></a>
### s_currentMusic

```ml
s_currentMusic
```

Tracks the mutable s current music value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L70)

<a id="constant-constant-s-fracbits-const-s-fracbits-16-src-s-sound-ml-2077528375"></a>
### S_FRACBITS

```ml
const S_FRACBITS = 16
```

Defines s fracbits for the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L37)

<a id="constant-constant-s-fracunit-const-s-fracunit-65536-src-s-sound-ml-824387979"></a>
### S_FRACUNIT

```ml
const S_FRACUNIT = 65536
```

Defines s fracunit for the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L39)

<a id="function-function-s-getchannel-function-s-getchannel-origin-sfxinfo-src-s-sound-ml-1594929490"></a>
### S_getChannel

```ml
function S_getChannel(origin, sfxinfo)
```

Reserves an empty or same-origin voice, otherwise replaces an eligible channel by priority or returns -1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `S_getChannel`. |
| `sfxinfo` | `dynamic` | — | Sfxinfo value supplied to `S_getChannel`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L912)

<a id="function-function-s-init-function-s-init-sfxvolume-musicvolume-src-s-sound-ml-1521484207"></a>
### S_Init

```ml
function S_Init(sfxVolume, musicVolume)
```

Initializes platform channels and volumes, clears music ownership, and resets all SFX lump/usefulness metadata.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfxVolume` | `dynamic` | — | Sfx volume value supplied to `S_Init`. |
| `musicVolume` | `dynamic` | — | Music volume value supplied to `S_Init`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L548)

<a id="constant-constant-s-max-volume-const-s-max-volume-127-src-s-sound-ml-1955100046"></a>
### S_MAX_VOLUME

```ml
const S_MAX_VOLUME = 127
```

Defines the maximum s max volume accepted by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L35)

<a id="function-function-s-mpsendpickupsoundtoplayer-function-s-mpsendpickupsoundtoplayer-playerslot-sound-id-src-s-sound-ml-1233481429"></a>
### S_MPSendPickupSoundToPlayer

```ml
function S_MPSendPickupSoundToPlayer(playerSlot, sound_id)
```

Sends one pickup sound to the owning player in host-authoritative multiplayer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerSlot` | `dynamic` | — | Player slot value supplied to `S_MPSendPickupSoundToPlayer`. |
| `sound_id` | `dynamic` | — | Sound id value supplied to `S_MPSendPickupSoundToPlayer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L512)

<a id="global-global-s-musiczoneptrs-s-musiczoneptrs-src-s-sound-ml-1046348815"></a>
### s_musicZonePtrs

```ml
s_musicZonePtrs
```

Stores the s music zone ptrs collection used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L72)

<a id="function-function-s-netrecvpacket-function-s-netrecvpacket-payload-src-s-sound-ml-1226399475"></a>
### S_NetRecvPacket

```ml
function S_NetRecvPacket(payload)
```

Applies one multiplayer sound packet on clients so attenuation uses local listener position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `payload` | `dynamic` | — | Payload value supplied to `S_NetRecvPacket`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L523)

<a id="function-function-s-pausesound-function-s-pausesound-src-s-sound-ml-393028293"></a>
### S_PauseSound

```ml
function S_PauseSound()
```

Pauses the active music handle exactly once and records the paused state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L1062)

<a id="function-function-s-precachelevelaudio-function-s-precachelevelaudio-src-s-sound-ml-2047139985"></a>
### S_PrecacheLevelAudio

```ml
function S_PrecacheLevelAudio()
```

Resolves and precaches every named SFX lump once while periodically pumping window and audio updates.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L654)

<a id="function-function-s-resumesound-function-s-resumesound-src-s-sound-ml-1362018613"></a>
### S_ResumeSound

```ml
function S_ResumeSound()
```

Resumes a previously paused music handle and clears the paused state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L1072)

<a id="function-function-s-setmusicvolume-function-s-setmusicvolume-volume-src-s-sound-ml-197098267"></a>
### S_SetMusicVolume

```ml
function S_SetMusicVolume(volume)
```

Clamps and stores music volume, then forwards only the requested level to the platform mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `volume` | `dynamic` | — | Volume value supplied to `S_SetMusicVolume`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L1146)

<a id="function-function-s-setsfxvolume-function-s-setsfxvolume-volume-src-s-sound-ml-1453364991"></a>
### S_SetSfxVolume

```ml
function S_SetSfxVolume(volume)
```

Clamps and stores effects volume and forwards it to the platform mixer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `volume` | `dynamic` | — | Volume value supplied to `S_SetSfxVolume`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L1159)

<a id="function-function-s-start-function-s-start-src-s-sound-ml-2127533509"></a>
### S_Start

```ml
function S_Start()
```

Stops residual channels and selects the looping level track from game mode, episode, and map.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L596)

<a id="function-function-s-startmusic-function-s-startmusic-music-id-src-s-sound-ml-1650381272"></a>
### S_StartMusic

```ml
function S_StartMusic(music_id)
```

Starts a non-looping music track through the common change-music path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `music_id` | `dynamic` | — | Music id value supplied to `S_StartMusic`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L952)

<a id="function-function-s-startsound-function-s-startsound-origin-sound-id-src-s-sound-ml-870392446"></a>
### S_StartSound

```ml
function S_StartSound(origin, sound_id)
```

Starts an SFX at the current global effects volume.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `S_StartSound`. |
| `sound_id` | `dynamic` | — | Sound id value supplied to `S_StartSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L694)

<a id="function-function-s-startsoundatvolume-function-s-startsoundatvolume-origin-p-sfx-id-volume-src-s-sound-ml-630858307"></a>
### S_StartSoundAtVolume

```ml
function S_StartSoundAtVolume(origin_p, sfx_id, volume)
```

Broadcasts host audio, resolves aliases and attenuation, reserves a channel, and starts the platform SFX handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin_p` | `dynamic` | — | Origin p value supplied to `S_StartSoundAtVolume`. |
| `sfx_id` | `dynamic` | — | Sfx id value supplied to `S_StartSoundAtVolume`. |
| `volume` | `dynamic` | — | Volume value supplied to `S_StartSoundAtVolume`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L703)

<a id="global-global-s-stereo-swing-s-stereo-swing-src-s-sound-ml-150092285"></a>
### s_stereo_swing

```ml
s_stereo_swing
```

Tracks the mutable s stereo swing value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L58)

<a id="function-function-s-stopchannel-function-s-stopchannel-cnum-src-s-sound-ml-38265896"></a>
### S_StopChannel

```ml
function S_StopChannel(cnum)
```

Stops a validated platform voice, decrements its SFX usefulness, and resets the logical channel slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cnum` | `dynamic` | — | Index identifying c. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L817)

<a id="function-function-s-stopmusic-function-s-stopmusic-src-s-sound-ml-1567617527"></a>
### S_StopMusic

```ml
function S_StopMusic()
```

Resumes if needed, stops and unregisters the active song, retags its lump cache, and clears music ownership state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L1019)

<a id="function-function-s-stopsound-function-s-stopsound-origin-src-s-sound-ml-636591881"></a>
### S_StopSound

```ml
function S_StopSound(origin)
```

Finds and releases the first active channel associated with a specific sound origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | Origin value supplied to `S_StopSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L801)

<a id="function-function-s-updatesounds-function-s-updatesounds-listener-p-src-s-sound-ml-1885139350"></a>
### S_UpdateSounds

```ml
function S_UpdateSounds(listener_p)
```

Recomputes positional parameters for playing voices and releases finished or newly inaudible channels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `listener_p` | `dynamic` | — | Listener p value supplied to `S_UpdateSounds`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L1083)

<a id="global-global-snd-musicvolume-snd-musicvolume-src-s-sound-ml-1102623227"></a>
### snd_MusicVolume

```ml
snd_MusicVolume
```

Tracks the mutable snd music volume value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L63)

<a id="global-global-snd-sfxvolume-snd-sfxvolume-src-s-sound-ml-1990260223"></a>
### snd_SfxVolume

```ml
snd_SfxVolume
```

Tracks the mutable snd sfx volume value used by the s sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/s_sound.ml#L61)
