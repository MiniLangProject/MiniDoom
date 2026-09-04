# `src/i_sound.ml`

[Home](README.md) · [Files](Files.md)

Mixes Doom sound effects into platform PCM buffers and translates MUS music events to the active MIDI backend.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomdef.ml` → [src/doomdef.ml](File-src-doomdef-ml-460406769.md)
- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `i_sound.ml` → [src/i_sound.ml](File-src-i-sound-ml-33806980.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_misc.ml` → [src/m_misc.ml](File-src-m-misc-ml-906836777.md)
- `sounds.ml` → [src/sounds.ml](File-src-sounds-ml-1875364049.md)
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="global-global-i-chactive-i-chactive-src-i-sound-ml-2070030837"></a>
### _I_chActive

```ml
_I_chActive
```

Stores the i ch active collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L212)

<a id="global-global-i-chdata-i-chdata-src-i-sound-ml-1509359361"></a>
### _I_chData

```ml
_I_chData
```

Stores the i ch data collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L221)

<a id="global-global-i-chfrac-i-chfrac-src-i-sound-ml-445346785"></a>
### _I_chFrac

```ml
_I_chFrac
```

Stores the i ch frac collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L230)

<a id="global-global-i-chhandle-i-chhandle-src-i-sound-ml-120334369"></a>
### _I_chHandle

```ml
_I_chHandle
```

Stores the i ch handle collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L215)

<a id="global-global-i-chid-i-chid-src-i-sound-ml-1311342313"></a>
### _I_chId

```ml
_I_chId
```

Stores the i ch id collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L218)

<a id="global-global-i-chleftvol-i-chleftvol-src-i-sound-ml-1147083237"></a>
### _I_chLeftVol

```ml
_I_chLeftVol
```

Stores the i ch left vol collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L239)

<a id="global-global-i-chlen-i-chlen-src-i-sound-ml-1419988851"></a>
### _I_chLen

```ml
_I_chLen
```

Stores the i ch len collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L224)

<a id="global-global-i-chpos-i-chpos-src-i-sound-ml-952048497"></a>
### _I_chPos

```ml
_I_chPos
```

Stores the i ch pos collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L227)

<a id="global-global-i-chrightvol-i-chrightvol-src-i-sound-ml-1732393045"></a>
### _I_chRightVol

```ml
_I_chRightVol
```

Stores the i ch right vol collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L242)

<a id="global-global-i-chstart-i-chstart-src-i-sound-ml-1264097233"></a>
### _I_chStart

```ml
_I_chStart
```

Stores the i ch start collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L236)

<a id="global-global-i-chstep-i-chstep-src-i-sound-ml-1332959121"></a>
### _I_chStep

```ml
_I_chStep
```

Stores the i ch step collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L233)

<a id="global-global-i-currentsonghandle-i-currentsonghandle-src-i-sound-ml-511745119"></a>
### _I_currentSongHandle

```ml
_I_currentSongHandle
```

Tracks the mutable i current song handle value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L269)

<a id="global-global-i-mididbgprinted-i-mididbgprinted-src-i-sound-ml-98642713"></a>
### _I_midiDbgPrinted

```ml
_I_midiDbgPrinted
```

Tracks whether i midi dbg printed is active in the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L316)

<a id="global-global-i-midihandle-i-midihandle-src-i-sound-ml-657960425"></a>
### _I_midiHandle

```ml
_I_midiHandle
```

Tracks the mutable i midi handle value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L273)

<a id="global-global-i-mixscaletable-i-mixscaletable-src-i-sound-ml-2119902547"></a>
### _I_mixScaleTable

```ml
_I_mixScaleTable
```

Stores the i mix scale table collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L202)

<a id="global-global-i-mixscratch-i-mixscratch-src-i-sound-ml-67904929"></a>
### _I_mixScratch

```ml
_I_mixScratch
```

Tracks the mutable i mix scratch value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L256)

<a id="global-global-i-musicchanmap-i-musicchanmap-src-i-sound-ml-980111769"></a>
### _I_musicChanMap

```ml
_I_musicChanMap
```

Stores the i music chan map collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L310)

<a id="global-global-i-musicchanvel-i-musicchanvel-src-i-sound-ml-750122313"></a>
### _I_musicChanVel

```ml
_I_musicChanVel
```

Stores the i music chan vel collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L307)

<a id="global-global-i-musicdata-i-musicdata-src-i-sound-ml-23254621"></a>
### _I_musicData

```ml
_I_musicData
```

Holds the optional i music data resource used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L276)

<a id="global-global-i-musicdelay-i-musicdelay-src-i-sound-ml-999263453"></a>
### _I_musicDelay

```ml
_I_musicDelay
```

Tracks the mutable i music delay value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L297)

<a id="global-global-i-musiclastms-i-musiclastms-src-i-sound-ml-1134697405"></a>
### _I_musicLastMs

```ml
_I_musicLastMs
```

Tracks the mutable i music last ms value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L300)

<a id="global-global-i-musiclooping-i-musiclooping-src-i-sound-ml-8393953"></a>
### _I_musicLooping

```ml
_I_musicLooping
```

Tracks whether i music looping is active in the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L285)

<a id="global-global-i-musicmsfrac-i-musicmsfrac-src-i-sound-ml-2142087853"></a>
### _I_musicMsFrac

```ml
_I_musicMsFrac
```

Tracks the mutable i music ms frac value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L303)

<a id="global-global-i-musicpaused-i-musicpaused-src-i-sound-ml-357166529"></a>
### _I_musicPaused

```ml
_I_musicPaused
```

Tracks whether i music paused is active in the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L282)

<a id="global-global-i-musicplaying-i-musicplaying-src-i-sound-ml-1968855649"></a>
### _I_musicPlaying

```ml
_I_musicPlaying
```

Tracks whether i music playing is active in the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L279)

<a id="global-global-i-musicpos-i-musicpos-src-i-sound-ml-627716289"></a>
### _I_musicPos

```ml
_I_musicPos
```

Tracks the mutable i music pos value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L294)

<a id="global-global-i-musicscoreend-i-musicscoreend-src-i-sound-ml-736088875"></a>
### _I_musicScoreEnd

```ml
_I_musicScoreEnd
```

Tracks the mutable i music score end value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L291)

<a id="global-global-i-musicscorestart-i-musicscorestart-src-i-sound-ml-1439769681"></a>
### _I_musicScoreStart

```ml
_I_musicScoreStart
```

Tracks the mutable i music score start value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L288)

<a id="global-global-i-musicusedmidi-i-musicusedmidi-src-i-sound-ml-959317945"></a>
### _I_musicUsedMidi

```ml
_I_musicUsedMidi
```

