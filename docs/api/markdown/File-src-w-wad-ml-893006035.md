# `src/w_wad.ml`

[Home](README.md) · [Files](Files.md)

Implements WAD/lump lookup, caching, and resource loading helpers.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `d_main.ml` → [src/d_main.ml](File-src-d-main-ml-105344057.md)
- `doomtype.ml` → [src/doomtype.ml](File-src-doomtype-ml-372549946.md)
- `i_system.ml` → [src/i_system.ml](File-src-i-system-ml-1632920966.md)
- `m_argv.ml` → [src/m_argv.ml](File-src-m-argv-ml-728984635.md)
- `m_swap.ml` → [src/m_swap.ml](File-src-m-swap-ml-1401834276.md)
- `std/fs.ml` as `fs` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/fs.ml` — external dependency
- `std/math.ml` → `../MiniLangCompilerOptimization/MiniLangCompilerPy/std/math.ml` — external dependency
- `w_wad.ml` → [src/w_wad.ml](File-src-w-wad-ml-893006035.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="function-function-w-addcacheddataname-function-w-addcacheddataname-data-name-src-w-wad-ml-1575708347"></a>
### _W_AddCachedDataName

```ml
function _W_AddCachedDataName(data, name)
```

Appends one data/name pair to the cached lump name lookup without using concatenation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L763)

<a id="function-function-w-addfilesfromargv-function-w-addfilesfromargv-src-w-wad-ml-1344187434"></a>
### _W_AddFilesFromArgv

```ml
function _W_AddFilesFromArgv()
```

Adds files from argument entries to the WAD resource.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L500)

<a id="function-function-w-addloadedfile-inline-function-w-addloadedfile-path-data-src-w-wad-ml-209992992"></a>
### _W_AddLoadedFile

```ml
inline function _W_AddLoadedFile(path, data)
```

Appends an in-memory WAD file record and returns the stable index stored by its lump directory entries.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L374)

<a id="constant-constant-w-cache-null-ptr-const-w-cache-null-ptr-1-src-w-wad-ml-1004994051"></a>
### _W_CACHE_NULL_PTR

```ml
const _W_CACHE_NULL_PTR = -1
```

Defines w cache null ptr for the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L84)

<a id="function-function-w-copybytes-inline-function-w-copybytes-b-off-n-src-w-wad-ml-1096648412"></a>
### _W_CopyBytes

```ml
inline function _W_CopyBytes(b, off, n)
```

Returns an independent byte slice for a requested WAD-file range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |
| `n` | `dynamic` | — | Number of values to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L118)

<a id="function-function-w-extractfilebase-function-w-extractfilebase-path-src-w-wad-ml-1674049095"></a>
### _W_ExtractFileBase

```ml
function _W_ExtractFileBase(path)
```

Extracts an uppercase, extension-free filename into an eight-byte lump name and rejects overlong bases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L232)

<a id="global-global-w-files-w-files-src-w-wad-ml-123289318"></a>
### _W_files

```ml
_W_files
```

Stores the w files collection used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L96)

<a id="function-function-w-inttostring-function-w-inttostring-v-src-w-wad-ml-1516925708"></a>
### _W_IntToString

```ml
function _W_IntToString(v)
```

Formats integer values for WAD diagnostics without implicit stringification.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L300)

<a id="function-function-w-ishdwaddata-inline-function-w-ishdwaddata-data-src-w-wad-ml-30692211"></a>
### _W_IsHDWADData

```ml
inline function _W_IsHDWADData(data)
```

Validates the minimum header length and four-byte MDHD signature of an in-memory HDWAD package.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L224)

<a id="function-function-w-iswadfilename-inline-function-w-iswadfilename-path-src-w-wad-ml-665100150"></a>
### _W_IsWadFilename

```ml
inline function _W_IsWadFilename(path)
```

Recognizes a case-insensitive .wad suffix without allocating a normalized path copy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L205)

<a id="function-function-w-name8equals-inline-function-w-name8equals-a-b-src-w-wad-ml-981933592"></a>
### _W_Name8Equals

```ml
inline function _W_Name8Equals(a, b)
```

Compares two canonical eight-byte lump names without string allocation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | First input operand. |
| `b` | `dynamic` | — | Second input operand. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L194)

<a id="function-function-w-name8fromstring-inline-function-w-name8fromstring-name-src-w-wad-ml-870153724"></a>
### _W_Name8FromString

```ml
inline function _W_Name8FromString(name)
```

Uppercases, truncates, and zero-pads a string to Doom's fixed eight-byte lump-name representation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L157)

<a id="function-function-w-name8tostring-function-w-name8tostring-name-src-w-wad-ml-1827580127"></a>
### _W_Name8ToString

```ml
function _W_Name8ToString(name)
```

Converts an internal eight-byte lump name to a safe display string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L173)

<a id="global-global-w-profile-count-w-profile-count-src-w-wad-ml-83535706"></a>
### _W_profile_count

```ml
_W_profile_count
```

Tracks the mutable w profile count value used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L947)

<a id="global-global-w-profile-info-w-profile-info-src-w-wad-ml-775322"></a>
### _W_profile_info

```ml
_W_profile_info
```

Stores the w profile info collection used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L944)

<a id="function-function-w-readi32le-inline-function-w-readi32le-b-off-src-w-wad-ml-619466054"></a>
### _W_ReadI32LE

```ml
inline function _W_ReadI32LE(b, off)
```

Decodes one signed 32-bit little-endian field from a WAD header or directory entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `b` | `dynamic` | — | Second input operand. |
| `off` | `dynamic` | — | Zero-based byte or element offset. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L108)

<a id="function-function-w-remembercacheddataname-function-w-remembercacheddataname-data-name-src-w-wad-ml-429416021"></a>
### _W_RememberCachedDataName

```ml
function _W_RememberCachedDataName(data, name)
```

Associates cached lump bytes with a known name without touching lumpinfo metadata.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L843)

<a id="function-function-w-slotempty-inline-function-w-slotempty-slot-src-w-wad-ml-19577365"></a>
### _W_SlotEmpty

```ml
inline function _W_SlotEmpty(slot)
```

Tests the cache-slot convention in which empty, void, or negative pointer values mean no resident lump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | Slot value supplied to `_W_SlotEmpty`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L360)

<a id="function-function-w-tointor-function-w-tointor-v-fallback-src-w-wad-ml-1249356050"></a>
### _W_ToIntOr

```ml
function _W_ToIntOr(v, fallback)
```

Converts int or values for the WAD resource.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |
| `fallback` | `dynamic` | — | Value returned when the requested conversion or lookup is unavailable. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L333)

<a id="function-function-w-topathstring-inline-function-w-topathstring-v-src-w-wad-ml-745995529"></a>
### _W_ToPathString

```ml
inline function _W_ToPathString(v)
```

Converts path string values for the WAD resource.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `v` | `dynamic` | — | Value consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L287)

<a id="function-function-w-toupperascii-inline-function-w-toupperascii-s-src-w-wad-ml-787921102"></a>
### _W_ToUpperAscii

```ml
inline function _W_ToUpperAscii(s)
```

Uppercases ASCII lump-name characters in a newly allocated string while preserving nonletters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `_W_ToUpperAscii`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L126)

<a id="function-function-extractfilebase-function-extractfilebase-path-dest-src-w-wad-ml-1660605343"></a>
### ExtractFileBase

```ml
function ExtractFileBase(path, dest)
```

Copies a canonical filename base into a byte buffer or reference slot for compatibility with the original API.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Filesystem path to process. |
| `dest` | `dynamic` | — | Dest value supplied to `ExtractFileBase`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L263)

<a id="function-function-filelength-inline-function-filelength-handle-src-w-wad-ml-1059993971"></a>
### filelength

```ml
inline function filelength(handle)
```

Returns the byte length of a validated loaded-file handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `handle` | `dynamic` | — | Handle value supplied to `filelength`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L146)

- [filelump_t](Type-filelump-t-976508614.md) — struct
<a id="global-global-lumpcache-lumpcache-src-w-wad-ml-1736674438"></a>
### lumpcache

```ml
lumpcache
```

Holds the optional lumpcache resource used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L69)

<a id="global-global-lumpinfo-lumpinfo-src-w-wad-ml-1171055014"></a>
### lumpinfo

```ml
lumpinfo
```

Holds the optional lumpinfo resource used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L71)

- [lumpinfo_t](Type-lumpinfo-t-1640184248.md) — struct
<a id="global-global-numlumps-numlumps-src-w-wad-ml-31777280"></a>
### numlumps

```ml
numlumps
```

Tracks the mutable numlumps value used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L73)

<a id="global-global-reloadfile-reloadfile-src-w-wad-ml-1190799616"></a>
### reloadfile

```ml
reloadfile
```

Tracks the mutable reloadfile value used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L102)

<a id="global-global-reloadlump-reloadlump-src-w-wad-ml-377971032"></a>
### reloadlump

```ml
reloadlump
```

Tracks the mutable reloadlump value used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L100)

<a id="global-global-reloadname-reloadname-src-w-wad-ml-1967472190"></a>
### reloadname

```ml
reloadname
```

Holds the optional reloadname resource used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L98)

<a id="function-function-strupr-inline-function-strupr-s-src-w-wad-ml-1027916704"></a>
### strupr

```ml
inline function strupr(s)
```

Exposes allocation-safe ASCII uppercase conversion under the legacy WAD API name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `s` | `dynamic` | — | S value supplied to `strupr`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L140)

<a id="function-function-w-addfile-function-w-addfile-filename-src-w-wad-ml-178127207"></a>
### W_AddFile

```ml
function W_AddFile(filename)
```

Loads a WAD or single-lump file, validates its directory, and appends normalized entries in load-order override precedence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | Filesystem name of the target resource. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L384)

<a id="function-function-w-cachelumpname-function-w-cachelumpname-name-tag-src-w-wad-ml-21876793"></a>
### W_CacheLumpName

```ml
function W_CacheLumpName(name, tag)
```

Resolves a canonical lump name, ensures its data is resident under the requested tag, and preserves name metadata for patch users.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L935)

<a id="function-function-w-cachelumpnum-function-w-cachelumpnum-lump-tag-src-w-wad-ml-1355760740"></a>
### W_CacheLumpNum

```ml
function W_CacheLumpNum(lump, tag)
```

Allocates and fills a lump's zone-cache slot on first use, retags resident data, and records patch-name identity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `W_CacheLumpNum`. |
| `tag` | `dynamic` | — | Zone-memory or resource-lifetime tag. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L795)

<a id="function-function-w-checknumforname-function-w-checknumforname-name-src-w-wad-ml-150746567"></a>
### W_CheckNumForName

```ml
function W_CheckNumForName(name)
```

Searches the merged directory backward so later WADs override earlier lumps with the same canonical name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L686)

<a id="function-function-w-getcachedlumpptr-function-w-getcachedlumpptr-lump-src-w-wad-ml-1808711322"></a>
### W_GetCachedLumpPtr

```ml
function W_GetCachedLumpPtr(lump)
```

Returns a resident lump's zone pointer without loading it, or the null-pointer sentinel for invalid or empty slots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `W_GetCachedLumpPtr`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L912)

<a id="function-function-w-getnumforname-function-w-getnumforname-name-src-w-wad-ml-1896969631"></a>
### W_GetNumForName

```ml
function W_GetNumForName(name)
```

Resolves a lump name to its overriding directory index and raises a fatal error when absent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Resource or object name to resolve. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L702)

<a id="constant-constant-w-hdwad-max-version-const-w-hdwad-max-version-6-src-w-wad-ml-1154372305"></a>
### W_HDWAD_MAX_VERSION

```ml
const W_HDWAD_MAX_VERSION = 6
```

Defines the maximum w hdwad max version accepted by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L34)

<a id="constant-constant-w-hdwad-min-version-const-w-hdwad-min-version-1-src-w-wad-ml-1894954514"></a>
### W_HDWAD_MIN_VERSION

```ml
const W_HDWAD_MIN_VERSION = 1
```

Defines the minimum w hdwad min version accepted by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L32)

<a id="function-function-w-initfile-function-w-initfile-filename-src-w-wad-ml-1614583581"></a>
### W_InitFile

```ml
function W_InitFile(filename)
```

Initializes the merged lump directory and cache from a single WAD path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filename` | `dynamic` | — | Filesystem name of the target resource. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L617)

