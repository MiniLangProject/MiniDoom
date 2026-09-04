# `src/p_tick.ml`

[Home](README.md) · [Files](Files.md)

Owns the intrusive thinker list and advances all world thinkers once per unpaused game tic.

Package: [`(global)`](Package-global-1952375359.md)

Reachable from entry: **yes**

## Imports

- `doomstat.ml` → [src/doomstat.ml](File-src-doomstat-ml-1652708088.md)
- `p_local.ml` → [src/p_local.ml](File-src-p-local-ml-1043095437.md)
- `p_spec.ml` → [src/p_spec.ml](File-src-p-spec-ml-402508231.md)
- `p_user.ml` → [src/p_user.ml](File-src-p-user-ml-1917117091.md)
- `z_zone.ml` → [src/z_zone.ml](File-src-z-zone-ml-1788911354.md)

## Declarations

<a id="global-global-ptk-owner-nodes-ptk-owner-nodes-src-p-tick-ml-110710854"></a>
### _PTK_owner_nodes

```ml
_PTK_owner_nodes
```

Stores the ptk owner nodes collection used by the p tick subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L33)

<a id="global-global-ptk-owner-vals-ptk-owner-vals-src-p-tick-ml-1195763294"></a>
### _PTK_owner_vals

```ml
_PTK_owner_vals
```

Stores the ptk owner vals collection used by the p tick subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L36)

<a id="global-global-leveltime-leveltime-src-p-tick-ml-1431147370"></a>
### leveltime

```ml
leveltime
```

Tracks the mutable leveltime value used by the p tick subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L27)

<a id="function-function-p-addthinker-function-p-addthinker-thinker-src-p-tick-ml-1118069235"></a>
### P_AddThinker

```ml
function P_AddThinker(thinker)
```

Adds thinker entries to the play simulation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thinker` | `dynamic` | — | Thinker value supplied to `P_AddThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L95)

<a id="function-function-p-allocatethinker-function-p-allocatethinker-thinker-src-p-tick-ml-225921385"></a>
### P_AllocateThinker

```ml
function P_AllocateThinker(thinker)
```

Constructs an unlinked thinker node with an empty callback and owner slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thinker` | `dynamic` | — | Thinker value supplied to `P_AllocateThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L121)

<a id="function-function-p-initthinkers-function-p-initthinkers-src-p-tick-ml-77441064"></a>
### P_InitThinkers

```ml
function P_InitThinkers()
```

Resets the thinker sentinel into an empty circular doubly linked list and clears owner bookkeeping.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L39)

<a id="function-function-p-registerthinkerowner-function-p-registerthinkerowner-node-owner-src-p-tick-ml-1331298027"></a>
### P_RegisterThinkerOwner

```ml
function P_RegisterThinkerOwner(node, owner)
```

Associates a thinker node with its owning gameplay object in the fallback owner registry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `P_RegisterThinkerOwner`. |
| `owner` | `dynamic` | — | Owner value supplied to `P_RegisterThinkerOwner`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L51)

<a id="function-function-p-removethinker-function-p-removethinker-thinker-src-p-tick-ml-1001166363"></a>
### P_RemoveThinker

```ml
function P_RemoveThinker(thinker)
```

Removes remove Thinker data from the play simulation system.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `thinker` | `dynamic` | — | Thinker value supplied to `P_RemoveThinker`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L108)

<a id="function-function-p-resolvethinkerowner-function-p-resolvethinkerowner-node-src-p-tick-ml-1658580094"></a>
### P_ResolveThinkerOwner

```ml
function P_ResolveThinkerOwner(node)
```

Returns a thinker's direct owner or resolves it from the fallback registry used by legacy nodes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `P_ResolveThinkerOwner`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L62)

<a id="function-function-p-runfrozenplayermobjs-function-p-runfrozenplayermobjs-src-p-tick-ml-1618097020"></a>
### P_RunFrozenPlayerMobjs

```ml
function P_RunFrozenPlayerMobjs()
```

Advances only active player mobjs while the developer freeze suspends every other world thinker.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L169)

<a id="function-function-p-runthinkers-function-p-runthinkers-src-p-tick-ml-313370360"></a>
### P_RunThinkers

```ml
function P_RunThinkers()
```

Walks the thinker list safely across removals and invokes each active callback with its resolved owner.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L127)

<a id="function-function-p-ticker-function-p-ticker-src-p-tick-ml-754217540"></a>
### P_Ticker

```ml
function P_Ticker()
```

Advances players, thinkers, and sector specials once per unpaused game tic, then increments level time.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L183)

<a id="function-function-p-unregisterthinkerowner-function-p-unregisterthinkerowner-node-src-p-tick-ml-1231027612"></a>
### P_UnregisterThinkerOwner

```ml
function P_UnregisterThinkerOwner(node)
```

Removes a thinker-to-owner association when the node leaves the active thinker list.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `node` | `dynamic` | — | Node value supplied to `P_UnregisterThinkerOwner`. |


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L77)

<a id="global-global-thinkercap-thinkercap-src-p-tick-ml-1630097120"></a>
### thinkercap

```ml
thinkercap
```

Tracks the mutable thinkercap value used by the p tick subsystem.


[View source](https://github.com/MiniLangProject/MiniDoom/blob/main/src/p_tick.ml#L30)