Stores the i music used midi collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L313)

<a id="global-global-i-musicvolume-i-musicvolume-src-i-sound-ml-1397954273"></a>
### _I_musicVolume

```ml
_I_musicVolume
```

Tracks the mutable i music volume value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L260)

<a id="global-global-i-nexthandle-i-nexthandle-src-i-sound-ml-373055329"></a>
### _I_nextHandle

```ml
_I_nextHandle
```

Tracks the mutable i next handle value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L190)

<a id="global-global-i-nextsonghandle-i-nextsonghandle-src-i-sound-ml-332526037"></a>
### _I_nextSongHandle

```ml
_I_nextSongHandle
```

Tracks the mutable i next song handle value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L263)

<a id="global-global-i-sfxrates-i-sfxrates-src-i-sound-ml-1846350041"></a>
### _I_sfxRates

```ml
_I_sfxRates
```

Stores the i sfx rates collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L205)

<a id="global-global-i-sfxsamples-i-sfxsamples-src-i-sound-ml-157242529"></a>
### _I_sfxSamples

```ml
_I_sfxSamples
```

Stores the i sfx samples collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L208)

<a id="global-global-i-sfxvolume-i-sfxvolume-src-i-sound-ml-327968385"></a>
### _I_sfxVolume

```ml
_I_sfxVolume
```

Tracks the mutable i sfx volume value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L193)

<a id="global-global-i-songdata-i-songdata-src-i-sound-ml-1221036969"></a>
### _I_songData

```ml
_I_songData
```

Stores the i song data collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L266)

<a id="global-global-i-soundtimerenabled-i-soundtimerenabled-src-i-sound-ml-758955617"></a>
### _I_soundTimerEnabled

```ml
_I_soundTimerEnabled
```

Tracks whether i sound timer enabled is active in the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L320)

<a id="global-global-i-steptable-i-steptable-src-i-sound-ml-1552249915"></a>
### _I_stepTable

```ml
_I_stepTable
```

Stores the i step table collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L199)

- [_I_wavebuf_t](Type-i-wavebuf-t-1761960035.md) — struct
<a id="global-global-i-wavebuffers-i-wavebuffers-src-i-sound-ml-1505241079"></a>
### _I_waveBuffers

```ml
_I_waveBuffers
```

Stores the i wave buffers collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L246)

<a id="global-global-i-wavehandle-i-wavehandle-src-i-sound-ml-1709465633"></a>
### _I_waveHandle

```ml
_I_waveHandle
```

Tracks the mutable i wave handle value used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L249)

<a id="global-global-i-waveready-i-waveready-src-i-sound-ml-729811839"></a>
### _I_waveReady

```ml
_I_waveReady
```

Tracks whether i wave ready is active in the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L252)

<a id="function-function-is-calcstereovolumes-inline-function-is-calcstereovolumes-vol127-sep-src-i-sound-ml-1429092061"></a>
### _IS_CalcStereoVolumes

```ml
inline function _IS_CalcStereoVolumes(vol127, sep)
```

Applies Doom's quadratic separation curve and returns clamped left/right 0..127 channel gains.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `vol127` | `dynamic` | — | Vol127 value supplied to `_IS_CalcStereoVolumes`. |
| `sep` | `dynamic` | — | Sep value supplied to `_IS_CalcStereoVolumes`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L392)

<a id="function-function-is-clamp-inline-function-is-clamp-v-lo-hi-src-i-sound-ml-130111648"></a>
### _IS_Clamp

```ml
inline function _IS_Clamp(v, lo, hi)
```

Converts and clamps a scalar to an inclusive mixer/MIDI range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `lo` | `dynamic` | — | Inclusive lower bound. |
| `hi` | `dynamic` | — | Inclusive upper bound. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L370)

<a id="function-function-is-clamps16-inline-function-is-clamps16-v-src-i-sound-ml-1254441162"></a>
### _IS_ClampS16

```ml
inline function _IS_ClampS16(v)
```

Saturates a mixed accumulator to the signed 16-bit PCM sample range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L917)

<a id="function-function-is-ensuresfxcachesize-function-is-ensuresfxcachesize-src-i-sound-ml-1646299263"></a>
### _IS_EnsureSfxCacheSize

```ml
function _IS_EnsureSfxCacheSize()
```

Resizes per-SFX rate/sample/length caches to the metadata table while preserving existing entries.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L501)

<a id="function-function-is-enumindex-inline-function-is-enumindex-v-fallback-src-i-sound-ml-704483180"></a>
### _IS_EnumIndex

```ml
inline function _IS_EnumIndex(v, fallback)
```

Converts enum-compatible integer values without accepting fractional numbers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L483)

<a id="function-function-is-findchannelbyhandle-inline-function-is-findchannelbyhandle-handle-src-i-sound-ml-366046998"></a>
### _IS_FindChannelByHandle

```ml
inline function _IS_FindChannelByHandle(handle)
```

Resolves a public sound handle to its active software channel index, or minus one when stale.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `_IS_FindChannelByHandle`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L735)

<a id="function-function-is-findchannelfornewsound-function-is-findchannelfornewsound-sid-src-i-sound-ml-340540009"></a>
### _IS_FindChannelForNewSound

```ml
function _IS_FindChannelForNewSound(sid)
```

Reuses a free mixing channel, otherwise evicting the oldest after enforcing single-instance effects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sid` | `dynamic` | — | Sid value supplied to `_IS_FindChannelForNewSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L681)

<a id="constant-constant-is-gmem-fixed-const-is-gmem-fixed-0-src-i-sound-ml-83971064"></a>
### _IS_GMEM_FIXED

```ml
const _IS_GMEM_FIXED = 0
```

Defines is gmem fixed for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L175)

<a id="function-function-is-initmixscaletable-inline-function-is-initmixscaletable-src-i-sound-ml-1771016840"></a>
### _IS_InitMixScaleTable

```ml
inline function _IS_InitMixScaleTable()
```

Precomputes exact 8-bit sample scaling so the mixer can avoid per-sample division.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L559)

<a id="function-function-is-initsteptable-inline-function-is-initsteptable-src-i-sound-ml-895429972"></a>
### _IS_InitStepTable

```ml
inline function _IS_InitStepTable()
```

Precomputes 16.16 pitch steps for every signed Doom pitch offset.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L540)

<a id="function-function-is-isseq-inline-function-is-isseq-v-src-i-sound-ml-1805780770"></a>
### _IS_IsSeq

```ml
inline function _IS_IsSeq(v)
```

Accepts either array or list storage used by translated audio tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L325)

<a id="function-function-is-loadsfxdata-function-is-loadsfxdata-sid-src-i-sound-ml-1914014727"></a>
### _IS_LoadSfxData