<a id="function-function-w-initmultiplefiles-function-w-initmultiplefiles-filenames-src-w-wad-ml-548065894"></a>
### W_InitMultipleFiles

```ml
function W_InitMultipleFiles(filenames)
```

Clears prior resource state, loads each configured WAD in order, validates the result, and creates empty zone-cache slots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filenames` | `dynamic` | — | Filenames value supplied to `W_InitMultipleFiles`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L552)

<a id="function-function-w-lumplength-function-w-lumplength-lump-src-w-wad-ml-1886461514"></a>
### W_LumpLength

```ml
function W_LumpLength(lump)
```

Validates a lump index and returns its directory byte size.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `W_LumpLength`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L712)

<a id="function-function-w-nameforcacheddata-function-w-nameforcacheddata-data-src-w-wad-ml-886948136"></a>
### W_NameForCachedData

```ml
function W_NameForCachedData(data)
```

Returns the WAD lump name for a cached byte view, when known.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Binary or structured data to process. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L865)

<a id="function-function-w-numlumps-function-w-numlumps-src-w-wad-ml-1540301148"></a>
### W_NumLumps

```ml
function W_NumLumps()
```

Returns the current merged directory size after all WAD and single-lump files have been added.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L622)

<a id="function-function-w-profile-function-w-profile-src-w-wad-ml-338426478"></a>
### W_Profile

```ml
function W_Profile()
```

Samples cache residency for every lump and accumulates a per-snapshot history used to inspect resource-cache behavior.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L951)

<a id="function-function-w-readlump-function-w-readlump-lump-dest-src-w-wad-ml-1918871126"></a>
### W_ReadLump

```ml
function W_ReadLump(lump, dest)
```

Copies one validated lump byte range from its owning loaded file into the caller's destination buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | Lump value supplied to `W_ReadLump`. |
| `dest` | `dynamic` | — | Dest value supplied to `W_ReadLump`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L724)

<a id="function-function-w-reload-function-w-reload-src-w-wad-ml-2073216204"></a>
### W_Reload

```ml
function W_Reload()
```

Re-reads the designated reloadable WAD, invalidates its resident cache entries, and updates directory positions and sizes in place.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L628)

<a id="global-global-wad-cached-patch-bytes-wad-cached-patch-bytes-src-w-wad-ml-630647030"></a>
### wad_cached_patch_bytes

```ml
wad_cached_patch_bytes
```

Stores the wad cached patch bytes collection used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L75)

<a id="global-global-wad-cached-patch-last-data-wad-cached-patch-last-data-src-w-wad-ml-116005550"></a>
### wad_cached_patch_last_data

```ml
wad_cached_patch_last_data
```

Holds the optional wad cached patch last data resource used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L79)

<a id="global-global-wad-cached-patch-last-name-wad-cached-patch-last-name-src-w-wad-ml-801461736"></a>
### wad_cached_patch_last_name

```ml
wad_cached_patch_last_name
```

Stores the mutable wad cached patch last name text used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L81)

<a id="global-global-wad-cached-patch-names-wad-cached-patch-names-src-w-wad-ml-1299499428"></a>
### wad_cached_patch_names

```ml
wad_cached_patch_names
```

Stores the wad cached patch names collection used by the w wad subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/w_wad.ml#L77)

- [wadfile_t](Type-wadfile-t-478421302.md) — struct
- [wadinfo_t](Type-wadinfo-t-642488260.md) — struct