```ml
function _IS_LoadSfxData(sid)
```

Decodes and caches a DMX sound lump's sample rate and unsigned 8-bit PCM payload by SFX id.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sid` | `dynamic` | — | Sid value supplied to `_IS_LoadSfxData`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L627)

<a id="function-function-is-mapmuschannel-function-is-mapmuschannel-mchan-src-i-sound-ml-472440054"></a>
### _IS_MapMusChannel

```ml
function _IS_MapMusChannel(mchan)
```

Assigns a stable non-percussion MIDI channel to a MUS channel, with MUS channel 15 mapped to percussion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mchan` | `dynamic` | — | Mchan value supplied to `_IS_MapMusChannel`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1141)

<a id="constant-constant-is-midi-mapper-const-is-midi-mapper-4294967295-src-i-sound-ml-881605171"></a>
### _IS_MIDI_MAPPER

```ml
const _IS_MIDI_MAPPER = 4294967295
```

Defines is midi mapper for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L172)

<a id="function-function-is-midiallnotesoff-inline-function-is-midiallnotesoff-src-i-sound-ml-251425236"></a>
### _IS_MidiAllNotesOff

```ml
inline function _IS_MidiAllNotesOff()
```

Sends both all-notes-off and all-sound-off controllers on every MIDI channel.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1086)

<a id="function-function-is-midiinit-inline-function-is-midiinit-src-i-sound-ml-219419256"></a>
### _IS_MidiInit

```ml
inline function _IS_MidiInit()
```

Opens the platform MIDI backend once and stores its pointer-sized output handle.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1014)

<a id="function-function-is-midimsg2-inline-function-is-midimsg2-status-data1-src-i-sound-ml-1816811683"></a>
### _IS_MidiMsg2

```ml
inline function _IS_MidiMsg2(status, data1)
```

Packs and sends a two-byte MIDI message, reporting only the first failure in developer mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `status` | `dynamic` | — | Status value supplied to `_IS_MidiMsg2`. |
| `data1` | `dynamic` | — | Data1 value supplied to `_IS_MidiMsg2`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1048)

<a id="function-function-is-midimsg3-inline-function-is-midimsg3-status-data1-data2-src-i-sound-ml-593021253"></a>
### _IS_MidiMsg3

```ml
inline function _IS_MidiMsg3(status, data1, data2)
```

Packs and sends a three-byte MIDI message, reporting only the first failure in developer mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `status` | `dynamic` | — | Status value supplied to `_IS_MidiMsg3`. |
| `data1` | `dynamic` | — | Data1 value supplied to `_IS_MidiMsg3`. |
| `data2` | `dynamic` | — | Data2 value supplied to `_IS_MidiMsg3`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1068)

<a id="function-function-is-midishutdown-inline-function-is-midishutdown-src-i-sound-ml-867293716"></a>
### _IS_MidiShutdown

```ml
inline function _IS_MidiShutdown()
```

Resets all MIDI voices, closes the mapper handle, and clears local ownership.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1034)

<a id="constant-constant-is-mix-buf-bytes-const-is-mix-buf-bytes-is-mix-samples-4-src-i-sound-ml-87601226"></a>
### _IS_MIX_BUF_BYTES

```ml
const _IS_MIX_BUF_BYTES = _IS_MIX_SAMPLES * 4
```

Defines is mix buf bytes for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L154)

<a id="constant-constant-is-mix-rate-const-is-mix-rate-11025-src-i-sound-ml-1552499645"></a>
### _IS_MIX_RATE

```ml
const _IS_MIX_RATE = 11025
```

Defines is mix rate for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L148)

<a id="constant-constant-is-mix-samples-const-is-mix-samples-512-src-i-sound-ml-1733116440"></a>
### _IS_MIX_SAMPLES

```ml
const _IS_MIX_SAMPLES = 512
```

Defines is mix samples for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L151)

<a id="function-function-is-mixtobytes-function-is-mixtobytes-outb-src-i-sound-ml-1538706845"></a>
### _IS_MixToBytes

```ml
function _IS_MixToBytes(outb)
```

Mixes active unsigned 8-bit SFX channels into an interleaved signed 16-bit stereo PCM block.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `outb` | `dynamic` | — | Outb value supplied to `_IS_MixToBytes`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L927)

<a id="function-function-is-musctrltomidi-inline-function-is-musctrltomidi-ctrl-src-i-sound-ml-259076753"></a>
### _IS_MusCtrlToMidi

```ml
inline function _IS_MusCtrlToMidi(ctrl)
```

Maps Doom MUS controller numbers to their General MIDI controller equivalents.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ctrl` | `dynamic` | — | Ctrl value supplied to `_IS_MusCtrlToMidi`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1118)

<a id="function-function-is-musicfindslotindex-inline-function-is-musicfindslotindex-handle-src-i-sound-ml-831800532"></a>
### _IS_MusicFindSlotIndex

```ml
inline function _IS_MusicFindSlotIndex(handle)
```

Resolves a registered song handle to its metadata slot, or minus one when unregistered.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `_IS_MusicFindSlotIndex`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1202)

<a id="function-function-is-musicprocessslice-function-is-musicprocessslice-src-i-sound-ml-1179866863"></a>
### _IS_MusicProcessSlice

```ml
function _IS_MusicProcessSlice()
```

Translates MUS events into MIDI messages until a timed slice boundary or score end is reached.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1326)

<a id="function-function-is-musicresetruntime-function-is-musicresetruntime-src-i-sound-ml-1958437135"></a>
### _IS_MusicResetRuntime

```ml
function _IS_MusicResetRuntime()
```

Resets MUS channel velocities/mappings, reserves MIDI percussion channel 10, and clears timing fractions.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1099)

<a id="function-function-is-musicrestart-inline-function-is-musicrestart-src-i-sound-ml-2100408098"></a>
### _IS_MusicRestart

```ml
inline function _IS_MusicRestart()
```

Silences current notes and rewinds a looping MUS score to its first event with fresh channel mappings.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1452)

<a id="function-function-is-musicrunticks-function-is-musicrunticks-ticks-src-i-sound-ml-1917726887"></a>
### _IS_MusicRunTicks

```ml
function _IS_MusicRunTicks(ticks)
```

Consumes a bounded number of 140-Hz MUS ticks, honoring delays, looping, pause, and malformed-score guards.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ticks` | `dynamic` | — | Ticks value supplied to `_IS_MusicRunTicks`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1466)

<a id="function-function-is-musicscale7-inline-function-is-musicscale7-v-src-i-sound-ml-2053645158"></a>
### _IS_MusicScale7

```ml
inline function _IS_MusicScale7(v)
```

Applies sequencer-side master gain on Windows MIDI devices that may ignore midiOutSetVolume; Linux delegates gain to FluidSynth.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1169)

<a id="function-function-is-musicsetslotplaying-inline-function-is-musicsetslotplaying-handle-playing-looping-src-i-sound-ml-637775986"></a>
### _IS_MusicSetSlotPlaying

```ml
inline function _IS_MusicSetSlotPlaying(handle, playing, looping)
```

Updates the looping and playing flags stored with a registered song handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `_IS_MusicSetSlotPlaying`. |
| `playing` | `dynamic` | — | Playing value supplied to `_IS_MusicSetSlotPlaying`. |
| `looping` | `dynamic` | — | Looping value supplied to `_IS_MusicSetSlotPlaying`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1223)

<a id="function-function-is-musicstartinternal-function-is-musicstartinternal-handle-data-looping-src-i-sound-ml-1831176697"></a>
### _IS_MusicStartInternal

```ml
function _IS_MusicStartInternal(handle, data, looping)
```

Validates a MUS score header/range and initializes decoder, timing, loop, and registration state for playback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `_IS_MusicStartInternal`. |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `looping` | `dynamic` | — | Looping value supplied to `_IS_MusicStartInternal`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1279)

<a id="function-function-is-musicstopinternal-function-is-musicstopinternal-updateslot-src-i-sound-ml-502586674"></a>
### _IS_MusicStopInternal

```ml
function _IS_MusicStopInternal(updateSlot)
```

Silences MIDI, clears the active MUS decoder/timing state, and optionally marks its song slot stopped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `updateSlot` | `dynamic` | — | Update slot value supplied to `_IS_MusicStopInternal`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1236)

<a id="function-function-is-musicticker-function-is-musicticker-src-i-sound-ml-1155815333"></a>
### _IS_MusicTicker

```ml
function _IS_MusicTicker()
```

Converts elapsed milliseconds to fractional 140-Hz MUS ticks and advances active playback with stall clamping.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1521)

<a id="function-function-is-normalizevolume127-inline-function-is-normalizevolume127-v-src-i-sound-ml-1315243494"></a>
### _IS_NormalizeVolume127

```ml
inline function _IS_NormalizeVolume127(v)
```

Converts legacy 0..15 Doom volume values to 0..127 while accepting already normalized MIDI-scale values.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L380)

<a id="constant-constant-is-num-mix-channels-const-is-num-mix-channels-8-src-i-sound-ml-1448598698"></a>
### _IS_NUM_MIX_CHANNELS

```ml
const _IS_NUM_MIX_CHANNELS = 8
```

Defines the is num mix channels count used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L157)

<a id="constant-constant-is-num-wave-bufs-const-is-num-wave-bufs-4-src-i-sound-ml-752504920"></a>
### _IS_NUM_WAVE_BUFS

```ml
const _IS_NUM_WAVE_BUFS = 4
```

Defines the is num wave bufs count used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L160)

<a id="function-function-is-pitchtostep-inline-function-is-pitchtostep-pitch-rate-src-i-sound-ml-254383688"></a>
### _IS_PitchToStep

```ml
inline function _IS_PitchToStep(pitch, rate)
```

Combines Doom pitch and source sample rate into a positive 16.16 mixer cursor step.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pitch` | `dynamic` | — | Pitch value supplied to `_IS_PitchToStep`. |
| `rate` | `dynamic` | — | Rate value supplied to `_IS_PitchToStep`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L718)

<a id="function-function-is-readmusvarlen-inline-function-is-readmusvarlen-data-posref-src-i-sound-ml-1089546639"></a>
### _IS_ReadMusVarLen

```ml
inline function _IS_ReadMusVarLen(data, posref)
```

Decodes a bounded MUS base-128 variable-length delay and advances the caller's byte cursor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `posref` | `dynamic` | — | Posref value supplied to `_IS_ReadMusVarLen`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1182)

<a id="function-function-is-readu16-inline-function-is-readu16-buf-off-src-i-sound-ml-1838309350"></a>
### _IS_ReadU16

```ml
inline function _IS_ReadU16(buf, off)
```

Reads a checked unsigned little-endian 16-bit field, returning zero outside the buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_IS_ReadU16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L451)

<a id="function-function-is-readu32-inline-function-is-readu32-buf-off-src-i-sound-ml-92642286"></a>
### _IS_ReadU32

```ml
inline function _IS_ReadU32(buf, off)
```

Reads a checked unsigned little-endian 32-bit field, returning zero outside the buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_IS_ReadU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L462)

<a id="function-function-is-readu64-inline-function-is-readu64-buf-off-src-i-sound-ml-1628985466"></a>
### _IS_ReadU64

```ml
inline function _IS_ReadU64(buf, off)
```

Reconstructs a pointer-sized little-endian value from two checked 32-bit words.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_IS_ReadU64`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L473)

<a id="function-function-is-resetchannels-function-is-resetchannels-src-i-sound-ml-610140537"></a>
### _IS_ResetChannels

```ml
function _IS_ResetChannels()
```

Reinitializes every software mixing channel to an inactive, centered, empty state.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L579)

<a id="function-function-is-setchannelvolumes-inline-function-is-setchannelvolumes-slot-vol-sep-src-i-sound-ml-1214155151"></a>
### _IS_SetChannelVolumes

```ml
inline function _IS_SetChannelVolumes(slot, vol, sep)
```

Stores Doom's separation-adjusted left/right gains for one checked software mixing channel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_IS_SetChannelVolumes`. |
| `vol` | `dynamic` | — | Vol value supplied to `_IS_SetChannelVolumes`. |
| `sep` | `dynamic` | — | Sep value supplied to `_IS_SetChannelVolumes`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L610)

<a id="function-function-is-shouldsingleinstance-inline-function-is-shouldsingleinstance-sid-src-i-sound-ml-282989998"></a>
### _IS_ShouldSingleInstance

```ml
inline function _IS_ShouldSingleInstance(sid)
```

Identifies chainsaw, platform-move, and pistol effects that replace an existing identical channel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sid` | `dynamic` | — | Sid value supplied to `_IS_ShouldSingleInstance`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L667)

<a id="function-function-is-stopallsfx-inline-function-is-stopallsfx-src-i-sound-ml-707566290"></a>
### _IS_StopAllSfx

```ml
inline function _IS_StopAllSfx()
```

Marks every software SFX channel inactive without disturbing music playback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L752)

<a id="function-function-is-tickms-inline-function-is-tickms-src-i-sound-ml-1472512848"></a>
### _IS_TickMs

```ml
inline function _IS_TickMs()
```

Returns the platform millisecond clock used to schedule MUS playback.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L492)

<a id="function-function-is-toint-inline-function-is-toint-v-fallback-src-i-sound-ml-1303043068"></a>
### _IS_ToInt

```ml
inline function _IS_ToInt(v, fallback)
```

Converts numeric or numeric-string values by truncating toward zero, otherwise returning the supplied fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L335)

<a id="constant-constant-is-wave-mapper-const-is-wave-mapper-4294967295-src-i-sound-ml-1712380795"></a>
### _IS_WAVE_MAPPER

```ml
const _IS_WAVE_MAPPER = 4294967295
```

Defines is wave mapper for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L169)

<a id="function-function-is-wavefindfreebuffer-inline-function-is-wavefindfreebuffer-src-i-sound-ml-1764939618"></a>
### _IS_WaveFindFreeBuffer

```ml
inline function _IS_WaveFindFreeBuffer()
```

Returns the first waveform ring slot not currently owned by WinMM, or minus one when saturated.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L899)

<a id="function-function-is-waveformat-inline-function-is-waveformat-src-i-sound-ml-1269905398"></a>
### _IS_WaveFormat

```ml
inline function _IS_WaveFormat()
```

Builds the PCM WAVEFORMATEX for 11,025-Hz stereo signed 16-bit mixer output.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L763)

<a id="constant-constant-is-wavehdr-size-const-is-wavehdr-size-48-src-i-sound-ml-126797950"></a>
### _IS_WAVEHDR_SIZE

```ml
const _IS_WAVEHDR_SIZE = 48
```

Defines is wavehdr size for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L163)

<a id="function-function-is-waveinit-function-is-waveinit-src-i-sound-ml-576213747"></a>
### _IS_WaveInit

```ml
function _IS_WaveInit()
```

Opens WinMM waveform output and allocates/prepares the fixed ring of unmanaged PCM buffers.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L777)

<a id="function-function-is-waveisdone-inline-function-is-waveisdone-wb-src-i-sound-ml-232526613"></a>
### _IS_WaveIsDone

```ml
inline function _IS_WaveIsDone(wb)
```

Reads a submitted WAVEHDR's WHDR_DONE flag, treating never-submitted buffers as immediately reusable.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wb` | `dynamic` | — | Wb value supplied to `_IS_WaveIsDone`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L869)

<a id="function-function-is-waverefresh-inline-function-is-waverefresh-src-i-sound-ml-667749524"></a>
### _IS_WaveRefresh

```ml
inline function _IS_WaveRefresh()
```

Marks submitted ring buffers reusable after WinMM reports their headers complete.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L883)

<a id="function-function-is-waveshutdown-function-is-waveshutdown-src-i-sound-ml-814081871"></a>
### _IS_WaveShutdown

```ml
function _IS_WaveShutdown()
```

Resets waveform output, unprepares every header, frees unmanaged buffers, and closes the device.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L832)

<a id="function-function-is-wavesubmitmixedbuffer-function-is-wavesubmitmixedbuffer-src-i-sound-ml-1858092271"></a>
### _IS_WaveSubmitMixedBuffer

```ml
function _IS_WaveSubmitMixedBuffer()
```

Fills one free unmanaged waveform buffer with a mixed block and queues its prepared header to WinMM.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L990)

<a id="constant-constant-is-whdr-done-const-is-whdr-done-1-src-i-sound-ml-994991989"></a>
### _IS_WHDR_DONE

```ml
const _IS_WHDR_DONE = 1
```

Defines is whdr done for the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L166)

<a id="function-function-is-writeu16-inline-function-is-writeu16-buf-off-value-src-i-sound-ml-1693067415"></a>
### _IS_WriteU16

```ml
inline function _IS_WriteU16(buf, off, value)
```

Writes one non-negative unsigned 16-bit value in little-endian order to a WinMM structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_IS_WriteU16`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L410)

<a id="function-function-is-writeu32-inline-function-is-writeu32-buf-off-value-src-i-sound-ml-624633563"></a>
### _IS_WriteU32

```ml
inline function _IS_WriteU32(buf, off, value)
```

Writes one non-negative unsigned 32-bit value in little-endian order to a WinMM structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_IS_WriteU32`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L423)

<a id="function-function-is-writeu64-inline-function-is-writeu64-buf-off-value-src-i-sound-ml-1780302845"></a>
### _IS_WriteU64

```ml
inline function _IS_WriteU64(buf, off, value)
```

Writes a pointer-sized 64-bit value as two little-endian words in a WinMM structure buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buf` | `dynamic` | — | Buf value supplied to `_IS_WriteU64`. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `value` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L438)

<a id="function-function-isnd-idiv-inline-function-isnd-idiv-a-b-src-i-sound-ml-2058769245"></a>
### _ISnd_IDiv

```ml
inline function _ISnd_IDiv(a, b)
```

Divides mixer integers with truncation toward zero and returns zero for a zero divisor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L356)

<a id="function-function-addsfx-function-addsfx-sfxid-volume-step-seperation-src-i-sound-ml-1292713171"></a>
### addsfx

```ml
function addsfx(sfxid, volume, step, seperation)
```

Assigns cached PCM to a mixing channel, initializes cursor/gains, and returns a unique playback handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfxid` | `dynamic` | — | Sfxid value supplied to `addsfx`. |
| `volume` | `dynamic` | — | Volume value supplied to `addsfx`. |
| `step` | `dynamic` | — | Step value supplied to `addsfx`. |
| `seperation` | `dynamic` | — | Seperation value supplied to `addsfx`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1856)

<a id="function-function-getsfx-function-getsfx-name-lenout-src-i-sound-ml-650364777"></a>
### getsfx

```ml
function getsfx(name, lenOut)
```

Loads a named `DS*` sound lump and writes its byte length through the legacy output reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `lenOut` | `dynamic` | — | Len out value supplied to `getsfx`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1834)

<a id="extern_function-extern-function-globalalloc-extern-function-globalalloc-flags-as-u32-size-as-u32-from-kernel32-dll-symbol-globalalloc-returns-ptr-src-i-sound-ml-409902495"></a>
### GlobalAlloc

```ml
extern function GlobalAlloc(flags as u32, size as u32) from "kernel32.dll" symbol "GlobalAlloc" returns ptr
```

Allocates fixed-address unmanaged storage for WinMM sample buffers and WAVEHDR records.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flags` | `u32` | — | Bit flags that control the operation. |
| `size` | `u32` | — | Requested size in bytes or elements. |


**Returns:** The resulting fixed-address unmanaged storage for WinMM sample buffers and WAVEHDR records.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L125)

<a id="extern_function-extern-function-globalfree-extern-function-globalfree-mem-as-ptr-from-kernel32-dll-symbol-globalfree-returns-ptr-src-i-sound-ml-833380547"></a>
### GlobalFree

```ml
extern function GlobalFree(mem as ptr) from "kernel32.dll" symbol "GlobalFree" returns ptr
```

Releases unmanaged WinMM buffer/header storage and returns null on success.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mem` | `ptr` | — | `ptr` value supplied as mem to `GlobalFree`. |


**Returns:** Result returned by the native `GlobalFree` binding as `ptr`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L131)

<a id="function-function-i-getsfxlumpnum-function-i-getsfxlumpnum-sfxinfo-src-i-sound-ml-505533936"></a>
### I_GetSfxLumpNum

```ml
function I_GetSfxLumpNum(sfxinfo)
```

Resolves an SFX metadata name to its `DS*` lump, falling back to the pistol sound when absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `sfxinfo` | `dynamic` | — | Sfxinfo value supplied to `I_GetSfxLumpNum`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1591)

<a id="function-function-i-handlesoundtimer-function-i-handlesoundtimer-src-i-sound-ml-651281695"></a>
### I_HandleSoundTimer

```ml
function I_HandleSoundTimer()
```

Preserves the legacy timer callback hook; WinMM/MUS advancement is driven by the main update loop.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1889)

<a id="function-function-i-initmusic-function-i-initmusic-src-i-sound-ml-1768395553"></a>
### I_InitMusic

```ml
function I_InitMusic()
```

Clears song registration/playback state, opens MIDI output, and applies the default master volume.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1675)

<a id="function-function-i-initsound-function-i-initsound-src-i-sound-ml-1264338381"></a>
### I_InitSound

```ml
function I_InitSound()
```

Initializes SFX caches/tables/channels, opens waveform output, and starts the MIDI music backend.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1548)

<a id="function-function-i-pausesong-function-i-pausesong-handle-src-i-sound-ml-1081518863"></a>
### I_PauseSong

```ml
function I_PauseSong(handle)
```

Pauses the active registered song, resets sounding MIDI notes, and updates its slot flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_PauseSong`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1718)

<a id="function-function-i-playsong-function-i-playsong-handle-looping-src-i-sound-ml-349515657"></a>
### I_PlaySong

```ml
function I_PlaySong(handle, looping)
```

Resolves a registered song, validates/starts its MUS stream, and records requested looping state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_PlaySong`. |
| `looping` | `dynamic` | — | Looping value supplied to `I_PlaySong`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1759)

<a id="function-function-i-precachesfx-function-i-precachesfx-id-src-i-sound-ml-1086435546"></a>
### I_PrecacheSfx

```ml
function I_PrecacheSfx(id)
```

Decodes one SFX id into the rate/sample cache before first playback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Id value supplied to `I_PrecacheSfx`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1605)

<a id="function-function-i-qrysongplaying-function-i-qrysongplaying-handle-src-i-sound-ml-1385331997"></a>
### I_QrySongPlaying

```ml
function I_QrySongPlaying(handle)
```

Reports whether the requested handle is the active, unpaused MUS song.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_QrySongPlaying`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1814)

<a id="function-function-i-registersong-function-i-registersong-data-src-i-sound-ml-1797909367"></a>
### I_RegisterSong

```ml
function I_RegisterSong(data)
```

Stores immutable MUS bytes under a new handle with initial stopped/non-looping metadata.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1745)

<a id="function-function-i-resumesong-function-i-resumesong-handle-src-i-sound-ml-1150755005"></a>
### I_ResumeSong

```ml
function I_ResumeSong(handle)
```

Resumes the active paused song from its MUS cursor with a rebased wall-clock timestamp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_ResumeSong`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1731)

<a id="function-function-i-setchannels-function-i-setchannels-src-i-sound-ml-2043678511"></a>
### I_SetChannels

```ml
function I_SetChannels()
```

Rebuilds the pitch table if needed and resets all software mixing channels.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1584)

<a id="function-function-i-setmusicvolume-function-i-setmusicvolume-volume-src-i-sound-ml-1971671213"></a>
### I_SetMusicVolume

```ml
function I_SetMusicVolume(volume)
```

Normalizes Doom music volume and applies it to both WinMM MIDI output channels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `volume` | `dynamic` | — | Volume value supplied to `I_SetMusicVolume`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1697)

<a id="function-function-i-setsfxvolume-function-i-setsfxvolume-volume-src-i-sound-ml-1877243865"></a>
### I_SetSfxVolume

```ml
function I_SetSfxVolume(volume)
```

Normalizes and stores the master SFX gain used when starting/mixing effects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `volume` | `dynamic` | — | Volume value supplied to `I_SetSfxVolume`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1711)

<a id="function-function-i-shutdownmusic-function-i-shutdownmusic-src-i-sound-ml-1252286321"></a>
### I_ShutdownMusic

```ml
function I_ShutdownMusic()
```

Stops the active MUS score and resets/closes the platform MIDI backend.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1690)

<a id="function-function-i-shutdownsound-function-i-shutdownsound-src-i-sound-ml-528136829"></a>
### I_ShutdownSound

```ml
function I_ShutdownSound()
```

Stops SFX, releases waveform buffers/device state, and shuts down registered MIDI music.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1577)

<a id="function-function-i-sounddeltimer-function-i-sounddeltimer-src-i-sound-ml-162024089"></a>
### I_SoundDelTimer

```ml
function I_SoundDelTimer()
```

Clears the legacy sound-timer enabled flag during backend teardown.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1902)

<a id="function-function-i-soundisplaying-function-i-soundisplaying-handle-src-i-sound-ml-199282925"></a>
### I_SoundIsPlaying

```ml
function I_SoundIsPlaying(handle)
```

Reports whether a sound handle still owns an active channel with unread PCM samples.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_SoundIsPlaying`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1643)

<a id="function-function-i-soundsettimer-function-i-soundsettimer-ticks-src-i-sound-ml-1630880039"></a>
### I_SoundSetTimer

```ml
function I_SoundSetTimer(ticks)
```

Marks the legacy sound timer enabled while ignoring its obsolete tick-period argument.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `ticks` | `dynamic` | — | Ticks value supplied to `I_SoundSetTimer`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1895)

<a id="function-function-i-startsound-function-i-startsound-id-vol-sep-pitch-priority-src-i-sound-ml-1272039505"></a>
### I_StartSound

```ml
function I_StartSound(id, vol, sep, pitch, priority)
```

Loads an SFX, derives its pitch step, assigns a mixing channel, and returns a public playback handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `id` | `dynamic` | — | Id value supplied to `I_StartSound`. |
| `vol` | `dynamic` | — | Vol value supplied to `I_StartSound`. |
| `sep` | `dynamic` | — | Sep value supplied to `I_StartSound`. |
| `pitch` | `dynamic` | — | Pitch value supplied to `I_StartSound`. |
| `priority` | `dynamic` | — | Playback or task priority used by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1617)

<a id="function-function-i-stopsong-function-i-stopsong-handle-src-i-sound-ml-107872333"></a>
### I_StopSong

```ml
function I_StopSong(handle)
```

Stops the active song decoder or clears only the metadata flags of a different registered handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_StopSong`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1777)

<a id="function-function-i-stopsound-function-i-stopsound-handle-src-i-sound-ml-1659252435"></a>
### I_StopSound

```ml
function I_StopSound(handle)
```

Deactivates the software mixing channel associated with a public sound handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_StopSound`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1635)

<a id="function-function-i-submitsound-function-i-submitsound-src-i-sound-ml-1767705745"></a>
### I_SubmitSound

```ml
function I_SubmitSound()
```

Fills every currently free WinMM ring slot with a freshly mixed PCM block.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1567)

<a id="function-function-i-unregistersong-function-i-unregistersong-handle-src-i-sound-ml-919685053"></a>
### I_UnRegisterSong

```ml
function I_UnRegisterSong(handle)
```

Stops a matching active song and removes its handle/data record from the registration table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_UnRegisterSong`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1789)

<a id="function-function-i-updatesound-function-i-updatesound-src-i-sound-ml-817754735"></a>
### I_UpdateSound

```ml
function I_UpdateSound()
```

Advances wall-clock-driven MUS/MIDI playback during the engine sound update.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1562)

<a id="function-function-i-updatesoundparams-function-i-updatesoundparams-handle-vol-sep-pitch-src-i-sound-ml-2144610604"></a>
### I_UpdateSoundParams

```ml
function I_UpdateSoundParams(handle, vol, sep, pitch)
```

Recomputes pitch step and stereo gains for an active sound handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `I_UpdateSoundParams`. |
| `vol` | `dynamic` | — | Vol value supplied to `I_UpdateSoundParams`. |
| `sep` | `dynamic` | — | Sep value supplied to `I_UpdateSoundParams`. |
| `pitch` | `dynamic` | — | Pitch value supplied to `I_UpdateSoundParams`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1662)

<a id="global-global-lengths-lengths-src-i-sound-ml-153334153"></a>
### lengths

```ml
lengths
```

Stores the lengths collection used by the i sound subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L195)

<a id="extern_function-extern-function-midioutclose-extern-function-midioutclose-hmo-as-ptr-from-winmm-dll-symbol-midioutclose-returns-u32-src-i-sound-ml-810316802"></a>
### midiOutClose

```ml
extern function midiOutClose(hmo as ptr) from "winmm.dll" symbol "midiOutClose" returns u32
```

Closes the Windows MIDI output handle after playback has stopped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hmo` | `ptr` | — | `ptr` value supplied as hmo to `midiOutClose`. |


**Returns:** Result returned by the native `midiOutClose` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L111)

<a id="extern_function-extern-function-midioutopen-extern-function-midioutopen-phmo-as-bytes-dev-as-u32-cb-as-ptr-inst-as-ptr-flags-as-u32-from-winmm-dll-symbol-midioutopen-returns-u32-src-i-sound-ml-1868703012"></a>
### midiOutOpen

```ml
extern function midiOutOpen(phmo as bytes, dev as u32, cb as ptr, inst as ptr, flags as u32) from "winmm.dll" symbol "midiOutOpen" returns u32
```

Opens the Windows MIDI mapper and writes its output handle to caller-owned storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `phmo` | `bytes` | — | `bytes` value supplied as phmo to `midiOutOpen`. |
| `dev` | `u32` | — | `u32` value supplied as dev to `midiOutOpen`. |
| `cb` | `ptr` | — | `ptr` value supplied as cb to `midiOutOpen`. |
| `inst` | `ptr` | — | `ptr` value supplied as inst to `midiOutOpen`. |
| `flags` | `u32` | — | Bit flags that control the operation. |


**Returns:** Result returned by the native `midiOutOpen` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L92)

<a id="extern_function-extern-function-midioutreset-extern-function-midioutreset-hmo-as-ptr-from-winmm-dll-symbol-midioutreset-returns-u32-src-i-sound-ml-1742852271"></a>
### midiOutReset

```ml
extern function midiOutReset(hmo as ptr) from "winmm.dll" symbol "midiOutReset" returns u32
```

Silences and resets every channel on the active Windows MIDI output device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hmo` | `ptr` | — | `ptr` value supplied as hmo to `midiOutReset`. |


**Returns:** Result returned by the native `midiOutReset` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L105)

<a id="extern_function-extern-function-midioutsetvolume-extern-function-midioutsetvolume-hmo-as-ptr-vol-as-u32-from-winmm-dll-symbol-midioutsetvolume-returns-u32-src-i-sound-ml-580538427"></a>
### midiOutSetVolume

```ml
extern function midiOutSetVolume(hmo as ptr, vol as u32) from "winmm.dll" symbol "midiOutSetVolume" returns u32
```

Applies a packed left/right 16-bit master volume to the MIDI output device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hmo` | `ptr` | — | `ptr` value supplied as hmo to `midiOutSetVolume`. |
| `vol` | `u32` | — | `u32` value supplied as vol to `midiOutSetVolume`. |


**Returns:** Result returned by the native `midiOutSetVolume` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L118)

<a id="extern_function-extern-function-midioutshortmsg-extern-function-midioutshortmsg-hmo-as-ptr-msg-as-u32-from-winmm-dll-symbol-midioutshortmsg-returns-u32-src-i-sound-ml-1078622694"></a>
### midiOutShortMsg

```ml
extern function midiOutShortMsg(hmo as ptr, msg as u32) from "winmm.dll" symbol "midiOutShortMsg" returns u32
```

Sends one packed channel/system MIDI message to the active output device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hmo` | `ptr` | — | `ptr` value supplied as hmo to `midiOutShortMsg`. |
| `msg` | `u32` | — | `u32` value supplied as msg to `midiOutShortMsg`. |


**Returns:** Result returned by the native `midiOutShortMsg` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L99)

<a id="function-function-myioctl-function-myioctl-fd-req-arg-src-i-sound-ml-518895515"></a>
### myioctl

```ml
function myioctl(fd, req, arg)
```

Retains the legacy Unix audio-control entry point as a deterministic no-op on WinMM.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fd` | `dynamic` | — | Fd value supplied to `myioctl`. |
| `req` | `dynamic` | — | Req value supplied to `myioctl`. |
| `arg` | `dynamic` | — | Arg value supplied to `myioctl`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L1824)

<a id="extern_function-extern-function-rtlmovememoryfromptr-extern-function-rtlmovememoryfromptr-dst-as-bytes-src-as-ptr-len-as-u32-from-kernel32-dll-symbol-rtlmovememory-returns-void-src-i-sound-ml-1898916798"></a>
### RtlMoveMemoryFromPtr

```ml
extern function RtlMoveMemoryFromPtr(dst as bytes, src as ptr, len as u32) from "kernel32.dll" symbol "RtlMoveMemory" returns void
```

Copies an unmanaged WAVEHDR record into managed bytes for flag inspection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `bytes` | — | `bytes` value supplied as dst to `RtlMoveMemoryFromPtr`. |
| `src` | `ptr` | — | `ptr` value supplied as src to `RtlMoveMemoryFromPtr`. |
| `len` | `u32` | — | `u32` value supplied as len to `RtlMoveMemoryFromPtr`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L143)

<a id="extern_function-extern-function-rtlmovememorytoptr-extern-function-rtlmovememorytoptr-dst-as-ptr-src-as-bytes-len-as-u32-from-kernel32-dll-symbol-rtlmovememory-returns-void-src-i-sound-ml-2027316784"></a>
### RtlMoveMemoryToPtr

```ml
extern function RtlMoveMemoryToPtr(dst as ptr, src as bytes, len as u32) from "kernel32.dll" symbol "RtlMoveMemory" returns void
```

Copies a managed byte buffer into fixed unmanaged WinMM storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dst` | `ptr` | — | `ptr` value supplied as dst to `RtlMoveMemoryToPtr`. |
| `src` | `bytes` | — | `bytes` value supplied as src to `RtlMoveMemoryToPtr`. |
| `len` | `u32` | — | `u32` value supplied as len to `RtlMoveMemoryToPtr`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L137)

<a id="extern_function-extern-function-waveoutclose-extern-function-waveoutclose-hwo-as-ptr-from-winmm-dll-symbol-waveoutclose-returns-u32-src-i-sound-ml-328214436"></a>
### waveOutClose

```ml
extern function waveOutClose(hwo as ptr) from "winmm.dll" symbol "waveOutClose" returns u32
```

Closes a reset waveform output handle after all headers have been unprepared.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwo` | `ptr` | — | `ptr` value supplied as hwo to `waveOutClose`. |


**Returns:** Result returned by the native `waveOutClose` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L82)

<a id="extern_function-extern-function-waveoutopen-extern-function-waveoutopen-phwo-as-bytes-dev-as-u32-pwfx-as-bytes-cb-as-ptr-inst-as-ptr-flags-as-u32-from-winmm-dll-symbol-waveoutopen-returns-u32-src-i-sound-ml-195472144"></a>
### waveOutOpen

```ml
extern function waveOutOpen(phwo as bytes, dev as u32, pwfx as bytes, cb as ptr, inst as ptr, flags as u32) from "winmm.dll" symbol "waveOutOpen" returns u32
```

Opens the WinMM waveform mapper with the supplied PCM format and writes the device handle to caller storage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `phwo` | `bytes` | — | `bytes` value supplied as phwo to `waveOutOpen`. |
| `dev` | `u32` | — | `u32` value supplied as dev to `waveOutOpen`. |
| `pwfx` | `bytes` | — | Native wave-format descriptor. |
| `cb` | `ptr` | — | `ptr` value supplied as cb to `waveOutOpen`. |
| `inst` | `ptr` | — | `ptr` value supplied as inst to `waveOutOpen`. |
| `flags` | `u32` | — | Bit flags that control the operation. |


**Returns:** Result returned by the native `waveOutOpen` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L46)

<a id="extern_function-extern-function-waveoutprepareheader-extern-function-waveoutprepareheader-hwo-as-ptr-pwh-as-ptr-cbwh-as-u32-from-winmm-dll-symbol-waveoutprepareheader-returns-u32-src-i-sound-ml-2144017293"></a>
### waveOutPrepareHeader

```ml
extern function waveOutPrepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutPrepareHeader" returns u32
```

Registers one unmanaged WAVEHDR with an open waveform device before queued playback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwo` | `ptr` | — | `ptr` value supplied as hwo to `waveOutPrepareHeader`. |
| `pwh` | `ptr` | — | `ptr` value supplied as pwh to `waveOutPrepareHeader`. |
| `cbwh` | `u32` | — | `u32` value supplied as cbwh to `waveOutPrepareHeader`. |


**Returns:** Result returned by the native `waveOutPrepareHeader` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L54)

<a id="extern_function-extern-function-waveoutreset-extern-function-waveoutreset-hwo-as-ptr-from-winmm-dll-symbol-waveoutreset-returns-u32-src-i-sound-ml-1432651265"></a>
### waveOutReset

```ml
extern function waveOutReset(hwo as ptr) from "winmm.dll" symbol "waveOutReset" returns u32
```

Stops waveform playback and returns all queued buffers to the application.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwo` | `ptr` | — | `ptr` value supplied as hwo to `waveOutReset`. |


**Returns:** Result returned by the native `waveOutReset` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L76)

<a id="extern_function-extern-function-waveoutunprepareheader-extern-function-waveoutunprepareheader-hwo-as-ptr-pwh-as-ptr-cbwh-as-u32-from-winmm-dll-symbol-waveoutunprepareheader-returns-u32-src-i-sound-ml-219527094"></a>
### waveOutUnprepareHeader

```ml
extern function waveOutUnprepareHeader(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutUnprepareHeader" returns u32
```

Releases WinMM ownership of a completed WAVEHDR before its unmanaged memory is freed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwo` | `ptr` | — | `ptr` value supplied as hwo to `waveOutUnprepareHeader`. |
| `pwh` | `ptr` | — | `ptr` value supplied as pwh to `waveOutUnprepareHeader`. |
| `cbwh` | `u32` | — | `u32` value supplied as cbwh to `waveOutUnprepareHeader`. |


**Returns:** Result returned by the native `waveOutUnprepareHeader` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L70)

<a id="extern_function-extern-function-waveoutwrite-extern-function-waveoutwrite-hwo-as-ptr-pwh-as-ptr-cbwh-as-u32-from-winmm-dll-symbol-waveoutwrite-returns-u32-src-i-sound-ml-1972619686"></a>
### waveOutWrite

```ml
extern function waveOutWrite(hwo as ptr, pwh as ptr, cbwh as u32) from "winmm.dll" symbol "waveOutWrite" returns u32
```

Queues a prepared WAVEHDR buffer for asynchronous playback on the waveform device.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hwo` | `ptr` | — | `ptr` value supplied as hwo to `waveOutWrite`. |
| `pwh` | `ptr` | — | `ptr` value supplied as pwh to `waveOutWrite`. |
| `cbwh` | `u32` | — | `u32` value supplied as cbwh to `waveOutWrite`. |


**Returns:** Result returned by the native `waveOutWrite` binding as `u32`.

[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/i_sound.ml#L62)
