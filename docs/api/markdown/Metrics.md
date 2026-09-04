# Metrics

[Home](README.md)

Static metrics are calculated from target-specific preprocessed MiniLang files inside the configured source roots. External imported modules, generated documentation, and excluded paths are not measured.

## Project summary

| Metric | Value |
| --- | ---: |
| Blank lines | 8369 |
| Clone groups | 915 |
| Cognitive complexity | 22837 (maximum per function: 622) |
| Comment lines | 14655 |
| Cyclomatic complexity | 18886 (average: 8.5, maximum: 969) |
| Documentation coverage | 100% (8146 of 8146 documentation items) |
| Duplicated lines | 4547 (7.89%) |
| Files | 88 |
| Functions | 2222 |
| Maintainability index | 1.61 / 100 |
| Physical lines | 80638 |
| Source lines | 57614 |
| Statements | 42186 |

## Documentation coverage

Coverage is split by documentation contract so strong API summaries cannot hide undocumented parameters or data members.

| Category | Documented | Total | Coverage |
| --- | ---: | ---: | ---: |
| API declarations | 1522 | 1522 | 100% |
| Constants | 1078 | 1078 | 100% |
| Enum variants | 1606 | 1606 | 100% |
| Fields | 640 | 640 | 100% |
| Globals | 1029 | 1029 | 100% |
| Overall | 8146 | 8146 | 100% |
| Parameters | 2271 | 2271 | 100% |

## Halstead metrics

| Distinct operators | Distinct operands | Total operators | Total operands | Vocabulary | Length | Volume | Difficulty | Effort | Estimated defects |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 58 | 12794 | 219561 | 165941 | 12852 | 385502 | 5261988.67 | 376.14 | 1979225434.38 | 1754 |

## Files

| File | SLOC | Functions | Cyclomatic total / avg / max | Cognitive total / max | Duplication | Halstead volume | MI |
| --- | ---: | ---: | --- | --- | --- | ---: | ---: |
| [`src/am_map.ml`](File-src-am-map-ml-1409794280.md) | 760 | 50 | 221 / 4.42 / 31 | 222 / 53 | 37 (4.87%) | 37699.39 | 0 |
| [`src/console_cmd.ml`](File-src-console-cmd-ml-361086087.md) | 279 | 20 | 128 / 6.4 / 24 | 122 / 24 | 0 (0%) | 17232.15 | 0 |
| [`src/console_ui.ml`](File-src-console-ui-ml-497758297.md) | 320 | 21 | 109 / 5.19 / 26 | 102 / 30 | 0 (0%) | 13677.19 | 1.73 |
| [`src/d_englsh.ml`](File-src-d-englsh-ml-970368195.md) | 285 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 10442.25 | 18.31 |
| [`src/d_event.ml`](File-src-d-event-ml-1995118760.md) | 39 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 459.47 | 46.65 |
| [`src/d_french.ml`](File-src-d-french-ml-849171914.md) | 199 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 6871.86 | 22.99 |
| [`src/d_items.ml`](File-src-d-items-ml-1350618780.md) | 84 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 1598.93 | 35.59 |
| [`src/d_main.ml`](File-src-d-main-ml-105344057.md) | 1867 | 66 | 801 / 12.14 / 150 | 1048 / 250 | 295 (15.8%) | 110720.25 | 0 |
| [`src/d_net.ml`](File-src-d-net-ml-529296669.md) | 5944 | 142 | 2181 / 15.36 / 200 | 3743 / 622 | 643 (10.82%) | 423844.94 | 0 |
| [`src/d_player.ml`](File-src-d-player-ml-1944166105.md) | 144 | 3 | 12 / 4 / 4 | 9 / 3 | 22 (15.28%) | 2797.29 | 27.17 |
| [`src/d_textur.ml`](File-src-d-textur-ml-890499098.md) | 6 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 27 | 73 |
| [`src/d_think.ml`](File-src-d-think-ml-737524740.md) | 11 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 51.89 | 65.27 |
| [`src/d_ticcmd.ml`](File-src-d-ticcmd-ml-1143326682.md) | 9 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 41.51 | 67.85 |
| [`src/doomdata.ml`](File-src-doomdata-ml-887192154.md) | 79 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 1022.77 | 37.53 |
| [`src/doomdef.ml`](File-src-doomdef-ml-460406769.md) | 171 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 4088.3 | 26 |
| [`src/doomstat.ml`](File-src-doomstat-ml-1652708088.md) | 69 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 1514.11 | 37.62 |
| [`src/doomtype.ml`](File-src-doomtype-ml-372549946.md) | 13 | 1 | 1 / 1 / 1 | 0 / 0 | 0 (0%) | 249.98 | 58.78 |
| [`src/dstrings.ml`](File-src-dstrings-ml-567491523.md) | 32 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 383.18 | 49.08 |
| [`src/f_finale.ml`](File-src-f-finale-ml-635076109.md) | 422 | 21 | 155 / 7.38 / 19 | 185 / 24 | 13 (3.08%) | 19202.43 | 0 |
| [`src/f_wipe.ml`](File-src-f-wipe-ml-1921092045.md) | 268 | 15 | 92 / 6.13 / 15 | 109 / 31 | 12 (4.48%) | 11295.09 | 6.28 |
| [`src/g_game.ml`](File-src-g-game-ml-257299317.md) | 1329 | 53 | 548 / 10.34 / 61 | 640 / 74 | 6 (0.45%) | 76391.96 | 0 |
| [`src/hdwad_builder.ml`](File-src-hdwad-builder-ml-980370789.md) | 1284 | 79 | 481 / 6.09 / 36 | 592 / 69 | 116 (9.03%) | 102738.87 | 0 |
| [`src/hu_lib.ml`](File-src-hu-lib-ml-937975676.md) | 284 | 28 | 113 / 4.04 / 12 | 101 / 19 | 6 (2.11%) | 12744.34 | 2.54 |
| [`src/hu_stuff.ml`](File-src-hu-stuff-ml-1965779679.md) | 522 | 28 | 157 / 5.61 / 37 | 207 / 96 | 15 (2.87%) | 29805.4 | 0 |
| [`src/i_gl.ml`](File-src-i-gl-ml-2113703076.md) | 811 | 34 | 245 / 7.21 / 22 | 250 / 26 | 60 (7.4%) | 60469.02 | 0 |
| [`src/i_main.ml`](File-src-i-main-ml-97520758.md) | 81 | 3 | 32 / 10.67 / 15 | 49 / 23 | 26 (32.1%) | 3486.16 | 29.26 |
| [`src/i_net.ml`](File-src-i-net-ml-1331775872.md) | 326 | 16 | 141 / 8.81 / 44 | 172 / 75 | 27 (8.28%) | 18365.55 | 0 |
| [`src/i_sound.ml`](File-src-i-sound-ml-33806980.md) | 1179 | 80 | 371 / 4.64 / 25 | 384 / 57 | 6 (0.51%) | 66028.9 | 0 |
| [`src/i_system.ml`](File-src-i-system-ml-1632920966.md) | 169 | 20 | 70 / 3.5 / 12 | 56 / 12 | 25 (14.79%) | 7457.29 | 14.87 |
| [`src/i_video.ml`](File-src-i-video-ml-140536292.md) | 1859 | 85 | 696 / 8.19 / 42 | 796 / 63 | 289 (15.55%) | 117469.46 | 0 |
| [`src/info.ml`](File-src-info-ml-1415270573.md) | 5331 | 2 | 973 / 486.5 / 969 | 5 / 3 | 0 (0%) | 547394.88 | 0 |
| [`src/m_argv.ml`](File-src-m-argv-ml-728984635.md) | 43 | 4 | 14 / 3.5 / 6 | 12 / 6 | 0 (0%) | 1219.57 | 40.87 |
| [`src/m_bbox.ml`](File-src-m-bbox-ml-1176525784.md) | 30 | 2 | 10 / 5 / 7 | 8 / 6 | 6 (20%) | 910.05 | 45.71 |
| [`src/m_cheat.ml`](File-src-m-cheat-ml-440987496.md) | 136 | 10 | 50 / 5 / 11 | 49 / 13 | 0 (0%) | 5798.45 | 20.38 |
| [`src/m_fixed.ml`](File-src-m-fixed-ml-2129187227.md) | 94 | 7 | 28 / 4 / 8 | 29 / 12 | 0 (0%) | 3208.09 | 28.64 |
| [`src/m_menu.ml`](File-src-m-menu-ml-331716860.md) | 2221 | 126 | 623 / 4.94 / 93 | 744 / 175 | 83 (3.74%) | 124033.3 | 0 |
| [`src/m_misc.ml`](File-src-m-misc-ml-906836777.md) | 527 | 23 | 188 / 8.17 / 41 | 191 / 40 | 22 (4.17%) | 25844.29 | 0 |
| [`src/m_random.ml`](File-src-m-random-ml-1659574948.md) | 40 | 3 | 3 / 1 / 1 | 0 / 0 | 0 (0%) | 4404.33 | 39.13 |
| [`src/m_swap.ml`](File-src-m-swap-ml-1401834276.md) | 20 | 4 | 6 / 1.5 / 2 | 2 / 1 | 0 (0%) | 612.11 | 51.3 |
| [`src/mp_fnv1a.ml`](File-src-mp-fnv1a-ml-1881283455.md) | 28 | 3 | 7 / 2.33 / 3 | 4 / 2 | 0 (0%) | 930.28 | 46.7 |
| [`src/mp_platform.ml`](File-src-mp-platform-ml-1361006310.md) | 1703 | 59 | 552 / 9.36 / 49 | 803 / 115 | 265 (15.56%) | 94965.5 | 0 |
| [`src/mp_state.ml`](File-src-mp-state-ml-130741680.md) | 326 | 17 | 117 / 6.88 / 16 | 138 / 27 | 59 (18.1%) | 15568.02 | 9.e-002 |
| [`src/p_ceilng.ml`](File-src-p-ceilng-ml-226654252.md) | 143 | 9 | 55 / 6.11 / 15 | 71 / 26 | 7 (4.9%) | 5971.32 | 19.15 |
| [`src/p_doors.ml`](File-src-p-doors-ml-224295587.md) | 354 | 17 | 122 / 7.18 / 28 | 140 / 40 | 20 (5.65%) | 16593.02 | 0 |
| [`src/p_enemy.ml`](File-src-p-enemy-ml-1875479956.md) | 1207 | 74 | 531 / 7.18 / 38 | 600 / 65 | 27 (2.24%) | 78734.3 | 0 |
| [`src/p_floor.ml`](File-src-p-floor-ml-1999892698.md) | 390 | 10 | 103 / 10.3 / 38 | 205 / 77 | 82 (21.03%) | 15567.82 | 0.27 |
| [`src/p_inter.ml`](File-src-p-inter-ml-1430401638.md) | 756 | 23 | 404 / 17.57 / 107 | 521 / 171 | 53 (7.01%) | 48864.07 | 0 |
| [`src/p_lights.ml`](File-src-p-lights-ml-1710096069.md) | 162 | 13 | 59 / 4.54 / 7 | 57 / 8 | 12 (7.41%) | 7555.75 | 16.71 |
| [`src/p_local.ml`](File-src-p-local-ml-1043095437.md) | 53 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 1058.75 | 41.21 |
| [`src/p_map.ml`](File-src-p-map-ml-882556686.md) | 926 | 29 | 303 / 10.45 / 35 | 396 / 61 | 18 (1.94%) | 51029.29 | 0 |
| [`src/p_maputl.ml`](File-src-p-maputl-ml-227665141.md) | 579 | 25 | 195 / 7.8 / 24 | 253 / 37 | 48 (8.29%) | 27483.31 | 0 |
| [`src/p_mobj.ml`](File-src-p-mobj-ml-1335564114.md) | 1023 | 28 | 373 / 13.32 / 49 | 475 / 69 | 59 (5.77%) | 58084.98 | 0 |
| [`src/p_plats.ml`](File-src-p-plats-ml-866228534.md) | 260 | 12 | 83 / 6.92 / 20 | 105 / 33 | 6 (2.31%) | 11575.99 | 7.7 |
| [`src/p_pspr.ml`](File-src-p-pspr-ml-844718747.md) | 702 | 44 | 294 / 6.68 / 24 | 294 / 36 | 41 (5.84%) | 40133.25 | 0 |
| [`src/p_saveg.ml`](File-src-p-saveg-ml-1704891910.md) | 997 | 55 | 291 / 5.29 / 24 | 320 / 38 | 54 (5.42%) | 56291.38 | 0 |
| [`src/p_setup.ml`](File-src-p-setup-ml-2057900615.md) | 672 | 22 | 274 / 12.45 / 106 | 371 / 137 | 80 (11.9%) | 38870.79 | 0 |
| [`src/p_sight.ml`](File-src-p-sight-ml-269759795.md) | 177 | 7 | 76 / 10.86 / 20 | 138 / 69 | 9 (5.08%) | 9780.38 | 12.8 |
| [`src/p_spec.ml`](File-src-p-spec-ml-402508231.md) | 1108 | 29 | 366 / 12.62 / 84 | 372 / 65 | 64 (5.78%) | 50660.6 | 0 |
| [`src/p_switch.ml`](File-src-p-switch-ml-925070734.md) | 535 | 12 | 191 / 15.92 / 125 | 209 / 114 | 0 (0%) | 25851.78 | 0 |
| [`src/p_telept.ml`](File-src-p-telept-ml-266213122.md) | 77 | 2 | 33 / 16.5 / 25 | 71 / 62 | 0 (0%) | 3455.61 | 29.63 |
| [`src/p_tick.ml`](File-src-p-tick-ml-887781845.md) | 156 | 10 | 72 / 7.2 / 31 | 90 / 34 | 0 (0%) | 6125.22 | 15.96 |
| [`src/p_user.ml`](File-src-p-user-ml-1917117091.md) | 288 | 11 | 164 / 14.91 / 47 | 187 / 56 | 42 (14.58%) | 19265.78 | 0 |
| [`src/platform_linux.ml`](File-src-platform-linux-ml-1395705459.md) | 0 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0.%) | 0 | 100. |
| [`src/r_bsp.ml`](File-src-r-bsp-ml-998402465.md) | 488 | 21 | 149 / 7.1 / 24 | 156 / 34 | 41 (8.4%) | 22248.08 | 0 |
| [`src/r_data.ml`](File-src-r-data-ml-1686270288.md) | 961 | 33 | 449 / 13.61 / 89 | 642 / 182 | 50 (5.2%) | 54856.51 | 0 |
| [`src/r_defs.ml`](File-src-r-defs-ml-1187974936.md) | 181 | 9 | 11 / 1.22 / 2 | 2 / 1 | 0 (0%) | 3067.89 | 24.86 |
| [`src/r_draw.ml`](File-src-r-draw-ml-919823710.md) | 700 | 31 | 292 / 9.42 / 47 | 331 / 63 | 214 (30.57%) | 38018 | 0 |
| [`src/r_gl.ml`](File-src-r-gl-ml-2087530889.md) | 5539 | 234 | 1753 / 7.49 / 50 | 2198 / 90 | 1025 (18.51%) | 388467.06 | 0 |
| [`src/r_hires.ml`](File-src-r-hires-ml-694005807.md) | 55 | 7 | 19 / 2.71 / 6 | 12 / 5 | 0 (0%) | 1569.05 | 37.1 |
| [`src/r_local.ml`](File-src-r-local-ml-797040731.md) | 10 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 66.44 | 65.43 |
| [`src/r_main.ml`](File-src-r-main-ml-1902335243.md) | 1052 | 39 | 342 / 8.77 / 46 | 407 / 45 | 61 (5.8%) | 55540.75 | 0 |
| [`src/r_plane.ml`](File-src-r-plane-ml-1848108848.md) | 562 | 21 | 178 / 8.48 / 40 | 218 / 79 | 13 (2.31%) | 24999.99 | 0 |
| [`src/r_renderer.ml`](File-src-r-renderer-ml-72894217.md) | 46 | 10 | 14 / 1.4 / 3 | 4 / 2 | 0 (0%) | 885.61 | 41.21 |
| [`src/r_segs.ml`](File-src-r-segs-ml-1658887754.md) | 792 | 25 | 304 / 12.16 / 67 | 423 / 104 | 34 (4.29%) | 41451.87 | 0 |
| [`src/r_sky.ml`](File-src-r-sky-ml-918225537.md) | 23 | 1 | 5 / 5 / 5 | 4 / 4 | 0 (0%) | 451.38 | 51.04 |
| [`src/r_state.ml`](File-src-r-state-ml-691819649.md) | 46 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 767.56 | 43.53 |
| [`src/r_things.ml`](File-src-r-things-ml-545677447.md) | 1133 | 47 | 422 / 8.98 / 48 | 542 / 102 | 100 (8.83%) | 62624.83 | 0 |
| [`src/r_upscaled.ml`](File-src-r-upscaled-ml-1801241933.md) | 240 | 20 | 96 / 4.8 / 22 | 92 / 23 | 19 (7.92%) | 11581.69 | 6.71 |
| [`src/s_sound.ml`](File-src-s-sound-ml-1485495390.md) | 810 | 45 | 333 / 7.4 / 28 | 366 / 47 | 35 (4.32%) | 46737.03 | 0 |
| [`src/sounds.ml`](File-src-sounds-ml-1875364049.md) | 381 | 0 | 0 / 0. / 0 | 0 / 0 | 0 (0%) | 31879.13 | 12.17 |
| [`src/st_lib.ml`](File-src-st-lib-ml-1845497584.md) | 323 | 29 | 114 / 3.93 / 20 | 120 / 27 | 13 (4.02%) | 14841.25 | 0.72 |
| [`src/st_stuff.ml`](File-src-st-stuff-ml-811030939.md) | 1038 | 41 | 294 / 7.17 / 68 | 449 / 198 | 54 (5.2%) | 65062.7 | 0 |
| [`src/stdlib.ml`](File-src-stdlib-ml-366721133.md) | 4 | 1 | 2 / 2 / 2 | 1 / 1 | 0 (0%) | 74.01 | 73.51 |
| [`src/tables.ml`](File-src-tables-ml-1959718242.md) | 99 | 3 | 24 / 8 / 17 | 26 / 21 | 0 (0%) | 3674.66 | 28.28 |
| [`src/v_video.ml`](File-src-v-video-ml-592999939.md) | 698 | 28 | 236 / 8.43 / 26 | 305 / 46 | 66 (9.46%) | 56721.17 | 0 |
| [`src/w_wad.ml`](File-src-w-wad-ml-893006035.md) | 721 | 34 | 231 / 6.79 / 27 | 272 / 32 | 26 (3.61%) | 31667.82 | 0 |
| [`src/wi_stuff.ml`](File-src-wi-stuff-ml-450049266.md) | 1455 | 61 | 409 / 6.7 / 36 | 529 / 79 | 141 (9.69%) | 74893.61 | 0 |
| [`src/z_zone.ml`](File-src-z-zone-ml-1788911354.md) | 348 | 25 | 95 / 3.8 / 13 | 91 / 17 | 0 (0%) | 13909.75 | 2.77 |

## Functions

| Function | Location | LOC | Statements | Cyclomatic | Cognitive | Max nesting | Halstead volume | MI |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| [`_abs`](File-src-p-maputl-ml-227665141.md#function-function-abs-inline-function-abs-x-src-p-maputl-ml-1657338949) | `src/p_maputl.ml:30` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_absS32`](File-src-m-fixed-ml-2129187227.md#function-function-abss32-inline-function-abss32-x-src-m-fixed-ml-1465749931) | `src/m_fixed.ml:98` | 5 | 4 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_allocIntArray`](File-src-r-data-ml-1686270288.md#function-function-allocintarray-inline-function-allocintarray-n-fill-src-r-data-ml-1791096903) | `src/r_data.ml:130` | 6 | 6 | 3 | 2 | 1 | 185.84 | 66.73 |
| [`_AM_Abs`](File-src-am-map-ml-1409794280.md#function-function-am-abs-inline-function-am-abs-v-src-am-map-ml-849795394) | `src/am_map.ml:209` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_AM_CacheOrVoid`](File-src-am-map-ml-1409794280.md#function-function-am-cacheorvoid-inline-function-am-cacheorvoid-name-tag-src-am-map-ml-708958987) | `src/am_map.ml:268` | 8 | 6 | 3 | 3 | 2 | 221.65 | 63.47 |
| [`_AM_CaseKey`](File-src-am-map-ml-1409794280.md#function-function-am-casekey-inline-function-am-casekey-k-src-am-map-ml-1436408755) | `src/am_map.ml:259` | 4 | 3 | 2 | 1 | 1 | 104 | 72.47 |
| [`_AM_Clamp`](File-src-am-map-ml-1409794280.md#function-function-am-clamp-inline-function-am-clamp-v-lo-hi-src-am-map-ml-723797740) | `src/am_map.ml:219` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_AM_CXMTOF`](File-src-am-map-ml-1409794280.md#function-function-am-cxmtof-inline-function-am-cxmtof-x-src-am-map-ml-1235620120) | `src/am_map.ml:294` | 3 | 1 | 1 | 0 | 0 | 62.91 | 76.86 |
| [`_AM_CYMTOF`](File-src-am-map-ml-1409794280.md#function-function-am-cymtof-inline-function-am-cymtof-y-src-am-map-ml-311430407) | `src/am_map.ml:301` | 3 | 1 | 1 | 0 | 0 | 79.95 | 76.13 |
| [`_AM_FLine`](File-src-am-map-ml-1409794280.md#function-function-am-fline-inline-function-am-fline-x1-y1-x2-y2-src-am-map-ml-323930756) | `src/am_map.ml:202` | 3 | 1 | 1 | 0 | 0 | 118.03 | 74.95 |
| [`_AM_FPoint`](File-src-am-map-ml-1409794280.md#function-function-am-fpoint-inline-function-am-fpoint-x-y-src-am-map-ml-1587790255) | `src/am_map.ml:182` | 3 | 1 | 1 | 0 | 0 | 58.81 | 77.07 |
| [`_AM_FTOM`](File-src-am-map-ml-1409794280.md#function-function-am-ftom-inline-function-am-ftom-x-src-am-map-ml-912357714) | `src/am_map.ml:280` | 3 | 1 | 1 | 0 | 0 | 62.91 | 76.86 |
| [`_AM_IDiv`](File-src-am-map-ml-1409794280.md#function-function-am-idiv-inline-function-am-idiv-a-b-src-am-map-ml-938453907) | `src/am_map.ml:241` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_AM_MLine`](File-src-am-map-ml-1409794280.md#function-function-am-mline-inline-function-am-mline-x1-y1-x2-y2-src-am-map-ml-396644912) | `src/am_map.ml:192` | 3 | 1 | 1 | 0 | 0 | 118.03 | 74.95 |
| [`_AM_Mod`](File-src-am-map-ml-1409794280.md#function-function-am-mod-inline-function-am-mod-n-d-src-am-map-ml-1436761690) | `src/am_map.ml:229` | 6 | 6 | 3 | 2 | 1 | 161.42 | 67.16 |
| [`_AM_MPoint`](File-src-am-map-ml-1409794280.md#function-function-am-mpoint-inline-function-am-mpoint-x-y-src-am-map-ml-1928583769) | `src/am_map.ml:174` | 3 | 1 | 1 | 0 | 0 | 58.81 | 77.07 |
| [`_AM_MTOF`](File-src-am-map-ml-1409794280.md#function-function-am-mtof-inline-function-am-mtof-x-src-am-map-ml-926496378) | `src/am_map.ml:287` | 3 | 1 | 1 | 0 | 0 | 62.91 | 76.86 |
| [`_AM_PutPixel`](File-src-am-map-ml-1409794280.md#function-function-am-putpixel-inline-function-am-putpixel-x-y-color-src-am-map-ml-1583495650) | `src/am_map.ml:762` | 10 | 13 | 15 | 14 | 1 | 660.68 | 56.42 |
| [`_AM_ToLowerAscii`](File-src-am-map-ml-1409794280.md#function-function-am-tolowerascii-inline-function-am-tolowerascii-c-src-am-map-ml-612118995) | `src/am_map.ml:251` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_BuildMenus`](File-src-m-menu-ml-331716860.md#function-function-buildmenus-function-buildmenus-src-m-menu-ml-809581667) | `src/m_menu.ml:713` | 117 | 56 | 1 | 0 | 0 | 6047.75 | 28.27 |
| [`_bytesOf`](File-src-m-menu-ml-331716860.md#function-function-bytesof-inline-function-bytesof-x-src-m-menu-ml-1836315840) | `src/m_menu.ml:79` | 5 | 5 | 3 | 2 | 1 | 160 | 68.92 |
| [`_CCMD_Ammo`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-ammo-function-ccmd-ammo-includekeys-src-console-cmd-ml-1938584826) | `src/console_cmd.ml:141` | 9 | 7 | 3 | 2 | 1 | 294.32 | 61.49 |
| [`_CCMD_Cheats`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-cheats-function-ccmd-cheats-src-console-cmd-ml-138875740) | `src/console_cmd.ml:322` | 12 | 10 | 1 | 0 | 0 | 267.57 | 59.33 |
| [`_CCMD_CurrentPlayer`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-currentplayer-inline-function-ccmd-currentplayer-src-console-cmd-ml-695993155) | `src/console_cmd.ml:61` | 6 | 7 | 6 | 5 | 1 | 284.27 | 65.04 |
| [`_CCMD_Fps`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-fps-function-ccmd-fps-src-console-cmd-ml-1890509428) | `src/console_cmd.ml:277` | 5 | 3 | 1 | 0 | 0 | 114.45 | 70.2 |
| [`_CCMD_Freeze`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-freeze-function-ccmd-freeze-src-console-cmd-ml-1128913844) | `src/console_cmd.ml:232` | 7 | 6 | 2 | 1 | 1 | 235.23 | 64.69 |
| [`_CCMD_God`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-god-function-ccmd-god-src-console-cmd-ml-130539386) | `src/console_cmd.ml:124` | 12 | 10 | 3 | 2 | 1 | 464.08 | 57.38 |
| [`_CCMD_GrantArsenal`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-grantarsenal-function-ccmd-grantarsenal-player-includekeys-src-console-cmd-ml-2119057401) | `src/console_cmd.ml:93` | 24 | 20 | 10 | 14 | 3 | 771 | 48.33 |
| [`_CCMD_Help`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-help-function-ccmd-help-src-console-cmd-ml-151046288) | `src/console_cmd.ml:306` | 13 | 11 | 1 | 0 | 0 | 294.03 | 58.28 |
| [`_CCMD_IdClev`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-idclev-function-ccmd-idclev-argument-src-console-cmd-ml-1575269499) | `src/console_cmd.ml:186` | 23 | 24 | 17 | 17 | 2 | 1404.87 | 45.97 |
| [`_CCMD_Invisible`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-invisible-function-ccmd-invisible-src-console-cmd-ml-1906055948) | `src/console_cmd.ml:217` | 11 | 9 | 4 | 3 | 1 | 480.8 | 57.97 |
| [`_CCMD_KillMonsters`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-killmonsters-function-ccmd-killmonsters-src-console-cmd-ml-803689928) | `src/console_cmd.ml:252` | 21 | 18 | 11 | 15 | 3 | 969.07 | 48.77 |
| [`_CCMD_Name`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-name-function-ccmd-name-argument-setname-src-console-cmd-ml-696852544) | `src/console_cmd.ml:287` | 15 | 11 | 4 | 3 | 1 | 490 | 54.97 |
| [`_CCMD_NoClip`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-noclip-function-ccmd-noclip-src-console-cmd-ml-557567636) | `src/console_cmd.ml:154` | 8 | 7 | 2 | 1 | 1 | 368.02 | 62.06 |
| [`_CCMD_OnOff`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-onoff-inline-function-ccmd-onoff-enabled-src-console-cmd-ml-1446062606) | `src/console_cmd.ml:84` | 4 | 3 | 2 | 1 | 1 | 60.94 | 74.1 |
| [`_CCMD_ParsePositiveInt`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-parsepositiveint-function-ccmd-parsepositiveint-text-src-console-cmd-ml-1640560571) | `src/console_cmd.ml:167` | 14 | 14 | 7 | 7 | 2 | 561.53 | 54.81 |
| [`_CCMD_RequireGameplayCheat`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-requiregameplaycheat-inline-function-ccmd-requiregameplaycheat-requireplayer-src-console-cmd-ml-952942861) | `src/console_cmd.ml:71` | 9 | 9 | 6 | 6 | 2 | 252.01 | 61.56 |
| [`_CCMD_ResolveMobj`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-resolvemobj-inline-function-ccmd-resolvemobj-node-src-console-cmd-ml-412015767) | `src/console_cmd.ml:244` | 5 | 5 | 5 | 4 | 1 | 210.83 | 67.81 |
| [`_CCMD_Result`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-result-inline-function-ccmd-result-handled-message-clearlog-closeconsole-src-console-cmd-ml-2050725376) | `src/console_cmd.ml:55` | 3 | 1 | 1 | 0 | 0 | 92.51 | 75.69 |
| [`_CeilingMakeThinker`](File-src-p-ceilng-ml-226654252.md#function-function-ceilingmakethinker-inline-function-ceilingmakethinker-fn-src-p-ceilng-ml-1774093012) | `src/p_ceilng.ml:49` | 3 | 1 | 1 | 0 | 0 | 93.21 | 75.67 |
| [`_CeilingSetSlot`](File-src-p-ceilng-ml-226654252.md#function-function-ceilingsetslot-inline-function-ceilingsetslot-idx-v-src-p-ceilng-ml-1897665829) | `src/p_ceilng.ml:57` | 12 | 12 | 6 | 5 | 1 | 515 | 56.66 |
| [`_cht_bytes_from_list`](File-src-m-cheat-ml-440987496.md#function-function-cht-bytes-from-list-function-cht-bytes-from-list-lst-src-m-cheat-ml-1327058122) | `src/m_cheat.ml:146` | 9 | 6 | 2 | 1 | 1 | 214.05 | 62.6 |
| [`_cht_ensure_table`](File-src-m-cheat-ml-440987496.md#function-function-cht-ensure-table-function-cht-ensure-table-src-m-cheat-ml-1282062907) | `src/m_cheat.ml:46` | 12 | 10 | 3 | 2 | 1 | 221.65 | 59.63 |
| [`_cht_key_byte`](File-src-m-cheat-ml-440987496.md#function-function-cht-key-byte-inline-function-cht-key-byte-key-src-m-cheat-ml-1404954707) | `src/m_cheat.ml:63` | 9 | 9 | 6 | 6 | 2 | 361.93 | 60.46 |
| [`_cht_scramble`](File-src-m-cheat-ml-440987496.md#function-function-cht-scramble-inline-function-cht-scramble-a-src-m-cheat-ml-427199099) | `src/m_cheat.ml:38` | 5 | 3 | 1 | 0 | 0 | 417.95 | 66.27 |
| [`_cht_seq_get`](File-src-m-cheat-ml-440987496.md#function-function-cht-seq-get-inline-function-cht-seq-get-seq-idx-src-m-cheat-ml-1834664642) | `src/m_cheat.ml:86` | 6 | 6 | 3 | 2 | 1 | 168.56 | 67.03 |
| [`_cht_seq_len`](File-src-m-cheat-ml-440987496.md#function-function-cht-seq-len-inline-function-cht-seq-len-seq-src-m-cheat-ml-225195033) | `src/m_cheat.ml:76` | 5 | 5 | 3 | 2 | 1 | 160 | 68.92 |
| [`_cht_seq_set`](File-src-m-cheat-ml-440987496.md#function-function-cht-seq-set-inline-function-cht-seq-set-seq-idx-v-src-m-cheat-ml-874826344) | `src/m_cheat.ml:98` | 6 | 6 | 3 | 2 | 1 | 189.99 | 66.67 |
| [`_cht_write_buffer`](File-src-m-cheat-ml-440987496.md#function-function-cht-write-buffer-function-cht-write-buffer-buffer-outlist-src-m-cheat-ml-104556033) | `src/m_cheat.ml:161` | 22 | 15 | 8 | 12 | 2 | 658.91 | 49.9 |
| [`_clampInt`](File-src-v-video-ml-592999939.md#function-function-clampint-inline-function-clampint-x-lo-hi-src-v-video-ml-1341042677) | `src/v_video.ml:207` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_cstrClear`](File-src-m-menu-ml-331716860.md#function-function-cstrclear-function-cstrclear-buf-src-m-menu-ml-1304511364) | `src/m_menu.ml:175` | 6 | 4 | 3 | 2 | 1 | 165 | 67.1 |
| [`_cstrCopy`](File-src-m-menu-ml-331716860.md#function-function-cstrcopy-function-cstrcopy-dst-src-src-m-menu-ml-289189592) | `src/m_menu.ml:213` | 9 | 8 | 5 | 4 | 1 | 402.36 | 60.27 |
| [`_cstrEqString`](File-src-m-menu-ml-331716860.md#function-function-cstreqstring-inline-function-cstreqstring-buf-s-src-m-menu-ml-2073444738) | `src/m_menu.ml:227` | 4 | 3 | 2 | 1 | 1 | 120.93 | 72.02 |
| [`_cstrFromString`](File-src-m-menu-ml-331716860.md#function-function-cstrfromstring-function-cstrfromstring-buf-s-src-m-menu-ml-647135047) | `src/m_menu.ml:198` | 10 | 9 | 4 | 3 | 1 | 397.46 | 59.45 |
| [`_cstrLen`](File-src-m-menu-ml-331716860.md#function-function-cstrlen-function-cstrlen-buf-src-m-menu-ml-343553044) | `src/m_menu.ml:185` | 8 | 6 | 4 | 3 | 1 | 203.56 | 63.6 |
| [`_CUI_Abs`](File-src-console-ui-ml-497758297.md#function-function-cui-abs-inline-function-cui-abs-v-src-console-ui-ml-1883246339) | `src/console_ui.ml:121` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_CUI_DrawFPS`](File-src-console-ui-ml-497758297.md#function-function-cui-drawfps-function-cui-drawfps-y-src-console-ui-ml-783082191) | `src/console_ui.ml:425` | 21 | 18 | 6 | 6 | 2 | 742.8 | 50.25 |
| [`_CUI_DrawText`](File-src-console-ui-ml-497758297.md#function-function-cui-drawtext-function-cui-drawtext-x-y-text-cursor-src-console-ui-ml-103097450) | `src/console_ui.ml:407` | 13 | 12 | 6 | 5 | 1 | 643.95 | 55.23 |
| [`_CUI_HistoryDown`](File-src-console-ui-ml-497758297.md#function-function-cui-historydown-function-cui-historydown-src-console-ui-ml-829440016) | `src/console_ui.ml:345` | 11 | 8 | 3 | 2 | 1 | 247.59 | 60.12 |
| [`_CUI_HistoryUp`](File-src-console-ui-ml-497758297.md#function-function-cui-historyup-function-cui-historyup-src-console-ui-ml-2018724084) | `src/console_ui.ml:336` | 6 | 6 | 3 | 2 | 1 | 166.91 | 67.06 |
| [`_CUI_IDiv`](File-src-console-ui-ml-497758297.md#function-function-cui-idiv-inline-function-cui-idiv-a-b-src-console-ui-ml-1969479540) | `src/console_ui.ml:111` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_CUI_MaxScroll`](File-src-console-ui-ml-497758297.md#function-function-cui-maxscroll-inline-function-cui-maxscroll-src-console-ui-ml-1948165335) | `src/console_ui.ml:189` | 5 | 4 | 2 | 1 | 1 | 106.27 | 70.29 |
| [`_CUI_RecordHistory`](File-src-console-ui-ml-497758297.md#function-function-cui-recordhistory-function-cui-recordhistory-command-src-console-ui-ml-556637949) | `src/console_ui.ml:299` | 12 | 9 | 5 | 5 | 2 | 379.78 | 57.72 |
| [`_CUI_ReleasePause`](File-src-console-ui-ml-497758297.md#function-function-cui-releasepause-function-cui-releasepause-src-console-ui-ml-315117964) | `src/console_ui.ml:213` | 7 | 6 | 2 | 1 | 1 | 89.86 | 67.62 |
| [`_CUI_SetInput`](File-src-console-ui-ml-497758297.md#function-function-cui-setinput-function-cui-setinput-text-src-console-ui-ml-1104276507) | `src/console_ui.ml:198` | 12 | 7 | 3 | 2 | 1 | 212.61 | 59.76 |
| [`_CUI_Submit`](File-src-console-ui-ml-497758297.md#function-function-cui-submit-function-cui-submit-src-console-ui-ml-717145354) | `src/console_ui.ml:315` | 16 | 17 | 7 | 6 | 1 | 483.31 | 54 |
| [`_CUI_UpdateAnimation`](File-src-console-ui-ml-497758297.md#function-function-cui-updateanimation-function-cui-updateanimation-src-console-ui-ml-904492828) | `src/console_ui.ml:224` | 22 | 15 | 7 | 8 | 2 | 512.68 | 50.8 |
| [`_D_AddDemoLmpFromArgs`](File-src-d-main-ml-105344057.md#function-function-d-adddemolmpfromargs-inline-function-d-adddemolmpfromargs-flag-src-d-main-ml-50079807) | `src/d_main.ml:1502` | 11 | 9 | 6 | 5 | 1 | 400.08 | 58.26 |
| [`_D_ArgValue`](File-src-d-main-ml-105344057.md#function-function-d-argvalue-function-d-argvalue-flag-src-d-main-ml-2067337204) | `src/d_main.ml:841` | 7 | 7 | 4 | 3 | 1 | 237.74 | 64.39 |
| [`_D_AttachExistingAutoHDWAD`](File-src-d-main-ml-105344057.md#function-function-d-attachexistingautohdwad-function-d-attachexistingautohdwad-src-d-main-ml-1041324584) | `src/d_main.ml:885` | 13 | 13 | 9 | 8 | 1 | 501.48 | 55.58 |
| [`_D_AutoHDWADShouldRun`](File-src-d-main-ml-105344057.md#function-function-d-autohdwadshouldrun-function-d-autohdwadshouldrun-src-d-main-ml-70311158) | `src/d_main.ml:876` | 6 | 7 | 7 | 6 | 1 | 288.85 | 64.85 |
| [`_D_DigitAt`](File-src-d-main-ml-105344057.md#function-function-d-digitat-function-d-digitat-s-idx-src-d-main-ml-1791104708) | `src/d_main.ml:904` | 8 | 9 | 6 | 5 | 1 | 338.58 | 61.78 |
| [`_D_DrawMPDebugOverlay`](File-src-d-main-ml-105344057.md#function-function-d-drawmpdebugoverlay-function-d-drawmpdebugoverlay-src-d-main-ml-22849900) | `src/d_main.ml:459` | 18 | 13 | 9 | 11 | 3 | 485 | 52.6 |
| [`_D_FileReadable`](File-src-d-main-ml-105344057.md#function-function-d-filereadable-inline-function-d-filereadable-path-src-d-main-ml-2024005632) | `src/d_main.ml:1517` | 6 | 7 | 5 | 4 | 1 | 252.17 | 65.54 |
| [`_D_GenerateHDWADCacheAfterInit`](File-src-d-main-ml-105344057.md#function-function-d-generatehdwadcacheafterinit-function-d-generatehdwadcacheafterinit-src-d-main-ml-1961071664) | `src/d_main.ml:1394` | 93 | 95 | 23 | 23 | 2 | 3984.49 | 28.76 |
| [`_D_GeomNameForMapName`](File-src-d-main-ml-105344057.md#function-function-d-geomnameformapname-function-d-geomnameformapname-mapname-src-d-main-ml-1073924187) | `src/d_main.ml:995` | 3 | 1 | 1 | 0 | 0 | 34.87 | 78.66 |
| [`_D_HDWADDrawLoadingScreen`](File-src-d-main-ml-105344057.md#function-function-d-hdwaddrawloadingscreen-function-d-hdwaddrawloadingscreen-text-src-d-main-ml-823449429) | `src/d_main.ml:1262` | 18 | 19 | 14 | 13 | 1 | 1083.48 | 49.48 |
| [`_D_HDWADDrawText`](File-src-d-main-ml-105344057.md#function-function-d-hdwaddrawtext-function-d-hdwaddrawtext-text-y-src-d-main-ml-959629828) | `src/d_main.ml:1198` | 24 | 20 | 9 | 12 | 3 | 884.9 | 48.05 |
| [`_D_HDWADDurationText`](File-src-d-main-ml-105344057.md#function-function-d-hdwaddurationtext-function-d-hdwaddurationtext-ms-src-d-main-ml-326478272) | `src/d_main.ml:1226` | 9 | 10 | 5 | 4 | 1 | 418.68 | 60.15 |
| [`_D_HDWADFinishProgressPhase`](File-src-d-main-ml-105344057.md#function-function-d-hdwadfinishprogressphase-function-d-hdwadfinishprogressphase-src-d-main-ml-1422196558) | `src/d_main.ml:1333` | 8 | 8 | 3 | 2 | 1 | 171.3 | 64.26 |
| [`_D_HDWADFontLump`](File-src-d-main-ml-105344057.md#function-function-d-hdwadfontlump-function-d-hdwadfontlump-code-src-d-main-ml-1704901931) | `src/d_main.ml:1142` | 6 | 4 | 1 | 0 | 0 | 166.8 | 67.33 |
| [`_D_HDWADLooksComplete`](File-src-d-main-ml-105344057.md#function-function-d-hdwadlookscomplete-function-d-hdwadlookscomplete-path-src-d-main-ml-1081017943) | `src/d_main.ml:1110` | 22 | 21 | 8 | 11 | 3 | 692.73 | 49.75 |
| [`_D_HDWADPatchWidth`](File-src-d-main-ml-105344057.md#function-function-d-hdwadpatchwidth-inline-function-d-hdwadpatchwidth-patch-src-d-main-ml-1086702265) | `src/d_main.ml:1160` | 6 | 6 | 4 | 3 | 1 | 274.79 | 65.41 |
| [`_D_HDWADPathForWad`](File-src-d-main-ml-105344057.md#function-function-d-hdwadpathforwad-function-d-hdwadpathforwad-wad-src-d-main-ml-158585034) | `src/d_main.ml:870` | 3 | 1 | 1 | 0 | 0 | 34.87 | 78.66 |
| [`_D_HDWADProgressLine`](File-src-d-main-ml-105344057.md#function-function-d-hdwadprogressline-function-d-hdwadprogressline-src-d-main-ml-796470732) | `src/d_main.ml:1238` | 19 | 20 | 10 | 9 | 1 | 703.28 | 50.82 |
| [`_D_HDWADProgressReset`](File-src-d-main-ml-105344057.md#function-function-d-hdwadprogressreset-function-d-hdwadprogressreset-src-d-main-ml-632285652) | `src/d_main.ml:1283` | 20 | 18 | 1 | 0 | 0 | 216.64 | 55.13 |
| [`_D_HDWADScaleFromArgs`](File-src-d-main-ml-105344057.md#function-function-d-hdwadscalefromargs-function-d-hdwadscalefromargs-src-d-main-ml-579520774) | `src/d_main.ml:1135` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`_D_HDWADSetProgressPhase`](File-src-d-main-ml-105344057.md#function-function-d-hdwadsetprogressphase-function-d-hdwadsetprogressphase-text-basepct-spanpct-expectedunits-src-d-main-ml-1575591239) | `src/d_main.ml:1311` | 18 | 18 | 3 | 2 | 1 | 364.35 | 54.28 |
| [`_D_HDWADStatus`](File-src-d-main-ml-105344057.md#function-function-d-hdwadstatus-function-d-hdwadstatus-text-src-d-main-ml-417622277) | `src/d_main.ml:1376` | 15 | 15 | 8 | 7 | 1 | 471.12 | 54.55 |
| [`_D_HDWADTextByte`](File-src-d-main-ml-105344057.md#function-function-d-hdwadtextbyte-inline-function-d-hdwadtextbyte-c-src-d-main-ml-837423998) | `src/d_main.ml:1152` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_D_HDWADTextWidth`](File-src-d-main-ml-105344057.md#function-function-d-hdwadtextwidth-function-d-hdwadtextwidth-text-src-d-main-ml-1971104415) | `src/d_main.ml:1170` | 23 | 18 | 8 | 11 | 3 | 697.47 | 49.31 |
| [`_D_IDiv`](File-src-d-main-ml-105344057.md#function-function-d-idiv-inline-function-d-idiv-a-b-src-d-main-ml-928454260) | `src/d_main.ml:482` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_D_InitEventQueue`](File-src-d-main-ml-105344057.md#function-function-d-initeventqueue-function-d-initeventqueue-src-d-main-ml-235089890) | `src/d_main.ml:593` | 14 | 12 | 3 | 2 | 1 | 318.95 | 57.06 |
| [`_D_IsMapMarkerName`](File-src-d-main-ml-105344057.md#function-function-d-ismapmarkername-function-d-ismapmarkername-name-src-d-main-ml-590616133) | `src/d_main.ml:1002` | 11 | 8 | 9 | 8 | 1 | 600.32 | 56.62 |
| [`_D_IsResponseTokenByte`](File-src-d-main-ml-105344057.md#function-function-d-isresponsetokenbyte-inline-function-d-isresponsetokenbyte-c-src-d-main-ml-7371724) | `src/d_main.ml:1570` | 3 | 1 | 1 | 0 | 0 | 59.21 | 77.05 |
| [`_D_IsWadPath`](File-src-d-main-ml-105344057.md#function-function-d-iswadpath-function-d-iswadpath-path-src-d-main-ml-1746733613) | `src/d_main.ml:852` | 14 | 18 | 11 | 10 | 1 | 856.83 | 52.98 |
| [`_D_MapNameFor`](File-src-d-main-ml-105344057.md#function-function-d-mapnamefor-function-d-mapnamefor-episode-map-src-d-main-ml-1238491371) | `src/d_main.ml:917` | 74 | 139 | 106 | 137 | 2 | 5345.14 | 18.86 |
| [`_D_MapPairsFromLumps`](File-src-d-main-ml-105344057.md#function-function-d-mappairsfromlumps-function-d-mappairsfromlumps-lumps-src-d-main-ml-606199023) | `src/d_main.ml:1017` | 20 | 15 | 7 | 9 | 3 | 840.25 | 50.2 |
| [`_D_NameInList`](File-src-d-main-ml-105344057.md#function-function-d-nameinlist-function-d-nameinlist-names-name-src-d-main-ml-803184755) | `src/d_main.ml:1097` | 9 | 8 | 4 | 4 | 2 | 247.25 | 61.89 |
| [`_D_ParseResponseArgs`](File-src-d-main-ml-105344057.md#function-function-d-parseresponseargs-function-d-parseresponseargs-data-src-d-main-ml-1258154820) | `src/d_main.ml:1577` | 19 | 15 | 10 | 13 | 2 | 672.02 | 50.96 |
| [`_D_ParseWadFilesFromArgs`](File-src-d-main-ml-105344057.md#function-function-d-parsewadfilesfromargs-function-d-parsewadfilesfromargs-src-d-main-ml-2140936060) | `src/d_main.ml:812` | 21 | 14 | 9 | 11 | 3 | 599.09 | 50.5 |
| [`_D_ProfileAdd`](File-src-d-main-ml-105344057.md#function-function-d-profileadd-function-d-profileadd-slot-delta-src-d-main-ml-353637884) | `src/d_main.ml:264` | 34 | 23 | 11 | 10 | 1 | 739.74 | 45.02 |
| [`_D_ProfileFlushMaybe`](File-src-d-main-ml-105344057.md#function-function-d-profileflushmaybe-function-d-profileflushmaybe-src-d-main-ml-1606119908) | `src/d_main.ml:491` | 94 | 96 | 8 | 7 | 1 | 3648.8 | 30.94 |
| [`_D_ProfileFrameSample`](File-src-d-main-ml-105344057.md#function-function-d-profileframesample-function-d-profileframesample-deltaus-src-d-main-ml-1578402304) | `src/d_main.ml:388` | 15 | 16 | 9 | 8 | 1 | 573.04 | 53.82 |
| [`_D_ProfileGameTick`](File-src-d-main-ml-105344057.md#function-function-d-profilegametick-function-d-profilegametick-src-d-main-ml-1027590416) | `src/d_main.ml:302` | 4 | 3 | 2 | 1 | 1 | 66.61 | 73.83 |
| [`_D_ProfileGLAdd`](File-src-d-main-ml-105344057.md#function-function-d-profilegladd-function-d-profilegladd-slot-delta-src-d-main-ml-976401050) | `src/d_main.ml:333` | 40 | 28 | 13 | 13 | 2 | 905.91 | 42.6 |
| [`_D_ProfileGLBatches`](File-src-d-main-ml-105344057.md#function-function-d-profileglbatches-function-d-profileglbatches-kind-total-drawn-vertices-src-d-main-ml-1901416829) | `src/d_main.ml:434` | 21 | 21 | 6 | 5 | 1 | 534.85 | 51.25 |
| [`_D_ProfileLog`](File-src-d-main-ml-105344057.md#function-function-d-profilelog-function-d-profilelog-line-src-d-main-ml-986565372) | `src/d_main.ml:321` | 7 | 5 | 3 | 2 | 1 | 187.3 | 65.25 |
| [`_D_ProfileMs`](File-src-d-main-ml-105344057.md#function-function-d-profilems-inline-function-d-profilems-us-src-d-main-ml-1942349021) | `src/d_main.ml:424` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`_D_ProfilePercentileMs`](File-src-d-main-ml-105344057.md#function-function-d-profilepercentilems-function-d-profilepercentilems-percent-src-d-main-ml-699214121) | `src/d_main.ml:407` | 13 | 13 | 6 | 6 | 2 | 430.86 | 56.45 |
| [`_D_ProfileThinker`](File-src-d-main-ml-105344057.md#function-function-d-profilethinker-function-d-profilethinker-ismobj-src-d-main-ml-1505897448) | `src/d_main.ml:310` | 7 | 7 | 4 | 3 | 1 | 175.69 | 65.31 |
| [`_D_ProfileTimeUs`](File-src-d-main-ml-105344057.md#function-function-d-profiletimeus-inline-function-d-profiletimeus-src-d-main-ml-1601460839) | `src/d_main.ml:377` | 7 | 5 | 3 | 3 | 2 | 169.92 | 65.55 |
| [`_D_ReadHDWADImageNames`](File-src-d-main-ml-105344057.md#function-function-d-readhdwadimagenames-function-d-readhdwadimagenames-path-src-d-main-ml-1763619289) | `src/d_main.ml:1070` | 22 | 26 | 16 | 15 | 1 | 1795.56 | 45.78 |
| [`_D_ReadHDWADLumpNames`](File-src-d-main-ml-105344057.md#function-function-d-readhdwadlumpnames-function-d-readhdwadlumpnames-path-src-d-main-ml-1487528589) | `src/d_main.ml:1041` | 25 | 30 | 19 | 18 | 1 | 2418.98 | 43.26 |
| [`_D_StatusBarVisible`](File-src-d-main-ml-105344057.md#function-function-d-statusbarvisible-inline-function-d-statusbarvisible-src-d-main-ml-2048695845) | `src/d_main.ml:1932` | 10 | 11 | 8 | 7 | 1 | 398.35 | 58.9 |
| [`_D_StrContains`](File-src-d-main-ml-105344057.md#function-function-d-strcontains-function-d-strcontains-haystack-needle-src-d-main-ml-1084280811) | `src/d_main.ml:1543` | 22 | 21 | 9 | 12 | 3 | 713.7 | 49.53 |
| [`_D_TimeMs`](File-src-d-main-ml-105344057.md#function-function-d-timems-inline-function-d-timems-src-d-main-ml-2126858933) | `src/d_main.ml:254` | 5 | 4 | 2 | 1 | 1 | 127.44 | 69.74 |
| [`_D_ToLowerAscii`](File-src-d-main-ml-105344057.md#function-function-d-tolowerascii-function-d-tolowerascii-s-src-d-main-ml-1193596467) | `src/d_main.ml:1528` | 10 | 9 | 5 | 5 | 2 | 375 | 59.49 |
| [`_DNet_CopyCmd`](File-src-d-net-ml-529296669.md#function-function-dnet-copycmd-inline-function-dnet-copycmd-src-src-d-net-ml-1325907731) | `src/d_net.ml:766` | 11 | 3 | 2 | 1 | 1 | 393.55 | 58.84 |
| [`_DNet_CopyStoreToBuffer`](File-src-d-net-ml-529296669.md#function-function-dnet-copystoretobuffer-function-dnet-copystoretobuffer-src-src-d-net-ml-438357362) | `src/d_net.ml:6328` | 20 | 15 | 7 | 7 | 2 | 894.08 | 50.01 |
| [`_DNet_DefaultCmds`](File-src-d-net-ml-529296669.md#function-function-dnet-defaultcmds-inline-function-dnet-defaultcmds-src-d-net-ml-1977705497) | `src/d_net.ml:616` | 9 | 6 | 2 | 1 | 1 | 210.83 | 62.64 |
| [`_DNet_EnsureStateArrays`](File-src-d-net-ml-529296669.md#function-function-dnet-ensurestatearrays-function-dnet-ensurestatearrays-src-d-net-ml-1697579430) | `src/d_net.ml:727` | 31 | 24 | 10 | 10 | 2 | 869.98 | 45.54 |
| [`_DNet_EnumIndex`](File-src-d-net-ml-529296669.md#function-function-dnet-enumindex-inline-function-dnet-enumindex-v-limit-src-d-net-ml-414909372) | `src/d_net.ml:657` | 15 | 15 | 10 | 11 | 2 | 525 | 53.95 |
| [`_DNet_IDiv`](File-src-d-net-ml-529296669.md#function-function-dnet-idiv-inline-function-dnet-idiv-a-b-src-d-net-ml-737104714) | `src/d_net.ml:678` | 8 | 8 | 3 | 2 | 1 | 305.53 | 62.5 |
| [`_DNet_IsSeq`](File-src-d-net-ml-529296669.md#function-function-dnet-isseq-inline-function-dnet-isseq-v-src-d-net-ml-296876571) | `src/d_net.ml:629` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_DNet_MakeStoreFromBuffer`](File-src-d-net-ml-529296669.md#function-function-dnet-makestorefrombuffer-function-dnet-makestorefrombuffer-src-d-net-ml-1469315966) | `src/d_net.ml:6305` | 19 | 9 | 5 | 5 | 2 | 687.65 | 51.57 |
| [`_DNet_MPAbs32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpabs32-inline-function-dnet-mpabs32-v-src-d-net-ml-1799194019) | `src/d_net.ml:3835` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_DNet_MPActiveSlots`](File-src-d-net-ml-529296669.md#function-function-dnet-mpactiveslots-inline-function-dnet-mpactiveslots-src-d-net-ml-1213473945) | `src/d_net.ml:1145` | 7 | 5 | 4 | 4 | 2 | 191.76 | 65.04 |
| [`_DNet_MPActorIsStaticForSync`](File-src-d-net-ml-529296669.md#function-function-dnet-mpactorisstaticforsync-inline-function-dnet-mpactorisstaticforsync-mo-src-d-net-ml-1686958069) | `src/d_net.ml:3926` | 17 | 19 | 16 | 15 | 1 | 1105.82 | 49.7 |
| [`_DNet_MPActorStateKey`](File-src-d-net-ml-529296669.md#function-function-dnet-mpactorstatekey-inline-function-dnet-mpactorstatekey-mo-src-d-net-ml-1491357537) | `src/d_net.ml:4035` | 17 | 17 | 3 | 2 | 1 | 1379.49 | 50.77 |
| [`_DNet_MPActorUsable`](File-src-d-net-ml-529296669.md#function-function-dnet-mpactorusable-inline-function-dnet-mpactorusable-mo-src-d-net-ml-1157409265) | `src/d_net.ml:2410` | 11 | 12 | 11 | 10 | 1 | 581.39 | 56.45 |
| [`_DNet_MPAngleAbsDelta`](File-src-d-net-ml-529296669.md#function-function-dnet-mpangleabsdelta-inline-function-dnet-mpangleabsdelta-a-b-src-d-net-ml-1340856186) | `src/d_net.ml:3863` | 8 | 8 | 3 | 2 | 1 | 235.23 | 63.29 |
| [`_DNet_MPAngleDeltaSigned`](File-src-d-net-ml-529296669.md#function-function-dnet-mpangledeltasigned-inline-function-dnet-mpangledeltasigned-toang-fromang-src-d-net-ml-1178048032) | `src/d_net.ml:3365` | 6 | 6 | 3 | 2 | 1 | 235.23 | 66.02 |
| [`_DNet_MPApproxDist2D`](File-src-d-net-ml-529296669.md#function-function-dnet-mpapproxdist2d-inline-function-dnet-mpapproxdist2d-dx-dy-src-d-net-ml-1511403408) | `src/d_net.ml:3844` | 7 | 6 | 2 | 1 | 1 | 200.67 | 65.17 |
| [`_DNet_MPBuildChatPacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildchatpacket-function-dnet-mpbuildchatpacket-senderslot-dest-msg-src-d-net-ml-410656134) | `src/d_net.ml:1870` | 16 | 13 | 2 | 1 | 1 | 539.27 | 54.34 |
| [`_DNet_MPBuildFeedPacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildfeedpacket-inline-function-dnet-mpbuildfeedpacket-code-a-b-src-d-net-ml-67118443) | `src/d_net.ml:1830` | 8 | 6 | 1 | 0 | 0 | 311.14 | 62.71 |
| [`_DNet_MPBuildIntermissionWB`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildintermissionwb-function-dnet-mpbuildintermissionwb-src-d-net-ml-2105750424) | `src/d_net.ml:1320` | 102 | 82 | 35 | 81 | 6 | 4916.09 | 25.63 |
| [`_DNet_MPBuildNamePacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildnamepacket-function-dnet-mpbuildnamepacket-slot-name-src-d-net-ml-563911167) | `src/d_net.ml:2066` | 16 | 14 | 3 | 2 | 1 | 518.06 | 54.32 |
| [`_DNet_MPBuildPhasePacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildphasepacket-function-dnet-mpbuildphasepacket-src-d-net-ml-1006707098) | `src/d_net.ml:2298` | 17 | 17 | 3 | 2 | 1 | 771.49 | 52.54 |
| [`_DNet_MPBuildSnapshotPacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildsnapshotpacket-function-dnet-mpbuildsnapshotpacket-forceall-snapshottick-src-d-net-ml-1421533285) | `src/d_net.ml:4573` | 630 | 596 | 167 | 383 | 6 | 35945.25 | 0 |
| [`_DNet_MPBuildWIStatsPacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpbuildwistatspacket-function-dnet-mpbuildwistatspacket-src-d-net-ml-190965254) | `src/d_net.ml:1495` | 90 | 90 | 34 | 51 | 4 | 6637.17 | 26.04 |
| [`_DNet_MPClampAbs`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclampabs-inline-function-dnet-mpclampabs-v-limit-src-d-net-ml-1287851144) | `src/d_net.ml:3376` | 9 | 11 | 5 | 4 | 1 | 298.68 | 61.18 |
| [`_DNet_MPClientActorMissLimit`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientactormisslimit-inline-function-dnet-mpclientactormisslimit-baselimit-mo-src-d-net-ml-2142042409) | `src/d_net.ml:3981` | 22 | 24 | 15 | 19 | 2 | 983.19 | 47.74 |
| [`_DNet_MPClientAdvanceActors`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientadvanceactors-function-dnet-mpclientadvanceactors-src-d-net-ml-1782398728) | `src/d_net.ml:3602` | 109 | 101 | 37 | 106 | 6 | 4998.84 | 24.68 |
| [`_DNet_MPClientAdvancePlayers`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientadvanceplayers-function-dnet-mpclientadvanceplayers-src-d-net-ml-949574054) | `src/d_net.ml:3719` | 107 | 99 | 41 | 109 | 6 | 5214.77 | 24.19 |
| [`_DNet_MPClientApplyChat`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientapplychat-inline-function-dnet-mpclientapplychat-payload-src-d-net-ml-320147415) | `src/d_net.ml:1942` | 19 | 22 | 12 | 11 | 1 | 1095.44 | 49.21 |
| [`_DNet_MPClientApplyFeed`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientapplyfeed-function-dnet-mpclientapplyfeed-payload-src-d-net-ml-1750289340) | `src/d_net.ml:5407` | 20 | 16 | 10 | 9 | 1 | 850.63 | 49.76 |
| [`_DNet_MPClientApplyName`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientapplyname-function-dnet-mpclientapplyname-payload-src-d-net-ml-1845363598) | `src/d_net.ml:2133` | 18 | 17 | 11 | 10 | 1 | 758.86 | 50.97 |
| [`_DNet_MPClientApplyPhase`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientapplyphase-function-dnet-mpclientapplyphase-payload-src-d-net-ml-767835662) | `src/d_net.ml:5431` | 174 | 169 | 38 | 71 | 6 | 6155.86 | 19.48 |
| [`_DNet_MPClientApplySnapshot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientapplysnapshot-function-dnet-mpclientapplysnapshot-payload-src-d-net-ml-118107484) | `src/d_net.ml:5619` | 584 | 512 | 200 | 622 | 8 | 34158.46 | 0 |
| [`_DNet_MPClientApplyWIStats`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientapplywistats-function-dnet-mpclientapplywistats-payload-src-d-net-ml-1228798750) | `src/d_net.ml:1676` | 104 | 106 | 28 | 36 | 4 | 4991.99 | 26.34 |
| [`_DNet_MPClientBindActorId`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientbindactorid-inline-function-dnet-mpclientbindactorid-idx-aid-src-d-net-ml-1604579610) | `src/d_net.ml:4125` | 10 | 7 | 6 | 5 | 1 | 273.99 | 60.31 |
| [`_DNet_MPClientBootstrapWorld`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientbootstrapworld-function-dnet-mpclientbootstrapworld-src-d-net-ml-1311616966) | `src/d_net.ml:4175` | 65 | 64 | 12 | 21 | 4 | 1553.85 | 36.49 |
| [`_DNet_MPClientClassifyActor`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientclassifyactor-inline-function-dnet-mpclientclassifyactor-atype-flags-mo-src-d-net-ml-9833139) | `src/d_net.ml:3511` | 13 | 15 | 13 | 12 | 1 | 851.24 | 53.44 |
| [`_DNet_MPClientEnsureActorMotionSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientensureactormotionslot-inline-function-dnet-mpclientensureactormotionslot-idx-src-d-net-ml-1359704682) | `src/d_net.ml:3389` | 26 | 26 | 3 | 2 | 1 | 564.71 | 49.46 |
| [`_DNet_MPClientEnsurePlayerMotionSlots`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientensureplayermotionslots-inline-function-dnet-mpclientensureplayermotionslots-src-d-net-ml-206265) | `src/d_net.ml:3418` | 22 | 21 | 2 | 1 | 1 | 441.62 | 51.93 |
| [`_DNet_MPClientFindActorByPose`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientfindactorbypose-function-dnet-mpclientfindactorbypose-atype-ax-ay-az-claimed-src-d-net-ml-2011604112) | `src/d_net.ml:4062` | 27 | 21 | 14 | 24 | 5 | 1219.07 | 45.28 |
| [`_DNet_MPClientFindActorByUidField`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientfindactorbyuidfield-inline-function-dnet-mpclientfindactorbyuidfield-aid-src-d-net-ml-900818695) | `src/d_net.ml:3327` | 11 | 7 | 4 | 4 | 2 | 282.39 | 59.58 |
| [`_DNet_MPClientFindActorIndex`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientfindactorindex-inline-function-dnet-mpclientfindactorindex-idv-src-d-net-ml-1968831100) | `src/d_net.ml:3315` | 8 | 6 | 3 | 3 | 2 | 208.97 | 63.65 |
| [`_DNet_MPClientFindClaimedActorExact`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientfindclaimedactorexact-function-dnet-mpclientfindclaimedactorexact-atype-ax-ay-az-aang-aspr-afrm-astate-claimed-src-d-net-ml-499989603) | `src/d_net.ml:4102` | 18 | 14 | 16 | 26 | 5 | 1214.32 | 48.87 |
| [`_DNet_MPClientFindFreeActorSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientfindfreeactorslot-inline-function-dnet-mpclientfindfreeactorslot-src-d-net-ml-499823801) | `src/d_net.ml:3341` | 10 | 9 | 5 | 6 | 2 | 338.58 | 59.8 |
| [`_DNet_MPClientRemoveActorAt`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientremoveactorat-inline-function-dnet-mpclientremoveactorat-idx-src-d-net-ml-859753826) | `src/d_net.ml:4139` | 33 | 39 | 26 | 25 | 1 | 1601.48 | 40.94 |
| [`_DNet_MPClientResetPlayerMotionSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientresetplayermotionslot-inline-function-dnet-mpclientresetplayermotionslot-slot-src-d-net-ml-1691437429) | `src/d_net.ml:3444` | 13 | 12 | 3 | 2 | 1 | 400 | 57.08 |
| [`_DNet_MPClientStaleMissLimit`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientstalemisslimit-function-dnet-mpclientstalemisslimit-src-d-net-ml-1455318298) | `src/d_net.ml:4008` | 20 | 20 | 9 | 9 | 2 | 697.17 | 50.5 |
| [`_DNet_MPClientTrackActorSnapshot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclienttrackactorsnapshot-function-dnet-mpclienttrackactorsnapshot-idx-mo-atype-afl-ax-ay-az-aang-snaptick-spawnednow-src-d-net-ml-1326063569) | `src/d_net.ml:3537` | 58 | 52 | 9 | 9 | 2 | 1884.3 | 37.39 |
| [`_DNet_MPClientTrackPlayerSnapshot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclienttrackplayersnapshot-function-dnet-mpclienttrackplayersnapshot-slot-px-py-pz-pang-snaptick-hardsnap-src-d-net-ml-1162120845) | `src/d_net.ml:3467` | 35 | 32 | 6 | 5 | 1 | 1360.17 | 43.57 |
| [`_DNet_MPClientUpdateWIStatsSync`](File-src-d-net-ml-529296669.md#function-function-dnet-mpclientupdatewistatssync-function-dnet-mpclientupdatewistatssync-src-d-net-ml-1864367782) | `src/d_net.ml:1793` | 28 | 27 | 8 | 8 | 2 | 618.39 | 47.81 |
| [`_DNet_MPCmdEquals`](File-src-d-net-ml-529296669.md#function-function-dnet-mpcmdequals-inline-function-dnet-mpcmdequals-a-b-src-d-net-ml-129934498) | `src/d_net.ml:4246` | 10 | 15 | 9 | 8 | 1 | 803.58 | 56.63 |
| [`_DNet_MPCopyFrags4`](File-src-d-net-ml-529296669.md#function-function-dnet-mpcopyfrags4-inline-function-dnet-mpcopyfrags4-src-src-d-net-ml-1771428857) | `src/d_net.ml:1184` | 10 | 11 | 6 | 9 | 2 | 565.45 | 58.11 |
| [`_DNet_MPDrainAuthoritativePackets`](File-src-d-net-ml-529296669.md#function-function-dnet-mpdrainauthoritativepackets-function-dnet-mpdrainauthoritativepackets-src-d-net-ml-1836919678) | `src/d_net.ml:6225` | 71 | 70 | 47 | 94 | 5 | 3289.67 | 28.67 |
| [`_DNet_MPEnsureHostSlotMobj`](File-src-d-net-ml-529296669.md#function-function-dnet-mpensurehostslotmobj-function-dnet-mpensurehostslotmobj-slot-src-d-net-ml-1948319562) | `src/d_net.ml:4390` | 116 | 94 | 62 | 77 | 3 | 7284.96 | 19.58 |
| [`_DNet_MPEnsurePlayerStruct`](File-src-d-net-ml-529296669.md#function-function-dnet-mpensureplayerstruct-inline-function-dnet-mpensureplayerstruct-slot-src-d-net-ml-1762105183) | `src/d_net.ml:3231` | 10 | 9 | 6 | 5 | 1 | 326.9 | 59.77 |
| [`_DNet_MPHostActorRelevantForSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostactorrelevantforslot-inline-function-dnet-mphostactorrelevantforslot-slot-mo-src-d-net-ml-1732957373) | `src/d_net.ml:3876` | 37 | 36 | 15 | 16 | 2 | 1936.85 | 40.76 |
| [`_DNet_MPHostApplyActiveSlots`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostapplyactiveslots-function-dnet-mphostapplyactiveslots-src-d-net-ml-1335133890) | `src/d_net.ml:4514` | 54 | 43 | 31 | 63 | 6 | 3509.38 | 33.22 |
| [`_DNet_MPHostBroadcastAllNames`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostbroadcastallnames-function-dnet-mphostbroadcastallnames-src-d-net-ml-1207325710) | `src/d_net.ml:2116` | 13 | 10 | 5 | 5 | 2 | 386.43 | 56.91 |
| [`_DNet_MPHostBroadcastKillFeed`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostbroadcastkillfeed-function-dnet-mphostbroadcastkillfeed-killer-victim-src-d-net-ml-2054318403) | `src/d_net.ml:1891` | 20 | 17 | 9 | 9 | 2 | 809.82 | 50.04 |
| [`_DNet_MPHostBroadcastName`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostbroadcastname-function-dnet-mphostbroadcastname-slot-name-src-d-net-ml-747329257) | `src/d_net.ml:2098` | 15 | 13 | 7 | 9 | 3 | 519.68 | 54.39 |
| [`_DNet_MPHostBroadcastTelefragFeed`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostbroadcasttelefragfeed-function-dnet-mphostbroadcasttelefragfeed-killer-victim-src-d-net-ml-835436891) | `src/d_net.ml:1917` | 20 | 17 | 9 | 9 | 2 | 814.13 | 50.03 |
| [`_DNet_MPHostBroadcastWIStats`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostbroadcastwistats-function-dnet-mphostbroadcastwistats-src-d-net-ml-2038592958) | `src/d_net.ml:1605` | 14 | 11 | 5 | 5 | 2 | 373.29 | 56.32 |
| [`_DNet_MPHostCheckFragFeed`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostcheckfragfeed-function-dnet-mphostcheckfragfeed-src-d-net-ml-605267374) | `src/d_net.ml:2230` | 42 | 33 | 18 | 31 | 5 | 1468.85 | 39.99 |
| [`_DNet_MPHostCollectActorChunk`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostcollectactorchunk-function-dnet-mphostcollectactorchunk-maxcount-forceall-snapshottick-src-d-net-ml-314326704) | `src/d_net.ml:2706` | 104 | 93 | 36 | 77 | 6 | 3753.81 | 26.13 |
| [`_DNet_MPHostCollectSectorChanges`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostcollectsectorchanges-function-dnet-mphostcollectsectorchanges-maxcount-forceall-src-d-net-ml-354029985) | `src/d_net.ml:3045` | 64 | 67 | 26 | 35 | 3 | 2541.44 | 33.26 |
| [`_DNet_MPHostCollectSideChanges`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostcollectsidechanges-function-dnet-mphostcollectsidechanges-maxcount-forceall-src-d-net-ml-1321076381) | `src/d_net.ml:3158` | 62 | 65 | 25 | 34 | 3 | 2363.82 | 33.92 |
| [`_DNet_MPHostEnsureSectorCache`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostensuresectorcache-function-dnet-mphostensuresectorcache-src-d-net-ml-713187302) | `src/d_net.ml:3003` | 34 | 30 | 10 | 9 | 1 | 1153.96 | 43.81 |
| [`_DNet_MPHostEnsureSideCache`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostensuresidecache-function-dnet-mphostensuresidecache-src-d-net-ml-1129331936) | `src/d_net.ml:3119` | 31 | 28 | 9 | 8 | 1 | 1012.58 | 45.21 |
| [`_DNet_MPHostFindActorIndex`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostfindactorindex-inline-function-dnet-mphostfindactorindex-nodekey-src-d-net-ml-228544860) | `src/d_net.ml:2438` | 9 | 8 | 6 | 6 | 2 | 359.49 | 60.48 |
| [`_DNet_MPHostFindActorIndexByPose`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostfindactorindexbypose-function-dnet-mphostfindactorindexbypose-owner-src-d-net-ml-1181323827) | `src/d_net.ml:2462` | 22 | 19 | 10 | 15 | 4 | 1106.2 | 48.06 |
| [`_DNet_MPHostFindFreeActorSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostfindfreeactorslot-inline-function-dnet-mphostfindfreeactorslot-src-d-net-ml-1239942337) | `src/d_net.ml:2450` | 8 | 6 | 3 | 3 | 2 | 201.74 | 63.76 |
| [`_DNet_MPHostHandleChatPacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mphosthandlechatpacket-function-dnet-mphosthandlechatpacket-node-payload-src-d-net-ml-1341369538) | `src/d_net.ml:2003` | 32 | 39 | 20 | 23 | 2 | 1927.16 | 41.48 |
| [`_DNet_MPHostHandleInputPacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mphosthandleinputpacket-function-dnet-mphosthandleinputpacket-node-payload-src-d-net-ml-1816039086) | `src/d_net.ml:4317` | 61 | 59 | 35 | 43 | 4 | 3624.69 | 31.43 |
| [`_DNet_MPHostHandleNamePacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mphosthandlenamepacket-function-dnet-mphosthandlenamepacket-node-payload-src-d-net-ml-1084001242) | `src/d_net.ml:2156` | 19 | 22 | 13 | 12 | 1 | 888.73 | 49.71 |
| [`_DNet_MPHostHandleWIStatsRequest`](File-src-d-net-ml-529296669.md#function-function-dnet-mphosthandlewistatsrequest-inline-function-dnet-mphosthandlewistatsrequest-node-payload-src-d-net-ml-1317611309) | `src/d_net.ml:1624` | 15 | 18 | 11 | 11 | 2 | 770.53 | 52.65 |
| [`_DNet_MPHostInvalidateActorSigById`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostinvalidateactorsigbyid-inline-function-dnet-mphostinvalidateactorsigbyid-aid-src-d-net-ml-383408763) | `src/d_net.ml:2822` | 13 | 10 | 5 | 5 | 2 | 317.29 | 57.51 |
| [`_DNet_MPHostIsLikelyTelefrag`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostislikelytelefrag-function-dnet-mphostislikelytelefrag-killer-victim-src-d-net-ml-499363637) | `src/d_net.ml:2210` | 17 | 25 | 18 | 17 | 1 | 1379.49 | 48.75 |
| [`_DNet_MPHostMarkSlotFullsync`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostmarkslotfullsync-inline-function-dnet-mphostmarkslotfullsync-slot-src-d-net-ml-2075551653) | `src/d_net.ml:3259` | 9 | 7 | 4 | 3 | 1 | 304.23 | 61.26 |
| [`_DNet_MPHostMaybeSendPhase`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostmaybesendphase-function-dnet-mphostmaybesendphase-force-src-d-net-ml-334833743) | `src/d_net.ml:2319` | 67 | 58 | 28 | 38 | 3 | 2619.31 | 32.47 |
| [`_DNet_MPHostMaybeSendSnapshot`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostmaybesendsnapshot-function-dnet-mphostmaybesendsnapshot-forceall-src-d-net-ml-514344400) | `src/d_net.ml:5281` | 116 | 93 | 39 | 71 | 6 | 3854.07 | 24.61 |
| [`_DNet_MPHostPopRemovedIds`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostpopremovedids-function-dnet-mphostpopremovedids-maxcount-src-d-net-ml-417378493) | `src/d_net.ml:2947` | 49 | 44 | 14 | 18 | 3 | 1400.42 | 39.22 |
| [`_DNet_MPHostQueueRemovedId`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostqueueremovedid-inline-function-dnet-mphostqueueremovedid-idv-src-d-net-ml-1197986382) | `src/d_net.ml:2488` | 20 | 18 | 5 | 5 | 2 | 573.86 | 51.63 |
| [`_DNet_MPHostRefreshActorRegistry`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostrefreshactorregistry-function-dnet-mphostrefreshactorregistry-src-d-net-ml-494029294) | `src/d_net.ml:2511` | 173 | 168 | 66 | 168 | 6 | 7781.3 | 15.06 |
| [`_DNet_MPHostRelayChat`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostrelaychat-function-dnet-mphostrelaychat-sender-dest-txt-src-d-net-ml-618409569) | `src/d_net.ml:1967` | 29 | 27 | 19 | 21 | 3 | 1329.76 | 43.67 |
| [`_DNet_MPHostRequeueDroppedActorRows`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostrequeuedroppedactorrows-function-dnet-mphostrequeuedroppedactorrows-actorids-startidx-src-d-net-ml-121309424) | `src/d_net.ml:2840` | 11 | 11 | 5 | 5 | 2 | 365.36 | 58.67 |
| [`_DNet_MPHostSelectActorsForSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostselectactorsforslot-function-dnet-mphostselectactorsforslot-slot-actorids-actorrefs-maxcount-forceall-snapshottick-src-d-net-ml-1133359884) | `src/d_net.ml:2860` | 77 | 73 | 21 | 28 | 3 | 3006.88 | 31.67 |
| [`_DNet_MPHostSendWIStatsTo`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostsendwistatsto-inline-function-dnet-mphostsendwistatsto-slot-src-d-net-ml-1172046521) | `src/d_net.ml:1593` | 9 | 11 | 6 | 5 | 1 | 376.52 | 60.34 |
| [`_DNet_MPHostSnapshotInterval`](File-src-d-net-ml-529296669.md#function-function-dnet-mphostsnapshotinterval-inline-function-dnet-mphostsnapshotinterval-src-d-net-ml-1885979425) | `src/d_net.ml:5247` | 25 | 21 | 12 | 14 | 3 | 734.43 | 47.82 |
| [`_DNet_MPIntermissionNextMap`](File-src-d-net-ml-529296669.md#function-function-dnet-mpintermissionnextmap-inline-function-dnet-mpintermissionnextmap-src-d-net-ml-165051741) | `src/d_net.ml:2286` | 9 | 8 | 6 | 5 | 1 | 366.61 | 60.42 |
| [`_DNet_MPIsAuthoritative`](File-src-d-net-ml-529296669.md#function-function-dnet-mpisauthoritative-inline-function-dnet-mpisauthoritative-src-d-net-ml-1120883385) | `src/d_net.ml:794` | 3 | 1 | 1 | 0 | 0 | 49.83 | 77.57 |
| [`_DNet_MPIsClient`](File-src-d-net-ml-529296669.md#function-function-dnet-mpisclient-inline-function-dnet-mpisclient-src-d-net-ml-985891305) | `src/d_net.ml:787` | 4 | 3 | 2 | 1 | 1 | 87.57 | 73 |
| [`_DNet_MPIsHost`](File-src-d-net-ml-529296669.md#function-function-dnet-mpishost-inline-function-dnet-mpishost-src-d-net-ml-76636219) | `src/d_net.ml:780` | 4 | 3 | 2 | 1 | 1 | 87.57 | 73 |
| [`_DNet_MPLevelReady`](File-src-d-net-ml-529296669.md#function-function-dnet-mplevelready-function-dnet-mplevelready-src-d-net-ml-1706688174) | `src/d_net.ml:2393` | 13 | 12 | 12 | 12 | 2 | 593.88 | 54.66 |
| [`_DNet_MPMakeWBRowForSlot`](File-src-d-net-ml-529296669.md#function-function-dnet-mpmakewbrowforslot-function-dnet-mpmakewbrowforslot-slot-src-d-net-ml-1649044330) | `src/d_net.ml:1269` | 40 | 37 | 21 | 30 | 3 | 2170.7 | 38.87 |
| [`_DNet_MPNormalizeChatText`](File-src-d-net-ml-529296669.md#function-function-dnet-mpnormalizechattext-function-dnet-mpnormalizechattext-msg-src-d-net-ml-2040249925) | `src/d_net.ml:1842` | 21 | 20 | 9 | 11 | 3 | 739.75 | 49.86 |
| [`_DNet_MPPhaseCode`](File-src-d-net-ml-529296669.md#function-function-dnet-mpphasecode-inline-function-dnet-mpphasecode-src-d-net-ml-845364153) | `src/d_net.ml:2277` | 6 | 7 | 4 | 3 | 1 | 181.52 | 66.67 |
| [`_DNet_MPPlayerHasAnyOwnedWeapon`](File-src-d-net-ml-529296669.md#function-function-dnet-mpplayerhasanyownedweapon-inline-function-dnet-mpplayerhasanyownedweapon-p-src-d-net-ml-31687821) | `src/d_net.ml:3245` | 10 | 10 | 6 | 6 | 2 | 346.79 | 59.59 |
| [`_DNet_MPPlayerName`](File-src-d-net-ml-529296669.md#function-function-dnet-mpplayername-inline-function-dnet-mpplayername-slot-src-d-net-ml-1015615399) | `src/d_net.ml:1170` | 10 | 10 | 6 | 6 | 2 | 386.43 | 59.26 |
| [`_DNet_MPReadFixedName`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreadfixedname-function-dnet-mpreadfixedname-payload-off-width-src-d-net-ml-451826231) | `src/d_net.ml:1234` | 29 | 34 | 14 | 15 | 2 | 1188.68 | 44.68 |
| [`_DNet_MPReadI16`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreadi16-inline-function-dnet-mpreadi16-buf-off-src-d-net-ml-1839860647) | `src/d_net.ml:868` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`_DNet_MPReadI32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreadi32-inline-function-dnet-mpreadi32-buf-off-src-d-net-ml-32614367) | `src/d_net.ml:892` | 9 | 8 | 2 | 1 | 1 | 425.73 | 60.51 |
| [`_DNet_MPReadNamePacket`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreadnamepacket-function-dnet-mpreadnamepacket-payload-src-d-net-ml-324417506) | `src/d_net.ml:2086` | 7 | 8 | 7 | 6 | 1 | 446.25 | 62.07 |
| [`_DNet_MPReadU16`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreadu16-inline-function-dnet-mpreadu16-buf-off-src-d-net-ml-716767983) | `src/d_net.ml:858` | 5 | 3 | 1 | 0 | 0 | 160.54 | 69.17 |
| [`_DNet_MPReadU32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreadu32-inline-function-dnet-mpreadu32-buf-off-src-d-net-ml-1974594903) | `src/d_net.ml:878` | 9 | 8 | 2 | 1 | 1 | 422.26 | 60.53 |
| [`_DNet_MPResetRuntime`](File-src-d-net-ml-529296669.md#function-function-dnet-mpresetruntime-function-dnet-mpresetruntime-src-d-net-ml-363594122) | `src/d_net.ml:919` | 194 | 191 | 2 | 1 | 1 | 4274.12 | 24.4 |
| [`_DNet_MPReturnToOffline`](File-src-d-net-ml-529296669.md#function-function-dnet-mpreturntooffline-function-dnet-mpreturntooffline-wasclient-src-d-net-ml-1990907642) | `src/d_net.ml:1643` | 17 | 17 | 6 | 5 | 1 | 442.08 | 53.83 |
| [`_DNet_MPSendInputCmd`](File-src-d-net-ml-529296669.md#function-function-dnet-mpsendinputcmd-function-dnet-mpsendinputcmd-cmd-src-d-net-ml-552648740) | `src/d_net.ml:4260` | 48 | 54 | 19 | 28 | 3 | 2483.78 | 37 |
| [`_DNet_MPSendWIStatsRequest`](File-src-d-net-ml-529296669.md#function-function-dnet-mpsendwistatsrequest-inline-function-dnet-mpsendwistatsrequest-src-d-net-ml-1785454439) | `src/d_net.ml:1663` | 9 | 9 | 3 | 2 | 1 | 383.37 | 60.69 |
| [`_DNet_MPSeqIsNewer`](File-src-d-net-ml-529296669.md#function-function-dnet-mpseqisnewer-inline-function-dnet-mpseqisnewer-a-b-src-d-net-ml-480064680) | `src/d_net.ml:906` | 10 | 11 | 4 | 3 | 1 | 371.56 | 59.65 |
| [`_DNet_MPSetPlayerSlotActive`](File-src-d-net-ml-529296669.md#function-function-dnet-mpsetplayerslotactive-function-dnet-mpsetplayerslotactive-slot-active-src-d-net-ml-1778747358) | `src/d_net.ml:3273` | 38 | 27 | 23 | 29 | 2 | 1407.41 | 40.4 |
| [`_DNet_MPSign32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpsign32-inline-function-dnet-mpsign32-v-src-d-net-ml-1998853025) | `src/d_net.ml:3355` | 5 | 5 | 3 | 2 | 1 | 113.3 | 69.97 |
| [`_DNet_MPSlotActive`](File-src-d-net-ml-529296669.md#function-function-dnet-mpslotactive-inline-function-dnet-mpslotactive-active-slot-src-d-net-ml-1962931165) | `src/d_net.ml:1157` | 9 | 8 | 4 | 4 | 2 | 281.76 | 61.49 |
| [`_DNet_MPStateKeyEquals`](File-src-d-net-ml-529296669.md#function-function-dnet-mpstatekeyequals-inline-function-dnet-mpstatekeyequals-a-b-src-d-net-ml-1487521922) | `src/d_net.ml:3966` | 10 | 10 | 6 | 6 | 2 | 435.97 | 58.9 |
| [`_DNet_MPStaticActorHeartbeatHit`](File-src-d-net-ml-529296669.md#function-function-dnet-mpstaticactorheartbeathit-inline-function-dnet-mpstaticactorheartbeathit-idv-snapshottick-src-d-net-ml-1913851425) | `src/d_net.ml:3952` | 8 | 9 | 4 | 3 | 1 | 388.64 | 61.63 |
| [`_DNet_MPThinkerIsMobj`](File-src-d-net-ml-529296669.md#function-function-dnet-mpthinkerismobj-inline-function-dnet-mpthinkerismobj-node-src-d-net-ml-999486565) | `src/d_net.ml:2427` | 7 | 9 | 5 | 4 | 1 | 307.7 | 63.47 |
| [`_DNet_MPU32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpu32-inline-function-dnet-mpu32-v-src-d-net-ml-623133935) | `src/d_net.ml:3855` | 3 | 1 | 1 | 0 | 0 | 62.91 | 76.86 |
| [`_DNet_MPWBRowChanged`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwbrowchanged-inline-function-dnet-mpwbrowchanged-a-b-src-d-net-ml-1851651394) | `src/d_net.ml:1436` | 28 | 33 | 16 | 15 | 1 | 1795.64 | 43.49 |
| [`_DNet_MPWBStatsChanged`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwbstatschanged-inline-function-dnet-mpwbstatschanged-oldwb-newwb-src-d-net-ml-2001596236) | `src/d_net.ml:1472` | 18 | 24 | 15 | 17 | 2 | 1229.45 | 48.97 |
| [`_DNet_MPWriteFixedName`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwritefixedname-function-dnet-mpwritefixedname-payload-off-width-name-src-d-net-ml-1735799266) | `src/d_net.ml:1201` | 25 | 29 | 15 | 15 | 2 | 1087.39 | 46.23 |
| [`_DNet_MPWriteI16`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwritei16-inline-function-dnet-mpwritei16-buf-off-v-src-d-net-ml-383399033) | `src/d_net.ml:818` | 10 | 13 | 7 | 6 | 1 | 541.78 | 58.1 |
| [`_DNet_MPWriteI32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwritei32-inline-function-dnet-mpwritei32-buf-off-v-src-d-net-ml-1422226517) | `src/d_net.ml:850` | 3 | 1 | 1 | 0 | 0 | 92.51 | 75.69 |
| [`_DNet_MPWriteU16`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwriteu16-inline-function-dnet-mpwriteu16-buf-off-v-src-d-net-ml-581765625) | `src/d_net.ml:803` | 9 | 10 | 5 | 4 | 1 | 428.77 | 60.08 |
| [`_DNet_MPWriteU32`](File-src-d-net-ml-529296669.md#function-function-dnet-mpwriteu32-inline-function-dnet-mpwriteu32-buf-off-v-src-d-net-ml-2118689101) | `src/d_net.ml:834` | 10 | 11 | 5 | 4 | 1 | 573.04 | 58.2 |
| [`_DNet_RunGameTics`](File-src-d-net-ml-529296669.md#function-function-dnet-rungametics-function-dnet-rungametics-counts-src-d-net-ml-98592648) | `src/d_net.ml:6783` | 36 | 33 | 16 | 40 | 6 | 1347.31 | 41.99 |
| [`_DNet_StateIndex`](File-src-d-net-ml-529296669.md#function-function-dnet-stateindex-function-dnet-stateindex-s-src-d-net-ml-525156693) | `src/d_net.ml:691` | 29 | 27 | 15 | 18 | 3 | 1494.18 | 43.85 |
| [`_DNet_ToInt`](File-src-d-net-ml-529296669.md#function-function-dnet-toint-inline-function-dnet-toint-v-fallback-src-d-net-ml-1163889037) | `src/d_net.ml:638` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_DNet_TryRunTicsUncapped`](File-src-d-net-ml-529296669.md#function-function-dnet-tryrunticsuncapped-function-dnet-tryrunticsuncapped-src-d-net-ml-767296054) | `src/d_net.ml:6825` | 31 | 34 | 14 | 16 | 3 | 1156.99 | 44.13 |
| [`_DoorsAddThinkerIfPossible`](File-src-p-doors-ml-224295587.md#function-function-doorsaddthinkerifpossible-inline-function-doorsaddthinkerifpossible-th-src-p-doors-ml-430232801) | `src/p_doors.ml:39` | 3 | 2 | 2 | 1 | 1 | 81.41 | 75.94 |
| [`_DoorsBackSector`](File-src-p-doors-ml-224295587.md#function-function-doorsbacksector-inline-function-doorsbacksector-line-src-p-doors-ml-650965929) | `src/p_doors.ml:109` | 11 | 16 | 10 | 9 | 1 | 600.28 | 56.48 |
| [`_DoorsHasCard`](File-src-p-doors-ml-224295587.md#function-function-doorshascard-function-doorshascard-player-card-src-p-doors-ml-1597228475) | `src/p_doors.ml:73` | 29 | 28 | 14 | 20 | 4 | 999.52 | 45.21 |
| [`_DoorsIsSeq`](File-src-p-doors-ml-224295587.md#function-function-doorsisseq-inline-function-doorsisseq-v-src-p-doors-ml-486324013) | `src/p_doors.ml:64` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_DoorsMakeThinker`](File-src-p-doors-ml-224295587.md#function-function-doorsmakethinker-inline-function-doorsmakethinker-fn-src-p-doors-ml-1505777603) | `src/p_doors.ml:32` | 3 | 1 | 1 | 0 | 0 | 93.21 | 75.67 |
| [`_DoorsSoundOrg`](File-src-p-doors-ml-224295587.md#function-function-doorssoundorg-inline-function-doorssoundorg-sec-src-p-doors-ml-221562458) | `src/p_doors.ml:56` | 4 | 3 | 2 | 1 | 1 | 79.95 | 73.27 |
| [`_DoorsStartSound`](File-src-p-doors-ml-224295587.md#function-function-doorsstartsound-inline-function-doorsstartsound-origin-snd-src-p-doors-ml-1357597958) | `src/p_doors.ml:47` | 5 | 2 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_DP_BoolArray`](File-src-d-player-ml-1944166105.md#function-function-dp-boolarray-function-dp-boolarray-n-v-src-d-player-ml-953575162) | `src/d_player.ml:204` | 12 | 8 | 4 | 3 | 1 | 246.12 | 59.18 |
| [`_DP_IntArray`](File-src-d-player-ml-1944166105.md#function-function-dp-intarray-function-dp-intarray-n-v-src-d-player-ml-641535692) | `src/d_player.ml:187` | 12 | 8 | 4 | 3 | 1 | 246.12 | 59.18 |
| [`_EnsureIntercepts`](File-src-p-maputl-ml-227665141.md#function-function-ensureintercepts-inline-function-ensureintercepts-src-p-maputl-ml-1279046185) | `src/p_maputl.ml:478` | 10 | 6 | 3 | 3 | 2 | 230.32 | 61.24 |
| [`_ensurePsprites`](File-src-p-pspr-ml-844718747.md#function-function-ensurepsprites-function-ensurepsprites-player-src-p-pspr-ml-1714897315) | `src/p_pspr.ml:310` | 11 | 8 | 4 | 3 | 1 | 324.33 | 59.16 |
| [`_F_AnyPlayerButtons`](File-src-f-finale-ml-635076109.md#function-function-f-anyplayerbuttons-function-f-anyplayerbuttons-src-f-finale-ml-624245860) | `src/f_finale.ml:118` | 12 | 7 | 8 | 10 | 3 | 459.04 | 56.74 |
| [`_F_DrawTiledFlat`](File-src-f-finale-ml-635076109.md#function-function-f-drawtiledflat-function-f-drawtiledflat-name-src-f-finale-ml-1579450145) | `src/f_finale.ml:135` | 36 | 31 | 14 | 24 | 4 | 1283.46 | 42.4 |
| [`_F_EndPatchName`](File-src-f-finale-ml-635076109.md#function-function-f-endpatchname-inline-function-f-endpatchname-stage-src-f-finale-ml-1059232023) | `src/f_finale.ml:178` | 9 | 13 | 7 | 6 | 1 | 297.21 | 60.93 |
| [`_F_IDiv`](File-src-f-finale-ml-635076109.md#function-function-f-idiv-inline-function-f-idiv-a-b-src-f-finale-ml-1228827124) | `src/f_finale.ml:77` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_F_PatchWidth`](File-src-f-finale-ml-635076109.md#function-function-f-patchwidth-inline-function-f-patchwidth-patch-src-f-finale-ml-1468789395) | `src/f_finale.ml:103` | 4 | 3 | 3 | 2 | 1 | 146.95 | 71.29 |
| [`_F_Substr`](File-src-f-finale-ml-635076109.md#function-function-f-substr-inline-function-f-substr-s-n-src-f-finale-ml-395405038) | `src/f_finale.ml:64` | 7 | 8 | 4 | 3 | 1 | 301.85 | 63.66 |
| [`_F_u16le`](File-src-f-finale-ml-635076109.md#function-function-f-u16le-inline-function-f-u16le-b-off-src-f-finale-ml-642020952) | `src/f_finale.ml:88` | 3 | 1 | 1 | 0 | 0 | 104 | 75.33 |
| [`_F_u32le`](File-src-f-finale-ml-635076109.md#function-function-f-u32le-inline-function-f-u32le-b-off-src-f-finale-ml-1461881632) | `src/f_finale.ml:96` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`_F_UpperAscii`](File-src-f-finale-ml-635076109.md#function-function-f-upperascii-inline-function-f-upperascii-c-src-f-finale-ml-543028862) | `src/f_finale.ml:111` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_FloorAddThinkerIfPossible`](File-src-p-floor-ml-1999892698.md#function-function-flooraddthinkerifpossible-inline-function-flooraddthinkerifpossible-th-src-p-floor-ml-1440013050) | `src/p_floor.ml:39` | 3 | 2 | 2 | 1 | 1 | 81.41 | 75.94 |
| [`_FloorMakeThinker`](File-src-p-floor-ml-1999892698.md#function-function-floormakethinker-inline-function-floormakethinker-fn-src-p-floor-ml-1601910674) | `src/p_floor.ml:31` | 3 | 1 | 1 | 0 | 0 | 93.21 | 75.67 |
| [`_FloorSectorIndex`](File-src-p-floor-ml-1999892698.md#function-function-floorsectorindex-function-floorsectorindex-sec-src-p-floor-ml-786876744) | `src/p_floor.ml:64` | 10 | 10 | 5 | 5 | 2 | 294.8 | 60.22 |
| [`_FloorSoundOrg`](File-src-p-floor-ml-1999892698.md#function-function-floorsoundorg-inline-function-floorsoundorg-sec-src-p-floor-ml-859500321) | `src/p_floor.ml:56` | 4 | 3 | 2 | 1 | 1 | 79.95 | 73.27 |
| [`_FloorStartSound`](File-src-p-floor-ml-1999892698.md#function-function-floorstartsound-inline-function-floorstartsound-origin-snd-src-p-floor-ml-880687481) | `src/p_floor.ml:47` | 5 | 2 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_FloorTextureHeight`](File-src-p-floor-ml-1999892698.md#function-function-floortextureheight-inline-function-floortextureheight-tex-src-p-floor-ml-1036300135) | `src/p_floor.ml:79` | 5 | 5 | 4 | 3 | 1 | 180.09 | 68.42 |
| [`_fmt1`](File-src-m-menu-ml-331716860.md#function-function-fmt1-function-fmt1-fmt-arg-src-m-menu-ml-1120862256) | `src/m_menu.ml:236` | 32 | 26 | 10 | 10 | 2 | 1103.66 | 44.52 |
| [`_FW_ByteCopy`](File-src-f-wipe-ml-1921092045.md#function-function-fw-bytecopy-function-fw-bytecopy-dst-src-count-src-f-wipe-ml-198788964) | `src/f_wipe.ml:83` | 11 | 12 | 8 | 7 | 1 | 480.94 | 57.43 |
| [`_FW_ReadU16LE`](File-src-f-wipe-ml-1921092045.md#function-function-fw-readu16le-inline-function-fw-readu16le-buf-wordindex-src-f-wipe-ml-93044764) | `src/f_wipe.ml:57` | 6 | 6 | 4 | 3 | 1 | 309.13 | 65.05 |
| [`_FW_WriteU16LE`](File-src-f-wipe-ml-1921092045.md#function-function-fw-writeu16le-inline-function-fw-writeu16le-buf-wordindex-v-src-f-wipe-ml-1259196044) | `src/f_wipe.ml:69` | 8 | 9 | 5 | 4 | 1 | 417.17 | 61.28 |
| [`_G_ButtonIsDown`](File-src-g-game-ml-257299317.md#function-function-g-buttonisdown-inline-function-g-buttonisdown-arr-idx-src-g-game-ml-1460040395) | `src/g_game.ml:1351` | 6 | 7 | 5 | 4 | 1 | 270.51 | 65.32 |
| [`_G_CopyFrags`](File-src-g-game-ml-257299317.md#function-function-g-copyfrags-function-g-copyfrags-fr-src-g-game-ml-2080609660) | `src/g_game.ml:269` | 10 | 9 | 7 | 7 | 2 | 432.36 | 58.79 |
| [`_G_DemoReadU8`](File-src-g-game-ml-257299317.md#function-function-g-demoreadu8-inline-function-g-demoreadu8-src-g-game-ml-1324525721) | `src/g_game.ml:1011` | 10 | 7 | 4 | 3 | 1 | 235.02 | 61.05 |
| [`_G_DemoWriteU8`](File-src-g-game-ml-257299317.md#function-function-g-demowriteu8-inline-function-g-demowriteu8-v-src-g-game-ml-705867589) | `src/g_game.ml:1025` | 12 | 12 | 6 | 6 | 2 | 376.52 | 57.62 |
| [`_G_EnsureDir`](File-src-g-game-ml-257299317.md#function-function-g-ensuredir-function-g-ensuredir-path-src-g-game-ml-1022131921) | `src/g_game.ml:329` | 7 | 8 | 5 | 4 | 1 | 300.83 | 63.54 |
| [`_G_EnsureInputState`](File-src-g-game-ml-257299317.md#function-function-g-ensureinputstate-function-g-ensureinputstate-src-g-game-ml-1527451400) | `src/g_game.ml:1299` | 14 | 9 | 7 | 6 | 1 | 432.69 | 55.6 |
| [`_G_EnvString`](File-src-g-game-ml-257299317.md#function-function-g-envstring-function-g-envstring-name-src-g-game-ml-237525493) | `src/g_game.ml:283` | 7 | 7 | 6 | 5 | 1 | 317.29 | 63.24 |
| [`_G_IDiv`](File-src-g-game-ml-257299317.md#function-function-g-idiv-inline-function-g-idiv-a-b-src-g-game-ml-343808028) | `src/g_game.ml:1321` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_G_InitDevInputTweaks`](File-src-g-game-ml-257299317.md#function-function-g-initdevinputtweaks-function-g-initdevinputtweaks-src-g-game-ml-1876036374) | `src/g_game.ml:1382` | 33 | 27 | 11 | 14 | 2 | 645.97 | 45.72 |
| [`_G_KeyIndex`](File-src-g-game-ml-257299317.md#function-function-g-keyindex-inline-function-g-keyindex-k-src-g-game-ml-82910566) | `src/g_game.ml:1331` | 5 | 5 | 4 | 3 | 1 | 159.91 | 68.78 |
| [`_G_KeyIsDown`](File-src-g-game-ml-257299317.md#function-function-g-keyisdown-inline-function-g-keyisdown-k-src-g-game-ml-40266776) | `src/g_game.ml:1340` | 6 | 5 | 2 | 1 | 1 | 153.73 | 67.44 |
| [`_G_ParTimeTics`](File-src-g-game-ml-257299317.md#function-function-g-partimetics-function-g-partimetics-episode-map-src-g-game-ml-850773547) | `src/g_game.ml:245` | 17 | 12 | 12 | 13 | 2 | 650.74 | 51.85 |
| [`_G_PathBaseName`](File-src-g-game-ml-257299317.md#function-function-g-pathbasename-function-g-pathbasename-path-src-g-game-ml-643191681) | `src/g_game.ml:294` | 12 | 12 | 8 | 8 | 2 | 567.83 | 56.1 |
| [`_G_SanitizeSaveDirName`](File-src-g-game-ml-257299317.md#function-function-g-sanitizesavedirname-function-g-sanitizesavedirname-name-src-g-game-ml-702120345) | `src/g_game.ml:310` | 15 | 12 | 13 | 13 | 2 | 625.51 | 53.02 |
| [`_G_SaveDir`](File-src-g-game-ml-257299317.md#function-function-g-savedir-function-g-savedir-src-g-game-ml-1402859284) | `src/g_game.ml:339` | 12 | 14 | 7 | 6 | 1 | 573.04 | 56.2 |
| [`_G_SaveFileName`](File-src-g-game-ml-257299317.md#function-function-g-savefilename-function-g-savefilename-slot-src-g-game-ml-499797334) | `src/g_game.ml:370` | 8 | 8 | 3 | 2 | 1 | 249.12 | 63.12 |
| [`_G_ShowLoadingFrame`](File-src-g-game-ml-257299317.md#function-function-g-showloadingframe-function-g-showloadingframe-text-src-g-game-ml-1499010683) | `src/g_game.ml:654` | 10 | 5 | 4 | 3 | 1 | 179.72 | 61.86 |
| [`_HU_BuildBaseShiftMap`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-buildbaseshiftmap-function-hu-buildbaseshiftmap-src-hu-stuff-ml-944432222) | `src/hu_stuff.ml:296` | 14 | 10 | 3 | 2 | 1 | 245.27 | 57.86 |
| [`_HU_BuildEnglishShiftMap`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-buildenglishshiftmap-function-hu-buildenglishshiftmap-src-hu-stuff-ml-252506978) | `src/hu_stuff.ml:313` | 23 | 21 | 1 | 0 | 0 | 705.43 | 50.22 |
| [`_HU_BuildFrenchShiftMap`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-buildfrenchshiftmap-function-hu-buildfrenchshiftmap-src-hu-stuff-ml-502939132) | `src/hu_stuff.ml:343` | 13 | 11 | 1 | 0 | 0 | 314.93 | 58.07 |
| [`_HU_CurrentPlayer`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-currentplayer-inline-function-hu-currentplayer-src-hu-stuff-ml-849753163) | `src/hu_stuff.ml:372` | 6 | 7 | 5 | 4 | 1 | 235.23 | 65.75 |
| [`_HU_EnsureInputBuffers`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-ensureinputbuffers-function-hu-ensureinputbuffers-src-hu-stuff-ml-1659229002) | `src/hu_stuff.ml:442` | 11 | 8 | 2 | 1 | 1 | 380.74 | 58.94 |
| [`_HU_FontHeight`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-fontheight-inline-function-hu-fontheight-src-hu-stuff-ml-418488323) | `src/hu_stuff.ml:229` | 6 | 3 | 4 | 3 | 1 | 206.82 | 66.27 |
| [`_HU_InitDestinationKeys`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-initdestinationkeys-inline-function-hu-initdestinationkeys-src-hu-stuff-ml-1608886867) | `src/hu_stuff.ml:430` | 9 | 2 | 1 | 0 | 0 | 130.8 | 64.23 |
| [`_HU_ITextString`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-itextstring-inline-function-hu-itextstring-it-src-hu-stuff-ml-1703431336) | `src/hu_stuff.ml:285` | 8 | 10 | 6 | 5 | 1 | 490.66 | 60.65 |
| [`_HU_KeyCodeFromString`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-keycodefromstring-inline-function-hu-keycodefromstring-s-src-hu-stuff-ml-190628240) | `src/hu_stuff.ml:239` | 6 | 6 | 4 | 3 | 1 | 226.18 | 66 |
| [`_HU_MapTitle`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-maptitle-function-hu-maptitle-src-hu-stuff-ml-1706407490) | `src/hu_stuff.ml:408` | 17 | 15 | 15 | 22 | 3 | 824.37 | 50.72 |
| [`_HU_MPSendChatMessage`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-mpsendchatmessage-inline-function-hu-mpsendchatmessage-dest-msg-src-hu-stuff-ml-2027964392) | `src/hu_stuff.ml:265` | 8 | 10 | 5 | 4 | 1 | 323.33 | 62.05 |
| [`_HU_MPUsePacketChat`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-mpusepacketchat-inline-function-hu-mpusepacketchat-src-hu-stuff-ml-806766775) | `src/hu_stuff.ml:255` | 5 | 5 | 5 | 4 | 1 | 167.59 | 68.51 |
| [`_HU_PlayerName`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-playername-inline-function-hu-playername-idx-src-hu-stuff-ml-800349398) | `src/hu_stuff.ml:277` | 4 | 3 | 3 | 2 | 1 | 123.19 | 71.82 |
| [`_HU_PopCurrentPlayerMessage`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-popcurrentplayermessage-function-hu-popcurrentplayermessage-src-hu-stuff-ml-2102497440) | `src/hu_stuff.ml:381` | 21 | 16 | 8 | 8 | 2 | 604.88 | 50.6 |
| [`_HU_SetChatOn`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-setchaton-inline-function-hu-setchaton-v-src-hu-stuff-ml-660705073) | `src/hu_stuff.ml:218` | 8 | 5 | 3 | 2 | 1 | 169.46 | 64.29 |
| [`_HU_SetMessageOn`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-setmessageon-inline-function-hu-setmessageon-v-src-hu-stuff-ml-1389851785) | `src/hu_stuff.ml:206` | 8 | 5 | 3 | 2 | 1 | 169.46 | 64.29 |
| [`_HU_ShiftChar`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-shiftchar-inline-function-hu-shiftchar-c-src-hu-stuff-ml-545413456) | `src/hu_stuff.ml:362` | 7 | 5 | 5 | 4 | 1 | 217.13 | 64.53 |
| [`_HU_ShowMessagesEnabled`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-showmessagesenabled-inline-function-hu-showmessagesenabled-src-hu-stuff-ml-1365532107) | `src/hu_stuff.ml:248` | 4 | 3 | 2 | 1 | 1 | 92 | 72.85 |
| [`_HU_ToInt`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-toint-inline-function-hu-toint-v-fallback-src-hu-stuff-ml-787734787) | `src/hu_stuff.ml:192` | 10 | 10 | 5 | 5 | 2 | 361.93 | 59.6 |
| [`_HUlib_appendBytes`](File-src-hu-lib-ml-937975676.md#function-function-hulib-appendbytes-function-hulib-appendbytes-tl-b-src-hu-lib-ml-657512177) | `src/hu_lib.ml:324` | 6 | 4 | 4 | 3 | 1 | 197.15 | 66.42 |
| [`_HUlib_needsVal`](File-src-hu-lib-ml-937975676.md#function-function-hulib-needsval-inline-function-hulib-needsval-v-src-hu-lib-ml-1450210638) | `src/hu_lib.ml:148` | 8 | 7 | 5 | 5 | 2 | 200.16 | 63.51 |
| [`_HUlib_patchAt`](File-src-hu-lib-ml-937975676.md#function-function-hulib-patchat-inline-function-hulib-patchat-font-idx-src-hu-lib-ml-1136400172) | `src/hu_lib.ml:131` | 5 | 5 | 4 | 3 | 1 | 194.51 | 68.19 |
| [`_HUlib_patchHeight`](File-src-hu-lib-ml-937975676.md#function-function-hulib-patchheight-inline-function-hulib-patchheight-p-src-hu-lib-ml-718718788) | `src/hu_lib.ml:122` | 4 | 3 | 2 | 1 | 1 | 110.36 | 72.29 |
| [`_HUlib_patchWidth`](File-src-hu-lib-ml-937975676.md#function-function-hulib-patchwidth-inline-function-hulib-patchwidth-p-src-hu-lib-ml-338476484) | `src/hu_lib.ml:114` | 4 | 3 | 2 | 1 | 1 | 108 | 72.36 |
| [`_HUlib_refBool`](File-src-hu-lib-ml-937975676.md#function-function-hulib-refbool-inline-function-hulib-refbool-v-src-hu-lib-ml-215390286) | `src/hu_lib.ml:104` | 6 | 7 | 6 | 5 | 1 | 331.71 | 64.57 |
| [`_HUlib_toByte`](File-src-hu-lib-ml-937975676.md#function-function-hulib-tobyte-inline-function-hulib-tobyte-ch-src-hu-lib-ml-1710511449) | `src/hu_lib.ml:90` | 10 | 7 | 4 | 4 | 2 | 252.17 | 60.83 |
| [`_HUlib_upper`](File-src-hu-lib-ml-937975676.md#function-function-hulib-upper-inline-function-hulib-upper-c-src-hu-lib-ml-839689773) | `src/hu_lib.ml:140` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_I_AddKeyMap`](File-src-i-video-ml-140536292.md#function-function-i-addkeymap-inline-function-i-addkeymap-vk-doomkey-src-i-video-ml-1072998313) | `src/i_video.ml:1036` | 8 | 6 | 1 | 0 | 0 | 154.29 | 64.84 |
| [`_I_BuildBmpFromFrame`](File-src-i-video-ml-140536292.md#function-function-i-buildbmpfromframe-function-i-buildbmpfromframe-src-i-video-ml-1823323607) | `src/i_video.ml:2012` | 4 | 2 | 1 | 0 | 0 | 74.01 | 73.64 |
| [`_I_BuildBmpFromIndexedFrame`](File-src-i-video-ml-140536292.md#function-function-i-buildbmpfromindexedframe-function-i-buildbmpfromindexedframe-src-width-height-src-i-video-ml-293874954) | `src/i_video.ml:1963` | 40 | 42 | 10 | 9 | 1 | 1941.15 | 40.68 |
| [`_I_BuildHighresGameFrame`](File-src-i-video-ml-140536292.md#function-function-i-buildhighresgameframe-function-i-buildhighresgameframe-src-i-video-ml-415135431) | `src/i_video.ml:1911` | 28 | 23 | 11 | 10 | 1 | 1053.94 | 45.79 |
| [`_I_BuildNearestLogicalFrame`](File-src-i-video-ml-140536292.md#function-function-i-buildnearestlogicalframe-function-i-buildnearestlogicalframe-src-src-i-video-ml-1641656909) | `src/i_video.ml:1896` | 11 | 10 | 5 | 4 | 1 | 376.52 | 58.57 |
| [`_I_BuildPresentFrame`](File-src-i-video-ml-140536292.md#function-function-i-buildpresentframe-function-i-buildpresentframe-src-i-video-ml-216973927) | `src/i_video.ml:1946` | 10 | 7 | 8 | 7 | 1 | 383.78 | 59.02 |
| [`_I_ClampPresentScale`](File-src-i-video-ml-140536292.md#function-function-i-clamppresentscale-inline-function-i-clamppresentscale-scale-src-i-video-ml-583868346) | `src/i_video.ml:2020` | 6 | 6 | 3 | 2 | 1 | 158.46 | 67.22 |
| [`_I_ComposeHDWipeFrame`](File-src-i-video-ml-140536292.md#function-function-i-composehdwipeframe-function-i-composehdwipeframe-src-i-video-ml-1717040629) | `src/i_video.ml:773` | 42 | 38 | 17 | 25 | 4 | 1672.52 | 39.73 |
| [`_I_CreateWindow`](File-src-i-video-ml-140536292.md#function-function-i-createwindow-function-i-createwindow-src-i-video-ml-1788295197) | `src/i_video.ml:1243` | 63 | 61 | 12 | 11 | 1 | 2409.9 | 35.45 |
| [`_I_DrawGLOverlayFrame`](File-src-i-video-ml-140536292.md#function-function-i-drawgloverlayframe-function-i-drawgloverlayframe-src-i-video-ml-1222743985) | `src/i_video.ml:1846` | 41 | 49 | 23 | 37 | 3 | 2111 | 38.45 |
| [`_I_DrawLoadingIndicator`](File-src-i-video-ml-140536292.md#function-function-i-drawloadingindicator-function-i-drawloadingindicator-src-i-video-ml-771998867) | `src/i_video.ml:953` | 40 | 40 | 13 | 16 | 3 | 1553.85 | 40.96 |
| [`_I_EnsureGLOOverlay`](File-src-i-video-ml-140536292.md#function-function-i-ensureglooverlay-function-i-ensureglooverlay-src-i-video-ml-2129603369) | `src/i_video.ml:1683` | 15 | 12 | 6 | 5 | 1 | 466.37 | 54.85 |
| [`_I_EnsureScreenshotDir`](File-src-i-video-ml-140536292.md#function-function-i-ensurescreenshotdir-function-i-ensurescreenshotdir-src-i-video-ml-682815855) | `src/i_video.ml:1346` | 14 | 11 | 5 | 4 | 1 | 254.19 | 57.48 |
| [`_I_ExitProcess`](File-src-i-system-ml-1632920966.md#function-function-i-exitprocess-inline-function-i-exitprocess-code-src-i-system-ml-1403665511) | `src/i_system.ml:297` | 4 | 3 | 2 | 1 | 1 | 97.67 | 72.67 |
| [`_I_FpsTitle`](File-src-i-video-ml-140536292.md#function-function-i-fpstitle-inline-function-i-fpstitle-src-i-video-ml-2017868188) | `src/i_video.ml:900` | 5 | 4 | 2 | 1 | 1 | 146.95 | 69.31 |
| [`_I_GetTickCount`](File-src-i-system-ml-1632920966.md#function-function-i-gettickcount-inline-function-i-gettickcount-src-i-system-ml-385322314) | `src/i_system.ml:281` | 3 | 1 | 1 | 0 | 0 | 33 | 78.82 |
| [`_I_GLOverlayHighresPatches`](File-src-i-video-ml-140536292.md#function-function-i-gloverlayhighrespatches-function-i-gloverlayhighrespatches-src-i-video-ml-1547344655) | `src/i_video.ml:1796` | 32 | 35 | 16 | 18 | 3 | 1144.92 | 43.6 |
| [`_I_GLOverlayLogicalMask`](File-src-i-video-ml-140536292.md#function-function-i-gloverlaylogicalmask-function-i-gloverlaylogicalmask-src-mask-src-i-video-ml-363202421) | `src/i_video.ml:1762` | 29 | 32 | 16 | 18 | 3 | 1088.14 | 44.68 |
| [`_I_GLOverlayLogicalPixel`](File-src-i-video-ml-140536292.md#function-function-i-gloverlaylogicalpixel-function-i-gloverlaylogicalpixel-src-sx-sy-src-i-video-ml-1033436836) | `src/i_video.ml:1706` | 18 | 15 | 4 | 4 | 2 | 493.48 | 53.22 |
| [`_I_GLOverlayLogicalRect`](File-src-i-video-ml-140536292.md#function-function-i-gloverlaylogicalrect-function-i-gloverlaylogicalrect-src-x-y-w-h-src-i-video-ml-2080504189) | `src/i_video.ml:1732` | 24 | 22 | 11 | 11 | 2 | 770.32 | 48.2 |
| [`_I_HandleRendererHotkeyMessage`](File-src-i-video-ml-140536292.md#function-function-i-handlerendererhotkeymessage-function-i-handlerendererhotkeymessage-msg-wparam-lparam-src-i-video-ml-1830323407) | `src/i_video.ml:584` | 17 | 18 | 11 | 11 | 2 | 549.45 | 52.49 |
| [`_I_HDWIPE_Rand`](File-src-i-video-ml-140536292.md#function-function-i-hdwipe-rand-inline-function-i-hdwipe-rand-src-i-video-ml-2010857498) | `src/i_video.ml:675` | 5 | 3 | 1 | 0 | 0 | 118.94 | 70.09 |
| [`_I_IDiv`](File-src-i-video-ml-140536292.md#function-function-i-idiv-inline-function-i-idiv-a-b-src-i-video-ml-1144211123) | `src/i_video.ml:532` | 8 | 8 | 3 | 2 | 1 | 298.02 | 62.57 |
| [`_I_IndexedToRGBA`](File-src-i-video-ml-140536292.md#function-function-i-indexedtorgba-function-i-indexedtorgba-src-dst-width-height-src-i-video-ml-1411806957) | `src/i_video.ml:649` | 23 | 24 | 14 | 14 | 2 | 1245.45 | 46.74 |
| [`_I_InitBitmapInfo`](File-src-i-video-ml-140536292.md#function-function-i-initbitmapinfo-function-i-initbitmapinfo-src-i-video-ml-156193295) | `src/i_video.ml:1222` | 16 | 16 | 3 | 2 | 1 | 660.68 | 53.58 |
| [`_I_InitDefaultPalette`](File-src-i-video-ml-140536292.md#function-function-i-initdefaultpalette-function-i-initdefaultpalette-src-i-video-ml-923549957) | `src/i_video.ml:1194` | 9 | 7 | 3 | 2 | 1 | 244.42 | 62.06 |
| [`_I_InitKeyMap`](File-src-i-video-ml-140536292.md#function-function-i-initkeymap-function-i-initkeymap-src-i-video-ml-289741735) | `src/i_video.ml:1048` | 90 | 89 | 3 | 2 | 1 | 3925.48 | 31.8 |
| [`_I_InitPresentMetrics`](File-src-i-video-ml-140536292.md#function-function-i-initpresentmetrics-function-i-initpresentmetrics-src-i-video-ml-1806358673) | `src/i_video.ml:2029` | 23 | 20 | 2 | 1 | 1 | 525.04 | 50.98 |
| [`_I_IntToString`](File-src-i-video-ml-140536292.md#function-function-i-inttostring-function-i-inttostring-v-src-i-video-ml-2045155491) | `src/i_video.ml:869` | 28 | 26 | 14 | 22 | 2 | 935.95 | 45.74 |
| [`_I_MaybeAutoScreenshot`](File-src-i-video-ml-140536292.md#function-function-i-maybeautoscreenshot-function-i-maybeautoscreenshot-src-i-video-ml-895218267) | `src/i_video.ml:2110` | 3 | 2 | 2 | 1 | 1 | 50.72 | 77.38 |
| [`_I_MaybeAutoScreenshotFromFrame`](File-src-i-video-ml-140536292.md#function-function-i-maybeautoscreenshotfromframe-function-i-maybeautoscreenshotfromframe-src-width-height-src-i-video-ml-1933191236) | `src/i_video.ml:2119` | 3 | 2 | 2 | 1 | 1 | 96.21 | 75.44 |
| [`_I_MouseButtonsNow`](File-src-i-video-ml-140536292.md#function-function-i-mousebuttonsnow-inline-function-i-mousebuttonsnow-src-i-video-ml-1016051664) | `src/i_video.ml:2232` | 7 | 8 | 4 | 3 | 1 | 312.13 | 63.56 |
| [`_I_OverlayChangedLogicalPixels`](File-src-i-video-ml-140536292.md#function-function-i-overlaychangedlogicalpixels-function-i-overlaychangedlogicalpixels-scaled-cur-base-src-i-video-ml-271621440) | `src/i_video.ml:1484` | 27 | 26 | 13 | 18 | 4 | 1013.76 | 45.98 |
| [`_I_OverlayChangedLogicalPixelsNearest`](File-src-i-video-ml-140536292.md#function-function-i-overlaychangedlogicalpixelsnearest-function-i-overlaychangedlogicalpixelsnearest-cur-base-src-i-video-ml-1506352428) | `src/i_video.ml:1517` | 31 | 28 | 12 | 21 | 5 | 975.07 | 44.92 |
| [`_I_OverlayLogicalRectNearest`](File-src-i-video-ml-140536292.md#function-function-i-overlaylogicalrectnearest-function-i-overlaylogicalrectnearest-src-x-y-w-h-src-i-video-ml-929297707) | `src/i_video.ml:1410` | 64 | 58 | 22 | 31 | 4 | 2260.51 | 34.15 |
| [`_I_OverlayMarkedLogicalPixels`](File-src-i-video-ml-140536292.md#function-function-i-overlaymarkedlogicalpixels-function-i-overlaymarkedlogicalpixels-scaled-mask-src-i-video-ml-299470083) | `src/i_video.ml:1554` | 29 | 27 | 11 | 16 | 4 | 955.4 | 45.75 |
| [`_I_OverlayMarkedLogicalPixelsNearest`](File-src-i-video-ml-140536292.md#function-function-i-overlaymarkedlogicalpixelsnearest-function-i-overlaymarkedlogicalpixelsnearest-src-mask-src-i-video-ml-507402271) | `src/i_video.ml:1589` | 51 | 51 | 24 | 33 | 5 | 1854.86 | 36.64 |
| [`_I_OverlayPreparedHighresPatches`](File-src-i-video-ml-140536292.md#function-function-i-overlaypreparedhighrespatches-function-i-overlaypreparedhighrespatches-src-i-video-ml-1574348935) | `src/i_video.ml:1645` | 33 | 39 | 19 | 21 | 3 | 1302.61 | 42.51 |
| [`_I_OverlayScaledRect`](File-src-i-video-ml-140536292.md#function-function-i-overlayscaledrect-function-i-overlayscaledrect-scaled-x-y-w-h-src-i-video-ml-77246257) | `src/i_video.ml:1372` | 28 | 29 | 12 | 11 | 1 | 1020.91 | 45.75 |
| [`_I_PollKeyboard`](File-src-i-video-ml-140536292.md#function-function-i-pollkeyboard-function-i-pollkeyboard-src-i-video-ml-1860744661) | `src/i_video.ml:2154` | 63 | 51 | 20 | 32 | 4 | 2486.17 | 34.28 |
| [`_I_PollMouse`](File-src-i-video-ml-140536292.md#function-function-i-pollmouse-function-i-pollmouse-src-i-video-ml-1112899695) | `src/i_video.ml:2243` | 38 | 36 | 12 | 12 | 2 | 1094.03 | 42.65 |
| [`_I_PresentIndexedFrameGL`](File-src-i-video-ml-140536292.md#function-function-i-presentindexedframegl-function-i-presentindexedframegl-src-src-i-video-ml-277668719) | `src/i_video.ml:2506` | 3 | 1 | 1 | 0 | 0 | 55.35 | 77.25 |
| [`_I_PresentIndexedFrameGLSized`](File-src-i-video-ml-140536292.md#function-function-i-presentindexedframeglsized-function-i-presentindexedframeglsized-src-srcw-srch-src-i-video-ml-1127998178) | `src/i_video.ml:2481` | 20 | 28 | 15 | 16 | 2 | 1142.31 | 48.19 |
| [`_I_PumpMessages`](File-src-i-video-ml-140536292.md#function-function-i-pumpmessages-function-i-pumpmessages-src-i-video-ml-872914261) | `src/i_video.ml:1314` | 24 | 19 | 14 | 21 | 3 | 840.25 | 47.53 |
| [`_I_ReadS32`](File-src-i-video-ml-140536292.md#function-function-i-reads32-inline-function-i-reads32-buf-off-src-i-video-ml-782921126) | `src/i_video.ml:1186` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`_I_ReadU32`](File-src-i-video-ml-140536292.md#function-function-i-readu32-inline-function-i-readu32-buf-off-src-i-video-ml-1302537186) | `src/i_video.ml:1178` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`_I_ReleaseKeyboard`](File-src-i-video-ml-140536292.md#function-function-i-releasekeyboard-function-i-releasekeyboard-postevents-src-i-video-ml-79065016) | `src/i_video.ml:2126` | 20 | 17 | 8 | 10 | 3 | 607.82 | 51.05 |
| [`_I_SaveLastPresentFrame`](File-src-i-video-ml-140536292.md#function-function-i-savelastpresentframe-function-i-savelastpresentframe-src-src-i-video-ml-2042906851) | `src/i_video.ml:609` | 14 | 11 | 8 | 7 | 1 | 559.39 | 54.68 |
| [`_I_SaveLastRGBAFrameSized`](File-src-i-video-ml-140536292.md#function-function-i-savelastrgbaframesized-function-i-savelastrgbaframesized-src-width-height-src-i-video-ml-359675466) | `src/i_video.ml:630` | 11 | 11 | 8 | 7 | 1 | 515.22 | 57.22 |
| [`_I_SetCursorVisible`](File-src-i-video-ml-140536292.md#function-function-i-setcursorvisible-function-i-setcursorvisible-visible-src-i-video-ml-977480897) | `src/i_video.ml:1000` | 28 | 24 | 9 | 13 | 3 | 499.96 | 48.32 |
| [`_I_SetWindowTitle`](File-src-i-video-ml-140536292.md#function-function-i-setwindowtitle-inline-function-i-setwindowtitle-title-src-i-video-ml-1520351526) | `src/i_video.ml:544` | 9 | 10 | 4 | 3 | 1 | 235.23 | 62.04 |
| [`_I_ShouldAutoScreenshot`](File-src-i-video-ml-140536292.md#function-function-i-shouldautoscreenshot-function-i-shouldautoscreenshot-src-i-video-ml-1895743425) | `src/i_video.ml:2087` | 15 | 14 | 6 | 5 | 1 | 358.2 | 55.65 |
| [`_I_ShowFatalErrorBox`](File-src-i-system-ml-1632920966.md#function-function-i-showfatalerrorbox-inline-function-i-showfatalerrorbox-text-src-i-system-ml-775909207) | `src/i_system.ml:101` | 5 | 5 | 4 | 3 | 1 | 225.62 | 67.74 |
| [`_I_Sleep`](File-src-i-system-ml-1632920966.md#function-function-i-sleep-inline-function-i-sleep-ms-src-i-system-ml-1667207988) | `src/i_system.ml:288` | 5 | 5 | 3 | 2 | 1 | 159.91 | 68.92 |
| [`_I_StatusOverlayY`](File-src-i-video-ml-140536292.md#function-function-i-statusoverlayy-inline-function-i-statusoverlayy-src-i-video-ml-1727106364) | `src/i_video.ml:1834` | 8 | 6 | 4 | 4 | 2 | 171.3 | 64.12 |
| [`_I_StrContains`](File-src-i-system-ml-1632920966.md#function-function-i-strcontains-inline-function-i-strcontains-haystack-needle-src-i-system-ml-1630063697) | `src/i_system.ml:74` | 22 | 21 | 9 | 12 | 3 | 724.21 | 49.48 |
| [`_I_ToggleRendererHotkey`](File-src-i-video-ml-140536292.md#function-function-i-togglerendererhotkey-function-i-togglerendererhotkey-src-i-video-ml-637168247) | `src/i_video.ml:567` | 11 | 6 | 4 | 3 | 1 | 166.52 | 61.19 |
| [`_I_ToIntOr`](File-src-i-video-ml-140536292.md#function-function-i-tointor-function-i-tointor-v-fallback-src-i-video-ml-640711141) | `src/i_video.ml:512` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_I_ToLowerAscii`](File-src-i-system-ml-1632920966.md#function-function-i-tolowerascii-inline-function-i-tolowerascii-s-src-i-system-ml-1105301289) | `src/i_system.ml:59` | 10 | 9 | 5 | 5 | 2 | 383.37 | 59.42 |
| [`_I_UpdateBitmapColorTable`](File-src-i-video-ml-140536292.md#function-function-i-updatebitmapcolortable-function-i-updatebitmapcolortable-src-i-video-ml-1211744935) | `src/i_video.ml:1206` | 12 | 11 | 4 | 3 | 1 | 446.53 | 57.37 |
| [`_I_UpdateWindowTitle`](File-src-i-video-ml-140536292.md#function-function-i-updatewindowtitle-function-i-updatewindowtitle-src-i-video-ml-1047198775) | `src/i_video.ml:913` | 30 | 29 | 9 | 8 | 1 | 818.29 | 46.17 |
| [`_I_WriteAutoScreenshot`](File-src-i-video-ml-140536292.md#function-function-i-writeautoscreenshot-function-i-writeautoscreenshot-src-i-video-ml-1265666455) | `src/i_video.ml:2057` | 3 | 1 | 1 | 0 | 0 | 53.15 | 77.38 |
| [`_I_WriteAutoScreenshotFromFrame`](File-src-i-video-ml-140536292.md#function-function-i-writeautoscreenshotfromframe-function-i-writeautoscreenshotfromframe-src-width-height-src-i-video-ml-1676714690) | `src/i_video.ml:2066` | 15 | 14 | 5 | 4 | 1 | 533.84 | 54.57 |
| [`_I_WriteU16`](File-src-i-video-ml-140536292.md#function-function-i-writeu16-inline-function-i-writeu16-buf-off-value-src-i-video-ml-686588047) | `src/i_video.ml:1155` | 5 | 4 | 2 | 1 | 1 | 210.91 | 68.21 |
| [`_I_WriteU32`](File-src-i-video-ml-140536292.md#function-function-i-writeu32-inline-function-i-writeu32-buf-off-value-src-i-video-ml-432394011) | `src/i_video.ml:1166` | 7 | 6 | 2 | 1 | 1 | 355.74 | 63.43 |
| [`_idivS32`](File-src-m-fixed-ml-2129187227.md#function-function-idivs32-inline-function-idivs32-a-b-src-m-fixed-ml-633276288) | `src/m_fixed.ml:108` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_IMain_IntToString`](File-src-i-main-ml-97520758.md#function-function-imain-inttostring-function-imain-inttostring-v-src-i-main-ml-1020691259) | `src/i_main.ml:51` | 29 | 28 | 15 | 23 | 2 | 1023.3 | 45.01 |
| [`_IMain_ShowFatalError`](File-src-i-main-ml-97520758.md#function-function-imain-showfatalerror-inline-function-imain-showfatalerror-msg-src-i-main-ml-1517378773) | `src/i_main.ml:84` | 11 | 6 | 4 | 3 | 1 | 267.19 | 59.75 |
| [`_INet_DecodeToNetbuffer`](File-src-i-net-ml-1331775872.md#function-function-inet-decodetonetbuffer-function-inet-decodetonetbuffer-payload-src-i-net-ml-1487371019) | `src/i_net.ml:131` | 41 | 32 | 15 | 15 | 2 | 1925.65 | 39.8 |
| [`_INet_EncodeDoomData`](File-src-i-net-ml-1331775872.md#function-function-inet-encodedoomdata-function-inet-encodedoomdata-d-src-i-net-ml-1031919413) | `src/i_net.ml:91` | 34 | 32 | 11 | 11 | 2 | 1885.85 | 42.18 |
| [`_INet_EnsureSlotMobj`](File-src-i-net-ml-1331775872.md#function-function-inet-ensureslotmobj-function-inet-ensureslotmobj-slot-src-i-net-ml-2012147207) | `src/i_net.ml:197` | 37 | 33 | 23 | 27 | 3 | 1845.8 | 39.83 |
| [`_INet_ReadI32LE`](File-src-i-net-ml-1331775872.md#function-function-inet-readi32le-inline-function-inet-readi32le-buf-off-src-i-net-ml-180213182) | `src/i_net.ml:78` | 9 | 8 | 2 | 1 | 1 | 425.73 | 60.51 |
| [`_INet_RemoveSlotMobj`](File-src-i-net-ml-1331775872.md#function-function-inet-removeslotmobj-inline-function-inet-removeslotmobj-slot-src-i-net-ml-1814716378) | `src/i_net.ml:242` | 11 | 11 | 8 | 7 | 1 | 452.78 | 57.61 |
| [`_INet_SlotIsActive`](File-src-i-net-ml-1331775872.md#function-function-inet-slotisactive-function-inet-slotisactive-activeslots-slot-src-i-net-ml-661025110) | `src/i_net.ml:184` | 9 | 8 | 4 | 4 | 2 | 281.76 | 61.49 |
| [`_INet_SyncRuntimeFromPlatform`](File-src-i-net-ml-1331775872.md#function-function-inet-syncruntimefromplatform-function-inet-syncruntimefromplatform-src-i-net-ml-193128259) | `src/i_net.ml:256` | 94 | 99 | 44 | 75 | 5 | 4030.05 | 25.8 |
| [`_INet_ToInt`](File-src-i-net-ml-1331775872.md#function-function-inet-toint-function-inet-toint-v-fallback-src-i-net-ml-1700000845) | `src/i_net.ml:45` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_INet_WriteI32LE`](File-src-i-net-ml-1331775872.md#function-function-inet-writei32le-inline-function-inet-writei32le-buf-off-v-src-i-net-ml-1245780518) | `src/i_net.ml:65` | 8 | 7 | 2 | 1 | 1 | 402.36 | 61.79 |
| [`_InitActiveCeilings`](File-src-p-ceilng-ml-226654252.md#function-function-initactiveceilings-function-initactiveceilings-src-p-ceilng-ml-1911881191) | `src/p_ceilng.ml:33` | 10 | 8 | 3 | 2 | 1 | 199.04 | 61.69 |
| [`_InitActivePlats`](File-src-p-plats-ml-866228534.md#function-function-initactiveplats-function-initactiveplats-src-p-plats-ml-405742737) | `src/p_plats.ml:35` | 10 | 8 | 3 | 2 | 1 | 199.04 | 61.69 |
| [`_InitButtonList`](File-src-p-switch-ml-925070734.md#function-function-initbuttonlist-function-initbuttonlist-src-p-switch-ml-1198639841) | `src/p_switch.ml:112` | 10 | 8 | 3 | 2 | 1 | 274.02 | 60.71 |
| [`_InitItemRespawnQueue`](File-src-p-mobj-ml-1335564114.md#function-function-inititemrespawnqueue-inline-function-inititemrespawnqueue-src-p-mobj-ml-2053385418) | `src/p_mobj.ml:221` | 12 | 8 | 3 | 3 | 2 | 278.63 | 58.94 |
| [`_IS_CalcStereoVolumes`](File-src-i-sound-ml-33806980.md#function-function-is-calcstereovolumes-inline-function-is-calcstereovolumes-vol127-sep-src-i-sound-ml-1429092061) | `src/i_sound.ml:392` | 10 | 8 | 1 | 0 | 0 | 451.79 | 59.46 |
| [`_IS_Clamp`](File-src-i-sound-ml-33806980.md#function-function-is-clamp-inline-function-is-clamp-v-lo-hi-src-i-sound-ml-130111648) | `src/i_sound.ml:370` | 6 | 6 | 3 | 2 | 1 | 175.14 | 66.91 |
| [`_IS_ClampS16`](File-src-i-sound-ml-33806980.md#function-function-is-clamps16-inline-function-is-clamps16-v-src-i-sound-ml-1254441162) | `src/i_sound.ml:917` | 6 | 6 | 3 | 2 | 1 | 164.23 | 67.11 |
| [`_IS_EnsureSfxCacheSize`](File-src-i-sound-ml-33806980.md#function-function-is-ensuresfxcachesize-function-is-ensuresfxcachesize-src-i-sound-ml-1646299263) | `src/i_sound.ml:501` | 29 | 23 | 16 | 18 | 2 | 1041.24 | 44.82 |
| [`_IS_EnumIndex`](File-src-i-sound-ml-33806980.md#function-function-is-enumindex-inline-function-is-enumindex-v-fallback-src-i-sound-ml-704483180) | `src/i_sound.ml:483` | 6 | 6 | 3 | 2 | 1 | 175.14 | 66.91 |
| [`_IS_FindChannelByHandle`](File-src-i-sound-ml-33806980.md#function-function-is-findchannelbyhandle-inline-function-is-findchannelbyhandle-handle-src-i-sound-ml-366046998) | `src/i_sound.ml:735` | 12 | 9 | 5 | 5 | 2 | 359.49 | 57.89 |
| [`_IS_FindChannelForNewSound`](File-src-i-sound-ml-33806980.md#function-function-is-findchannelfornewsound-function-is-findchannelfornewsound-sid-src-i-sound-ml-340540009) | `src/i_sound.ml:681` | 26 | 18 | 8 | 12 | 3 | 660.82 | 48.31 |
| [`_IS_IDiv`](File-src-i-system-ml-1632920966.md#function-function-is-idiv-inline-function-is-idiv-a-b-src-i-system-ml-490967277) | `src/i_system.ml:49` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_IS_InitMixScaleTable`](File-src-i-sound-ml-33806980.md#function-function-is-initmixscaletable-inline-function-is-initmixscaletable-src-i-sound-ml-1771016840) | `src/i_sound.ml:559` | 15 | 12 | 5 | 5 | 2 | 470.46 | 54.96 |
| [`_IS_InitStepTable`](File-src-i-sound-ml-33806980.md#function-function-is-initsteptable-inline-function-is-initsteptable-src-i-sound-ml-895429972) | `src/i_sound.ml:540` | 14 | 13 | 5 | 5 | 2 | 510.07 | 55.37 |
| [`_IS_IsSeq`](File-src-i-sound-ml-33806980.md#function-function-is-isseq-inline-function-is-isseq-v-src-i-sound-ml-1805780770) | `src/i_sound.ml:325` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_IS_LoadSfxData`](File-src-i-sound-ml-33806980.md#function-function-is-loadsfxdata-function-is-loadsfxdata-sid-src-i-sound-ml-1914014727) | `src/i_sound.ml:627` | 28 | 30 | 16 | 15 | 1 | 1429.47 | 44.19 |
| [`_IS_MapMusChannel`](File-src-i-sound-ml-33806980.md#function-function-is-mapmuschannel-function-is-mapmuschannel-mchan-src-i-sound-ml-472440054) | `src/i_sound.ml:1141` | 18 | 16 | 6 | 6 | 2 | 583.46 | 52.44 |
| [`_IS_MidiAllNotesOff`](File-src-i-sound-ml-33806980.md#function-function-is-midiallnotesoff-inline-function-is-midiallnotesoff-src-i-sound-ml-251425236) | `src/i_sound.ml:1086` | 9 | 7 | 3 | 2 | 1 | 227.55 | 62.28 |
| [`_IS_MidiInit`](File-src-i-sound-ml-33806980.md#function-function-is-midiinit-inline-function-is-midiinit-src-i-sound-ml-219419256) | `src/i_sound.ml:1014` | 14 | 11 | 4 | 3 | 1 | 339 | 56.74 |
| [`_IS_MidiMsg2`](File-src-i-sound-ml-33806980.md#function-function-is-midimsg2-inline-function-is-midimsg2-status-data1-src-i-sound-ml-1816811683) | `src/i_sound.ml:1048` | 14 | 11 | 6 | 6 | 2 | 514.32 | 55.21 |
| [`_IS_MidiMsg3`](File-src-i-sound-ml-33806980.md#function-function-is-midimsg3-inline-function-is-midimsg3-status-data1-data2-src-i-sound-ml-593021253) | `src/i_sound.ml:1068` | 15 | 12 | 6 | 6 | 2 | 648.04 | 53.85 |
| [`_IS_MidiShutdown`](File-src-i-sound-ml-33806980.md#function-function-is-midishutdown-inline-function-is-midishutdown-src-i-sound-ml-867293716) | `src/i_sound.ml:1034` | 7 | 6 | 2 | 1 | 1 | 130.8 | 66.48 |
| [`_IS_MixToBytes`](File-src-i-sound-ml-33806980.md#function-function-is-mixtobytes-function-is-mixtobytes-outb-src-i-sound-ml-1538706845) | `src/i_sound.ml:927` | 49 | 44 | 14 | 25 | 5 | 2253.1 | 37.77 |
| [`_IS_MusCtrlToMidi`](File-src-i-sound-ml-33806980.md#function-function-is-musctrltomidi-inline-function-is-musctrltomidi-ctrl-src-i-sound-ml-259076753) | `src/i_sound.ml:1118` | 19 | 32 | 16 | 15 | 1 | 825.06 | 49.53 |
| [`_IS_MusicFindSlotIndex`](File-src-i-sound-ml-33806980.md#function-function-is-musicfindslotindex-inline-function-is-musicfindslotindex-handle-src-i-sound-ml-831800532) | `src/i_sound.ml:1202` | 13 | 10 | 6 | 6 | 2 | 428.77 | 56.46 |
| [`_IS_MusicProcessSlice`](File-src-i-sound-ml-33806980.md#function-function-is-musicprocessslice-function-is-musicprocessslice-src-i-sound-ml-1179866863) | `src/i_sound.ml:1326` | 102 | 81 | 25 | 57 | 5 | 3488.18 | 28.02 |
| [`_IS_MusicResetRuntime`](File-src-i-sound-ml-33806980.md#function-function-is-musicresetruntime-function-is-musicresetruntime-src-i-sound-ml-1958437135) | `src/i_sound.ml:1099` | 13 | 11 | 1 | 0 | 0 | 236.35 | 58.95 |
| [`_IS_MusicRestart`](File-src-i-sound-ml-33806980.md#function-function-is-musicrestart-inline-function-is-musicrestart-src-i-sound-ml-2100408098) | `src/i_sound.ml:1452` | 10 | 8 | 1 | 0 | 0 | 120 | 63.49 |
| [`_IS_MusicRunTicks`](File-src-i-sound-ml-33806980.md#function-function-is-musicrunticks-function-is-musicrunticks-ticks-src-i-sound-ml-1917726887) | `src/i_sound.ml:1466` | 41 | 35 | 16 | 22 | 3 | 1074.4 | 41.44 |
| [`_IS_MusicScale7`](File-src-i-sound-ml-33806980.md#function-function-is-musicscale7-inline-function-is-musicscale7-v-src-i-sound-ml-2053645158) | `src/i_sound.ml:1169` | 4 | 2 | 1 | 0 | 0 | 138.97 | 71.73 |
| [`_IS_MusicSetSlotPlaying`](File-src-i-sound-ml-33806980.md#function-function-is-musicsetslotplaying-inline-function-is-musicsetslotplaying-handle-playing-looping-src-i-sound-ml-637775986) | `src/i_sound.ml:1223` | 8 | 7 | 2 | 1 | 1 | 229.25 | 63.5 |
| [`_IS_MusicStartInternal`](File-src-i-sound-ml-33806980.md#function-function-is-musicstartinternal-function-is-musicstartinternal-handle-data-looping-src-i-sound-ml-1831176697) | `src/i_sound.ml:1279` | 37 | 39 | 12 | 11 | 1 | 1268.24 | 42.45 |
| [`_IS_MusicStopInternal`](File-src-i-sound-ml-33806980.md#function-function-is-musicstopinternal-function-is-musicstopinternal-updateslot-src-i-sound-ml-502586674) | `src/i_sound.ml:1236` | 31 | 27 | 4 | 3 | 1 | 501.48 | 48.02 |
| [`_IS_MusicTicker`](File-src-i-sound-ml-33806980.md#function-function-is-musicticker-function-is-musicticker-src-i-sound-ml-1155815333) | `src/i_sound.ml:1521` | 21 | 21 | 7 | 6 | 1 | 524.62 | 51.17 |
| [`_IS_NormalizeVolume127`](File-src-i-sound-ml-33806980.md#function-function-is-normalizevolume127-inline-function-is-normalizevolume127-v-src-i-sound-ml-1315243494) | `src/i_sound.ml:380` | 7 | 4 | 2 | 1 | 1 | 155.59 | 65.95 |
| [`_IS_PitchToStep`](File-src-i-sound-ml-33806980.md#function-function-is-pitchtostep-inline-function-is-pitchtostep-pitch-rate-src-i-sound-ml-254383688) | `src/i_sound.ml:718` | 10 | 10 | 3 | 2 | 1 | 370 | 59.8 |
| [`_IS_ReadMusVarLen`](File-src-i-sound-ml-33806980.md#function-function-is-readmusvarlen-inline-function-is-readmusvarlen-data-posref-src-i-sound-ml-1089546639) | `src/i_sound.ml:1182` | 14 | 14 | 7 | 7 | 2 | 606.7 | 54.57 |
| [`_IS_ReadU16`](File-src-i-sound-ml-33806980.md#function-function-is-readu16-inline-function-is-readu16-buf-off-src-i-sound-ml-1838309350) | `src/i_sound.ml:451` | 6 | 7 | 5 | 4 | 1 | 332.84 | 64.69 |
| [`_IS_ReadU32`](File-src-i-sound-ml-33806980.md#function-function-is-readu32-inline-function-is-readu32-buf-off-src-i-sound-ml-92642286) | `src/i_sound.ml:462` | 6 | 7 | 5 | 4 | 1 | 455.79 | 63.74 |
| [`_IS_ReadU64`](File-src-i-sound-ml-33806980.md#function-function-is-readu64-inline-function-is-readu64-buf-off-src-i-sound-ml-1628985466) | `src/i_sound.ml:473` | 5 | 3 | 1 | 0 | 0 | 150.12 | 69.38 |
| [`_IS_ResetChannels`](File-src-i-sound-ml-33806980.md#function-function-is-resetchannels-function-is-resetchannels-src-i-sound-ml-610140537) | `src/i_sound.ml:579` | 24 | 22 | 1 | 0 | 0 | 538.69 | 50.63 |
| [`_IS_SetChannelVolumes`](File-src-i-sound-ml-33806980.md#function-function-is-setchannelvolumes-inline-function-is-setchannelvolumes-slot-vol-sep-src-i-sound-ml-1214155151) | `src/i_sound.ml:610` | 10 | 9 | 3 | 2 | 1 | 561.53 | 58.53 |
| [`_IS_ShouldSingleInstance`](File-src-i-sound-ml-33806980.md#function-function-is-shouldsingleinstance-inline-function-is-shouldsingleinstance-sid-src-i-sound-ml-282989998) | `src/i_sound.ml:667` | 9 | 7 | 1 | 0 | 0 | 476.08 | 60.3 |
| [`_IS_StopAllSfx`](File-src-i-sound-ml-33806980.md#function-function-is-stopallsfx-inline-function-is-stopallsfx-src-i-sound-ml-707566290) | `src/i_sound.ml:752` | 8 | 6 | 4 | 3 | 1 | 201.74 | 63.62 |
| [`_IS_TickMs`](File-src-i-sound-ml-33806980.md#function-function-is-tickms-inline-function-is-tickms-src-i-sound-ml-1472512848) | `src/i_sound.ml:492` | 6 | 3 | 2 | 1 | 1 | 112 | 68.41 |
| [`_IS_ToInt`](File-src-i-sound-ml-33806980.md#function-function-is-toint-inline-function-is-toint-v-fallback-src-i-sound-ml-1303043068) | `src/i_sound.ml:335` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_IS_WaveFindFreeBuffer`](File-src-i-sound-ml-33806980.md#function-function-is-wavefindfreebuffer-inline-function-is-wavefindfreebuffer-src-i-sound-ml-1764939618) | `src/i_sound.ml:899` | 12 | 9 | 5 | 5 | 2 | 291.48 | 58.53 |
| [`_IS_WaveFormat`](File-src-i-sound-ml-33806980.md#function-function-is-waveformat-inline-function-is-waveformat-src-i-sound-ml-1269905398) | `src/i_sound.ml:763` | 11 | 9 | 1 | 0 | 0 | 343.87 | 59.39 |
| [`_IS_WaveInit`](File-src-i-sound-ml-33806980.md#function-function-is-waveinit-function-is-waveinit-src-i-sound-ml-576213747) | `src/i_sound.ml:777` | 43 | 38 | 9 | 14 | 3 | 1405.73 | 41.12 |
| [`_IS_WaveIsDone`](File-src-i-sound-ml-33806980.md#function-function-is-waveisdone-inline-function-is-waveisdone-wb-src-i-sound-ml-232526613) | `src/i_sound.ml:869` | 9 | 10 | 4 | 3 | 1 | 388.42 | 60.52 |
| [`_IS_WaveRefresh`](File-src-i-sound-ml-33806980.md#function-function-is-waverefresh-inline-function-is-waverefresh-src-i-sound-ml-667749524) | `src/i_sound.ml:883` | 12 | 9 | 6 | 6 | 2 | 333.67 | 57.98 |
| [`_IS_WaveShutdown`](File-src-i-sound-ml-33806980.md#function-function-is-waveshutdown-function-is-waveshutdown-src-i-sound-ml-814081871) | `src/i_sound.ml:832` | 28 | 22 | 10 | 21 | 4 | 856.83 | 46.55 |
| [`_IS_WaveSubmitMixedBuffer`](File-src-i-sound-ml-33806980.md#function-function-is-wavesubmitmixedbuffer-function-is-wavesubmitmixedbuffer-src-i-sound-ml-1858092271) | `src/i_sound.ml:990` | 17 | 19 | 8 | 7 | 1 | 639.53 | 52.44 |
| [`_IS_WriteU16`](File-src-i-sound-ml-33806980.md#function-function-is-writeu16-inline-function-is-writeu16-buf-off-value-src-i-sound-ml-1693067415) | `src/i_sound.ml:410` | 7 | 7 | 3 | 2 | 1 | 306.05 | 63.76 |
| [`_IS_WriteU32`](File-src-i-sound-ml-33806980.md#function-function-is-writeu32-inline-function-is-writeu32-buf-off-value-src-i-sound-ml-624633563) | `src/i_sound.ml:423` | 9 | 9 | 3 | 2 | 1 | 459.04 | 60.14 |
| [`_IS_WriteU64`](File-src-i-sound-ml-33806980.md#function-function-is-writeu64-inline-function-is-writeu64-buf-off-value-src-i-sound-ml-1780302845) | `src/i_sound.ml:438` | 8 | 7 | 2 | 1 | 1 | 306.05 | 62.63 |
| [`_ISnd_IDiv`](File-src-i-sound-ml-33806980.md#function-function-isnd-idiv-inline-function-isnd-idiv-a-b-src-i-sound-ml-2058769245) | `src/i_sound.ml:356` | 8 | 8 | 3 | 2 | 1 | 305.53 | 62.5 |
| [`_LineIndex`](File-src-p-map-ml-882556686.md#function-function-lineindex-function-lineindex-ld-src-p-map-ml-351072229) | `src/p_map.ml:107` | 10 | 10 | 5 | 5 | 2 | 294.8 | 60.22 |
| [`_M_ApplyDefaultKV`](File-src-m-misc-ml-906836777.md#function-function-m-applydefaultkv-function-m-applydefaultkv-key-val-src-m-misc-ml-1975610468) | `src/m_misc.ml:271` | 104 | 84 | 41 | 40 | 1 | 2647.44 | 26.52 |
| [`_M_GetDefaultFilePath`](File-src-m-misc-ml-906836777.md#function-function-m-getdefaultfilepath-function-m-getdefaultfilepath-src-m-misc-ml-738690622) | `src/m_misc.ml:381` | 13 | 8 | 6 | 5 | 1 | 307.16 | 57.48 |
| [`_M_IsSpaceByte`](File-src-m-misc-ml-906836777.md#function-function-m-isspacebyte-inline-function-m-isspacebyte-c-src-m-misc-ml-739644970) | `src/m_misc.ml:169` | 3 | 1 | 1 | 0 | 0 | 57.36 | 77.14 |
| [`_M_MakeShotName`](File-src-m-misc-ml-906836777.md#function-function-m-makeshotname-inline-function-m-makeshotname-i-src-m-misc-ml-1590530684) | `src/m_misc.ml:87` | 6 | 4 | 1 | 0 | 0 | 217.13 | 66.53 |
| [`_M_ParentDirExists`](File-src-m-misc-ml-906836777.md#function-function-m-parentdirexists-function-m-parentdirexists-path-src-m-misc-ml-2098313141) | `src/m_misc.ml:427` | 16 | 19 | 9 | 9 | 2 | 665.24 | 52.76 |
| [`_M_ParseDefaultLine`](File-src-m-misc-ml-906836777.md#function-function-m-parsedefaultline-function-m-parsedefaultline-line-src-m-misc-ml-860847524) | `src/m_misc.ml:400` | 20 | 22 | 12 | 11 | 1 | 922.09 | 49.25 |
| [`_M_ParseInt`](File-src-m-misc-ml-906836777.md#function-function-m-parseint-function-m-parseint-s0-src-m-misc-ml-2064530559) | `src/m_misc.ml:198` | 34 | 29 | 19 | 25 | 3 | 1457.65 | 41.88 |
| [`_M_ParseText`](File-src-m-misc-ml-906836777.md#function-function-m-parsetext-inline-function-m-parsetext-s0-src-m-misc-ml-1253081344) | `src/m_misc.ml:239` | 10 | 9 | 6 | 5 | 1 | 445 | 58.84 |
| [`_M_patchWidth`](File-src-m-misc-ml-906836777.md#function-function-m-patchwidth-inline-function-m-patchwidth-patch-src-m-misc-ml-806404199) | `src/m_misc.ml:48` | 4 | 3 | 2 | 1 | 1 | 108 | 72.36 |
| [`_M_QuoteText`](File-src-m-misc-ml-906836777.md#function-function-m-quotetext-function-m-quotetext-s0-src-m-misc-ml-621705853) | `src/m_misc.ml:253` | 13 | 11 | 3 | 2 | 1 | 440.92 | 56.78 |
| [`_M_StrCaseEq`](File-src-m-argv-ml-728984635.md#function-function-m-strcaseeq-function-m-strcaseeq-a-b-src-m-argv-ml-874642975) | `src/m_argv.ml:68` | 16 | 14 | 6 | 6 | 2 | 509.48 | 53.97 |
| [`_M_ToLowerAscii`](File-src-m-argv-ml-728984635.md#function-function-m-tolowerascii-inline-function-m-tolowerascii-c-src-m-argv-ml-1007597400) | `src/m_argv.ml:59` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_M_Trim`](File-src-m-misc-ml-906836777.md#function-function-m-trim-function-m-trim-s0-src-m-misc-ml-1192847775) | `src/m_misc.ml:176` | 15 | 14 | 8 | 7 | 1 | 579.61 | 53.92 |
| [`_M_u16le`](File-src-m-misc-ml-906836777.md#function-function-m-u16le-inline-function-m-u16le-b-off-src-m-misc-ml-2125663046) | `src/m_misc.ml:41` | 3 | 1 | 1 | 0 | 0 | 104 | 75.33 |
| [`_M_UpperAscii`](File-src-m-misc-ml-906836777.md#function-function-m-upperascii-inline-function-m-upperascii-c-src-m-misc-ml-1035694538) | `src/m_misc.ml:56` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_M_WritePCXfile`](File-src-m-misc-ml-906836777.md#function-function-m-writepcxfile-function-m-writepcxfile-filename-data-width-height-palette-src-m-misc-ml-1243487923) | `src/m_misc.ml:101` | 48 | 48 | 11 | 11 | 2 | 2002.39 | 38.73 |
| [`_M_WriteU16LE`](File-src-m-misc-ml-906836777.md#function-function-m-writeu16le-inline-function-m-writeu16le-buf-off-value-src-m-misc-ml-325152432) | `src/m_misc.ml:78` | 5 | 4 | 2 | 1 | 1 | 210.91 | 68.21 |
| [`_makeClip`](File-src-r-bsp-ml-998402465.md#function-function-makeclip-inline-function-makeclip-first-last-src-r-bsp-ml-655213319) | `src/r_bsp.ml:221` | 3 | 1 | 1 | 0 | 0 | 58.81 | 77.07 |
| [`_makeDrawseg`](File-src-r-bsp-ml-998402465.md#function-function-makedrawseg-inline-function-makedrawseg-src-r-bsp-ml-1260812187) | `src/r_bsp.ml:212` | 3 | 1 | 1 | 0 | 0 | 117.62 | 74.96 |
| [`_makeVisSprite`](File-src-r-things-ml-545677447.md#function-function-makevissprite-inline-function-makevissprite-src-r-things-ml-1444950729) | `src/r_things.ml:213` | 3 | 1 | 1 | 0 | 0 | 138.38 | 74.47 |
| [`_MapAbs`](File-src-p-map-ml-882556686.md#function-function-mapabs-inline-function-mapabs-x-src-p-map-ml-1045468126) | `src/p_map.ml:66` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_Menu`](File-src-m-menu-ml-331716860.md#function-function-menu-inline-function-menu-numitems-prevmenu-menuitems-routine-x-y-laston-src-m-menu-ml-1005320209) | `src/m_menu.ml:328` | 3 | 1 | 1 | 0 | 0 | 148 | 74.26 |
| [`_MI`](File-src-m-menu-ml-331716860.md#function-function-mi-inline-function-mi-status-name-routine-alphakey-src-m-menu-ml-570326876) | `src/m_menu.ml:315` | 3 | 1 | 1 | 0 | 0 | 92.51 | 75.69 |
| [`_min`](File-src-m-menu-ml-331716860.md#function-function-min-inline-function-min-a-b-src-m-menu-ml-358407869) | `src/m_menu.ml:62` | 4 | 3 | 2 | 1 | 1 | 77.71 | 73.36 |
| [`_MMENU_ArgValue`](File-src-m-menu-ml-331716860.md#function-function-mmenu-argvalue-inline-function-mmenu-argvalue-flag-src-m-menu-ml-1611760198) | `src/m_menu.ml:616` | 7 | 7 | 4 | 3 | 1 | 247.76 | 64.26 |
| [`_MMENU_BuildMainMenu`](File-src-m-menu-ml-331716860.md#function-function-mmenu-buildmainmenu-inline-function-mmenu-buildmainmenu-src-m-menu-ml-103862462) | `src/m_menu.ml:655` | 11 | 1 | 1 | 0 | 0 | 433.82 | 58.68 |
| [`_MMENU_BuildMPHostMenu`](File-src-m-menu-ml-331716860.md#function-function-mmenu-buildmphostmenu-inline-function-mmenu-buildmphostmenu-src-m-menu-ml-1633640382) | `src/m_menu.ml:679` | 12 | 1 | 1 | 0 | 0 | 475.97 | 57.58 |
| [`_MMENU_BuildMPJoinMenu`](File-src-m-menu-ml-331716860.md#function-function-mmenu-buildmpjoinmenu-inline-function-mmenu-buildmpjoinmenu-src-m-menu-ml-1301529418) | `src/m_menu.ml:694` | 7 | 1 | 1 | 0 | 0 | 181.52 | 65.61 |
| [`_MMENU_BuildMPNameMenu`](File-src-m-menu-ml-331716860.md#function-function-mmenu-buildmpnamemenu-inline-function-mmenu-buildmpnamemenu-src-m-menu-ml-758348128) | `src/m_menu.ml:704` | 6 | 1 | 1 | 0 | 0 | 126.71 | 68.17 |
| [`_MMENU_BuildMultiplayerMenu`](File-src-m-menu-ml-331716860.md#function-function-mmenu-buildmultiplayermenu-inline-function-mmenu-buildmultiplayermenu-src-m-menu-ml-171654532) | `src/m_menu.ml:669` | 7 | 1 | 1 | 0 | 0 | 178.41 | 65.67 |
| [`_MMENU_ClampCursor`](File-src-m-menu-ml-331716860.md#function-function-mmenu-clampcursor-function-mmenu-clampcursor-src-m-menu-ml-274006721) | `src/m_menu.ml:133` | 17 | 16 | 8 | 9 | 2 | 427.74 | 53.66 |
| [`_MMENU_ClampInt`](File-src-m-menu-ml-331716860.md#function-function-mmenu-clampint-function-mmenu-clampint-v-lo-hi-src-m-menu-ml-1570737203) | `src/m_menu.ml:1118` | 13 | 12 | 4 | 3 | 1 | 311.85 | 57.7 |
| [`_MMENU_DrawPatchScale2`](File-src-m-menu-ml-331716860.md#function-function-mmenu-drawpatchscale2-function-mmenu-drawpatchscale2-x-y-scrn-patch-src-m-menu-ml-113698428) | `src/m_menu.ml:2266` | 58 | 60 | 28 | 84 | 8 | 3322.08 | 33.11 |
| [`_MMENU_FontLumpName`](File-src-m-menu-ml-331716860.md#function-function-mmenu-fontlumpname-function-mmenu-fontlumpname-code-src-m-menu-ml-1914178570) | `src/m_menu.ml:2354` | 6 | 4 | 1 | 0 | 0 | 166.8 | 67.33 |
| [`_MMENU_HandleMPJoinHostEditKey`](File-src-m-menu-ml-331716860.md#function-function-mmenu-handlempjoinhosteditkey-function-mmenu-handlempjoinhosteditkey-ch-src-m-menu-ml-1114582660) | `src/m_menu.ml:2490` | 32 | 26 | 9 | 9 | 2 | 733.36 | 45.89 |
| [`_MMENU_HandleMPNameEditKey`](File-src-m-menu-ml-331716860.md#function-function-mmenu-handlempnameeditkey-function-mmenu-handlempnameeditkey-ch-src-m-menu-ml-667069920) | `src/m_menu.ml:2452` | 30 | 24 | 9 | 9 | 2 | 680.41 | 46.73 |
| [`_MMENU_IDiv`](File-src-m-menu-ml-331716860.md#function-function-mmenu-idiv-inline-function-mmenu-idiv-a-b-src-m-menu-ml-606884753) | `src/m_menu.ml:90` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_MMENU_ItemCount`](File-src-m-menu-ml-331716860.md#function-function-mmenu-itemcount-inline-function-mmenu-itemcount-menu-src-m-menu-ml-189103027) | `src/m_menu.ml:119` | 10 | 13 | 8 | 7 | 1 | 461.25 | 58.46 |
| [`_MMENU_MPCLIInt`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpcliint-function-mmenu-mpcliint-flag-fallback-lo-hi-src-m-menu-ml-1708011663) | `src/m_menu.ml:1656` | 8 | 9 | 5 | 4 | 1 | 377.83 | 61.58 |
| [`_MMENU_MPCLIReportFailure`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpclireportfailure-function-mmenu-mpclireportfailure-role-reason-src-m-menu-ml-621008915) | `src/m_menu.ml:1703` | 4 | 2 | 1 | 0 | 0 | 116 | 72.28 |
| [`_MMENU_MPFailureCode`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpfailurecode-function-mmenu-mpfailurecode-reason-src-m-menu-ml-1520400221) | `src/m_menu.ml:644` | 8 | 10 | 7 | 6 | 1 | 366.13 | 61.41 |
| [`_MMENU_MPIsNumericIPv4`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpisnumericipv4-function-mmenu-mpisnumericipv4-host-src-m-menu-ml-1883711495) | `src/m_menu.ml:1668` | 30 | 30 | 15 | 24 | 3 | 1033.15 | 44.66 |
| [`_MMENU_MPLimitText`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mplimittext-inline-function-mmenu-mplimittext-v-src-m-menu-ml-375606862) | `src/m_menu.ml:1156` | 5 | 5 | 3 | 2 | 1 | 126.71 | 69.63 |
| [`_MMENU_MPModeName`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpmodename-inline-function-mmenu-mpmodename-mode-src-m-menu-ml-2113524257) | `src/m_menu.ml:1135` | 4 | 3 | 2 | 1 | 1 | 72.34 | 73.58 |
| [`_MMENU_MPSkillName`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpskillname-inline-function-mmenu-mpskillname-skill-src-m-menu-ml-2050386415) | `src/m_menu.ml:1143` | 9 | 12 | 6 | 5 | 1 | 296.13 | 61.07 |
| [`_MMENU_MPStartHostConfigured`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpstarthostconfigured-function-mmenu-mpstarthostconfigured-interactive-src-m-menu-ml-1516290055) | `src/m_menu.ml:1520` | 36 | 36 | 12 | 14 | 2 | 1387.79 | 42.43 |
| [`_MMENU_MPStartJoinConfigured`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpstartjoinconfigured-function-mmenu-mpstartjoinconfigured-interactive-src-m-menu-ml-1110635315) | `src/m_menu.ml:1595` | 44 | 50 | 20 | 33 | 3 | 2012.78 | 38.33 |
| [`_MMENU_MPStatus`](File-src-m-menu-ml-331716860.md#function-function-mmenu-mpstatus-function-mmenu-mpstatus-line-src-m-menu-ml-916149265) | `src/m_menu.ml:627` | 12 | 9 | 7 | 7 | 2 | 391.38 | 57.36 |
| [`_MMENU_ParseMapToken`](File-src-m-menu-ml-331716860.md#function-function-mmenu-parsemaptoken-function-mmenu-parsemaptoken-maptoken-src-m-menu-ml-1318664868) | `src/m_menu.ml:1201` | 16 | 12 | 13 | 14 | 2 | 755.71 | 51.83 |
| [`_MMENU_ParseUnsignedTail`](File-src-m-menu-ml-331716860.md#function-function-mmenu-parseunsignedtail-function-mmenu-parseunsignedtail-s0-startidx-src-m-menu-ml-636341473) | `src/m_menu.ml:1180` | 17 | 18 | 8 | 8 | 2 | 601.38 | 52.62 |
| [`_MMENU_RequestStatusBarRefresh`](File-src-m-menu-ml-331716860.md#function-function-mmenu-requeststatusbarrefresh-inline-function-mmenu-requeststatusbarrefresh-src-m-menu-ml-317677160) | `src/m_menu.ml:2171` | 6 | 3 | 2 | 1 | 1 | 85.95 | 69.21 |
| [`_MMENU_RevealLogicalMenuText`](File-src-m-menu-ml-331716860.md#function-function-mmenu-reveallogicalmenutext-function-mmenu-reveallogicalmenutext-x-y-string-src-m-menu-ml-1032447971) | `src/m_menu.ml:2407` | 8 | 10 | 6 | 5 | 1 | 465.12 | 60.81 |
| [`_MMENU_StartMultiplayerGame`](File-src-m-menu-ml-331716860.md#function-function-mmenu-startmultiplayergame-function-mmenu-startmultiplayergame-mode-skill-maptoken-localslot-src-m-menu-ml-1977011423) | `src/m_menu.ml:1225` | 64 | 57 | 13 | 17 | 2 | 2080.43 | 35.62 |
| [`_MMENU_StringWidthMenuSized`](File-src-m-menu-ml-331716860.md#function-function-mmenu-stringwidthmenusized-function-mmenu-stringwidthmenusized-string-src-m-menu-ml-1636142688) | `src/m_menu.ml:2332` | 18 | 14 | 6 | 7 | 2 | 503.8 | 52.89 |
| [`_MMENU_SyncMPBuffers`](File-src-m-menu-ml-331716860.md#function-function-mmenu-syncmpbuffers-function-mmenu-syncmpbuffers-src-m-menu-ml-145668449) | `src/m_menu.ml:1298` | 18 | 20 | 5 | 4 | 1 | 647.71 | 52.26 |
| [`_MMENU_ToInt`](File-src-m-menu-ml-331716860.md#function-function-mmenu-toint-function-mmenu-toint-v-fallback-src-m-menu-ml-155298819) | `src/m_menu.ml:101` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_MMENU_ToUpperAsciiString`](File-src-m-menu-ml-331716860.md#function-function-mmenu-toupperasciistring-function-mmenu-toupperasciistring-s0-src-m-menu-ml-553282274) | `src/m_menu.ml:1165` | 10 | 9 | 5 | 5 | 2 | 378.33 | 59.46 |
| [`_MMENU_WriteMenuSizedOrText`](File-src-m-menu-ml-331716860.md#function-function-mmenu-writemenusizedortext-function-mmenu-writemenusizedortext-x-y-string-src-m-menu-ml-1802088113) | `src/m_menu.ml:2422` | 7 | 4 | 2 | 1 | 1 | 156.28 | 65.93 |
| [`_MMENU_WriteTextMenuSized`](File-src-m-menu-ml-331716860.md#function-function-mmenu-writetextmenusized-function-mmenu-writetextmenusized-x-y-string-src-m-menu-ml-1517109187) | `src/m_menu.ml:2366` | 32 | 28 | 9 | 13 | 2 | 1046.43 | 44.81 |
| [`_MMISC_IDiv`](File-src-m-misc-ml-906836777.md#function-function-mmisc-idiv-inline-function-mmisc-idiv-a-b-src-m-misc-ml-817267228) | `src/m_misc.ml:66` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_Mobj_Default`](File-src-p-mobj-ml-1335564114.md#function-function-mobj-default-function-mobj-default-src-p-mobj-ml-986177093) | `src/p_mobj.ml:397` | 23 | 1 | 1 | 0 | 0 | 362.08 | 52.24 |
| [`_MP_Clamp`](File-src-mp-state-ml-130741680.md#function-function-mp-clamp-function-mp-clamp-v-lo-hi-src-mp-state-ml-1981874647) | `src/mp_state.ml:101` | 13 | 12 | 4 | 3 | 1 | 311.85 | 57.7 |
| [`_MP_HASH_ToHex8`](File-src-mp-fnv1a-ml-1881283455.md#function-function-mp-hash-tohex8-function-mp-hash-tohex8-v-src-mp-fnv1a-ml-102400390) | `src/mp_fnv1a.ml:36` | 11 | 8 | 2 | 1 | 1 | 272.05 | 59.97 |
| [`_MP_HASH_U32`](File-src-mp-fnv1a-ml-1881283455.md#function-function-mp-hash-u32-inline-function-mp-hash-u32-v-src-mp-fnv1a-ml-445265867) | `src/mp_fnv1a.ml:28` | 4 | 3 | 2 | 1 | 1 | 96 | 72.72 |
| [`_MP_IsAllowedNameByte`](File-src-mp-state-ml-130741680.md#function-function-mp-isallowednamebyte-inline-function-mp-isallowednamebyte-c-src-mp-state-ml-704203991) | `src/mp_state.ml:159` | 7 | 9 | 10 | 9 | 1 | 310.23 | 62.77 |
| [`_MP_StrContains`](File-src-mp-state-ml-130741680.md#function-function-mp-strcontains-function-mp-strcontains-haystack-needle-src-mp-state-ml-1169203444) | `src/mp_state.ml:133` | 22 | 21 | 9 | 12 | 3 | 713.7 | 49.53 |
| [`_MP_ToInt`](File-src-mp-state-ml-130741680.md#function-function-mp-toint-function-mp-toint-v-fallback-src-mp-state-ml-1726606425) | `src/mp_state.ml:81` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_MP_ToUpperAscii`](File-src-mp-state-ml-130741680.md#function-function-mp-toupperascii-function-mp-toupperascii-s-src-mp-state-ml-1810119656) | `src/mp_state.ml:118` | 10 | 9 | 5 | 5 | 2 | 378.33 | 59.46 |
| [`_MP_TwoDigits`](File-src-mp-state-ml-130741680.md#function-function-mp-twodigits-inline-function-mp-twodigits-v-src-mp-state-ml-1844174734) | `src/mp_state.ml:211` | 10 | 10 | 3 | 2 | 1 | 376.47 | 59.75 |
| [`_MPPlatform_AllocHostPeerId`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-allochostpeerid-function-mpplatform-allochostpeerid-src-mp-platform-ml-1625463265) | `src/mp_platform.ml:1250` | 17 | 16 | 6 | 9 | 3 | 390.14 | 54.21 |
| [`_MPPlatform_AllocHostSlot`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-allochostslot-inline-function-mpplatform-allochostslot-src-mp-platform-ml-689460722) | `src/mp_platform.ml:956` | 8 | 6 | 3 | 3 | 2 | 144.43 | 64.77 |
| [`_MPPlatform_ClientHandlePacket`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-clienthandlepacket-function-mpplatform-clienthandlepacket-payload-peerip-peerport-src-mp-platform-ml-619432863) | `src/mp_platform.ml:1486` | 54 | 60 | 27 | 38 | 4 | 2745.16 | 34.5 |
| [`_MPPlatform_CloseSocketOnly`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-closesocketonly-inline-function-mpplatform-closesocketonly-src-mp-platform-ml-2027985830) | `src/mp_platform.ml:804` | 7 | 4 | 3 | 2 | 1 | 151.27 | 65.9 |
| [`_MPPlatform_EnsurePeerTelemetry`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-ensurepeertelemetry-inline-function-mpplatform-ensurepeertelemetry-p-src-mp-platform-ml-1491768638) | `src/mp_platform.ml:417` | 12 | 19 | 10 | 9 | 1 | 756.03 | 54.96 |
| [`_MPPlatform_ExpireHostPeers`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-expirehostpeers-function-mpplatform-expirehostpeers-src-mp-platform-ml-401773489) | `src/mp_platform.ml:1547` | 44 | 35 | 12 | 21 | 4 | 1679.08 | 39.95 |
| [`_MPPlatform_FindHostPeerBySlot`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-findhostpeerbyslot-inline-function-mpplatform-findhostpeerbyslot-slot-src-mp-platform-ml-1037496932) | `src/mp_platform.ml:968` | 9 | 7 | 4 | 4 | 2 | 279.69 | 61.51 |
| [`_MPPlatform_FindHostPeerIndex`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-findhostpeerindex-inline-function-mpplatform-findhostpeerindex-ip-port-src-mp-platform-ml-173892600) | `src/mp_platform.ml:913` | 12 | 9 | 6 | 6 | 2 | 398.51 | 57.44 |
| [`_MPPlatform_GameChecksum16`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-gamechecksum16-inline-function-mpplatform-gamechecksum16-payload-n-src-mp-platform-ml-93569600) | `src/mp_platform.ml:1184` | 14 | 14 | 5 | 4 | 1 | 589.37 | 54.93 |
| [`_MPPlatform_HostHandlePacket`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-hosthandlepacket-function-mpplatform-hosthandlepacket-payload-peerip-peerport-src-mp-platform-ml-1800989103) | `src/mp_platform.ml:1384` | 85 | 79 | 35 | 56 | 5 | 4126.21 | 27.89 |
| [`_MPPlatform_HostSendAccept`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-hostsendaccept-function-mpplatform-hostsendaccept-ip-port-slot-peerid-src-mp-platform-ml-1235214134) | `src/mp_platform.ml:1360` | 18 | 5 | 2 | 1 | 1 | 479.27 | 53.58 |
| [`_MPPlatform_HostSendDeny`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-hostsenddeny-inline-function-mpplatform-hostsenddeny-ip-port-reasoncode-reasontext-includehash-src-mp-platform-ml-1227839112) | `src/mp_platform.ml:1348` | 5 | 4 | 2 | 1 | 1 | 241.48 | 67.8 |
| [`_MPPlatform_InitClientSlotNames`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-initclientslotnames-function-mpplatform-initclientslotnames-localname-src-mp-platform-ml-1112044133) | `src/mp_platform.ml:565` | 22 | 20 | 8 | 9 | 2 | 598.26 | 50.2 |
| [`_MPPlatform_IsGamePacket`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-isgamepacket-inline-function-mpplatform-isgamepacket-payload-src-mp-platform-ml-254231958) | `src/mp_platform.ml:1174` | 5 | 5 | 3 | 2 | 1 | 376.52 | 66.31 |
| [`_MPPlatform_IsPeerIdUsed`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-ispeeridused-inline-function-mpplatform-ispeeridused-pid-src-mp-platform-ml-120553493) | `src/mp_platform.ml:929` | 10 | 9 | 5 | 5 | 2 | 325 | 59.93 |
| [`_MPPlatform_IsSlotUsed`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-isslotused-inline-function-mpplatform-isslotused-slot-src-mp-platform-ml-2065359466) | `src/mp_platform.ml:943` | 10 | 9 | 6 | 6 | 2 | 351.03 | 59.56 |
| [`_MPPlatform_IsWouldBlockError`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-iswouldblockerror-inline-function-mpplatform-iswouldblockerror-v-src-mp-platform-ml-1165526184) | `src/mp_platform.ml:843` | 5 | 4 | 2 | 1 | 1 | 158.32 | 69.08 |
| [`_MPPlatform_LogEvent`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-logevent-function-mpplatform-logevent-line-src-mp-platform-ml-472513635) | `src/mp_platform.ml:199` | 22 | 16 | 9 | 12 | 3 | 691.12 | 49.62 |
| [`_MPPlatform_NormalizeIPv4`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-normalizeipv4-function-mpplatform-normalizeipv4-value-src-mp-platform-ml-313055694) | `src/mp_platform.ml:881` | 27 | 30 | 13 | 20 | 3 | 1089.25 | 45.76 |
| [`_MPPlatform_PeerIngame`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-peeringame-inline-function-mpplatform-peeringame-p-src-mp-platform-ml-1100446582) | `src/mp_platform.ml:406` | 7 | 9 | 5 | 4 | 1 | 325.03 | 63.3 |
| [`_MPPlatform_PopGamePacket`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-popgamepacket-function-mpplatform-popgamepacket-src-mp-platform-ml-1385292127) | `src/mp_platform.ml:1116` | 50 | 51 | 19 | 21 | 2 | 1607.27 | 37.93 |
| [`_MPPlatform_PushConsoleMessage`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-pushconsolemessage-inline-function-mpplatform-pushconsolemessage-msg-src-mp-platform-ml-1236327033) | `src/mp_platform.ml:459` | 10 | 12 | 7 | 6 | 1 | 441.12 | 58.73 |
| [`_MPPlatform_QueueDepth`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-queuedepth-inline-function-mpplatform-queuedepth-src-mp-platform-ml-1788212296) | `src/mp_platform.ml:432` | 10 | 12 | 5 | 4 | 1 | 343.65 | 59.76 |
| [`_MPPlatform_QueueEnsureCapacity`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-queueensurecapacity-function-mpplatform-queueensurecapacity-required-src-mp-platform-ml-230080746) | `src/mp_platform.ml:981` | 25 | 24 | 8 | 8 | 2 | 834.34 | 47.97 |
| [`_MPPlatform_QueueGamePacket`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-queuegamepacket-function-mpplatform-queuegamepacket-node-payload-src-mp-platform-ml-1599016619) | `src/mp_platform.ml:1014` | 90 | 89 | 34 | 51 | 3 | 3019.46 | 28.43 |
| [`_MPPlatform_RemoveHostPeerByIndex`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-removehostpeerbyindex-function-mpplatform-removehostpeerbyindex-idx-withmessage-src-mp-platform-ml-821021945) | `src/mp_platform.ml:1307` | 33 | 29 | 12 | 18 | 3 | 1191.39 | 43.72 |
| [`_MPPlatform_SanitizeField`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-sanitizefield-inline-function-mpplatform-sanitizefield-s0-src-mp-platform-ml-627939849) | `src/mp_platform.ml:794` | 7 | 6 | 2 | 1 | 1 | 265.93 | 64.32 |
| [`_MPPlatform_SendFields`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-sendfields-inline-function-mpplatform-sendfields-sock-ip-port-fields-src-mp-platform-ml-1919123749) | `src/mp_platform.ml:855` | 22 | 20 | 11 | 12 | 2 | 1212.6 | 47.64 |
| [`_MPPlatform_SetError`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-seterror-inline-function-mpplatform-seterror-msg-src-mp-platform-ml-2118061025) | `src/mp_platform.ml:1868` | 8 | 4 | 2 | 1 | 1 | 110.36 | 65.73 |
| [`_MPPlatform_SetNonBlocking`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-setnonblocking-inline-function-mpplatform-setnonblocking-sock-enabled-src-mp-platform-ml-1934402101) | `src/mp_platform.ml:816` | 6 | 5 | 2 | 1 | 1 | 197.15 | 66.69 |
| [`_MPPlatform_SetRecvTimeout`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-setrecvtimeout-inline-function-mpplatform-setrecvtimeout-sock-timeoutms-src-mp-platform-ml-2114262669) | `src/mp_platform.ml:827` | 12 | 12 | 3 | 2 | 1 | 585.41 | 56.68 |
| [`_MPPlatform_SetStatus`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-setstatus-inline-function-mpplatform-setstatus-msg-src-mp-platform-ml-926219131) | `src/mp_platform.ml:446` | 9 | 5 | 2 | 1 | 1 | 129.27 | 64.13 |
| [`_MPPlatform_ToBytesCopy`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-tobytescopy-inline-function-mpplatform-tobytescopy-v-src-mp-platform-ml-22597820) | `src/mp_platform.ml:386` | 16 | 11 | 5 | 5 | 2 | 432.43 | 54.6 |
| [`_MPPlatform_ToInt`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-toint-inline-function-mpplatform-toint-v-fallback-src-mp-platform-ml-1762823210) | `src/mp_platform.ml:356` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_MPPlatform_UnwrapGamePayload`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-unwrapgamepayload-function-mpplatform-unwrapgamepayload-packet-src-mp-platform-ml-328914251) | `src/mp_platform.ml:1203` | 16 | 17 | 7 | 6 | 1 | 787.56 | 52.51 |
| [`_MPPlatform_UpsertHostPeer`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-upserthostpeer-function-mpplatform-upserthostpeer-ip-port-name-src-mp-platform-ml-1875797152) | `src/mp_platform.ml:1274` | 25 | 24 | 8 | 8 | 2 | 1335.36 | 46.54 |
| [`_MPPlatform_WaitPulse`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-waitpulse-inline-function-mpplatform-waitpulse-src-mp-platform-ml-2058951914) | `src/mp_platform.ml:373` | 9 | 8 | 5 | 7 | 2 | 240 | 61.85 |
| [`_MPPlatform_WrapGamePayload`](File-src-mp-platform-ml-1361006310.md#function-function-mpplatform-wrapgamepayload-function-mpplatform-wrapgamepayload-localslot-payload-src-mp-platform-ml-595602410) | `src/mp_platform.ml:1225` | 22 | 21 | 5 | 4 | 1 | 894.29 | 49.38 |
| [`_nameTo8`](File-src-r-data-ml-1686270288.md#function-function-nameto8-inline-function-nameto8-name-src-r-data-ml-1531125689) | `src/r_data.ml:191` | 10 | 8 | 3 | 2 | 1 | 215.49 | 61.44 |
| [`_P_AddThinkerIfPossible`](File-src-p-lights-ml-1710096069.md#function-function-p-addthinkerifpossible-inline-function-p-addthinkerifpossible-th-src-p-lights-ml-604158161) | `src/p_lights.ml:38` | 5 | 2 | 2 | 1 | 1 | 81.41 | 71.11 |
| [`_P_FineIndexFromAngle`](File-src-p-user-ml-1917117091.md#function-function-p-fineindexfromangle-inline-function-p-fineindexfromangle-angle-src-p-user-ml-1985083742) | `src/p_user.ml:48` | 9 | 8 | 6 | 5 | 1 | 354.63 | 60.52 |
| [`_P_MakeThinker`](File-src-p-lights-ml-1710096069.md#function-function-p-makethinker-inline-function-p-makethinker-acp1-src-p-lights-ml-1189809076) | `src/p_lights.ml:29` | 3 | 1 | 1 | 0 | 0 | 93.21 | 75.67 |
| [`_P_NumLines`](File-src-p-spec-ml-402508231.md#function-function-p-numlines-inline-function-p-numlines-src-p-spec-ml-1677013619) | `src/p_spec.ml:1167` | 6 | 7 | 4 | 3 | 1 | 212.67 | 66.19 |
| [`_P_NumSectors`](File-src-p-spec-ml-402508231.md#function-function-p-numsectors-inline-function-p-numsectors-src-p-spec-ml-56787207) | `src/p_spec.ml:1158` | 6 | 7 | 4 | 3 | 1 | 212.67 | 66.19 |
| [`_patchHeight`](File-src-m-menu-ml-331716860.md#function-function-patchheight-inline-function-patchheight-patch-src-m-menu-ml-1642623044) | `src/m_menu.ml:165` | 6 | 6 | 3 | 2 | 1 | 232.99 | 66.05 |
| [`_patchWidth`](File-src-m-menu-ml-331716860.md#function-function-patchwidth-inline-function-patchwidth-patch-src-m-menu-ml-388748754) | `src/m_menu.ml:155` | 6 | 6 | 3 | 2 | 1 | 230.32 | 66.08 |
| [`_PE_Abs`](File-src-p-enemy-ml-1875479956.md#function-function-pe-abs-inline-function-pe-abs-v-src-p-enemy-ml-1514184290) | `src/p_enemy.ml:103` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_PE_DropHiddenTarget`](File-src-p-enemy-ml-1875479956.md#function-function-pe-drophiddentarget-function-pe-drophiddentarget-actor-src-p-enemy-ml-2076430188) | `src/p_enemy.ml:164` | 18 | 15 | 7 | 6 | 1 | 765.71 | 51.48 |
| [`_PE_HasOtherAliveType`](File-src-p-enemy-ml-1875479956.md#function-function-pe-hasotheralivetype-function-pe-hasotheralivetype-exceptmo-motype-src-p-enemy-ml-1474425678) | `src/p_enemy.ml:220` | 11 | 7 | 7 | 7 | 2 | 317.07 | 58.83 |
| [`_PE_IDiv`](File-src-p-enemy-ml-1875479956.md#function-function-pe-idiv-inline-function-pe-idiv-a-b-src-p-enemy-ml-1356503379) | `src/p_enemy.ml:113` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_PE_IsNoTargetMobj`](File-src-p-enemy-ml-1875479956.md#function-function-pe-isnotargetmobj-inline-function-pe-isnotargetmobj-mo-src-p-enemy-ml-2006283620) | `src/p_enemy.ml:155` | 4 | 3 | 3 | 2 | 1 | 165 | 70.94 |
| [`_PE_JunkLineWithTag`](File-src-p-enemy-ml-1875479956.md#function-function-pe-junklinewithtag-inline-function-pe-junklinewithtag-tag-src-p-enemy-ml-34489016) | `src/p_enemy.ml:133` | 3 | 1 | 1 | 0 | 0 | 208 | 73.23 |
| [`_PE_PainShootSkull`](File-src-p-enemy-ml-1875479956.md#function-function-pe-painshootskull-function-pe-painshootskull-actor-angle-src-p-enemy-ml-839800143) | `src/p_enemy.ml:1216` | 29 | 30 | 15 | 17 | 3 | 1652.68 | 43.55 |
| [`_PE_ResolveThinkerMobj`](File-src-p-enemy-ml-1875479956.md#function-function-pe-resolvethinkermobj-inline-function-pe-resolvethinkermobj-cur-src-p-enemy-ml-522950588) | `src/p_enemy.ml:140` | 11 | 12 | 8 | 8 | 2 | 380.74 | 58.14 |
| [`_PE_StartSound`](File-src-p-enemy-ml-1875479956.md#function-function-pe-startsound-inline-function-pe-startsound-origin-sfx-src-p-enemy-ml-1162699243) | `src/p_enemy.ml:124` | 5 | 2 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_PI_AmmoIndex`](File-src-p-inter-ml-1430401638.md#function-function-pi-ammoindex-inline-function-pi-ammoindex-a-src-p-inter-ml-1956067429) | `src/p_inter.ml:145` | 11 | 13 | 8 | 8 | 2 | 343.13 | 58.45 |
| [`_PI_CardIndex`](File-src-p-inter-ml-1430401638.md#function-function-pi-cardindex-function-pi-cardindex-card-src-p-inter-ml-769988169) | `src/p_inter.ml:202` | 22 | 26 | 16 | 18 | 2 | 829.81 | 48.13 |
| [`_PI_CommitTouchedPlayer`](File-src-p-inter-ml-1430401638.md#function-function-pi-committouchedplayer-inline-function-pi-committouchedplayer-toucher-player-pidx-src-p-inter-ml-79010260) | `src/p_inter.ml:332` | 9 | 6 | 6 | 5 | 1 | 312.48 | 60.91 |
| [`_PI_DiagHitEnabled`](File-src-p-inter-ml-1430401638.md#function-function-pi-diaghitenabled-function-pi-diaghitenabled-src-p-inter-ml-850063649) | `src/p_inter.ml:113` | 16 | 12 | 6 | 6 | 2 | 262.37 | 55.99 |
| [`_PI_DiagHitLog`](File-src-p-inter-ml-1430401638.md#function-function-pi-diaghitlog-inline-function-pi-diaghitlog-msg-src-p-inter-ml-1791149711) | `src/p_inter.ml:133` | 8 | 6 | 4 | 3 | 1 | 202.12 | 63.62 |
| [`_PI_HasCard`](File-src-p-inter-ml-1430401638.md#function-function-pi-hascard-inline-function-pi-hascard-player-card-src-p-inter-ml-306351473) | `src/p_inter.ml:231` | 7 | 8 | 6 | 5 | 1 | 365 | 62.82 |
| [`_PI_HasWeapon`](File-src-p-inter-ml-1430401638.md#function-function-pi-hasweapon-inline-function-pi-hasweapon-player-weapon-src-p-inter-ml-965541659) | `src/p_inter.ml:265` | 8 | 10 | 6 | 5 | 1 | 386.43 | 61.38 |
| [`_PI_IDiv`](File-src-p-inter-ml-1430401638.md#function-function-pi-idiv-inline-function-pi-idiv-a-b-src-p-inter-ml-1369898529) | `src/p_inter.ml:243` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_PI_IsNoTargetPlayerMobj`](File-src-p-inter-ml-1430401638.md#function-function-pi-isnotargetplayermobj-inline-function-pi-isnotargetplayermobj-mo-src-p-inter-ml-414517660) | `src/p_inter.ml:40` | 4 | 3 | 3 | 2 | 1 | 165 | 70.94 |
| [`_PI_PlayerIndex`](File-src-p-inter-ml-1430401638.md#function-function-pi-playerindex-function-pi-playerindex-player-src-p-inter-ml-269232360) | `src/p_inter.ml:277` | 19 | 18 | 10 | 13 | 3 | 645 | 51.09 |
| [`_PI_PlayerIndexForThing`](File-src-p-inter-ml-1430401638.md#function-function-pi-playerindexforthing-function-pi-playerindexforthing-player-thing-src-p-inter-ml-111769594) | `src/p_inter.ml:301` | 25 | 21 | 14 | 17 | 3 | 865.91 | 47.05 |
| [`_PI_PowerIndex`](File-src-p-inter-ml-1430401638.md#function-function-pi-powerindex-function-pi-powerindex-pw-src-p-inter-ml-260356228) | `src/p_inter.ml:180` | 18 | 22 | 13 | 14 | 2 | 610 | 51.37 |
| [`_PI_WeaponIndex`](File-src-p-inter-ml-1430401638.md#function-function-pi-weaponindex-function-pi-weaponindex-w-src-p-inter-ml-2132387580) | `src/p_inter.ml:160` | 16 | 23 | 13 | 13 | 2 | 600.13 | 52.53 |
| [`_PI_WeaponInfo`](File-src-p-inter-ml-1430401638.md#function-function-pi-weaponinfo-inline-function-pi-weaponinfo-weapon-src-p-inter-ml-658160330) | `src/p_inter.ml:253` | 7 | 8 | 4 | 3 | 1 | 238.42 | 64.38 |
| [`_PlatFrontSector`](File-src-p-plats-ml-866228534.md#function-function-platfrontsector-inline-function-platfrontsector-line-src-p-plats-ml-451480228) | `src/p_plats.ml:99` | 9 | 12 | 9 | 8 | 1 | 500.5 | 59.07 |
| [`_PlatMakeThinker`](File-src-p-plats-ml-866228534.md#function-function-platmakethinker-inline-function-platmakethinker-fn-src-p-plats-ml-1317720746) | `src/p_plats.ml:50` | 3 | 1 | 1 | 0 | 0 | 93.21 | 75.67 |
| [`_PlatSetSlot`](File-src-p-plats-ml-866228534.md#function-function-platsetslot-function-platsetslot-idx-v-src-p-plats-ml-3122846) | `src/p_plats.ml:76` | 18 | 15 | 7 | 7 | 2 | 477.02 | 52.92 |
| [`_PlatSoundOrg`](File-src-p-plats-ml-866228534.md#function-function-platsoundorg-inline-function-platsoundorg-sec-src-p-plats-ml-740712103) | `src/p_plats.ml:67` | 4 | 3 | 2 | 1 | 1 | 79.95 | 73.27 |
| [`_PlatStartSound`](File-src-p-plats-ml-866228534.md#function-function-platstartsound-inline-function-platstartsound-origin-snd-src-p-plats-ml-401524451) | `src/p_plats.ml:58` | 5 | 2 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_PM_AllocNetUid`](File-src-p-mobj-ml-1335564114.md#function-function-pm-allocnetuid-inline-function-pm-allocnetuid-src-p-mobj-ml-2031785198) | `src/p_mobj.ml:386` | 8 | 8 | 3 | 2 | 1 | 186.91 | 63.99 |
| [`_PM_DiagMovePrint`](File-src-p-map-ml-882556686.md#function-function-pm-diagmoveprint-inline-function-pm-diagmoveprint-msg-src-p-map-ml-43323167) | `src/p_map.ml:203` | 5 | 5 | 3 | 2 | 1 | 120 | 69.79 |
| [`_PM_EnsurePlayerSlots`](File-src-p-mobj-ml-1335564114.md#function-function-pm-ensureplayerslots-function-pm-ensureplayerslots-src-p-mobj-ml-1267695689) | `src/p_mobj.ml:771` | 24 | 16 | 9 | 10 | 2 | 738.62 | 48.6 |
| [`_PM_IDiv`](File-src-p-mobj-ml-1335564114.md#function-function-pm-idiv-inline-function-pm-idiv-a-b-src-p-mobj-ml-659972091) | `src/p_mobj.ml:326` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_PM_MobjTypeIndex`](File-src-p-mobj-ml-1335564114.md#function-function-pm-mobjtypeindex-function-pm-mobjtypeindex-v-src-p-mobj-ml-1639907493) | `src/p_mobj.ml:355` | 23 | 23 | 10 | 11 | 2 | 808.99 | 48.59 |
| [`_PM_RegisterThinker`](File-src-p-mobj-ml-1335564114.md#function-function-pm-registerthinker-inline-function-pm-registerthinker-node-owner-src-p-mobj-ml-1632776455) | `src/p_mobj.ml:239` | 29 | 26 | 8 | 14 | 3 | 832.33 | 46.58 |
| [`_PM_ResolveThinkerId`](File-src-p-mobj-ml-1335564114.md#function-function-pm-resolvethinkerid-inline-function-pm-resolvethinkerid-node-src-p-mobj-ml-1967113310) | `src/p_mobj.ml:289` | 13 | 8 | 4 | 6 | 3 | 286.73 | 57.96 |
| [`_PM_ResolveThinkerOwner`](File-src-p-mobj-ml-1335564114.md#function-function-pm-resolvethinkerowner-inline-function-pm-resolvethinkerowner-node-src-p-mobj-ml-1191935754) | `src/p_mobj.ml:273` | 12 | 9 | 4 | 6 | 3 | 280.54 | 58.78 |
| [`_PM_StateSpriteIndex`](File-src-p-mobj-ml-1335564114.md#function-function-pm-statespriteindex-inline-function-pm-statespriteindex-spr-src-p-mobj-ml-944309971) | `src/p_mobj.ml:425` | 13 | 12 | 6 | 9 | 3 | 343.65 | 57.14 |
| [`_PM_ToInt`](File-src-p-mobj-ml-1335564114.md#function-function-pm-toint-inline-function-pm-toint-v-fallback-src-p-mobj-ml-1910346478) | `src/p_mobj.ml:337` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_PM_TryMoveDiagEnabled`](File-src-p-map-ml-882556686.md#function-function-pm-trymovediagenabled-inline-function-pm-trymovediagenabled-src-p-map-ml-2127547906) | `src/p_map.ml:183` | 16 | 12 | 6 | 6 | 2 | 270.51 | 55.9 |
| [`_PM_UnregisterThinker`](File-src-p-mobj-ml-1335564114.md#function-function-pm-unregisterthinker-inline-function-pm-unregisterthinker-node-src-p-mobj-ml-257279822) | `src/p_mobj.ml:306` | 15 | 12 | 4 | 6 | 3 | 338.43 | 56.1 |
| [`_PM_UseDiagEnabled`](File-src-p-map-ml-882556686.md#function-function-pm-usediagenabled-inline-function-pm-usediagenabled-src-p-map-ml-334061992) | `src/p_map.ml:211` | 16 | 12 | 6 | 6 | 2 | 270.51 | 55.9 |
| [`_PM_UseDiagLog`](File-src-p-map-ml-882556686.md#function-function-pm-usediaglog-inline-function-pm-usediaglog-msg-src-p-map-ml-348721383) | `src/p_map.ml:231` | 9 | 8 | 5 | 4 | 1 | 262.33 | 61.57 |
| [`_PMAP_IDiv`](File-src-p-map-ml-882556686.md#function-function-pmap-idiv-inline-function-pmap-idiv-a-b-src-p-map-ml-43107763) | `src/p_map.ml:75` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_PMAP_S32`](File-src-p-map-ml-882556686.md#function-function-pmap-s32-inline-function-pmap-s32-v-src-p-map-ml-2120541908) | `src/p_map.ml:85` | 6 | 6 | 3 | 2 | 1 | 171.3 | 66.98 |
| [`_PMU_DiagUseEnabled`](File-src-p-maputl-ml-227665141.md#function-function-pmu-diaguseenabled-inline-function-pmu-diaguseenabled-src-p-maputl-ml-297974505) | `src/p_maputl.ml:70` | 16 | 12 | 6 | 6 | 2 | 270.51 | 55.9 |
| [`_PMU_DiagUseLog`](File-src-p-maputl-ml-227665141.md#function-function-pmu-diaguselog-inline-function-pmu-diaguselog-msg-src-p-maputl-ml-1252893942) | `src/p_maputl.ml:90` | 8 | 6 | 4 | 3 | 1 | 202.12 | 63.62 |
| [`_PMU_HasSignBit`](File-src-p-maputl-ml-227665141.md#function-function-pmu-hassignbit-inline-function-pmu-hassignbit-v-src-p-maputl-ml-2124986427) | `src/p_maputl.ml:46` | 3 | 1 | 1 | 0 | 0 | 70.31 | 76.52 |
| [`_PMU_IsSeq`](File-src-p-maputl-ml-227665141.md#function-function-pmu-isseq-inline-function-pmu-isseq-v-src-p-maputl-ml-545167715) | `src/p_maputl.ml:53` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_PMU_U32`](File-src-p-maputl-ml-227665141.md#function-function-pmu-u32-inline-function-pmu-u32-v-src-p-maputl-ml-1445805573) | `src/p_maputl.ml:38` | 4 | 3 | 2 | 1 | 1 | 96 | 72.72 |
| [`_PS_AmmoIndex`](File-src-p-pspr-ml-844718747.md#function-function-ps-ammoindex-inline-function-ps-ammoindex-a-src-p-pspr-ml-1571193666) | `src/p_pspr.ml:173` | 11 | 13 | 8 | 8 | 2 | 343.13 | 58.45 |
| [`_PS_DiagFireEnabled`](File-src-p-pspr-ml-844718747.md#function-function-ps-diagfireenabled-function-ps-diagfireenabled-src-p-pspr-ml-891650688) | `src/p_pspr.ml:120` | 16 | 12 | 6 | 6 | 2 | 262.37 | 55.99 |
| [`_PS_DiagFireLog`](File-src-p-pspr-ml-844718747.md#function-function-ps-diagfirelog-inline-function-ps-diagfirelog-msg-src-p-pspr-ml-459771176) | `src/p_pspr.ml:140` | 9 | 8 | 5 | 4 | 1 | 262.33 | 61.57 |
| [`_PS_EnsureRuntimeArrays`](File-src-p-setup-ml-2057900615.md#function-function-ps-ensureruntimearrays-function-ps-ensureruntimearrays-src-p-setup-ml-1823432558) | `src/p_setup.ml:211` | 26 | 19 | 9 | 10 | 2 | 726.22 | 47.89 |
| [`_PS_GetAmmoCount`](File-src-p-pspr-ml-844718747.md#function-function-ps-getammocount-inline-function-ps-getammocount-player-ammotype-src-p-pspr-ml-1139952068) | `src/p_pspr.ml:217` | 11 | 15 | 7 | 6 | 1 | 455 | 57.73 |
| [`_PS_HasWeapon`](File-src-p-pspr-ml-844718747.md#function-function-ps-hasweapon-inline-function-ps-hasweapon-player-weapontype-src-p-pspr-ml-331169760) | `src/p_pspr.ml:249` | 9 | 12 | 6 | 5 | 1 | 372.92 | 60.37 |
| [`_PS_I16LE`](File-src-p-setup-ml-2057900615.md#function-function-ps-i16le-inline-function-ps-i16le-b-off-src-p-setup-ml-1902709660) | `src/p_setup.ml:56` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`_PS_IDiv`](File-src-p-spec-ml-402508231.md#function-function-ps-idiv-inline-function-ps-idiv-a-b-src-p-spec-ml-6169774) | `src/p_spec.ml:487` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_PS_IsProjectileType`](File-src-p-spec-ml-402508231.md#function-function-ps-isprojectiletype-inline-function-ps-isprojectiletype-t-src-p-spec-ml-542082429) | `src/p_spec.ml:505` | 4 | 1 | 1 | 0 | 0 | 183.48 | 70.88 |
| [`_PS_IsSeq`](File-src-p-spec-ml-402508231.md#function-function-ps-isseq-inline-function-ps-isseq-v-src-p-spec-ml-1115844777) | `src/p_spec.ml:497` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_PS_LineSideSector`](File-src-p-spec-ml-402508231.md#function-function-ps-linesidesector-function-ps-linesidesector-line-side-src-p-spec-ml-2057387437) | `src/p_spec.ml:1192` | 14 | 17 | 11 | 10 | 1 | 605.41 | 54.04 |
| [`_PS_MapName`](File-src-p-setup-ml-2057900615.md#function-function-ps-mapname-inline-function-ps-mapname-episode-map-src-p-setup-ml-248175738) | `src/p_setup.ml:133` | 74 | 139 | 106 | 137 | 2 | 5361.58 | 18.85 |
| [`_PS_MobjInState`](File-src-p-pspr-ml-844718747.md#function-function-ps-mobjinstate-inline-function-ps-mobjinstate-mo-stnum-src-p-pspr-ml-295297352) | `src/p_pspr.ml:289` | 7 | 8 | 4 | 3 | 1 | 224.01 | 64.57 |
| [`_PS_Name8`](File-src-p-setup-ml-2057900615.md#function-function-ps-name8-inline-function-ps-name8-data-off-src-p-setup-ml-1187962102) | `src/p_setup.ml:80` | 3 | 1 | 1 | 0 | 0 | 68.11 | 76.62 |
| [`_PS_ParseInt`](File-src-p-spec-ml-402508231.md#function-function-ps-parseint-function-ps-parseint-v-src-p-spec-ml-630103978) | `src/p_spec.ml:463` | 18 | 15 | 8 | 12 | 3 | 545.61 | 52.38 |
| [`_PS_PlaySound`](File-src-p-pspr-ml-844718747.md#function-function-ps-playsound-inline-function-ps-playsound-origin-sfx-src-p-pspr-ml-1245918704) | `src/p_pspr.ml:301` | 5 | 2 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_PS_PowerIndex`](File-src-p-pspr-ml-844718747.md#function-function-ps-powerindex-function-ps-powerindex-pw-src-p-pspr-ml-52179729) | `src/p_pspr.ml:188` | 13 | 17 | 10 | 10 | 2 | 437.22 | 55.87 |
| [`_PS_PSpriteInState`](File-src-p-pspr-ml-844718747.md#function-function-ps-pspriteinstate-inline-function-ps-pspriteinstate-psp-stnum-src-p-pspr-ml-668201937) | `src/p_pspr.ml:277` | 7 | 8 | 4 | 3 | 1 | 224.01 | 64.57 |
| [`_PS_ReadLumpBytes`](File-src-p-setup-ml-2057900615.md#function-function-ps-readlumpbytes-inline-function-ps-readlumpbytes-lump-src-p-setup-ml-145557809) | `src/p_setup.ml:66` | 9 | 6 | 2 | 1 | 1 | 178.41 | 63.15 |
| [`_PS_ResetButtons`](File-src-p-spec-ml-402508231.md#function-function-ps-resetbuttons-function-ps-resetbuttons-src-p-spec-ml-1110252694) | `src/p_spec.ml:512` | 12 | 7 | 5 | 5 | 2 | 341.84 | 58.04 |
| [`_PS_SectorIndex`](File-src-p-spec-ml-402508231.md#function-function-ps-sectorindex-function-ps-sectorindex-sec-src-p-spec-ml-1101506329) | `src/p_spec.ml:1177` | 10 | 10 | 5 | 5 | 2 | 286.73 | 60.31 |
| [`_PS_SetAmmoCount`](File-src-p-pspr-ml-844718747.md#function-function-ps-setammocount-inline-function-ps-setammocount-player-ammotype-value-src-p-pspr-ml-1922981961) | `src/p_pspr.ml:234` | 10 | 14 | 7 | 6 | 1 | 446.53 | 58.69 |
| [`_PS_StateObjectIndex`](File-src-p-pspr-ml-844718747.md#function-function-ps-stateobjectindex-function-ps-stateobjectindex-stobj-src-p-pspr-ml-1123285516) | `src/p_pspr.ml:262` | 10 | 10 | 5 | 5 | 2 | 294.8 | 60.22 |
| [`_PS_U16LE`](File-src-p-setup-ml-2057900615.md#function-function-ps-u16le-inline-function-ps-u16le-b-off-src-p-setup-ml-27770148) | `src/p_setup.ml:48` | 3 | 1 | 1 | 0 | 0 | 104 | 75.33 |
| [`_PS_VertexOrZero`](File-src-p-setup-ml-2057900615.md#function-function-ps-vertexorzero-inline-function-ps-vertexorzero-idx-src-p-setup-ml-871805350) | `src/p_setup.ml:122` | 6 | 3 | 4 | 3 | 1 | 178.38 | 66.72 |
| [`_PS_WeaponIndex`](File-src-p-pspr-ml-844718747.md#function-function-ps-weaponindex-function-ps-weaponindex-w-src-p-pspr-ml-486422089) | `src/p_pspr.ml:153` | 16 | 23 | 13 | 13 | 2 | 600.13 | 52.53 |
| [`_PS_WeaponInfo`](File-src-p-pspr-ml-844718747.md#function-function-ps-weaponinfo-inline-function-ps-weaponinfo-w-src-p-pspr-ml-202512540) | `src/p_pspr.ml:205` | 7 | 8 | 4 | 3 | 1 | 238.42 | 64.38 |
| [`_PSave_EnsureBuffer`](File-src-p-saveg-ml-1704891910.md#function-function-psave-ensurebuffer-inline-function-psave-ensurebuffer-size-src-p-saveg-ml-1276165487) | `src/p_saveg.ml:46` | 8 | 5 | 3 | 2 | 1 | 178.38 | 64.13 |
| [`_PSET_IDiv`](File-src-p-setup-ml-2057900615.md#function-function-pset-idiv-inline-function-pset-idiv-a-b-src-p-setup-ml-1125777514) | `src/p_setup.ml:89` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_PSET_IsSeq`](File-src-p-setup-ml-2057900615.md#function-function-pset-isseq-inline-function-pset-isseq-v-src-p-setup-ml-295772741) | `src/p_setup.ml:99` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_PSET_LoadPulse`](File-src-p-setup-ml-2057900615.md#function-function-pset-loadpulse-inline-function-pset-loadpulse-text-src-p-setup-ml-286314812) | `src/p_setup.ml:107` | 11 | 8 | 7 | 8 | 2 | 320.64 | 58.79 |
| [`_PSI_GetRejectByte`](File-src-p-sight-ml-269759795.md#function-function-psi-getrejectbyte-function-psi-getrejectbyte-idx-src-p-sight-ml-672608293) | `src/p_sight.ml:62` | 13 | 13 | 8 | 10 | 2 | 427.23 | 56.2 |
| [`_PSI_SectorIndex`](File-src-p-sight-ml-269759795.md#function-function-psi-sectorindex-function-psi-sectorindex-sec-src-p-sight-ml-1436670683) | `src/p_sight.ml:48` | 10 | 10 | 5 | 5 | 2 | 294.8 | 60.22 |
| [`_PSpec_GetPower`](File-src-p-spec-ml-402508231.md#function-function-pspec-getpower-function-pspec-getpower-player-pw-src-p-spec-ml-1879109406) | `src/p_spec.ml:1091` | 15 | 18 | 9 | 9 | 2 | 620.46 | 53.58 |
| [`_PSpec_PowerIndex`](File-src-p-spec-ml-402508231.md#function-function-pspec-powerindex-function-pspec-powerindex-pw-src-p-spec-ml-1313460997) | `src/p_spec.ml:1068` | 18 | 22 | 13 | 14 | 2 | 610 | 51.37 |
| [`_PSV_ArchivePlayerV2`](File-src-p-saveg-ml-1704891910.md#function-function-psv-archiveplayerv2-function-psv-archiveplayerv2-p-src-p-saveg-ml-2010827783) | `src/p_saveg.ml:375` | 69 | 65 | 24 | 30 | 2 | 3206.33 | 32.11 |
| [`_PSV_CheckTag`](File-src-p-saveg-ml-1704891910.md#function-function-psv-checktag-function-psv-checktag-tag-src-p-saveg-ml-1446091901) | `src/p_saveg.ml:189` | 13 | 12 | 4 | 5 | 2 | 320.63 | 57.62 |
| [`_PSV_ClearBlockLinks`](File-src-p-saveg-ml-1704891910.md#function-function-psv-clearblocklinks-function-psv-clearblocklinks-src-p-saveg-ml-187733669) | `src/p_saveg.ml:362` | 8 | 6 | 3 | 2 | 1 | 178.38 | 64.13 |
| [`_PSV_ClearThingLists`](File-src-p-saveg-ml-1704891910.md#function-function-psv-clearthinglists-function-psv-clearthinglists-src-p-saveg-ml-1291036337) | `src/p_saveg.ml:346` | 13 | 10 | 4 | 4 | 2 | 309.13 | 57.73 |
| [`_PSV_Ensure`](File-src-p-saveg-ml-1704891910.md#function-function-psv-ensure-function-psv-ensure-extra-src-p-saveg-ml-687050275) | `src/p_saveg.ml:59` | 20 | 17 | 6 | 5 | 1 | 544.36 | 51.66 |
| [`_PSV_ObjIndex`](File-src-p-saveg-ml-1704891910.md#function-function-psv-objindex-function-psv-objindex-arr-obj-src-p-saveg-ml-284659665) | `src/p_saveg.ml:221` | 10 | 10 | 5 | 5 | 2 | 307.67 | 60.09 |
| [`_PSV_PlayerIndex`](File-src-p-saveg-ml-1704891910.md#function-function-psv-playerindex-inline-function-psv-playerindex-p-src-p-saveg-ml-23143384) | `src/p_saveg.ml:235` | 4 | 3 | 2 | 1 | 1 | 116.76 | 72.12 |
| [`_PSV_ReadBool`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readbool-inline-function-psv-readbool-src-p-saveg-ml-1105554270) | `src/p_saveg.ml:170` | 3 | 1 | 1 | 0 | 0 | 43.19 | 78.01 |
| [`_PSV_ReadCeiling`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readceiling-inline-function-psv-readceiling-src-p-saveg-ml-1741552740) | `src/p_saveg.ml:1188` | 9 | 10 | 5 | 4 | 1 | 639.09 | 58.87 |
| [`_PSV_ReadDoor`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readdoor-inline-function-psv-readdoor-src-p-saveg-ml-1491372622) | `src/p_saveg.ml:1200` | 8 | 8 | 4 | 3 | 1 | 519.8 | 60.75 |
| [`_PSV_ReadFixedString`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readfixedstring-function-psv-readfixedstring-width-src-p-saveg-ml-2041160199) | `src/p_saveg.ml:206` | 9 | 6 | 2 | 1 | 1 | 184.48 | 63.05 |
| [`_PSV_ReadFlash`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readflash-inline-function-psv-readflash-src-p-saveg-ml-1498532626) | `src/p_saveg.ml:1236` | 7 | 6 | 3 | 2 | 1 | 423.04 | 62.77 |
| [`_PSV_ReadFloor`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readfloor-inline-function-psv-readfloor-src-p-saveg-ml-2058540634) | `src/p_saveg.ml:1211` | 8 | 8 | 4 | 3 | 1 | 544.66 | 60.6 |
| [`_PSV_ReadGlow`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readglow-inline-function-psv-readglow-src-p-saveg-ml-15709750) | `src/p_saveg.ml:1256` | 7 | 6 | 3 | 2 | 1 | 385.44 | 63.05 |
| [`_PSV_ReadMapthing`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readmapthing-inline-function-psv-readmapthing-src-p-saveg-ml-497450330) | `src/p_saveg.ml:293` | 3 | 1 | 1 | 0 | 0 | 99.66 | 75.46 |
| [`_PSV_ReadMobj`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readmobj-function-psv-readmobj-src-p-saveg-ml-752994799) | `src/p_saveg.ml:886` | 61 | 58 | 15 | 14 | 1 | 3082.92 | 34.61 |
| [`_PSV_ReadPlat`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readplat-inline-function-psv-readplat-src-p-saveg-ml-1188583386) | `src/p_saveg.ml:1223` | 10 | 10 | 5 | 4 | 1 | 678.72 | 57.69 |
| [`_PSV_ReadPsprite`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readpsprite-inline-function-psv-readpsprite-src-p-saveg-ml-32997428) | `src/p_saveg.ml:336` | 7 | 5 | 1 | 0 | 0 | 164 | 65.92 |
| [`_PSV_ReadS32`](File-src-p-saveg-ml-1704891910.md#function-function-psv-reads32-inline-function-psv-reads32-src-p-saveg-ml-126859058) | `src/p_saveg.ml:176` | 9 | 8 | 2 | 1 | 1 | 287.92 | 61.7 |
| [`_PSV_ReadSectorRef`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readsectorref-inline-function-psv-readsectorref-src-p-saveg-ml-1003238056) | `src/p_saveg.ml:1178` | 6 | 6 | 4 | 3 | 1 | 206.32 | 66.28 |
| [`_PSV_ReadStrobe`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readstrobe-inline-function-psv-readstrobe-src-p-saveg-ml-1498149678) | `src/p_saveg.ml:1246` | 7 | 6 | 3 | 2 | 1 | 423.04 | 62.77 |
| [`_PSV_ReadTiccmd`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readticcmd-inline-function-psv-readticcmd-src-p-saveg-ml-752434306) | `src/p_saveg.ml:315` | 3 | 1 | 1 | 0 | 0 | 112.95 | 75.08 |
| [`_PSV_ReadU8`](File-src-p-saveg-ml-1704891910.md#function-function-psv-readu8-inline-function-psv-readu8-src-p-saveg-ml-747825898) | `src/p_saveg.ml:157` | 10 | 7 | 4 | 3 | 1 | 235.02 | 61.05 |
| [`_PSV_ResolveThinkerMobj`](File-src-p-saveg-ml-1704891910.md#function-function-psv-resolvethinkermobj-function-psv-resolvethinkermobj-node-src-p-saveg-ml-1762355821) | `src/p_saveg.ml:828` | 15 | 12 | 9 | 8 | 1 | 455.1 | 54.52 |
| [`_PSV_SectorIndex`](File-src-p-saveg-ml-1704891910.md#function-function-psv-sectorindex-inline-function-psv-sectorindex-sec-src-p-saveg-ml-1790716839) | `src/p_saveg.ml:243` | 4 | 3 | 2 | 1 | 1 | 116.76 | 72.12 |
| [`_PSV_StateFromIndex`](File-src-p-saveg-ml-1704891910.md#function-function-psv-statefromindex-inline-function-psv-statefromindex-idx-src-p-saveg-ml-1363500157) | `src/p_saveg.ml:267` | 7 | 5 | 5 | 4 | 1 | 220.08 | 64.49 |
| [`_PSV_StateToIndex`](File-src-p-saveg-ml-1704891910.md#function-function-psv-statetoindex-function-psv-statetoindex-st-src-p-saveg-ml-1515990960) | `src/p_saveg.ml:251` | 12 | 11 | 6 | 8 | 3 | 350.94 | 57.83 |
| [`_PSV_ToS32`](File-src-p-saveg-ml-1704891910.md#function-function-psv-tos32-inline-function-psv-tos32-v-src-p-saveg-ml-13872842) | `src/p_saveg.ml:87` | 8 | 7 | 4 | 4 | 2 | 164 | 64.25 |
| [`_PSV_UnArchivePlayerV1`](File-src-p-saveg-ml-1704891910.md#function-function-psv-unarchiveplayerv1-function-psv-unarchiveplayerv1-p-src-p-saveg-ml-121398479) | `src/p_saveg.ml:455` | 63 | 53 | 9 | 9 | 2 | 2432.6 | 35.83 |
| [`_PSV_UnArchivePlayerV2`](File-src-p-saveg-ml-1704891910.md#function-function-psv-unarchiveplayerv2-function-psv-unarchiveplayerv2-p-src-p-saveg-ml-1915418215) | `src/p_saveg.ml:530` | 68 | 58 | 12 | 12 | 2 | 2736.59 | 34.34 |
| [`_PSV_WriteBool`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writebool-inline-function-psv-writebool-v-src-p-saveg-ml-1512429562) | `src/p_saveg.ml:110` | 3 | 3 | 2 | 1 | 1 | 93.77 | 75.51 |
| [`_PSV_WriteCeiling`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writeceiling-inline-function-psv-writeceiling-c-src-p-saveg-ml-1984752735) | `src/p_saveg.ml:1027` | 11 | 9 | 1 | 0 | 0 | 280.93 | 60 |
| [`_PSV_WriteDoor`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writedoor-inline-function-psv-writedoor-d-src-p-saveg-ml-1761991072) | `src/p_saveg.ml:1042` | 9 | 7 | 1 | 0 | 0 | 216.64 | 62.69 |
| [`_PSV_WriteFixedString`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writefixedstring-function-psv-writefixedstring-s-width-src-p-saveg-ml-1862858720) | `src/p_saveg.ml:143` | 10 | 8 | 3 | 3 | 2 | 238.42 | 61.14 |
| [`_PSV_WriteFlash`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writeflash-inline-function-psv-writeflash-f-src-p-saveg-ml-153409412) | `src/p_saveg.ml:1088` | 8 | 6 | 1 | 0 | 0 | 188 | 64.24 |
| [`_PSV_WriteFloor`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writefloor-inline-function-psv-writefloor-f-src-p-saveg-ml-2908500) | `src/p_saveg.ml:1056` | 10 | 8 | 1 | 0 | 0 | 250.63 | 61.25 |
| [`_PSV_WriteGlow`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writeglow-inline-function-psv-writeglow-g-src-p-saveg-ml-1868291947) | `src/p_saveg.ml:1112` | 6 | 4 | 1 | 0 | 0 | 133.26 | 68.01 |
| [`_PSV_WriteMapthing`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writemapthing-inline-function-psv-writemapthing-mt-src-p-saveg-ml-1808125025) | `src/p_saveg.ml:279` | 11 | 12 | 2 | 1 | 1 | 307.46 | 59.59 |
| [`_PSV_WriteMobj`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writemobj-function-psv-writemobj-mo-src-p-saveg-ml-41275997) | `src/p_saveg.ml:848` | 29 | 27 | 1 | 0 | 0 | 932.21 | 47.17 |
| [`_PSV_WritePlat`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writeplat-function-psv-writeplat-p-src-p-saveg-ml-1850217587) | `src/p_saveg.ml:1071` | 13 | 11 | 1 | 0 | 0 | 333.82 | 57.9 |
| [`_PSV_WritePsprite`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writepsprite-inline-function-psv-writepsprite-psp-src-p-saveg-ml-277364781) | `src/p_saveg.ml:323` | 10 | 10 | 2 | 1 | 1 | 284.98 | 60.73 |
| [`_PSV_WriteS32`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writes32-inline-function-psv-writes32-v-src-p-saveg-ml-1422577328) | `src/p_saveg.ml:117` | 7 | 5 | 1 | 0 | 0 | 200 | 65.32 |
| [`_PSV_WriteStrobe`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writestrobe-inline-function-psv-writestrobe-s-src-p-saveg-ml-578041519) | `src/p_saveg.ml:1100` | 8 | 6 | 1 | 0 | 0 | 188 | 64.24 |
| [`_PSV_WriteTag`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writetag-function-psv-writetag-tag-src-p-saveg-ml-749116199) | `src/p_saveg.ml:128` | 10 | 8 | 3 | 3 | 2 | 226.18 | 61.3 |
| [`_PSV_WriteTiccmd`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writeticcmd-inline-function-psv-writeticcmd-cmd-src-p-saveg-ml-476492240) | `src/p_saveg.ml:300` | 12 | 14 | 2 | 1 | 1 | 361.21 | 58.28 |
| [`_PSV_WriteU8`](File-src-p-saveg-ml-1704891910.md#function-function-psv-writeu8-inline-function-psv-writeu8-v-src-p-saveg-ml-1008826060) | `src/p_saveg.ml:99` | 7 | 5 | 1 | 0 | 0 | 140.18 | 66.4 |
| [`_PSW_DiagUseEnabled`](File-src-p-switch-ml-925070734.md#function-function-psw-diaguseenabled-function-psw-diaguseenabled-src-p-switch-ml-1280183933) | `src/p_switch.ml:149` | 16 | 12 | 6 | 6 | 2 | 262.37 | 55.99 |
| [`_PSW_DiagUseLog`](File-src-p-switch-ml-925070734.md#function-function-psw-diaguselog-inline-function-psw-diaguselog-msg-src-p-switch-ml-1094728881) | `src/p_switch.ml:169` | 8 | 6 | 4 | 3 | 1 | 202.12 | 63.62 |
| [`_PSW_Idiv`](File-src-p-switch-ml-925070734.md#function-function-psw-idiv-inline-function-psw-idiv-a-b-src-p-switch-ml-1143589623) | `src/p_switch.ml:219` | 6 | 6 | 3 | 2 | 1 | 221.65 | 66.2 |
| [`_PSW_IsSeq`](File-src-p-switch-ml-925070734.md#function-function-psw-isseq-inline-function-psw-isseq-v-src-p-switch-ml-512562008) | `src/p_switch.ml:105` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_PSW_Side0`](File-src-p-switch-ml-925070734.md#function-function-psw-side0-inline-function-psw-side0-line-src-p-switch-ml-2104470924) | `src/p_switch.ml:127` | 8 | 10 | 8 | 7 | 1 | 421.99 | 60.84 |
| [`_PSW_StartSound`](File-src-p-switch-ml-925070734.md#function-function-psw-startsound-inline-function-psw-startsound-origin-sound-src-p-switch-ml-576074077) | `src/p_switch.ml:140` | 6 | 4 | 3 | 2 | 1 | 141.78 | 67.56 |
| [`_PT_AddLineIntercept`](File-src-p-maputl-ml-227665141.md#function-function-pt-addlineintercept-function-pt-addlineintercept-ld-src-p-maputl-ml-272220968) | `src/p_maputl.ml:523` | 30 | 24 | 11 | 10 | 1 | 1300.6 | 44.49 |
| [`_PT_AddThingIntercept`](File-src-p-maputl-ml-227665141.md#function-function-pt-addthingintercept-function-pt-addthingintercept-thing-src-p-maputl-ml-1257789788) | `src/p_maputl.ml:565` | 38 | 33 | 5 | 4 | 1 | 1258.58 | 43.16 |
| [`_PT_EnsureInterceptCapacity`](File-src-p-maputl-ml-227665141.md#function-function-pt-ensureinterceptcapacity-function-pt-ensureinterceptcapacity-need-src-p-maputl-ml-1890684112) | `src/p_maputl.ml:492` | 23 | 20 | 8 | 8 | 2 | 650.74 | 49.52 |
| [`_PTP_ResolveThinkerMobj`](File-src-p-telept-ml-266213122.md#function-function-ptp-resolvethinkermobj-function-ptp-resolvethinkermobj-th-src-p-telept-ml-561066941) | `src/p_telept.ml:32` | 13 | 13 | 8 | 9 | 2 | 413.3 | 56.31 |
| [`_PU_GetPower`](File-src-p-user-ml-1917117091.md#function-function-pu-getpower-function-pu-getpower-player-pw-src-p-user-ml-971558126) | `src/p_user.ml:105` | 15 | 18 | 9 | 9 | 2 | 620.46 | 53.58 |
| [`_PU_HasWeapon`](File-src-p-user-ml-1917117091.md#function-function-pu-hasweapon-inline-function-pu-hasweapon-player-w-src-p-user-ml-1139037741) | `src/p_user.ml:144` | 7 | 8 | 5 | 4 | 1 | 314.04 | 63.41 |
| [`_PU_PowerIndex`](File-src-p-user-ml-1917117091.md#function-function-pu-powerindex-function-pu-powerindex-pw-src-p-user-ml-1908662029) | `src/p_user.ml:81` | 18 | 22 | 13 | 14 | 2 | 610 | 51.37 |
| [`_PU_SetPower`](File-src-p-user-ml-1917117091.md#function-function-pu-setpower-function-pu-setpower-player-pw-value-src-p-user-ml-823984723) | `src/p_user.ml:126` | 13 | 15 | 8 | 8 | 2 | 534.71 | 55.52 |
| [`_PU_WeaponIndex`](File-src-p-user-ml-1917117091.md#function-function-pu-weaponindex-function-pu-weaponindex-w-src-p-user-ml-1543777893) | `src/p_user.ml:61` | 16 | 23 | 13 | 13 | 2 | 600.13 | 52.53 |
| [`_R_Abs`](File-src-r-main-ml-1902335243.md#function-function-r-abs-inline-function-r-abs-x-src-r-main-ml-232278825) | `src/r_main.ml:313` | 5 | 4 | 2 | 1 | 1 | 114.45 | 70.07 |
| [`_R_AngNorm`](File-src-r-main-ml-1902335243.md#function-function-r-angnorm-inline-function-r-angnorm-a-src-r-main-ml-1810144420) | `src/r_main.ml:363` | 4 | 2 | 1 | 0 | 0 | 78.14 | 73.48 |
| [`_R_AngSub`](File-src-r-main-ml-1902335243.md#function-function-r-angsub-inline-function-r-angsub-a-b-src-r-main-ml-799650374) | `src/r_main.ml:372` | 3 | 1 | 1 | 0 | 0 | 82.45 | 76.04 |
| [`_R_ClipGet`](File-src-r-bsp-ml-998402465.md#function-function-r-clipget-inline-function-r-clipget-i-src-r-bsp-ml-1370608928) | `src/r_bsp.ml:228` | 4 | 3 | 3 | 2 | 1 | 146.95 | 71.29 |
| [`_R_ClipSet`](File-src-r-bsp-ml-998402465.md#function-function-r-clipset-inline-function-r-clipset-i-c-src-r-bsp-ml-1865036895) | `src/r_bsp.ml:237` | 12 | 9 | 4 | 3 | 1 | 293.44 | 58.64 |
| [`_R_ColorMapAt`](File-src-r-main-ml-1902335243.md#function-function-r-colormapat-inline-function-r-colormapat-level-src-r-main-ml-465629565) | `src/r_main.ml:410` | 10 | 10 | 6 | 5 | 1 | 417.79 | 59.03 |
| [`_R_FineSineAt`](File-src-r-main-ml-1902335243.md#function-function-r-finesineat-inline-function-r-finesineat-angle-src-r-main-ml-76048170) | `src/r_main.ml:379` | 10 | 10 | 6 | 6 | 2 | 399.41 | 59.16 |
| [`_R_HasSignBit`](File-src-r-main-ml-1902335243.md#function-function-r-hassignbit-inline-function-r-hassignbit-v-src-r-main-ml-1615810353) | `src/r_main.ml:425` | 3 | 1 | 1 | 0 | 0 | 70.31 | 76.52 |
| [`_R_IDiv`](File-src-r-main-ml-1902335243.md#function-function-r-idiv-inline-function-r-idiv-a-b-src-r-main-ml-1475153906) | `src/r_main.ml:324` | 8 | 8 | 3 | 2 | 1 | 298.02 | 62.57 |
| [`_R_InitTextureMapping`](File-src-r-main-ml-1902335243.md#function-function-r-inittexturemapping-function-r-inittexturemapping-src-r-main-ml-1683816812) | `src/r_main.ml:1339` | 76 | 59 | 18 | 27 | 3 | 2289.26 | 33.03 |
| [`_R_IsSeq`](File-src-r-main-ml-1902335243.md#function-function-r-isseq-inline-function-r-isseq-v-src-r-main-ml-747200205) | `src/r_main.ml:355` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_R_LerpAngle`](File-src-r-main-ml-1902335243.md#function-function-r-lerpangle-inline-function-r-lerpangle-a-b-frac-src-r-main-ml-1483425416) | `src/r_main.ml:505` | 9 | 10 | 4 | 3 | 1 | 510.32 | 59.69 |
| [`_R_LerpS32`](File-src-r-main-ml-1902335243.md#function-function-r-lerps32-inline-function-r-lerps32-a-b-frac-src-r-main-ml-952702094) | `src/r_main.ml:492` | 7 | 7 | 3 | 2 | 1 | 306.49 | 63.75 |
| [`_R_ProfileFlushMaybe`](File-src-r-main-ml-1902335243.md#function-function-r-profileflushmaybe-function-r-profileflushmaybe-src-r-main-ml-222973206) | `src/r_main.ml:199` | 107 | 148 | 46 | 45 | 1 | 6688 | 22.76 |
| [`_R_RebuildScaleLight`](File-src-r-main-ml-1902335243.md#function-function-r-rebuildscalelight-function-r-rebuildscalelight-src-r-main-ml-762705094) | `src/r_main.ml:1009` | 21 | 20 | 6 | 10 | 3 | 708.47 | 50.39 |
| [`_R_RenderOpenGLPlayerView`](File-src-r-main-ml-1902335243.md#function-function-r-renderopenglplayerview-function-r-renderopenglplayerview-player-src-r-main-ml-1428438047) | `src/r_main.ml:1048` | 24 | 16 | 14 | 17 | 3 | 666.81 | 48.24 |
| [`_R_S32`](File-src-r-main-ml-1902335243.md#function-function-r-s32-function-r-s32-v-src-r-main-ml-1040365410) | `src/r_main.ml:432` | 28 | 17 | 8 | 12 | 3 | 683.68 | 47.51 |
| [`_R_SetupFrame`](File-src-r-main-ml-1902335243.md#function-function-r-setupframe-function-r-setupframe-player-src-r-main-ml-1582975857) | `src/r_main.ml:1194` | 128 | 117 | 30 | 45 | 3 | 4454.34 | 24.45 |
| [`_R_TanToAngle`](File-src-r-main-ml-1902335243.md#function-function-r-tantoangle-inline-function-r-tantoangle-num-den-src-r-main-ml-1330430034) | `src/r_main.ml:394` | 11 | 14 | 7 | 6 | 1 | 544.09 | 57.19 |
| [`_R_TimeMs`](File-src-r-main-ml-1902335243.md#function-function-r-timems-inline-function-r-timems-src-r-main-ml-121105675) | `src/r_main.ml:192` | 4 | 2 | 1 | 0 | 0 | 92 | 72.98 |
| [`_R_ToFrac`](File-src-r-main-ml-1902335243.md#function-function-r-tofrac-inline-function-r-tofrac-v-src-r-main-ml-2132514969) | `src/r_main.ml:464` | 22 | 22 | 11 | 16 | 2 | 526.21 | 50.18 |
| [`_R_ToIntOr`](File-src-r-main-ml-1902335243.md#function-function-r-tointor-inline-function-r-tointor-v-fallback-src-r-main-ml-1926071927) | `src/r_main.ml:337` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_R_ViewAngleToX`](File-src-r-bsp-ml-998402465.md#function-function-r-viewangletox-inline-function-r-viewangletox-aidx-src-r-bsp-ml-1001607503) | `src/r_bsp.ml:282` | 7 | 8 | 5 | 4 | 1 | 322.09 | 63.33 |
| [`_RBSP_AngNorm`](File-src-r-bsp-ml-998402465.md#function-function-rbsp-angnorm-inline-function-rbsp-angnorm-a-src-r-bsp-ml-1096893810) | `src/r_bsp.ml:293` | 4 | 2 | 1 | 0 | 0 | 78.14 | 73.48 |
| [`_RBSP_AngSub`](File-src-r-bsp-ml-998402465.md#function-function-rbsp-angsub-inline-function-rbsp-angsub-a-b-src-r-bsp-ml-1421870718) | `src/r_bsp.ml:302` | 3 | 1 | 1 | 0 | 0 | 82.45 | 76.04 |
| [`_RBSP_IsSeq`](File-src-r-bsp-ml-998402465.md#function-function-rbsp-isseq-inline-function-rbsp-isseq-v-src-r-bsp-ml-1035484735) | `src/r_bsp.ml:253` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_RBSP_StoreWallRange`](File-src-r-bsp-ml-998402465.md#function-function-rbsp-storewallrange-inline-function-rbsp-storewallrange-first-last-src-r-bsp-ml-217397319) | `src/r_bsp.ml:195` | 12 | 9 | 2 | 1 | 1 | 247.59 | 59.43 |
| [`_RBSP_TimeMs`](File-src-r-bsp-ml-998402465.md#function-function-rbsp-timems-inline-function-rbsp-timems-src-r-bsp-ml-1422692815) | `src/r_bsp.ml:185` | 4 | 2 | 1 | 0 | 0 | 92 | 72.98 |
| [`_RBSP_ToInt`](File-src-r-bsp-ml-998402465.md#function-function-rbsp-toint-inline-function-rbsp-toint-v-fallback-src-r-bsp-ml-2076386329) | `src/r_bsp.ml:263` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_RD_CenterY`](File-src-r-draw-ml-919823710.md#function-function-rd-centery-inline-function-rd-centery-src-r-draw-ml-1708862922) | `src/r_draw.ml:204` | 4 | 3 | 2 | 1 | 1 | 106.27 | 72.41 |
| [`_rd_clamp`](File-src-r-data-ml-1686270288.md#function-function-rd-clamp-inline-function-rd-clamp-v-lo-hi-src-r-data-ml-1316150864) | `src/r_data.ml:150` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_RD_DepthPass`](File-src-r-draw-ml-919823710.md#function-function-rd-depthpass-inline-function-rd-depthpass-di-src-r-draw-ml-1003475191) | `src/r_draw.ml:176` | 4 | 2 | 1 | 0 | 0 | 43.19 | 75.28 |
| [`_RD_DepthStore`](File-src-r-draw-ml-919823710.md#function-function-rd-depthstore-inline-function-rd-depthstore-di-src-r-draw-ml-583977341) | `src/r_draw.ml:185` | 3 | 1 | 1 | 0 | 0 | 33 | 78.82 |
| [`_rd_drawColumnInCacheAt`](File-src-r-data-ml-1686270288.md#function-function-rd-drawcolumnincacheat-function-rd-drawcolumnincacheat-patchbytes-coloff-cache-cacheoff-originy-cacheheight-src-r-data-ml-2021901064) | `src/r_data.ml:493` | 28 | 27 | 18 | 22 | 2 | 1304.8 | 44.2 |
| [`_rd_drawPatchColumnToCanvas`](File-src-r-data-ml-1686270288.md#function-function-rd-drawpatchcolumntocanvas-function-rd-drawpatchcolumntocanvas-patchbytes-coloff-canvas-texw-texh-dstx-originy-src-r-data-ml-309526928) | `src/r_data.ml:361` | 19 | 16 | 11 | 15 | 3 | 776.69 | 50.39 |
| [`_RD_DrawPatchIfExists`](File-src-r-draw-ml-919823710.md#function-function-rd-drawpatchifexists-inline-function-rd-drawpatchifexists-x-y-scrn-name-src-r-draw-ml-175559980) | `src/r_draw.ml:274` | 6 | 6 | 4 | 3 | 1 | 290.05 | 65.25 |
| [`_rd_ensureColumnCache`](File-src-r-data-ml-1686270288.md#function-function-rd-ensurecolumncache-inline-function-rd-ensurecolumncache-tex-width-src-r-data-ml-309228381) | `src/r_data.ml:869` | 12 | 12 | 9 | 8 | 1 | 485 | 56.44 |
| [`_rd_enumIndex`](File-src-r-data-ml-1686270288.md#function-function-rd-enumindex-inline-function-rd-enumindex-v-limit-src-r-data-ml-572440819) | `src/r_data.ml:259` | 18 | 17 | 10 | 12 | 2 | 519.8 | 52.26 |
| [`_RD_FlatSampleCoord`](File-src-r-draw-ml-919823710.md#function-function-rd-flatsamplecoord-inline-function-rd-flatsamplecoord-frac-size-src-r-draw-ml-1572625725) | `src/r_draw.ml:249` | 10 | 12 | 6 | 5 | 1 | 413.64 | 59.06 |
| [`_rd_generateTextureComposite`](File-src-r-data-ml-1686270288.md#function-function-rd-generatetexturecomposite-function-rd-generatetexturecomposite-texnum-src-r-data-ml-1550425460) | `src/r_data.ml:387` | 51 | 46 | 25 | 41 | 5 | 2076.9 | 36.16 |
| [`_rd_getUpscaledTextureColumn`](File-src-r-data-ml-1686270288.md#function-function-rd-getupscaledtexturecolumn-function-rd-getupscaledtexturecolumn-tex-col-src-r-data-ml-1742938958) | `src/r_data.ml:888` | 45 | 56 | 31 | 31 | 2 | 2689.78 | 35.75 |
| [`_rd_i16`](File-src-r-data-ml-1686270288.md#function-function-rd-i16-inline-function-rd-i16-b-off-src-r-data-ml-1340043857) | `src/r_data.ml:232` | 3 | 1 | 1 | 0 | 0 | 58.81 | 77.07 |
| [`_rd_i32`](File-src-r-data-ml-1686270288.md#function-function-rd-i32-inline-function-rd-i32-b-off-src-r-data-ml-296002481) | `src/r_data.ml:240` | 3 | 1 | 1 | 0 | 0 | 58.81 | 77.07 |
| [`_rd_idiv`](File-src-r-data-ml-1686270288.md#function-function-rd-idiv-inline-function-rd-idiv-a-b-src-r-data-ml-788735663) | `src/r_data.ml:160` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_RD_IDiv`](File-src-r-draw-ml-919823710.md#function-function-rd-idiv-inline-function-rd-idiv-a-b-src-r-draw-ml-3584833) | `src/r_draw.ml:194` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_RD_IsPow2`](File-src-r-draw-ml-919823710.md#function-function-rd-ispow2-inline-function-rd-ispow2-n-src-r-draw-ml-863221058) | `src/r_draw.ml:263` | 4 | 3 | 3 | 2 | 1 | 158.12 | 71.07 |
| [`_rd_isSeq`](File-src-r-data-ml-1686270288.md#function-function-rd-isseq-inline-function-rd-isseq-v-src-r-data-ml-284176874) | `src/r_data.ml:140` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_rd_loadPulse`](File-src-r-data-ml-1686270288.md#function-function-rd-loadpulse-inline-function-rd-loadpulse-iter-src-r-data-ml-431569554) | `src/r_data.ml:282` | 10 | 10 | 6 | 7 | 2 | 316.62 | 59.87 |
| [`_rd_markPresent`](File-src-r-data-ml-1686270288.md#function-function-rd-markpresent-inline-function-rd-markpresent-arr-idx-src-r-data-ml-1258030290) | `src/r_data.ml:248` | 6 | 7 | 5 | 4 | 1 | 244.42 | 65.63 |
| [`_rd_parseTextureLump`](File-src-r-data-ml-1686270288.md#function-function-rd-parsetexturelump-function-rd-parsetexturelump-lumpname-patchlookup-src-r-data-ml-978070398) | `src/r_data.ml:299` | 46 | 46 | 19 | 28 | 3 | 2163.64 | 37.82 |
| [`_RD_TargetBuffer`](File-src-r-draw-ml-919823710.md#function-function-rd-targetbuffer-inline-function-rd-targetbuffer-src-r-draw-ml-180896930) | `src/r_draw.ml:225` | 5 | 5 | 5 | 4 | 1 | 221.65 | 67.66 |
| [`_RD_TargetHeight`](File-src-r-draw-ml-919823710.md#function-function-rd-targetheight-inline-function-rd-targetheight-src-r-draw-ml-546131744) | `src/r_draw.ml:218` | 4 | 3 | 3 | 2 | 1 | 108 | 72.23 |
| [`_RD_TargetWidth`](File-src-r-draw-ml-919823710.md#function-function-rd-targetwidth-inline-function-rd-targetwidth-src-r-draw-ml-1525366726) | `src/r_draw.ml:211` | 4 | 3 | 3 | 2 | 1 | 108 | 72.23 |
| [`_rd_upperName8`](File-src-r-data-ml-1686270288.md#function-function-rd-uppername8-function-rd-uppername8-v-src-r-data-ml-1815038761) | `src/r_data.ml:206` | 20 | 19 | 8 | 9 | 2 | 657.86 | 50.81 |
| [`_rd_wrapColumn`](File-src-r-data-ml-1686270288.md#function-function-rd-wrapcolumn-inline-function-rd-wrapcolumn-col-mask-width-src-r-data-ml-2057426568) | `src/r_data.ml:172` | 14 | 16 | 8 | 8 | 2 | 495.51 | 55.05 |
| [`_RD_WrapIndex`](File-src-r-draw-ml-919823710.md#function-function-rd-wrapindex-inline-function-rd-wrapindex-i-n-src-r-draw-ml-1386260883) | `src/r_draw.ml:235` | 9 | 9 | 7 | 7 | 2 | 321.17 | 60.69 |
| [`_RP_Abs`](File-src-r-plane-ml-1848108848.md#function-function-rp-abs-inline-function-rp-abs-v-src-r-plane-ml-108911242) | `src/r_plane.ml:145` | 5 | 4 | 2 | 1 | 1 | 114.45 | 70.07 |
| [`_RP_AngNorm`](File-src-r-plane-ml-1848108848.md#function-function-rp-angnorm-inline-function-rp-angnorm-a-src-r-plane-ml-419188575) | `src/r_plane.ml:162` | 4 | 2 | 1 | 0 | 0 | 78.14 | 73.48 |
| [`_RP_DefaultColorMap`](File-src-r-plane-ml-1848108848.md#function-function-rp-defaultcolormap-inline-function-rp-defaultcolormap-src-r-plane-ml-1249687728) | `src/r_plane.ml:185` | 14 | 9 | 6 | 5 | 1 | 357.58 | 56.31 |
| [`_RP_DrawVisplanes`](File-src-r-plane-ml-1848108848.md#function-function-rp-drawvisplanes-function-rp-drawvisplanes-src-r-plane-ml-98651865) | `src/r_plane.ml:554` | 123 | 113 | 40 | 79 | 5 | 4605.37 | 23.38 |
| [`_RP_EnsurePlaneCapacity`](File-src-r-plane-ml-1848108848.md#function-function-rp-ensureplanecapacity-function-rp-ensureplanecapacity-needindex-src-r-plane-ml-742454977) | `src/r_plane.ml:228` | 25 | 23 | 10 | 11 | 2 | 787.56 | 47.88 |
| [`_RP_FineAt`](File-src-r-plane-ml-1848108848.md#function-function-rp-fineat-inline-function-rp-fineat-tab-idx-src-r-plane-ml-810100658) | `src/r_plane.ml:171` | 10 | 11 | 7 | 7 | 2 | 451.89 | 58.65 |
| [`_RP_I`](File-src-r-plane-ml-1848108848.md#function-function-rp-i-inline-function-rp-i-v-fallback-src-r-plane-ml-412511704) | `src/r_plane.ml:127` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_RP_IDiv`](File-src-r-plane-ml-1848108848.md#function-function-rp-idiv-inline-function-rp-idiv-a-b-src-r-plane-ml-317990625) | `src/r_plane.ml:115` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_RP_IsSeq`](File-src-r-plane-ml-1848108848.md#function-function-rp-isseq-inline-function-rp-isseq-v-src-r-plane-ml-1094817874) | `src/r_plane.ml:154` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_RP_NewPlane`](File-src-r-plane-ml-1848108848.md#function-function-rp-newplane-inline-function-rp-newplane-height-picnum-lightlevel-src-r-plane-ml-1744632695) | `src/r_plane.ml:220` | 4 | 2 | 1 | 0 | 0 | 194.49 | 70.71 |
| [`_RP_RecomputeSlopeTables`](File-src-r-plane-ml-1848108848.md#function-function-rp-recomputeslopetables-function-rp-recomputeslopetables-src-r-plane-ml-1380175339) | `src/r_plane.ml:298` | 29 | 29 | 14 | 17 | 2 | 1219.57 | 44.61 |
| [`_RP_ResetPlane`](File-src-r-plane-ml-1848108848.md#function-function-rp-resetplane-function-rp-resetplane-pl-height-picnum-lightlevel-minx-maxx-src-r-plane-ml-954733404) | `src/r_plane.ml:265` | 27 | 20 | 8 | 9 | 2 | 850.95 | 47.19 |
| [`_RP_TargetHeight`](File-src-r-plane-ml-1848108848.md#function-function-rp-targetheight-inline-function-rp-targetheight-src-r-plane-ml-1359538410) | `src/r_plane.ml:210` | 4 | 3 | 3 | 2 | 1 | 108 | 72.23 |
| [`_RP_TargetWidth`](File-src-r-plane-ml-1848108848.md#function-function-rp-targetwidth-inline-function-rp-targetwidth-src-r-plane-ml-208005712) | `src/r_plane.ml:203` | 4 | 3 | 3 | 2 | 1 | 108 | 72.23 |
| [`_RS_Abs`](File-src-r-segs-ml-1658887754.md#function-function-rs-abs-inline-function-rs-abs-v-src-r-segs-ml-764261568) | `src/r_segs.ml:139` | 5 | 4 | 2 | 1 | 1 | 114.45 | 70.07 |
| [`_RS_AllocIntList`](File-src-r-segs-ml-1658887754.md#function-function-rs-allocintlist-inline-function-rs-allocintlist-n-fill-src-r-segs-ml-1052167343) | `src/r_segs.ml:184` | 9 | 6 | 2 | 1 | 1 | 159.91 | 63.48 |
| [`_RS_AllocMaskedCols`](File-src-r-segs-ml-1658887754.md#function-function-rs-allocmaskedcols-function-rs-allocmaskedcols-start-stop-src-r-segs-ml-1062654977) | `src/r_segs.ml:373` | 18 | 21 | 9 | 8 | 1 | 651.41 | 51.7 |
| [`_RS_AngNorm`](File-src-r-segs-ml-1658887754.md#function-function-rs-angnorm-inline-function-rs-angnorm-a-src-r-segs-ml-1287694807) | `src/r_segs.ml:235` | 4 | 2 | 1 | 0 | 0 | 78.14 | 73.48 |
| [`_RS_AngSub`](File-src-r-segs-ml-1658887754.md#function-function-rs-angsub-inline-function-rs-angsub-a-b-src-r-segs-ml-1874460203) | `src/r_segs.ml:244` | 3 | 1 | 1 | 0 | 0 | 82.45 | 76.04 |
| [`_RS_Clamp`](File-src-r-segs-ml-1658887754.md#function-function-rs-clamp-inline-function-rs-clamp-v-lo-hi-src-r-segs-ml-45824942) | `src/r_segs.ml:130` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_RS_ClampIndex`](File-src-r-segs-ml-1658887754.md#function-function-rs-clampindex-inline-function-rs-clampindex-i-n-src-r-segs-ml-1097890701) | `src/r_segs.ml:164` | 7 | 9 | 6 | 5 | 1 | 275.94 | 63.67 |
| [`_RS_CopyClipToOpenings`](File-src-r-segs-ml-1658887754.md#function-function-rs-copycliptoopenings-function-rs-copycliptoopenings-src-start-stop-fallback-src-r-segs-ml-1464668399) | `src/r_segs.ml:343` | 21 | 25 | 12 | 12 | 2 | 878.95 | 48.93 |
| [`_RS_DrawMaskedTextureColumn`](File-src-r-segs-ml-1658887754.md#function-function-rs-drawmaskedtexturecolumn-function-rs-drawmaskedtexturecolumn-x-texnum-texturecolumn-texturemid-yscale-topclip-bottomclip-src-r-segs-ml-1629864199) | `src/r_segs.ml:471` | 87 | 82 | 23 | 42 | 4 | 3247.16 | 30.01 |
| [`_RS_DrawTexturedRange`](File-src-r-segs-ml-1658887754.md#function-function-rs-drawtexturedrange-function-rs-drawtexturedrange-fb-x-y1-y2-texnum-texcol-cmap-src-r-segs-ml-183170629) | `src/r_segs.ml:438` | 21 | 26 | 13 | 15 | 2 | 1078.02 | 48.17 |
| [`_RS_EnsureOpeningsCapacity`](File-src-r-segs-ml-1658887754.md#function-function-rs-ensureopeningscapacity-function-rs-ensureopeningscapacity-needed-src-r-segs-ml-2081519344) | `src/r_segs.ml:197` | 25 | 24 | 13 | 14 | 2 | 873.51 | 47.16 |
| [`_RS_GetClipValue`](File-src-r-segs-ml-1658887754.md#function-function-rs-getclipvalue-inline-function-rs-getclipvalue-clipref-x-fallback-src-r-segs-ml-445048381) | `src/r_segs.ml:307` | 12 | 11 | 9 | 10 | 2 | 461.25 | 56.6 |
| [`_RS_IDiv`](File-src-r-segs-ml-1658887754.md#function-function-rs-idiv-inline-function-rs-idiv-a-b-src-r-segs-ml-1984995287) | `src/r_segs.ml:99` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_RS_IsSeq`](File-src-r-segs-ml-1658887754.md#function-function-rs-isseq-inline-function-rs-isseq-v-src-r-segs-ml-385991552) | `src/r_segs.ml:175` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_RS_ReadMaskedCol`](File-src-r-segs-ml-1658887754.md#function-function-rs-readmaskedcol-inline-function-rs-readmaskedcol-maskref-x-src-r-segs-ml-554069583) | `src/r_segs.ml:399` | 12 | 11 | 9 | 10 | 2 | 451.43 | 56.66 |
| [`_RS_ResolveTexture`](File-src-r-segs-ml-1658887754.md#function-function-rs-resolvetexture-inline-function-rs-resolvetexture-texid-src-r-segs-ml-425988308) | `src/r_segs.ml:251` | 10 | 10 | 9 | 8 | 1 | 394.66 | 58.8 |
| [`_RS_SelectWallLights`](File-src-r-segs-ml-1658887754.md#function-function-rs-selectwalllights-function-rs-selectwalllights-line-sec-src-r-segs-ml-1046142236) | `src/r_segs.ml:267` | 29 | 18 | 13 | 14 | 2 | 988.72 | 45.38 |
| [`_RS_SetClipValue`](File-src-r-segs-ml-1658887754.md#function-function-rs-setclipvalue-inline-function-rs-setclipvalue-clipref-x-value-src-r-segs-ml-1302772842) | `src/r_segs.ml:325` | 11 | 10 | 9 | 10 | 2 | 451.43 | 57.49 |
| [`_RS_ToInt`](File-src-r-segs-ml-1658887754.md#function-function-rs-toint-inline-function-rs-toint-v-fallback-src-r-segs-ml-551203270) | `src/r_segs.ml:110` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_RS_WrapIndex`](File-src-r-segs-ml-1658887754.md#function-function-rs-wrapindex-inline-function-rs-wrapindex-i-n-src-r-segs-ml-718341927) | `src/r_segs.ml:149` | 10 | 11 | 7 | 7 | 2 | 348.31 | 59.45 |
| [`_RS_WriteMaskedCol`](File-src-r-segs-ml-1658887754.md#function-function-rs-writemaskedcol-inline-function-rs-writemaskedcol-maskref-x-value-src-r-segs-ml-1118192978) | `src/r_segs.ml:417` | 11 | 10 | 9 | 10 | 2 | 451.43 | 57.49 |
| [`_RT_Abs`](File-src-r-things-ml-545677447.md#function-function-rt-abs-inline-function-rt-abs-v-src-r-things-ml-1550979053) | `src/r_things.ml:241` | 5 | 4 | 2 | 1 | 1 | 114.45 | 70.07 |
| [`_RT_AngNorm`](File-src-r-things-ml-545677447.md#function-function-rt-angnorm-inline-function-rt-angnorm-a-src-r-things-ml-611631638) | `src/r_things.ml:290` | 4 | 2 | 1 | 0 | 0 | 78.14 | 73.48 |
| [`_RT_BuildSpriteDef`](File-src-r-things-ml-545677447.md#function-function-rt-buildspritedef-function-rt-buildspritedef-sprname-src-r-things-ml-1648405728) | `src/r_things.ml:465` | 53 | 39 | 21 | 35 | 4 | 2062.47 | 36.35 |
| [`_RT_Clamp`](File-src-r-things-ml-545677447.md#function-function-rt-clamp-inline-function-rt-clamp-v-lo-hi-src-r-things-ml-1825509095) | `src/r_things.ml:252` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_RT_ColormapAt`](File-src-r-things-ml-545677447.md#function-function-rt-colormapat-inline-function-rt-colormapat-idx-src-r-things-ml-1108471472) | `src/r_things.ml:649` | 12 | 12 | 8 | 7 | 1 | 514.53 | 56.4 |
| [`_RT_DrawMaskedPatchColumn`](File-src-r-things-ml-545677447.md#function-function-rt-drawmaskedpatchcolumn-function-rt-drawmaskedpatchcolumn-patch-coloff-src-r-things-ml-1477215761) | `src/r_things.ml:697` | 58 | 57 | 12 | 20 | 3 | 1788.86 | 37.14 |
| [`_RT_DrawUpscaledLinearSprite`](File-src-r-things-ml-545677447.md#function-function-rt-drawupscaledlinearsprite-function-rt-drawupscaledlinearsprite-vis-entry-origw-x1-x2-src-r-things-ml-930646455) | `src/r_things.ml:800` | 73 | 80 | 44 | 96 | 9 | 4600.08 | 27.79 |
| [`_RT_EnumIndex`](File-src-r-things-ml-545677447.md#function-function-rt-enumindex-inline-function-rt-enumindex-v-limit-src-r-things-ml-448765984) | `src/r_things.ml:325` | 13 | 15 | 8 | 8 | 2 | 466.37 | 55.94 |
| [`_RT_GetClipValue`](File-src-r-things-ml-545677447.md#function-function-rt-getclipvalue-inline-function-rt-getclipvalue-clipref-x-fallback-src-r-things-ml-718424062) | `src/r_things.ml:308` | 12 | 11 | 9 | 10 | 2 | 461.25 | 56.6 |
| [`_RT_IDiv`](File-src-r-things-ml-545677447.md#function-function-rt-idiv-inline-function-rt-idiv-a-b-src-r-things-ml-321727572) | `src/r_things.ml:231` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_RT_InstallSpriteLump`](File-src-r-things-ml-545677447.md#function-function-rt-installspritelump-function-rt-installspritelump-frames-frame-rotation-lump-flipped-sprname-maxframe-src-r-things-ml-717438544) | `src/r_things.ml:412` | 42 | 35 | 13 | 15 | 2 | 1310.88 | 41.01 |
| [`_RT_IsSeq`](File-src-r-things-ml-545677447.md#function-function-rt-isseq-inline-function-rt-isseq-v-src-r-things-ml-1770601213) | `src/r_things.ml:298` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_RT_LumpNameAt`](File-src-r-things-ml-545677447.md#function-function-rt-lumpnameat-inline-function-rt-lumpnameat-lumpnum-src-r-things-ml-1534659095) | `src/r_things.ml:380` | 7 | 8 | 6 | 5 | 1 | 326.98 | 63.15 |
| [`_RT_MakeEmptyFrame`](File-src-r-things-ml-545677447.md#function-function-rt-makeemptyframe-inline-function-rt-makeemptyframe-src-r-things-ml-396971181) | `src/r_things.ml:220` | 5 | 3 | 1 | 0 | 0 | 138.97 | 69.61 |
| [`_RT_Name4`](File-src-r-things-ml-545677447.md#function-function-rt-name4-inline-function-rt-name4-s-src-r-things-ml-1651458208) | `src/r_things.ml:364` | 12 | 11 | 4 | 3 | 1 | 381.47 | 57.85 |
| [`_RT_ProfDrawn`](File-src-r-things-ml-545677447.md#function-function-rt-profdrawn-inline-function-rt-profdrawn-src-r-things-ml-1623117371) | `src/r_things.ml:172` | 4 | 3 | 2 | 1 | 1 | 72.34 | 73.58 |
| [`_RT_ProfProjected`](File-src-r-things-ml-545677447.md#function-function-rt-profprojected-inline-function-rt-profprojected-src-r-things-ml-1233339811) | `src/r_things.ml:165` | 4 | 3 | 2 | 1 | 1 | 72.34 | 73.58 |
| [`_RT_ProfReject`](File-src-r-things-ml-545677447.md#function-function-rt-profreject-inline-function-rt-profreject-kind-src-r-things-ml-2067364263) | `src/r_things.ml:180` | 30 | 29 | 14 | 13 | 1 | 965.22 | 45 |
| [`_RT_ProfThingSeen`](File-src-r-things-ml-545677447.md#function-function-rt-profthingseen-inline-function-rt-profthingseen-src-r-things-ml-609996239) | `src/r_things.ml:158` | 4 | 3 | 2 | 1 | 1 | 72.34 | 73.58 |
| [`_RT_RebuildColormapCache`](File-src-r-things-ml-545677447.md#function-function-rt-rebuildcolormapcache-function-rt-rebuildcolormapcache-src-r-things-ml-1447473950) | `src/r_things.ml:619` | 24 | 20 | 5 | 4 | 1 | 579.61 | 49.87 |
| [`_RT_S32`](File-src-r-things-ml-545677447.md#function-function-rt-s32-inline-function-rt-s32-v-src-r-things-ml-1038021317) | `src/r_things.ml:280` | 6 | 5 | 2 | 1 | 1 | 151.62 | 67.49 |
| [`_RT_SelectSpriteLights`](File-src-r-things-ml-545677447.md#function-function-rt-selectspritelights-inline-function-rt-selectspritelights-lightnum-src-r-things-ml-758246765) | `src/r_things.ml:677` | 14 | 8 | 5 | 4 | 1 | 337.6 | 56.62 |
| [`_RT_ShadowColormap`](File-src-r-things-ml-545677447.md#function-function-rt-shadowcolormap-inline-function-rt-shadowcolormap-src-r-things-ml-1851385251) | `src/r_things.ml:664` | 8 | 5 | 3 | 2 | 1 | 158.12 | 64.5 |
| [`_RT_SourceScaleFromEntry`](File-src-r-things-ml-545677447.md#function-function-rt-sourcescalefromentry-inline-function-rt-sourcescalefromentry-entry-origw-src-r-things-ml-1399845501) | `src/r_things.ml:785` | 7 | 8 | 7 | 6 | 1 | 344.92 | 62.85 |
| [`_RT_SpriteIndex`](File-src-r-things-ml-545677447.md#function-function-rt-spriteindex-inline-function-rt-spriteindex-v-src-r-things-ml-1218471113) | `src/r_things.ml:343` | 9 | 5 | 3 | 2 | 1 | 199.04 | 62.68 |
| [`_RT_TargetBuffer`](File-src-r-things-ml-545677447.md#function-function-rt-targetbuffer-inline-function-rt-targetbuffer-src-r-things-ml-1524515139) | `src/r_things.ml:775` | 5 | 5 | 5 | 4 | 1 | 221.65 | 67.66 |
| [`_RT_ToInt`](File-src-r-things-ml-545677447.md#function-function-rt-toint-inline-function-rt-toint-v-fallback-src-r-things-ml-1716101863) | `src/r_things.ml:262` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_RT_UpperAscii`](File-src-r-things-ml-545677447.md#function-function-rt-upperascii-inline-function-rt-upperascii-c-src-r-things-ml-259601176) | `src/r_things.ml:356` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_s16le`](File-src-v-video-ml-592999939.md#function-function-s16le-inline-function-s16le-b-off-src-v-video-ml-426326194) | `src/v_video.ml:188` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`_s32`](File-src-m-fixed-ml-2129187227.md#function-function-s32-function-s32-x-src-m-fixed-ml-2061379470) | `src/m_fixed.ml:64` | 30 | 17 | 8 | 12 | 3 | 683.68 | 46.85 |
| [`_S_Abs`](File-src-s-sound-ml-1485495390.md#function-function-s-abs-inline-function-s-abs-v-src-s-sound-ml-1249108556) | `src/s_sound.ml:245` | 5 | 5 | 3 | 2 | 1 | 128 | 69.59 |
| [`_S_AngNorm`](File-src-s-sound-ml-1485495390.md#function-function-s-angnorm-inline-function-s-angnorm-a-src-s-sound-ml-247835693) | `src/s_sound.ml:254` | 4 | 3 | 2 | 1 | 1 | 96 | 72.72 |
| [`_S_AngRef`](File-src-s-sound-ml-1485495390.md#function-function-s-angref-inline-function-s-angref-v-src-s-sound-ml-116865424) | `src/s_sound.ml:412` | 8 | 8 | 6 | 7 | 2 | 325.03 | 61.9 |
| [`_S_Clamp`](File-src-s-sound-ml-1485495390.md#function-function-s-clamp-inline-function-s-clamp-v-lo-hi-src-s-sound-ml-792553964) | `src/s_sound.ml:227` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_S_DegradeUsefulness`](File-src-s-sound-ml-1485495390.md#function-function-s-degradeusefulness-inline-function-s-degradeusefulness-sfx-src-s-sound-ml-262359263) | `src/s_sound.ml:355` | 15 | 14 | 8 | 8 | 2 | 562.62 | 54.01 |
| [`_S_EffectiveConsoleSlot`](File-src-s-sound-ml-1485495390.md#function-function-s-effectiveconsoleslot-inline-function-s-effectiveconsoleslot-src-s-sound-ml-268660442) | `src/s_sound.ml:295` | 9 | 5 | 4 | 4 | 2 | 224.01 | 62.19 |
| [`_S_EnsureChannels`](File-src-s-sound-ml-1485495390.md#function-function-s-ensurechannels-inline-function-s-ensurechannels-src-s-sound-ml-896088898) | `src/s_sound.ml:275` | 14 | 13 | 5 | 4 | 1 | 405 | 56.07 |
| [`_S_EnumIndex`](File-src-s-sound-ml-1485495390.md#function-function-s-enumindex-inline-function-s-enumindex-v-limit-src-s-sound-ml-1339446697) | `src/s_sound.ml:145` | 14 | 16 | 7 | 7 | 2 | 475.97 | 55.31 |
| [`_S_FineSineAt`](File-src-s-sound-ml-1485495390.md#function-function-s-finesineat-inline-function-s-finesineat-idx-src-s-sound-ml-2113745881) | `src/s_sound.ml:262` | 10 | 10 | 6 | 6 | 2 | 413.68 | 59.06 |
| [`_S_GetListener`](File-src-s-sound-ml-1485495390.md#function-function-s-getlistener-inline-function-s-getlistener-src-s-sound-ml-802656094) | `src/s_sound.ml:307` | 8 | 9 | 5 | 4 | 1 | 275.78 | 62.54 |
| [`_S_GetSfxById`](File-src-s-sound-ml-1485495390.md#function-function-s-getsfxbyid-inline-function-s-getsfxbyid-sound-id-src-s-sound-ml-168677235) | `src/s_sound.ml:319` | 6 | 6 | 4 | 3 | 1 | 210.91 | 66.21 |
| [`_S_IDiv`](File-src-s-sound-ml-1485495390.md#function-function-s-idiv-inline-function-s-idiv-a-b-src-s-sound-ml-1719114793) | `src/s_sound.ml:215` | 6 | 6 | 5 | 4 | 1 | 299.56 | 65.01 |
| [`_S_IsSeq`](File-src-s-sound-ml-1485495390.md#function-function-s-isseq-inline-function-s-isseq-v-src-s-sound-ml-1798949782) | `src/s_sound.ml:117` | 4 | 2 | 1 | 0 | 0 | 85.95 | 73.19 |
| [`_S_LinkOf`](File-src-s-sound-ml-1485495390.md#function-function-s-linkof-inline-function-s-linkof-sfx-src-s-sound-ml-277960245) | `src/s_sound.ml:329` | 11 | 8 | 6 | 5 | 1 | 350 | 58.66 |
| [`_S_LoadPulse`](File-src-s-sound-ml-1485495390.md#function-function-s-loadpulse-inline-function-s-loadpulse-iter-src-s-sound-ml-1526189662) | `src/s_sound.ml:167` | 11 | 12 | 7 | 9 | 2 | 379.98 | 58.28 |
| [`_S_Min`](File-src-s-sound-ml-1485495390.md#function-function-s-min-inline-function-s-min-a-b-src-s-sound-ml-1888466169) | `src/s_sound.ml:237` | 4 | 3 | 2 | 1 | 1 | 77.71 | 73.36 |
| [`_S_MPSendSoundEvent`](File-src-s-sound-ml-1485495390.md#function-function-s-mpsendsoundevent-function-s-mpsendsoundevent-origin-p-sid-volume-targetslot-src-s-sound-ml-881170861) | `src/s_sound.ml:455` | 46 | 44 | 15 | 15 | 2 | 1980.82 | 38.63 |
| [`_S_MusicId`](File-src-s-sound-ml-1485495390.md#function-function-s-musicid-inline-function-s-musicid-v-src-s-sound-ml-740846432) | `src/s_sound.ml:198` | 10 | 12 | 7 | 6 | 1 | 459.04 | 58.61 |
| [`_S_PosRef`](File-src-s-sound-ml-1485495390.md#function-function-s-posref-inline-function-s-posref-v-src-s-sound-ml-2056068700) | `src/s_sound.ml:396` | 12 | 8 | 8 | 9 | 2 | 395.31 | 57.2 |
| [`_S_ReadI32`](File-src-s-sound-ml-1485495390.md#function-function-s-readi32-inline-function-s-readi32-buf-off-src-s-sound-ml-1324011560) | `src/s_sound.ml:439` | 9 | 8 | 2 | 1 | 1 | 425.73 | 60.51 |
| [`_S_SameXY`](File-src-s-sound-ml-1485495390.md#function-function-s-samexy-inline-function-s-samexy-a-b-src-s-sound-ml-1869235741) | `src/s_sound.ml:386` | 6 | 5 | 3 | 2 | 1 | 341.32 | 64.88 |
| [`_S_SetSfxUsefulnessAndLump`](File-src-s-sound-ml-1485495390.md#function-function-s-setsfxusefulnessandlump-inline-function-s-setsfxusefulnessandlump-sid-sfx-src-s-sound-ml-2116297187) | `src/s_sound.ml:376` | 5 | 5 | 4 | 3 | 1 | 185.47 | 68.33 |
| [`_S_SfxId`](File-src-s-sound-ml-1485495390.md#function-function-s-sfxid-inline-function-s-sfxid-v-src-s-sound-ml-970866184) | `src/s_sound.ml:183` | 10 | 12 | 7 | 6 | 1 | 459.04 | 58.61 |
| [`_S_SfxPriority`](File-src-s-sound-ml-1485495390.md#function-function-s-sfxpriority-inline-function-s-sfxpriority-sfx-src-s-sound-ml-916113603) | `src/s_sound.ml:347` | 4 | 3 | 2 | 1 | 1 | 106.27 | 72.41 |
| [`_S_ToInt`](File-src-s-sound-ml-1485495390.md#function-function-s-toint-inline-function-s-toint-v-fallback-src-s-sound-ml-366156502) | `src/s_sound.ml:126` | 14 | 14 | 7 | 8 | 2 | 526.45 | 55 |
| [`_S_WriteI32`](File-src-s-sound-ml-1485495390.md#function-function-s-writei32-inline-function-s-writei32-buf-off-v-src-s-sound-ml-1574458978) | `src/s_sound.ml:426` | 8 | 7 | 2 | 1 | 1 | 402.36 | 61.79 |
| [`_SetTMBox`](File-src-p-map-ml-882556686.md#function-function-settmbox-inline-function-settmbox-x-y-radius-src-p-map-ml-1363201131) | `src/p_map.ml:97` | 6 | 4 | 1 | 0 | 0 | 190.16 | 66.93 |
| [`_ST_ArrayAppend`](File-src-st-stuff-ml-811030939.md#function-function-st-arrayappend-function-st-arrayappend-arr-item-src-st-stuff-ml-1734783620) | `src/st_stuff.ml:501` | 12 | 10 | 3 | 2 | 1 | 318.58 | 58.53 |
| [`_ST_CheatParam`](File-src-st-stuff-ml-811030939.md#function-function-st-cheatparam-inline-function-st-cheatparam-cheat-src-st-stuff-ml-127806838) | `src/st_stuff.ml:526` | 4 | 2 | 1 | 0 | 0 | 89.86 | 73.05 |
| [`_ST_DigitFromParam`](File-src-st-stuff-ml-811030939.md#function-function-st-digitfromparam-inline-function-st-digitfromparam-param-idx-src-st-stuff-ml-174909379) | `src/st_stuff.ml:471` | 9 | 10 | 6 | 5 | 1 | 398.51 | 60.17 |
| [`_ST_DigitString`](File-src-st-stuff-ml-811030939.md#function-function-st-digitstring-inline-function-st-digitstring-v-src-st-stuff-ml-181747753) | `src/st_stuff.ml:484` | 12 | 19 | 10 | 9 | 1 | 446.53 | 56.56 |
| [`_ST_EnumIndex`](File-src-st-stuff-ml-811030939.md#function-function-st-enumindex-function-st-enumindex-v-limit-src-st-stuff-ml-1203358057) | `src/st_stuff.ml:429` | 15 | 15 | 10 | 11 | 2 | 515.24 | 54.01 |
| [`_ST_FacebackName`](File-src-st-stuff-ml-811030939.md#function-function-st-facebackname-inline-function-st-facebackname-src-st-stuff-ml-1677797813) | `src/st_stuff.ml:516` | 6 | 7 | 4 | 3 | 1 | 150.12 | 67.25 |
| [`_ST_GetAmmo`](File-src-st-stuff-ml-811030939.md#function-function-st-getammo-inline-function-st-getammo-player-idx-src-st-stuff-ml-1779943155) | `src/st_stuff.ml:616` | 7 | 8 | 5 | 4 | 1 | 353.3 | 63.05 |
| [`_ST_GetCard`](File-src-st-stuff-ml-811030939.md#function-function-st-getcard-inline-function-st-getcard-player-idx-src-st-stuff-ml-206523255) | `src/st_stuff.ml:592` | 7 | 8 | 5 | 4 | 1 | 331.93 | 63.24 |
| [`_ST_GetMaxAmmo`](File-src-st-stuff-ml-811030939.md#function-function-st-getmaxammo-inline-function-st-getmaxammo-player-idx-src-st-stuff-ml-1661056635) | `src/st_stuff.ml:628` | 7 | 8 | 5 | 4 | 1 | 353.3 | 63.05 |
| [`_ST_GetPower`](File-src-st-stuff-ml-811030939.md#function-function-st-getpower-inline-function-st-getpower-player-idx-src-st-stuff-ml-2001258365) | `src/st_stuff.ml:579` | 8 | 10 | 6 | 5 | 1 | 397.46 | 61.29 |
| [`_ST_GetRef`](File-src-st-stuff-ml-811030939.md#function-function-st-getref-inline-function-st-getref-refv-fallback-src-st-stuff-ml-49433732) | `src/st_stuff.ml:536` | 7 | 5 | 4 | 3 | 1 | 194.51 | 65 |
| [`_ST_GetWeaponOwned`](File-src-st-stuff-ml-811030939.md#function-function-st-getweaponowned-inline-function-st-getweaponowned-player-idx-src-st-stuff-ml-687293677) | `src/st_stuff.ml:604` | 7 | 8 | 5 | 4 | 1 | 331.93 | 63.24 |
| [`_ST_IDiv`](File-src-st-stuff-ml-811030939.md#function-function-st-idiv-inline-function-st-idiv-a-b-src-st-stuff-ml-2043021018) | `src/st_stuff.ml:450` | 8 | 8 | 3 | 2 | 1 | 298.02 | 62.57 |
| [`_ST_LoadPatchMaybe`](File-src-st-stuff-ml-811030939.md#function-function-st-loadpatchmaybe-inline-function-st-loadpatchmaybe-name-src-st-stuff-ml-1305356206) | `src/st_stuff.ml:557` | 5 | 5 | 3 | 2 | 1 | 175.69 | 68.63 |
| [`_ST_LoadPatchRequired`](File-src-st-stuff-ml-811030939.md#function-function-st-loadpatchrequired-inline-function-st-loadpatchrequired-name-src-st-stuff-ml-1123791290) | `src/st_stuff.ml:566` | 8 | 6 | 3 | 2 | 1 | 202.05 | 63.75 |
| [`_ST_Player`](File-src-st-stuff-ml-811030939.md#function-function-st-player-inline-function-st-player-src-st-stuff-ml-1057442077) | `src/st_stuff.ml:399` | 6 | 7 | 5 | 4 | 1 | 235.23 | 65.75 |
| [`_ST_SetMessage`](File-src-st-stuff-ml-811030939.md#function-function-st-setmessage-inline-function-st-setmessage-msg-src-st-stuff-ml-2015913326) | `src/st_stuff.ml:462` | 4 | 3 | 2 | 1 | 1 | 84 | 73.12 |
| [`_ST_SetRef`](File-src-st-stuff-ml-811030939.md#function-function-st-setref-inline-function-st-setref-refv-v-src-st-stuff-ml-650025146) | `src/st_stuff.ml:548` | 5 | 2 | 3 | 2 | 1 | 144.95 | 69.22 |
| [`_ST_ToInt`](File-src-st-stuff-ml-811030939.md#function-function-st-toint-function-st-toint-v-fallback-src-st-stuff-ml-488441562) | `src/st_stuff.ml:410` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_ST_WeaponAmmoType`](File-src-st-stuff-ml-811030939.md#function-function-st-weaponammotype-inline-function-st-weaponammotype-weapon-src-st-stuff-ml-1652279747) | `src/st_stuff.ml:639` | 11 | 14 | 6 | 5 | 1 | 446.25 | 57.92 |
| [`_STL_AddPatchName`](File-src-st-lib-ml-1845497584.md#function-function-stl-addpatchname-function-stl-addpatchname-patch-name-src-st-lib-ml-1876238914) | `src/st_lib.ml:114` | 22 | 18 | 5 | 5 | 2 | 615.42 | 50.51 |
| [`_STL_AsBool`](File-src-st-lib-ml-1845497584.md#function-function-stl-asbool-inline-function-stl-asbool-v-src-st-lib-ml-632075038) | `src/st_lib.ml:212` | 6 | 7 | 5 | 4 | 1 | 288.85 | 65.12 |
| [`_STL_DrawPatchHD`](File-src-st-lib-ml-1845497584.md#function-function-stl-drawpatchhd-function-stl-drawpatchhd-x-y-scrn-patch-src-st-lib-ml-72261712) | `src/st_lib.ml:177` | 7 | 7 | 4 | 3 | 1 | 349.77 | 63.22 |
| [`_STL_GetPatch`](File-src-st-lib-ml-1845497584.md#function-function-stl-getpatch-inline-function-stl-getpatch-patches-idx-src-st-lib-ml-1069829139) | `src/st_lib.ml:304` | 7 | 7 | 5 | 4 | 1 | 292.3 | 63.63 |
| [`_STL_GetRefValue`](File-src-st-lib-ml-1845497584.md#function-function-stl-getrefvalue-inline-function-stl-getrefvalue-refv-fallback-src-st-lib-ml-52715717) | `src/st_lib.ml:190` | 8 | 7 | 4 | 4 | 2 | 214.05 | 63.44 |
| [`_STL_IDiv`](File-src-st-lib-ml-1845497584.md#function-function-stl-idiv-inline-function-stl-idiv-a-b-src-st-lib-ml-1842179913) | `src/st_lib.ml:250` | 8 | 8 | 3 | 2 | 1 | 298.02 | 62.57 |
| [`_STL_NameForPatch`](File-src-st-lib-ml-1845497584.md#function-function-stl-nameforpatch-function-stl-nameforpatch-patch-src-st-lib-ml-762918611) | `src/st_lib.ml:160` | 9 | 8 | 5 | 5 | 2 | 285.29 | 61.32 |
| [`_STL_PatchHeight`](File-src-st-lib-ml-1845497584.md#function-function-stl-patchheight-inline-function-stl-patchheight-p-src-st-lib-ml-364529094) | `src/st_lib.ml:279` | 4 | 3 | 2 | 1 | 1 | 110.36 | 72.29 |
| [`_STL_PatchLeft`](File-src-st-lib-ml-1845497584.md#function-function-stl-patchleft-inline-function-stl-patchleft-p-src-st-lib-ml-1375170434) | `src/st_lib.ml:287` | 4 | 3 | 2 | 1 | 1 | 110.36 | 72.29 |
| [`_STL_PatchTop`](File-src-st-lib-ml-1845497584.md#function-function-stl-patchtop-inline-function-stl-patchtop-p-src-st-lib-ml-1300275712) | `src/st_lib.ml:295` | 4 | 3 | 2 | 1 | 1 | 110.36 | 72.29 |
| [`_STL_PatchWidth`](File-src-st-lib-ml-1845497584.md#function-function-stl-patchwidth-inline-function-stl-patchwidth-p-src-st-lib-ml-441552824) | `src/st_lib.ml:271` | 4 | 3 | 2 | 1 | 1 | 108 | 72.36 |
| [`_STL_RefBool`](File-src-st-lib-ml-1845497584.md#function-function-stl-refbool-inline-function-stl-refbool-refv-src-st-lib-ml-1557369461) | `src/st_lib.ml:222` | 3 | 1 | 1 | 0 | 0 | 64.53 | 76.79 |
| [`_STL_RefInt`](File-src-st-lib-ml-1845497584.md#function-function-stl-refint-inline-function-stl-refint-refv-fallback-src-st-lib-ml-2025081077) | `src/st_lib.ml:263` | 4 | 2 | 1 | 0 | 0 | 95.18 | 72.88 |
| [`_STL_SetRefValue`](File-src-st-lib-ml-1845497584.md#function-function-stl-setrefvalue-inline-function-stl-setrefvalue-refv-v-src-st-lib-ml-1052055715) | `src/st_lib.ml:203` | 5 | 2 | 3 | 2 | 1 | 144.95 | 69.22 |
| [`_STL_ToInt`](File-src-st-lib-ml-1845497584.md#function-function-stl-toint-function-stl-toint-v-fallback-src-st-lib-ml-555649543) | `src/st_lib.ml:231` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_TB_Trunc`](File-src-tables-ml-1959718242.md#function-function-tb-trunc-inline-function-tb-trunc-v-src-tables-ml-1670933924) | `src/tables.ml:96` | 6 | 3 | 2 | 1 | 1 | 134.89 | 67.84 |
| [`_toupperByte`](File-src-m-menu-ml-331716860.md#function-function-toupperbyte-inline-function-toupperbyte-c-src-m-menu-ml-1910171505) | `src/m_menu.ml:70` | 4 | 3 | 3 | 2 | 1 | 102.19 | 72.39 |
| [`_u16le`](File-src-v-video-ml-592999939.md#function-function-u16le-inline-function-u16le-b-off-src-v-video-ml-405757178) | `src/v_video.ml:180` | 3 | 1 | 1 | 0 | 0 | 104 | 75.33 |
| [`_u32`](File-src-m-fixed-ml-2129187227.md#function-function-u32-inline-function-u32-x-src-m-fixed-ml-1570500655) | `src/m_fixed.ml:42` | 18 | 14 | 7 | 8 | 2 | 573.45 | 52.36 |
| [`_u32le`](File-src-v-video-ml-592999939.md#function-function-u32le-inline-function-u32le-b-off-src-v-video-ml-999244766) | `src/v_video.ml:198` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`_W_AddCachedDataName`](File-src-w-wad-ml-893006035.md#function-function-w-addcacheddataname-function-w-addcacheddataname-data-name-src-w-wad-ml-1575708347) | `src/w_wad.ml:763` | 26 | 20 | 6 | 6 | 2 | 707.16 | 48.37 |
| [`_W_AddFilesFromArgv`](File-src-w-wad-ml-893006035.md#function-function-w-addfilesfromargv-function-w-addfilesfromargv-src-w-wad-ml-1344187434) | `src/w_wad.ml:500` | 43 | 31 | 15 | 28 | 4 | 1096.11 | 41.06 |
| [`_W_AddLoadedFile`](File-src-w-wad-ml-893006035.md#function-function-w-addloadedfile-inline-function-w-addloadedfile-path-data-src-w-wad-ml-209992992) | `src/w_wad.ml:374` | 5 | 3 | 1 | 0 | 0 | 133.98 | 69.72 |
| [`_W_CopyBytes`](File-src-w-wad-ml-893006035.md#function-function-w-copybytes-inline-function-w-copybytes-b-off-n-src-w-wad-ml-1096648412) | `src/w_wad.ml:118` | 3 | 1 | 1 | 0 | 0 | 75.28 | 76.32 |
| [`_W_ExtractFileBase`](File-src-w-wad-ml-893006035.md#function-function-w-extractfilebase-function-w-extractfilebase-path-src-w-wad-ml-1674049095) | `src/w_wad.ml:232` | 24 | 19 | 9 | 11 | 2 | 773.3 | 48.46 |
| [`_W_IntToString`](File-src-w-wad-ml-893006035.md#function-function-w-inttostring-function-w-inttostring-v-src-w-wad-ml-1516925708) | `src/w_wad.ml:300` | 28 | 26 | 14 | 22 | 2 | 977.05 | 45.61 |
| [`_W_IsHDWADData`](File-src-w-wad-ml-893006035.md#function-function-w-ishdwaddata-inline-function-w-ishdwaddata-data-src-w-wad-ml-30692211) | `src/w_wad.ml:224` | 4 | 3 | 3 | 2 | 1 | 267.19 | 69.47 |
| [`_W_IsWadFilename`](File-src-w-wad-ml-893006035.md#function-function-w-iswadfilename-inline-function-w-iswadfilename-path-src-w-wad-ml-665100150) | `src/w_wad.ml:205` | 13 | 16 | 10 | 9 | 1 | 797.68 | 54.04 |
| [`_W_Name8Equals`](File-src-w-wad-ml-893006035.md#function-function-w-name8equals-inline-function-w-name8equals-a-b-src-w-wad-ml-981933592) | `src/w_wad.ml:194` | 6 | 4 | 3 | 3 | 2 | 158.32 | 67.22 |
| [`_W_Name8FromString`](File-src-w-wad-ml-893006035.md#function-function-w-name8fromstring-inline-function-w-name8fromstring-name-src-w-wad-ml-870153724) | `src/w_wad.ml:157` | 11 | 9 | 3 | 2 | 1 | 315.77 | 59.38 |
| [`_W_Name8ToString`](File-src-w-wad-ml-893006035.md#function-function-w-name8tostring-function-w-name8tostring-name-src-w-wad-ml-1827580127) | `src/w_wad.ml:173` | 16 | 18 | 7 | 7 | 2 | 568.69 | 53.5 |
| [`_W_ReadI32LE`](File-src-w-wad-ml-893006035.md#function-function-w-readi32le-inline-function-w-readi32le-b-off-src-w-wad-ml-619466054) | `src/w_wad.ml:108` | 3 | 1 | 1 | 0 | 0 | 219.62 | 73.06 |
| [`_W_RememberCachedDataName`](File-src-w-wad-ml-893006035.md#function-function-w-remembercacheddataname-function-w-remembercacheddataname-data-name-src-w-wad-ml-429416021) | `src/w_wad.ml:843` | 17 | 13 | 7 | 9 | 3 | 462.96 | 53.55 |
| [`_W_SlotEmpty`](File-src-w-wad-ml-893006035.md#function-function-w-slotempty-inline-function-w-slotempty-slot-src-w-wad-ml-19577365) | `src/w_wad.ml:360` | 9 | 8 | 6 | 5 | 1 | 299.56 | 61.04 |
| [`_W_ToIntOr`](File-src-w-wad-ml-893006035.md#function-function-w-tointor-function-w-tointor-v-fallback-src-w-wad-ml-1249356050) | `src/w_wad.ml:333` | 23 | 16 | 8 | 9 | 2 | 584.85 | 49.84 |
| [`_W_ToPathString`](File-src-w-wad-ml-893006035.md#function-function-w-topathstring-inline-function-w-topathstring-v-src-w-wad-ml-745995529) | `src/w_wad.ml:287` | 9 | 5 | 3 | 2 | 1 | 148 | 63.58 |
| [`_W_ToUpperAscii`](File-src-w-wad-ml-893006035.md#function-function-w-toupperascii-inline-function-w-toupperascii-s-src-w-wad-ml-787921102) | `src/w_wad.ml:126` | 10 | 6 | 4 | 4 | 2 | 279.69 | 60.52 |
| [`_WI_Abs`](File-src-wi-stuff-ml-450049266.md#function-function-wi-abs-inline-function-wi-abs-v-src-wi-stuff-ml-2118089972) | `src/wi_stuff.ml:106` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`_WI_AnimDefault`](File-src-wi-stuff-ml-450049266.md#function-function-wi-animdefault-inline-function-wi-animdefault-src-wi-stuff-ml-1723076950) | `src/wi_stuff.ml:99` | 3 | 1 | 1 | 0 | 0 | 227.43 | 72.95 |
| [`_WI_CacheOrVoid`](File-src-wi-stuff-ml-450049266.md#function-function-wi-cacheorvoid-inline-function-wi-cacheorvoid-name-tag-src-wi-stuff-ml-108992609) | `src/wi_stuff.ml:217` | 8 | 6 | 3 | 3 | 2 | 221.65 | 63.47 |
| [`_WI_Clamp`](File-src-wi-stuff-ml-450049266.md#function-function-wi-clamp-inline-function-wi-clamp-v-lo-hi-src-wi-stuff-ml-1284802694) | `src/wi_stuff.ml:148` | 5 | 5 | 3 | 2 | 1 | 125.02 | 69.67 |
| [`_WI_DrawRowName`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawrowname-inline-function-wi-drawrowname-slot-x-y-src-wi-stuff-ml-376799871) | `src/wi_stuff.ml:841` | 8 | 6 | 3 | 2 | 1 | 209.59 | 63.64 |
| [`_WI_GetPlr`](File-src-wi-stuff-ml-450049266.md#function-function-wi-getplr-inline-function-wi-getplr-index-src-wi-stuff-ml-817295472) | `src/wi_stuff.ml:463` | 5 | 5 | 4 | 3 | 1 | 182.84 | 68.38 |
| [`_WI_GetPlrFrag`](File-src-wi-stuff-ml-450049266.md#function-function-wi-getplrfrag-inline-function-wi-getplrfrag-playernum-target-src-wi-stuff-ml-1022640426) | `src/wi_stuff.ml:488` | 6 | 6 | 5 | 4 | 1 | 325.48 | 64.76 |
| [`_WI_IDiv`](File-src-wi-stuff-ml-450049266.md#function-function-wi-idiv-inline-function-wi-idiv-a-b-src-wi-stuff-ml-127578497) | `src/wi_stuff.ml:134` | 8 | 8 | 3 | 2 | 1 | 305.53 | 62.5 |
| [`_WI_NumPixelWidth`](File-src-wi-stuff-ml-450049266.md#function-function-wi-numpixelwidth-function-wi-numpixelwidth-n-digits-src-wi-stuff-ml-1822355229) | `src/wi_stuff.ml:727` | 30 | 25 | 13 | 14 | 2 | 1027.63 | 44.94 |
| [`_WI_PatchH`](File-src-wi-stuff-ml-450049266.md#function-function-wi-patchh-inline-function-wi-patchh-p-src-wi-stuff-ml-1217550520) | `src/wi_stuff.ml:166` | 5 | 5 | 3 | 2 | 1 | 138.97 | 69.34 |
| [`_WI_PatchW`](File-src-wi-stuff-ml-450049266.md#function-function-wi-patchw-inline-function-wi-patchw-p-src-wi-stuff-ml-695726214) | `src/wi_stuff.ml:157` | 5 | 5 | 3 | 2 | 1 | 138.97 | 69.34 |
| [`_WI_PlayerIngame`](File-src-wi-stuff-ml-450049266.md#function-function-wi-playeringame-inline-function-wi-playeringame-index-src-wi-stuff-ml-1303973828) | `src/wi_stuff.ml:472` | 11 | 13 | 11 | 13 | 2 | 570.02 | 56.51 |
| [`_WI_PlayerRowName`](File-src-wi-stuff-ml-450049266.md#function-function-wi-playerrowname-function-wi-playerrowname-slot-src-wi-stuff-ml-1713287707) | `src/wi_stuff.ml:820` | 13 | 11 | 5 | 5 | 2 | 392.55 | 56.87 |
| [`_WI_Point`](File-src-wi-stuff-ml-450049266.md#function-function-wi-point-inline-function-wi-point-x-y-src-wi-stuff-ml-1883774227) | `src/wi_stuff.ml:93` | 3 | 1 | 1 | 0 | 0 | 58.81 | 77.07 |
| [`_WI_SafeDrawNamedPatch`](File-src-wi-stuff-ml-450049266.md#function-function-wi-safedrawnamedpatch-inline-function-wi-safedrawnamedpatch-x-y-patch-name-src-wi-stuff-ml-1779676888) | `src/wi_stuff.ml:190` | 12 | 10 | 7 | 11 | 3 | 520.19 | 56.5 |
| [`_WI_SafeDrawPatch`](File-src-wi-stuff-ml-450049266.md#function-function-wi-safedrawpatch-inline-function-wi-safedrawpatch-x-y-patch-src-wi-stuff-ml-1026425151) | `src/wi_stuff.ml:177` | 6 | 4 | 3 | 2 | 1 | 172.88 | 66.95 |
| [`_WI_SafeStartSound`](File-src-wi-stuff-ml-450049266.md#function-function-wi-safestartsound-inline-function-wi-safestartsound-origin-sfx-src-wi-stuff-ml-522615223) | `src/wi_stuff.ml:207` | 5 | 2 | 2 | 1 | 1 | 101.58 | 70.43 |
| [`_WI_Substr`](File-src-wi-stuff-ml-450049266.md#function-function-wi-substr-inline-function-wi-substr-s-n-src-wi-stuff-ml-1012277625) | `src/wi_stuff.ml:809` | 7 | 8 | 5 | 4 | 1 | 323.33 | 63.32 |
| [`_WI_TargetItems`](File-src-wi-stuff-ml-450049266.md#function-function-wi-targetitems-function-wi-targetitems-index-src-wi-stuff-ml-357332675) | `src/wi_stuff.ml:516` | 14 | 10 | 10 | 10 | 2 | 610.76 | 54.15 |
| [`_WI_TargetKills`](File-src-wi-stuff-ml-450049266.md#function-function-wi-targetkills-function-wi-targetkills-index-src-wi-stuff-ml-1506411389) | `src/wi_stuff.ml:498` | 14 | 10 | 10 | 10 | 2 | 610.76 | 54.15 |
| [`_WI_TargetPar`](File-src-wi-stuff-ml-450049266.md#function-function-wi-targetpar-inline-function-wi-targetpar-src-wi-stuff-ml-1776544438) | `src/wi_stuff.ml:563` | 4 | 3 | 3 | 2 | 1 | 158.32 | 71.06 |
| [`_WI_TargetSecrets`](File-src-wi-stuff-ml-450049266.md#function-function-wi-targetsecrets-function-wi-targetsecrets-index-src-wi-stuff-ml-1168188885) | `src/wi_stuff.ml:534` | 14 | 10 | 10 | 10 | 2 | 625.51 | 54.07 |
| [`_WI_TargetTime`](File-src-wi-stuff-ml-450049266.md#function-function-wi-targettime-inline-function-wi-targettime-index-src-wi-stuff-ml-153431048) | `src/wi_stuff.ml:552` | 8 | 6 | 7 | 6 | 1 | 410.34 | 61.06 |
| [`_WI_ToInt`](File-src-wi-stuff-ml-450049266.md#function-function-wi-toint-function-wi-toint-v-fallback-src-wi-stuff-ml-283881325) | `src/wi_stuff.ml:115` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`_wipeRand`](File-src-f-wipe-ml-1921092045.md#function-function-wiperand-inline-function-wiperand-src-f-wipe-ml-1026589449) | `src/f_wipe.ml:46` | 5 | 3 | 1 | 0 | 0 | 118.94 | 70.09 |
| [`_Z_Align4`](File-src-z-zone-ml-1788911354.md#function-function-z-align4-inline-function-z-align4-n-src-z-zone-ml-17595920) | `src/z_zone.ml:136` | 3 | 1 | 1 | 0 | 0 | 68.11 | 76.62 |
| [`_Z_AssignUser`](File-src-z-zone-ml-1788911354.md#function-function-z-assignuser-inline-function-z-assignuser-user-ptr-src-z-zone-ml-1340041787) | `src/z_zone.ml:206` | 5 | 2 | 3 | 2 | 1 | 144.95 | 69.22 |
| [`_Z_FindBlockByPtr`](File-src-z-zone-ml-1788911354.md#function-function-z-findblockbyptr-inline-function-z-findblockbyptr-ptr-src-z-zone-ml-2048263456) | `src/z_zone.ml:189` | 11 | 7 | 3 | 3 | 2 | 220.08 | 60.48 |
| [`_Z_Get`](File-src-z-zone-ml-1788911354.md#function-function-z-get-inline-function-z-get-i-src-z-zone-ml-1213111117) | `src/z_zone.ml:92` | 8 | 8 | 7 | 7 | 2 | 333.73 | 61.69 |
| [`_Z_IsFree`](File-src-z-zone-ml-1788911354.md#function-function-z-isfree-inline-function-z-isfree-i-src-z-zone-ml-2050730483) | `src/z_zone.ml:115` | 4 | 2 | 1 | 0 | 0 | 92 | 72.98 |
| [`_Z_LinkAfter`](File-src-z-zone-ml-1788911354.md#function-function-z-linkafter-inline-function-z-linkafter-aidx-bidx-src-z-zone-ml-583217041) | `src/z_zone.ml:144` | 13 | 11 | 1 | 0 | 0 | 301.6 | 58.2 |
| [`_Z_NewBlock`](File-src-z-zone-ml-1788911354.md#function-function-z-newblock-inline-function-z-newblock-start-size-user-tag-id-next-prev-src-z-zone-ml-160527891) | `src/z_zone.ml:129` | 3 | 1 | 1 | 0 | 0 | 148 | 74.26 |
| [`_Z_Set`](File-src-z-zone-ml-1788911354.md#function-function-z-set-inline-function-z-set-i-b-src-z-zone-ml-883917049) | `src/z_zone.ml:105` | 6 | 7 | 5 | 4 | 1 | 246.12 | 65.61 |
| [`_Z_Unlink`](File-src-z-zone-ml-1788911354.md#function-function-z-unlink-inline-function-z-unlink-i-src-z-zone-ml-133492951) | `src/z_zone.ml:166` | 14 | 12 | 1 | 0 | 0 | 319.82 | 57.32 |
| [`A_BabyMetal`](File-src-p-enemy-ml-1875479956.md#function-function-a-babymetal-function-a-babymetal-mo-src-p-enemy-ml-264551041) | `src/p_enemy.ml:1442` | 4 | 2 | 1 | 0 | 0 | 68.11 | 73.9 |
| [`A_BFGsound`](File-src-p-pspr-ml-844718747.md#function-function-a-bfgsound-function-a-bfgsound-player-psp-src-p-pspr-ml-1414761340) | `src/p_pspr.ml:934` | 5 | 4 | 2 | 1 | 1 | 127.44 | 69.74 |
| [`A_BFGSpray`](File-src-p-pspr-ml-844718747.md#function-function-a-bfgspray-function-a-bfgspray-mo-src-p-pspr-ml-1061472450) | `src/p_pspr.ml:943` | 26 | 21 | 8 | 11 | 2 | 990.93 | 47.08 |
| [`A_BossDeath`](File-src-p-enemy-ml-1875479956.md#function-function-a-bossdeath-function-a-bossdeath-mo-src-p-enemy-ml-1366931721) | `src/p_enemy.ml:1325` | 87 | 63 | 38 | 65 | 4 | 2583.13 | 28.69 |
| [`A_BrainAwake`](File-src-p-enemy-ml-1875479956.md#function-function-a-brainawake-function-a-brainawake-mo-src-p-enemy-ml-1277683087) | `src/p_enemy.ml:1481` | 21 | 16 | 6 | 8 | 3 | 532.19 | 51.26 |
| [`A_BrainDie`](File-src-p-enemy-ml-1875479956.md#function-function-a-braindie-function-a-braindie-mo-src-p-enemy-ml-479458515) | `src/p_enemy.ml:1552` | 4 | 3 | 2 | 1 | 1 | 85.11 | 73.08 |
| [`A_BrainExplode`](File-src-p-enemy-ml-1875479956.md#function-function-a-brainexplode-function-a-brainexplode-mo-src-p-enemy-ml-544424995) | `src/p_enemy.ml:1537` | 12 | 13 | 4 | 3 | 1 | 613.11 | 56.4 |
| [`A_BrainPain`](File-src-p-enemy-ml-1875479956.md#function-function-a-brainpain-function-a-brainpain-mo-src-p-enemy-ml-670665675) | `src/p_enemy.ml:1508` | 4 | 2 | 1 | 0 | 0 | 66.61 | 73.96 |
| [`A_BrainScream`](File-src-p-enemy-ml-1875479956.md#function-function-a-brainscream-function-a-brainscream-mo-src-p-enemy-ml-265427341) | `src/p_enemy.ml:1515` | 17 | 15 | 5 | 7 | 3 | 767.78 | 52.28 |
| [`A_BrainSpit`](File-src-p-enemy-ml-1875479956.md#function-function-a-brainspit-function-a-brainspit-mo-src-p-enemy-ml-891514255) | `src/p_enemy.ml:1559` | 28 | 26 | 14 | 13 | 1 | 1219.54 | 44.94 |
| [`A_BruisAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-bruisattack-function-a-bruisattack-actor-src-p-enemy-ml-1236799230) | `src/p_enemy.ml:834` | 10 | 8 | 4 | 3 | 1 | 385 | 59.54 |
| [`A_BspiAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-bspiattack-function-a-bspiattack-actor-src-p-enemy-ml-1881790900) | `src/p_enemy.ml:780` | 5 | 4 | 3 | 2 | 1 | 157.17 | 68.97 |
| [`A_Chase`](File-src-p-enemy-ml-1875479956.md#function-function-a-chase-function-a-chase-actor-src-p-enemy-ml-402784232) | `src/p_enemy.ml:629` | 60 | 45 | 38 | 47 | 3 | 3101.95 | 31.65 |
| [`A_CheckReload`](File-src-p-pspr-ml-844718747.md#function-function-a-checkreload-function-a-checkreload-player-psp-src-p-pspr-ml-2053285582) | `src/p_pspr.ml:634` | 5 | 4 | 2 | 1 | 1 | 93.77 | 70.68 |
| [`A_CloseShotgun2`](File-src-p-enemy-ml-1875479956.md#function-function-a-closeshotgun2-function-a-closeshotgun2-player-psp-src-p-enemy-ml-671068709) | `src/p_enemy.ml:1470` | 8 | 4 | 4 | 3 | 1 | 226.18 | 63.28 |
| [`A_CPosAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-cposattack-function-a-cposattack-actor-src-p-enemy-ml-1155549244) | `src/p_enemy.ml:745` | 10 | 9 | 3 | 2 | 1 | 479.27 | 59.01 |
| [`A_CPosRefire`](File-src-p-enemy-ml-1875479956.md#function-function-a-cposrefire-function-a-cposrefire-actor-src-p-enemy-ml-2139858900) | `src/p_enemy.ml:758` | 8 | 8 | 7 | 7 | 2 | 370.88 | 61.37 |
| [`A_CyberAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-cyberattack-function-a-cyberattack-actor-src-p-enemy-ml-967729894) | `src/p_enemy.ml:826` | 5 | 4 | 3 | 2 | 1 | 157.17 | 68.97 |
| [`A_Explode`](File-src-p-enemy-ml-1875479956.md#function-function-a-explode-function-a-explode-thingy-src-p-enemy-ml-516321202) | `src/p_enemy.ml:1315` | 6 | 4 | 3 | 2 | 1 | 148.68 | 67.41 |
| [`A_FaceTarget`](File-src-p-enemy-ml-1875479956.md#function-function-a-facetarget-function-a-facetarget-actor-src-p-enemy-ml-1350337244) | `src/p_enemy.ml:704` | 9 | 8 | 5 | 4 | 1 | 559.62 | 59.27 |
| [`A_Fall`](File-src-p-enemy-ml-1875479956.md#function-function-a-fall-function-a-fall-actor-src-p-enemy-ml-1408647940) | `src/p_enemy.ml:561` | 4 | 3 | 2 | 1 | 1 | 120.93 | 72.02 |
| [`A_FatAttack1`](File-src-p-enemy-ml-1875479956.md#function-function-a-fatattack1-function-a-fatattack1-actor-src-p-enemy-ml-32663876) | `src/p_enemy.ml:1127` | 15 | 14 | 6 | 6 | 2 | 791.62 | 53.24 |
| [`A_FatAttack2`](File-src-p-enemy-ml-1875479956.md#function-function-a-fatattack2-function-a-fatattack2-actor-src-p-enemy-ml-1073575896) | `src/p_enemy.ml:1146` | 15 | 14 | 6 | 6 | 2 | 811.96 | 53.17 |
| [`A_FatAttack3`](File-src-p-enemy-ml-1875479956.md#function-function-a-fatattack3-function-a-fatattack3-actor-src-p-enemy-ml-1122802460) | `src/p_enemy.ml:1165` | 22 | 21 | 9 | 10 | 2 | 1275.94 | 47.76 |
| [`A_FatRaise`](File-src-p-enemy-ml-1875479956.md#function-function-a-fatraise-function-a-fatraise-actor-src-p-enemy-ml-1156702704) | `src/p_enemy.ml:1119` | 5 | 4 | 2 | 1 | 1 | 110.36 | 70.18 |
| [`A_Fire`](File-src-p-enemy-ml-1875479956.md#function-function-a-fire-function-a-fire-actor-src-p-enemy-ml-1003134652) | `src/p_enemy.ml:1058` | 13 | 15 | 5 | 4 | 1 | 613.11 | 55.51 |
| [`A_FireBFG`](File-src-p-pspr-ml-844718747.md#function-function-a-firebfg-function-a-firebfg-player-psp-src-p-pspr-ml-498932770) | `src/p_pspr.ml:920` | 10 | 9 | 5 | 4 | 1 | 401.29 | 59.28 |
| [`A_FireCGun`](File-src-p-pspr-ml-844718747.md#function-function-a-firecgun-function-a-firecgun-player-psp-src-p-pspr-ml-1107191108) | `src/p_pspr.ml:854` | 25 | 21 | 10 | 10 | 2 | 1150.49 | 46.73 |
| [`A_FireCrackle`](File-src-p-enemy-ml-1875479956.md#function-function-a-firecrackle-function-a-firecrackle-actor-src-p-enemy-ml-2128786222) | `src/p_enemy.ml:1050` | 5 | 4 | 2 | 1 | 1 | 110.36 | 70.18 |
| [`A_FireMissile`](File-src-p-pspr-ml-844718747.md#function-function-a-firemissile-function-a-firemissile-player-psp-src-p-pspr-ml-598510132) | `src/p_pspr.ml:888` | 10 | 9 | 5 | 4 | 1 | 401.29 | 59.28 |
| [`A_FirePistol`](File-src-p-pspr-ml-844718747.md#function-function-a-firepistol-function-a-firepistol-player-psp-src-p-pspr-ml-1609164352) | `src/p_pspr.ml:775` | 15 | 14 | 5 | 4 | 1 | 720.64 | 53.66 |
| [`A_FirePlasma`](File-src-p-pspr-ml-844718747.md#function-function-a-fireplasma-function-a-fireplasma-player-psp-src-p-pspr-ml-614841636) | `src/p_pspr.ml:902` | 12 | 11 | 5 | 4 | 1 | 554.97 | 56.57 |
| [`A_FireShotgun`](File-src-p-pspr-ml-844718747.md#function-function-a-fireshotgun-function-a-fireshotgun-player-psp-src-p-pspr-ml-1277193936) | `src/p_pspr.ml:798` | 19 | 17 | 6 | 5 | 1 | 793.06 | 51 |
| [`A_FireShotgun2`](File-src-p-pspr-ml-844718747.md#function-function-a-fireshotgun2-function-a-fireshotgun2-player-psp-src-p-pspr-ml-401862336) | `src/p_pspr.ml:825` | 22 | 20 | 6 | 5 | 1 | 1182.41 | 48.39 |
| [`A_GunFlash`](File-src-p-pspr-ml-844718747.md#function-function-a-gunflash-function-a-gunflash-player-psp-src-p-pspr-ml-1125230964) | `src/p_pspr.ml:685` | 10 | 9 | 5 | 4 | 1 | 358.2 | 59.63 |
| [`A_HeadAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-headattack-function-a-headattack-actor-src-p-enemy-ml-438363492) | `src/p_enemy.ml:813` | 10 | 8 | 4 | 3 | 1 | 358.2 | 59.76 |
| [`A_Hoof`](File-src-p-enemy-ml-1875479956.md#function-function-a-hoof-function-a-hoof-mo-src-p-enemy-ml-421290175) | `src/p_enemy.ml:1428` | 4 | 2 | 1 | 0 | 0 | 68.11 | 73.9 |
| [`A_KeenDie`](File-src-p-enemy-ml-1875479956.md#function-function-a-keendie-function-a-keendie-mo-src-p-enemy-ml-1327958005) | `src/p_enemy.ml:568` | 7 | 7 | 3 | 2 | 1 | 208.08 | 64.93 |
| [`A_Light0`](File-src-p-pspr-ml-844718747.md#function-function-a-light0-function-a-light0-player-psp-src-p-pspr-ml-924287496) | `src/p_pspr.ml:980` | 5 | 4 | 2 | 1 | 1 | 102.19 | 70.41 |
| [`A_Light1`](File-src-p-pspr-ml-844718747.md#function-function-a-light1-function-a-light1-player-psp-src-p-pspr-ml-563439452) | `src/p_pspr.ml:989` | 5 | 4 | 2 | 1 | 1 | 102.19 | 70.41 |
| [`A_Light2`](File-src-p-pspr-ml-844718747.md#function-function-a-light2-function-a-light2-player-psp-src-p-pspr-ml-171472604) | `src/p_pspr.ml:998` | 5 | 4 | 2 | 1 | 1 | 102.19 | 70.41 |
| [`A_LoadShotgun2`](File-src-p-enemy-ml-1875479956.md#function-function-a-loadshotgun2-function-a-loadshotgun2-player-psp-src-p-enemy-ml-733555045) | `src/p_enemy.ml:1460` | 6 | 6 | 3 | 2 | 1 | 169.92 | 67.01 |
| [`A_Look`](File-src-p-enemy-ml-1875479956.md#function-function-a-look-function-a-look-actor-src-p-enemy-ml-1943150700) | `src/p_enemy.ml:581` | 37 | 27 | 22 | 27 | 3 | 1724.81 | 40.17 |
| [`A_Lower`](File-src-p-pspr-ml-844718747.md#function-function-a-lower-function-a-lower-player-psp-src-p-pspr-ml-1774162906) | `src/p_pspr.ml:644` | 19 | 15 | 6 | 5 | 1 | 532.5 | 52.21 |
| [`A_Metal`](File-src-p-enemy-ml-1875479956.md#function-function-a-metal-function-a-metal-mo-src-p-enemy-ml-1753458177) | `src/p_enemy.ml:1435` | 4 | 2 | 1 | 0 | 0 | 68.11 | 73.9 |
| [`A_OpenShotgun2`](File-src-p-enemy-ml-1875479956.md#function-function-a-openshotgun2-function-a-openshotgun2-player-psp-src-p-enemy-ml-1740103801) | `src/p_enemy.ml:1450` | 6 | 6 | 3 | 2 | 1 | 169.92 | 67.01 |
| [`A_Pain`](File-src-p-enemy-ml-1875479956.md#function-function-a-pain-function-a-pain-actor-src-p-enemy-ml-1469000624) | `src/p_enemy.ml:1306` | 6 | 4 | 5 | 4 | 1 | 236.35 | 65.73 |
| [`A_PainAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-painattack-function-a-painattack-actor-src-p-enemy-ml-974460048) | `src/p_enemy.ml:1261` | 5 | 4 | 3 | 2 | 1 | 137.61 | 69.37 |
| [`A_PainDie`](File-src-p-enemy-ml-1875479956.md#function-function-a-paindie-function-a-paindie-actor-src-p-enemy-ml-1411442724) | `src/p_enemy.ml:1269` | 7 | 6 | 2 | 1 | 1 | 211.77 | 65.01 |
| [`A_PainShootSkull`](File-src-p-enemy-ml-1875479956.md#function-function-a-painshootskull-function-a-painshootskull-actor-angle-src-p-enemy-ml-751248139) | `src/p_enemy.ml:1255` | 3 | 1 | 1 | 0 | 0 | 47.55 | 77.71 |
| [`A_PlayerScream`](File-src-p-enemy-ml-1875479956.md#function-function-a-playerscream-function-a-playerscream-mo-src-p-enemy-ml-2068832627) | `src/p_enemy.ml:1663` | 8 | 6 | 4 | 3 | 1 | 213.97 | 63.44 |
| [`A_PosAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-posattack-function-a-posattack-actor-src-p-enemy-ml-623318456) | `src/p_enemy.ml:716` | 10 | 9 | 3 | 2 | 1 | 475.63 | 59.04 |
| [`A_Punch`](File-src-p-pspr-ml-844718747.md#function-function-a-punch-function-a-punch-player-psp-src-p-pspr-ml-72189828) | `src/p_pspr.ml:699` | 20 | 16 | 9 | 9 | 2 | 1115.8 | 49.07 |
| [`A_Raise`](File-src-p-pspr-ml-844718747.md#function-function-a-raise-function-a-raise-player-psp-src-p-pspr-ml-589110452) | `src/p_pspr.ml:671` | 9 | 10 | 5 | 4 | 1 | 337.6 | 60.81 |
| [`A_ReFire`](File-src-p-pspr-ml-844718747.md#function-function-a-refire-function-a-refire-player-psp-src-p-pspr-ml-1243259212) | `src/p_pspr.ml:613` | 15 | 11 | 7 | 6 | 1 | 497.54 | 54.52 |
| [`A_SargAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-sargattack-function-a-sargattack-actor-src-p-enemy-ml-397434868) | `src/p_enemy.ml:802` | 8 | 6 | 4 | 3 | 1 | 285.29 | 62.57 |
| [`A_Saw`](File-src-p-pspr-ml-844718747.md#function-function-a-saw-function-a-saw-player-psp-src-p-pspr-ml-866454506) | `src/p_pspr.ml:729` | 34 | 26 | 9 | 13 | 3 | 1566.75 | 43.01 |
| [`A_Scream`](File-src-p-enemy-ml-1875479956.md#function-function-a-scream-function-a-scream-actor-src-p-enemy-ml-800727680) | `src/p_enemy.ml:1279` | 16 | 12 | 13 | 12 | 1 | 750.53 | 51.85 |
| [`A_SkelFist`](File-src-p-enemy-ml-1875479956.md#function-function-a-skelfist-function-a-skelfist-actor-src-p-enemy-ml-1350978016) | `src/p_enemy.ml:929` | 9 | 7 | 4 | 3 | 1 | 333.67 | 60.98 |
| [`A_SkelMissile`](File-src-p-enemy-ml-1875479956.md#function-function-a-skelmissile-function-a-skelmissile-actor-src-p-enemy-ml-1543460206) | `src/p_enemy.ml:848` | 12 | 10 | 4 | 3 | 1 | 494.35 | 57.06 |
| [`A_SkelWhoosh`](File-src-p-enemy-ml-1875479956.md#function-function-a-skelwhoosh-function-a-skelwhoosh-actor-src-p-enemy-ml-1100162812) | `src/p_enemy.ml:921` | 5 | 4 | 3 | 2 | 1 | 140.18 | 69.32 |
| [`A_SkullAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-skullattack-function-a-skullattack-actor-src-p-enemy-ml-1949735670) | `src/p_enemy.ml:1192` | 15 | 14 | 7 | 6 | 1 | 1033.71 | 52.3 |
| [`A_SpawnFly`](File-src-p-enemy-ml-1875479956.md#function-function-a-spawnfly-function-a-spawnfly-mo-src-p-enemy-ml-1524945083) | `src/p_enemy.ml:1599` | 47 | 32 | 17 | 19 | 3 | 1680.34 | 38.65 |
| [`A_SpawnSound`](File-src-p-enemy-ml-1875479956.md#function-function-a-spawnsound-function-a-spawnsound-mo-src-p-enemy-ml-37339459) | `src/p_enemy.ml:1655` | 4 | 2 | 1 | 0 | 0 | 68.11 | 73.9 |
| [`A_SpidRefire`](File-src-p-enemy-ml-1875479956.md#function-function-a-spidrefire-function-a-spidrefire-actor-src-p-enemy-ml-56669504) | `src/p_enemy.ml:769` | 8 | 8 | 7 | 7 | 2 | 370.88 | 61.37 |
| [`A_SPosAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-sposattack-function-a-sposattack-actor-src-p-enemy-ml-828407708) | `src/p_enemy.ml:729` | 12 | 10 | 4 | 3 | 1 | 539.23 | 56.79 |
| [`A_StartFire`](File-src-p-enemy-ml-1875479956.md#function-function-a-startfire-function-a-startfire-actor-src-p-enemy-ml-4128964) | `src/p_enemy.ml:1042` | 5 | 4 | 2 | 1 | 1 | 110.36 | 70.18 |
| [`A_Tracer`](File-src-p-enemy-ml-1875479956.md#function-function-a-tracer-function-a-tracer-actor-src-p-enemy-ml-1398278016) | `src/p_enemy.ml:864` | 47 | 43 | 18 | 23 | 3 | 2566.69 | 37.23 |
| [`A_TroopAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-troopattack-function-a-troopattack-actor-src-p-enemy-ml-220725572) | `src/p_enemy.ml:788` | 11 | 9 | 4 | 3 | 1 | 408.6 | 58.46 |
| [`A_VileAttack`](File-src-p-enemy-ml-1875479956.md#function-function-a-vileattack-function-a-vileattack-actor-src-p-enemy-ml-190774116) | `src/p_enemy.ml:1093` | 18 | 18 | 8 | 7 | 1 | 1116.45 | 50.2 |
| [`A_VileChase`](File-src-p-enemy-ml-1875479956.md#function-function-a-vilechase-function-a-vilechase-actor-src-p-enemy-ml-375948540) | `src/p_enemy.ml:981` | 44 | 37 | 8 | 22 | 6 | 1612 | 40.62 |
| [`A_VileStart`](File-src-p-enemy-ml-1875479956.md#function-function-a-vilestart-function-a-vilestart-actor-src-p-enemy-ml-1552077500) | `src/p_enemy.ml:1035` | 4 | 3 | 2 | 1 | 1 | 92 | 72.85 |
| [`A_VileTarget`](File-src-p-enemy-ml-1875479956.md#function-function-a-viletarget-function-a-viletarget-actor-src-p-enemy-ml-930643528) | `src/p_enemy.ml:1077` | 10 | 10 | 4 | 3 | 1 | 371.51 | 59.65 |
| [`A_WeaponReady`](File-src-p-pspr-ml-844718747.md#function-function-a-weaponready-function-a-weaponready-player-psp-src-p-pspr-ml-1879350942) | `src/p_pspr.ml:560` | 41 | 29 | 24 | 26 | 2 | 2098.49 | 38.33 |
| [`A_XScream`](File-src-p-enemy-ml-1875479956.md#function-function-a-xscream-function-a-xscream-actor-src-p-enemy-ml-1914016882) | `src/p_enemy.ml:1300` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`abs`](File-src-stdlib-ml-366721133.md#function-function-abs-inline-function-abs-x-src-stdlib-ml-1036888773) | `src/stdlib.ml:23` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`addsfx`](File-src-i-sound-ml-33806980.md#function-function-addsfx-function-addsfx-sfxid-volume-step-seperation-src-i-sound-ml-1292713171) | `src/i_sound.ml:1856` | 24 | 26 | 5 | 4 | 1 | 1094.48 | 47.94 |
| [`AM_activateNewScale`](File-src-am-map-ml-1409794280.md#function-function-am-activatenewscale-function-am-activatenewscale-src-am-map-ml-1047704837) | `src/am_map.ml:433` | 16 | 14 | 1 | 0 | 0 | 351.39 | 55.77 |
| [`AM_addMark`](File-src-am-map-ml-1409794280.md#function-function-am-addmark-function-am-addmark-src-am-map-ml-1060519389) | `src/am_map.ml:482` | 16 | 12 | 3 | 3 | 2 | 473.13 | 54.6 |
| [`AM_changeWindowLoc`](File-src-am-map-ml-1409794280.md#function-function-am-changewindowloc-function-am-changewindowloc-src-am-map-ml-441067149) | `src/am_map.ml:549` | 17 | 18 | 8 | 7 | 1 | 552.2 | 52.88 |
| [`AM_changeWindowScale`](File-src-am-map-ml-1409794280.md#function-function-am-changewindowscale-function-am-changewindowscale-src-am-map-ml-30037877) | `src/am_map.ml:723` | 9 | 8 | 2 | 1 | 1 | 221.65 | 62.49 |
| [`AM_clearFB`](File-src-am-map-ml-1409794280.md#function-function-am-clearfb-function-am-clearfb-src-am-map-ml-237434137) | `src/am_map.ml:774` | 16 | 15 | 11 | 13 | 3 | 607.82 | 52.76 |
| [`AM_clearMarks`](File-src-am-map-ml-1409794280.md#function-function-am-clearmarks-function-am-clearmarks-src-am-map-ml-1593372081) | `src/am_map.ml:651` | 11 | 8 | 2 | 1 | 1 | 197.65 | 60.94 |
| [`AM_clipMline`](File-src-am-map-ml-1409794280.md#function-function-am-clipmline-function-am-clipmline-ml-fl-src-am-map-ml-1038252760) | `src/am_map.ml:795` | 14 | 15 | 11 | 10 | 1 | 775.49 | 53.29 |
| [`AM_doFollowPlayer`](File-src-am-map-ml-1409794280.md#function-function-am-dofollowplayer-function-am-dofollowplayer-src-am-map-ml-33969829) | `src/am_map.ml:735` | 15 | 13 | 5 | 4 | 1 | 530.1 | 54.6 |
| [`AM_drawCrosshair`](File-src-am-map-ml-1409794280.md#function-function-am-drawcrosshair-function-am-drawcrosshair-color-src-am-map-ml-566215142) | `src/am_map.ml:994` | 9 | 7 | 1 | 0 | 0 | 324.14 | 61.47 |
| [`AM_Drawer`](File-src-am-map-ml-1409794280.md#function-function-am-drawer-function-am-drawer-src-am-map-ml-1458462425) | `src/am_map.ml:1108` | 11 | 10 | 2 | 1 | 1 | 247.76 | 60.25 |
| [`AM_drawFline`](File-src-am-map-ml-1409794280.md#function-function-am-drawfline-function-am-drawfline-fl-color-src-am-map-ml-843340756) | `src/am_map.ml:816` | 27 | 26 | 9 | 11 | 2 | 857.35 | 47.03 |
| [`AM_drawGrid`](File-src-am-map-ml-1409794280.md#function-function-am-drawgrid-function-am-drawgrid-color-src-am-map-ml-89985676) | `src/am_map.ml:859` | 17 | 15 | 5 | 4 | 1 | 570.02 | 53.19 |
| [`AM_drawLineCharacter`](File-src-am-map-ml-1409794280.md#function-function-am-drawlinecharacter-function-am-drawlinecharacter-lineset-count-scale-angle-color-x-y-src-am-map-ml-640930311) | `src/am_map.ml:933` | 16 | 13 | 5 | 5 | 2 | 983.04 | 52.11 |
| [`AM_drawMarks`](File-src-am-map-ml-1409794280.md#function-function-am-drawmarks-function-am-drawmarks-src-am-map-ml-618684613) | `src/am_map.ml:978` | 13 | 12 | 5 | 5 | 2 | 515.24 | 56.04 |
| [`AM_drawMline`](File-src-am-map-ml-1409794280.md#function-function-am-drawmline-function-am-drawmline-ml-color-src-am-map-ml-649283323) | `src/am_map.ml:850` | 6 | 3 | 2 | 1 | 1 | 148 | 67.56 |
| [`AM_drawPlayers`](File-src-am-map-ml-1409794280.md#function-function-am-drawplayers-function-am-drawplayers-src-am-map-ml-1340983441) | `src/am_map.ml:951` | 13 | 12 | 3 | 2 | 1 | 1048.42 | 54.15 |
| [`AM_drawThings`](File-src-am-map-ml-1409794280.md#function-function-am-drawthings-function-am-drawthings-color-radius-src-am-map-ml-1881583208) | `src/am_map.ml:971` | 4 | 2 | 1 | 0 | 0 | 47.55 | 74.99 |
| [`AM_drawWalls`](File-src-am-map-ml-1409794280.md#function-function-am-drawwalls-function-am-drawwalls-src-am-map-ml-959674961) | `src/am_map.ml:882` | 25 | 16 | 12 | 17 | 2 | 826.57 | 47.46 |
| [`AM_findMinMaxBoundaries`](File-src-am-map-ml-1409794280.md#function-function-am-findminmaxboundaries-function-am-findminmaxboundaries-src-am-map-ml-1319293921) | `src/am_map.ml:501` | 41 | 48 | 14 | 22 | 3 | 1636.12 | 40.43 |
| [`AM_getIslope`](File-src-am-map-ml-1409794280.md#function-function-am-getislope-function-am-getislope-ml-sl-src-am-map-ml-927988067) | `src/am_map.ml:416` | 15 | 14 | 7 | 8 | 2 | 599.46 | 53.95 |
| [`AM_initVariables`](File-src-am-map-ml-1409794280.md#function-function-am-initvariables-function-am-initvariables-src-am-map-ml-1580855553) | `src/am_map.ml:572` | 51 | 45 | 6 | 5 | 1 | 1292.06 | 40.16 |
| [`AM_LevelInit`](File-src-am-map-ml-1409794280.md#function-function-am-levelinit-function-am-levelinit-src-am-map-ml-1984030733) | `src/am_map.ml:664` | 17 | 15 | 1 | 0 | 0 | 218.51 | 56.64 |
| [`AM_loadPics`](File-src-am-map-ml-1409794280.md#function-function-am-loadpics-function-am-loadpics-src-am-map-ml-2118969033) | `src/am_map.ml:630` | 13 | 8 | 4 | 4 | 2 | 322.02 | 57.6 |
| [`AM_maxOutWindowScale`](File-src-am-map-ml-1409794280.md#function-function-am-maxoutwindowscale-function-am-maxoutwindowscale-src-am-map-ml-160827861) | `src/am_map.ml:712` | 8 | 7 | 2 | 1 | 1 | 144.43 | 64.91 |
| [`AM_minOutWindowScale`](File-src-am-map-ml-1409794280.md#function-function-am-minoutwindowscale-function-am-minoutwindowscale-src-am-map-ml-877490805) | `src/am_map.ml:702` | 8 | 7 | 2 | 1 | 1 | 144.43 | 64.91 |
| [`AM_Responder`](File-src-am-map-ml-1409794280.md#function-function-am-responder-function-am-responder-ev-src-am-map-ml-311245636) | `src/am_map.ml:1006` | 72 | 79 | 31 | 53 | 3 | 2578.25 | 31.43 |
| [`AM_restoreScaleAndLoc`](File-src-am-map-ml-1409794280.md#function-function-am-restorescaleandloc-function-am-restorescaleandloc-src-am-map-ml-1499514873) | `src/am_map.ml:463` | 17 | 14 | 3 | 2 | 1 | 247.59 | 55.99 |
| [`AM_rotate`](File-src-am-map-ml-1409794280.md#function-function-am-rotate-function-am-rotate-x-y-a-src-am-map-ml-601884461) | `src/am_map.ml:915` | 9 | 6 | 3 | 2 | 1 | 465 | 60.1 |
| [`AM_saveScaleAndLoc`](File-src-am-map-ml-1409794280.md#function-function-am-savescaleandloc-function-am-savescaleandloc-src-am-map-ml-338263233) | `src/am_map.ml:451` | 10 | 8 | 1 | 0 | 0 | 101.58 | 64 |
| [`AM_Start`](File-src-am-map-ml-1409794280.md#function-function-am-start-function-am-start-src-am-map-ml-1671233489) | `src/am_map.ml:685` | 14 | 11 | 4 | 3 | 1 | 299.32 | 57.12 |
| [`AM_Stop`](File-src-am-map-ml-1409794280.md#function-function-am-stop-function-am-stop-src-am-map-ml-1533456511) | `src/am_map.ml:1122` | 12 | 10 | 3 | 2 | 1 | 259.6 | 59.15 |
| [`AM_Ticker`](File-src-am-map-ml-1409794280.md#function-function-am-ticker-function-am-ticker-src-am-map-ml-116236767) | `src/am_map.ml:1090` | 15 | 11 | 6 | 5 | 1 | 296.34 | 56.23 |
| [`AM_unloadPics`](File-src-am-map-ml-1409794280.md#function-function-am-unloadpics-function-am-unloadpics-src-am-map-ml-735063475) | `src/am_map.ml:645` | 4 | 2 | 1 | 0 | 0 | 39.86 | 75.53 |
| [`AM_updateLightLev`](File-src-am-map-ml-1409794280.md#function-function-am-updatelightlev-function-am-updatelightlev-src-am-map-ml-563355083) | `src/am_map.ml:752` | 4 | 2 | 1 | 0 | 0 | 43.19 | 75.28 |
| [`asByte`](File-src-doomtype-ml-372549946.md#function-function-asbyte-inline-function-asbyte-x-src-doomtype-ml-1417310256) | `src/doomtype.ml:46` | 3 | 1 | 1 | 0 | 0 | 39.86 | 78.25 |
| [`BindToLocalPort`](File-src-i-net-ml-1331775872.md#function-function-bindtolocalport-function-bindtolocalport-sock-port-src-i-net-ml-852378268) | `src/i_net.ml:410` | 5 | 3 | 1 | 0 | 0 | 58.81 | 72.23 |
| [`CCMD_DirectCheatResponder`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-directcheatresponder-function-ccmd-directcheatresponder-ev-src-console-cmd-ml-385065507) | `src/console_cmd.ml:371` | 31 | 34 | 24 | 24 | 2 | 1894.12 | 41.29 |
| [`CCMD_Execute`](File-src-console-cmd-ml-361086087.md#function-function-ccmd-execute-function-ccmd-execute-line-src-console-cmd-ml-1143111138) | `src/console_cmd.ml:337` | 29 | 38 | 18 | 17 | 1 | 1798.17 | 42.89 |
| [`CheckAbort`](File-src-d-net-ml-529296669.md#function-function-checkabort-function-checkabort-src-d-net-ml-1671598574) | `src/d_net.ml:7243` | 17 | 16 | 10 | 13 | 3 | 747.94 | 51.69 |
| [`cht_CheckCheat`](File-src-m-cheat-ml-440987496.md#function-function-cht-checkcheat-function-cht-checkcheat-cht-key-src-m-cheat-ml-631019231) | `src/m_cheat.ml:109` | 27 | 24 | 10 | 9 | 1 | 1019.15 | 46.37 |
| [`cht_GetParam`](File-src-m-cheat-ml-440987496.md#function-function-cht-getparam-function-cht-getparam-cht-buffer-src-m-cheat-ml-130818006) | `src/m_cheat.ml:188` | 29 | 28 | 11 | 13 | 2 | 944.53 | 45.79 |
| [`createnullcursor`](File-src-i-video-ml-140536292.md#function-function-createnullcursor-function-createnullcursor-src-i-video-ml-1567951135) | `src/i_video.ml:2668` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`CUI_ClearLog`](File-src-console-ui-ml-497758297.md#function-function-cui-clearlog-function-cui-clearlog-src-console-ui-ml-77916864) | `src/console_ui.ml:180` | 6 | 4 | 1 | 0 | 0 | 60.94 | 70.39 |
| [`CUI_Drawer`](File-src-console-ui-ml-497758297.md#function-function-cui-drawer-function-cui-drawer-src-console-ui-ml-198107576) | `src/console_ui.ml:449` | 26 | 22 | 7 | 9 | 3 | 1144.05 | 46.78 |
| [`CUI_Init`](File-src-console-ui-ml-497758297.md#function-function-cui-init-function-cui-init-src-console-ui-ml-1631764492) | `src/console_ui.ml:127` | 11 | 10 | 2 | 1 | 1 | 148.68 | 61.8 |
| [`CUI_IsCapturing`](File-src-console-ui-ml-497758297.md#function-function-cui-iscapturing-function-cui-iscapturing-src-console-ui-ml-487224982) | `src/console_ui.ml:291` | 4 | 2 | 1 | 0 | 0 | 53.77 | 74.61 |
| [`CUI_Log`](File-src-console-ui-ml-497758297.md#function-function-cui-log-function-cui-log-message-src-console-ui-ml-1718517383) | `src/console_ui.ml:158` | 18 | 14 | 7 | 7 | 2 | 606.7 | 52.19 |
| [`CUI_Responder`](File-src-console-ui-ml-497758297.md#function-function-cui-responder-function-cui-responder-ev-src-console-ui-ml-35117197) | `src/console_ui.ml:359` | 39 | 35 | 26 | 30 | 2 | 1697.81 | 39.18 |
| [`CUI_SetFont`](File-src-console-ui-ml-497758297.md#function-function-cui-setfont-function-cui-setfont-font-startchar-src-console-ui-ml-1652528233) | `src/console_ui.ml:143` | 11 | 11 | 3 | 2 | 1 | 243 | 60.18 |
| [`CUI_SetOpen`](File-src-console-ui-ml-497758297.md#function-function-cui-setopen-function-cui-setopen-openconsole-src-console-ui-ml-759482309) | `src/console_ui.ml:251` | 30 | 34 | 10 | 10 | 2 | 859.05 | 45.89 |
| [`CUI_Toggle`](File-src-console-ui-ml-497758297.md#function-function-cui-toggle-function-cui-toggle-src-console-ui-ml-467478780) | `src/console_ui.ml:286` | 3 | 1 | 1 | 0 | 0 | 33 | 78.82 |
| [`D_AddFile`](File-src-d-main-ml-105344057.md#function-function-d-addfile-function-d-addfile-file-src-d-main-ml-833552250) | `src/d_main.ml:64` | 19 | 15 | 8 | 9 | 2 | 519.57 | 52.01 |
| [`D_AdvanceDemo`](File-src-d-main-ml-105344057.md#function-function-d-advancedemo-function-d-advancedemo-src-d-main-ml-1734225940) | `src/d_main.ml:696` | 4 | 2 | 1 | 0 | 0 | 34.87 | 75.93 |
| [`D_ArbitrateNetStart`](File-src-d-net-ml-529296669.md#function-function-d-arbitratenetstart-function-d-arbitratenetstart-src-d-net-ml-909778042) | `src/d_net.ml:7263` | 35 | 35 | 12 | 19 | 3 | 1653.02 | 42.17 |
| [`D_CheckNetGame`](File-src-d-net-ml-529296669.md#function-function-d-checknetgame-function-d-checknetgame-src-d-net-ml-855586970) | `src/d_net.ml:6440` | 52 | 47 | 16 | 32 | 5 | 1685.71 | 37.82 |
| [`D_Display`](File-src-d-main-ml-105344057.md#function-function-d-display-function-d-display-src-d-main-ml-1002071674) | `src/d_main.ml:1944` | 311 | 261 | 150 | 250 | 4 | 12751.6 | 0 |
| [`D_DoAdvanceDemo`](File-src-d-main-ml-105344057.md#function-function-d-doadvancedemo-function-d-doadvancedemo-src-d-main-ml-34373146) | `src/d_main.ml:703` | 81 | 63 | 24 | 36 | 3 | 2235.4 | 31.69 |
| [`D_DoomLoop`](File-src-d-main-ml-105344057.md#function-function-d-doomloop-function-d-doomloop-src-d-main-ml-1406743232) | `src/d_main.ml:2288` | 77 | 61 | 34 | 61 | 4 | 2567.9 | 30.4 |
| [`D_DoomMain`](File-src-d-main-ml-105344057.md#function-function-d-doommain-function-d-doommain-src-d-main-ml-1126039512) | `src/d_main.ml:1722` | 180 | 168 | 77 | 126 | 4 | 7810.67 | 13.19 |
| [`D_ForceWipe`](File-src-d-main-ml-105344057.md#function-function-d-forcewipe-function-d-forcewipe-src-d-main-ml-2139527162) | `src/d_main.ml:247` | 4 | 2 | 1 | 0 | 0 | 34.87 | 75.93 |
| [`D_HDWADProgressStep`](File-src-d-main-ml-105344057.md#function-function-d-hdwadprogressstep-function-d-hdwadprogressstep-units-src-d-main-ml-1797080475) | `src/d_main.ml:1344` | 25 | 22 | 13 | 15 | 2 | 798.06 | 47.44 |
| [`D_NetInitSinglePlayer`](File-src-d-net-ml-529296669.md#function-function-d-netinitsingleplayer-function-d-netinitsingleplayer-src-d-net-ml-227000536) | `src/d_net.ml:6351` | 77 | 62 | 19 | 26 | 2 | 2300.54 | 32.75 |
| [`D_NetMPDebugOverlayText`](File-src-d-net-ml-529296669.md#function-function-d-netmpdebugoverlaytext-function-d-netmpdebugoverlaytext-src-d-net-ml-1616574152) | `src/d_net.ml:1117` | 25 | 21 | 8 | 11 | 3 | 1242.77 | 46.76 |
| [`D_NetMPSendChat`](File-src-d-net-ml-529296669.md#function-function-d-netmpsendchat-function-d-netmpsendchat-dest-msg-src-d-net-ml-2093206039) | `src/d_net.ml:2041` | 20 | 22 | 12 | 11 | 1 | 976.96 | 49.07 |
| [`D_NetMPSetPlayerName`](File-src-d-net-ml-529296669.md#function-function-d-netmpsetplayername-function-d-netmpsetplayername-name-src-d-net-ml-974223481) | `src/d_net.ml:2179` | 24 | 20 | 11 | 13 | 2 | 862.59 | 47.86 |
| [`D_PageDrawer`](File-src-d-main-ml-105344057.md#function-function-d-pagedrawer-function-d-pagedrawer-src-d-main-ml-1919885984) | `src/d_main.ml:674` | 18 | 11 | 11 | 12 | 2 | 707.82 | 51.18 |
| [`D_PageTicker`](File-src-d-main-ml-105344057.md#function-function-d-pageticker-function-d-pageticker-src-d-main-ml-749541744) | `src/d_main.ml:662` | 9 | 5 | 3 | 2 | 1 | 120 | 64.22 |
| [`D_PostEvent`](File-src-d-main-ml-105344057.md#function-function-d-postevent-function-d-postevent-ev-src-d-main-ml-1245685575) | `src/d_main.ml:611` | 7 | 6 | 2 | 1 | 1 | 176.42 | 65.57 |
| [`D_ProcessEvents`](File-src-d-main-ml-105344057.md#function-function-d-processevents-function-d-processevents-src-d-main-ml-895840882) | `src/d_main.ml:622` | 30 | 19 | 10 | 19 | 3 | 761.1 | 46.26 |
| [`D_QuitNetGame`](File-src-d-net-ml-529296669.md#function-function-d-quitnetgame-function-d-quitnetgame-src-d-net-ml-1253157380) | `src/d_net.ml:6501` | 23 | 21 | 14 | 19 | 3 | 824 | 47.99 |
| [`D_StartTitle`](File-src-d-main-ml-105344057.md#function-function-d-starttitle-function-d-starttitle-src-d-main-ml-766789840) | `src/d_main.ml:795` | 13 | 11 | 1 | 0 | 0 | 173.92 | 59.88 |
| [`EV_BuildStairs`](File-src-p-floor-ml-1999892698.md#function-function-ev-buildstairs-function-ev-buildstairs-line-type-src-p-floor-ml-1572296407) | `src/p_floor.ml:418` | 79 | 68 | 18 | 45 | 4 | 2586.66 | 32.29 |
| [`EV_CeilingCrushStop`](File-src-p-ceilng-ml-226654252.md#function-function-ev-ceilingcrushstop-function-ev-ceilingcrushstop-line-src-p-ceilng-ml-164855987) | `src/p_ceilng.ml:115` | 16 | 13 | 5 | 5 | 2 | 375 | 55.04 |
| [`EV_DoCeiling`](File-src-p-ceilng-ml-226654252.md#function-function-ev-doceiling-function-ev-doceiling-line-type-src-p-ceilng-ml-620422971) | `src/p_ceilng.ml:174` | 35 | 33 | 13 | 21 | 3 | 1541.73 | 42.25 |
| [`EV_DoDonut`](File-src-p-spec-ml-402508231.md#function-function-ev-dodonut-function-ev-dodonut-line-src-p-spec-ml-714629988) | `src/p_spec.ml:1453` | 45 | 48 | 21 | 41 | 3 | 2365.9 | 37.49 |
| [`EV_DoDoor`](File-src-p-doors-ml-224295587.md#function-function-ev-dodoor-function-ev-dodoor-line-type-src-p-doors-ml-622067172) | `src/p_doors.ml:264` | 54 | 42 | 14 | 18 | 3 | 2253.1 | 36.85 |
| [`EV_DoFloor`](File-src-p-floor-ml-1999892698.md#function-function-ev-dofloor-function-ev-dofloor-line-floortype-src-p-floor-ml-1214231375) | `src/p_floor.ml:246` | 145 | 111 | 38 | 77 | 6 | 5692.77 | 21.45 |
| [`EV_DoLockedDoor`](File-src-p-doors-ml-224295587.md#function-function-ev-dolockeddoor-function-ev-dolockeddoor-line-type-thing-src-p-doors-ml-383289614) | `src/p_doors.ml:226` | 29 | 19 | 13 | 13 | 2 | 1010.81 | 45.31 |
| [`EV_DoPlat`](File-src-p-plats-ml-866228534.md#function-function-ev-doplat-function-ev-doplat-line-type-amount-src-p-plats-ml-1933495643) | `src/p_plats.ml:260` | 86 | 72 | 20 | 33 | 3 | 3735.47 | 30.1 |
| [`EV_LightTurnOn`](File-src-p-lights-ml-1710096069.md#function-function-ev-lightturnon-function-ev-lightturnon-line-bright-src-p-lights-ml-482609686) | `src/p_lights.ml:206` | 16 | 13 | 6 | 8 | 2 | 383.37 | 54.84 |
| [`EV_SlidingDoor`](File-src-p-doors-ml-224295587.md#function-function-ev-slidingdoor-function-ev-slidingdoor-line-thing-src-p-doors-ml-1112026500) | `src/p_doors.ml:489` | 5 | 3 | 1 | 0 | 0 | 58.81 | 72.23 |
| [`EV_StartLightStrobing`](File-src-p-lights-ml-1710096069.md#function-function-ev-startlightstrobing-function-ev-startlightstrobing-line-src-p-lights-ml-1034264194) | `src/p_lights.ml:174` | 10 | 8 | 4 | 4 | 2 | 242.5 | 60.95 |
| [`EV_StopPlat`](File-src-p-plats-ml-866228534.md#function-function-ev-stopplat-function-ev-stopplat-line-src-p-plats-ml-1217674417) | `src/p_plats.ml:171` | 18 | 13 | 7 | 9 | 3 | 590.73 | 52.27 |
| [`EV_Teleport`](File-src-p-telept-ml-266213122.md#function-function-ev-teleport-function-ev-teleport-line-side-thing-src-p-telept-ml-109397786) | `src/p_telept.ml:54` | 56 | 49 | 25 | 62 | 6 | 2653.49 | 34.53 |
| [`EV_TurnTagLightsOff`](File-src-p-lights-ml-1710096069.md#function-function-ev-turntaglightsoff-function-ev-turntaglightsoff-line-src-p-lights-ml-1684255512) | `src/p_lights.ml:189` | 12 | 11 | 5 | 6 | 2 | 326.98 | 58.18 |
| [`EV_VerticalDoor`](File-src-p-doors-ml-224295587.md#function-function-ev-verticaldoor-function-ev-verticaldoor-line-thing-src-p-doors-ml-1406394028) | `src/p_doors.ml:333` | 81 | 55 | 28 | 33 | 4 | 3074.83 | 30.18 |
| [`Expand4`](File-src-i-video-ml-140536292.md#function-function-expand4-function-expand4-src-dst-count-src-i-video-ml-2140160445) | `src/i_video.ml:2693` | 4 | 3 | 3 | 2 | 1 | 170.97 | 70.83 |
| [`ExpandTics`](File-src-d-net-ml-529296669.md#function-function-expandtics-function-expandtics-low-src-d-net-ml-1718593482) | `src/d_net.ml:7099` | 15 | 11 | 6 | 5 | 1 | 475.93 | 54.79 |
| [`ExtractFileBase`](File-src-w-wad-ml-893006035.md#function-function-extractfilebase-function-extractfilebase-path-dest-src-w-wad-ml-1660605343) | `src/w_wad.ml:263` | 17 | 13 | 6 | 7 | 2 | 450.83 | 53.77 |
| [`F_BunnyScroll`](File-src-f-finale-ml-635076109.md#function-function-f-bunnyscroll-function-f-bunnyscroll-src-f-finale-ml-1268295952) | `src/f_finale.ml:437` | 44 | 37 | 14 | 15 | 2 | 1915.11 | 39.28 |
| [`F_CastDrawer`](File-src-f-finale-ml-635076109.md#function-function-f-castdrawer-function-f-castdrawer-src-f-finale-ml-961639588) | `src/f_finale.ml:490` | 7 | 5 | 3 | 2 | 1 | 181.52 | 65.34 |
| [`F_CastPrint`](File-src-f-finale-ml-635076109.md#function-function-f-castprint-function-f-castprint-text-src-f-finale-ml-279572055) | `src/f_finale.ml:357` | 40 | 28 | 11 | 17 | 3 | 1224.72 | 41.95 |
| [`F_CastResponder`](File-src-f-finale-ml-635076109.md#function-function-f-castresponder-function-f-castresponder-ev-src-f-finale-ml-110025057) | `src/f_finale.ml:344` | 9 | 7 | 3 | 2 | 1 | 169.46 | 63.17 |
| [`F_CastTicker`](File-src-f-finale-ml-635076109.md#function-function-f-castticker-function-f-castticker-src-f-finale-ml-70992336) | `src/f_finale.ml:336` | 5 | 4 | 2 | 1 | 1 | 78.14 | 71.23 |
| [`F_Drawer`](File-src-f-finale-ml-635076109.md#function-function-f-drawer-function-f-drawer-src-f-finale-ml-1327430912) | `src/f_finale.ml:536` | 26 | 20 | 14 | 20 | 3 | 957.95 | 46.38 |
| [`F_DrawPatchCol`](File-src-f-finale-ml-635076109.md#function-function-f-drawpatchcol-function-f-drawpatchcol-x-patch-col-src-f-finale-ml-73259202) | `src/f_finale.ml:405` | 28 | 31 | 19 | 23 | 3 | 1308.23 | 44.05 |
| [`F_Responder`](File-src-f-finale-ml-635076109.md#function-function-f-responder-function-f-responder-ev-src-f-finale-ml-471896075) | `src/f_finale.ml:269` | 7 | 5 | 4 | 3 | 1 | 130.8 | 66.21 |
| [`F_StartCast`](File-src-f-finale-ml-635076109.md#function-function-f-startcast-function-f-startcast-src-f-finale-ml-516556096) | `src/f_finale.ml:322` | 11 | 9 | 1 | 0 | 0 | 146.95 | 61.97 |
| [`F_StartFinale`](File-src-f-finale-ml-635076109.md#function-function-f-startfinale-function-f-startfinale-src-f-finale-ml-1731171528) | `src/f_finale.ml:189` | 71 | 55 | 15 | 24 | 2 | 1616.83 | 35.13 |
| [`F_TextWrite`](File-src-f-finale-ml-635076109.md#function-function-f-textwrite-function-f-textwrite-src-f-finale-ml-1883472226) | `src/f_finale.ml:278` | 37 | 35 | 11 | 14 | 2 | 1200.89 | 42.75 |
| [`F_Ticker`](File-src-f-finale-ml-635076109.md#function-function-f-ticker-function-f-ticker-src-f-finale-ml-421623840) | `src/f_finale.ml:500` | 28 | 22 | 12 | 13 | 2 | 690.61 | 46.94 |
| [`filelength`](File-src-w-wad-ml-893006035.md#function-function-filelength-inline-function-filelength-handle-src-w-wad-ml-1059993971) | `src/w_wad.ml:146` | 7 | 8 | 5 | 4 | 1 | 286.73 | 63.69 |
| [`FindResponseFile`](File-src-d-main-ml-105344057.md#function-function-findresponsefile-function-findresponsefile-src-d-main-ml-32238248) | `src/d_main.ml:1652` | 59 | 48 | 14 | 40 | 4 | 1801.6 | 36.69 |
| [`FixedDiv`](File-src-m-fixed-ml-2129187227.md#function-function-fixeddiv-function-fixeddiv-a-b-src-m-fixed-ml-868742543) | `src/m_fixed.ml:130` | 11 | 7 | 3 | 3 | 2 | 284.98 | 59.69 |
| [`FixedDiv2`](File-src-m-fixed-ml-2129187227.md#function-function-fixeddiv2-inline-function-fixeddiv2-a-b-src-m-fixed-ml-1761712588) | `src/m_fixed.ml:148` | 11 | 8 | 2 | 1 | 1 | 239.75 | 60.35 |
| [`FixedMul`](File-src-m-fixed-ml-2129187227.md#function-function-fixedmul-inline-function-fixedmul-a-b-src-m-fixed-ml-1785882466) | `src/m_fixed.ml:119` | 5 | 3 | 1 | 0 | 0 | 128.93 | 69.84 |
| [`ForeignTranslation`](File-src-hu-stuff-ml-1965779679.md#function-function-foreigntranslation-function-foreigntranslation-ch-src-hu-stuff-ml-1441955351) | `src/hu_stuff.ml:629` | 7 | 9 | 6 | 5 | 1 | 278.63 | 63.64 |
| [`G_BeginRecording`](File-src-g-game-ml-257299317.md#function-function-g-beginrecording-function-g-beginrecording-src-g-game-ml-1388602672) | `src/g_game.ml:1117` | 24 | 31 | 11 | 12 | 2 | 955.39 | 47.55 |
| [`G_BuildTiccmd`](File-src-g-game-ml-257299317.md#function-function-g-buildticcmd-function-g-buildticcmd-cmd-src-g-game-ml-571766794) | `src/g_game.ml:1509` | 118 | 122 | 61 | 74 | 2 | 6317.69 | 19.99 |
| [`G_CheckDemoStatus`](File-src-g-game-ml-257299317.md#function-function-g-checkdemostatus-function-g-checkdemostatus-src-g-game-ml-2114324282) | `src/g_game.ml:1174` | 7 | 5 | 1 | 0 | 0 | 64.53 | 68.76 |
| [`G_CheckSpot`](File-src-g-game-ml-257299317.md#function-function-g-checkspot-function-g-checkspot-playernum-mthing-src-g-game-ml-22785680) | `src/g_game.ml:603` | 27 | 26 | 23 | 29 | 3 | 1506.44 | 43.43 |
| [`G_ClearInputState`](File-src-g-game-ml-257299317.md#function-function-g-clearinputstate-function-g-clearinputstate-src-g-game-ml-134955208) | `src/g_game.ml:1359` | 19 | 17 | 1 | 0 | 0 | 325.54 | 54.38 |
| [`G_CmdChecksum`](File-src-g-game-ml-257299317.md#function-function-g-cmdchecksum-function-g-cmdchecksum-cmd-src-g-game-ml-217711408) | `src/g_game.ml:447` | 9 | 12 | 6 | 5 | 1 | 459.74 | 59.73 |
| [`G_DeathMatchSpawnPlayer`](File-src-g-game-ml-257299317.md#function-function-g-deathmatchspawnplayer-function-g-deathmatchspawnplayer-playernum-src-g-game-ml-835215021) | `src/g_game.ml:74` | 37 | 29 | 22 | 28 | 3 | 1601.68 | 40.39 |
| [`G_DeferedInitNew`](File-src-g-game-ml-257299317.md#function-function-g-deferedinitnew-function-g-deferedinitnew-skill-episode-map-src-g-game-ml-2113490110) | `src/g_game.ml:188` | 10 | 8 | 1 | 0 | 0 | 137.61 | 63.08 |
| [`G_DeferedPlayDemo`](File-src-g-game-ml-257299317.md#function-function-g-deferedplaydemo-function-g-deferedplaydemo-demo-src-g-game-ml-729185157) | `src/g_game.ml:202` | 6 | 4 | 1 | 0 | 0 | 70.31 | 69.96 |
| [`G_DoCompleted`](File-src-g-game-ml-257299317.md#function-function-g-docompleted-function-g-docompleted-src-g-game-ml-1051435032) | `src/g_game.ml:713` | 116 | 78 | 43 | 73 | 3 | 4011.99 | 23.95 |
| [`G_DoLoadGame`](File-src-g-game-ml-257299317.md#function-function-g-doloadgame-function-g-doloadgame-src-g-game-ml-157512896) | `src/g_game.ml:380` | 54 | 45 | 14 | 14 | 2 | 1709.63 | 37.69 |
| [`G_DoLoadLevel`](File-src-g-game-ml-257299317.md#function-function-g-doloadlevel-function-g-doloadlevel-src-g-game-ml-2077927002) | `src/g_game.ml:636` | 12 | 11 | 4 | 3 | 1 | 398.51 | 57.71 |
| [`G_DoNewGame`](File-src-g-game-ml-257299317.md#function-function-g-donewgame-function-g-donewgame-src-g-game-ml-637656350) | `src/g_game.ml:917` | 5 | 3 | 1 | 0 | 0 | 84 | 71.14 |
| [`G_DoPlayDemo`](File-src-g-game-ml-257299317.md#function-function-g-doplaydemo-function-g-doplaydemo-src-g-game-ml-869619344) | `src/g_game.ml:924` | 61 | 52 | 15 | 15 | 2 | 1734.82 | 36.36 |
| [`G_DoReborn`](File-src-g-game-ml-257299317.md#function-function-g-doreborn-function-g-doreborn-playernum-src-g-game-ml-759480255) | `src/g_game.ml:668` | 37 | 25 | 29 | 33 | 3 | 1744.33 | 39.19 |
| [`G_DoSaveGame`](File-src-g-game-ml-257299317.md#function-function-g-dosavegame-function-g-dosavegame-src-g-game-ml-785828524) | `src/g_game.ml:864` | 45 | 43 | 15 | 17 | 2 | 1837.91 | 39.06 |
| [`G_DoWorldDone`](File-src-g-game-ml-257299317.md#function-function-g-doworlddone-function-g-doworlddone-src-g-game-ml-207052154) | `src/g_game.ml:843` | 18 | 14 | 3 | 2 | 1 | 340.86 | 54.48 |
| [`G_ExitLevel`](File-src-g-game-ml-257299317.md#function-function-g-exitlevel-function-g-exitlevel-src-g-game-ml-709776872) | `src/g_game.ml:1184` | 6 | 4 | 1 | 0 | 0 | 66.61 | 70.12 |
| [`G_InitNew`](File-src-g-game-ml-257299317.md#function-function-g-initnew-function-g-initnew-skill-episode-map-src-g-game-ml-1535045346) | `src/g_game.ml:124` | 51 | 43 | 15 | 22 | 3 | 1541.73 | 38.41 |
| [`G_InitPlayer`](File-src-g-game-ml-257299317.md#function-function-g-initplayer-function-g-initplayer-playernum-src-g-game-ml-279662107) | `src/g_game.ml:459` | 9 | 11 | 8 | 7 | 1 | 457.87 | 59.48 |
| [`G_LoadGame`](File-src-g-game-ml-257299317.md#function-function-g-loadgame-function-g-loadgame-name-src-g-game-ml-681417797) | `src/g_game.ml:212` | 6 | 4 | 1 | 0 | 0 | 70.31 | 69.96 |
| [`G_PlayDemo`](File-src-g-game-ml-257299317.md#function-function-g-playdemo-function-g-playdemo-name-src-g-game-ml-737594289) | `src/g_game.ml:1145` | 8 | 6 | 1 | 0 | 0 | 93.77 | 66.36 |
| [`G_PlayerFinishLevel`](File-src-g-game-ml-257299317.md#function-function-g-playerfinishlevel-function-g-playerfinishlevel-playernum-src-g-game-ml-2138977871) | `src/g_game.ml:472` | 28 | 25 | 10 | 9 | 1 | 900.81 | 46.4 |
| [`G_PlayerReborn`](File-src-g-game-ml-257299317.md#function-function-g-playerreborn-function-g-playerreborn-playernum-src-g-game-ml-1384052151) | `src/g_game.ml:507` | 84 | 78 | 36 | 49 | 3 | 4048.15 | 27.92 |
| [`G_ProcessGameActionOnly`](File-src-g-game-ml-257299317.md#function-function-g-processgameactiononly-function-g-processgameactiononly-src-g-game-ml-1148964690) | `src/g_game.ml:1260` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`G_ProcessPendingGameAction`](File-src-g-game-ml-257299317.md#function-function-g-processpendinggameaction-function-g-processpendinggameaction-src-g-game-ml-1102488064) | `src/g_game.ml:1227` | 27 | 16 | 13 | 24 | 3 | 754 | 46.88 |
| [`G_ReadDemoTiccmd`](File-src-g-game-ml-257299317.md#function-function-g-readdemoticcmd-function-g-readdemoticcmd-cmd-src-g-game-ml-1869050758) | `src/g_game.ml:1040` | 20 | 20 | 8 | 7 | 1 | 639.53 | 50.9 |
| [`G_RecordDemo`](File-src-g-game-ml-257299317.md#function-function-g-recorddemo-function-g-recorddemo-name-src-g-game-ml-898777841) | `src/g_game.ml:1088` | 23 | 20 | 7 | 7 | 2 | 649.89 | 49.66 |
| [`G_Responder`](File-src-g-game-ml-257299317.md#function-function-g-responder-function-g-responder-ev-src-g-game-ml-1836286565) | `src/g_game.ml:1419` | 68 | 63 | 41 | 57 | 4 | 3399.76 | 29.78 |
| [`G_SaveGame`](File-src-g-game-ml-257299317.md#function-function-g-savegame-function-g-savegame-slot-description-src-g-game-ml-1617746172) | `src/g_game.ml:999` | 8 | 6 | 1 | 0 | 0 | 104 | 66.04 |
| [`G_ScreenShot`](File-src-g-game-ml-257299317.md#function-function-g-screenshot-function-g-screenshot-src-g-game-ml-2062966032) | `src/g_game.ml:1501` | 4 | 2 | 1 | 0 | 0 | 44.97 | 75.16 |
| [`G_SecretExitLevel`](File-src-g-game-ml-257299317.md#function-function-g-secretexitlevel-function-g-secretexitlevel-src-g-game-ml-569091152) | `src/g_game.ml:1193` | 10 | 6 | 4 | 3 | 1 | 216.33 | 61.3 |
| [`G_Ticker`](File-src-g-game-ml-257299317.md#function-function-g-ticker-function-g-ticker-src-g-game-ml-1573207808) | `src/g_game.ml:1265` | 25 | 22 | 19 | 27 | 3 | 1094.25 | 45.67 |
| [`G_TimeDemo`](File-src-g-game-ml-257299317.md#function-function-g-timedemo-function-g-timedemo-name-src-g-game-ml-1837173681) | `src/g_game.ml:1157` | 14 | 12 | 1 | 0 | 0 | 239.75 | 58.2 |
| [`G_WorldDone`](File-src-g-game-ml-257299317.md#function-function-g-worlddone-function-g-worlddone-src-g-game-ml-963713764) | `src/g_game.ml:1206` | 17 | 13 | 15 | 17 | 3 | 672.86 | 51.34 |
| [`G_WriteDemoTiccmd`](File-src-g-game-ml-257299317.md#function-function-g-writedemoticcmd-function-g-writedemoticcmd-cmd-src-g-game-ml-1012412346) | `src/g_game.ml:1066` | 16 | 14 | 5 | 4 | 1 | 381.47 | 54.99 |
| [`GetLocalAddress`](File-src-i-net-ml-1331775872.md#function-function-getlocaladdress-function-getlocaladdress-src-i-net-ml-692022017) | `src/i_net.ml:443` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`getNextSector`](File-src-p-spec-ml-402508231.md#function-function-getnextsector-function-getnextsector-line-sec-src-p-spec-ml-66776559) | `src/p_spec.ml:1261` | 23 | 26 | 15 | 16 | 2 | 907.88 | 47.57 |
| [`GetPackets`](File-src-d-net-ml-529296669.md#function-function-getpackets-function-getpackets-src-d-net-ml-1826830354) | `src/d_net.ml:7167` | 64 | 55 | 30 | 54 | 3 | 3155.3 | 32.06 |
| [`getSector`](File-src-p-spec-ml-402508231.md#function-function-getsector-function-getsector-currentsector-lineindex-side-src-p-spec-ml-1222409722) | `src/p_spec.ml:1252` | 5 | 4 | 2 | 1 | 1 | 144.43 | 69.36 |
| [`getsfx`](File-src-i-sound-ml-33806980.md#function-function-getsfx-function-getsfx-name-lenout-src-i-sound-ml-650364777) | `src/i_sound.ml:1834` | 14 | 13 | 10 | 11 | 2 | 671.55 | 53.86 |
| [`getSide`](File-src-p-spec-ml-402508231.md#function-function-getside-function-getside-currentsector-lineindex-side-src-p-spec-ml-801455564) | `src/p_spec.ml:1228` | 18 | 28 | 17 | 16 | 1 | 959.18 | 49.45 |
| [`grabsharedmemory`](File-src-i-video-ml-140536292.md#function-function-grabsharedmemory-function-grabsharedmemory-size-src-i-video-ml-303888106) | `src/i_video.ml:2675` | 4 | 2 | 1 | 0 | 0 | 38.04 | 75.67 |
| [`HDB_BuildImages`](File-src-hdwad-builder-ml-980370789.md#function-function-hdb-buildimages-function-hdb-buildimages-waddata-lumps-scale-src-hdwad-builder-ml-316101281) | `src/hdwad_builder.ml:1855` | 20 | 18 | 1 | 0 | 0 | 1026.26 | 50.4 |
| [`HDB_EstimateImageProgressUnits`](File-src-hdwad-builder-ml-980370789.md#function-function-hdb-estimateimageprogressunits-function-hdb-estimateimageprogressunits-waddata-lumps-scale-src-hdwad-builder-ml-1775364895) | `src/hdwad_builder.ml:1608` | 13 | 12 | 2 | 1 | 1 | 666.46 | 55.66 |
| [`HDB_LegacyToolMain`](File-src-hdwad-builder-ml-980370789.md#function-function-hdb-legacytoolmain-function-hdb-legacytoolmain-args-src-hdwad-builder-ml-1162084691) | `src/hdwad_builder.ml:1898` | 43 | 42 | 13 | 15 | 2 | 2428.16 | 38.92 |
| [`HDB_LoadWadForBuild`](File-src-hdwad-builder-ml-980370789.md#function-function-hdb-loadwadforbuild-function-hdb-loadwadforbuild-path-src-hdwad-builder-ml-255056417) | `src/hdwad_builder.ml:1879` | 3 | 1 | 1 | 0 | 0 | 36 | 78.56 |
| [`HDB_WriteHDWAD`](File-src-hdwad-builder-ml-980370789.md#function-function-hdb-writehdwad-function-hdb-writehdwad-path-waddata-lumps-images-extranames-extradatas-scale-src-hdwad-builder-ml-1151223375) | `src/hdwad_builder.ml:1892` | 3 | 1 | 1 | 0 | 0 | 140.65 | 74.42 |
| [`HGetPacket`](File-src-d-net-ml-529296669.md#function-function-hgetpacket-function-hgetpacket-src-d-net-ml-1704939230) | `src/d_net.ml:7142` | 21 | 24 | 10 | 10 | 2 | 814.24 | 49.43 |
| [`HSendPacket`](File-src-d-net-ml-529296669.md#function-function-hsendpacket-function-hsendpacket-node-flags-src-d-net-ml-1590865323) | `src/d_net.ml:7118` | 19 | 21 | 7 | 6 | 1 | 587.76 | 51.77 |
| [`HU_Drawer`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-drawer-function-hu-drawer-src-hu-stuff-ml-960711168) | `src/hu_stuff.ml:549` | 6 | 6 | 3 | 2 | 1 | 135.93 | 67.68 |
| [`HU_Erase`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-erase-function-hu-erase-src-hu-stuff-ml-494926250) | `src/hu_stuff.ml:557` | 5 | 3 | 1 | 0 | 0 | 62.27 | 72.05 |
| [`HU_Init`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-init-function-hu-init-src-hu-stuff-ml-1193802138) | `src/hu_stuff.ml:455` | 30 | 26 | 8 | 10 | 2 | 870.28 | 46.12 |
| [`HU_NetAddMessage`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-netaddmessage-function-hu-netaddmessage-msg-src-hu-stuff-ml-1211802131) | `src/hu_stuff.ml:565` | 27 | 24 | 10 | 10 | 2 | 826.56 | 47 |
| [`HU_Responder`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-responder-function-hu-responder-ev-src-hu-stuff-ml-1833774927) | `src/hu_stuff.ml:639` | 91 | 72 | 37 | 96 | 7 | 3062.36 | 27.88 |
| [`HU_Start`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-start-function-hu-start-src-hu-stuff-ml-524594290) | `src/hu_stuff.ml:502` | 38 | 36 | 3 | 2 | 1 | 1488.34 | 42.92 |
| [`HU_Stop`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-stop-function-hu-stop-src-hu-stuff-ml-860128090) | `src/hu_stuff.ml:493` | 7 | 5 | 1 | 0 | 0 | 69.19 | 68.55 |
| [`HU_Ticker`](File-src-hu-stuff-ml-1965779679.md#function-function-hu-ticker-function-hu-ticker-src-hu-stuff-ml-1028332794) | `src/hu_stuff.ml:597` | 25 | 21 | 7 | 10 | 3 | 608.76 | 49.07 |
| [`HUlib_addCharToTextLine`](File-src-hu-lib-ml-937975676.md#function-function-hulib-addchartotextline-function-hulib-addchartotextline-t-ch-src-hu-lib-ml-1188376490) | `src/hu_lib.ml:193` | 10 | 10 | 3 | 2 | 1 | 344.92 | 60.01 |
| [`HUlib_addLineToSText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-addlinetostext-function-hulib-addlinetostext-s-src-hu-lib-ml-1538269276) | `src/hu_lib.ml:307` | 11 | 10 | 4 | 3 | 1 | 361.93 | 58.83 |
| [`HUlib_addMessageToSText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-addmessagetostext-function-hulib-addmessagetostext-s-prefix-msg-src-hu-lib-ml-1643916663) | `src/hu_lib.ml:335` | 7 | 8 | 4 | 3 | 1 | 301.85 | 63.66 |
| [`HUlib_addPrefixToIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-addprefixtoitext-function-hulib-addprefixtoitext-it-str-src-hu-lib-ml-2138441435) | `src/hu_lib.ml:420` | 6 | 6 | 3 | 2 | 1 | 194.49 | 66.6 |
| [`HUlib_clearTextLine`](File-src-hu-lib-ml-937975676.md#function-function-hulib-cleartextline-function-hulib-cleartextline-t-src-hu-lib-ml-1697740921) | `src/hu_lib.ml:159` | 12 | 8 | 5 | 5 | 2 | 356.7 | 57.92 |
| [`HUlib_delCharFromIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-delcharfromitext-function-hulib-delcharfromitext-it-src-hu-lib-ml-10039910) | `src/hu_lib.ml:394` | 5 | 5 | 3 | 2 | 1 | 158.46 | 68.95 |
| [`HUlib_delCharFromTextLine`](File-src-hu-lib-ml-937975676.md#function-function-hulib-delcharfromtextline-function-hulib-delcharfromtextline-t-src-hu-lib-ml-1038206113) | `src/hu_lib.ml:206` | 8 | 8 | 3 | 2 | 1 | 243 | 63.19 |
| [`HUlib_drawIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-drawitext-function-hulib-drawitext-it-src-hu-lib-ml-957077604) | `src/hu_lib.ml:448` | 5 | 5 | 3 | 2 | 1 | 148.68 | 69.14 |
| [`HUlib_drawSText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-drawstext-function-hulib-drawstext-s-src-hu-lib-ml-1531664234) | `src/hu_lib.ml:345` | 11 | 11 | 5 | 5 | 2 | 371.56 | 58.62 |
| [`HUlib_drawTextLine`](File-src-hu-lib-ml-937975676.md#function-function-hulib-drawtextline-function-hulib-drawtextline-l-drawcursor-src-hu-lib-ml-1384136783) | `src/hu_lib.ml:218` | 27 | 22 | 12 | 19 | 3 | 1032.83 | 46.06 |
| [`HUlib_eraseIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-eraseitext-function-hulib-eraseitext-it-src-hu-lib-ml-669856574) | `src/hu_lib.ml:456` | 8 | 6 | 4 | 3 | 1 | 245.27 | 63.03 |
| [`HUlib_eraseLineFromIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-eraselinefromitext-function-hulib-eraselinefromitext-it-src-hu-lib-ml-1646816114) | `src/hu_lib.ml:402` | 6 | 4 | 3 | 2 | 1 | 137.61 | 67.65 |
| [`HUlib_eraseSText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-erasestext-function-hulib-erasestext-s-src-hu-lib-ml-1321217732) | `src/hu_lib.ml:361` | 12 | 9 | 5 | 5 | 2 | 377.83 | 57.74 |
| [`HUlib_eraseTextLine`](File-src-hu-lib-ml-937975676.md#function-function-hulib-erasetextline-function-hulib-erasetextline-l-src-hu-lib-ml-1695318591) | `src/hu_lib.ml:250` | 24 | 17 | 9 | 11 | 3 | 753.4 | 48.54 |
| [`HUlib_init`](File-src-hu-lib-ml-937975676.md#function-function-hulib-init-function-hulib-init-src-hu-lib-ml-424823637) | `src/hu_lib.ml:83` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`HUlib_initIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-inititext-function-hulib-inititext-it-x-y-font-startchar-on-src-hu-lib-ml-1168220829) | `src/hu_lib.ml:383` | 8 | 7 | 2 | 1 | 1 | 343.65 | 62.27 |
| [`HUlib_initSText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-initstext-function-hulib-initstext-s-x-y-h-font-startchar-on-src-hu-lib-ml-2134593597) | `src/hu_lib.ml:285` | 17 | 16 | 4 | 3 | 1 | 723.27 | 52.6 |
| [`HUlib_initTextLine`](File-src-hu-lib-ml-937975676.md#function-function-hulib-inittextline-function-hulib-inittextline-t-x-y-f-sc-src-hu-lib-ml-981397914) | `src/hu_lib.ml:178` | 10 | 9 | 2 | 1 | 1 | 301.85 | 60.55 |
| [`HUlib_keyInIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-keyinitext-function-hulib-keyinitext-it-ch-src-hu-lib-ml-2005175831) | `src/hu_lib.ml:431` | 12 | 8 | 6 | 5 | 1 | 312.11 | 58.19 |
| [`HUlib_resetIText`](File-src-hu-lib-ml-937975676.md#function-function-hulib-resetitext-function-hulib-resetitext-it-src-hu-lib-ml-1757403654) | `src/hu_lib.ml:411` | 5 | 4 | 2 | 1 | 1 | 104 | 70.36 |
| [`I_AllocLow`](File-src-i-system-ml-1632920966.md#function-function-i-alloclow-function-i-alloclow-length-src-i-system-ml-1947220855) | `src/i_system.ml:182` | 3 | 1 | 1 | 0 | 0 | 36 | 78.56 |
| [`I_BaseTiccmd`](File-src-i-system-ml-1632920966.md#function-function-i-baseticcmd-function-i-baseticcmd-src-i-system-ml-1959708987) | `src/i_system.ml:158` | 7 | 4 | 2 | 1 | 1 | 147.15 | 66.12 |
| [`I_BeginHDWipe`](File-src-i-video-ml-140536292.md#function-function-i-beginhdwipe-function-i-beginhdwipe-src-i-video-ml-560126483) | `src/i_video.ml:684` | 23 | 23 | 16 | 15 | 1 | 1155.35 | 46.7 |
| [`I_BeginRead`](File-src-i-system-ml-1632920966.md#function-function-i-beginread-function-i-beginread-src-i-system-ml-1325459429) | `src/i_system.ml:252` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`I_CaptureGLFrameToScreen`](File-src-i-video-ml-140536292.md#function-function-i-captureglframetoscreen-function-i-captureglframetoscreen-src-i-video-ml-598646243) | `src/i_video.ml:2454` | 20 | 27 | 16 | 17 | 2 | 1179.86 | 47.96 |
| [`I_CaptureLogicalOverlayBase`](File-src-i-video-ml-140536292.md#function-function-i-capturelogicaloverlaybase-function-i-capturelogicaloverlaybase-src-i-video-ml-951043003) | `src/i_video.ml:2511` | 9 | 8 | 7 | 6 | 1 | 450 | 59.66 |
| [`I_EndRead`](File-src-i-system-ml-1632920966.md#function-function-i-endread-function-i-endread-src-i-system-ml-1974117865) | `src/i_system.ml:256` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`I_Error`](File-src-i-system-ml-1632920966.md#function-function-i-error-function-i-error-msg-src-i-system-ml-1013761610) | `src/i_system.ml:201` | 28 | 21 | 12 | 12 | 2 | 895.17 | 46.15 |
| [`I_FinishUpdate`](File-src-i-video-ml-140536292.md#function-function-i-finishupdate-function-i-finishupdate-src-i-video-ml-1689348567) | `src/i_video.ml:2565` | 80 | 70 | 42 | 63 | 3 | 3473.89 | 28.04 |
| [`I_GetEvent`](File-src-i-video-ml-140536292.md#function-function-i-getevent-function-i-getevent-src-i-video-ml-1469405115) | `src/i_video.ml:2724` | 5 | 3 | 1 | 0 | 0 | 45 | 73.04 |
| [`I_GetFPS`](File-src-i-video-ml-140536292.md#function-function-i-getfps-function-i-getfps-src-i-video-ml-1710521951) | `src/i_video.ml:907` | 3 | 1 | 1 | 0 | 0 | 43.19 | 78.01 |
| [`I_GetHeapSize`](File-src-i-system-ml-1632920966.md#function-function-i-getheapsize-function-i-getheapsize-src-i-system-ml-894279737) | `src/i_system.ml:239` | 3 | 1 | 1 | 0 | 0 | 38.04 | 78.39 |
| [`I_GetSfxLumpNum`](File-src-i-sound-ml-33806980.md#function-function-i-getsfxlumpnum-function-i-getsfxlumpnum-sfxinfo-src-i-sound-ml-505533936) | `src/i_sound.ml:1591` | 10 | 6 | 4 | 3 | 1 | 239.75 | 60.98 |
| [`I_GetTime`](File-src-i-system-ml-1632920966.md#function-function-i-gettime-function-i-gettime-src-i-system-ml-611096061) | `src/i_system.ml:127` | 8 | 8 | 3 | 2 | 1 | 212.61 | 63.6 |
| [`I_GetTimeFrac`](File-src-i-system-ml-1632920966.md#function-function-i-gettimefrac-function-i-gettimefrac-src-i-system-ml-1933898069) | `src/i_system.ml:139` | 14 | 17 | 6 | 5 | 1 | 422.64 | 55.8 |
| [`I_HandleSoundTimer`](File-src-i-sound-ml-33806980.md#function-function-i-handlesoundtimer-function-i-handlesoundtimer-src-i-sound-ml-651281695) | `src/i_sound.ml:1889` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`I_HDScreenWipe`](File-src-i-video-ml-140536292.md#function-function-i-hdscreenwipe-function-i-hdscreenwipe-tics-src-i-video-ml-1505333242) | `src/i_video.ml:820` | 43 | 46 | 20 | 30 | 4 | 1572.53 | 39.29 |
| [`I_Init`](File-src-i-system-ml-1632920966.md#function-function-i-init-function-i-init-src-i-system-ml-1584407751) | `src/i_system.ml:108` | 3 | 2 | 2 | 1 | 1 | 65.73 | 76.6 |
| [`I_InitGraphics`](File-src-i-video-ml-140536292.md#function-function-i-initgraphics-function-i-initgraphics-src-i-video-ml-1175045107) | `src/i_video.ml:2292` | 89 | 76 | 20 | 23 | 2 | 2525.78 | 30.96 |
| [`I_InitMusic`](File-src-i-sound-ml-33806980.md#function-function-i-initmusic-function-i-initmusic-src-i-sound-ml-1768395553) | `src/i_sound.ml:1675` | 11 | 9 | 1 | 0 | 0 | 137.61 | 62.17 |
| [`I_InitNetwork`](File-src-i-net-ml-1331775872.md#function-function-i-initnetwork-function-i-initnetwork-src-i-net-ml-452360835) | `src/i_net.ml:363` | 5 | 2 | 2 | 1 | 1 | 65.73 | 71.76 |
| [`I_InitSound`](File-src-i-sound-ml-33806980.md#function-function-i-initsound-function-i-initsound-src-i-sound-ml-1264338381) | `src/i_sound.ml:1548` | 10 | 8 | 1 | 0 | 0 | 113.3 | 63.67 |
| [`I_LoadingPulse`](File-src-i-video-ml-140536292.md#function-function-i-loadingpulse-function-i-loadingpulse-src-i-video-ml-1839338687) | `src/i_video.ml:2542` | 13 | 16 | 8 | 9 | 2 | 404.09 | 56.37 |
| [`I_NetCmd`](File-src-i-net-ml-1331775872.md#function-function-i-netcmd-function-i-netcmd-src-i-net-ml-118273743) | `src/i_net.ml:371` | 28 | 23 | 14 | 18 | 3 | 1049.95 | 45.39 |
| [`I_PauseSong`](File-src-i-sound-ml-33806980.md#function-function-i-pausesong-function-i-pausesong-handle-src-i-sound-ml-1081518863) | `src/i_sound.ml:1718` | 9 | 10 | 6 | 5 | 1 | 312.11 | 60.91 |
| [`I_PlaySong`](File-src-i-sound-ml-33806980.md#function-function-i-playsong-function-i-playsong-handle-looping-src-i-sound-ml-349515657) | `src/i_sound.ml:1759` | 12 | 12 | 3 | 2 | 1 | 388.64 | 57.92 |
| [`I_PollInput`](File-src-i-video-ml-140536292.md#function-function-i-pollinput-function-i-pollinput-src-i-video-ml-1448869485) | `src/i_video.ml:2557` | 5 | 3 | 1 | 0 | 0 | 45 | 73.04 |
| [`I_PrecacheSfx`](File-src-i-sound-ml-33806980.md#function-function-i-precachesfx-function-i-precachesfx-id-src-i-sound-ml-1086435546) | `src/i_sound.ml:1605` | 5 | 4 | 2 | 1 | 1 | 127.44 | 69.74 |
| [`I_PrepareHDWipeEnd`](File-src-i-video-ml-140536292.md#function-function-i-preparehdwipeend-function-i-preparehdwipeend-src-i-video-ml-1620471307) | `src/i_video.ml:715` | 52 | 63 | 32 | 43 | 3 | 3106.53 | 33.81 |
| [`I_QrySongPlaying`](File-src-i-sound-ml-33806980.md#function-function-i-qrysongplaying-function-i-qrysongplaying-handle-src-i-sound-ml-1385331997) | `src/i_sound.ml:1814` | 5 | 4 | 2 | 1 | 1 | 165.06 | 68.96 |
| [`I_Quit`](File-src-i-system-ml-1632920966.md#function-function-i-quit-function-i-quit-src-i-system-ml-835643483) | `src/i_system.ml:168` | 9 | 13 | 7 | 6 | 1 | 366.95 | 60.29 |
| [`I_ReadScreen`](File-src-i-video-ml-140536292.md#function-function-i-readscreen-function-i-readscreen-scr-src-i-video-ml-741646909) | `src/i_video.ml:2661` | 5 | 4 | 2 | 1 | 1 | 171.9 | 68.83 |
| [`I_RegisterSong`](File-src-i-sound-ml-33806980.md#function-function-i-registersong-function-i-registersong-data-src-i-sound-ml-1797909367) | `src/i_sound.ml:1745` | 8 | 6 | 1 | 0 | 0 | 150.12 | 64.93 |
| [`I_ResumeSong`](File-src-i-sound-ml-33806980.md#function-function-i-resumesong-function-i-resumesong-handle-src-i-sound-ml-1150755005) | `src/i_sound.ml:1731` | 10 | 10 | 5 | 4 | 1 | 284.6 | 60.33 |
| [`I_SetChannels`](File-src-i-sound-ml-33806980.md#function-function-i-setchannels-function-i-setchannels-src-i-sound-ml-2043678511) | `src/i_sound.ml:1584` | 4 | 2 | 1 | 0 | 0 | 33.69 | 76.04 |
| [`I_SetForceSoftwarePresent`](File-src-i-video-ml-140536292.md#function-function-i-setforcesoftwarepresent-function-i-setforcesoftwarepresent-v-src-i-video-ml-734667613) | `src/i_video.ml:558` | 5 | 4 | 3 | 2 | 1 | 110.36 | 70.05 |
| [`I_SetLoadingStatus`](File-src-i-video-ml-140536292.md#function-function-i-setloadingstatus-function-i-setloadingstatus-text-src-i-video-ml-60940544) | `src/i_video.ml:2525` | 14 | 12 | 4 | 3 | 1 | 315.77 | 56.96 |
| [`I_SetMusicVolume`](File-src-i-sound-ml-33806980.md#function-function-i-setmusicvolume-function-i-setmusicvolume-volume-src-i-sound-ml-1971671213) | `src/i_sound.ml:1697` | 9 | 6 | 2 | 1 | 1 | 269.21 | 61.9 |
| [`I_SetPalette`](File-src-i-video-ml-140536292.md#function-function-i-setpalette-function-i-setpalette-palette-src-i-video-ml-729637086) | `src/i_video.ml:2419` | 24 | 27 | 14 | 15 | 2 | 965.88 | 47.11 |
| [`I_SetSfxVolume`](File-src-i-sound-ml-33806980.md#function-function-i-setsfxvolume-function-i-setsfxvolume-volume-src-i-sound-ml-1877243865) | `src/i_sound.ml:1711` | 4 | 2 | 1 | 0 | 0 | 49.83 | 74.85 |
| [`I_ShutdownGraphics`](File-src-i-video-ml-140536292.md#function-function-i-shutdowngraphics-function-i-shutdowngraphics-src-i-video-ml-876306099) | `src/i_video.ml:2392` | 20 | 16 | 5 | 6 | 2 | 366.63 | 52.99 |
| [`I_ShutdownMusic`](File-src-i-sound-ml-33806980.md#function-function-i-shutdownmusic-function-i-shutdownmusic-src-i-sound-ml-1252286321) | `src/i_sound.ml:1690` | 4 | 2 | 1 | 0 | 0 | 39 | 75.59 |
| [`I_ShutdownSound`](File-src-i-sound-ml-33806980.md#function-function-i-shutdownsound-function-i-shutdownsound-src-i-sound-ml-528136829) | `src/i_sound.ml:1577` | 5 | 3 | 1 | 0 | 0 | 45 | 73.04 |
| [`I_SoundDelTimer`](File-src-i-sound-ml-33806980.md#function-function-i-sounddeltimer-function-i-sounddeltimer-src-i-sound-ml-162024089) | `src/i_sound.ml:1902` | 4 | 2 | 1 | 0 | 0 | 34.87 | 75.93 |
| [`I_SoundIsPlaying`](File-src-i-sound-ml-33806980.md#function-function-i-soundisplaying-function-i-soundisplaying-handle-src-i-sound-ml-199282925) | `src/i_sound.ml:1643` | 10 | 9 | 4 | 3 | 1 | 330.12 | 60.01 |
| [`I_SoundSetTimer`](File-src-i-sound-ml-33806980.md#function-function-i-soundsettimer-function-i-soundsettimer-ticks-src-i-sound-ml-1630880039) | `src/i_sound.ml:1895` | 5 | 3 | 1 | 0 | 0 | 49.83 | 72.73 |
| [`I_StartFrame`](File-src-i-video-ml-140536292.md#function-function-i-startframe-function-i-startframe-src-i-video-ml-2021092591) | `src/i_video.ml:2731` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`I_StartSound`](File-src-i-sound-ml-33806980.md#function-function-i-startsound-function-i-startsound-id-vol-sep-pitch-priority-src-i-sound-ml-1272039505) | `src/i_sound.ml:1617` | 11 | 12 | 5 | 4 | 1 | 557.41 | 57.38 |
| [`I_StartTic`](File-src-i-video-ml-140536292.md#function-function-i-starttic-function-i-starttic-src-i-video-ml-1348154195) | `src/i_video.ml:2736` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`I_StopSong`](File-src-i-sound-ml-33806980.md#function-function-i-stopsong-function-i-stopsong-handle-src-i-sound-ml-107872333) | `src/i_sound.ml:1777` | 8 | 5 | 3 | 2 | 1 | 183.4 | 64.05 |
| [`I_StopSound`](File-src-i-sound-ml-33806980.md#function-function-i-stopsound-function-i-stopsound-handle-src-i-sound-ml-1659252435) | `src/i_sound.ml:1635` | 5 | 4 | 2 | 1 | 1 | 110.36 | 70.18 |
| [`I_SubmitSound`](File-src-i-sound-ml-33806980.md#function-function-i-submitsound-function-i-submitsound-src-i-sound-ml-1767705745) | `src/i_sound.ml:1567` | 7 | 4 | 2 | 1 | 1 | 87.57 | 67.7 |
| [`I_Tactile`](File-src-i-system-ml-1632920966.md#function-function-i-tactile-function-i-tactile-on-off-total-src-i-system-ml-1923541287) | `src/i_system.ml:191` | 5 | 3 | 1 | 0 | 0 | 69.19 | 71.73 |
| [`I_UnRegisterSong`](File-src-i-sound-ml-33806980.md#function-function-i-unregistersong-function-i-unregistersong-handle-src-i-sound-ml-919685053) | `src/i_sound.ml:1789` | 18 | 14 | 7 | 7 | 2 | 541.78 | 52.53 |
| [`I_UpdateNoBlit`](File-src-i-video-ml-140536292.md#function-function-i-updatenoblit-function-i-updatenoblit-src-i-video-ml-1030797555) | `src/i_video.ml:2449` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`I_UpdateSound`](File-src-i-sound-ml-33806980.md#function-function-i-updatesound-function-i-updatesound-src-i-sound-ml-817754735) | `src/i_sound.ml:1562` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`I_UpdateSoundParams`](File-src-i-sound-ml-33806980.md#function-function-i-updatesoundparams-function-i-updatesoundparams-handle-vol-sep-pitch-src-i-sound-ml-2144610604) | `src/i_sound.ml:1662` | 9 | 9 | 4 | 3 | 1 | 496.31 | 59.77 |
| [`I_WaitVBL`](File-src-i-system-ml-1632920966.md#function-function-i-waitvbl-function-i-waitvbl-count-src-i-system-ml-290254782) | `src/i_system.ml:245` | 4 | 2 | 1 | 0 | 0 | 55.35 | 74.53 |
| [`I_ZoneBase`](File-src-i-system-ml-1632920966.md#function-function-i-zonebase-function-i-zonebase-sizeout-src-i-system-ml-1467315904) | `src/i_system.ml:117` | 7 | 4 | 3 | 2 | 1 | 178.38 | 65.4 |
| [`IdentifyVersion`](File-src-d-main-ml-105344057.md#function-function-identifyversion-function-identifyversion-src-d-main-ml-887866944) | `src/d_main.ml:1602` | 44 | 27 | 13 | 22 | 3 | 1541.32 | 40.08 |
| [`IGL_Begin2D`](File-src-i-gl-ml-2113703076.md#function-function-igl-begin2d-function-igl-begin2d-src-i-gl-ml-166738217) | `src/i_gl.ml:1244` | 13 | 12 | 2 | 1 | 1 | 275.78 | 58.34 |
| [`IGL_Begin3D`](File-src-i-gl-ml-2113703076.md#function-function-igl-begin3d-function-igl-begin3d-src-i-gl-ml-1335136043) | `src/i_gl.ml:849` | 22 | 22 | 3 | 2 | 1 | 607.59 | 50.82 |
| [`IGL_CaptureLogicalIndexed`](File-src-i-gl-ml-2113703076.md#function-function-igl-capturelogicalindexed-function-igl-capturelogicalindexed-dest-logicalw-logicalh-src-i-gl-ml-881340740) | `src/i_gl.ml:1005` | 33 | 38 | 18 | 24 | 3 | 1801.6 | 41.66 |
| [`IGL_CaptureRGBA`](File-src-i-gl-ml-2113703076.md#function-function-igl-capturergba-function-igl-capturergba-dest-outw-outh-front-src-i-gl-ml-1871880969) | `src/i_gl.ml:1049` | 41 | 44 | 20 | 26 | 3 | 2130.61 | 38.82 |
| [`IGL_ConfigureFramePacing`](File-src-i-gl-ml-2113703076.md#function-function-igl-configureframepacing-function-igl-configureframepacing-src-i-gl-ml-1246744489) | `src/i_gl.ml:675` | 26 | 26 | 16 | 21 | 3 | 999.83 | 45.98 |
| [`IGL_CreateFuzzMaskTexture`](File-src-i-gl-ml-2113703076.md#function-function-igl-createfuzzmasktexture-function-igl-createfuzzmasktexture-data-width-height-transparent-src-i-gl-ml-1676390126) | `src/i_gl.ml:1149` | 46 | 48 | 15 | 23 | 4 | 2230.51 | 38.27 |
| [`IGL_CreateIndexedTexture`](File-src-i-gl-ml-2113703076.md#function-function-igl-createindexedtexture-function-igl-createindexedtexture-data-width-height-transparent-src-i-gl-ml-1809621044) | `src/i_gl.ml:1203` | 3 | 1 | 1 | 0 | 0 | 99.91 | 75.46 |
| [`IGL_CreateIndexedTextureEx`](File-src-i-gl-ml-2113703076.md#function-function-igl-createindexedtextureex-function-igl-createindexedtextureex-data-width-height-transparent-repeatwrap-src-i-gl-ml-1493595861) | `src/i_gl.ml:1101` | 40 | 44 | 17 | 17 | 2 | 2050.34 | 39.58 |
| [`IGL_DrawIndexedFrame`](File-src-i-gl-ml-2113703076.md#function-function-igl-drawindexedframe-function-igl-drawindexedframe-data-width-height-src-i-gl-ml-1616895490) | `src/i_gl.ml:1299` | 53 | 58 | 17 | 16 | 1 | 2507.88 | 36.3 |
| [`IGL_DrawIndexedOverlay`](File-src-i-gl-ml-2113703076.md#function-function-igl-drawindexedoverlay-function-igl-drawindexedoverlay-data-mask-width-height-src-i-gl-ml-1507091410) | `src/i_gl.ml:1423` | 14 | 19 | 13 | 12 | 1 | 774.52 | 53.02 |
| [`IGL_DrawIndexedOverlayLayers`](File-src-i-gl-ml-2113703076.md#function-function-igl-drawindexedoverlaylayers-function-igl-drawindexedoverlaylayers-logical-logicalmask-logicalminx-logicalminy-logicalmaxx-logicalmaxy-highres-highresmask-highresminx-highresminy-highresmaxx-highresmaxy-width-height-statusy-src-i-gl-ml-867658311) | `src/i_gl.ml:1455` | 22 | 29 | 22 | 24 | 3 | 1845.26 | 44.89 |
| [`IGL_DrawPaletteFlash`](File-src-i-gl-ml-2113703076.md#function-function-igl-drawpaletteflash-function-igl-drawpaletteflash-src-i-gl-ml-1541982853) | `src/i_gl.ml:1399` | 16 | 17 | 4 | 3 | 1 | 530 | 54.12 |
| [`IGL_DrawRGBAFrame`](File-src-i-gl-ml-2113703076.md#function-function-igl-drawrgbaframe-function-igl-drawrgbaframe-data-width-height-src-i-gl-ml-2039715250) | `src/i_gl.ml:1361` | 34 | 39 | 10 | 9 | 1 | 1482.43 | 43.04 |
| [`IGL_DrawTextureRect`](File-src-i-gl-ml-2113703076.md#function-function-igl-drawtexturerect-function-igl-drawtexturerect-texid-x-y-width-height-flipped-src-i-gl-ml-1416428869) | `src/i_gl.ml:1265` | 26 | 25 | 6 | 5 | 1 | 1054.44 | 47.16 |
| [`IGL_EnsureFrameTexture`](File-src-i-gl-ml-2113703076.md#function-function-igl-ensureframetexture-function-igl-ensureframetexture-src-i-gl-ml-1142756917) | `src/i_gl.ml:1226` | 14 | 14 | 3 | 2 | 1 | 431.81 | 56.14 |
| [`IGL_EnsureOverlayTexture`](File-src-i-gl-ml-2113703076.md#function-function-igl-ensureoverlaytexture-function-igl-ensureoverlaytexture-src-i-gl-ml-41255577) | `src/i_gl.ml:1208` | 14 | 14 | 3 | 2 | 1 | 431.81 | 56.14 |
| [`IGL_HasFrameReady`](File-src-i-gl-ml-2113703076.md#function-function-igl-hasframeready-function-igl-hasframeready-src-i-gl-ml-924953487) | `src/i_gl.ml:881` | 3 | 1 | 1 | 0 | 0 | 38.04 | 78.39 |
| [`IGL_Init`](File-src-i-gl-ml-2113703076.md#function-function-igl-init-function-igl-init-hwnd-hdc-width-height-src-i-gl-ml-201721240) | `src/i_gl.ml:762` | 60 | 58 | 9 | 8 | 1 | 1834.48 | 37.15 |
| [`IGL_IsActive`](File-src-i-gl-ml-2113703076.md#function-function-igl-isactive-function-igl-isactive-src-i-gl-ml-2095981625) | `src/i_gl.ml:706` | 3 | 1 | 1 | 0 | 0 | 46.51 | 77.78 |
| [`IGL_IsAvailable`](File-src-i-gl-ml-2113703076.md#function-function-igl-isavailable-function-igl-isavailable-src-i-gl-ml-855297625) | `src/i_gl.ml:711` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`IGL_MakeCurrent`](File-src-i-gl-ml-2113703076.md#function-function-igl-makecurrent-function-igl-makecurrent-src-i-gl-ml-537290857) | `src/i_gl.ml:716` | 5 | 5 | 4 | 3 | 1 | 141.78 | 69.15 |
| [`IGL_MarkFrameReady`](File-src-i-gl-ml-2113703076.md#function-function-igl-markframeready-function-igl-markframeready-src-i-gl-ml-1591438137) | `src/i_gl.ml:875` | 4 | 3 | 2 | 1 | 1 | 57.36 | 74.28 |
| [`IGL_NearestPaletteIndex`](File-src-i-gl-ml-2113703076.md#function-function-igl-nearestpaletteindex-function-igl-nearestpaletteindex-r-g-b-src-i-gl-ml-1698771178) | `src/i_gl.ml:964` | 31 | 29 | 15 | 17 | 3 | 1458.64 | 43.3 |
| [`IGL_ReadU32`](File-src-i-gl-ml-2113703076.md#function-function-igl-readu32-inline-function-igl-readu32-buf-off-src-i-gl-ml-419493286) | `src/i_gl.ml:658` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`IGL_Resize`](File-src-i-gl-ml-2113703076.md#function-function-igl-resize-function-igl-resize-width-height-src-i-gl-ml-891394846) | `src/i_gl.ml:836` | 10 | 11 | 6 | 5 | 1 | 271.41 | 60.34 |
| [`IGL_SetPalette`](File-src-i-gl-ml-2113703076.md#function-function-igl-setpalette-function-igl-setpalette-palette-src-i-gl-ml-1072310958) | `src/i_gl.ml:909` | 13 | 12 | 3 | 2 | 1 | 363.11 | 57.37 |
| [`IGL_SetPaletteFlash`](File-src-i-gl-ml-2113703076.md#function-function-igl-setpaletteflash-function-igl-setpaletteflash-paletteindex-src-i-gl-ml-43342346) | `src/i_gl.ml:926` | 30 | 24 | 9 | 8 | 1 | 679.4 | 46.74 |
| [`IGL_SetRendererEnabled`](File-src-i-gl-ml-2113703076.md#function-function-igl-setrendererenabled-function-igl-setrendererenabled-v-src-i-gl-ml-1211173921) | `src/i_gl.ml:724` | 24 | 20 | 5 | 4 | 1 | 398.35 | 51.01 |
| [`IGL_Shutdown`](File-src-i-gl-ml-2113703076.md#function-function-igl-shutdown-function-igl-shutdown-src-i-gl-ml-1510068453) | `src/i_gl.ml:1481` | 16 | 14 | 3 | 3 | 2 | 266.89 | 56.34 |
| [`IGL_Swap`](File-src-i-gl-ml-2113703076.md#function-function-igl-swap-function-igl-swap-src-i-gl-ml-1133720761) | `src/i_gl.ml:887` | 17 | 18 | 8 | 9 | 2 | 399.41 | 53.87 |
| [`IGL_ToggleRenderer`](File-src-i-gl-ml-2113703076.md#function-function-igl-togglerenderer-function-igl-togglerenderer-src-i-gl-ml-1253250857) | `src/i_gl.ml:752` | 4 | 3 | 2 | 1 | 1 | 74.01 | 73.51 |
| [`IGL_WantsOpenGL`](File-src-i-gl-ml-2113703076.md#function-function-igl-wantsopengl-function-igl-wantsopengl-src-i-gl-ml-215185475) | `src/i_gl.ml:663` | 10 | 7 | 3 | 2 | 1 | 292.56 | 60.51 |
| [`IGL_WriteU16`](File-src-i-gl-ml-2113703076.md#function-function-igl-writeu16-inline-function-igl-writeu16-buf-off-value-src-i-gl-ml-1426558611) | `src/i_gl.ml:637` | 5 | 3 | 1 | 0 | 0 | 171.3 | 68.98 |
| [`IGL_WriteU32`](File-src-i-gl-ml-2113703076.md#function-function-igl-writeu32-inline-function-igl-writeu32-buf-off-value-src-i-gl-ml-1516734675) | `src/i_gl.ml:647` | 7 | 5 | 1 | 0 | 0 | 298.02 | 64.11 |
| [`Info_StateAt`](File-src-info-ml-1415270573.md#function-function-info-stateat-function-info-stateat-s-src-info-ml-1130611297) | `src/info.ml:6643` | 7 | 8 | 4 | 3 | 1 | 230.7 | 64.48 |
| [`Info_StateIndex`](File-src-info-ml-1415270573.md#function-function-info-stateindex-function-info-stateindex-s-src-info-ml-2114878573) | `src/info.ml:3728` | 2911 | 971 | 969 | 2 | 1 | 84888.1 | 0 |
| [`InitExpand`](File-src-i-video-ml-140536292.md#function-function-initexpand-function-initexpand-src-i-video-ml-1416737831) | `src/i_video.ml:2682` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`InitExpand2`](File-src-i-video-ml-140536292.md#function-function-initexpand2-function-initexpand2-src-i-video-ml-492636399) | `src/i_video.ml:2686` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`LONG`](File-src-m-swap-ml-1401834276.md#function-function-long-function-long-x-src-m-swap-ml-300045343) | `src/m_swap.ml:51` | 4 | 3 | 2 | 1 | 1 | 65.73 | 73.87 |
| [`M_AddToBox`](File-src-m-bbox-ml-1176525784.md#function-function-m-addtobox-function-m-addtobox-box-x-y-src-m-bbox-ml-1709159541) | `src/m_bbox.ml:54` | 14 | 10 | 7 | 6 | 1 | 432.44 | 55.6 |
| [`M_ChangeBrightness`](File-src-m-menu-ml-331716860.md#function-function-m-changebrightness-function-m-changebrightness-choice-src-m-menu-ml-2124363704) | `src/m_menu.ml:2061` | 18 | 13 | 11 | 13 | 2 | 652.47 | 51.43 |
| [`M_ChangeDetail`](File-src-m-menu-ml-331716860.md#function-function-m-changedetail-function-m-changedetail-choice-src-m-menu-ml-398936580) | `src/m_menu.ml:2041` | 15 | 10 | 6 | 6 | 2 | 391.73 | 55.38 |
| [`M_ChangeMessages`](File-src-m-menu-ml-331716860.md#function-function-m-changemessages-function-m-changemessages-choice-src-m-menu-ml-437667500) | `src/m_menu.ml:1931` | 15 | 9 | 6 | 7 | 2 | 416.15 | 55.2 |
| [`M_ChangeSensitivity`](File-src-m-menu-ml-331716860.md#function-function-m-changesensitivity-function-m-changesensitivity-choice-src-m-menu-ml-1272134622) | `src/m_menu.ml:2030` | 8 | 6 | 5 | 6 | 2 | 198.81 | 63.53 |
| [`M_CheckParm`](File-src-m-argv-ml-728984635.md#function-function-m-checkparm-function-m-checkparm-check-src-m-argv-ml-541263268) | `src/m_argv.ml:45` | 10 | 6 | 3 | 3 | 2 | 169.46 | 62.17 |
| [`M_ChooseSkill`](File-src-m-menu-ml-331716860.md#function-function-m-chooseskill-function-m-chooseskill-choice-src-m-menu-ml-744107012) | `src/m_menu.ml:1877` | 8 | 5 | 2 | 1 | 1 | 158.12 | 64.63 |
| [`M_ClearBox`](File-src-m-bbox-ml-1176525784.md#function-function-m-clearbox-function-m-clearbox-box-src-m-bbox-ml-286265496) | `src/m_bbox.ml:39` | 8 | 8 | 3 | 2 | 1 | 226.18 | 63.41 |
| [`M_ClearMenus`](File-src-m-menu-ml-331716860.md#function-function-m-clearmenus-function-m-clearmenus-src-m-menu-ml-1187377101) | `src/m_menu.ml:2947` | 12 | 9 | 2 | 1 | 1 | 128 | 61.44 |
| [`M_ClearRandom`](File-src-m-random-ml-1659574948.md#function-function-m-clearrandom-function-m-clearrandom-src-m-random-ml-880149801) | `src/m_random.ml:69` | 6 | 4 | 1 | 0 | 0 | 53.15 | 70.81 |
| [`M_DoSave`](File-src-m-menu-ml-331716860.md#function-function-m-dosave-function-m-dosave-slot-src-m-menu-ml-873000857) | `src/m_menu.ml:944` | 8 | 5 | 2 | 1 | 1 | 153.73 | 64.72 |
| [`M_DrawEmptyCell`](File-src-m-menu-ml-331716860.md#function-function-m-drawemptycell-function-m-drawemptycell-menu-item-src-m-menu-ml-525479159) | `src/m_menu.ml:2124` | 4 | 1 | 1 | 0 | 0 | 160.54 | 71.29 |
| [`M_DrawEpisode`](File-src-m-menu-ml-331716860.md#function-function-m-drawepisode-function-m-drawepisode-src-m-menu-ml-1089180251) | `src/m_menu.ml:1863` | 3 | 1 | 1 | 0 | 0 | 77.71 | 76.22 |
| [`M_Drawer`](File-src-m-menu-ml-331716860.md#function-function-m-drawer-function-m-drawer-src-m-menu-ml-1228950853) | `src/m_menu.ml:2887` | 45 | 38 | 16 | 27 | 4 | 1906.02 | 38.82 |
| [`M_DrawLoad`](File-src-m-menu-ml-331716860.md#function-function-m-drawload-function-m-drawload-src-m-menu-ml-181506249) | `src/m_menu.ml:887` | 7 | 4 | 2 | 1 | 1 | 320 | 63.75 |
| [`M_DrawMainMenu`](File-src-m-menu-ml-331716860.md#function-function-m-drawmainmenu-function-m-drawmainmenu-src-m-menu-ml-950761865) | `src/m_menu.ml:1107` | 5 | 3 | 1 | 0 | 0 | 195.04 | 68.58 |
| [`M_DrawMPHostMenu`](File-src-m-menu-ml-331716860.md#function-function-m-drawmphostmenu-function-m-drawmphostmenu-src-m-menu-ml-1471969465) | `src/m_menu.ml:1366` | 28 | 26 | 1 | 0 | 0 | 1135.35 | 46.91 |
| [`M_DrawMPJoinMenu`](File-src-m-menu-ml-331716860.md#function-function-m-drawmpjoinmenu-function-m-drawmpjoinmenu-src-m-menu-ml-349421697) | `src/m_menu.ml:1396` | 17 | 14 | 2 | 1 | 1 | 569.45 | 53.6 |
| [`M_DrawMPNameMenu`](File-src-m-menu-ml-331716860.md#function-function-m-drawmpnamemenu-function-m-drawmpnamemenu-src-m-menu-ml-1429309861) | `src/m_menu.ml:1415` | 15 | 12 | 2 | 1 | 1 | 465.29 | 55.4 |
| [`M_DrawMultiplayerMenu`](File-src-m-menu-ml-331716860.md#function-function-m-drawmultiplayermenu-function-m-drawmultiplayermenu-src-m-menu-ml-1796855187) | `src/m_menu.ml:1328` | 9 | 7 | 1 | 0 | 0 | 337.6 | 61.35 |
| [`M_DrawNewGame`](File-src-m-menu-ml-331716860.md#function-function-m-drawnewgame-function-m-drawnewgame-src-m-menu-ml-2125858121) | `src/m_menu.ml:1841` | 4 | 2 | 1 | 0 | 0 | 144 | 71.62 |
| [`M_DrawOptions`](File-src-m-menu-ml-331716860.md#function-function-m-drawoptions-function-m-drawoptions-src-m-menu-ml-756874409) | `src/m_menu.ml:1907` | 11 | 7 | 1 | 0 | 0 | 862.78 | 56.59 |
| [`M_DrawReadThis1`](File-src-m-menu-ml-331716860.md#function-function-m-drawreadthis1-function-m-drawreadthis1-src-m-menu-ml-1023348683) | `src/m_menu.ml:1047` | 9 | 5 | 5 | 4 | 1 | 336.51 | 60.82 |
| [`M_DrawReadThis2`](File-src-m-menu-ml-331716860.md#function-function-m-drawreadthis2-function-m-drawreadthis2-src-m-menu-ml-2023572297) | `src/m_menu.ml:1058` | 9 | 5 | 5 | 4 | 1 | 336.51 | 60.82 |
| [`M_DrawSave`](File-src-m-menu-ml-331716860.md#function-function-m-drawsave-function-m-drawsave-src-m-menu-ml-1946530965) | `src/m_menu.ml:929` | 11 | 7 | 3 | 2 | 1 | 517.97 | 57.87 |
| [`M_DrawSaveLoadBorder`](File-src-m-menu-ml-331716860.md#function-function-m-drawsaveloadborder-function-m-drawsaveloadborder-x-y-src-m-menu-ml-434722100) | `src/m_menu.ml:898` | 8 | 5 | 2 | 1 | 1 | 343.87 | 62.27 |
| [`M_DrawSelCell`](File-src-m-menu-ml-331716860.md#function-function-m-drawselcell-function-m-drawselcell-menu-item-src-m-menu-ml-411363629) | `src/m_menu.ml:2132` | 4 | 1 | 1 | 0 | 0 | 160.54 | 71.29 |
| [`M_DrawSound`](File-src-m-menu-ml-331716860.md#function-function-m-drawsound-function-m-drawsound-src-m-menu-ml-898928195) | `src/m_menu.ml:1069` | 5 | 3 | 1 | 0 | 0 | 309.07 | 67.18 |
| [`M_DrawText`](File-src-m-misc-ml-906836777.md#function-function-m-drawtext-function-m-drawtext-x-y-direct-string-src-m-misc-ml-1205478345) | `src/m_misc.ml:644` | 36 | 29 | 11 | 15 | 2 | 1049.76 | 43.42 |
| [`M_DrawThermo`](File-src-m-menu-ml-331716860.md#function-function-m-drawthermo-function-m-drawthermo-x-y-thermwidth-thermdot-src-m-menu-ml-1846282897) | `src/m_menu.ml:2108` | 11 | 8 | 2 | 1 | 1 | 499.96 | 58.12 |
| [`M_EndGame`](File-src-m-menu-ml-331716860.md#function-function-m-endgame-function-m-endgame-choice-src-m-menu-ml-318353922) | `src/m_menu.ml:1959` | 12 | 8 | 3 | 2 | 1 | 218.26 | 59.68 |
| [`M_EndGameResponse`](File-src-m-menu-ml-331716860.md#function-function-m-endgameresponse-function-m-endgameresponse-ch-src-m-menu-ml-666204736) | `src/m_menu.ml:1950` | 6 | 5 | 2 | 1 | 1 | 108.42 | 68.51 |
| [`M_Episode`](File-src-m-menu-ml-331716860.md#function-function-m-episode-function-m-episode-choice-src-m-menu-ml-273551598) | `src/m_menu.ml:1889` | 13 | 9 | 5 | 4 | 1 | 284.6 | 57.84 |
| [`M_FinishReadThis`](File-src-m-menu-ml-331716860.md#function-function-m-finishreadthis-function-m-finishreadthis-choice-src-m-menu-ml-430302588) | `src/m_menu.ml:1990` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_Init`](File-src-m-menu-ml-331716860.md#function-function-m-init-function-m-init-src-m-menu-ml-2060382161) | `src/m_menu.ml:2991` | 67 | 60 | 6 | 5 | 1 | 1865.01 | 36.46 |
| [`M_LoadDefaults`](File-src-m-misc-ml-906836777.md#function-function-m-loaddefaults-function-m-loaddefaults-src-m-misc-ml-1321362704) | `src/m_misc.ml:544` | 48 | 44 | 8 | 11 | 3 | 1152.31 | 40.81 |
| [`M_LoadGame`](File-src-m-menu-ml-331716860.md#function-function-m-loadgame-function-m-loadgame-choice-src-m-menu-ml-663514720) | `src/m_menu.ml:917` | 9 | 6 | 2 | 1 | 1 | 131.69 | 64.07 |
| [`M_LoadSelect`](File-src-m-menu-ml-331716860.md#function-function-m-loadselect-function-m-loadselect-choice-src-m-menu-ml-801573676) | `src/m_menu.ml:909` | 5 | 3 | 1 | 0 | 0 | 69.19 | 71.73 |
| [`M_MPHostFragLimit`](File-src-m-menu-ml-331716860.md#function-function-m-mphostfraglimit-function-m-mphostfraglimit-choice-src-m-menu-ml-1910511720) | `src/m_menu.ml:1479` | 11 | 9 | 4 | 3 | 1 | 219.62 | 60.35 |
| [`M_MPHostMap`](File-src-m-menu-ml-331716860.md#function-function-m-mphostmap-function-m-mphostmap-choice-src-m-menu-ml-2098823054) | `src/m_menu.ml:1445` | 7 | 3 | 2 | 1 | 1 | 91.38 | 67.57 |
| [`M_MPHostMenuOpen`](File-src-m-menu-ml-331716860.md#function-function-m-mphostmenuopen-function-m-mphostmenuopen-choice-src-m-menu-ml-423651020) | `src/m_menu.ml:1340` | 7 | 5 | 1 | 0 | 0 | 82.45 | 68.01 |
| [`M_MPHostMode`](File-src-m-menu-ml-331716860.md#function-function-m-mphostmode-function-m-mphostmode-choice-src-m-menu-ml-1718503636) | `src/m_menu.ml:1433` | 9 | 5 | 2 | 1 | 1 | 116 | 64.46 |
| [`M_MPHostPlayers`](File-src-m-menu-ml-331716860.md#function-function-m-mphostplayers-function-m-mphostplayers-choice-src-m-menu-ml-259340962) | `src/m_menu.ml:1467` | 9 | 5 | 2 | 1 | 1 | 125.1 | 64.23 |
| [`M_MPHostPort`](File-src-m-menu-ml-331716860.md#function-function-m-mphostport-function-m-mphostport-choice-src-m-menu-ml-1674743224) | `src/m_menu.ml:1507` | 9 | 5 | 2 | 1 | 1 | 125.1 | 64.23 |
| [`M_MPHostSkill`](File-src-m-menu-ml-331716860.md#function-function-m-mphostskill-function-m-mphostskill-choice-src-m-menu-ml-28381184) | `src/m_menu.ml:1455` | 9 | 5 | 2 | 1 | 1 | 162.52 | 63.43 |
| [`M_MPHostStart`](File-src-m-menu-ml-331716860.md#function-function-m-mphoststart-function-m-mphoststart-choice-src-m-menu-ml-27557498) | `src/m_menu.ml:1563` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_MPHostTimeLimit`](File-src-m-menu-ml-331716860.md#function-function-m-mphosttimelimit-function-m-mphosttimelimit-choice-src-m-menu-ml-684199302) | `src/m_menu.ml:1493` | 11 | 9 | 4 | 3 | 1 | 219.62 | 60.35 |
| [`M_MPJoinEditHost`](File-src-m-menu-ml-331716860.md#function-function-m-mpjoinedithost-function-m-mpjoinedithost-choice-src-m-menu-ml-775020076) | `src/m_menu.ml:1570` | 9 | 7 | 1 | 0 | 0 | 130.8 | 64.23 |
| [`M_MPJoinMenuOpen`](File-src-m-menu-ml-331716860.md#function-function-m-mpjoinmenuopen-function-m-mpjoinmenuopen-choice-src-m-menu-ml-1068280160) | `src/m_menu.ml:1350` | 6 | 4 | 1 | 0 | 0 | 69.19 | 70.01 |
| [`M_MPJoinPort`](File-src-m-menu-ml-331716860.md#function-function-m-mpjoinport-function-m-mpjoinport-choice-src-m-menu-ml-951348120) | `src/m_menu.ml:1582` | 9 | 5 | 2 | 1 | 1 | 125.1 | 64.23 |
| [`M_MPJoinStart`](File-src-m-menu-ml-331716860.md#function-function-m-mpjoinstart-function-m-mpjoinstart-choice-src-m-menu-ml-1665563238) | `src/m_menu.ml:1645` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_MPNameDone`](File-src-m-menu-ml-331716860.md#function-function-m-mpnamedone-function-m-mpnamedone-choice-src-m-menu-ml-1634682072) | `src/m_menu.ml:1829` | 10 | 7 | 2 | 1 | 1 | 152.93 | 62.62 |
| [`M_MPNameEdit`](File-src-m-menu-ml-331716860.md#function-function-m-mpnameedit-function-m-mpnameedit-choice-src-m-menu-ml-565035416) | `src/m_menu.ml:1817` | 9 | 7 | 1 | 0 | 0 | 130.8 | 64.23 |
| [`M_MPNameMenuOpen`](File-src-m-menu-ml-331716860.md#function-function-m-mpnamemenuopen-function-m-mpnamemenuopen-choice-src-m-menu-ml-1470875060) | `src/m_menu.ml:1359` | 5 | 3 | 1 | 0 | 0 | 56.47 | 72.35 |
| [`M_MPStartFromCommandLine`](File-src-m-menu-ml-331716860.md#function-function-m-mpstartfromcommandline-function-m-mpstartfromcommandline-src-m-menu-ml-1946413497) | `src/m_menu.ml:1710` | 95 | 84 | 32 | 44 | 3 | 3826.42 | 27.47 |
| [`M_Multiplayer`](File-src-m-menu-ml-331716860.md#function-function-m-multiplayer-function-m-multiplayer-choice-src-m-menu-ml-1309081912) | `src/m_menu.ml:1319` | 7 | 5 | 1 | 0 | 0 | 82.45 | 68.01 |
| [`M_MusicVol`](File-src-m-menu-ml-331716860.md#function-function-m-musicvol-function-m-musicvol-choice-src-m-menu-ml-1623692320) | `src/m_menu.ml:1096` | 9 | 7 | 5 | 6 | 2 | 219.62 | 62.12 |
| [`M_NewGame`](File-src-m-menu-ml-331716860.md#function-function-m-newgame-function-m-newgame-choice-src-m-menu-ml-1323498888) | `src/m_menu.ml:1848` | 12 | 7 | 4 | 3 | 1 | 216.33 | 59.57 |
| [`M_Options`](File-src-m-menu-ml-331716860.md#function-function-m-options-function-m-options-choice-src-m-menu-ml-874359868) | `src/m_menu.ml:1924` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_QuickLoad`](File-src-m-menu-ml-331716860.md#function-function-m-quickload-function-m-quickload-src-m-menu-ml-1910442787) | `src/m_menu.ml:1030` | 13 | 9 | 3 | 2 | 1 | 288.44 | 58.07 |
| [`M_QuickLoadResponse`](File-src-m-menu-ml-331716860.md#function-function-m-quickloadresponse-function-m-quickloadresponse-ch-src-m-menu-ml-896288624) | `src/m_menu.ml:1022` | 6 | 3 | 2 | 1 | 1 | 108.42 | 68.51 |
| [`M_QuickSave`](File-src-m-menu-ml-331716860.md#function-function-m-quicksave-function-m-quicksave-src-m-menu-ml-879944437) | `src/m_menu.ml:998` | 18 | 15 | 4 | 3 | 1 | 420.43 | 53.71 |
| [`M_QuickSaveResponse`](File-src-m-menu-ml-331716860.md#function-function-m-quicksaveresponse-function-m-quicksaveresponse-ch-src-m-menu-ml-1765081650) | `src/m_menu.ml:990` | 6 | 3 | 2 | 1 | 1 | 108.42 | 68.51 |
| [`M_QuitDOOM`](File-src-m-menu-ml-331716860.md#function-function-m-quitdoom-function-m-quitdoom-choice-src-m-menu-ml-1070593840) | `src/m_menu.ml:2014` | 11 | 7 | 2 | 1 | 1 | 323.14 | 59.44 |
| [`M_QuitResponse`](File-src-m-menu-ml-331716860.md#function-function-m-quitresponse-function-m-quitresponse-ch-src-m-menu-ml-203115748) | `src/m_menu.ml:1997` | 12 | 8 | 5 | 5 | 2 | 384.7 | 57.69 |
| [`M_Random`](File-src-m-random-ml-1659574948.md#function-function-m-random-function-m-random-src-m-random-ml-1216352121) | `src/m_random.ml:60` | 5 | 3 | 1 | 0 | 0 | 88 | 71 |
| [`M_ReadFile`](File-src-m-misc-ml-906836777.md#function-function-m-readfile-function-m-readfile-name-bufferout-src-m-misc-ml-299560807) | `src/m_misc.ml:474` | 18 | 14 | 9 | 10 | 2 | 646.11 | 51.73 |
| [`M_ReadSaveStrings`](File-src-m-menu-ml-331716860.md#function-function-m-readsavestrings-function-m-readsavestrings-src-m-menu-ml-797741771) | `src/m_menu.ml:847` | 35 | 25 | 11 | 19 | 3 | 1197.09 | 43.29 |
| [`M_ReadThis`](File-src-m-menu-ml-331716860.md#function-function-m-readthis-function-m-readthis-choice-src-m-menu-ml-128723792) | `src/m_menu.ml:1976` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_ReadThis2`](File-src-m-menu-ml-331716860.md#function-function-m-readthis2-function-m-readthis2-choice-src-m-menu-ml-817030160) | `src/m_menu.ml:1983` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_Responder`](File-src-m-menu-ml-331716860.md#function-function-m-responder-function-m-responder-ev-src-m-menu-ml-361536964) | `src/m_menu.ml:2529` | 297 | 223 | 93 | 175 | 4 | 11143.97 | 5.21 |
| [`M_SaveDefaults`](File-src-m-misc-ml-906836777.md#function-function-m-savedefaults-function-m-savedefaults-src-m-misc-ml-166341536) | `src/m_misc.ml:598` | 36 | 31 | 5 | 5 | 2 | 1646.49 | 42.86 |
| [`M_SaveGame`](File-src-m-menu-ml-331716860.md#function-function-m-savegame-function-m-savegame-choice-src-m-menu-ml-1687464208) | `src/m_menu.ml:972` | 12 | 8 | 3 | 2 | 1 | 195.04 | 60.02 |
| [`M_SaveSelect`](File-src-m-menu-ml-331716860.md#function-function-m-saveselect-function-m-saveselect-choice-src-m-menu-ml-1662414856) | `src/m_menu.ml:956` | 12 | 9 | 2 | 1 | 1 | 270.51 | 59.16 |
| [`M_ScreenShot`](File-src-m-misc-ml-906836777.md#function-function-m-screenshot-function-m-screenshot-src-m-misc-ml-1062459216) | `src/m_misc.ml:498` | 38 | 29 | 16 | 20 | 2 | 1356 | 41.45 |
| [`M_SetArgv`](File-src-m-argv-ml-728984635.md#function-function-m-setargv-function-m-setargv-progname-args-src-m-argv-ml-567743064) | `src/m_argv.ml:29` | 11 | 8 | 2 | 1 | 1 | 203.56 | 60.85 |
| [`M_SetupNextMenu`](File-src-m-menu-ml-331716860.md#function-function-m-setupnextmenu-function-m-setupnextmenu-menudef-src-m-menu-ml-309778951) | `src/m_menu.ml:2963` | 11 | 9 | 1 | 0 | 0 | 128 | 62.39 |
| [`M_SfxVol`](File-src-m-menu-ml-331716860.md#function-function-m-sfxvol-function-m-sfxvol-choice-src-m-menu-ml-132310464) | `src/m_menu.ml:1084` | 9 | 7 | 5 | 6 | 2 | 219.62 | 62.12 |
| [`M_SizeDisplay`](File-src-m-menu-ml-331716860.md#function-function-m-sizedisplay-function-m-sizedisplay-choice-src-m-menu-ml-1788157774) | `src/m_menu.ml:2085` | 16 | 10 | 5 | 6 | 2 | 293.44 | 55.78 |
| [`M_Sound`](File-src-m-menu-ml-331716860.md#function-function-m-sound-function-m-sound-choice-src-m-menu-ml-42794090) | `src/m_menu.ml:1077` | 4 | 2 | 1 | 0 | 0 | 44.38 | 75.2 |
| [`M_StartControlPanel`](File-src-m-menu-ml-331716860.md#function-function-m-startcontrolpanel-function-m-startcontrolpanel-src-m-menu-ml-1364772623) | `src/m_menu.ml:2875` | 10 | 9 | 2 | 1 | 1 | 133.44 | 63.04 |
| [`M_StartMessage`](File-src-m-menu-ml-331716860.md#function-function-m-startmessage-function-m-startmessage-string-routine-input-src-m-menu-ml-1940333698) | `src/m_menu.ml:2141` | 14 | 12 | 1 | 0 | 0 | 174.17 | 59.17 |
| [`M_StopMessage`](File-src-m-menu-ml-331716860.md#function-function-m-stopmessage-function-m-stopmessage-src-m-menu-ml-1792237255) | `src/m_menu.ml:2157` | 11 | 8 | 3 | 2 | 1 | 130.8 | 62.06 |
| [`M_StringHeight`](File-src-m-menu-ml-331716860.md#function-function-m-stringheight-function-m-stringheight-string-src-m-menu-ml-1121515542) | `src/m_menu.ml:2206` | 12 | 9 | 4 | 4 | 2 | 318.95 | 58.39 |
| [`M_StringWidth`](File-src-m-menu-ml-331716860.md#function-function-m-stringwidth-function-m-stringwidth-string-src-m-menu-ml-92621696) | `src/m_menu.ml:2180` | 20 | 14 | 6 | 7 | 2 | 479.27 | 52.04 |
| [`M_Ticker`](File-src-m-menu-ml-331716860.md#function-function-m-ticker-function-m-ticker-src-m-menu-ml-1987620625) | `src/m_menu.ml:2977` | 10 | 8 | 3 | 2 | 1 | 188.87 | 61.84 |
| [`M_VerifyNightmare`](File-src-m-menu-ml-331716860.md#function-function-m-verifynightmare-function-m-verifynightmare-ch-src-m-menu-ml-1704315716) | `src/m_menu.ml:1869` | 5 | 4 | 2 | 1 | 1 | 116.76 | 70.01 |
| [`M_WriteFile`](File-src-m-misc-ml-906836777.md#function-function-m-writefile-function-m-writefile-name-source-length-src-m-misc-ml-1246450968) | `src/m_misc.ml:451` | 16 | 17 | 8 | 7 | 1 | 575 | 53.33 |
| [`M_WriteText`](File-src-m-menu-ml-331716860.md#function-function-m-writetext-function-m-writetext-x-y-string-src-m-menu-ml-224234963) | `src/m_menu.ml:2224` | 28 | 23 | 7 | 10 | 2 | 724.92 | 47.46 |
| [`main`](File-src-i-main-ml-97520758.md#function-function-main-function-main-args-src-i-main-ml-1861481220) | `src/i_main.ml:100` | 33 | 22 | 13 | 23 | 3 | 1271.83 | 43.39 |
| [`MP_ClampSettings`](File-src-mp-state-ml-130741680.md#function-function-mp-clampsettings-function-mp-clampsettings-src-mp-state-ml-1508968585) | `src/mp_state.ml:422` | 20 | 20 | 4 | 3 | 1 | 829.27 | 50.64 |
| [`MP_FNV1A_Hex`](File-src-mp-fnv1a-ml-1881283455.md#function-function-mp-fnv1a-hex-function-mp-fnv1a-hex-data-src-mp-fnv1a-ml-701199562) | `src/mp_fnv1a.ml:51` | 12 | 10 | 3 | 2 | 1 | 393.46 | 57.89 |
| [`MP_GetIwadPath`](File-src-mp-state-ml-130741680.md#function-function-mp-getiwadpath-function-mp-getiwadpath-src-mp-state-ml-1189385693) | `src/mp_state.ml:329` | 26 | 13 | 10 | 11 | 2 | 695.97 | 47.88 |
| [`MP_GetPlayerName`](File-src-mp-state-ml-130741680.md#function-function-mp-getplayername-function-mp-getplayername-src-mp-state-ml-969161865) | `src/mp_state.ml:203` | 4 | 3 | 3 | 2 | 1 | 96 | 72.58 |
| [`MP_GetSelectedMap`](File-src-mp-state-ml-130741680.md#function-function-mp-getselectedmap-function-mp-getselectedmap-src-mp-state-ml-2089951411) | `src/mp_state.ml:269` | 10 | 12 | 6 | 5 | 1 | 408.07 | 59.1 |
| [`MP_PlatformGetActiveSlots`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetactiveslots-function-mp-platformgetactiveslots-src-mp-platform-ml-783997369) | `src/mp_platform.ml:720` | 70 | 54 | 24 | 49 | 4 | 2153.7 | 33.18 |
| [`MP_PlatformGetDebugOverlayText`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetdebugoverlaytext-function-mp-platformgetdebugoverlaytext-src-mp-platform-ml-1562157397) | `src/mp_platform.ml:491` | 51 | 45 | 15 | 36 | 5 | 3045.65 | 36.34 |
| [`MP_PlatformGetLastError`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetlasterror-function-mp-platformgetlasterror-src-mp-platform-ml-1268604315) | `src/mp_platform.ml:1878` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`MP_PlatformGetLastStatus`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetlaststatus-function-mp-platformgetlaststatus-src-mp-platform-ml-663646093) | `src/mp_platform.ml:471` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`MP_PlatformGetLocalPlayerSlot`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetlocalplayerslot-inline-function-mp-platformgetlocalplayerslot-src-mp-platform-ml-1525395998) | `src/mp_platform.ml:552` | 9 | 8 | 5 | 5 | 2 | 224.66 | 62.05 |
| [`MP_PlatformGetNodeCount`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetnodecount-function-mp-platformgetnodecount-src-mp-platform-ml-470579337) | `src/mp_platform.ml:663` | 22 | 18 | 9 | 15 | 4 | 601.38 | 50.05 |
| [`MP_PlatformGetNumPlayers`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetnumplayers-function-mp-platformgetnumplayers-src-mp-platform-ml-1256615133) | `src/mp_platform.ml:687` | 31 | 26 | 13 | 32 | 5 | 897.4 | 45.04 |
| [`MP_PlatformGetPlayerNameBySlot`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetplayernamebyslot-function-mp-platformgetplayernamebyslot-slot-src-mp-platform-ml-1537780601) | `src/mp_platform.ml:626` | 33 | 31 | 24 | 38 | 3 | 1425.11 | 41.56 |
| [`MP_PlatformGetSessionMap`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetsessionmap-function-mp-platformgetsessionmap-src-mp-platform-ml-735798217) | `src/mp_platform.ml:486` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`MP_PlatformGetSessionMode`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetsessionmode-function-mp-platformgetsessionmode-src-mp-platform-ml-465812277) | `src/mp_platform.ml:476` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`MP_PlatformGetSessionSkill`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformgetsessionskill-function-mp-platformgetsessionskill-src-mp-platform-ml-1712229953) | `src/mp_platform.ml:481` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`MP_PlatformHostGame`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformhostgame-function-mp-platformhostgame-port-mode-skill-mapname-maxplayers-fraglimit-timelimit-src-mp-platform-ml-90697228) | `src/mp_platform.ml:1890` | 116 | 120 | 15 | 14 | 1 | 3483.85 | 28.15 |
| [`MP_PlatformIsClientConnected`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformisclientconnected-inline-function-mp-platformisclientconnected-src-mp-platform-ml-840466586) | `src/mp_platform.ml:547` | 3 | 1 | 1 | 0 | 0 | 36.54 | 78.52 |
| [`MP_PlatformIsHosting`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformishosting-inline-function-mp-platformishosting-src-mp-platform-ml-1563938382) | `src/mp_platform.ml:1800` | 3 | 1 | 1 | 0 | 0 | 36.54 | 78.52 |
| [`MP_PlatformJoinGame`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformjoingame-function-mp-platformjoingame-host-port-playername-src-mp-platform-ml-931882000) | `src/mp_platform.ml:2018` | 195 | 179 | 49 | 74 | 3 | 7702.34 | 16.24 |
| [`MP_PlatformNetRecv`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformnetrecv-inline-function-mp-platformnetrecv-src-mp-platform-ml-84520328) | `src/mp_platform.ml:1860` | 4 | 3 | 2 | 1 | 1 | 70.31 | 73.66 |
| [`MP_PlatformNetSend`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformnetsend-function-mp-platformnetsend-node-payload-src-mp-platform-ml-1843513141) | `src/mp_platform.ml:1807` | 46 | 41 | 13 | 16 | 2 | 1911.3 | 39 |
| [`MP_PlatformPump`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformpump-function-mp-platformpump-src-mp-platform-ml-2100981655) | `src/mp_platform.ml:1593` | 124 | 99 | 38 | 115 | 9 | 5562.38 | 23 |
| [`MP_PlatformSetEventLogPath`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformseteventlogpath-function-mp-platformseteventlogpath-path-src-mp-platform-ml-358749746) | `src/mp_platform.ml:187` | 8 | 4 | 2 | 1 | 1 | 104 | 65.91 |
| [`MP_PlatformSetPlayerNameBySlot`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformsetplayernamebyslot-function-mp-platformsetplayernamebyslot-slot-name-src-mp-platform-ml-1714090174) | `src/mp_platform.ml:592` | 29 | 27 | 13 | 15 | 2 | 944.28 | 45.52 |
| [`MP_PlatformShutdown`](File-src-mp-platform-ml-1361006310.md#function-function-mp-platformshutdown-function-mp-platformshutdown-src-mp-platform-ml-731477999) | `src/mp_platform.ml:1725` | 71 | 65 | 13 | 15 | 3 | 1854.19 | 34.98 |
| [`MP_RebuildMapList`](File-src-mp-state-ml-130741680.md#function-function-mp-rebuildmaplist-function-mp-rebuildmaplist-src-mp-state-ml-1004685543) | `src/mp_state.ml:223` | 40 | 38 | 12 | 26 | 4 | 1417.65 | 41.37 |
| [`MP_SanitizeName`](File-src-mp-state-ml-130741680.md#function-function-mp-sanitizename-function-mp-sanitizename-name-src-mp-state-ml-1426310704) | `src/mp_state.ml:169` | 22 | 21 | 12 | 12 | 2 | 819.58 | 48.7 |
| [`MP_SetMode`](File-src-mp-state-ml-130741680.md#function-function-mp-setmode-function-mp-setmode-mode-src-mp-state-ml-101889452) | `src/mp_state.ml:321` | 6 | 5 | 2 | 1 | 1 | 122.62 | 68.13 |
| [`MP_SetPlayerName`](File-src-mp-state-ml-130741680.md#function-function-mp-setplayername-function-mp-setplayername-name-src-mp-state-ml-1679646824) | `src/mp_state.ml:197` | 4 | 2 | 1 | 0 | 0 | 49.83 | 74.85 |
| [`MP_SetSelectedMapByName`](File-src-mp-state-ml-130741680.md#function-function-mp-setselectedmapbyname-function-mp-setselectedmapbyname-name-src-mp-state-ml-236960506) | `src/mp_state.ml:301` | 17 | 15 | 7 | 7 | 2 | 477.02 | 53.46 |
| [`MP_StepMap`](File-src-mp-state-ml-130741680.md#function-function-mp-stepmap-function-mp-stepmap-delta-src-mp-state-ml-637040561) | `src/mp_state.ml:282` | 16 | 14 | 6 | 5 | 1 | 471.89 | 54.2 |
| [`MP_UpdateIwadFingerprint`](File-src-mp-state-ml-130741680.md#function-function-mp-updateiwadfingerprint-function-mp-updateiwadfingerprint-src-mp-state-ml-1578752677) | `src/mp_state.ml:358` | 57 | 48 | 16 | 27 | 4 | 2282.22 | 36.03 |
| [`myioctl`](File-src-i-sound-ml-33806980.md#function-function-myioctl-function-myioctl-fd-req-arg-src-i-sound-ml-518895515) | `src/i_sound.ml:1824` | 6 | 4 | 1 | 0 | 0 | 78.87 | 69.61 |
| [`NetbufferChecksum`](File-src-d-net-ml-529296669.md#function-function-netbufferchecksum-function-netbufferchecksum-src-d-net-ml-1545828834) | `src/d_net.ml:7071` | 21 | 20 | 7 | 7 | 2 | 1179.86 | 48.71 |
| [`NetbufferSize`](File-src-d-net-ml-529296669.md#function-function-netbuffersize-inline-function-netbuffersize-src-d-net-ml-205698133) | `src/d_net.ml:7061` | 7 | 8 | 4 | 3 | 1 | 244.42 | 64.31 |
| [`NetUpdate`](File-src-d-net-ml-529296669.md#function-function-netupdate-function-netupdate-src-d-net-ml-79656906) | `src/d_net.ml:6530` | 226 | 189 | 95 | 244 | 10 | 10029.81 | 7.85 |
| [`P_ActivateInStasis`](File-src-p-plats-ml-866228534.md#function-function-p-activateinstasis-function-p-activateinstasis-tag-src-p-plats-ml-1951141947) | `src/p_plats.ml:151` | 16 | 10 | 6 | 8 | 3 | 493.31 | 54.07 |
| [`P_ActivateInStasisCeiling`](File-src-p-ceilng-ml-226654252.md#function-function-p-activateinstasisceiling-function-p-activateinstasisceiling-line-src-p-ceilng-ml-674653233) | `src/p_ceilng.ml:100` | 12 | 9 | 6 | 6 | 2 | 331.93 | 58 |
| [`P_AddActiveCeiling`](File-src-p-ceilng-ml-226654252.md#function-function-p-addactiveceiling-function-p-addactiveceiling-c-src-p-ceilng-ml-1788524832) | `src/p_ceilng.ml:72` | 11 | 7 | 3 | 3 | 2 | 185.47 | 61 |
| [`P_AddActivePlat`](File-src-p-plats-ml-866228534.md#function-function-p-addactiveplat-function-p-addactiveplat-plat-src-p-plats-ml-494813094) | `src/p_plats.ml:111` | 12 | 8 | 3 | 3 | 2 | 208.97 | 59.81 |
| [`P_AddThinker`](File-src-p-tick-ml-887781845.md#function-function-p-addthinker-function-p-addthinker-thinker-src-p-tick-ml-1118069235) | `src/p_tick.ml:95` | 8 | 7 | 2 | 1 | 1 | 163.5 | 64.53 |
| [`P_AimLineAttack`](File-src-p-map-ml-882556686.md#function-function-p-aimlineattack-function-p-aimlineattack-t1-angle-distance-src-p-map-ml-1749368286) | `src/p_map.ml:1225` | 24 | 23 | 5 | 4 | 1 | 1033.71 | 48.11 |
| [`P_AllocateThinker`](File-src-p-tick-ml-887781845.md#function-function-p-allocatethinker-function-p-allocatethinker-thinker-src-p-tick-ml-225921385) | `src/p_tick.ml:121` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`P_AproxDistance`](File-src-p-maputl-ml-227665141.md#function-function-p-aproxdistance-inline-function-p-aproxdistance-dx-dy-src-p-maputl-ml-1670041828) | `src/p_maputl.ml:102` | 8 | 5 | 2 | 1 | 1 | 208.15 | 63.8 |
| [`P_ArchivePlayers`](File-src-p-saveg-ml-1704891910.md#function-function-p-archiveplayers-function-p-archiveplayers-src-p-saveg-ml-1280947305) | `src/p_saveg.ml:609` | 15 | 16 | 8 | 11 | 2 | 585.41 | 53.89 |
| [`P_ArchiveSpecials`](File-src-p-saveg-ml-1704891910.md#function-function-p-archivespecials-function-p-archivespecials-src-p-saveg-ml-1104270211) | `src/p_saveg.ml:1121` | 51 | 43 | 23 | 38 | 3 | 1674.04 | 37.08 |
| [`P_ArchiveThinkers`](File-src-p-saveg-ml-1704891910.md#function-function-p-archivethinkers-function-p-archivethinkers-src-p-saveg-ml-1947368499) | `src/p_saveg.ml:961` | 25 | 19 | 9 | 14 | 3 | 661.37 | 48.55 |
| [`P_ArchiveWorld`](File-src-p-saveg-ml-1704891910.md#function-function-p-archiveworld-function-p-archiveworld-src-p-saveg-ml-1175521633) | `src/p_saveg.ml:668` | 55 | 69 | 14 | 23 | 4 | 2464.83 | 36.4 |
| [`P_BlockLinesIterator`](File-src-p-maputl-ml-227665141.md#function-function-p-blocklinesiterator-function-p-blocklinesiterator-x-y-func-src-p-maputl-ml-1166463331) | `src/p_maputl.ml:393` | 39 | 33 | 24 | 37 | 5 | 1389.74 | 40.06 |
| [`P_BlockThingsIterator`](File-src-p-maputl-ml-227665141.md#function-function-p-blockthingsiterator-function-p-blockthingsiterator-x-y-func-src-p-maputl-ml-1049498313) | `src/p_maputl.ml:443` | 19 | 16 | 11 | 12 | 2 | 598.26 | 51.18 |
| [`P_BoxOnLineSide`](File-src-p-maputl-ml-227665141.md#function-function-p-boxonlineside-inline-function-p-boxonlineside-tmbox-ld-src-p-maputl-ml-1842173681) | `src/p_maputl.ml:146` | 28 | 30 | 13 | 18 | 2 | 1413.99 | 44.62 |
| [`P_BringUpWeapon`](File-src-p-pspr-ml-844718747.md#function-function-p-bringupweapon-function-p-bringupweapon-player-src-p-pspr-ml-2143986817) | `src/p_pspr.ml:413` | 17 | 15 | 5 | 4 | 1 | 566.78 | 53.21 |
| [`P_BulletSlope`](File-src-p-pspr-ml-844718747.md#function-function-p-bulletslope-function-p-bulletslope-mo-src-p-pspr-ml-1709011234) | `src/p_pspr.ml:1007` | 18 | 13 | 4 | 4 | 2 | 584.74 | 52.71 |
| [`P_CalcHeight`](File-src-p-user-ml-1917117091.md#function-function-p-calcheight-function-p-calcheight-player-src-p-user-ml-937965713) | `src/p_user.ml:171` | 44 | 43 | 22 | 32 | 3 | 2692 | 37.17 |
| [`P_CalcSwing`](File-src-p-pspr-ml-844718747.md#function-function-p-calcswing-function-p-calcswing-player-src-p-pspr-ml-862186885) | `src/p_pspr.ml:387` | 19 | 15 | 3 | 2 | 1 | 438.86 | 53.2 |
| [`P_ChangeSector`](File-src-p-map-ml-882556686.md#function-function-p-changesector-function-p-changesector-sector-crunch-src-p-map-ml-1979810850) | `src/p_map.ml:958` | 14 | 12 | 6 | 6 | 2 | 512.68 | 55.22 |
| [`P_ChangeSwitchTexture`](File-src-p-switch-ml-925070734.md#function-function-p-changeswitchtexture-function-p-changeswitchtexture-line-useagain-src-p-switch-ml-256432222) | `src/p_switch.ml:266` | 49 | 43 | 15 | 29 | 3 | 1734.41 | 38.43 |
| [`P_CheckAmmo`](File-src-p-pspr-ml-844718747.md#function-function-p-checkammo-function-p-checkammo-player-src-p-pspr-ml-1378821395) | `src/p_pspr.ml:440` | 36 | 28 | 24 | 23 | 1 | 1663.67 | 40.27 |
| [`P_CheckMeleeRange`](File-src-p-enemy-ml-1875479956.md#function-function-p-checkmeleerange-function-p-checkmeleerange-actor-src-p-enemy-ml-10277128) | `src/p_enemy.ml:299` | 11 | 11 | 6 | 5 | 1 | 494.35 | 57.61 |
| [`P_CheckMissileRange`](File-src-p-enemy-ml-1875479956.md#function-function-p-checkmissilerange-function-p-checkmissilerange-actor-src-p-enemy-ml-1024443264) | `src/p_enemy.ml:315` | 27 | 30 | 21 | 21 | 2 | 1636.88 | 43.45 |
| [`P_CheckMissileSpawn`](File-src-p-mobj-ml-1335564114.md#function-function-p-checkmissilespawn-function-p-checkmissilespawn-th-src-p-mobj-ml-1378406047) | `src/p_mobj.ml:639` | 14 | 13 | 6 | 6 | 2 | 713.7 | 54.21 |
| [`P_CheckPosition`](File-src-p-map-ml-882556686.md#function-function-p-checkposition-function-p-checkposition-thing-x-y-src-p-map-ml-1352106668) | `src/p_map.ml:397` | 72 | 64 | 14 | 19 | 3 | 2408.04 | 33.92 |
| [`P_CheckSight`](File-src-p-sight-ml-269759795.md#function-function-p-checksight-function-p-checksight-t1-t2-src-p-sight-ml-595559849) | `src/p_sight.ml:232` | 37 | 39 | 16 | 18 | 3 | 1941.15 | 40.62 |
| [`P_CrossBSPNode`](File-src-p-sight-ml-269759795.md#function-function-p-crossbspnode-function-p-crossbspnode-bspnum-src-p-sight-ml-2053063059) | `src/p_sight.ml:197` | 23 | 20 | 11 | 12 | 2 | 1063.77 | 47.62 |
| [`P_CrossSpecialLine`](File-src-p-spec-ml-402508231.md#function-function-p-crossspecialline-function-p-crossspecialline-linenum-side-thing-src-p-spec-ml-101146787) | `src/p_spec.ml:783` | 278 | 131 | 84 | 17 | 2 | 8542 | 7.86 |
| [`P_CrossSubsector`](File-src-p-sight-ml-269759795.md#function-function-p-crosssubsector-function-p-crosssubsector-num-src-p-sight-ml-1605293382) | `src/p_sight.ml:130` | 49 | 47 | 20 | 69 | 7 | 2307.18 | 36.89 |
| [`P_DamageMobj`](File-src-p-inter-ml-1430401638.md#function-function-p-damagemobj-function-p-damagemobj-target-inflictor-source-damage-src-p-inter-ml-686570734) | `src/p_inter.ml:835` | 99 | 86 | 66 | 94 | 4 | 6692 | 20.8 |
| [`P_DeathThink`](File-src-p-user-ml-1917117091.md#function-function-p-deaththink-function-p-deaththink-player-src-p-user-ml-408663681) | `src/p_user.ml:261` | 31 | 24 | 14 | 18 | 3 | 1543.62 | 43.26 |
| [`P_DivlineSide`](File-src-p-sight-ml-269759795.md#function-function-p-divlineside-inline-function-p-divlineside-x-y-node-src-p-sight-ml-1698165132) | `src/p_sight.ml:84` | 24 | 31 | 14 | 23 | 3 | 1003.83 | 46.99 |
| [`P_DropWeapon`](File-src-p-pspr-ml-844718747.md#function-function-p-dropweapon-function-p-dropweapon-player-src-p-pspr-ml-363606733) | `src/p_pspr.ml:506` | 6 | 6 | 3 | 2 | 1 | 177.2 | 66.88 |
| [`P_ExplodeMissile`](File-src-p-mobj-ml-1335564114.md#function-function-p-explodemissile-function-p-explodemissile-mo-src-p-mobj-ml-384873899) | `src/p_mobj.ml:617` | 16 | 11 | 8 | 8 | 2 | 595.23 | 53.23 |
| [`P_FindHighestCeilingSurrounding`](File-src-p-spec-ml-402508231.md#function-function-p-findhighestceilingsurrounding-function-p-findhighestceilingsurrounding-sec-src-p-spec-ml-129033489) | `src/p_spec.ml:1388` | 17 | 14 | 7 | 9 | 3 | 506.65 | 53.28 |
| [`P_FindHighestFloorSurrounding`](File-src-p-spec-ml-402508231.md#function-function-p-findhighestfloorsurrounding-function-p-findhighestfloorsurrounding-sec-src-p-spec-ml-975368295) | `src/p_spec.ml:1314` | 17 | 14 | 7 | 9 | 3 | 537.51 | 53.1 |
| [`P_FindLowestCeilingSurrounding`](File-src-p-spec-ml-402508231.md#function-function-p-findlowestceilingsurrounding-function-p-findlowestceilingsurrounding-sec-src-p-spec-ml-1537753587) | `src/p_spec.ml:1365` | 17 | 14 | 7 | 9 | 3 | 506.65 | 53.28 |
| [`P_FindLowestFloorSurrounding`](File-src-p-spec-ml-402508231.md#function-function-p-findlowestfloorsurrounding-function-p-findlowestfloorsurrounding-sec-src-p-spec-ml-141499463) | `src/p_spec.ml:1291` | 17 | 14 | 7 | 9 | 3 | 512.93 | 53.24 |
| [`P_FindMinSurroundingLight`](File-src-p-spec-ml-402508231.md#function-function-p-findminsurroundinglight-function-p-findminsurroundinglight-sector-max-src-p-spec-ml-1722222576) | `src/p_spec.ml:1429` | 17 | 14 | 7 | 9 | 3 | 516.99 | 53.22 |
| [`P_FindNextHighestFloor`](File-src-p-spec-ml-402508231.md#function-function-p-findnexthighestfloor-function-p-findnexthighestfloor-sec-currentheight-src-p-spec-ml-1152834469) | `src/p_spec.ml:1338` | 21 | 17 | 9 | 11 | 3 | 606.7 | 50.46 |
| [`P_FindSectorFromLineTag`](File-src-p-spec-ml-402508231.md#function-function-p-findsectorfromlinetag-function-p-findsectorfromlinetag-line-start-src-p-spec-ml-652342582) | `src/p_spec.ml:1412` | 13 | 10 | 5 | 5 | 2 | 331.93 | 57.38 |
| [`P_FindSlidingDoorType`](File-src-p-doors-ml-224295587.md#function-function-p-findslidingdoortype-function-p-findslidingdoortype-line-src-p-doors-ml-1641591790) | `src/p_doors.ml:475` | 4 | 2 | 1 | 0 | 0 | 43.19 | 75.28 |
| [`P_FireWeapon`](File-src-p-pspr-ml-844718747.md#function-function-p-fireweapon-function-p-fireweapon-player-src-p-pspr-ml-697822901) | `src/p_pspr.ml:486` | 14 | 11 | 9 | 8 | 1 | 604.88 | 54.31 |
| [`P_ForgetPlayerTarget`](File-src-p-enemy-ml-1875479956.md#function-function-p-forgetplayertarget-function-p-forgetplayertarget-playermo-src-p-enemy-ml-284822990) | `src/p_enemy.ml:187` | 23 | 20 | 13 | 20 | 3 | 798.29 | 48.23 |
| [`P_GiveAmmo`](File-src-p-inter-ml-1430401638.md#function-function-p-giveammo-function-p-giveammo-player-ammo-num-src-p-inter-ml-243094258) | `src/p_inter.ml:346` | 54 | 37 | 28 | 39 | 3 | 2041.51 | 35.27 |
| [`P_GiveArmor`](File-src-p-inter-ml-1430401638.md#function-function-p-givearmor-function-p-givearmor-player-armortype-src-p-inter-ml-346479533) | `src/p_inter.ml:476` | 8 | 8 | 3 | 2 | 1 | 205.13 | 63.71 |
| [`P_GiveBody`](File-src-p-inter-ml-1430401638.md#function-function-p-givebody-function-p-givebody-player-num-src-p-inter-ml-1356383164) | `src/p_inter.ml:464` | 8 | 10 | 5 | 4 | 1 | 334.7 | 61.95 |
| [`P_GiveCard`](File-src-p-inter-ml-1430401638.md#function-function-p-givecard-function-p-givecard-player-card-src-p-inter-ml-487903254) | `src/p_inter.ml:488` | 10 | 12 | 7 | 6 | 1 | 468.05 | 58.55 |
| [`P_GivePower`](File-src-p-inter-ml-1430401638.md#function-function-p-givepower-function-p-givepower-player-power-src-p-inter-ml-1870988451) | `src/p_inter.ml:48` | 39 | 36 | 15 | 16 | 2 | 1368.97 | 41.31 |
| [`P_GiveWeapon`](File-src-p-inter-ml-1430401638.md#function-function-p-giveweapon-function-p-giveweapon-player-weapon-dropped-src-p-inter-ml-145348842) | `src/p_inter.ml:412` | 40 | 33 | 16 | 19 | 2 | 1469.89 | 40.72 |
| [`P_GroupLines`](File-src-p-setup-ml-2057900615.md#function-function-p-grouplines-function-p-grouplines-src-p-setup-ml-337393416) | `src/p_setup.ml:625` | 86 | 74 | 36 | 78 | 6 | 4183.5 | 27.6 |
| [`P_GunShot`](File-src-p-pspr-ml-844718747.md#function-function-p-gunshot-function-p-gunshot-mo-accurate-src-p-pspr-ml-1920535122) | `src/p_pspr.ml:1033` | 10 | 8 | 3 | 2 | 1 | 441.12 | 59.27 |
| [`P_HitSlideLine`](File-src-p-map-ml-882556686.md#function-function-p-hitslideline-function-p-hitslideline-ld-src-p-map-ml-1078275089) | `src/p_map.ml:667` | 38 | 30 | 9 | 8 | 1 | 1243.06 | 42.66 |
| [`P_Init`](File-src-p-setup-ml-2057900615.md#function-function-p-init-function-p-init-src-p-setup-ml-480363136) | `src/p_setup.ml:726` | 7 | 6 | 5 | 4 | 1 | 204 | 64.72 |
| [`P_InitPicAnims`](File-src-p-spec-ml-402508231.md#function-function-p-initpicanims-function-p-initpicanims-src-p-spec-ml-466094138) | `src/p_spec.ml:527` | 39 | 31 | 8 | 15 | 3 | 1143.38 | 42.8 |
| [`P_InitSlidingDoorFrames`](File-src-p-doors-ml-224295587.md#function-function-p-initslidingdoorframes-function-p-initslidingdoorframes-src-p-doors-ml-572766382) | `src/p_doors.ml:469` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`P_InitSwitchList`](File-src-p-switch-ml-925070734.md#function-function-p-initswitchlist-function-p-initswitchlist-src-p-switch-ml-1421212979) | `src/p_switch.ml:179` | 29 | 22 | 7 | 8 | 2 | 846.5 | 46.66 |
| [`P_InitThinkers`](File-src-p-tick-ml-887781845.md#function-function-p-initthinkers-function-p-initthinkers-src-p-tick-ml-77441064) | `src/p_tick.ml:39` | 8 | 6 | 1 | 0 | 0 | 109.39 | 65.89 |
| [`P_InterceptVector`](File-src-p-maputl-ml-227665141.md#function-function-p-interceptvector-inline-function-p-interceptvector-v2-v1-src-p-maputl-ml-1041643710) | `src/p_maputl.ml:231` | 8 | 5 | 2 | 1 | 1 | 442.28 | 61.51 |
| [`P_InterceptVector2`](File-src-p-sight-ml-269759795.md#function-function-p-interceptvector2-inline-function-p-interceptvector2-v2-v1-src-p-sight-ml-1488472292) | `src/p_sight.ml:119` | 7 | 6 | 2 | 1 | 1 | 461.51 | 62.64 |
| [`P_KillMobj`](File-src-p-inter-ml-1430401638.md#function-function-p-killmobj-function-p-killmobj-source-target-src-p-inter-ml-1790364609) | `src/p_inter.ml:744` | 74 | 54 | 43 | 54 | 3 | 4609.47 | 27.79 |
| [`P_LineAttack`](File-src-p-map-ml-882556686.md#function-function-p-lineattack-function-p-lineattack-t1-angle-distance-slope-damage-src-p-map-ml-642473316) | `src/p_map.ml:1263` | 18 | 18 | 4 | 3 | 1 | 834.46 | 51.62 |
| [`P_LineOpening`](File-src-p-maputl-ml-227665141.md#function-function-p-lineopening-function-p-lineopening-linedef-src-p-maputl-ml-1220007195) | `src/p_maputl.ml:244` | 42 | 33 | 9 | 8 | 1 | 903.8 | 42.68 |
| [`P_LoadBlockMap`](File-src-p-setup-ml-2057900615.md#function-function-p-loadblockmap-function-p-loadblockmap-lump-src-p-setup-ml-1988813850) | `src/p_setup.ml:524` | 50 | 45 | 9 | 8 | 1 | 1302.3 | 39.92 |
| [`P_LoadLineDefs`](File-src-p-setup-ml-2057900615.md#function-function-p-loadlinedefs-function-p-loadlinedefs-lump-src-p-setup-ml-1163422658) | `src/p_setup.ml:340` | 55 | 42 | 16 | 22 | 2 | 2506.88 | 36.08 |
| [`P_LoadNodes`](File-src-p-setup-ml-2057900615.md#function-function-p-loadnodes-function-p-loadnodes-lump-src-p-setup-ml-316950794) | `src/p_setup.ml:426` | 33 | 17 | 2 | 1 | 1 | 1350.04 | 44.69 |
| [`P_LoadSectors`](File-src-p-setup-ml-2057900615.md#function-function-p-loadsectors-function-p-loadsectors-lump-src-p-setup-ml-388173582) | `src/p_setup.ml:264` | 38 | 18 | 2 | 1 | 1 | 1072.31 | 44.05 |
| [`P_LoadSegs`](File-src-p-setup-ml-2057900615.md#function-function-p-loadsegs-function-p-loadsegs-lump-src-p-setup-ml-1312730618) | `src/p_setup.ml:468` | 44 | 36 | 17 | 32 | 5 | 1971.48 | 38.79 |
| [`P_LoadSideDefs`](File-src-p-setup-ml-2057900615.md#function-function-p-loadsidedefs-function-p-loadsidedefs-lump-src-p-setup-ml-673161662) | `src/p_setup.ml:309` | 23 | 19 | 5 | 5 | 2 | 975.66 | 48.69 |
| [`P_LoadSubsectors`](File-src-p-setup-ml-2057900615.md#function-function-p-loadsubsectors-function-p-loadsubsectors-lump-src-p-setup-ml-2137060094) | `src/p_setup.ml:406` | 15 | 12 | 2 | 1 | 1 | 425 | 55.67 |
| [`P_LoadThings`](File-src-p-setup-ml-2057900615.md#function-function-p-loadthings-function-p-loadthings-lump-src-p-setup-ml-1997992390) | `src/p_setup.ml:585` | 31 | 16 | 15 | 19 | 3 | 994.39 | 44.46 |
| [`P_LoadVertexes`](File-src-p-setup-ml-2057900615.md#function-function-p-loadvertexes-function-p-loadvertexes-lump-src-p-setup-ml-285503282) | `src/p_setup.ml:243` | 15 | 12 | 2 | 1 | 1 | 428.77 | 55.64 |
| [`P_LookForPlayers`](File-src-p-enemy-ml-1875479956.md#function-function-p-lookforplayers-function-p-lookforplayers-actor-allaround-src-p-enemy-ml-1969698702) | `src/p_enemy.ml:501` | 47 | 37 | 19 | 30 | 4 | 1875.57 | 38.05 |
| [`P_MakeDivline`](File-src-p-maputl-ml-227665141.md#function-function-p-makedivline-inline-function-p-makedivline-li-dl-src-p-maputl-ml-1476904192) | `src/p_maputl.ml:220` | 7 | 6 | 3 | 2 | 1 | 240.81 | 64.49 |
| [`P_MobjThinker`](File-src-p-mobj-ml-1335564114.md#function-function-p-mobjthinker-function-p-mobjthinker-mo-src-p-mobj-ml-410146987) | `src/p_mobj.ml:1285` | 50 | 46 | 33 | 53 | 5 | 2214.96 | 35.08 |
| [`P_Move`](File-src-p-enemy-ml-1875479956.md#function-function-p-move-function-p-move-actor-src-p-enemy-ml-1136750292) | `src/p_enemy.ml:353` | 40 | 35 | 17 | 27 | 4 | 1716.66 | 40.12 |
| [`P_MovePlayer`](File-src-p-user-ml-1917117091.md#function-function-p-moveplayer-function-p-moveplayer-player-src-p-user-ml-739313113) | `src/p_user.ml:228` | 23 | 17 | 17 | 19 | 3 | 1227.56 | 46.38 |
| [`P_MovePsprites`](File-src-p-pspr-ml-844718747.md#function-function-p-movepsprites-function-p-movepsprites-player-src-p-pspr-ml-2111210489) | `src/p_pspr.ml:531` | 22 | 16 | 7 | 16 | 5 | 703.22 | 49.84 |
| [`P_NewChaseDir`](File-src-p-enemy-ml-1875479956.md#function-function-p-newchasedir-function-p-newchasedir-actor-src-p-enemy-ml-1662507220) | `src/p_enemy.ml:411` | 73 | 67 | 35 | 54 | 4 | 2526 | 30.82 |
| [`P_NightmareRespawn`](File-src-p-mobj-ml-1335564114.md#function-function-p-nightmarerespawn-function-p-nightmarerespawn-mobj-src-p-mobj-ml-834896243) | `src/p_mobj.ml:1197` | 38 | 30 | 15 | 16 | 2 | 1767.36 | 40.78 |
| [`P_NoiseAlert`](File-src-p-enemy-ml-1875479956.md#function-function-p-noisealert-function-p-noisealert-target-emmiter-src-p-enemy-ml-1747912413) | `src/p_enemy.ml:284` | 9 | 9 | 5 | 4 | 1 | 291.43 | 61.25 |
| [`P_PathTraverse`](File-src-p-maputl-ml-227665141.md#function-function-p-pathtraverse-function-p-pathtraverse-x1-y1-x2-y2-flags-trav-src-p-maputl-ml-2050099288) | `src/p_maputl.ml:668` | 118 | 92 | 22 | 34 | 3 | 4352.66 | 26.37 |
| [`P_PlayerInSpecialSector`](File-src-p-spec-ml-402508231.md#function-function-p-playerinspecialsector-function-p-playerinspecialsector-player-src-p-spec-ml-444795477) | `src/p_spec.ml:1109` | 42 | 22 | 21 | 22 | 3 | 1684.33 | 39.17 |
| [`P_PlayerThink`](File-src-p-user-ml-1917117091.md#function-function-p-playerthink-function-p-playerthink-player-src-p-user-ml-1347832073) | `src/p_user.ml:303` | 89 | 69 | 47 | 56 | 3 | 5558.13 | 24.93 |
| [`P_PointOnDivlineSide`](File-src-p-maputl-ml-227665141.md#function-function-p-pointondivlineside-inline-function-p-pointondivlineside-x-y-line-src-p-maputl-ml-1466543704) | `src/p_maputl.ml:183` | 27 | 29 | 13 | 21 | 3 | 1017.49 | 45.97 |
| [`P_PointOnLineSide`](File-src-p-maputl-ml-227665141.md#function-function-p-pointonlineside-inline-function-p-pointonlineside-x-y-line-src-p-maputl-ml-457779622) | `src/p_maputl.ml:116` | 21 | 25 | 11 | 18 | 3 | 857.55 | 49.14 |
| [`P_RadiusAttack`](File-src-p-map-ml-882556686.md#function-function-p-radiusattack-function-p-radiusattack-spot-source-damage-src-p-map-ml-463123941) | `src/p_map.ml:1013` | 19 | 16 | 4 | 4 | 2 | 653.62 | 51.85 |
| [`P_Random`](File-src-m-random-ml-1659574948.md#function-function-p-random-function-p-random-src-m-random-ml-328211585) | `src/m_random.ml:51` | 5 | 3 | 1 | 0 | 0 | 88 | 71 |
| [`P_RecursiveSound`](File-src-p-enemy-ml-1875479956.md#function-function-p-recursivesound-function-p-recursivesound-sec-soundblocks-src-p-enemy-ml-75493233) | `src/p_enemy.ml:235` | 37 | 27 | 10 | 15 | 3 | 1071.57 | 43.23 |
| [`P_RegisterThinkerOwner`](File-src-p-tick-ml-887781845.md#function-function-p-registerthinkerowner-function-p-registerthinkerowner-node-owner-src-p-tick-ml-1331298027) | `src/p_tick.ml:51` | 8 | 7 | 2 | 1 | 1 | 175.69 | 64.31 |
| [`P_RemoveActiveCeiling`](File-src-p-ceilng-ml-226654252.md#function-function-p-removeactiveceiling-function-p-removeactiveceiling-c-src-p-ceilng-ml-1531573816) | `src/p_ceilng.ml:86` | 11 | 7 | 3 | 3 | 2 | 190.4 | 60.92 |
| [`P_RemoveActivePlat`](File-src-p-plats-ml-866228534.md#function-function-p-removeactiveplat-function-p-removeactiveplat-plat-src-p-plats-ml-811389848) | `src/p_plats.ml:128` | 18 | 12 | 5 | 9 | 3 | 449.78 | 53.37 |
| [`P_RemoveMobj`](File-src-p-mobj-ml-1335564114.md#function-function-p-removemobj-function-p-removemobj-th-src-p-mobj-ml-883373499) | `src/p_mobj.ml:986` | 23 | 17 | 11 | 11 | 2 | 922.06 | 48.06 |
| [`P_RemoveThinker`](File-src-p-tick-ml-887781845.md#function-function-p-removethinker-function-p-removethinker-thinker-src-p-tick-ml-1001166363) | `src/p_tick.ml:108` | 9 | 6 | 3 | 2 | 1 | 219.62 | 62.38 |
| [`P_ResolveThinkerOwner`](File-src-p-tick-ml-887781845.md#function-function-p-resolvethinkerowner-function-p-resolvethinkerowner-node-src-p-tick-ml-1658580094) | `src/p_tick.ml:62` | 12 | 10 | 5 | 5 | 2 | 326.9 | 58.18 |
| [`P_RespawnSpecials`](File-src-p-mobj-ml-1335564114.md#function-function-p-respawnspecials-function-p-respawnspecials-src-p-mobj-ml-1492768585) | `src/p_mobj.ml:1345` | 36 | 35 | 14 | 15 | 2 | 1659.35 | 41.62 |
| [`P_RunFrozenPlayerMobjs`](File-src-p-tick-ml-887781845.md#function-function-p-runfrozenplayermobjs-function-p-runfrozenplayermobjs-src-p-tick-ml-1618097020) | `src/p_tick.ml:169` | 12 | 7 | 8 | 10 | 3 | 405 | 57.13 |
| [`P_RunThinkers`](File-src-p-tick-ml-887781845.md#function-function-p-runthinkers-function-p-runthinkers-src-p-tick-ml-313370360) | `src/p_tick.ml:127` | 34 | 25 | 15 | 33 | 5 | 1089.25 | 43.31 |
| [`P_SetMobjState`](File-src-p-mobj-ml-1335564114.md#function-function-p-setmobjstate-function-p-setmobjstate-mobj-state-src-p-mobj-ml-256522030) | `src/p_mobj.ml:444` | 74 | 55 | 27 | 44 | 3 | 2476.09 | 31.83 |
| [`P_SetPsprite`](File-src-p-pspr-ml-844718747.md#function-function-p-setpsprite-function-p-setpsprite-player-position-stnum-src-p-pspr-ml-1010680289) | `src/p_pspr.ml:328` | 46 | 40 | 23 | 36 | 3 | 1771.24 | 37.89 |
| [`P_SetThingPosition`](File-src-p-maputl-ml-227665141.md#function-function-p-setthingposition-function-p-setthingposition-thing-src-p-maputl-ml-1951673242) | `src/p_maputl.ml:343` | 39 | 31 | 16 | 24 | 3 | 1464.78 | 40.97 |
| [`P_SetupLevel`](File-src-p-setup-ml-2057900615.md#function-function-p-setuplevel-function-p-setuplevel-episode-map-playermask-skill-src-p-setup-ml-743283847) | `src/p_setup.ml:740` | 106 | 95 | 25 | 35 | 4 | 3723.51 | 27.45 |
| [`P_SetupPsprites`](File-src-p-pspr-ml-844718747.md#function-function-p-setuppsprites-function-p-setuppsprites-player-src-p-pspr-ml-506929065) | `src/p_pspr.ml:515` | 11 | 9 | 3 | 2 | 1 | 259.6 | 59.97 |
| [`P_ShootSpecialLine`](File-src-p-spec-ml-402508231.md#function-function-p-shootspecialline-function-p-shootspecialline-thing-line-src-p-spec-ml-566507318) | `src/p_spec.ml:753` | 22 | 18 | 12 | 14 | 2 | 766.38 | 48.91 |
| [`P_SlideMove`](File-src-p-map-ml-882556686.md#function-function-p-slidemove-function-p-slidemove-mo-src-p-map-ml-2080095611) | `src/p_map.ml:801` | 76 | 64 | 16 | 33 | 4 | 2913.81 | 32.56 |
| [`P_SpawnBlood`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnblood-function-p-spawnblood-x-y-z-damage-src-p-mobj-ml-639092283) | `src/p_mobj.ml:1266` | 14 | 13 | 7 | 6 | 1 | 770.72 | 53.84 |
| [`P_SpawnDoorCloseIn30`](File-src-p-doors-ml-224295587.md#function-function-p-spawndoorclosein30-function-p-spawndoorclosein30-sec-src-p-doors-ml-31683431) | `src/p_doors.ml:432` | 12 | 12 | 3 | 2 | 1 | 528.54 | 56.99 |
| [`P_SpawnDoorRaiseIn5Mins`](File-src-p-doors-ml-224295587.md#function-function-p-spawndoorraisein5mins-function-p-spawndoorraisein5mins-sec-secnum-src-p-doors-ml-2101713618) | `src/p_doors.ml:450` | 15 | 15 | 3 | 2 | 1 | 714.88 | 53.96 |
| [`P_SpawnFireFlicker`](File-src-p-lights-ml-1710096069.md#function-function-p-spawnfireflicker-function-p-spawnfireflicker-sector-src-p-lights-ml-2047846770) | `src/p_lights.ml:69` | 8 | 8 | 3 | 2 | 1 | 377.83 | 61.85 |
| [`P_SpawnGlowingLight`](File-src-p-lights-ml-1710096069.md#function-function-p-spawnglowinglight-function-p-spawnglowinglight-sector-src-p-lights-ml-621564260) | `src/p_lights.ml:247` | 9 | 9 | 3 | 2 | 1 | 415 | 60.45 |
| [`P_SpawnLightFlash`](File-src-p-lights-ml-1710096069.md#function-function-p-spawnlightflash-function-p-spawnlightflash-sector-src-p-lights-ml-1214687330) | `src/p_lights.ml:105` | 10 | 11 | 4 | 3 | 1 | 578.25 | 58.31 |
| [`P_SpawnMapThing`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnmapthing-function-p-spawnmapthing-mthing-src-p-mobj-ml-474331152) | `src/p_mobj.ml:887` | 82 | 61 | 28 | 32 | 3 | 2936.46 | 30.2 |
| [`P_SpawnMissile`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnmissile-function-p-spawnmissile-source-dest-type-src-p-mobj-ml-1682134020) | `src/p_mobj.ml:661` | 38 | 38 | 19 | 19 | 2 | 2405.45 | 39.31 |
| [`P_SpawnMobj`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnmobj-function-p-spawnmobj-x-y-z-type-src-p-mobj-ml-151319488) | `src/p_mobj.ml:533` | 71 | 58 | 17 | 18 | 2 | 3010.71 | 32.97 |
| [`P_SpawnPlayer`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnplayer-function-p-spawnplayer-mthing-src-p-mobj-ml-1901578954) | `src/p_mobj.ml:802` | 67 | 58 | 26 | 33 | 3 | 2963.39 | 32.36 |
| [`P_SpawnPlayerMissile`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnplayermissile-function-p-spawnplayermissile-source-type-src-p-mobj-ml-1384187652) | `src/p_mobj.ml:711` | 45 | 43 | 17 | 19 | 2 | 2396.85 | 37.99 |
| [`P_SpawnPuff`](File-src-p-mobj-ml-1335564114.md#function-function-p-spawnpuff-function-p-spawnpuff-x-y-z-src-p-mobj-ml-732981978) | `src/p_mobj.ml:1246` | 12 | 12 | 5 | 4 | 1 | 621.48 | 56.23 |
| [`P_SpawnSpecials`](File-src-p-spec-ml-402508231.md#function-function-p-spawnspecials-function-p-spawnspecials-src-p-spec-ml-1573826186) | `src/p_spec.ml:574` | 101 | 66 | 32 | 31 | 3 | 2793.44 | 27.84 |
| [`P_SpawnStrobeFlash`](File-src-p-lights-ml-1710096069.md#function-function-p-spawnstrobeflash-function-p-spawnstrobeflash-sector-fastorslow-insync-src-p-lights-ml-1885627840) | `src/p_lights.ml:143` | 23 | 21 | 7 | 7 | 2 | 966.32 | 48.45 |
| [`P_StartButton`](File-src-p-switch-ml-925070734.md#function-function-p-startbutton-function-p-startbutton-line-w-texture-time-src-p-switch-ml-1250795040) | `src/p_switch.ml:231` | 27 | 19 | 8 | 11 | 3 | 803.61 | 47.36 |
| [`P_TeleportMove`](File-src-p-map-ml-882556686.md#function-function-p-teleportmove-function-p-teleportmove-thing-x-y-src-p-map-ml-822617392) | `src/p_map.ml:592` | 42 | 39 | 7 | 9 | 3 | 1389.13 | 41.64 |
| [`P_ThingHeightClip`](File-src-p-map-ml-882556686.md#function-function-p-thingheightclip-function-p-thingheightclip-thing-src-p-map-ml-1413609655) | `src/p_map.ml:644` | 16 | 13 | 5 | 5 | 2 | 535 | 53.96 |
| [`P_Thrust`](File-src-p-user-ml-1917117091.md#function-function-p-thrust-function-p-thrust-player-angle-move-src-p-user-ml-784374831) | `src/p_user.ml:157` | 9 | 11 | 10 | 9 | 1 | 641.16 | 58.18 |
| [`P_Ticker`](File-src-p-tick-ml-887781845.md#function-function-p-ticker-function-p-ticker-src-p-tick-ml-754217540) | `src/p_tick.ml:183` | 38 | 39 | 31 | 34 | 3 | 1770.68 | 38.63 |
| [`P_TouchSpecialThing`](File-src-p-inter-ml-1430401638.md#function-function-p-touchspecialthing-function-p-touchspecialthing-special-toucher-src-p-inter-ml-1177249818) | `src/p_inter.ml:502` | 226 | 199 | 107 | 171 | 5 | 12480.51 | 5.57 |
| [`P_TraverseIntercepts`](File-src-p-maputl-ml-227665141.md#function-function-p-traverseintercepts-function-p-traverseintercepts-func-maxfrac-src-p-maputl-ml-1021342438) | `src/p_maputl.ml:626` | 28 | 21 | 8 | 13 | 3 | 630.73 | 47.75 |
| [`P_TryMove`](File-src-p-map-ml-882556686.md#function-function-p-trymove-function-p-trymove-thing-x-y-src-p-map-ml-986644990) | `src/p_map.ml:485` | 89 | 78 | 35 | 58 | 4 | 4649.48 | 27.09 |
| [`P_TryWalk`](File-src-p-enemy-ml-1875479956.md#function-function-p-trywalk-function-p-trywalk-actor-src-p-enemy-ml-2059769982) | `src/p_enemy.ml:402` | 5 | 4 | 2 | 1 | 1 | 123.19 | 69.85 |
| [`P_UnArchivePlayers`](File-src-p-saveg-ml-1704891910.md#function-function-p-unarchiveplayers-function-p-unarchiveplayers-src-p-saveg-ml-1642831845) | `src/p_saveg.ml:628` | 31 | 28 | 16 | 24 | 3 | 1213.9 | 43.72 |
| [`P_UnArchiveSpecials`](File-src-p-saveg-ml-1704891910.md#function-function-p-unarchivespecials-function-p-unarchivespecials-src-p-saveg-ml-1069769677) | `src/p_saveg.ml:1266` | 50 | 38 | 16 | 26 | 2 | 1312.37 | 38.95 |
| [`P_UnArchiveThinkers`](File-src-p-saveg-ml-1704891910.md#function-function-p-unarchivethinkers-function-p-unarchivethinkers-src-p-saveg-ml-237453381) | `src/p_saveg.ml:990` | 30 | 27 | 10 | 13 | 3 | 884.43 | 45.8 |
| [`P_UnArchiveWorld`](File-src-p-saveg-ml-1704891910.md#function-function-p-unarchiveworld-function-p-unarchiveworld-src-p-saveg-ml-2067237545) | `src/p_saveg.ml:731` | 60 | 53 | 15 | 19 | 3 | 2079.26 | 35.96 |
| [`P_UnregisterThinkerOwner`](File-src-p-tick-ml-887781845.md#function-function-p-unregisterthinkerowner-function-p-unregisterthinkerowner-node-src-p-tick-ml-1231027612) | `src/p_tick.ml:77` | 15 | 12 | 4 | 4 | 2 | 313.82 | 56.32 |
| [`P_UnsetThingPosition`](File-src-p-maputl-ml-227665141.md#function-function-p-unsetthingposition-function-p-unsetthingposition-thing-src-p-maputl-ml-1842751442) | `src/p_maputl.ml:296` | 35 | 23 | 16 | 28 | 4 | 1313.84 | 42.33 |
| [`P_UpdateButtons`](File-src-p-switch-ml-925070734.md#function-function-p-updatebuttons-function-p-updatebuttons-src-p-switch-ml-747268229) | `src/p_switch.ml:326` | 27 | 18 | 8 | 25 | 5 | 828.53 | 47.27 |
| [`P_UpdateSpecials`](File-src-p-spec-ml-402508231.md#function-function-p-updatespecials-function-p-updatespecials-src-p-spec-ml-554269270) | `src/p_spec.ml:686` | 59 | 44 | 30 | 65 | 6 | 2197.57 | 33.94 |
| [`P_UseLines`](File-src-p-map-ml-882556686.md#function-function-p-uselines-function-p-uselines-player-src-p-map-ml-1960710740) | `src/p_map.ml:893` | 12 | 11 | 3 | 2 | 1 | 631.56 | 56.45 |
| [`P_UseSpecialLine`](File-src-p-switch-ml-925070734.md#function-function-p-usespecialline-function-p-usespecialline-thing-line-side-src-p-switch-ml-1943443042) | `src/p_switch.ml:363` | 280 | 197 | 125 | 114 | 2 | 10997.56 | 1.51 |
| [`P_XYMovement`](File-src-p-mobj-ml-1335564114.md#function-function-p-xymovement-function-p-xymovement-mo-src-p-mobj-ml-1310792247) | `src/p_mobj.ml:1021` | 95 | 70 | 49 | 69 | 4 | 4565.39 | 24.64 |
| [`P_ZMovement`](File-src-p-mobj-ml-1335564114.md#function-function-p-zmovement-function-p-zmovement-mo-src-p-mobj-ml-806994795) | `src/p_mobj.ml:1130` | 55 | 38 | 27 | 43 | 4 | 2958.75 | 34.1 |
| [`PacketGet`](File-src-i-net-ml-1331775872.md#function-function-packetget-function-packetget-sock-nodeout-dataout-lengthout-src-i-net-ml-2043169165) | `src/i_net.ml:434` | 7 | 7 | 5 | 4 | 1 | 319.63 | 63.35 |
| [`PacketSend`](File-src-i-net-ml-1331775872.md#function-function-packetsend-function-packetsend-sock-node-data-length-src-i-net-ml-626423415) | `src/i_net.ml:421` | 7 | 5 | 1 | 0 | 0 | 99.91 | 67.43 |
| [`Patch_ColumnOffset`](File-src-r-defs-ml-1187974936.md#function-function-patch-columnoffset-inline-function-patch-columnoffset-patchbytes-colindex-src-r-defs-ml-976267147) | `src/r_defs.ml:96` | 3 | 1 | 1 | 0 | 0 | 82.04 | 76.06 |
| [`Patch_Height`](File-src-r-defs-ml-1187974936.md#function-function-patch-height-function-patch-height-patchbytes-src-r-defs-ml-1030383874) | `src/r_defs.ml:77` | 3 | 1 | 1 | 0 | 0 | 46.51 | 77.78 |
| [`Patch_LeftOffset`](File-src-r-defs-ml-1187974936.md#function-function-patch-leftoffset-inline-function-patch-leftoffset-patchbytes-src-r-defs-ml-1868314291) | `src/r_defs.ml:83` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`Patch_TopOffset`](File-src-r-defs-ml-1187974936.md#function-function-patch-topoffset-inline-function-patch-topoffset-patchbytes-src-r-defs-ml-1638680039) | `src/r_defs.ml:89` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`Patch_Width`](File-src-r-defs-ml-1187974936.md#function-function-patch-width-function-patch-width-patchbytes-src-r-defs-ml-890337776) | `src/r_defs.ml:71` | 3 | 1 | 1 | 0 | 0 | 46.51 | 77.78 |
| [`PIT_AddLineIntercepts`](File-src-p-maputl-ml-227665141.md#function-function-pit-addlineintercepts-function-pit-addlineintercepts-ld-src-p-maputl-ml-2016716080) | `src/p_maputl.ml:613` | 3 | 1 | 1 | 0 | 0 | 36 | 78.56 |
| [`PIT_AddThingIntercepts`](File-src-p-maputl-ml-227665141.md#function-function-pit-addthingintercepts-function-pit-addthingintercepts-thing-src-p-maputl-ml-1668637938) | `src/p_maputl.ml:619` | 3 | 1 | 1 | 0 | 0 | 36 | 78.56 |
| [`PIT_ChangeSector`](File-src-p-map-ml-882556686.md#function-function-pit-changesector-function-pit-changesector-thing-src-p-map-ml-1424281071) | `src/p_map.ml:911` | 35 | 26 | 11 | 13 | 2 | 1322.55 | 42.98 |
| [`PIT_CheckLine`](File-src-p-map-ml-882556686.md#function-function-pit-checkline-function-pit-checkline-ld-src-p-map-ml-1399994421) | `src/p_map.ml:264` | 46 | 35 | 17 | 18 | 2 | 1428 | 39.35 |
| [`PIT_CheckThing`](File-src-p-map-ml-882556686.md#function-function-pit-checkthing-function-pit-checkthing-thing-src-p-map-ml-1910314675) | `src/p_map.ml:325` | 55 | 44 | 28 | 39 | 3 | 3107.29 | 33.82 |
| [`PIT_RadiusAttack`](File-src-p-map-ml-882556686.md#function-function-pit-radiusattack-function-pit-radiusattack-thing-src-p-map-ml-1849818043) | `src/p_map.ml:986` | 18 | 19 | 9 | 8 | 1 | 791.62 | 51.11 |
| [`PIT_StompThing`](File-src-p-map-ml-882556686.md#function-function-pit-stompthing-function-pit-stompthing-thing-src-p-map-ml-378332423) | `src/p_map.ml:243` | 14 | 13 | 8 | 7 | 1 | 562.54 | 54.67 |
| [`PIT_VileCheck`](File-src-p-enemy-ml-1875479956.md#function-function-pit-vilecheck-function-pit-vilecheck-thing-src-p-enemy-ml-1149051085) | `src/p_enemy.ml:942` | 29 | 29 | 14 | 13 | 1 | 1336.97 | 44.33 |
| [`Player_MakeDefault`](File-src-d-player-ml-1944166105.md#function-function-player-makedefault-function-player-makedefault-src-d-player-ml-1838920520) | `src/d_player.ml:219` | 46 | 16 | 4 | 3 | 1 | 1157.19 | 41.74 |
| [`PTR_AimTraverse`](File-src-p-map-ml-882556686.md#function-function-ptr-aimtraverse-function-ptr-aimtraverse-inter-src-p-map-ml-306114329) | `src/p_map.ml:1053` | 51 | 52 | 24 | 34 | 3 | 2038.25 | 36.35 |
| [`PTR_ShootTraverse`](File-src-p-map-ml-882556686.md#function-function-ptr-shoottraverse-function-ptr-shoottraverse-inter-src-p-map-ml-1007303361) | `src/p_map.ml:1122` | 79 | 69 | 34 | 61 | 5 | 3673.04 | 29.07 |
| [`PTR_SlideTraverse`](File-src-p-map-ml-882556686.md#function-function-ptr-slidetraverse-function-ptr-slidetraverse-inter-src-p-map-ml-1686116781) | `src/p_map.ml:717` | 36 | 34 | 13 | 17 | 2 | 1071.12 | 43.09 |
| [`PTR_UseTraverse`](File-src-p-map-ml-882556686.md#function-function-ptr-usetraverse-function-ptr-usetraverse-inter-src-p-map-ml-1685721921) | `src/p_map.ml:762` | 31 | 26 | 15 | 18 | 3 | 1106.1 | 44.14 |
| [`R_AddLine`](File-src-r-bsp-ml-998402465.md#function-function-r-addline-function-r-addline-line-src-r-bsp-ml-312334856) | `src/r_bsp.ml:448` | 65 | 63 | 24 | 25 | 2 | 2644.39 | 33.26 |
| [`R_AddPointToBox`](File-src-r-main-ml-1902335243.md#function-function-r-addpointtobox-function-r-addpointtobox-x-y-box-src-r-main-ml-1847282580) | `src/r_main.ml:787` | 13 | 8 | 7 | 6 | 1 | 418.43 | 56.4 |
| [`R_AddPSprites`](File-src-r-things-ml-545677447.md#function-function-r-addpsprites-function-r-addpsprites-src-r-things-ml-131247462) | `src/r_things.ml:1161` | 7 | 8 | 5 | 4 | 1 | 224.66 | 64.43 |
| [`R_AddSprites`](File-src-r-things-ml-545677447.md#function-function-r-addsprites-function-r-addsprites-sec-src-r-things-ml-583186175) | `src/r_things.ml:1133` | 23 | 20 | 10 | 11 | 2 | 737.97 | 48.87 |
| [`R_BspProfileReset`](File-src-r-bsp-ml-998402465.md#function-function-r-bspprofilereset-function-r-bspprofilereset-src-r-bsp-ml-361444462) | `src/r_bsp.ml:153` | 28 | 26 | 1 | 0 | 0 | 311.85 | 50.83 |
| [`R_BspProfileSetEnabled`](File-src-r-bsp-ml-998402465.md#function-function-r-bspprofilesetenabled-function-r-bspprofilesetenabled-on-src-r-bsp-ml-697677803) | `src/r_bsp.ml:147` | 4 | 2 | 1 | 0 | 0 | 38.04 | 75.67 |
| [`R_CheckBBox`](File-src-r-bsp-ml-998402465.md#function-function-r-checkbbox-function-r-checkbbox-bspcoord-src-r-bsp-ml-1452739868) | `src/r_bsp.ml:531` | 59 | 59 | 23 | 24 | 2 | 2583.3 | 34.39 |
| [`R_CheckPlane`](File-src-r-plane-ml-1848108848.md#function-function-r-checkplane-function-r-checkplane-pl-start-stop-src-r-plane-ml-153523453) | `src/r_plane.ml:732` | 41 | 34 | 10 | 10 | 2 | 1111.59 | 42.15 |
| [`R_CheckTextureNumForName`](File-src-r-data-ml-1686270288.md#function-function-r-checktexturenumforname-function-r-checktexturenumforname-name-src-r-data-ml-779540780) | `src/r_data.ml:1052` | 16 | 12 | 7 | 7 | 2 | 465.29 | 54.11 |
| [`R_ClearClipSegs`](File-src-r-bsp-ml-998402465.md#function-function-r-clearclipsegs-function-r-clearclipsegs-src-r-bsp-ml-1495323198) | `src/r_bsp.ml:324` | 8 | 7 | 3 | 2 | 1 | 210.91 | 63.62 |
| [`R_ClearDrawSegs`](File-src-r-bsp-ml-998402465.md#function-function-r-cleardrawsegs-function-r-cleardrawsegs-src-r-bsp-ml-1814161838) | `src/r_bsp.ml:307` | 12 | 8 | 3 | 3 | 2 | 208.08 | 59.82 |
| [`R_ClearPlanes`](File-src-r-plane-ml-1848108848.md#function-function-r-clearplanes-function-r-clearplanes-src-r-plane-ml-1641946997) | `src/r_plane.ml:390` | 38 | 31 | 8 | 7 | 1 | 941.62 | 43.64 |
| [`R_ClearSolidClipScales`](File-src-r-segs-ml-1658887754.md#function-function-r-clearsolidclipscales-function-r-clearsolidclipscales-src-r-segs-ml-1155629663) | `src/r_segs.ml:228` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`R_ClearSprites`](File-src-r-things-ml-545677447.md#function-function-r-clearsprites-function-r-clearsprites-src-r-things-ml-1116153862) | `src/r_things.ml:527` | 74 | 66 | 10 | 11 | 2 | 1656.04 | 35.34 |
| [`R_ClipPassWallSegment`](File-src-r-bsp-ml-998402465.md#function-function-r-clippasswallsegment-function-r-clippasswallsegment-first-last-src-r-bsp-ml-1252318656) | `src/r_bsp.ml:414` | 26 | 26 | 14 | 15 | 2 | 1015 | 46.2 |
| [`R_ClipSolidWallSegment`](File-src-r-bsp-ml-998402465.md#function-function-r-clipsolidwallsegment-function-r-clipsolidwallsegment-first-last-src-r-bsp-ml-1731342786) | `src/r_bsp.ml:338` | 61 | 60 | 23 | 34 | 3 | 2151.65 | 34.63 |
| [`R_ClipVisSprite`](File-src-r-things-ml-545677447.md#function-function-r-clipvissprite-function-r-clipvissprite-vis-xl-xh-src-r-things-ml-917264814) | `src/r_things.ml:1500` | 5 | 3 | 1 | 0 | 0 | 66.44 | 71.86 |
| [`R_DepthBeginSprite`](File-src-r-draw-ml-919823710.md#function-function-r-depthbeginsprite-function-r-depthbeginsprite-scale-src-r-draw-ml-945061931) | `src/r_draw.ml:164` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`R_DepthBeginWall`](File-src-r-draw-ml-919823710.md#function-function-r-depthbeginwall-function-r-depthbeginwall-scale-src-r-draw-ml-1103456663) | `src/r_draw.ml:153` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`R_DepthClear`](File-src-r-draw-ml-919823710.md#function-function-r-depthclear-function-r-depthclear-src-r-draw-ml-1883098487) | `src/r_draw.ml:146` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`R_DepthEndSprite`](File-src-r-draw-ml-919823710.md#function-function-r-depthendsprite-function-r-depthendsprite-src-r-draw-ml-752621639) | `src/r_draw.ml:169` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`R_DepthEndWall`](File-src-r-draw-ml-919823710.md#function-function-r-depthendwall-function-r-depthendwall-src-r-draw-ml-1006992463) | `src/r_draw.ml:158` | 2 | 0 | 1 | 0 | 0 | 13.93 | 85.29 |
| [`R_DrawColumn`](File-src-r-draw-ml-919823710.md#function-function-r-drawcolumn-function-r-drawcolumn-src-r-draw-ml-1697602859) | `src/r_draw.ml:342` | 91 | 90 | 41 | 56 | 3 | 4016.42 | 26.52 |
| [`R_DrawColumnInCache`](File-src-r-data-ml-1686270288.md#function-function-r-drawcolumnincache-function-r-drawcolumnincache-patch-cache-originy-cacheheight-src-r-data-ml-2009713495) | `src/r_data.ml:452` | 26 | 23 | 12 | 16 | 2 | 1001.86 | 46.51 |
| [`R_DrawColumnLow`](File-src-r-draw-ml-919823710.md#function-function-r-drawcolumnlow-function-r-drawcolumnlow-src-r-draw-ml-1832234905) | `src/r_draw.ml:447` | 108 | 104 | 47 | 63 | 3 | 4418.79 | 23.8 |
| [`R_DrawFuzzColumn`](File-src-r-draw-ml-919823710.md#function-function-r-drawfuzzcolumn-function-r-drawfuzzcolumn-src-r-draw-ml-1753582183) | `src/r_draw.ml:565` | 26 | 34 | 17 | 19 | 2 | 1368.11 | 44.89 |
| [`R_DrawFuzzColumnLow`](File-src-r-draw-ml-919823710.md#function-function-r-drawfuzzcolumnlow-function-r-drawfuzzcolumnlow-src-r-draw-ml-1503867063) | `src/r_draw.ml:595` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`R_DrawMasked`](File-src-r-things-ml-545677447.md#function-function-r-drawmasked-function-r-drawmasked-src-r-things-ml-1867631602) | `src/r_things.ml:1509` | 19 | 12 | 11 | 13 | 3 | 642.91 | 50.96 |
| [`R_DrawMaskedColumn`](File-src-r-things-ml-545677447.md#function-function-r-drawmaskedcolumn-function-r-drawmaskedcolumn-column-src-r-things-ml-957953800) | `src/r_things.ml:768` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`R_DrawPlanes`](File-src-r-plane-ml-1848108848.md#function-function-r-drawplanes-function-r-drawplanes-src-r-plane-ml-579493703) | `src/r_plane.ml:689` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`R_DrawPlayerSprites`](File-src-r-things-ml-545677447.md#function-function-r-drawplayersprites-function-r-drawplayersprites-player-src-r-things-ml-1026172293) | `src/r_things.ml:1469` | 21 | 21 | 12 | 12 | 2 | 969.07 | 48.63 |
| [`R_DrawProfileReset`](File-src-r-draw-ml-919823710.md#function-function-r-drawprofilereset-function-r-drawprofilereset-src-r-draw-ml-1711280927) | `src/r_draw.ml:125` | 10 | 8 | 1 | 0 | 0 | 93.21 | 64.26 |
| [`R_DrawProfileSetEnabled`](File-src-r-draw-ml-919823710.md#function-function-r-drawprofilesetenabled-function-r-drawprofilesetenabled-on-src-r-draw-ml-707901650) | `src/r_draw.ml:139` | 4 | 2 | 1 | 0 | 0 | 38.04 | 75.67 |
| [`R_DrawPSprite`](File-src-r-things-ml-545677447.md#function-function-r-drawpsprite-function-r-drawpsprite-player-psp-src-r-things-ml-1969520816) | `src/r_things.ml:1390` | 65 | 66 | 34 | 35 | 2 | 3882.83 | 30.75 |
| [`R_DrawSpan`](File-src-r-draw-ml-919823710.md#function-function-r-drawspan-function-r-drawspan-src-r-draw-ml-1291460371) | `src/r_draw.ml:696` | 54 | 56 | 26 | 28 | 2 | 2703.31 | 34.68 |
| [`R_DrawSpanLow`](File-src-r-draw-ml-919823710.md#function-function-r-drawspanlow-function-r-drawspanlow-src-r-draw-ml-643270273) | `src/r_draw.ml:756` | 62 | 61 | 25 | 30 | 3 | 2729.71 | 33.48 |
| [`R_DrawSprite`](File-src-r-things-ml-545677447.md#function-function-r-drawsprite-function-r-drawsprite-spr-src-r-things-ml-1106248085) | `src/r_things.ml:1203` | 106 | 93 | 48 | 102 | 5 | 4456.15 | 23.81 |
| [`R_DrawSprites`](File-src-r-things-ml-545677447.md#function-function-r-drawsprites-function-r-drawsprites-src-r-things-ml-1862688800) | `src/r_things.ml:1322` | 13 | 10 | 5 | 5 | 2 | 284.6 | 57.84 |
| [`R_DrawTranslatedColumn`](File-src-r-draw-ml-919823710.md#function-function-r-drawtranslatedcolumn-function-r-drawtranslatedcolumn-src-r-draw-ml-1752608583) | `src/r_draw.ml:600` | 83 | 84 | 38 | 54 | 3 | 3578.21 | 28.14 |
| [`R_DrawTranslatedColumnLow`](File-src-r-draw-ml-919823710.md#function-function-r-drawtranslatedcolumnlow-function-r-drawtranslatedcolumnlow-src-r-draw-ml-1428647693) | `src/r_draw.ml:690` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`R_DrawViewBorder`](File-src-r-draw-ml-919823710.md#function-function-r-drawviewborder-function-r-drawviewborder-src-r-draw-ml-2079482519) | `src/r_draw.ml:905` | 19 | 19 | 6 | 5 | 1 | 744.95 | 51.19 |
| [`R_DrawVisSprite`](File-src-r-things-ml-545677447.md#function-function-r-drawvissprite-function-r-drawvissprite-vis-x1-x2-src-r-things-ml-2004940949) | `src/r_things.ml:886` | 75 | 71 | 29 | 35 | 3 | 2950.87 | 30.9 |
| [`R_ExecuteSetViewSize`](File-src-r-main-ml-1902335243.md#function-function-r-executesetviewsize-function-r-executesetviewsize-src-r-main-ml-553064750) | `src/r_main.ml:956` | 4 | 3 | 2 | 1 | 1 | 72.34 | 73.58 |
| [`R_FillBackScreen`](File-src-r-draw-ml-919823710.md#function-function-r-fillbackscreen-function-r-fillbackscreen-src-r-draw-ml-557823155) | `src/r_draw.ml:847` | 49 | 44 | 16 | 21 | 4 | 2193.61 | 37.58 |
| [`R_FindPlane`](File-src-r-plane-ml-1848108848.md#function-function-r-findplane-function-r-findplane-height-picnum-lightlevel-src-r-plane-ml-917624394) | `src/r_plane.ml:698` | 24 | 18 | 8 | 8 | 2 | 650.1 | 49.12 |
| [`R_FlatNumForName`](File-src-r-data-ml-1686270288.md#function-function-r-flatnumforname-function-r-flatnumforname-name-src-r-data-ml-340882992) | `src/r_data.ml:696` | 9 | 6 | 2 | 1 | 1 | 178.38 | 63.15 |
| [`R_GenerateComposite`](File-src-r-data-ml-1686270288.md#function-function-r-generatecomposite-function-r-generatecomposite-texnum-src-r-data-ml-374801974) | `src/r_data.ml:530` | 47 | 49 | 31 | 47 | 4 | 2479.07 | 35.59 |
| [`R_GenerateLookup`](File-src-r-data-ml-1686270288.md#function-function-r-generatelookup-function-r-generatelookup-texnum-src-r-data-ml-1845411340) | `src/r_data.ml:589` | 75 | 71 | 32 | 50 | 3 | 3228.62 | 30.22 |
| [`R_GetColumn`](File-src-r-data-ml-1686270288.md#function-function-r-getcolumn-function-r-getcolumn-tex-col-src-r-data-ml-1532254948) | `src/r_data.ml:944` | 62 | 62 | 47 | 74 | 6 | 3523.81 | 29.74 |
| [`R_GetFlat`](File-src-r-data-ml-1686270288.md#function-function-r-getflat-function-r-getflat-flatnum-src-r-data-ml-951115176) | `src/r_data.ml:710` | 9 | 8 | 7 | 6 | 1 | 358.15 | 60.36 |
| [`R_GetMaskedColumnRaw`](File-src-r-data-ml-1686270288.md#function-function-r-getmaskedcolumnraw-function-r-getmaskedcolumnraw-tex-col-src-r-data-ml-978831622) | `src/r_data.ml:1017` | 27 | 35 | 23 | 22 | 1 | 1590.42 | 43.27 |
| [`R_Init`](File-src-r-main-ml-1902335243.md#function-function-r-init-function-r-init-src-r-main-ml-761046434) | `src/r_main.ml:805` | 34 | 29 | 12 | 11 | 1 | 947.3 | 44.14 |
| [`R_InitBuffer`](File-src-r-draw-ml-919823710.md#function-function-r-initbuffer-function-r-initbuffer-width-height-src-r-draw-ml-61239804) | `src/r_draw.ml:285` | 26 | 24 | 10 | 9 | 1 | 867.92 | 47.21 |
| [`R_InitColormaps`](File-src-r-data-ml-1686270288.md#function-function-r-initcolormaps-function-r-initcolormaps-src-r-data-ml-403085999) | `src/r_data.ml:754` | 5 | 3 | 1 | 0 | 0 | 83.76 | 71.15 |
| [`R_InitData`](File-src-r-data-ml-1686270288.md#function-function-r-initdata-function-r-initdata-src-r-data-ml-1980897465) | `src/r_data.ml:1286` | 7 | 5 | 1 | 0 | 0 | 69.76 | 68.52 |
| [`R_InitFlats`](File-src-r-data-ml-1686270288.md#function-function-r-initflats-function-r-initflats-src-r-data-ml-1811720223) | `src/r_data.ml:675` | 15 | 12 | 2 | 1 | 1 | 311.14 | 56.62 |
| [`R_InitLightTables`](File-src-r-main-ml-1902335243.md#function-function-r-initlighttables-function-r-initlighttables-src-r-main-ml-851065574) | `src/r_main.ml:972` | 30 | 27 | 6 | 10 | 3 | 960.86 | 46.09 |
| [`R_InitPlanes`](File-src-r-plane-ml-1848108848.md#function-function-r-initplanes-function-r-initplanes-src-r-plane-ml-610144495) | `src/r_plane.ml:334` | 47 | 40 | 6 | 6 | 2 | 1215.18 | 41.12 |
| [`R_InitPointToAngle`](File-src-r-main-ml-1902335243.md#function-function-r-initpointtoangle-function-r-initpointtoangle-src-r-main-ml-1811893726) | `src/r_main.ml:962` | 3 | 2 | 2 | 1 | 1 | 65.73 | 76.6 |
| [`R_InitSkyMap`](File-src-r-sky-ml-918225537.md#function-function-r-initskymap-function-r-initskymap-src-r-sky-ml-1095954206) | `src/r_sky.ml:36` | 16 | 11 | 5 | 4 | 1 | 322.09 | 55.5 |
| [`R_InitSpriteDefs`](File-src-r-things-ml-545677447.md#function-function-r-initspritedefs-function-r-initspritedefs-namelist-src-r-things-ml-3851591) | `src/r_things.ml:1382` | 3 | 1 | 1 | 0 | 0 | 30.88 | 79.03 |
| [`R_InitSpriteLumps`](File-src-r-data-ml-1686270288.md#function-function-r-initspritelumps-function-r-initspritelumps-src-r-data-ml-1665630727) | `src/r_data.ml:722` | 27 | 23 | 3 | 3 | 2 | 765.1 | 48.18 |
| [`R_InitSprites`](File-src-r-things-ml-545677447.md#function-function-r-initsprites-function-r-initsprites-namelist-src-r-things-ml-1855192337) | `src/r_things.ml:1338` | 36 | 29 | 12 | 14 | 3 | 1218.46 | 42.83 |
| [`R_InitTables`](File-src-r-main-ml-1902335243.md#function-function-r-inittables-function-r-inittables-src-r-main-ml-21188798) | `src/r_main.ml:967` | 3 | 2 | 2 | 1 | 1 | 65.73 | 76.6 |
| [`R_InitTextureMapping`](File-src-r-main-ml-1902335243.md#function-function-r-inittexturemapping-function-r-inittexturemapping-src-r-main-ml-1131780190) | `src/r_main.ml:1034` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`R_InitTextures`](File-src-r-data-ml-1686270288.md#function-function-r-inittextures-function-r-inittextures-src-r-data-ml-2134412345) | `src/r_data.ml:764` | 90 | 85 | 21 | 34 | 5 | 3283.15 | 29.92 |
| [`R_InitTranslationTables`](File-src-r-draw-ml-919823710.md#function-function-r-inittranslationtables-function-r-inittranslationtables-src-r-draw-ml-51017837) | `src/r_draw.ml:823` | 19 | 14 | 4 | 4 | 2 | 614.72 | 52.04 |
| [`R_InstallSpriteLump`](File-src-r-things-ml-545677447.md#function-function-r-installspritelump-function-r-installspritelump-lump-frame-rotation-flipped-src-r-things-ml-2000652329) | `src/r_things.ml:394` | 6 | 4 | 1 | 0 | 0 | 86.49 | 69.33 |
| [`R_MakeSpans`](File-src-r-plane-ml-1848108848.md#function-function-r-makespans-function-r-makespans-x-t1-b1-t2-b2-src-r-plane-ml-308509433) | `src/r_plane.ml:525` | 22 | 16 | 17 | 20 | 2 | 821 | 48.02 |
| [`R_MapPlane`](File-src-r-plane-ml-1848108848.md#function-function-r-mapplane-function-r-mapplane-y-x1-x2-src-r-plane-ml-488171667) | `src/r_plane.ml:439` | 71 | 68 | 20 | 22 | 2 | 2454.15 | 33.19 |
| [`R_NewVisSprite`](File-src-r-things-ml-545677447.md#function-function-r-newvissprite-function-r-newvissprite-src-r-things-ml-1508072646) | `src/r_things.ml:608` | 8 | 7 | 2 | 1 | 1 | 151.27 | 64.77 |
| [`R_PointInSubsector`](File-src-r-main-ml-1902335243.md#function-function-r-pointinsubsector-function-r-pointinsubsector-x-y-src-r-main-ml-491971087) | `src/r_main.ml:763` | 17 | 17 | 12 | 14 | 2 | 802.54 | 51.21 |
| [`R_PointOnSegSide`](File-src-r-main-ml-1902335243.md#function-function-r-pointonsegside-inline-function-r-pointonsegside-x-y-seg-src-r-main-ml-824635593) | `src/r_main.ml:563` | 35 | 37 | 15 | 25 | 3 | 1299.34 | 42.5 |
| [`R_PointOnSide`](File-src-r-main-ml-1902335243.md#function-function-r-pointonside-inline-function-r-pointonside-x-y-node-src-r-main-ml-593447418) | `src/r_main.ml:520` | 30 | 31 | 13 | 23 | 3 | 1104.65 | 44.72 |
| [`R_PointToAngle`](File-src-r-main-ml-1902335243.md#function-function-r-pointtoangle-function-r-pointtoangle-x-y-src-r-main-ml-1905448667) | `src/r_main.ml:609` | 41 | 26 | 10 | 19 | 3 | 1105 | 42.16 |
| [`R_PointToAngle2`](File-src-r-main-ml-1902335243.md#function-function-r-pointtoangle2-inline-function-r-pointtoangle2-x1-y1-x2-y2-src-r-main-ml-604360867) | `src/r_main.ml:662` | 12 | 10 | 1 | 0 | 0 | 198.81 | 60.23 |
| [`R_PointToDist`](File-src-r-main-ml-1902335243.md#function-function-r-pointtodist-inline-function-r-pointtodist-x-y-src-r-main-ml-1687323770) | `src/r_main.ml:679` | 26 | 30 | 13 | 13 | 2 | 1316.44 | 45.54 |
| [`R_PrecacheLevel`](File-src-r-data-ml-1686270288.md#function-function-r-precachelevel-function-r-precachelevel-src-r-data-ml-1678477413) | `src/r_data.ml:1086` | 177 | 136 | 89 | 182 | 7 | 7657.31 | 11.8 |
| [`R_ProjectSprite`](File-src-r-things-ml-545677447.md#function-function-r-projectsprite-function-r-projectsprite-thing-src-r-things-ml-755758406) | `src/r_things.ml:973` | 140 | 120 | 32 | 36 | 3 | 6095.54 | 22.38 |
| [`R_RenderBSPNode`](File-src-r-bsp-ml-998402465.md#function-function-r-renderbspnode-function-r-renderbspnode-bspnum-src-r-bsp-ml-623454997) | `src/r_bsp.ml:665` | 44 | 37 | 11 | 11 | 2 | 1364.73 | 40.72 |
| [`R_RenderClassicPlayerView`](File-src-r-main-ml-1902335243.md#function-function-r-renderclassicplayerview-function-r-renderclassicplayerview-player-src-r-main-ml-1669681167) | `src/r_main.ml:1080` | 87 | 62 | 31 | 37 | 2 | 2353.75 | 29.91 |
| [`R_RendererActive`](File-src-r-renderer-ml-72894217.md#function-function-r-rendereractive-function-r-rendereractive-src-r-renderer-ml-1627223828) | `src/r_renderer.ml:71` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`R_RendererIsOpenGL`](File-src-r-renderer-ml-72894217.md#function-function-r-rendererisopengl-function-r-rendererisopengl-src-r-renderer-ml-611886164) | `src/r_renderer.ml:76` | 3 | 1 | 1 | 0 | 0 | 31.7 | 78.95 |
| [`R_RendererName`](File-src-r-renderer-ml-72894217.md#function-function-r-renderername-function-r-renderername-mode-src-r-renderer-ml-594316909) | `src/r_renderer.ml:97` | 4 | 3 | 2 | 1 | 1 | 79.95 | 73.27 |
| [`R_RendererNormalize`](File-src-r-renderer-ml-72894217.md#function-function-r-renderernormalize-function-r-renderernormalize-mode-src-r-renderer-ml-1842468971) | `src/r_renderer.ml:35` | 4 | 3 | 2 | 1 | 1 | 64.53 | 73.93 |
| [`R_RendererRequest`](File-src-r-renderer-ml-72894217.md#function-function-r-rendererrequest-function-r-rendererrequest-mode-src-r-renderer-ml-812270171) | `src/r_renderer.ml:42` | 5 | 3 | 1 | 0 | 0 | 58.81 | 72.23 |
| [`R_RendererRequested`](File-src-r-renderer-ml-72894217.md#function-function-r-rendererrequested-function-r-rendererrequested-src-r-renderer-ml-1003406996) | `src/r_renderer.ml:50` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`R_RendererRequestedOpenGL`](File-src-r-renderer-ml-72894217.md#function-function-r-rendererrequestedopengl-function-r-rendererrequestedopengl-src-r-renderer-ml-249912758) | `src/r_renderer.ml:55` | 3 | 1 | 1 | 0 | 0 | 31.7 | 78.95 |
| [`R_RendererSetActive`](File-src-r-renderer-ml-72894217.md#function-function-r-renderersetactive-function-r-renderersetactive-mode-src-r-renderer-ml-1923231373) | `src/r_renderer.ml:61` | 7 | 5 | 1 | 0 | 0 | 91.38 | 67.7 |
| [`R_RendererSetHDAssetsEnabled`](File-src-r-renderer-ml-72894217.md#function-function-r-renderersethdassetsenabled-function-r-renderersethdassetsenabled-enabled-src-r-renderer-ml-884527413) | `src/r_renderer.ml:87` | 6 | 5 | 3 | 2 | 1 | 120.93 | 68.04 |
| [`R_RendererUsesHDAssets`](File-src-r-renderer-ml-72894217.md#function-function-r-rendereruseshdassets-function-r-rendereruseshdassets-src-r-renderer-ml-28442820) | `src/r_renderer.ml:81` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`R_RenderMaskedSegRange`](File-src-r-segs-ml-1658887754.md#function-function-r-rendermaskedsegrange-function-r-rendermaskedsegrange-ds-x1-x2-src-r-segs-ml-1127673351) | `src/r_segs.ml:578` | 68 | 67 | 29 | 44 | 5 | 2895.44 | 31.89 |
| [`R_RenderPlayerView`](File-src-r-main-ml-1902335243.md#function-function-r-renderplayerview-function-r-renderplayerview-player-src-r-main-ml-1511226413) | `src/r_main.ml:1182` | 6 | 4 | 3 | 3 | 2 | 96.79 | 68.72 |
| [`R_RenderSegLoop`](File-src-r-segs-ml-1658887754.md#function-function-r-rendersegloop-function-r-rendersegloop-src-r-segs-ml-1681211195) | `src/r_segs.ml:659` | 130 | 110 | 44 | 104 | 5 | 5081.74 | 22.02 |
| [`R_ResetViewInterpolation`](File-src-r-main-ml-1902335243.md#function-function-r-resetviewinterpolation-function-r-resetviewinterpolation-src-r-main-ml-1755598922) | `src/r_main.ml:182` | 6 | 4 | 1 | 0 | 0 | 60.94 | 70.39 |
| [`R_ScaleFromGlobalAngle`](File-src-r-main-ml-1902335243.md#function-function-r-scalefromglobalangle-function-r-scalefromglobalangle-visangle-src-r-main-ml-2031394109) | `src/r_main.ml:714` | 37 | 36 | 13 | 16 | 2 | 1473.25 | 41.86 |
| [`R_SetupFrame`](File-src-r-main-ml-1902335243.md#function-function-r-setupframe-function-r-setupframe-player-src-r-main-ml-1007900013) | `src/r_main.ml:1041` | 3 | 1 | 1 | 0 | 0 | 30.88 | 79.03 |
| [`R_SetViewSize`](File-src-r-main-ml-1902335243.md#function-function-r-setviewsize-function-r-setviewsize-blocks-detail-src-r-main-ml-2069391353) | `src/r_main.ml:847` | 94 | 89 | 21 | 22 | 2 | 2738.8 | 30.06 |
| [`R_SortVisSprites`](File-src-r-things-ml-545677447.md#function-function-r-sortvissprites-function-r-sortvissprites-src-r-things-ml-884051462) | `src/r_things.ml:1171` | 25 | 19 | 8 | 8 | 2 | 720 | 48.42 |
| [`R_StoreWallRange`](File-src-r-segs-ml-1658887754.md#function-function-r-storewallrange-function-r-storewallrange-start-stop-src-r-segs-ml-1433765533) | `src/r_segs.ml:809` | 233 | 205 | 67 | 94 | 4 | 10393.53 | 11.22 |
| [`R_Subsector`](File-src-r-bsp-ml-998402465.md#function-function-r-subsector-function-r-subsector-num-src-r-bsp-ml-1480965190) | `src/r_bsp.ml:606` | 49 | 42 | 19 | 24 | 3 | 1600.08 | 38.14 |
| [`R_TextureNumForName`](File-src-r-data-ml-1686270288.md#function-function-r-texturenumforname-function-r-texturenumforname-name-src-r-data-ml-915454452) | `src/r_data.ml:1073` | 10 | 6 | 4 | 4 | 2 | 194.51 | 61.62 |
| [`R_ThingsProfileSetEnabled`](File-src-r-things-ml-545677447.md#function-function-r-thingsprofilesetenabled-function-r-thingsprofilesetenabled-on-src-r-things-ml-974293169) | `src/r_things.ml:151` | 4 | 2 | 1 | 0 | 0 | 38.04 | 75.67 |
| [`R_VideoErase`](File-src-r-draw-ml-919823710.md#function-function-r-videoerase-function-r-videoerase-ofs-count-src-r-draw-ml-935996752) | `src/r_draw.ml:320` | 18 | 23 | 13 | 12 | 1 | 844.52 | 50.38 |
| [`RDefs_I16LE`](File-src-r-defs-ml-1187974936.md#function-function-rdefs-i16le-inline-function-rdefs-i16le-b-off-src-r-defs-ml-1531618801) | `src/r_defs.ml:47` | 5 | 4 | 2 | 1 | 1 | 131.69 | 69.64 |
| [`RDefs_I32LE`](File-src-r-defs-ml-1187974936.md#function-function-rdefs-i32le-inline-function-rdefs-i32le-b-off-src-r-defs-ml-1822406009) | `src/r_defs.ml:63` | 5 | 4 | 2 | 1 | 1 | 131.69 | 69.64 |
| [`RDefs_U16LE`](File-src-r-defs-ml-1187974936.md#function-function-rdefs-u16le-inline-function-rdefs-u16le-b-off-src-r-defs-ml-224073225) | `src/r_defs.ml:40` | 3 | 1 | 1 | 0 | 0 | 104 | 75.33 |
| [`RDefs_U32LE`](File-src-r-defs-ml-1187974936.md#function-function-rdefs-u32le-inline-function-rdefs-u32le-b-off-src-r-defs-ml-346134009) | `src/r_defs.ml:56` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`RGL_AddCachedDepthConvexFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addcacheddepthconvexfloat-function-rgl-addcacheddepthconvexfloat-xs-ys-count-z-src-r-gl-ml-470173012) | `src/r_gl.ml:4960` | 14 | 8 | 2 | 1 | 1 | 446.96 | 56.17 |
| [`RGL_AddCachedDepthQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addcacheddepthquad-function-rgl-addcacheddepthquad-x0-y0-z0-x1-y1-z1-x2-y2-z2-x3-y3-z3-src-r-gl-ml-198407764) | `src/r_gl.ml:4989` | 4 | 2 | 1 | 0 | 0 | 292.56 | 69.46 |
| [`RGL_AddCachedFlatConvexFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addcachedflatconvexfloat-function-rgl-addcachedflatconvexfloat-xs-ys-count-z-flatnum-src-r-gl-ml-548990115) | `src/r_gl.ml:4440` | 25 | 23 | 15 | 15 | 2 | 1306.88 | 45.67 |
| [`RGL_AddCachedWallQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addcachedwallquad-function-rgl-addcachedwallquad-v1-v2-z0-z1-texnum-side-transparent-texturemid-walloffset-src-r-gl-ml-1685486898) | `src/r_gl.ml:3422` | 35 | 27 | 7 | 7 | 2 | 1807.98 | 42.57 |
| [`RGL_AddDynamicLight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-adddynamiclight-function-rgl-adddynamiclight-x-y-z-r-g-b-radius-strength-src-r-gl-ml-1065129223) | `src/r_gl.ml:2446` | 29 | 32 | 9 | 8 | 1 | 1037.48 | 45.77 |
| [`RGL_AddLiquidSectorLights`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addliquidsectorlights-function-rgl-addliquidsectorlights-player-src-r-gl-ml-585086667) | `src/r_gl.ml:2587` | 16 | 16 | 10 | 13 | 3 | 731.63 | 52.33 |
| [`RGL_AddSectorLiquidLight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addsectorliquidlight-function-rgl-addsectorliquidlight-sec-kind-player-pulse-src-r-gl-ml-402641313) | `src/r_gl.ml:2520` | 60 | 55 | 17 | 21 | 3 | 2510.41 | 35.12 |
| [`RGL_AddVolatileFlatTemplate`](File-src-r-gl-ml-2087530889.md#function-function-rgl-addvolatileflattemplate-function-rgl-addvolatileflattemplate-sidx-xs-ys-count-src-r-gl-ml-18352574) | `src/r_gl.ml:5294` | 13 | 11 | 3 | 2 | 1 | 426.9 | 56.88 |
| [`RGL_AngleToDegrees`](File-src-r-gl-ml-2087530889.md#function-function-rgl-angletodegrees-inline-function-rgl-angletodegrees-a-src-r-gl-ml-1872754608) | `src/r_gl.ml:2318` | 5 | 4 | 2 | 1 | 1 | 133.98 | 69.59 |
| [`RGL_ArrayBatchVisible`](File-src-r-gl-ml-2087530889.md#function-function-rgl-arraybatchvisible-function-rgl-arraybatchvisible-batch-src-r-gl-ml-1611708832) | `src/r_gl.ml:4718` | 19 | 20 | 7 | 8 | 2 | 809.82 | 50.8 |
| [`RGL_BeginArrayBatchDraw`](File-src-r-gl-ml-2087530889.md#function-function-rgl-beginarraybatchdraw-function-rgl-beginarraybatchdraw-src-r-gl-ml-444210796) | `src/r_gl.ml:4659` | 5 | 3 | 1 | 0 | 0 | 57.06 | 72.32 |
| [`RGL_BeginFixedArrayScale`](File-src-r-gl-ml-2087530889.md#function-function-rgl-beginfixedarrayscale-function-rgl-beginfixedarrayscale-src-r-gl-ml-117763436) | `src/r_gl.ml:4674` | 10 | 8 | 1 | 0 | 0 | 180 | 62.26 |
| [`RGL_BindOrColor`](File-src-r-gl-ml-2087530889.md#function-function-rgl-bindorcolor-function-rgl-bindorcolor-texid-src-r-gl-ml-1714112880) | `src/r_gl.ml:3312` | 9 | 6 | 2 | 1 | 1 | 133.44 | 64.03 |
| [`RGL_BottomTextureOrZero`](File-src-r-gl-ml-2087530889.md#function-function-rgl-bottomtextureorzero-inline-function-rgl-bottomtextureorzero-side-src-r-gl-ml-682012336) | `src/r_gl.ml:3700` | 4 | 3 | 3 | 2 | 1 | 133.98 | 71.57 |
| [`RGL_BspSideValueFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-bspsidevaluefloat-function-rgl-bspsidevaluefloat-x-y-node-src-r-gl-ml-1759723639) | `src/r_gl.ml:5101` | 7 | 5 | 1 | 0 | 0 | 259.15 | 64.53 |
| [`RGL_BuildCurrentMapGeometryLump`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildcurrentmapgeometrylump-function-rgl-buildcurrentmapgeometrylump-src-r-gl-ml-1993680822) | `src/r_gl.ml:2296` | 13 | 11 | 1 | 0 | 0 | 436.71 | 57.08 |
| [`RGL_BuildDynamicLights`](File-src-r-gl-ml-2087530889.md#function-function-rgl-builddynamiclights-function-rgl-builddynamiclights-player-src-r-gl-ml-478081879) | `src/r_gl.ml:2834` | 80 | 75 | 19 | 25 | 3 | 3214.36 | 31.37 |
| [`RGL_BuildDynamicLightSurfaceRecords`](File-src-r-gl-ml-2087530889.md#function-function-rgl-builddynamiclightsurfacerecords-function-rgl-builddynamiclightsurfacerecords-src-r-gl-ml-1524875900) | `src/r_gl.ml:2995` | 25 | 27 | 7 | 9 | 2 | 1305.4 | 46.75 |
| [`RGL_BuildFlatArrayBatchRange`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildflatarraybatchrange-function-rgl-buildflatarraybatchrange-startindex-endindex-src-r-gl-ml-1611781177) | `src/r_gl.ml:1296` | 78 | 89 | 23 | 49 | 3 | 4753.19 | 29.89 |
| [`RGL_BuildGeometryCache`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildgeometrycache-function-rgl-buildgeometrycache-sigmap-sigsegs-siglines-signodes-sigsubsectors-sigsectormotion-sigsides-src-r-gl-ml-2002145290) | `src/r_gl.ml:5880` | 57 | 55 | 1 | 0 | 0 | 988.61 | 40.59 |
| [`RGL_BuildSpriteLightRecords`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildspritelightrecords-function-rgl-buildspritelightrecords-src-r-gl-ml-1134783598) | `src/r_gl.ml:5631` | 24 | 21 | 5 | 4 | 1 | 1083.08 | 47.97 |
| [`RGL_BuildStaticArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildstaticarraybatches-function-rgl-buildstaticarraybatches-src-r-gl-ml-206026902) | `src/r_gl.ml:1376` | 67 | 63 | 17 | 43 | 4 | 1910.06 | 34.91 |
| [`RGL_BuildStaticDisplayLists`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildstaticdisplaylists-function-rgl-buildstaticdisplaylists-src-r-gl-ml-2073294442) | `src/r_gl.ml:4552` | 64 | 49 | 17 | 42 | 5 | 1569.37 | 35.94 |
| [`RGL_BuildVolatileFlatTemplates`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildvolatileflattemplates-function-rgl-buildvolatileflattemplates-src-r-gl-ml-3226416) | `src/r_gl.ml:6002` | 40 | 33 | 23 | 40 | 6 | 1725.84 | 39.29 |
| [`RGL_BuildVolatileSectorMap`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildvolatilesectormap-function-rgl-buildvolatilesectormap-sigmap-src-r-gl-ml-2017248987) | `src/r_gl.ml:1694` | 95 | 79 | 39 | 90 | 7 | 3464.87 | 26.83 |
| [`RGL_BuildWallArrayBatchRange`](File-src-r-gl-ml-2087530889.md#function-function-rgl-buildwallarraybatchrange-function-rgl-buildwallarraybatchrange-startindex-endindex-src-r-gl-ml-324899809) | `src/r_gl.ml:1217` | 75 | 88 | 20 | 52 | 3 | 5199.73 | 30.39 |
| [`RGL_CachedTexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-cachedtexture-function-rgl-cachedtexture-key-entry-transparent-repeatwrap-src-r-gl-ml-564411882) | `src/r_gl.ml:3068` | 22 | 19 | 10 | 10 | 2 | 944.6 | 48.54 |
| [`RGL_ClampByte`](File-src-r-gl-ml-2087530889.md#function-function-rgl-clampbyte-inline-function-rgl-clampbyte-v-src-r-gl-ml-365661855) | `src/r_gl.ml:2430` | 6 | 7 | 4 | 3 | 1 | 220.42 | 66.08 |
| [`RGL_ClipBspFlatToBoundarySegs`](File-src-r-gl-ml-2087530889.md#function-function-rgl-clipbspflattoboundarysegs-function-rgl-clipbspflattoboundarysegs-ss-xs-ys-count-outx-outy-src-r-gl-ml-1152965151) | `src/r_gl.ml:5241` | 43 | 36 | 19 | 28 | 5 | 1717.06 | 39.16 |
| [`RGL_ClipPolyToNodeSide`](File-src-r-gl-ml-2087530889.md#function-function-rgl-clippolytonodeside-function-rgl-clippolytonodeside-xs-ys-count-node-side-outx-outy-src-r-gl-ml-2020237394) | `src/r_gl.ml:5117` | 51 | 40 | 12 | 21 | 4 | 1527.33 | 38.84 |
| [`RGL_ClipPolyToSegFront`](File-src-r-gl-ml-2087530889.md#function-function-rgl-clippolytosegfront-function-rgl-clippolytosegfront-xs-ys-count-sg-outx-outy-src-r-gl-ml-749815369) | `src/r_gl.ml:5182` | 45 | 38 | 12 | 20 | 4 | 1813.42 | 39.51 |
| [`RGL_CollectFrameMobjs`](File-src-r-gl-ml-2087530889.md#function-function-rgl-collectframemobjs-function-rgl-collectframemobjs-src-r-gl-ml-1152482820) | `src/r_gl.ml:2791` | 37 | 28 | 12 | 15 | 3 | 1020.14 | 43.11 |
| [`RGL_CollectScrollingGeometry`](File-src-r-gl-ml-2087530889.md#function-function-rgl-collectscrollinggeometry-function-rgl-collectscrollinggeometry-src-r-gl-ml-1227417544) | `src/r_gl.ml:6199` | 32 | 30 | 1 | 0 | 0 | 471.06 | 48.32 |
| [`RGL_CollectVolatileGeometry`](File-src-r-gl-ml-2087530889.md#function-function-rgl-collectvolatilegeometry-function-rgl-collectvolatilegeometry-src-r-gl-ml-874496844) | `src/r_gl.ml:6396` | 34 | 32 | 1 | 0 | 0 | 520 | 47.44 |
| [`RGL_CompileFlatDisplayListRange`](File-src-r-gl-ml-2087530889.md#function-function-rgl-compileflatdisplaylistrange-function-rgl-compileflatdisplaylistrange-startindex-endindex-src-r-gl-ml-430350891) | `src/r_gl.ml:4528` | 22 | 19 | 4 | 4 | 2 | 882.1 | 49.55 |
| [`RGL_CompileTexturedQuadDisplayList`](File-src-r-gl-ml-2087530889.md#function-function-rgl-compiletexturedquaddisplaylist-function-rgl-compiletexturedquaddisplaylist-quads-src-r-gl-ml-429694082) | `src/r_gl.ml:3503` | 9 | 9 | 4 | 3 | 1 | 255.41 | 61.79 |
| [`RGL_CompileWallDisplayListRange`](File-src-r-gl-ml-2087530889.md#function-function-rgl-compilewalldisplaylistrange-function-rgl-compilewalldisplaylistrange-startindex-endindex-src-r-gl-ml-879625945) | `src/r_gl.ml:4500` | 24 | 21 | 4 | 4 | 2 | 1066.15 | 48.15 |
| [`RGL_CreateArrayBufferOrZero`](File-src-r-gl-ml-2087530889.md#function-function-rgl-createarraybufferorzero-function-rgl-createarraybufferorzero-data-src-r-gl-ml-1508640476) | `src/r_gl.ml:989` | 5 | 5 | 4 | 3 | 1 | 198.81 | 68.12 |
| [`RGL_CreateInterleavedGeomBufferOrZero`](File-src-r-gl-ml-2087530889.md#function-function-rgl-createinterleavedgeombufferorzero-function-rgl-createinterleavedgeombufferorzero-data-src-r-gl-ml-472528884) | `src/r_gl.ml:997` | 5 | 5 | 4 | 3 | 1 | 198.81 | 68.12 |
| [`RGL_CrossFixed`](File-src-r-gl-ml-2087530889.md#function-function-rgl-crossfixed-inline-function-rgl-crossfixed-ax-ay-bx-by-cx-cy-src-r-gl-ml-1482457826) | `src/r_gl.ml:4104` | 3 | 1 | 1 | 0 | 0 | 269.77 | 72.44 |
| [`RGL_CurrentMapIdentity`](File-src-r-gl-ml-2087530889.md#function-function-rgl-currentmapidentity-inline-function-rgl-currentmapidentity-src-r-gl-ml-1495498101) | `src/r_gl.ml:1519` | 8 | 9 | 4 | 3 | 1 | 272.63 | 62.71 |
| [`RGL_DefaultTextureMid`](File-src-r-gl-ml-2087530889.md#function-function-rgl-defaulttexturemid-function-rgl-defaulttexturemid-z1-side-src-r-gl-ml-1007975330) | `src/r_gl.ml:3407` | 3 | 1 | 1 | 0 | 0 | 55.35 | 77.25 |
| [`RGL_DeleteArrayBatchBuffers`](File-src-r-gl-ml-2087530889.md#function-function-rgl-deletearraybatchbuffers-function-rgl-deletearraybatchbuffers-batches-src-r-gl-ml-312090868) | `src/r_gl.ml:834` | 14 | 15 | 8 | 16 | 3 | 535.05 | 54.82 |
| [`RGL_DeleteStaticDisplayLists`](File-src-r-gl-ml-2087530889.md#function-function-rgl-deletestaticdisplaylists-function-rgl-deletestaticdisplaylists-src-r-gl-ml-569672704) | `src/r_gl.ml:789` | 35 | 36 | 8 | 9 | 2 | 835 | 44.78 |
| [`RGL_DisableCutoutAlpha`](File-src-r-gl-ml-2087530889.md#function-function-rgl-disablecutoutalpha-function-rgl-disablecutoutalpha-src-r-gl-ml-500531412) | `src/r_gl.ml:3329` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`RGL_DrawAllBspFlats`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawallbspflats-function-rgl-drawallbspflats-src-r-gl-ml-1163948924) | `src/r_gl.ml:5444` | 46 | 49 | 20 | 36 | 3 | 2256 | 37.56 |
| [`RGL_DrawAllFlats`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawallflats-function-rgl-drawallflats-src-r-gl-ml-746346704) | `src/r_gl.ml:4415` | 16 | 13 | 5 | 5 | 2 | 561.53 | 53.81 |
| [`RGL_DrawAllLineMidtextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawalllinemidtextures-function-rgl-drawalllinemidtextures-src-r-gl-ml-1035390124) | `src/r_gl.ml:3893` | 14 | 12 | 8 | 8 | 2 | 473.13 | 55.19 |
| [`RGL_DrawAllMaskedWalls`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawallmaskedwalls-function-rgl-drawallmaskedwalls-src-r-gl-ml-276944944) | `src/r_gl.ml:3846` | 10 | 8 | 3 | 2 | 1 | 256.76 | 60.91 |
| [`RGL_DrawAllWalls`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawallwalls-function-rgl-drawallwalls-src-r-gl-ml-1397371572) | `src/r_gl.ml:3796` | 16 | 12 | 5 | 5 | 2 | 334.7 | 55.38 |
| [`RGL_DrawBoundaryQuads`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawboundaryquads-function-rgl-drawboundaryquads-src-r-gl-ml-747814676) | `src/r_gl.ml:3514` | 11 | 6 | 3 | 2 | 1 | 154.29 | 61.56 |
| [`RGL_DrawBspFlatNode`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawbspflatnode-function-rgl-drawbspflatnode-bspnum-xs-ys-count-src-r-gl-ml-903855201) | `src/r_gl.ml:5413` | 23 | 28 | 15 | 15 | 2 | 1513.54 | 46.01 |
| [`RGL_DrawBspLeafFlat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawbspleafflat-function-rgl-drawbspleafflat-sidx-xs-ys-count-src-r-gl-ml-1907004210) | `src/r_gl.ml:5315` | 33 | 32 | 16 | 15 | 1 | 1400.07 | 42.69 |
| [`RGL_DrawCachedDepthGeometry`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawcacheddepthgeometry-function-rgl-drawcacheddepthgeometry-src-r-gl-ml-1284808686) | `src/r_gl.ml:4996` | 44 | 36 | 11 | 24 | 4 | 1493.52 | 40.44 |
| [`RGL_DrawCachedFlatTris`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawcachedflattris-function-rgl-drawcachedflattris-src-r-gl-ml-1653402296) | `src/r_gl.ml:4469` | 27 | 28 | 11 | 22 | 4 | 1229.47 | 45.66 |
| [`RGL_DrawCachedTexturedQuads`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawcachedtexturedquads-function-rgl-drawcachedtexturedquads-quads-src-r-gl-ml-1101920040) | `src/r_gl.ml:3461` | 39 | 40 | 15 | 34 | 4 | 1795.73 | 40.49 |
| [`RGL_DrawCachedWorld`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawcachedworld-function-rgl-drawcachedworld-player-yaw-src-r-gl-ml-1828053566) | `src/r_gl.ml:5977` | 8 | 6 | 1 | 0 | 0 | 114.22 | 65.76 |
| [`RGL_DrawDirectWorld`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawdirectworld-function-rgl-drawdirectworld-player-yaw-src-r-gl-ml-1339202860) | `src/r_gl.ml:5990` | 10 | 8 | 1 | 0 | 0 | 144 | 62.94 |
| [`RGL_DrawDynamicLightGlows`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawdynamiclightglows-function-rgl-drawdynamiclightglows-yaw-src-r-gl-ml-1798163245) | `src/r_gl.ml:3023` | 7 | 8 | 5 | 4 | 1 | 326.9 | 63.29 |
| [`RGL_DrawFlatArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawflatarraybatches-function-rgl-drawflatarraybatches-src-r-gl-ml-1573584500) | `src/r_gl.ml:4781` | 33 | 28 | 10 | 13 | 3 | 1071.12 | 44.32 |
| [`RGL_DrawFlatConvexFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawflatconvexfloat-function-rgl-drawflatconvexfloat-xs-ys-count-z-flatnum-src-r-gl-ml-1494969443) | `src/r_gl.ml:4875` | 28 | 28 | 7 | 9 | 2 | 1110.92 | 46.16 |
| [`RGL_DrawFlatDisplayLists`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawflatdisplaylists-function-rgl-drawflatdisplaylists-src-r-gl-ml-401093900) | `src/r_gl.ml:4643` | 13 | 9 | 3 | 2 | 1 | 261.52 | 58.37 |
| [`RGL_DrawFlatPolygonEarClipped`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawflatpolygonearclipped-function-rgl-drawflatpolygonearclipped-pxs-pys-count-zz-textured-src-r-gl-ml-391985259) | `src/r_gl.ml:4156` | 70 | 67 | 28 | 59 | 6 | 3006.88 | 31.63 |
| [`RGL_DrawFlatTriangle`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawflattriangle-function-rgl-drawflattriangle-pxs-pys-a-b-c-zz-textured-src-r-gl-ml-1027386010) | `src/r_gl.ml:4134` | 14 | 15 | 4 | 3 | 1 | 748.08 | 54.34 |
| [`RGL_DrawLine`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawline-function-rgl-drawline-li-src-r-gl-ml-1053938221) | `src/r_gl.ml:3770` | 13 | 13 | 16 | 17 | 2 | 781.38 | 53.29 |
| [`RGL_DrawLineSideMidtexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawlinesidemidtexture-function-rgl-drawlinesidemidtexture-li-sideindex-src-r-gl-ml-1445908602) | `src/r_gl.ml:3860` | 28 | 30 | 23 | 22 | 1 | 1489.26 | 43.12 |
| [`RGL_DrawMaskedArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawmaskedarraybatches-function-rgl-drawmaskedarraybatches-src-r-gl-ml-769463628) | `src/r_gl.ml:4818` | 30 | 23 | 8 | 9 | 2 | 723.59 | 46.68 |
| [`RGL_DrawMaskedMidtexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawmaskedmidtexture-function-rgl-drawmaskedmidtexture-v1-v2-linedef-side-front-back-walloffset-src-r-gl-ml-1181058232) | `src/r_gl.ml:3637` | 9 | 9 | 8 | 7 | 1 | 579.03 | 58.76 |
| [`RGL_DrawMaskedQuads`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawmaskedquads-function-rgl-drawmaskedquads-src-r-gl-ml-1253191374) | `src/r_gl.ml:3528` | 11 | 6 | 3 | 2 | 1 | 154.29 | 61.56 |
| [`RGL_DrawMaskedSeg`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawmaskedseg-function-rgl-drawmaskedseg-sg-src-r-gl-ml-1942098794) | `src/r_gl.ml:3815` | 27 | 30 | 21 | 22 | 2 | 1630.81 | 43.46 |
| [`RGL_DrawOneSpriteBillboard`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawonespritebillboard-function-rgl-drawonespritebillboard-mo-lump-flip-rx-rz-src-r-gl-ml-325179473) | `src/r_gl.ml:5558` | 70 | 65 | 21 | 31 | 3 | 3056.17 | 32.52 |
| [`RGL_DrawPlayerWeapon2D`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawplayerweapon2d-function-rgl-drawplayerweapon2d-player-src-r-gl-ml-988102003) | `src/r_gl.ml:5825` | 44 | 39 | 26 | 61 | 9 | 2218.44 | 37.22 |
| [`RGL_DrawScrollingMaskedArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawscrollingmaskedarraybatches-function-rgl-drawscrollingmaskedarraybatches-src-r-gl-ml-542269598) | `src/r_gl.ml:6809` | 26 | 24 | 8 | 9 | 2 | 720.46 | 48.05 |
| [`RGL_DrawScrollingMaskedWalls`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawscrollingmaskedwalls-function-rgl-drawscrollingmaskedwalls-src-r-gl-ml-479006004) | `src/r_gl.ml:6174` | 23 | 19 | 10 | 13 | 3 | 743.75 | 48.84 |
| [`RGL_DrawScrollingWallArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawscrollingwallarraybatches-function-rgl-drawscrollingwallarraybatches-src-r-gl-ml-178329868) | `src/r_gl.ml:6781` | 26 | 24 | 8 | 9 | 2 | 716.54 | 48.07 |
| [`RGL_DrawScrollingWalls`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawscrollingwalls-function-rgl-drawscrollingwalls-src-r-gl-ml-46892660) | `src/r_gl.ml:6154` | 18 | 16 | 10 | 13 | 3 | 588.83 | 51.88 |
| [`RGL_DrawSeg`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawseg-function-rgl-drawseg-sg-src-r-gl-ml-701020964) | `src/r_gl.ml:3786` | 8 | 8 | 10 | 10 | 2 | 456.34 | 60.33 |
| [`RGL_DrawSky`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawsky-function-rgl-drawsky-yaw-src-r-gl-ml-1831395729) | `src/r_gl.ml:5372` | 28 | 28 | 3 | 2 | 1 | 888.73 | 47.38 |
| [`RGL_DrawSkyConvexFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyconvexfloat-function-rgl-drawskyconvexfloat-xs-ys-count-z-src-r-gl-ml-690982302) | `src/r_gl.ml:4931` | 21 | 21 | 5 | 4 | 1 | 791.62 | 50.19 |
| [`RGL_DrawSkyDepthConvexFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskydepthconvexfloat-function-rgl-drawskydepthconvexfloat-xs-ys-count-z-src-r-gl-ml-621574760) | `src/r_gl.ml:5049` | 24 | 21 | 4 | 3 | 1 | 819.71 | 48.95 |
| [`RGL_DrawSkyInteriorBoundaries`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyinteriorboundaries-function-rgl-drawskyinteriorboundaries-src-r-gl-ml-1212401014) | `src/r_gl.ml:3953` | 13 | 9 | 7 | 9 | 3 | 443.91 | 56.22 |
| [`RGL_DrawSkyInteriorBoundaryLine`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyinteriorboundaryline-function-rgl-drawskyinteriorboundaryline-li-src-r-gl-ml-264292839) | `src/r_gl.ml:3969` | 43 | 43 | 21 | 22 | 2 | 2024.01 | 38.39 |
| [`RGL_DrawSkyInteriorBoundaryLines`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyinteriorboundarylines-function-rgl-drawskyinteriorboundarylines-src-r-gl-ml-1370051924) | `src/r_gl.ml:4019` | 13 | 9 | 7 | 9 | 3 | 443.91 | 56.22 |
| [`RGL_DrawSkyInteriorBoundarySeg`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyinteriorboundaryseg-function-rgl-drawskyinteriorboundaryseg-sg-src-r-gl-ml-1459749470) | `src/r_gl.ml:3911` | 34 | 34 | 12 | 12 | 2 | 1527.2 | 42.68 |
| [`RGL_DrawSkyPortals`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyportals-function-rgl-drawskyportals-src-r-gl-ml-345313520) | `src/r_gl.ml:4086` | 10 | 8 | 3 | 2 | 1 | 220.08 | 61.38 |
| [`RGL_DrawSkyPortalSeg`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyportalseg-function-rgl-drawskyportalseg-sg-src-r-gl-ml-2100016774) | `src/r_gl.ml:4035` | 44 | 43 | 13 | 12 | 1 | 2168.53 | 39.04 |
| [`RGL_DrawSkyVertex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawskyvertex-function-rgl-drawskyvertex-x-y-z-src-r-gl-ml-1094092681) | `src/r_gl.ml:4920` | 5 | 3 | 1 | 0 | 0 | 136 | 69.68 |
| [`RGL_DrawSpriteBillboards`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawspritebillboards-function-rgl-drawspritebillboards-player-yaw-src-r-gl-ml-325254606) | `src/r_gl.ml:5817` | 4 | 3 | 2 | 1 | 1 | 96.21 | 72.71 |
| [`RGL_DrawSpriteBillboardsImmediate`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawspritebillboardsimmediate-function-rgl-drawspritebillboardsimmediate-player-yaw-src-r-gl-ml-1428267494) | `src/r_gl.ml:5771` | 41 | 36 | 13 | 24 | 4 | 1876.6 | 40.15 |
| [`RGL_DrawSpriteBillboardsNative`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawspritebillboardsnative-function-rgl-drawspritebillboardsnative-player-yaw-src-r-gl-ml-2051068390) | `src/r_gl.ml:5713` | 51 | 49 | 20 | 34 | 4 | 2620.82 | 36.13 |
| [`RGL_DrawSpriteQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawspritequad-function-rgl-drawspritequad-x0-y0-x1-y1-z0-z1-flip-src-r-gl-ml-1433168612) | `src/r_gl.ml:5527` | 23 | 19 | 2 | 1 | 1 | 678 | 50.2 |
| [`RGL_DrawStaticArrayBatch`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawstaticarraybatch-function-rgl-drawstaticarraybatch-batch-mode-src-r-gl-ml-706290087) | `src/r_gl.ml:4696` | 19 | 16 | 7 | 6 | 1 | 771.68 | 50.95 |
| [`RGL_DrawStaticWorldDisplayList`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawstaticworlddisplaylist-function-rgl-drawstaticworlddisplaylist-src-r-gl-ml-1039614776) | `src/r_gl.ml:4852` | 15 | 14 | 4 | 5 | 2 | 304.31 | 56.42 |
| [`RGL_DrawSubsectorFlat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawsubsectorflat-function-rgl-drawsubsectorflat-ss-z-flatnum-src-r-gl-ml-1816668069) | `src/r_gl.ml:4240` | 159 | 149 | 50 | 85 | 4 | 7543.75 | 18.1 |
| [`RGL_DrawVolatileFlatArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatileflatarraybatches-function-rgl-drawvolatileflatarraybatches-src-r-gl-ml-1568016068) | `src/r_gl.ml:6680` | 32 | 31 | 11 | 14 | 3 | 1092.68 | 44.41 |
| [`RGL_DrawVolatileFlats`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatileflats-function-rgl-drawvolatileflats-src-r-gl-ml-1712159404) | `src/r_gl.ml:6071` | 35 | 28 | 15 | 18 | 3 | 1231.55 | 42.66 |
| [`RGL_DrawVolatileFlatTemplate`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatileflattemplate-function-rgl-drawvolatileflattemplate-t-src-r-gl-ml-1473995090) | `src/r_gl.ml:6048` | 19 | 19 | 12 | 11 | 1 | 1066.79 | 49.29 |
| [`RGL_DrawVolatileLineMidtextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatilelinemidtextures-function-rgl-drawvolatilelinemidtextures-src-r-gl-ml-353567260) | `src/r_gl.ml:6135` | 17 | 14 | 12 | 14 | 3 | 675.05 | 51.73 |
| [`RGL_DrawVolatileMaskedArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatilemaskedarraybatches-function-rgl-drawvolatilemaskedarraybatches-src-r-gl-ml-569355500) | `src/r_gl.ml:6714` | 27 | 26 | 9 | 10 | 2 | 763.6 | 47.38 |
| [`RGL_DrawVolatileMaskedWalls`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatilemaskedwalls-function-rgl-drawvolatilemaskedwalls-src-r-gl-ml-549080760) | `src/r_gl.ml:6122` | 11 | 10 | 7 | 7 | 2 | 446.25 | 57.79 |
| [`RGL_DrawVolatileMaskedWorld`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatilemaskedworld-function-rgl-drawvolatilemaskedworld-src-r-gl-ml-284833182) | `src/r_gl.ml:6359` | 4 | 3 | 2 | 1 | 1 | 69.19 | 73.71 |
| [`RGL_DrawVolatileOpaqueWorld`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatileopaqueworld-function-rgl-drawvolatileopaqueworld-src-r-gl-ml-1458664690) | `src/r_gl.ml:6353` | 4 | 2 | 1 | 0 | 0 | 33.69 | 76.04 |
| [`RGL_DrawVolatileWallArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatilewallarraybatches-function-rgl-drawvolatilewallarraybatches-src-r-gl-ml-1983986532) | `src/r_gl.ml:6645` | 33 | 32 | 11 | 14 | 3 | 1115.01 | 44.06 |
| [`RGL_DrawVolatileWalls`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawvolatilewalls-function-rgl-drawvolatilewalls-src-r-gl-ml-1289483382) | `src/r_gl.ml:6111` | 9 | 8 | 7 | 7 | 2 | 358.2 | 60.36 |
| [`RGL_DrawWallArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwallarraybatches-function-rgl-drawwallarraybatches-src-r-gl-ml-1760035816) | `src/r_gl.ml:4739` | 38 | 36 | 12 | 19 | 3 | 1318.05 | 42.08 |
| [`RGL_DrawWallDisplayLists`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwalldisplaylists-function-rgl-drawwalldisplaylists-src-r-gl-ml-1281824012) | `src/r_gl.ml:4622` | 18 | 17 | 5 | 6 | 2 | 466.76 | 53.26 |
| [`RGL_DrawWallPiece`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwallpiece-function-rgl-drawwallpiece-v1-v2-linedef-side-front-back-walloffset-src-r-gl-ml-1330420880) | `src/r_gl.ml:3736` | 25 | 24 | 12 | 12 | 2 | 1584.72 | 45.49 |
| [`RGL_DrawWallQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwallquad-function-rgl-drawwallquad-v1-v2-z0-z1-texnum-side-src-r-gl-ml-850309242) | `src/r_gl.ml:3625` | 3 | 1 | 1 | 0 | 0 | 125.64 | 74.76 |
| [`RGL_DrawWallQuadEx`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwallquadex-function-rgl-drawwallquadex-v1-v2-z0-z1-texnum-side-transparent-src-r-gl-ml-2009942782) | `src/r_gl.ml:3602` | 3 | 1 | 1 | 0 | 0 | 176 | 73.73 |
| [`RGL_DrawWallQuadOffset`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwallquadoffset-function-rgl-drawwallquadoffset-v1-v2-z0-z1-texnum-side-walloffset-src-r-gl-ml-2095134599) | `src/r_gl.ml:3614` | 3 | 1 | 1 | 0 | 0 | 176 | 73.73 |
| [`RGL_DrawWallQuadTexMid`](File-src-r-gl-ml-2087530889.md#function-function-rgl-drawwallquadtexmid-function-rgl-drawwallquadtexmid-v1-v2-z0-z1-texnum-side-transparent-texturemid-walloffset-src-r-gl-ml-1981819514) | `src/r_gl.ml:3552` | 41 | 49 | 17 | 17 | 2 | 2241.61 | 39.07 |
| [`RGL_EnableCutoutAlpha`](File-src-r-gl-ml-2087530889.md#function-function-rgl-enablecutoutalpha-function-rgl-enablecutoutalpha-src-r-gl-ml-1850385382) | `src/r_gl.ml:3323` | 4 | 2 | 1 | 0 | 0 | 55.35 | 74.53 |
| [`RGL_EndArrayBatchDraw`](File-src-r-gl-ml-2087530889.md#function-function-rgl-endarraybatchdraw-function-rgl-endarraybatchdraw-src-r-gl-ml-1382185268) | `src/r_gl.ml:4666` | 6 | 4 | 1 | 0 | 0 | 100.38 | 68.88 |
| [`RGL_EndFixedArrayScale`](File-src-r-gl-ml-2087530889.md#function-function-rgl-endfixedarrayscale-function-rgl-endfixedarrayscale-src-r-gl-ml-1508322924) | `src/r_gl.ml:4686` | 6 | 4 | 1 | 0 | 0 | 63.4 | 70.27 |
| [`RGL_EnsureGeometryCache`](File-src-r-gl-ml-2087530889.md#function-function-rgl-ensuregeometrycache-function-rgl-ensuregeometrycache-src-r-gl-ml-1055831944) | `src/r_gl.ml:5948` | 23 | 21 | 6 | 7 | 2 | 861.68 | 48.93 |
| [`RGL_EnsureScrollingArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-ensurescrollingarraybatches-function-rgl-ensurescrollingarraybatches-src-r-gl-ml-439661564) | `src/r_gl.ml:6341` | 10 | 12 | 9 | 8 | 1 | 459.04 | 58.34 |
| [`RGL_EnsureVolatileArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-ensurevolatilearraybatches-function-rgl-ensurevolatilearraybatches-src-r-gl-ml-16087272) | `src/r_gl.ml:6548` | 35 | 33 | 10 | 9 | 1 | 776.95 | 44.73 |
| [`RGL_EnsureVolatileSectorMap`](File-src-r-gl-ml-2087530889.md#function-function-rgl-ensurevolatilesectormap-function-rgl-ensurevolatilesectormap-sigmap-src-r-gl-ml-1031217067) | `src/r_gl.ml:1800` | 9 | 5 | 4 | 3 | 1 | 167.59 | 63.07 |
| [`RGL_EnumIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-enumindex-inline-function-rgl-enumindex-v-limit-src-r-gl-ml-1103489478) | `src/r_gl.ml:2339` | 8 | 6 | 3 | 3 | 2 | 158.12 | 64.5 |
| [`RGL_FallbackStepTexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-fallbacksteptexture-function-rgl-fallbacksteptexture-tex-side-otherside-src-r-gl-ml-1297630379) | `src/r_gl.ml:3716` | 10 | 12 | 6 | 5 | 1 | 343.38 | 59.62 |
| [`RGL_FixedToFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-fixedtofloat-inline-function-rgl-fixedtofloat-v-src-r-gl-ml-1792482099) | `src/r_gl.ml:2312` | 3 | 1 | 1 | 0 | 0 | 39.86 | 78.25 |
| [`RGL_FlatArrayBatchKey`](File-src-r-gl-ml-2087530889.md#function-function-rgl-flatarraybatchkey-function-rgl-flatarraybatchkey-t-src-r-gl-ml-44332692) | `src/r_gl.ml:599` | 5 | 3 | 1 | 0 | 0 | 250.77 | 67.82 |
| [`RGL_FlatNameForNum`](File-src-r-gl-ml-2087530889.md#function-function-rgl-flatnamefornum-function-rgl-flatnamefornum-flatnum-src-r-gl-ml-1182887281) | `src/r_gl.ml:2495` | 7 | 7 | 6 | 5 | 1 | 296.34 | 63.45 |
| [`RGL_FlatSpatialBatchCellKey`](File-src-r-gl-ml-2087530889.md#function-function-rgl-flatspatialbatchcellkey-function-rgl-flatspatialbatchcellkey-x-z-src-r-gl-ml-906344938) | `src/r_gl.ml:577` | 9 | 11 | 5 | 4 | 1 | 442.08 | 59.99 |
| [`RGL_FloatToGeom`](File-src-r-gl-ml-2087530889.md#function-function-rgl-floattogeom-inline-function-rgl-floattogeom-v-src-r-gl-ml-1071501767) | `src/r_gl.ml:1488` | 5 | 5 | 4 | 3 | 1 | 296.34 | 66.91 |
| [`RGL_GeometryCacheByteSize`](File-src-r-gl-ml-2087530889.md#function-function-rgl-geometrycachebytesize-function-rgl-geometrycachebytesize-src-r-gl-ml-1095005710) | `src/r_gl.ml:1811` | 15 | 19 | 7 | 6 | 1 | 634.14 | 53.78 |
| [`RGL_GeomToFloat`](File-src-r-gl-ml-2087530889.md#function-function-rgl-geomtofloat-inline-function-rgl-geomtofloat-v-src-r-gl-ml-1367197795) | `src/r_gl.ml:1496` | 3 | 1 | 1 | 0 | 0 | 39.86 | 78.25 |
| [`RGL_GroupCachedFlatTrisByTexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-groupcachedflattrisbytexture-function-rgl-groupcachedflattrisbytexture-tris-src-r-gl-ml-1412793798) | `src/r_gl.ml:740` | 37 | 30 | 11 | 19 | 4 | 1057.08 | 43.14 |
| [`RGL_GroupCachedQuadsByTexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-groupcachedquadsbytexture-function-rgl-groupcachedquadsbytexture-quads-src-r-gl-ml-1518540832) | `src/r_gl.ml:698` | 38 | 32 | 12 | 22 | 4 | 1135.8 | 42.53 |
| [`RGL_GroupFlatTrisForArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-groupflattrisforarraybatches-function-rgl-groupflattrisforarraybatches-tris-src-r-gl-ml-1761151926) | `src/r_gl.ml:669` | 26 | 21 | 8 | 15 | 4 | 754.81 | 47.91 |
| [`RGL_GroupOpaqueGeometryForBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-groupopaquegeometryforbatches-function-rgl-groupopaquegeometryforbatches-src-r-gl-ml-1760736466) | `src/r_gl.ml:780` | 6 | 4 | 1 | 0 | 0 | 76.11 | 69.72 |
| [`RGL_GroupWallQuadsForArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-groupwallquadsforarraybatches-function-rgl-groupwallquadsforarraybatches-quads-src-r-gl-ml-565545984) | `src/r_gl.ml:640` | 26 | 21 | 8 | 15 | 4 | 754.81 | 47.91 |
| [`RGL_HasActiveSectorMotion`](File-src-r-gl-ml-2087530889.md#function-function-rgl-hasactivesectormotion-function-rgl-hasactivesectormotion-src-r-gl-ml-93025980) | `src/r_gl.ml:2372` | 10 | 9 | 5 | 5 | 2 | 286.62 | 60.31 |
| [`RGL_IsNumber`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isnumber-inline-function-rgl-isnumber-v-src-r-gl-ml-825151071) | `src/r_gl.ml:535` | 3 | 1 | 1 | 0 | 0 | 81.41 | 76.08 |
| [`RGL_IsSeq`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isseq-inline-function-rgl-isseq-v-src-r-gl-ml-513682671) | `src/r_gl.ml:529` | 3 | 1 | 1 | 0 | 0 | 81.41 | 76.08 |
| [`RGL_IsValidFlatTri`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isvalidflattri-inline-function-rgl-isvalidflattri-t-src-r-gl-ml-723324843) | `src/r_gl.ml:541` | 12 | 19 | 19 | 18 | 1 | 1028.59 | 52.81 |
| [`RGL_IsVolatileLineIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isvolatilelineindex-function-rgl-isvolatilelineindex-idx-src-r-gl-ml-1683321463) | `src/r_gl.ml:1683` | 8 | 10 | 7 | 6 | 1 | 340.06 | 61.63 |
| [`RGL_IsVolatileSector`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isvolatilesector-function-rgl-isvolatilesector-sec-src-r-gl-ml-2005993413) | `src/r_gl.ml:1653` | 7 | 8 | 5 | 4 | 1 | 261.52 | 63.97 |
| [`RGL_IsVolatileSegIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isvolatilesegindex-function-rgl-isvolatilesegindex-idx-src-r-gl-ml-77709699) | `src/r_gl.ml:1672` | 8 | 10 | 7 | 6 | 1 | 340.06 | 61.63 |
| [`RGL_IsVolatileSubsectorIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-isvolatilesubsectorindex-function-rgl-isvolatilesubsectorindex-idx-src-r-gl-ml-1881339303) | `src/r_gl.ml:1663` | 6 | 6 | 5 | 4 | 1 | 242.5 | 65.66 |
| [`RGL_LightByte`](File-src-r-gl-ml-2087530889.md#function-function-rgl-lightbyte-inline-function-rgl-lightbyte-sec-src-r-gl-ml-2116814086) | `src/r_gl.ml:2362` | 8 | 9 | 5 | 4 | 1 | 345 | 61.86 |
| [`RGL_LineMayMoveGeometry`](File-src-r-gl-ml-2087530889.md#function-function-rgl-linemaymovegeometry-function-rgl-linemaymovegeometry-li-src-r-gl-ml-1815854389) | `src/r_gl.ml:1621` | 21 | 9 | 8 | 3 | 1 | 2094.88 | 46.83 |
| [`RGL_LineScrollsTexture`](File-src-r-gl-ml-2087530889.md#function-function-rgl-linescrollstexture-inline-function-rgl-linescrollstexture-li-src-r-gl-ml-1682041308) | `src/r_gl.ml:1647` | 3 | 1 | 1 | 0 | 0 | 116.76 | 74.98 |
| [`RGL_LiquidLightKind`](File-src-r-gl-ml-2087530889.md#function-function-rgl-liquidlightkind-function-rgl-liquidlightkind-flatnum-src-r-gl-ml-1708983161) | `src/r_gl.ml:2505` | 9 | 12 | 8 | 7 | 1 | 413.43 | 59.79 |
| [`RGL_LowerTextureMid`](File-src-r-gl-ml-2087530889.md#function-function-rgl-lowertexturemid-function-rgl-lowertexturemid-linedef-texnum-side-front-back-src-r-gl-ml-1497592649) | `src/r_gl.ml:3370` | 8 | 6 | 5 | 4 | 1 | 401.91 | 61.39 |
| [`RGL_LumpNameAt`](File-src-r-gl-ml-2087530889.md#function-function-rgl-lumpnameat-function-rgl-lumpnameat-lumpnum-src-r-gl-ml-16873268) | `src/r_gl.ml:3055` | 7 | 8 | 6 | 5 | 1 | 318.95 | 63.23 |
| [`RGL_MapGeomLumpName`](File-src-r-gl-ml-2087530889.md#function-function-rgl-mapgeomlumpname-function-rgl-mapgeomlumpname-src-r-gl-ml-1913699386) | `src/r_gl.ml:1501` | 16 | 19 | 7 | 9 | 2 | 701.84 | 52.86 |
| [`RGL_MarkVolatileSector`](File-src-r-gl-ml-2087530889.md#function-function-rgl-markvolatilesector-function-rgl-markvolatilesector-sec-src-r-gl-ml-2137363329) | `src/r_gl.ml:1613` | 4 | 3 | 2 | 1 | 1 | 91.38 | 72.87 |
| [`RGL_MarkVolatileSectorIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-markvolatilesectorindex-function-rgl-markvolatilesectorindex-idx-src-r-gl-ml-1655000321) | `src/r_gl.ml:1604` | 5 | 4 | 3 | 2 | 1 | 129.66 | 69.56 |
| [`RGL_MidTextureMid`](File-src-r-gl-ml-2087530889.md#function-function-rgl-midtexturemid-function-rgl-midtexturemid-linedef-texnum-side-front-back-src-r-gl-ml-675030083) | `src/r_gl.ml:3385` | 17 | 14 | 10 | 13 | 3 | 792.44 | 51.52 |
| [`RGL_MidTextureOrZero`](File-src-r-gl-ml-2087530889.md#function-function-rgl-midtextureorzero-inline-function-rgl-midtextureorzero-side-src-r-gl-ml-1896246754) | `src/r_gl.ml:3707` | 4 | 3 | 3 | 2 | 1 | 133.98 | 71.57 |
| [`RGL_MobjDecorLight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-mobjdecorlight-function-rgl-mobjdecorlight-mo-x-z-src-r-gl-ml-1730875410) | `src/r_gl.ml:2608` | 66 | 51 | 20 | 20 | 2 | 3769.88 | 32.58 |
| [`RGL_MobjExplosionLight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-mobjexplosionlight-function-rgl-mobjexplosionlight-mo-x-y-z-src-r-gl-ml-709488215) | `src/r_gl.ml:2682` | 38 | 30 | 13 | 12 | 1 | 1874.87 | 40.87 |
| [`RGL_MobjLight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-mobjlight-function-rgl-mobjlight-mo-src-r-gl-ml-265720384) | `src/r_gl.ml:2727` | 59 | 46 | 27 | 31 | 2 | 3679.29 | 32.77 |
| [`RGL_NormalizeDegrees`](File-src-r-gl-ml-2087530889.md#function-function-rgl-normalizedegrees-function-rgl-normalizedegrees-d-src-r-gl-ml-750737818) | `src/r_gl.ml:2326` | 9 | 5 | 3 | 2 | 1 | 121.11 | 64.19 |
| [`RGL_OppositeSide`](File-src-r-gl-ml-2087530889.md#function-function-rgl-oppositeside-function-rgl-oppositeside-linedef-side-src-r-gl-ml-537716784) | `src/r_gl.ml:3671` | 11 | 15 | 13 | 12 | 1 | 727.51 | 55.5 |
| [`RGL_PackNativeSprite`](File-src-r-gl-ml-2087530889.md#function-function-rgl-packnativesprite-inline-function-rgl-packnativesprite-mo-lump-flip-records-recordindex-src-r-gl-ml-1659369073) | `src/r_gl.ml:5662` | 44 | 46 | 14 | 14 | 2 | 2174.28 | 38.9 |
| [`RGL_PlayerNearActiveSectorMotion`](File-src-r-gl-ml-2087530889.md#function-function-rgl-playernearactivesectormotion-function-rgl-playernearactivesectormotion-player-src-r-gl-ml-41975447) | `src/r_gl.ml:2414` | 13 | 14 | 9 | 9 | 2 | 647.08 | 54.81 |
| [`RGL_PointInTriangle`](File-src-r-gl-ml-2087530889.md#function-function-rgl-pointintriangle-function-rgl-pointintriangle-px-py-ax-ay-bx-by-cx-cy-src-r-gl-ml-324802258) | `src/r_gl.ml:4117` | 8 | 6 | 1 | 0 | 0 | 510.09 | 61.21 |
| [`RGL_ProfileEnd`](File-src-r-gl-ml-2087530889.md#function-function-rgl-profileend-inline-function-rgl-profileend-slot-start-src-r-gl-ml-2099037123) | `src/r_gl.ml:6848` | 8 | 11 | 8 | 7 | 1 | 478.22 | 60.46 |
| [`RGL_ProfileStart`](File-src-r-gl-ml-2087530889.md#function-function-rgl-profilestart-inline-function-rgl-profilestart-src-r-gl-ml-741110349) | `src/r_gl.ml:6837` | 7 | 8 | 5 | 4 | 1 | 293.25 | 63.62 |
| [`RGL_ReadGeomDepthQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-readgeomdepthquad-function-rgl-readgeomdepthquad-buf-off-src-r-gl-ml-1574698482) | `src/r_gl.ml:2060` | 27 | 25 | 1 | 0 | 0 | 1127.05 | 47.27 |
| [`RGL_ReadGeomDepthTri`](File-src-r-gl-ml-2087530889.md#function-function-rgl-readgeomdepthtri-function-rgl-readgeomdepthtri-buf-off-src-r-gl-ml-1079784154) | `src/r_gl.ml:2015` | 21 | 19 | 1 | 0 | 0 | 836.68 | 50.56 |
| [`RGL_ReadGeomFlatTri`](File-src-r-gl-ml-2087530889.md#function-function-rgl-readgeomflattri-function-rgl-readgeomflattri-buf-off-src-r-gl-ml-1913287410) | `src/r_gl.ml:1957` | 37 | 35 | 1 | 0 | 0 | 1607.64 | 43.21 |
| [`RGL_ReadGeomQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-readgeomquad-function-rgl-readgeomquad-buf-off-src-r-gl-ml-1705546974) | `src/r_gl.ml:1877` | 49 | 47 | 1 | 0 | 0 | 2280.95 | 39.48 |
| [`RGL_ReadS32`](File-src-r-gl-ml-2087530889.md#function-function-rgl-reads32-inline-function-rgl-reads32-buf-off-src-r-gl-ml-85703707) | `src/r_gl.ml:1480` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`RGL_ReadU32`](File-src-r-gl-ml-2087530889.md#function-function-rgl-readu32-inline-function-rgl-readu32-buf-off-src-r-gl-ml-789621479) | `src/r_gl.ml:1473` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`RGL_RebuildNativeArrayBatchRecords`](File-src-r-gl-ml-2087530889.md#function-function-rgl-rebuildnativearraybatchrecords-function-rgl-rebuildnativearraybatchrecords-src-r-gl-ml-1577331416) | `src/r_gl.ml:1087` | 75 | 69 | 21 | 30 | 3 | 2468.64 | 32.52 |
| [`RGL_RebuildScrollingArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-rebuildscrollingarraybatches-function-rgl-rebuildscrollingarraybatches-currenttic-currentmap-currentleveltime-src-r-gl-ml-83585002) | `src/r_gl.ml:6239` | 94 | 92 | 1 | 0 | 0 | 1753.19 | 34.11 |
| [`RGL_RebuildVolatileArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-rebuildvolatilearraybatches-function-rgl-rebuildvolatilearraybatches-signature-src-r-gl-ml-1123026004) | `src/r_gl.ml:6436` | 104 | 104 | 3 | 2 | 1 | 2099.32 | 32.34 |
| [`RGL_RenderPlayerView`](File-src-r-gl-ml-2087530889.md#function-function-rgl-renderplayerview-function-rgl-renderplayerview-player-src-r-gl-ml-266226311) | `src/r_gl.ml:6860` | 104 | 111 | 18 | 21 | 2 | 4172.91 | 28.23 |
| [`RGL_ResetScrollingArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-resetscrollingarraybatches-function-rgl-resetscrollingarraybatches-src-r-gl-ml-1809248328) | `src/r_gl.ml:896` | 28 | 26 | 1 | 0 | 0 | 437.47 | 49.81 |
| [`RGL_ResetStaticArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-resetstaticarraybatches-function-rgl-resetstaticarraybatches-src-r-gl-ml-1374214140) | `src/r_gl.ml:927` | 57 | 56 | 16 | 45 | 4 | 1686.66 | 36.95 |
| [`RGL_ResetStaticDisplayLists`](File-src-r-gl-ml-2087530889.md#function-function-rgl-resetstaticdisplaylists-function-rgl-resetstaticdisplaylists-src-r-gl-ml-762068620) | `src/r_gl.ml:828` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`RGL_ResetVolatileArrayBatches`](File-src-r-gl-ml-2087530889.md#function-function-rgl-resetvolatilearraybatches-function-rgl-resetvolatilearraybatches-src-r-gl-ml-733126740) | `src/r_gl.ml:850` | 43 | 41 | 1 | 0 | 0 | 707.84 | 44.28 |
| [`RGL_ResolveFlatNum`](File-src-r-gl-ml-2087530889.md#function-function-rgl-resolveflatnum-inline-function-rgl-resolveflatnum-flatnum-src-r-gl-ml-143244174) | `src/r_gl.ml:3137` | 9 | 8 | 8 | 8 | 2 | 349.77 | 60.3 |
| [`RGL_ResolveTextureNum`](File-src-r-gl-ml-2087530889.md#function-function-rgl-resolvetexturenum-inline-function-rgl-resolvetexturenum-texnum-src-r-gl-ml-478404120) | `src/r_gl.ml:3125` | 9 | 8 | 8 | 8 | 2 | 349.77 | 60.3 |
| [`RGL_Restore3DProjection`](File-src-r-gl-ml-2087530889.md#function-function-rgl-restore3dprojection-function-rgl-restore3dprojection-src-r-gl-ml-1233739036) | `src/r_gl.ml:5351` | 17 | 15 | 5 | 4 | 1 | 509.05 | 53.53 |
| [`RGL_SectorIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sectorindex-function-rgl-sectorindex-sec-src-r-gl-ml-894431153) | `src/r_gl.ml:1592` | 9 | 8 | 5 | 5 | 2 | 261.52 | 61.58 |
| [`RGL_SectorMotionSignature`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sectormotionsignature-function-rgl-sectormotionsignature-src-r-gl-ml-2062079532) | `src/r_gl.ml:1529` | 14 | 13 | 6 | 10 | 3 | 559.09 | 54.95 |
| [`RGL_SectorNearFixedPoint`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sectornearfixedpoint-function-rgl-sectornearfixedpoint-sec-x-y-radius-src-r-gl-ml-854166790) | `src/r_gl.ml:2388` | 23 | 21 | 12 | 22 | 4 | 1022.04 | 47.61 |
| [`RGL_SectorTouchesSkyCeiling`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sectortouchesskyceiling-function-rgl-sectortouchesskyceiling-sec-src-r-gl-ml-1637146975) | `src/r_gl.ml:5078` | 18 | 14 | 11 | 16 | 3 | 653.62 | 51.43 |
| [`RGL_SegTextureOffset`](File-src-r-gl-ml-2087530889.md#function-function-rgl-segtextureoffset-function-rgl-segtextureoffset-sg-opposite-src-r-gl-ml-135481933) | `src/r_gl.ml:3652` | 14 | 17 | 10 | 9 | 1 | 1085.67 | 52.4 |
| [`RGL_SelectSpriteLump`](File-src-r-gl-ml-2087530889.md#function-function-rgl-selectspritelump-function-rgl-selectspritelump-thing-player-src-r-gl-ml-139702549) | `src/r_gl.ml:5498` | 19 | 23 | 12 | 11 | 1 | 1569.89 | 48.11 |
| [`RGL_SeqLen`](File-src-r-gl-ml-2087530889.md#function-function-rgl-seqlen-inline-function-rgl-seqlen-v-src-r-gl-ml-638602229) | `src/r_gl.ml:556` | 4 | 3 | 2 | 1 | 1 | 91.38 | 72.87 |
| [`RGL_SerializeGeometryCache`](File-src-r-gl-ml-2087530889.md#function-function-rgl-serializegeometrycache-function-rgl-serializegeometrycache-sigmap-sigsegs-siglines-signodes-sigsubsectors-sigsectormotion-sigsides-src-r-gl-ml-1966671242) | `src/r_gl.ml:2096` | 67 | 65 | 13 | 12 | 1 | 2662.84 | 34.43 |
| [`RGL_SetForceSoftware`](File-src-r-gl-ml-2087530889.md#function-function-rgl-setforcesoftware-function-rgl-setforcesoftware-v-src-r-gl-ml-997919776) | `src/r_gl.ml:520` | 5 | 4 | 3 | 2 | 1 | 110.36 | 70.05 |
| [`RGL_SetVertexLight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-setvertexlight-function-rgl-setvertexlight-base-x-y-z-src-r-gl-ml-461572574) | `src/r_gl.ml:2925` | 3 | 1 | 1 | 0 | 0 | 89.62 | 75.79 |
| [`RGL_SetVertexLightAlpha`](File-src-r-gl-ml-2087530889.md#function-function-rgl-setvertexlightalpha-function-rgl-setvertexlightalpha-base-x-y-z-alpha-src-r-gl-ml-667489492) | `src/r_gl.ml:2936` | 42 | 37 | 6 | 7 | 2 | 1770.58 | 41.04 |
| [`RGL_SideOrFallback`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sideorfallback-inline-function-rgl-sideorfallback-side-fallback-src-r-gl-ml-1086994988) | `src/r_gl.ml:3686` | 4 | 3 | 2 | 1 | 1 | 85.95 | 73.05 |
| [`RGL_SideRowOffset`](File-src-r-gl-ml-2087530889.md#function-function-rgl-siderowoffset-inline-function-rgl-siderowoffset-side-src-r-gl-ml-1091845348) | `src/r_gl.ml:3335` | 4 | 3 | 3 | 2 | 1 | 133.98 | 71.57 |
| [`RGL_SideTextureSignature`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sidetexturesignature-function-rgl-sidetexturesignature-src-r-gl-ml-1441912300) | `src/r_gl.ml:1546` | 40 | 42 | 15 | 29 | 4 | 1688.16 | 40.44 |
| [`RGL_SkySForPoint`](File-src-r-gl-ml-2087530889.md#function-function-rgl-skysforpoint-function-rgl-skysforpoint-x-y-src-r-gl-ml-708798433) | `src/r_gl.ml:4908` | 7 | 5 | 1 | 0 | 0 | 211.52 | 65.15 |
| [`RGL_SortBatchGroupsByKey`](File-src-r-gl-ml-2087530889.md#function-function-rgl-sortbatchgroupsbykey-function-rgl-sortbatchgroupsbykey-keys-groups-src-r-gl-ml-2038529984) | `src/r_gl.ml:608` | 29 | 26 | 10 | 13 | 3 | 853.04 | 46.23 |
| [`RGL_SpatialBatchCellKey`](File-src-r-gl-ml-2087530889.md#function-function-rgl-spatialbatchcellkey-function-rgl-spatialbatchcellkey-x-z-src-r-gl-ml-660588188) | `src/r_gl.ml:564` | 9 | 11 | 5 | 4 | 1 | 442.08 | 59.99 |
| [`RGL_SpriteEntryForLump`](File-src-r-gl-ml-2087530889.md#function-function-rgl-spriteentryforlump-function-rgl-spriteentryforlump-lump-src-r-gl-ml-291423486) | `src/r_gl.ml:3302` | 7 | 7 | 3 | 2 | 1 | 197.65 | 65.09 |
| [`RGL_SpriteIndex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-spriteindex-inline-function-rgl-spriteindex-v-src-r-gl-ml-1938259567) | `src/r_gl.ml:2350` | 9 | 5 | 3 | 2 | 1 | 199.04 | 62.68 |
| [`RGL_StaticVertexLit`](File-src-r-gl-ml-2087530889.md#function-function-rgl-staticvertexlit-function-rgl-staticvertexlit-base-x-y-z-src-r-gl-ml-1782373992) | `src/r_gl.ml:3036` | 5 | 3 | 1 | 0 | 0 | 148 | 69.42 |
| [`RGL_StringStartsWith`](File-src-r-gl-ml-2087530889.md#function-function-rgl-stringstartswith-function-rgl-stringstartswith-s-prefix-src-r-gl-ml-140844377) | `src/r_gl.ml:2480` | 12 | 12 | 6 | 6 | 2 | 440.92 | 57.14 |
| [`RGL_SyncPaletteRevision`](File-src-r-gl-ml-2087530889.md#function-function-rgl-syncpaletterevision-function-rgl-syncpaletterevision-src-r-gl-ml-271718358) | `src/r_gl.ml:3094` | 27 | 27 | 3 | 2 | 1 | 479.22 | 49.6 |
| [`RGL_TextureHeight`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureheight-function-rgl-textureheight-texnum-src-r-gl-ml-1666060953) | `src/r_gl.ml:3170` | 7 | 7 | 7 | 6 | 1 | 341.84 | 62.88 |
| [`RGL_TextureHeightFixed`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureheightfixed-function-rgl-textureheightfixed-texnum-src-r-gl-ml-438182233) | `src/r_gl.ml:3342` | 4 | 3 | 4 | 3 | 1 | 166.91 | 70.77 |
| [`RGL_TextureIdForFlatnum`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureidforflatnum-function-rgl-textureidforflatnum-flatnum-src-r-gl-ml-1433922361) | `src/r_gl.ml:3227` | 21 | 20 | 8 | 7 | 1 | 726.1 | 50.05 |
| [`RGL_TextureIdForSpriteFuzzLump`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureidforspritefuzzlump-function-rgl-textureidforspritefuzzlump-lump-src-r-gl-ml-929928642) | `src/r_gl.ml:3273` | 26 | 23 | 11 | 10 | 1 | 948.89 | 46.81 |
| [`RGL_TextureIdForSpriteLump`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureidforspritelump-function-rgl-textureidforspritelump-lump-src-r-gl-ml-1137998222) | `src/r_gl.ml:3251` | 19 | 18 | 8 | 7 | 1 | 702.96 | 51.1 |
| [`RGL_TextureIdForTexnum`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureidfortexnum-function-rgl-textureidfortexnum-texnum-src-r-gl-ml-1908960937) | `src/r_gl.ml:3181` | 20 | 19 | 8 | 7 | 1 | 690.22 | 50.66 |
| [`RGL_TextureIdForTexnumTransparent`](File-src-r-gl-ml-2087530889.md#function-function-rgl-textureidfortexnumtransparent-function-rgl-textureidfortexnumtransparent-texnum-src-r-gl-ml-1523274177) | `src/r_gl.ml:3204` | 20 | 19 | 8 | 7 | 1 | 685.77 | 50.68 |
| [`RGL_TextureName`](File-src-r-gl-ml-2087530889.md#function-function-rgl-texturename-function-rgl-texturename-texnum-src-r-gl-ml-2090441065) | `src/r_gl.ml:3149` | 8 | 9 | 6 | 5 | 1 | 333.67 | 61.82 |
| [`RGL_TextureWidth`](File-src-r-gl-ml-2087530889.md#function-function-rgl-texturewidth-function-rgl-texturewidth-texnum-src-r-gl-ml-60440933) | `src/r_gl.ml:3160` | 7 | 7 | 7 | 6 | 1 | 341.84 | 62.88 |
| [`RGL_TopTextureOrZero`](File-src-r-gl-ml-2087530889.md#function-function-rgl-toptextureorzero-inline-function-rgl-toptextureorzero-side-src-r-gl-ml-491048116) | `src/r_gl.ml:3693` | 4 | 3 | 3 | 2 | 1 | 133.98 | 71.57 |
| [`RGL_TryLoadGeometryCache`](File-src-r-gl-ml-2087530889.md#function-function-rgl-tryloadgeometrycache-function-rgl-tryloadgeometrycache-sigmap-sigsegs-siglines-signodes-sigsubsectors-sigsectormotion-sigsides-src-r-gl-ml-1315664590) | `src/r_gl.ml:2176` | 114 | 119 | 29 | 28 | 1 | 4624.65 | 25.57 |
| [`RGL_UpdateFlatNativeRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updateflatnativerecordtextures-function-rgl-updateflatnativerecordtextures-src-r-gl-ml-1983897548) | `src/r_gl.ml:1065` | 19 | 21 | 7 | 6 | 1 | 653.62 | 51.45 |
| [`RGL_UpdateMaskedNativeRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatemaskednativerecordtextures-function-rgl-updatemaskednativerecordtextures-src-r-gl-ml-1160759516) | `src/r_gl.ml:1044` | 18 | 20 | 7 | 6 | 1 | 633.31 | 52.06 |
| [`RGL_UpdateScrollingMaskedRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatescrollingmaskedrecordtextures-function-rgl-updatescrollingmaskedrecordtextures-src-r-gl-ml-1417254384) | `src/r_gl.ml:6762` | 17 | 18 | 6 | 5 | 1 | 542.84 | 53.2 |
| [`RGL_UpdateScrollingWallRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatescrollingwallrecordtextures-function-rgl-updatescrollingwallrecordtextures-src-r-gl-ml-427328702) | `src/r_gl.ml:6743` | 17 | 18 | 6 | 5 | 1 | 542.84 | 53.2 |
| [`RGL_UpdateVolatileFlatRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatevolatileflatrecordtextures-function-rgl-updatevolatileflatrecordtextures-src-r-gl-ml-1123781048) | `src/r_gl.ml:6607` | 17 | 18 | 6 | 5 | 1 | 542.84 | 53.2 |
| [`RGL_UpdateVolatileMaskedRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatevolatilemaskedrecordtextures-function-rgl-updatevolatilemaskedrecordtextures-src-r-gl-ml-1460939336) | `src/r_gl.ml:6626` | 17 | 18 | 6 | 5 | 1 | 542.84 | 53.2 |
| [`RGL_UpdateVolatileWallRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatevolatilewallrecordtextures-function-rgl-updatevolatilewallrecordtextures-src-r-gl-ml-1383996996) | `src/r_gl.ml:6587` | 18 | 19 | 6 | 5 | 1 | 562.54 | 52.55 |
| [`RGL_UpdateWallNativeRecordTextures`](File-src-r-gl-ml-2087530889.md#function-function-rgl-updatewallnativerecordtextures-function-rgl-updatewallnativerecordtextures-src-r-gl-ml-572668884) | `src/r_gl.ml:1021` | 20 | 23 | 8 | 8 | 2 | 743.4 | 50.44 |
| [`RGL_UpperTextureMid`](File-src-r-gl-ml-2087530889.md#function-function-rgl-uppertexturemid-function-rgl-uppertexturemid-linedef-texnum-side-front-back-src-r-gl-ml-990365755) | `src/r_gl.ml:3354` | 8 | 6 | 5 | 4 | 1 | 398.51 | 61.42 |
| [`RGL_Vertex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-vertex-inline-function-rgl-vertex-v-z-src-r-gl-ml-2128096507) | `src/r_gl.ml:3045` | 7 | 6 | 2 | 1 | 1 | 230.7 | 64.75 |
| [`RGL_VertexLit`](File-src-r-gl-ml-2087530889.md#function-function-rgl-vertexlit-function-rgl-vertexlit-base-x-y-z-src-r-gl-ml-203569652) | `src/r_gl.ml:2989` | 4 | 2 | 1 | 0 | 0 | 111.13 | 72.41 |
| [`RGL_VolatileGeometrySignature`](File-src-r-gl-ml-2087530889.md#function-function-rgl-volatilegeometrysignature-function-rgl-volatilegeometrysignature-src-r-gl-ml-643476492) | `src/r_gl.ml:6365` | 29 | 21 | 10 | 15 | 3 | 1088.14 | 45.49 |
| [`RGL_WallArrayBatchKey`](File-src-r-gl-ml-2087530889.md#function-function-rgl-wallarraybatchkey-function-rgl-wallarraybatchkey-q-src-r-gl-ml-408571291) | `src/r_gl.ml:589` | 7 | 6 | 2 | 1 | 1 | 381.47 | 63.22 |
| [`RGL_WriteGeomArrayVertex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeomarrayvertex-function-rgl-writegeomarrayvertex-vertices-voff-texcoords-toff-colors-coff-x-y-z-s-t-light-src-r-gl-ml-234467082) | `src/r_gl.ml:1179` | 12 | 10 | 1 | 0 | 0 | 630 | 56.72 |
| [`RGL_WriteGeomDepthQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeomdepthquad-function-rgl-writegeomdepthquad-buf-off-q-src-r-gl-ml-1032839545) | `src/r_gl.ml:2041` | 15 | 13 | 1 | 0 | 0 | 729.09 | 54.17 |
| [`RGL_WriteGeomDepthTri`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeomdepthtri-function-rgl-writegeomdepthtri-buf-off-t-src-r-gl-ml-419706222) | `src/r_gl.ml:1999` | 12 | 10 | 1 | 0 | 0 | 539.59 | 57.19 |
| [`RGL_WriteGeomFixed`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeomfixed-function-rgl-writegeomfixed-buf-off-v-src-r-gl-ml-539627646) | `src/r_gl.ml:1831` | 4 | 2 | 1 | 0 | 0 | 98.99 | 72.76 |
| [`RGL_WriteGeomFlatTri`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeomflattri-function-rgl-writegeomflattri-buf-off-t-src-r-gl-ml-1101591976) | `src/r_gl.ml:1931` | 22 | 20 | 1 | 0 | 0 | 1124.9 | 49.22 |
| [`RGL_WriteGeomInterleavedVertex`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeominterleavedvertex-function-rgl-writegeominterleavedvertex-buf-off-x-y-z-s-t-light-src-r-gl-ml-153265930) | `src/r_gl.ml:1201` | 12 | 10 | 1 | 0 | 0 | 604.41 | 56.85 |
| [`RGL_WriteGeomQuad`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writegeomquad-function-rgl-writegeomquad-buf-off-q-src-r-gl-ml-1119557941) | `src/r_gl.ml:1840` | 33 | 29 | 2 | 1 | 1 | 1703.34 | 43.98 |
| [`RGL_WriteNativeBatchRecord`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writenativebatchrecord-function-rgl-writenativebatchrecord-records-index-texid-batch-flags-src-r-gl-ml-541804941) | `src/r_gl.ml:1009` | 10 | 8 | 1 | 0 | 0 | 530.1 | 58.98 |
| [`RGL_WriteS32`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writes32-inline-function-rgl-writes32-buf-off-value-src-r-gl-ml-243072716) | `src/r_gl.ml:1466` | 3 | 1 | 1 | 0 | 0 | 69.19 | 76.57 |
| [`RGL_WriteU32`](File-src-r-gl-ml-2087530889.md#function-function-rgl-writeu32-inline-function-rgl-writeu32-buf-off-value-src-r-gl-ml-88615096) | `src/r_gl.ml:1453` | 8 | 7 | 2 | 1 | 1 | 374.06 | 62.02 |
| [`RH_Buffer`](File-src-r-hires-ml-694005807.md#function-function-rh-buffer-inline-function-rh-buffer-src-r-hires-ml-2056561155) | `src/r_hires.ml:99` | 3 | 1 | 1 | 0 | 0 | 27 | 79.44 |
| [`RH_Clear`](File-src-r-hires-ml-694005807.md#function-function-rh-clear-function-rh-clear-color-src-r-hires-ml-1697743521) | `src/r_hires.ml:64` | 5 | 5 | 3 | 2 | 1 | 161.42 | 68.89 |
| [`RH_Height`](File-src-r-hires-ml-694005807.md#function-function-rh-height-inline-function-rh-height-src-r-hires-ml-2077857159) | `src/r_hires.ml:93` | 4 | 3 | 2 | 1 | 1 | 64.53 | 73.93 |
| [`RH_Init`](File-src-r-hires-ml-694005807.md#function-function-rh-init-function-rh-init-src-r-hires-ml-885702466) | `src/r_hires.ml:38` | 21 | 21 | 6 | 5 | 1 | 524.62 | 51.31 |
| [`RH_IsActive`](File-src-r-hires-ml-694005807.md#function-function-rh-isactive-inline-function-rh-isactive-src-r-hires-ml-1064611939) | `src/r_hires.ml:81` | 4 | 3 | 2 | 1 | 1 | 131.69 | 71.76 |
| [`RH_SetForceLogical`](File-src-r-hires-ml-694005807.md#function-function-rh-setforcelogical-function-rh-setforcelogical-v-src-r-hires-ml-391453872) | `src/r_hires.ml:73` | 5 | 4 | 3 | 2 | 1 | 110.36 | 70.05 |
| [`RH_Width`](File-src-r-hires-ml-694005807.md#function-function-rh-width-inline-function-rh-width-src-r-hires-ml-1000581903) | `src/r_hires.ml:87` | 4 | 3 | 2 | 1 | 1 | 64.53 | 73.93 |
| [`RU_ArgValue`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-argvalue-function-ru-argvalue-flag-src-r-upscaled-ml-1999963472) | `src/r_upscaled.ml:159` | 8 | 9 | 5 | 4 | 1 | 301.19 | 62.27 |
| [`RU_ClampScale`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-clampscale-inline-function-ru-clampscale-v-src-r-upscaled-ml-627193647) | `src/r_upscaled.ml:116` | 6 | 6 | 3 | 2 | 1 | 158.46 | 67.22 |
| [`RU_FindEntry`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-findentry-function-ru-findentry-kind-name-src-r-upscaled-ml-545799495) | `src/r_upscaled.ml:330` | 11 | 10 | 6 | 6 | 2 | 360 | 58.58 |
| [`RU_FindPackagePath`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-findpackagepath-function-ru-findpackagepath-iwadpath-src-r-upscaled-ml-1233288558) | `src/r_upscaled.ml:182` | 22 | 24 | 16 | 23 | 4 | 1029.93 | 47.47 |
| [`RU_GetFlat`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-getflat-inline-function-ru-getflat-name-src-r-upscaled-ml-1266854740) | `src/r_upscaled.ml:344` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`RU_GetPatch`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-getpatch-inline-function-ru-getpatch-name-src-r-upscaled-ml-1844364192) | `src/r_upscaled.ml:356` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`RU_GetSprite`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-getsprite-inline-function-ru-getsprite-name-src-r-upscaled-ml-1909785828) | `src/r_upscaled.ml:362` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`RU_GetTexture`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-gettexture-inline-function-ru-gettexture-name-src-r-upscaled-ml-488835972) | `src/r_upscaled.ml:350` | 3 | 1 | 1 | 0 | 0 | 51.89 | 77.45 |
| [`RU_Init`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-init-function-ru-init-iwadpath-src-r-upscaled-ml-89798750) | `src/r_upscaled.ml:302` | 9 | 5 | 3 | 2 | 1 | 176.42 | 63.05 |
| [`RU_IsEnabled`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-isenabled-inline-function-ru-isenabled-src-r-upscaled-ml-721439529) | `src/r_upscaled.ml:323` | 3 | 1 | 1 | 0 | 0 | 43.19 | 78.01 |
| [`RU_LoadPackage`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-loadpackage-function-ru-loadpackage-path-src-r-upscaled-ml-1494735865) | `src/r_upscaled.ml:270` | 24 | 22 | 7 | 6 | 1 | 694.56 | 49.05 |
| [`RU_Name8`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-name8-function-ru-name8-name-src-r-upscaled-ml-1101300453) | `src/r_upscaled.ml:139` | 17 | 18 | 6 | 6 | 2 | 588.67 | 52.96 |
| [`RU_ParsePackage`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-parsepackage-function-ru-parsepackage-data-src-r-upscaled-ml-1772490218) | `src/r_upscaled.ml:210` | 50 | 48 | 22 | 23 | 2 | 2512.98 | 36.17 |
| [`RU_ParseScaleFromArgs`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-parsescalefromargs-function-ru-parsescalefromargs-src-r-upscaled-ml-664832604) | `src/r_upscaled.ml:169` | 9 | 5 | 6 | 6 | 2 | 248.8 | 61.6 |
| [`RU_ReadS32`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-reads32-inline-function-ru-reads32-b-off-src-r-upscaled-ml-104177550) | `src/r_upscaled.ml:90` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`RU_ReadU32`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-readu32-inline-function-ru-readu32-b-off-src-r-upscaled-ml-76711962) | `src/r_upscaled.ml:83` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`RU_RendererAllowsHD`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-rendererallowshd-inline-function-ru-rendererallowshd-src-r-upscaled-ml-40788577) | `src/r_upscaled.ml:318` | 3 | 1 | 1 | 0 | 0 | 33 | 78.82 |
| [`RU_RenderScale`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-renderscale-inline-function-ru-renderscale-src-r-upscaled-ml-628220563) | `src/r_upscaled.ml:313` | 3 | 1 | 1 | 0 | 0 | 27 | 79.44 |
| [`RU_ToIntOr`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-tointor-function-ru-tointor-v-fallback-src-r-upscaled-ml-1535545758) | `src/r_upscaled.ml:99` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`RU_ToUpperAscii`](File-src-r-upscaled-ml-1801241933.md#function-function-ru-toupperascii-function-ru-toupperascii-s-src-r-upscaled-ml-1440674053) | `src/r_upscaled.ml:125` | 11 | 10 | 5 | 5 | 2 | 366.3 | 58.66 |
| [`S_AdjustSoundParams`](File-src-s-sound-ml-1485495390.md#function-function-s-adjustsoundparams-function-s-adjustsoundparams-listener-source-vol-sep-pitch-src-s-sound-ml-549454435) | `src/s_sound.ml:846` | 53 | 48 | 25 | 27 | 2 | 2920.73 | 34.76 |
| [`S_ChangeMusic`](File-src-s-sound-ml-1485495390.md#function-function-s-changemusic-function-s-changemusic-music-id-looping-src-s-sound-ml-322855176) | `src/s_sound.ml:960` | 47 | 49 | 23 | 24 | 2 | 2027.13 | 37.28 |
| [`S_getChannel`](File-src-s-sound-ml-1485495390.md#function-function-s-getchannel-function-s-getchannel-origin-sfxinfo-src-s-sound-ml-1594929490) | `src/s_sound.ml:912` | 33 | 24 | 11 | 15 | 3 | 940.8 | 44.58 |
| [`S_Init`](File-src-s-sound-ml-1485495390.md#function-function-s-init-function-s-init-sfxvolume-musicvolume-src-s-sound-ml-1521484207) | `src/s_sound.ml:548` | 40 | 35 | 9 | 13 | 3 | 1178.89 | 42.34 |
| [`S_MPSendPickupSoundToPlayer`](File-src-s-sound-ml-1485495390.md#function-function-s-mpsendpickupsoundtoplayer-function-s-mpsendpickupsoundtoplayer-playerslot-sound-id-src-s-sound-ml-1233481429) | `src/s_sound.ml:512` | 8 | 9 | 6 | 5 | 1 | 375 | 61.47 |
| [`S_NetRecvPacket`](File-src-s-sound-ml-1485495390.md#function-function-s-netrecvpacket-function-s-netrecvpacket-payload-src-s-sound-ml-1226399475) | `src/s_sound.ml:523` | 17 | 17 | 8 | 7 | 1 | 973.75 | 51.16 |
| [`S_PauseSound`](File-src-s-sound-ml-1485495390.md#function-function-s-pausesound-function-s-pausesound-src-s-sound-ml-393028293) | `src/s_sound.ml:1062` | 7 | 4 | 4 | 3 | 1 | 185.75 | 65.14 |
| [`S_PrecacheLevelAudio`](File-src-s-sound-ml-1485495390.md#function-function-s-precachelevelaudio-function-s-precachelevelaudio-src-s-sound-ml-2047139985) | `src/s_sound.ml:654` | 30 | 25 | 15 | 23 | 3 | 1242.96 | 44.09 |
| [`S_ResumeSound`](File-src-s-sound-ml-1485495390.md#function-function-s-resumesound-function-s-resumesound-src-s-sound-ml-1362018613) | `src/s_sound.ml:1072` | 7 | 4 | 4 | 3 | 1 | 181.11 | 65.22 |
| [`S_SetMusicVolume`](File-src-s-sound-ml-1485495390.md#function-function-s-setmusicvolume-function-s-setmusicvolume-volume-src-s-sound-ml-197098267) | `src/s_sound.ml:1146` | 8 | 5 | 2 | 1 | 1 | 180.09 | 64.24 |
| [`S_SetSfxVolume`](File-src-s-sound-ml-1485495390.md#function-function-s-setsfxvolume-function-s-setsfxvolume-volume-src-s-sound-ml-1453364991) | `src/s_sound.ml:1159` | 8 | 5 | 2 | 1 | 1 | 180.09 | 64.24 |
| [`S_Start`](File-src-s-sound-ml-1485495390.md#function-function-s-start-function-s-start-src-s-sound-ml-2127533509) | `src/s_sound.ml:596` | 49 | 32 | 11 | 13 | 2 | 1751.72 | 38.94 |
| [`S_StartMusic`](File-src-s-sound-ml-1485495390.md#function-function-s-startmusic-function-s-startmusic-music-id-src-s-sound-ml-1650381272) | `src/s_sound.ml:952` | 3 | 1 | 1 | 0 | 0 | 41.21 | 78.15 |
| [`S_StartSound`](File-src-s-sound-ml-1485495390.md#function-function-s-startsound-function-s-startsound-origin-sound-id-src-s-sound-ml-870392446) | `src/s_sound.ml:694` | 3 | 1 | 1 | 0 | 0 | 56.47 | 77.19 |
| [`S_StartSoundAtVolume`](File-src-s-sound-ml-1485495390.md#function-function-s-startsoundatvolume-function-s-startsoundatvolume-origin-p-sfx-id-volume-src-s-sound-ml-630858307) | `src/s_sound.ml:703` | 74 | 70 | 28 | 33 | 2 | 3635.38 | 30.53 |
| [`S_StopChannel`](File-src-s-sound-ml-1485495390.md#function-function-s-stopchannel-function-s-stopchannel-cnum-src-s-sound-ml-38265896) | `src/s_sound.ml:817` | 17 | 13 | 9 | 9 | 2 | 655.39 | 52.23 |
| [`S_StopMusic`](File-src-s-sound-ml-1485495390.md#function-function-s-stopmusic-function-s-stopmusic-src-s-sound-ml-1567617527) | `src/s_sound.ml:1019` | 35 | 30 | 18 | 18 | 2 | 1373.81 | 41.92 |
| [`S_StopSound`](File-src-s-sound-ml-1485495390.md#function-function-s-stopsound-function-s-stopsound-origin-src-s-sound-ml-636591881) | `src/s_sound.ml:801` | 12 | 8 | 5 | 5 | 2 | 289.51 | 58.55 |
| [`S_UpdateSounds`](File-src-s-sound-ml-1485495390.md#function-function-s-updatesounds-function-s-updatesounds-listener-p-src-s-sound-ml-1885139350) | `src/s_sound.ml:1083` | 54 | 41 | 20 | 47 | 5 | 1964.43 | 36.46 |
| [`SHORT`](File-src-m-swap-ml-1401834276.md#function-function-short-function-short-x-src-m-swap-ml-1513256323) | `src/m_swap.ml:44` | 4 | 3 | 2 | 1 | 1 | 65.73 | 73.87 |
| [`SlopeDiv`](File-src-tables-ml-1959718242.md#function-function-slopediv-function-slopediv-num-den-src-tables-ml-1863100150) | `src/tables.ml:65` | 22 | 16 | 5 | 4 | 1 | 519.54 | 51.03 |
| [`ST_calcPainOffset`](File-src-st-stuff-ml-811030939.md#function-function-st-calcpainoffset-function-st-calcpainoffset-src-st-stuff-ml-77405746) | `src/st_stuff.ml:652` | 13 | 13 | 5 | 4 | 1 | 377.83 | 56.98 |
| [`ST_createWidgets`](File-src-st-stuff-ml-811030939.md#function-function-st-createwidgets-function-st-createwidgets-src-st-stuff-ml-1644037126) | `src/st_stuff.ml:1172` | 33 | 28 | 3 | 3 | 2 | 2787.14 | 42.35 |
| [`ST_diffDraw`](File-src-st-stuff-ml-811030939.md#function-function-st-diffdraw-function-st-diffdraw-src-st-stuff-ml-938534284) | `src/st_stuff.ml:1001` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`ST_doPaletteStuff`](File-src-st-stuff-ml-811030939.md#function-function-st-dopalettestuff-function-st-dopalettestuff-src-st-stuff-ml-1488779158) | `src/st_stuff.ml:888` | 40 | 34 | 18 | 28 | 4 | 1710.64 | 39.99 |
| [`ST_doRefresh`](File-src-st-stuff-ml-811030939.md#function-function-st-dorefresh-function-st-dorefresh-src-st-stuff-ml-432325286) | `src/st_stuff.ml:993` | 6 | 4 | 1 | 0 | 0 | 64.53 | 70.22 |
| [`ST_Drawer`](File-src-st-stuff-ml-811030939.md#function-function-st-drawer-function-st-drawer-fullscreen-refresh-src-st-stuff-ml-68389006) | `src/st_stuff.ml:1429` | 17 | 13 | 4 | 3 | 1 | 350 | 54.81 |
| [`ST_drawWidgets`](File-src-st-stuff-ml-811030939.md#function-function-st-drawwidgets-function-st-drawwidgets-refresh-src-st-stuff-ml-307986157) | `src/st_stuff.ml:956` | 27 | 23 | 5 | 4 | 1 | 873.51 | 47.51 |
| [`ST_ForceRefresh`](File-src-st-stuff-ml-811030939.md#function-function-st-forcerefresh-function-st-forcerefresh-src-st-stuff-ml-201583414) | `src/st_stuff.ml:1419` | 4 | 2 | 1 | 0 | 0 | 34.87 | 75.93 |
| [`ST_Init`](File-src-st-stuff-ml-811030939.md#function-function-st-init-function-st-init-src-st-stuff-ml-2053265042) | `src/st_stuff.ml:1451` | 10 | 6 | 4 | 4 | 2 | 279.69 | 60.52 |
| [`ST_initData`](File-src-st-stuff-ml-811030939.md#function-function-st-initdata-function-st-initdata-src-st-stuff-ml-91352570) | `src/st_stuff.ml:1114` | 49 | 45 | 3 | 2 | 1 | 937.66 | 41.92 |
| [`ST_loadData`](File-src-st-stuff-ml-811030939.md#function-function-st-loaddata-function-st-loaddata-src-st-stuff-ml-1753217774) | `src/st_stuff.ml:1073` | 9 | 5 | 2 | 1 | 1 | 135.93 | 63.98 |
| [`ST_loadGraphics`](File-src-st-stuff-ml-811030939.md#function-function-st-loadgraphics-function-st-loadgraphics-src-st-stuff-ml-112509780) | `src/st_stuff.ml:1006` | 57 | 43 | 9 | 9 | 2 | 2843.65 | 36.3 |
| [`ST_refreshBackground`](File-src-st-stuff-ml-811030939.md#function-function-st-refreshbackground-function-st-refreshbackground-src-st-stuff-ml-628960942) | `src/st_stuff.ml:935` | 17 | 13 | 9 | 9 | 2 | 692.45 | 52.06 |
| [`ST_Responder`](File-src-st-stuff-ml-811030939.md#function-function-st-responder-function-st-responder-ev-src-st-stuff-ml-960601707) | `src/st_stuff.ml:1251` | 151 | 124 | 68 | 198 | 6 | 7786.54 | 16.07 |
| [`ST_Start`](File-src-st-stuff-ml-811030939.md#function-function-st-start-function-st-start-src-st-stuff-ml-255929498) | `src/st_stuff.ml:1216` | 12 | 10 | 3 | 2 | 1 | 169.92 | 60.44 |
| [`ST_Stop`](File-src-st-stuff-ml-811030939.md#function-function-st-stop-function-st-stop-src-st-stuff-ml-2126394670) | `src/st_stuff.ml:1233` | 13 | 10 | 5 | 5 | 2 | 320.63 | 57.48 |
| [`ST_Ticker`](File-src-st-stuff-ml-811030939.md#function-function-st-ticker-function-st-ticker-src-st-stuff-ml-1986405426) | `src/st_stuff.ml:874` | 10 | 10 | 3 | 2 | 1 | 237.74 | 61.15 |
| [`ST_unloadData`](File-src-st-stuff-ml-811030939.md#function-function-st-unloaddata-function-st-unloaddata-src-st-stuff-ml-1461794516) | `src/st_stuff.ml:1109` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`ST_unloadGraphics`](File-src-st-stuff-ml-811030939.md#function-function-st-unloadgraphics-function-st-unloadgraphics-src-st-stuff-ml-622582606) | `src/st_stuff.ml:1084` | 23 | 20 | 2 | 1 | 1 | 351.86 | 52.2 |
| [`ST_updateFaceWidget`](File-src-st-stuff-ml-811030939.md#function-function-st-updatefacewidget-function-st-updatefacewidget-src-st-stuff-ml-475121390) | `src/st_stuff.ml:670` | 112 | 82 | 33 | 69 | 4 | 3762.33 | 25.82 |
| [`ST_updateWidgets`](File-src-st-stuff-ml-811030939.md#function-function-st-updatewidgets-function-st-updatewidgets-src-st-stuff-ml-542107790) | `src/st_stuff.ml:798` | 64 | 53 | 18 | 25 | 3 | 2451.31 | 34.45 |
| [`STlib_drawBinIcon`](File-src-st-lib-ml-1845497584.md#function-function-stlib-drawbinicon-function-stlib-drawbinicon-b-refresh-src-st-lib-ml-1194160832) | `src/st_lib.ml:498` | 22 | 17 | 8 | 15 | 4 | 851.92 | 49.12 |
| [`STlib_drawMultIcon`](File-src-st-lib-ml-1845497584.md#function-function-stlib-drawmulticon-function-stlib-drawmulticon-i-refresh-src-st-lib-ml-1228763299) | `src/st_lib.ml:449` | 27 | 21 | 11 | 27 | 6 | 1123.13 | 45.94 |
| [`STlib_drawNum`](File-src-st-lib-ml-1845497584.md#function-function-stlib-drawnum-function-stlib-drawnum-n-refresh-src-st-lib-ml-1411732168) | `src/st_lib.ml:345` | 48 | 41 | 20 | 23 | 2 | 1928.16 | 37.63 |
| [`STlib_drawPercent`](File-src-st-lib-ml-1845497584.md#function-function-stlib-drawpercent-function-stlib-drawpercent-p-refresh-src-st-lib-ml-668209940) | `src/st_lib.ml:421` | 7 | 5 | 5 | 4 | 1 | 310.23 | 63.45 |
| [`STlib_init`](File-src-st-lib-ml-1845497584.md#function-function-stlib-init-function-stlib-init-src-st-lib-ml-1340308009) | `src/st_lib.ml:313` | 8 | 5 | 3 | 2 | 1 | 197.15 | 63.83 |
| [`STlib_initBinIcon`](File-src-st-lib-ml-1845497584.md#function-function-stlib-initbinicon-function-stlib-initbinicon-b-x-y-patch-val-on-src-st-lib-ml-149681206) | `src/st_lib.ml:486` | 8 | 6 | 1 | 0 | 0 | 192.11 | 64.18 |
| [`STlib_initMultIcon`](File-src-st-lib-ml-1845497584.md#function-function-stlib-initmulticon-function-stlib-initmulticon-i-x-y-il-inum-on-src-st-lib-ml-812863844) | `src/st_lib.ml:437` | 8 | 6 | 1 | 0 | 0 | 200.16 | 64.05 |
| [`STlib_initNum`](File-src-st-lib-ml-1845497584.md#function-function-stlib-initnum-function-stlib-initnum-n-x-y-pl-num-on-width-src-st-lib-ml-1645784195) | `src/st_lib.ml:331` | 9 | 7 | 1 | 0 | 0 | 225.18 | 62.58 |
| [`STlib_initPercent`](File-src-st-lib-ml-1845497584.md#function-function-stlib-initpercent-function-stlib-initpercent-p-x-y-pl-num-on-percentpatch-src-st-lib-ml-954277086) | `src/st_lib.ml:412` | 5 | 3 | 1 | 0 | 0 | 276.6 | 67.52 |
| [`STlib_RegisterPatchName`](File-src-st-lib-ml-1845497584.md#function-function-stlib-registerpatchname-function-stlib-registerpatchname-patch-name-src-st-lib-ml-1995345510) | `src/st_lib.ml:142` | 14 | 11 | 7 | 7 | 2 | 413.64 | 55.74 |
| [`STlib_updateBinIcon`](File-src-st-lib-ml-1845497584.md#function-function-stlib-updatebinicon-function-stlib-updatebinicon-b-refresh-src-st-lib-ml-1747133694) | `src/st_lib.ml:548` | 3 | 1 | 1 | 0 | 0 | 47.55 | 77.71 |
| [`STlib_updateMultIcon`](File-src-st-lib-ml-1845497584.md#function-function-stlib-updatemulticon-function-stlib-updatemulticon-i-refresh-src-st-lib-ml-1931806075) | `src/st_lib.ml:541` | 3 | 1 | 1 | 0 | 0 | 47.55 | 77.71 |
| [`STlib_updateNum`](File-src-st-lib-ml-1845497584.md#function-function-stlib-updatenum-function-stlib-updatenum-n-refresh-src-st-lib-ml-1236166050) | `src/st_lib.ml:527` | 3 | 2 | 2 | 1 | 1 | 95.18 | 75.47 |
| [`STlib_updatePercent`](File-src-st-lib-ml-1845497584.md#function-function-stlib-updatepercent-function-stlib-updatepercent-p-refresh-src-st-lib-ml-438824462) | `src/st_lib.ml:534` | 3 | 1 | 1 | 0 | 0 | 47.55 | 77.71 |
| [`strupr`](File-src-w-wad-ml-893006035.md#function-function-strupr-inline-function-strupr-s-src-w-wad-ml-1027916704) | `src/w_wad.ml:140` | 3 | 1 | 1 | 0 | 0 | 41.21 | 78.15 |
| [`SwapLONG`](File-src-m-swap-ml-1401834276.md#function-function-swaplong-function-swaplong-x-src-m-swap-ml-913315623) | `src/m_swap.ml:34` | 7 | 2 | 1 | 0 | 0 | 224.74 | 64.96 |
| [`SwapSHORT`](File-src-m-swap-ml-1401834276.md#function-function-swapshort-function-swapshort-x-src-m-swap-ml-598909929) | `src/m_swap.ml:27` | 4 | 2 | 1 | 0 | 0 | 130.8 | 71.91 |
| [`T_FireFlicker`](File-src-p-lights-ml-1710096069.md#function-function-t-fireflicker-function-t-fireflicker-flick-src-p-lights-ml-1836652873) | `src/p_lights.ml:46` | 15 | 13 | 6 | 5 | 1 | 497.54 | 54.65 |
| [`T_Glow`](File-src-p-lights-ml-1710096069.md#function-function-t-glow-function-t-glow-g-src-p-lights-ml-1167778181) | `src/p_lights.ml:226` | 16 | 11 | 6 | 7 | 2 | 538.42 | 53.8 |
| [`T_LightFlash`](File-src-p-lights-ml-1710096069.md#function-function-t-lightflash-function-t-lightflash-flash-src-p-lights-ml-1339578852) | `src/p_lights.ml:82` | 16 | 14 | 7 | 8 | 2 | 680 | 52.96 |
| [`T_MoveCeiling`](File-src-p-ceilng-ml-226654252.md#function-function-t-moveceiling-function-t-moveceiling-ceiling-src-p-ceilng-ml-66760340) | `src/p_ceilng.ml:138` | 25 | 17 | 15 | 26 | 4 | 1148.56 | 46.06 |
| [`T_MoveFloor`](File-src-p-floor-ml-1999892698.md#function-function-t-movefloor-function-t-movefloor-floor-src-p-floor-ml-1183940481) | `src/p_floor.ml:203` | 34 | 17 | 10 | 16 | 3 | 1105.89 | 43.94 |
| [`T_MovePlane`](File-src-p-floor-ml-1999892698.md#function-function-t-moveplane-function-t-moveplane-sector-speed-dest-crush-floororceiling-direction-src-p-floor-ml-945033760) | `src/p_floor.ml:93` | 95 | 66 | 21 | 56 | 5 | 2389 | 30.38 |
| [`T_PlatRaise`](File-src-p-plats-ml-866228534.md#function-function-t-platraise-function-t-platraise-plat-src-p-plats-ml-658963712) | `src/p_plats.ml:194` | 51 | 28 | 18 | 24 | 3 | 2055.6 | 37.13 |
| [`T_SlidingDoor`](File-src-p-doors-ml-224295587.md#function-function-t-slidingdoor-function-t-slidingdoor-door-src-p-doors-ml-1553671806) | `src/p_doors.ml:482` | 3 | 1 | 1 | 0 | 0 | 28.07 | 79.32 |
| [`T_StrobeFlash`](File-src-p-lights-ml-1710096069.md#function-function-t-strobeflash-function-t-strobeflash-flash-src-p-lights-ml-2067931284) | `src/p_lights.ml:122` | 14 | 10 | 5 | 4 | 1 | 408.92 | 56.04 |
| [`T_VerticalDoor`](File-src-p-doors-ml-224295587.md#function-function-t-verticaldoor-function-t-verticaldoor-door-src-p-doors-ml-758044156) | `src/p_doors.ml:124` | 82 | 45 | 25 | 40 | 4 | 2858.62 | 30.69 |
| [`Tables_Init`](File-src-tables-ml-1959718242.md#function-function-tables-init-function-tables-init-src-tables-ml-1545735699) | `src/tables.ml:105` | 53 | 49 | 17 | 21 | 2 | 2083.74 | 36.86 |
| [`TryRunTics`](File-src-d-net-ml-529296669.md#function-function-tryruntics-function-tryruntics-src-d-net-ml-863008846) | `src/d_net.ml:6866` | 174 | 159 | 87 | 174 | 5 | 7359.02 | 12.35 |
| [`twoSided`](File-src-p-spec-ml-402508231.md#function-function-twosided-function-twosided-sectorindex-lineindex-src-p-spec-ml-1289321126) | `src/p_spec.ml:1212` | 11 | 15 | 9 | 8 | 1 | 534.71 | 56.97 |
| [`UDPsocket`](File-src-i-net-ml-1331775872.md#function-function-udpsocket-function-udpsocket-src-i-net-ml-234044483) | `src/i_net.ml:403` | 3 | 1 | 1 | 0 | 0 | 27 | 79.44 |
| [`UP_AddAllPatchLumps`](File-src-hdwad-builder-ml-980370789.md#function-function-up-addallpatchlumps-function-up-addallpatchlumps-images-waddata-lumps-scale-pal-src-hdwad-builder-ml-13953682) | `src/hdwad_builder.ml:1548` | 21 | 17 | 10 | 16 | 4 | 997.58 | 48.81 |
| [`UP_AddFlatRange`](File-src-hdwad-builder-ml-980370789.md#function-function-up-addflatrange-function-up-addflatrange-images-waddata-lumps-startname-endname-scale-pal-src-hdwad-builder-ml-393355073) | `src/hdwad_builder.ml:1467` | 17 | 15 | 9 | 10 | 2 | 953.81 | 51.09 |
| [`UP_AddPatchRange`](File-src-hdwad-builder-ml-980370789.md#function-function-up-addpatchrange-function-up-addpatchrange-images-waddata-lumps-startname-endname-kind-scale-pal-src-hdwad-builder-ml-515779077) | `src/hdwad_builder.ml:1495` | 19 | 16 | 10 | 13 | 3 | 963.37 | 49.87 |
| [`UP_AddTextureLump`](File-src-hdwad-builder-ml-980370789.md#function-function-up-addtexturelump-function-up-addtexturelump-images-waddata-lumps-lumpname-patchlookup-scale-pal-src-hdwad-builder-ml-952750787) | `src/hdwad_builder.ml:1578` | 14 | 11 | 4 | 5 | 2 | 544.4 | 55.3 |
| [`UP_BestEdgeColor`](File-src-hdwad-builder-ml-980370789.md#function-function-up-bestedgecolor-function-up-bestedgecolor-pal-center-a-b-hasalpha-src-hdwad-builder-ml-1070491787) | `src/hdwad_builder.ml:1187` | 6 | 5 | 2 | 1 | 1 | 212.4 | 66.46 |
| [`UP_BestEdgeColorCached`](File-src-hdwad-builder-ml-980370789.md#function-function-up-bestedgecolorcached-function-up-bestedgecolorcached-pal-cache-center-a-b-hasalpha-src-hdwad-builder-ml-1878513317) | `src/hdwad_builder.ml:1201` | 6 | 5 | 2 | 1 | 1 | 242.03 | 66.06 |
| [`UP_BlendCorner`](File-src-hdwad-builder-ml-980370789.md#function-function-up-blendcorner-function-up-blendcorner-dst-dw-blockx-blocky-scale-corner-base-edge-pal-cache-hasalpha-src-hdwad-builder-ml-1817017207) | `src/hdwad_builder.ml:1231` | 30 | 19 | 8 | 19 | 4 | 1089.25 | 45.44 |
| [`UP_BlendEdgeColumn`](File-src-hdwad-builder-ml-980370789.md#function-function-up-blendedgecolumn-function-up-blendedgecolumn-dst-dw-blockx-blocky-scale-col-base-edge-pal-cache-hasalpha-weight-src-hdwad-builder-ml-1183685192) | `src/hdwad_builder.ml:1300` | 10 | 8 | 4 | 3 | 1 | 500.11 | 58.75 |
| [`UP_BlendEdgeRow`](File-src-hdwad-builder-ml-980370789.md#function-function-up-blendedgerow-function-up-blendedgerow-dst-dw-blockx-blocky-scale-row-base-edge-pal-cache-hasalpha-weight-src-hdwad-builder-ml-438735274) | `src/hdwad_builder.ml:1276` | 10 | 8 | 4 | 3 | 1 | 489.69 | 58.81 |
| [`UP_BlendIndex`](File-src-hdwad-builder-ml-980370789.md#function-function-up-blendindex-function-up-blendindex-pal-cache-base-edge-edgeweight-hasalpha-src-hdwad-builder-ml-1080132460) | `src/hdwad_builder.ml:610` | 19 | 21 | 13 | 12 | 1 | 1493.52 | 48.13 |
| [`UP_BlendIndexRatio`](File-src-hdwad-builder-ml-980370789.md#function-function-up-blendindexratio-function-up-blendindexratio-pal-cache-base-edge-ratiocode-hasalpha-src-hdwad-builder-ml-585129005) | `src/hdwad_builder.ml:685` | 31 | 30 | 15 | 14 | 1 | 1924.85 | 42.45 |
| [`UP_BuildTextureImage`](File-src-hdwad-builder-ml-980370789.md#function-function-up-buildtextureimage-function-up-buildtextureimage-tex-waddata-lumps-src-hdwad-builder-ml-1884074262) | `src/hdwad_builder.ml:477` | 19 | 14 | 6 | 11 | 4 | 926.43 | 50.52 |
| [`UP_ClampScale`](File-src-hdwad-builder-ml-980370789.md#function-function-up-clampscale-inline-function-up-clampscale-v-src-hdwad-builder-ml-1878835579) | `src/hdwad_builder.ml:203` | 6 | 6 | 3 | 2 | 1 | 158.46 | 67.22 |
| [`UP_ColorDistance`](File-src-hdwad-builder-ml-980370789.md#function-function-up-colordistance-function-up-colordistance-pal-a-b-hasalpha-src-hdwad-builder-ml-1082153454) | `src/hdwad_builder.ml:509` | 10 | 10 | 4 | 3 | 1 | 554.88 | 58.43 |
| [`UP_ColorDistanceCached`](File-src-hdwad-builder-ml-980370789.md#function-function-up-colordistancecached-function-up-colordistancecached-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-646408364) | `src/hdwad_builder.ml:527` | 12 | 12 | 11 | 11 | 2 | 660 | 55.24 |
| [`UP_CopyBytes`](File-src-hdwad-builder-ml-980370789.md#function-function-up-copybytes-function-up-copybytes-dst-dstoff-src-srcoff-count-src-hdwad-builder-ml-1525350391) | `src/hdwad_builder.ml:235` | 7 | 4 | 2 | 1 | 1 | 181.52 | 65.48 |
| [`UP_CornerWeight`](File-src-hdwad-builder-ml-980370789.md#function-function-up-cornerweight-inline-function-up-cornerweight-dist-scale-src-hdwad-builder-ml-600308955) | `src/hdwad_builder.ml:1211` | 7 | 8 | 4 | 3 | 1 | 280.54 | 63.89 |
| [`UP_CountMarkerRange`](File-src-hdwad-builder-ml-980370789.md#function-function-up-countmarkerrange-function-up-countmarkerrange-lumps-startname-endname-src-hdwad-builder-ml-2034395852) | `src/hdwad_builder.ml:1597` | 6 | 5 | 4 | 3 | 1 | 222.97 | 66.04 |
| [`UP_DecodePatch`](File-src-hdwad-builder-ml-980370789.md#function-function-up-decodepatch-function-up-decodepatch-name-kind-lumpdata-src-hdwad-builder-ml-1988572937) | `src/hdwad_builder.ml:325` | 35 | 33 | 13 | 26 | 5 | 1494.19 | 42.34 |
| [`UP_DefaultPalette`](File-src-hdwad-builder-ml-980370789.md#function-function-up-defaultpalette-function-up-defaultpalette-src-hdwad-builder-ml-567595022) | `src/hdwad_builder.ml:281` | 12 | 9 | 2 | 1 | 1 | 261.34 | 59.26 |
| [`UP_DrawPatchToTexture`](File-src-hdwad-builder-ml-980370789.md#function-function-up-drawpatchtotexture-function-up-drawpatchtotexture-patch-canvas-texw-texh-originx-originy-src-hdwad-builder-ml-2111693240) | `src/hdwad_builder.ml:451` | 21 | 15 | 10 | 19 | 5 | 695.61 | 49.91 |
| [`UP_FindLump`](File-src-hdwad-builder-ml-980370789.md#function-function-up-findlump-function-up-findlump-lumps-name-src-hdwad-builder-ml-146086334) | `src/hdwad_builder.ml:259` | 9 | 7 | 3 | 3 | 2 | 236.84 | 62.15 |
| [`UP_FindMarker`](File-src-hdwad-builder-ml-980370789.md#function-function-up-findmarker-function-up-findmarker-lumps-name-src-hdwad-builder-ml-1401415546) | `src/hdwad_builder.ml:246` | 9 | 7 | 3 | 3 | 2 | 230.32 | 62.24 |
| [`UP_HasImage`](File-src-hdwad-builder-ml-980370789.md#function-function-up-hasimage-function-up-hasimage-images-kind-name-src-hdwad-builder-ml-92544639) | `src/hdwad_builder.ml:1520` | 10 | 8 | 5 | 5 | 2 | 322.84 | 59.95 |
| [`UP_IsLikelyPatch`](File-src-hdwad-builder-ml-980370789.md#function-function-up-islikelypatch-function-up-islikelypatch-data-src-hdwad-builder-ml-1058920954) | `src/hdwad_builder.ml:309` | 11 | 14 | 10 | 9 | 1 | 584.74 | 56.56 |
| [`UP_IsMarkerName`](File-src-hdwad-builder-ml-980370789.md#function-function-up-ismarkername-function-up-ismarkername-name-src-hdwad-builder-ml-388596395) | `src/hdwad_builder.ml:1533` | 8 | 11 | 19 | 18 | 1 | 525.14 | 58.7 |
| [`UP_IsTransparent`](File-src-hdwad-builder-ml-980370789.md#function-function-up-istransparent-inline-function-up-istransparent-idx-hasalpha-src-hdwad-builder-ml-2003587156) | `src/hdwad_builder.ml:500` | 3 | 1 | 1 | 0 | 0 | 59.21 | 77.05 |
| [`UP_LoadingPulse`](File-src-hdwad-builder-ml-980370789.md#function-function-up-loadingpulse-inline-function-up-loadingpulse-src-hdwad-builder-ml-2029973617) | `src/hdwad_builder.ml:73` | 3 | 2 | 2 | 1 | 1 | 71.7 | 76.33 |
| [`UP_LoadPalette`](File-src-hdwad-builder-ml-980370789.md#function-function-up-loadpalette-function-up-loadpalette-waddata-lumps-src-hdwad-builder-ml-61373445) | `src/hdwad_builder.ml:297` | 9 | 7 | 5 | 4 | 1 | 368.02 | 60.55 |
| [`UP_LoadWad`](File-src-hdwad-builder-ml-980370789.md#function-function-up-loadwad-function-up-loadwad-path-src-hdwad-builder-ml-581096753) | `src/hdwad_builder.ml:1423` | 31 | 26 | 10 | 9 | 1 | 1211.82 | 44.53 |
| [`UP_LumpBytes`](File-src-hdwad-builder-ml-980370789.md#function-function-up-lumpbytes-function-up-lumpbytes-waddata-lumps-idx-src-hdwad-builder-ml-1858335110) | `src/hdwad_builder.ml:273` | 6 | 6 | 7 | 6 | 1 | 411.2 | 63.78 |
| [`UP_Name8`](File-src-hdwad-builder-ml-980370789.md#function-function-up-name8-function-up-name8-b-src-hdwad-builder-ml-1721344886) | `src/hdwad_builder.ml:212` | 16 | 14 | 7 | 8 | 2 | 500.11 | 53.89 |
| [`UP_NearestPaletteIndex`](File-src-hdwad-builder-ml-980370789.md#function-function-up-nearestpaletteindex-function-up-nearestpaletteindex-pal-r-g-b-hasalpha-src-hdwad-builder-ml-1002562574) | `src/hdwad_builder.ml:579` | 23 | 19 | 5 | 8 | 3 | 675.88 | 49.81 |
| [`UP_ParsePnames`](File-src-hdwad-builder-ml-980370789.md#function-function-up-parsepnames-function-up-parsepnames-waddata-lumps-src-hdwad-builder-ml-621107689) | `src/hdwad_builder.ml:367` | 17 | 17 | 6 | 6 | 2 | 690.22 | 52.47 |
| [`UP_ParseTextureLump`](File-src-hdwad-builder-ml-980370789.md#function-function-up-parsetexturelump-function-up-parsetexturelump-waddata-lumps-lumpname-patchlookup-src-hdwad-builder-ml-2117002350) | `src/hdwad_builder.ml:391` | 46 | 41 | 17 | 24 | 3 | 2047.18 | 38.26 |
| [`UP_PixelAt`](File-src-hdwad-builder-ml-980370789.md#function-function-up-pixelat-inline-function-up-pixelat-src-w-h-x-y-src-hdwad-builder-ml-1326570123) | `src/hdwad_builder.ml:565` | 7 | 9 | 5 | 4 | 1 | 320.43 | 63.35 |
| [`UP_ReadS16`](File-src-hdwad-builder-ml-980370789.md#function-function-up-reads16-inline-function-up-reads16-b-off-src-hdwad-builder-ml-1575425656) | `src/hdwad_builder.ml:149` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`UP_ReadS32`](File-src-hdwad-builder-ml-980370789.md#function-function-up-reads32-inline-function-up-reads32-b-off-src-hdwad-builder-ml-468734636) | `src/hdwad_builder.ml:165` | 5 | 4 | 2 | 1 | 1 | 135.93 | 69.55 |
| [`UP_ReadU16`](File-src-hdwad-builder-ml-980370789.md#function-function-up-readu16-inline-function-up-readu16-b-off-src-hdwad-builder-ml-553761624) | `src/hdwad_builder.ml:142` | 3 | 1 | 1 | 0 | 0 | 104 | 75.33 |
| [`UP_ReadU32`](File-src-hdwad-builder-ml-980370789.md#function-function-up-readu32-inline-function-up-readu32-b-off-src-hdwad-builder-ml-875338036) | `src/hdwad_builder.ml:158` | 3 | 1 | 1 | 0 | 0 | 207.45 | 73.23 |
| [`UP_ReportProgress`](File-src-hdwad-builder-ml-980370789.md#function-function-up-reportprogress-inline-function-up-reportprogress-units-src-hdwad-builder-ml-456387046) | `src/hdwad_builder.ml:79` | 7 | 3 | 2 | 1 | 1 | 101.58 | 67.24 |
| [`UP_SimilarColor`](File-src-hdwad-builder-ml-980370789.md#function-function-up-similarcolor-inline-function-up-similarcolor-pal-a-b-hasalpha-src-hdwad-builder-ml-1132619571) | `src/hdwad_builder.ml:545` | 3 | 1 | 1 | 0 | 0 | 105.49 | 75.29 |
| [`UP_SimilarColorCached`](File-src-hdwad-builder-ml-980370789.md#function-function-up-similarcolorcached-inline-function-up-similarcolorcached-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-2045014575) | `src/hdwad_builder.ml:555` | 3 | 1 | 1 | 0 | 0 | 124 | 74.8 |
| [`UP_StrongEdgeWeight`](File-src-hdwad-builder-ml-980370789.md#function-function-up-strongedgeweight-inline-function-up-strongedgeweight-pal-base-edge-hasalpha-src-hdwad-builder-ml-1054262796) | `src/hdwad_builder.ml:1316` | 5 | 4 | 2 | 1 | 1 | 162.52 | 69 |
| [`UP_StrongEdgeWeightCached`](File-src-hdwad-builder-ml-980370789.md#function-function-up-strongedgeweightcached-inline-function-up-strongedgeweightcached-pal-cache-base-edge-hasalpha-src-hdwad-builder-ml-616442488) | `src/hdwad_builder.ml:1328` | 5 | 4 | 2 | 1 | 1 | 182.84 | 68.64 |
| [`UP_ToIntOr`](File-src-hdwad-builder-ml-980370789.md#function-function-up-tointor-function-up-tointor-v-fallback-src-hdwad-builder-ml-963143820) | `src/hdwad_builder.ml:186` | 14 | 14 | 7 | 8 | 2 | 515.47 | 55.07 |
| [`UP_WriteHDWADPackage`](File-src-hdwad-builder-ml-980370789.md#function-function-up-writehdwadpackage-function-up-writehdwadpackage-path-waddata-lumps-images-scale-src-hdwad-builder-ml-1185858904) | `src/hdwad_builder.ml:1699` | 3 | 1 | 1 | 0 | 0 | 132.83 | 74.59 |
| [`UP_WriteHDWADPackageWithExtraLumps`](File-src-hdwad-builder-ml-980370789.md#function-function-up-writehdwadpackagewithextralumps-function-up-writehdwadpackagewithextralumps-path-waddata-lumps-images-extranames-extradatas-scale-src-hdwad-builder-ml-190671691) | `src/hdwad_builder.ml:1712` | 128 | 117 | 29 | 41 | 2 | 6079.4 | 23.64 |
| [`UP_WritePackage`](File-src-hdwad-builder-ml-980370789.md#function-function-up-writepackage-function-up-writepackage-path-images-scale-src-hdwad-builder-ml-27442347) | `src/hdwad_builder.ml:1626` | 61 | 54 | 10 | 13 | 2 | 2745.71 | 35.63 |
| [`UP_WriteU32`](File-src-hdwad-builder-ml-980370789.md#function-function-up-writeu32-inline-function-up-writeu32-b-off-value-src-hdwad-builder-ml-436765929) | `src/hdwad_builder.ml:175` | 7 | 6 | 2 | 1 | 1 | 355.74 | 63.43 |
| [`UP_XbrzBlendCorner3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendcorner3-function-up-xbrzblendcorner3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-1737776994) | `src/hdwad_builder.ml:1015` | 3 | 1 | 1 | 0 | 0 | 204.33 | 73.28 |
| [`UP_XbrzBlendLineDiagonal3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendlinediagonal3-function-up-xbrzblendlinediagonal3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-1305918334) | `src/hdwad_builder.ml:999` | 5 | 3 | 1 | 0 | 0 | 429.04 | 66.19 |
| [`UP_XbrzBlendLineShallow3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendlineshallow3-function-up-xbrzblendlineshallow3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-535023524) | `src/hdwad_builder.ml:947` | 6 | 4 | 1 | 0 | 0 | 514.31 | 63.91 |
| [`UP_XbrzBlendLineSteep3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendlinesteep3-function-up-xbrzblendlinesteep3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-2082193308) | `src/hdwad_builder.ml:964` | 6 | 4 | 1 | 0 | 0 | 514.31 | 63.91 |
| [`UP_XbrzBlendLineSteepAndShallow3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendlinesteepandshallow3-function-up-xbrzblendlinesteepandshallow3-dst-dw-blockx-blocky-rot-col-pal-blendcache-hasalpha-src-hdwad-builder-ml-1869458228) | `src/hdwad_builder.ml:981` | 7 | 5 | 1 | 0 | 0 | 626.68 | 61.85 |
| [`UP_XbrzBlendPixel3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendpixel3-function-up-xbrzblendpixel3-dst-dw-blockx-blocky-blendinfo-rot-pal-distcache-blendcache-hasalpha-a0-b0-c0-d0-e0-f0-g0-h0-i0-src-hdwad-builder-ml-1371777590) | `src/hdwad_builder.ml:1039` | 44 | 36 | 17 | 24 | 3 | 4122.67 | 36.55 |
| [`UP_XbrzBlendRef3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzblendref3-function-up-xbrzblendref3-dst-dw-blockx-blocky-rot-i-j-col-pal-blendcache-hasalpha-ratiocode-src-hdwad-builder-ml-1368036309) | `src/hdwad_builder.ml:919` | 4 | 2 | 1 | 0 | 0 | 307.19 | 69.32 |
| [`UP_XbrzDistanceCached`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzdistancecached-function-up-xbrzdistancecached-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-1290233994) | `src/hdwad_builder.ml:639` | 28 | 26 | 13 | 13 | 2 | 1600.77 | 44.25 |
| [`UP_XbrzEq`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzeq-inline-function-up-xbrzeq-pal-cache-a-b-hasalpha-src-hdwad-builder-ml-366195771) | `src/hdwad_builder.ml:674` | 3 | 1 | 1 | 0 | 0 | 124 | 74.8 |
| [`UP_XbrzGetBottomL`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzgetbottoml-inline-function-up-xbrzgetbottoml-b-src-hdwad-builder-ml-2040124775) | `src/hdwad_builder.ml:741` | 3 | 1 | 1 | 0 | 0 | 57.36 | 77.14 |
| [`UP_XbrzGetBottomR`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzgetbottomr-inline-function-up-xbrzgetbottomr-b-src-hdwad-builder-ml-2135503519) | `src/hdwad_builder.ml:735` | 3 | 1 | 1 | 0 | 0 | 57.36 | 77.14 |
| [`UP_XbrzGetTopL`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzgettopl-inline-function-up-xbrzgettopl-b-src-hdwad-builder-ml-1821790615) | `src/hdwad_builder.ml:723` | 3 | 1 | 1 | 0 | 0 | 39.86 | 78.25 |
| [`UP_XbrzGetTopR`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzgettopr-inline-function-up-xbrzgettopr-b-src-hdwad-builder-ml-2067592479) | `src/hdwad_builder.ml:729` | 3 | 1 | 1 | 0 | 0 | 57.36 | 77.14 |
| [`UP_XbrzPreProcessCorners`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzpreprocesscorners-function-up-xbrzpreprocesscorners-pal-cache-a-b-c-d-e-f-g-h-ii-j-k-l-m-n-o-p-hasalpha-src-hdwad-builder-ml-1955858572) | `src/hdwad_builder.ml:804` | 19 | 22 | 17 | 22 | 2 | 1895.94 | 46.87 |
| [`UP_XbrzRefIndex3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzrefindex3-function-up-xbrzrefindex3-dw-blockx-blocky-rot-i-j-src-hdwad-builder-ml-863301972) | `src/hdwad_builder.ml:890` | 15 | 10 | 4 | 3 | 1 | 376.04 | 55.77 |
| [`UP_XbrzRotateBlendInfo`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzrotateblendinfo-function-up-xbrzrotateblendinfo-b-rot-src-hdwad-builder-ml-334337277) | `src/hdwad_builder.ml:776` | 6 | 7 | 4 | 3 | 1 | 356.75 | 64.62 |
| [`UP_XbrzRotGet`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzrotget-function-up-xbrzrotget-rot-pos-a-b-c-d-e-f-g-h-ii-src-hdwad-builder-ml-1134412171) | `src/hdwad_builder.ml:839` | 42 | 69 | 36 | 59 | 2 | 1678.16 | 37.17 |
| [`UP_XbrzScaleIndexed`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzscaleindexed-function-up-xbrzscaleindexed-img-scale-pal-src-hdwad-builder-ml-1870924866) | `src/hdwad_builder.ml:1338` | 77 | 64 | 35 | 69 | 4 | 7293.41 | 27.09 |
| [`UP_XbrzScaleIndexed3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzscaleindexed3-function-up-xbrzscaleindexed3-img-pal-src-hdwad-builder-ml-1595064506) | `src/hdwad_builder.ml:1092` | 81 | 83 | 13 | 30 | 3 | 5405.33 | 30.48 |
| [`UP_XbrzSetBottomL`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzsetbottoml-inline-function-up-xbrzsetbottoml-b-bt-src-hdwad-builder-ml-385297553) | `src/hdwad_builder.ml:769` | 3 | 1 | 1 | 0 | 0 | 66.61 | 76.69 |
| [`UP_XbrzSetBottomR`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzsetbottomr-inline-function-up-xbrzsetbottomr-b-bt-src-hdwad-builder-ml-1303659025) | `src/hdwad_builder.ml:762` | 3 | 1 | 1 | 0 | 0 | 66.61 | 76.69 |
| [`UP_XbrzSetRef3`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzsetref3-inline-function-up-xbrzsetref3-dst-dw-blockx-blocky-rot-i-j-col-src-hdwad-builder-ml-285946570) | `src/hdwad_builder.ml:933` | 3 | 1 | 1 | 0 | 0 | 174.17 | 73.77 |
| [`UP_XbrzSetTopL`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzsettopl-inline-function-up-xbrzsettopl-b-bt-src-hdwad-builder-ml-542360561) | `src/hdwad_builder.ml:748` | 3 | 1 | 1 | 0 | 0 | 48.43 | 77.66 |
| [`UP_XbrzSetTopR`](File-src-hdwad-builder-ml-980370789.md#function-function-up-xbrzsettopr-inline-function-up-xbrzsettopr-b-bt-src-hdwad-builder-ml-1219858865) | `src/hdwad_builder.ml:755` | 3 | 1 | 1 | 0 | 0 | 66.61 | 76.69 |
| [`UploadNewPalette`](File-src-i-video-ml-140536292.md#function-function-uploadnewpalette-function-uploadnewpalette-pal-src-i-video-ml-1924735708) | `src/i_video.ml:2700` | 3 | 1 | 1 | 0 | 0 | 30.88 | 79.03 |
| [`V_ClearHighresOverlay`](File-src-v-video-ml-592999939.md#function-function-v-clearhighresoverlay-function-v-clearhighresoverlay-src-v-video-ml-989087744) | `src/v_video.ml:296` | 27 | 21 | 5 | 7 | 3 | 597.25 | 48.67 |
| [`V_ClearHighresOverlayKeepLogicalY`](File-src-v-video-ml-592999939.md#function-function-v-clearhighresoverlaykeeplogicaly-function-v-clearhighresoverlaykeeplogicaly-logicaly-src-v-video-ml-1708880780) | `src/v_video.ml:336` | 44 | 36 | 10 | 10 | 2 | 938.73 | 41.99 |
| [`V_ClearHighresOverlayRect`](File-src-v-video-ml-592999939.md#function-function-v-clearhighresoverlayrect-function-v-clearhighresoverlayrect-x-y-width-height-src-v-video-ml-839420380) | `src/v_video.ml:390` | 25 | 29 | 12 | 11 | 1 | 1022.04 | 46.82 |
| [`V_ClearOverlayMask`](File-src-v-video-ml-592999939.md#function-function-v-clearoverlaymask-function-v-clearoverlaymask-src-v-video-ml-668063000) | `src/v_video.ml:242` | 24 | 18 | 5 | 7 | 3 | 532.5 | 50.13 |
| [`V_CopyRect`](File-src-v-video-ml-592999939.md#function-function-v-copyrect-function-v-copyrect-srcx-srcy-srcscrn-width-height-destx-desty-destscrn-src-v-video-ml-639122665) | `src/v_video.ml:661` | 15 | 11 | 3 | 2 | 1 | 552.2 | 54.74 |
| [`V_DrawBlock`](File-src-v-video-ml-592999939.md#function-function-v-drawblock-function-v-drawblock-x-y-scrn-width-height-src-src-v-video-ml-1297284562) | `src/v_video.ml:756` | 22 | 18 | 9 | 14 | 4 | 839.58 | 49.03 |
| [`V_DrawDitheredOverlayRect`](File-src-v-video-ml-592999939.md#function-function-v-drawditheredoverlayrect-function-v-drawditheredoverlayrect-x-y-width-height-color-src-v-video-ml-2061040161) | `src/v_video.ml:786` | 37 | 44 | 21 | 27 | 3 | 1685.71 | 40.37 |
| [`V_DrawNamedUpscaledPatchOverlay`](File-src-v-video-ml-592999939.md#function-function-v-drawnamedupscaledpatchoverlay-function-v-drawnamedupscaledpatchoverlay-x-y-name-flipped-src-v-video-ml-1904143480) | `src/v_video.ml:489` | 51 | 49 | 26 | 38 | 5 | 2042.91 | 36.08 |
| [`V_DrawNamedUpscaledPatchOverlayLogicalScale`](File-src-v-video-ml-592999939.md#function-function-v-drawnamedupscaledpatchoverlaylogicalscale-function-v-drawnamedupscaledpatchoverlaylogicalscale-x-y-name-flipped-logicalscale-src-v-video-ml-1260809501) | `src/v_video.ml:549` | 47 | 45 | 24 | 46 | 7 | 2129.84 | 36.99 |
| [`V_DrawPatch`](File-src-v-video-ml-592999939.md#function-function-v-drawpatch-function-v-drawpatch-x-y-scrn-patch-src-v-video-ml-1832591713) | `src/v_video.ml:684` | 42 | 33 | 13 | 30 | 6 | 1504.39 | 40.59 |
| [`V_DrawPatchDirect`](File-src-v-video-ml-592999939.md#function-function-v-drawpatchdirect-function-v-drawpatchdirect-x-y-scrn-patch-src-v-video-ml-643554339) | `src/v_video.ml:744` | 3 | 1 | 1 | 0 | 0 | 79.57 | 76.15 |
| [`V_DrawPatchFlipped`](File-src-v-video-ml-592999939.md#function-function-v-drawpatchflipped-function-v-drawpatchflipped-x-y-scrn-patch-src-v-video-ml-925846691) | `src/v_video.ml:900` | 38 | 33 | 12 | 28 | 6 | 1506 | 41.67 |
| [`V_DrawSolidOverlayRect`](File-src-v-video-ml-592999939.md#function-function-v-drawsolidoverlayrect-function-v-drawsolidoverlayrect-x-y-width-height-color-src-v-video-ml-1154554545) | `src/v_video.ml:835` | 33 | 41 | 20 | 24 | 2 | 1608.64 | 41.73 |
| [`V_DrawUpscaledFlatOverlay`](File-src-v-video-ml-592999939.md#function-function-v-drawupscaledflatoverlay-function-v-drawupscaledflatoverlay-name-src-v-video-ml-1611025961) | `src/v_video.ml:452` | 29 | 29 | 12 | 12 | 2 | 1164.76 | 45.02 |
| [`V_DrawUpscaledPatchOverlay`](File-src-v-video-ml-592999939.md#function-function-v-drawupscaledpatchoverlay-function-v-drawupscaledpatchoverlay-x-y-patch-flipped-src-v-video-ml-2114183601) | `src/v_video.ml:603` | 7 | 8 | 6 | 5 | 1 | 360.55 | 62.85 |
| [`V_EndOverlayMask`](File-src-v-video-ml-592999939.md#function-function-v-endoverlaymask-function-v-endoverlaymask-src-v-video-ml-1282421212) | `src/v_video.ml:269` | 4 | 2 | 1 | 0 | 0 | 34.87 | 75.93 |
| [`V_EnsureHighresOverlay`](File-src-v-video-ml-592999939.md#function-function-v-ensurehighresoverlay-function-v-ensurehighresoverlay-src-v-video-ml-1808382164) | `src/v_video.ml:275` | 18 | 20 | 10 | 9 | 1 | 671.25 | 51.48 |
| [`V_GetBlock`](File-src-v-video-ml-592999939.md#function-function-v-getblock-function-v-getblock-x-y-scrn-width-height-destbuf-src-v-video-ml-278197209) | `src/v_video.ml:882` | 11 | 9 | 3 | 2 | 1 | 389.83 | 58.74 |
| [`V_HighresOverlayCanReuse`](File-src-v-video-ml-592999939.md#function-function-v-highresoverlaycanreuse-function-v-highresoverlaycanreuse-src-v-video-ml-1658496904) | `src/v_video.ml:326` | 6 | 7 | 5 | 4 | 1 | 182.84 | 66.51 |
| [`V_Init`](File-src-v-video-ml-592999939.md#function-function-v-init-function-v-init-src-v-video-ml-2019431812) | `src/v_video.ml:215` | 23 | 20 | 2 | 1 | 1 | 471.89 | 51.3 |
| [`V_MarkHighresOverlayPixel`](File-src-v-video-ml-592999939.md#function-function-v-markhighresoverlaypixel-inline-function-v-markhighresoverlaypixel-idx-x-y-src-v-video-ml-2015538719) | `src/v_video.ml:429` | 19 | 21 | 9 | 8 | 1 | 540 | 51.76 |
| [`V_MarkOverlayPixel`](File-src-v-video-ml-592999939.md#function-function-v-markoverlaypixel-inline-function-v-markoverlaypixel-idx-x-y-src-v-video-ml-1231538525) | `src/v_video.ml:615` | 13 | 17 | 9 | 8 | 1 | 483.31 | 55.69 |
| [`V_MarkRect`](File-src-v-video-ml-592999939.md#function-function-v-markrect-function-v-markrect-x-y-width-height-src-v-video-ml-1648572392) | `src/v_video.ml:635` | 12 | 18 | 9 | 8 | 1 | 728.57 | 55.21 |
| [`V_SetHighresPatchOverlayEnabled`](File-src-v-video-ml-592999939.md#function-function-v-sethighrespatchoverlayenabled-function-v-sethighrespatchoverlayenabled-enabled-src-v-video-ml-441611519) | `src/v_video.ml:420` | 4 | 3 | 2 | 1 | 1 | 83.76 | 73.13 |
| [`W_AddFile`](File-src-w-wad-ml-893006035.md#function-function-w-addfile-function-w-addfile-filename-src-w-wad-ml-178127207) | `src/w_wad.ml:384` | 96 | 78 | 27 | 32 | 3 | 3788.35 | 28.07 |
| [`W_CacheLumpName`](File-src-w-wad-ml-893006035.md#function-function-w-cachelumpname-function-w-cachelumpname-name-tag-src-w-wad-ml-21876793) | `src/w_wad.ml:935` | 6 | 4 | 1 | 0 | 0 | 121.11 | 68.3 |
| [`W_CacheLumpNum`](File-src-w-wad-ml-893006035.md#function-function-w-cachelumpnum-function-w-cachelumpnum-lump-tag-src-w-wad-ml-1355760740) | `src/w_wad.ml:795` | 37 | 27 | 13 | 17 | 3 | 1236.03 | 42.39 |
| [`W_CheckNumForName`](File-src-w-wad-ml-893006035.md#function-function-w-checknumforname-function-w-checknumforname-name-src-w-wad-ml-150746567) | `src/w_wad.ml:686` | 11 | 7 | 3 | 3 | 2 | 227.55 | 60.38 |
| [`W_GetCachedLumpPtr`](File-src-w-wad-ml-893006035.md#function-function-w-getcachedlumpptr-function-w-getcachedlumpptr-lump-src-w-wad-ml-1808711322) | `src/w_wad.ml:912` | 18 | 12 | 6 | 5 | 1 | 377.83 | 53.76 |
| [`W_GetNumForName`](File-src-w-wad-ml-893006035.md#function-function-w-getnumforname-function-w-getnumforname-name-src-w-wad-ml-1896969631) | `src/w_wad.ml:702` | 7 | 4 | 2 | 1 | 1 | 131.69 | 66.45 |
| [`W_InitFile`](File-src-w-wad-ml-893006035.md#function-function-w-initfile-function-w-initfile-filename-src-w-wad-ml-1614583581) | `src/w_wad.ml:617` | 3 | 1 | 1 | 0 | 0 | 41.21 | 78.15 |
| [`W_InitMultipleFiles`](File-src-w-wad-ml-893006035.md#function-function-w-initmultiplefiles-function-w-initmultiplefiles-filenames-src-w-wad-ml-548065894) | `src/w_wad.ml:552` | 55 | 41 | 14 | 16 | 2 | 1225.24 | 38.53 |
| [`W_LumpLength`](File-src-w-wad-ml-893006035.md#function-function-w-lumplength-function-w-lumplength-lump-src-w-wad-ml-1886461514) | `src/w_wad.ml:712` | 8 | 5 | 3 | 2 | 1 | 228.33 | 63.38 |
| [`W_NameForCachedData`](File-src-w-wad-ml-893006035.md#function-function-w-nameforcacheddata-function-w-nameforcacheddata-data-src-w-wad-ml-886948136) | `src/w_wad.ml:865` | 40 | 36 | 16 | 29 | 4 | 1162.79 | 41.44 |
| [`W_NumLumps`](File-src-w-wad-ml-893006035.md#function-function-w-numlumps-function-w-numlumps-src-w-wad-ml-1540301148) | `src/w_wad.ml:622` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`W_Profile`](File-src-w-wad-ml-893006035.md#function-function-w-profile-function-w-profile-src-w-wad-ml-338426478) | `src/w_wad.ml:951` | 41 | 32 | 9 | 12 | 2 | 1162.24 | 42.15 |
| [`W_ReadLump`](File-src-w-wad-ml-893006035.md#function-function-w-readlump-function-w-readlump-lump-dest-src-w-wad-ml-1918871126) | `src/w_wad.ml:724` | 29 | 21 | 9 | 9 | 2 | 892.74 | 46.23 |
| [`W_Reload`](File-src-w-wad-ml-893006035.md#function-function-w-reload-function-w-reload-src-w-wad-ml-2073216204) | `src/w_wad.ml:628` | 45 | 34 | 13 | 16 | 3 | 1467.08 | 40.02 |
| [`WI_checkForAccelerate`](File-src-wi-stuff-ml-450049266.md#function-function-wi-checkforaccelerate-function-wi-checkforaccelerate-src-wi-stuff-ml-350505585) | `src/wi_stuff.ml:1440` | 35 | 28 | 14 | 23 | 3 | 1156.63 | 42.99 |
| [`WI_drawAnimatedBack`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawanimatedback-function-wi-drawanimatedback-src-wi-stuff-ml-1957830177) | `src/wi_stuff.ml:667` | 13 | 11 | 8 | 8 | 2 | 649.28 | 54.93 |
| [`WI_drawDeathmatchStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawdeathmatchstats-function-wi-drawdeathmatchstats-src-wi-stuff-ml-785657035) | `src/wi_stuff.ml:1071` | 38 | 33 | 11 | 16 | 4 | 1400.06 | 42.03 |
| [`WI_drawEL`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawel-function-wi-drawel-src-wi-stuff-ml-544351519) | `src/wi_stuff.ml:607` | 5 | 2 | 2 | 1 | 1 | 96 | 70.6 |
| [`WI_Drawer`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawer-function-wi-drawer-src-wi-stuff-ml-2080171103) | `src/wi_stuff.ml:1869` | 16 | 9 | 6 | 7 | 2 | 256.76 | 56.05 |
| [`WI_drawLF`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawlf-function-wi-drawlf-src-wi-stuff-ml-2102595941) | `src/wi_stuff.ml:600` | 5 | 2 | 2 | 1 | 1 | 96 | 70.6 |
| [`WI_drawNetgameStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawnetgamestats-function-wi-drawnetgamestats-src-wi-stuff-ml-1901995497) | `src/wi_stuff.ml:1265` | 30 | 32 | 10 | 12 | 3 | 1692.29 | 43.83 |
| [`WI_drawNoState`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawnostate-function-wi-drawnostate-src-wi-stuff-ml-1500972931) | `src/wi_stuff.ml:950` | 3 | 1 | 1 | 0 | 0 | 23.26 | 79.89 |
| [`WI_drawNum`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawnum-function-wi-drawnum-x-y-n-digits-src-wi-stuff-ml-1247002802) | `src/wi_stuff.ml:686` | 32 | 26 | 13 | 16 | 3 | 1100.55 | 44.12 |
| [`WI_drawNumRight`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawnumright-function-wi-drawnumright-xright-y-n-digits-src-wi-stuff-ml-1086244236) | `src/wi_stuff.ml:767` | 4 | 2 | 1 | 0 | 0 | 136 | 71.79 |
| [`WI_drawOnLnode`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawonlnode-function-wi-drawonlnode-n-c-src-wi-stuff-ml-731902946) | `src/wi_stuff.ml:616` | 17 | 17 | 12 | 14 | 3 | 942.52 | 50.72 |
| [`WI_drawPercent`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawpercent-function-wi-drawpercent-x-y-p-src-wi-stuff-ml-1179087454) | `src/wi_stuff.ml:776` | 15 | 11 | 5 | 4 | 1 | 423.73 | 55.28 |
| [`WI_drawPercentAligned`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawpercentaligned-function-wi-drawpercentaligned-x-y-p-src-wi-stuff-ml-949988334) | `src/wi_stuff.ml:798` | 6 | 3 | 2 | 1 | 1 | 165.67 | 67.22 |
| [`WI_drawShowNextLoc`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawshownextloc-function-wi-drawshownextloc-src-wi-stuff-ml-1019147339) | `src/wi_stuff.ml:935` | 11 | 8 | 2 | 1 | 1 | 292.56 | 59.75 |
| [`WI_drawStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawstats-function-wi-drawstats-src-wi-stuff-ml-1224185511) | `src/wi_stuff.ml:1409` | 25 | 21 | 7 | 6 | 1 | 1612.58 | 46.1 |
| [`WI_drawTime`](File-src-wi-stuff-ml-450049266.md#function-function-wi-drawtime-function-wi-drawtime-x-y-t-src-wi-stuff-ml-104433762) | `src/wi_stuff.ml:854` | 27 | 20 | 6 | 7 | 2 | 843.93 | 47.48 |
| [`WI_End`](File-src-wi-stuff-ml-450049266.md#function-function-wi-end-function-wi-end-src-wi-stuff-ml-800469535) | `src/wi_stuff.ml:885` | 5 | 3 | 1 | 0 | 0 | 46.51 | 72.94 |
| [`WI_fragSum`](File-src-wi-stuff-ml-450049266.md#function-function-wi-fragsum-function-wi-fragsum-playernum-src-wi-stuff-ml-1155397324) | `src/wi_stuff.ml:956` | 12 | 8 | 4 | 4 | 2 | 265.93 | 58.94 |
| [`WI_initAnimatedBack`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initanimatedback-function-wi-initanimatedback-src-wi-stuff-ml-846774261) | `src/wi_stuff.ml:635` | 13 | 12 | 5 | 4 | 1 | 479.27 | 56.26 |
| [`WI_initDeathmatchStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initdeathmatchstats-function-wi-initdeathmatchstats-src-wi-stuff-ml-807544767) | `src/wi_stuff.ml:970` | 24 | 18 | 5 | 10 | 4 | 426.9 | 50.8 |
| [`WI_initNetgameStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initnetgamestats-function-wi-initnetgamestats-src-wi-stuff-ml-63652297) | `src/wi_stuff.ml:1114` | 23 | 20 | 4 | 6 | 3 | 471.89 | 51.04 |
| [`WI_initNoState`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initnostate-function-wi-initnostate-src-wi-stuff-ml-2134794099) | `src/wi_stuff.ml:892` | 6 | 4 | 1 | 0 | 0 | 66.61 | 70.12 |
| [`WI_initShowNextLoc`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initshownextloc-function-wi-initshownextloc-src-wi-stuff-ml-761244015) | `src/wi_stuff.ml:914` | 8 | 6 | 1 | 0 | 0 | 102.19 | 66.1 |
| [`WI_initStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initstats-function-wi-initstats-src-wi-stuff-ml-1027401791) | `src/wi_stuff.ml:1300` | 23 | 20 | 2 | 1 | 1 | 396.34 | 51.83 |
| [`WI_initVariables`](File-src-wi-stuff-ml-450049266.md#function-function-wi-initvariables-function-wi-initvariables-wbstartstruct-src-wi-stuff-ml-1744773083) | `src/wi_stuff.ml:1750` | 65 | 56 | 26 | 36 | 5 | 2975.33 | 32.63 |
| [`WI_loadData`](File-src-wi-stuff-ml-450049266.md#function-function-wi-loaddata-function-wi-loaddata-src-wi-stuff-ml-1236972573) | `src/wi_stuff.ml:1482` | 151 | 141 | 16 | 21 | 2 | 4719.98 | 24.59 |
| [`WI_Responder`](File-src-wi-stuff-ml-450049266.md#function-function-wi-responder-function-wi-responder-ev-src-wi-stuff-ml-134542222) | `src/wi_stuff.ml:589` | 9 | 7 | 3 | 2 | 1 | 160.54 | 63.34 |
| [`WI_slamBackground`](File-src-wi-stuff-ml-450049266.md#function-function-wi-slambackground-function-wi-slambackground-src-wi-stuff-ml-1420277367) | `src/wi_stuff.ml:569` | 17 | 10 | 7 | 9 | 3 | 526.15 | 53.16 |
| [`WI_Start`](File-src-wi-stuff-ml-450049266.md#function-function-wi-start-function-wi-start-wbstartstruct-src-wi-stuff-ml-1304490643) | `src/wi_stuff.ml:1822` | 13 | 8 | 3 | 2 | 1 | 164.23 | 59.78 |
| [`WI_Ticker`](File-src-wi-stuff-ml-450049266.md#function-function-wi-ticker-function-wi-ticker-src-wi-stuff-ml-314708073) | `src/wi_stuff.ml:1838` | 27 | 17 | 8 | 10 | 2 | 542.84 | 48.55 |
| [`WI_unloadData`](File-src-wi-stuff-ml-450049266.md#function-function-wi-unloaddata-function-wi-unloaddata-src-wi-stuff-ml-1483912327) | `src/wi_stuff.ml:1643` | 104 | 101 | 2 | 1 | 1 | 1986.84 | 32.64 |
| [`WI_updateAnimatedBack`](File-src-wi-stuff-ml-450049266.md#function-function-wi-updateanimatedback-function-wi-updateanimatedback-src-wi-stuff-ml-292327135) | `src/wi_stuff.ml:650` | 15 | 14 | 7 | 9 | 3 | 628.96 | 53.81 |
| [`WI_updateDeathmatchStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-updatedeathmatchstats-function-wi-updatedeathmatchstats-src-wi-stuff-ml-847163807) | `src/wi_stuff.ml:997` | 70 | 49 | 21 | 57 | 7 | 2264.82 | 33.43 |
| [`WI_updateNetgameStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-updatenetgamestats-function-wi-updatenetgamestats-src-wi-stuff-ml-1059719567) | `src/wi_stuff.ml:1140` | 121 | 89 | 36 | 79 | 4 | 3695.66 | 24.74 |
| [`WI_updateNoState`](File-src-wi-stuff-ml-450049266.md#function-function-wi-updatenostate-function-wi-updatenostate-src-wi-stuff-ml-390045391) | `src/wi_stuff.ml:900` | 12 | 6 | 3 | 3 | 2 | 180.94 | 60.25 |
| [`WI_updateShowNextLoc`](File-src-wi-stuff-ml-450049266.md#function-function-wi-updateshownextloc-function-wi-updateshownextloc-src-wi-stuff-ml-1190632367) | `src/wi_stuff.ml:924` | 9 | 5 | 4 | 3 | 1 | 144.43 | 63.52 |
| [`WI_updateStats`](File-src-wi-stuff-ml-450049266.md#function-function-wi-updatestats-function-wi-updatestats-src-wi-stuff-ml-1580289979) | `src/wi_stuff.ml:1326` | 78 | 64 | 24 | 38 | 3 | 2698.02 | 31.47 |
| [`wipe_doColorXForm`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-docolorxform-function-wipe-docolorxform-width-height-ticks-src-f-wipe-ml-29165677) | `src/f_wipe.ml:146` | 33 | 27 | 12 | 20 | 4 | 985.79 | 44.3 |
| [`wipe_doMelt`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-domelt-function-wipe-domelt-width-height-ticks-src-f-wipe-ml-9724751) | `src/f_wipe.ml:237` | 50 | 43 | 15 | 31 | 4 | 1599.86 | 38.49 |
| [`wipe_EndScreen`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-endscreen-function-wipe-endscreen-x-y-width-height-src-f-wipe-ml-1294817912) | `src/f_wipe.ml:340` | 11 | 7 | 5 | 4 | 1 | 364.35 | 58.67 |
| [`wipe_EndScreenFromBuffer`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-endscreenfrombuffer-function-wipe-endscreenfrombuffer-x-y-width-height-buf-src-f-wipe-ml-1800279853) | `src/f_wipe.ml:359` | 11 | 7 | 5 | 4 | 1 | 411.2 | 58.31 |
| [`wipe_exitColorXForm`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-exitcolorxform-function-wipe-exitcolorxform-width-height-ticks-src-f-wipe-ml-1273337487) | `src/f_wipe.ml:187` | 6 | 4 | 1 | 0 | 0 | 78.87 | 69.61 |
| [`wipe_exitMelt`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-exitmelt-function-wipe-exitmelt-width-height-ticks-src-f-wipe-ml-768414165) | `src/f_wipe.ml:301` | 8 | 6 | 1 | 0 | 0 | 105.49 | 66 |
| [`wipe_initColorXForm`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-initcolorxform-function-wipe-initcolorxform-width-height-ticks-src-f-wipe-ml-2107596587) | `src/f_wipe.ml:134` | 6 | 5 | 3 | 2 | 1 | 200.67 | 66.5 |
| [`wipe_initMelt`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-initmelt-function-wipe-initmelt-width-height-ticks-src-f-wipe-ml-1766921797) | `src/f_wipe.ml:199` | 27 | 28 | 9 | 11 | 2 | 1083.64 | 46.32 |
| [`wipe_ScreenWipe`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-screenwipe-function-wipe-screenwipe-wipeno-x-y-width-height-ticks-src-f-wipe-ml-561049934) | `src/f_wipe.ml:380` | 34 | 24 | 9 | 10 | 2 | 922.64 | 44.62 |
| [`wipe_shittyColMajorXform`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-shittycolmajorxform-function-wipe-shittycolmajorxform-array16-width-height-src-f-wipe-ml-860301543) | `src/f_wipe.ml:100` | 25 | 24 | 11 | 11 | 2 | 867.47 | 47.45 |
| [`wipe_StartScreen`](File-src-f-wipe-ml-1921092045.md#function-function-wipe-startscreen-function-wipe-startscreen-x-y-width-height-src-f-wipe-ml-1129275984) | `src/f_wipe.ml:317` | 14 | 11 | 3 | 2 | 1 | 307.67 | 57.17 |
| [`WritePCXfile`](File-src-m-misc-ml-906836777.md#function-function-writepcxfile-function-writepcxfile-filename-data-width-height-palette-src-m-misc-ml-1872144825) | `src/m_misc.ml:162` | 3 | 1 | 1 | 0 | 0 | 103.61 | 75.35 |
| [`xlatekey`](File-src-i-video-ml-140536292.md#function-function-xlatekey-function-xlatekey-vk-src-i-video-ml-1934464348) | `src/i_video.ml:2706` | 14 | 13 | 8 | 8 | 2 | 427.35 | 55.5 |
| [`Z_BytesAt`](File-src-z-zone-ml-1788911354.md#function-function-z-bytesat-function-z-bytesat-ptr-length-src-z-zone-ml-862921553) | `src/z_zone.ml:578` | 3 | 1 | 1 | 0 | 0 | 62.27 | 76.89 |
| [`Z_ChangeTag`](File-src-z-zone-ml-1788911354.md#function-function-z-changetag-function-z-changetag-ptr-tag-src-z-zone-ml-2008670863) | `src/z_zone.ml:516` | 3 | 1 | 1 | 0 | 0 | 47.55 | 77.71 |
| [`Z_ChangeTag2`](File-src-z-zone-ml-1788911354.md#function-function-z-changetag2-function-z-changetag2-ptr-tag-src-z-zone-ml-1574777485) | `src/z_zone.ml:490` | 18 | 13 | 6 | 5 | 1 | 452.78 | 53.21 |
| [`Z_CheckHeap`](File-src-z-zone-ml-1788911354.md#function-function-z-checkheap-function-z-checkheap-src-z-zone-ml-1543129093) | `src/z_zone.ml:451` | 27 | 20 | 8 | 10 | 2 | 619.26 | 48.15 |
| [`Z_ClearZone`](File-src-z-zone-ml-1788911354.md#function-function-z-clearzone-function-z-clearzone-zone-src-z-zone-ml-343254549) | `src/z_zone.ml:215` | 18 | 16 | 1 | 0 | 0 | 510 | 53.52 |
| [`Z_DumpHeap`](File-src-z-zone-ml-1788911354.md#function-function-z-dumpheap-function-z-dumpheap-lowtag-hightag-src-z-zone-ml-1396088823) | `src/z_zone.ml:427` | 12 | 8 | 4 | 4 | 2 | 463.64 | 57.25 |
| [`Z_FileDumpHeap`](File-src-z-zone-ml-1788911354.md#function-function-z-filedumpheap-function-z-filedumpheap-f-src-z-zone-ml-1501817411) | `src/z_zone.ml:444` | 3 | 1 | 1 | 0 | 0 | 43.19 | 78.01 |
| [`Z_Free`](File-src-z-zone-ml-1788911354.md#function-function-z-free-function-z-free-ptr-src-z-zone-ml-369724887) | `src/z_zone.ml:256` | 38 | 33 | 13 | 14 | 2 | 1229.62 | 42.16 |
| [`Z_FreeMemory`](File-src-z-zone-ml-1788911354.md#function-function-z-freememory-function-z-freememory-src-z-zone-ml-874771983) | `src/z_zone.ml:521` | 12 | 8 | 4 | 4 | 2 | 296.34 | 58.61 |
| [`Z_FreeTags`](File-src-z-zone-ml-1788911354.md#function-function-z-freetags-function-z-freetags-lowtag-hightag-src-z-zone-ml-1403564475) | `src/z_zone.ml:400` | 20 | 19 | 11 | 16 | 3 | 710.84 | 50.17 |
| [`Z_GetZoneBuffer`](File-src-z-zone-ml-1788911354.md#function-function-z-getzonebuffer-function-z-getzonebuffer-src-z-zone-ml-732731997) | `src/z_zone.ml:535` | 3 | 1 | 1 | 0 | 0 | 22.46 | 80 |
| [`Z_Init`](File-src-z-zone-ml-1788911354.md#function-function-z-init-function-z-init-src-z-zone-ml-1369944715) | `src/z_zone.ml:240` | 11 | 9 | 1 | 0 | 0 | 157.17 | 61.77 |
| [`Z_Malloc`](File-src-z-zone-ml-1788911354.md#function-function-z-malloc-function-z-malloc-size-tag-user-src-z-zone-ml-1609689549) | `src/z_zone.ml:313` | 62 | 47 | 12 | 17 | 3 | 1998.15 | 36.18 |
| [`Z_PeekByte`](File-src-z-zone-ml-1788911354.md#function-function-z-peekbyte-function-z-peekbyte-ptr-src-z-zone-ml-366875643) | `src/z_zone.ml:541` | 3 | 1 | 1 | 0 | 0 | 39.86 | 78.25 |
| [`Z_PokeByte`](File-src-z-zone-ml-1788911354.md#function-function-z-pokebyte-function-z-pokebyte-ptr-v-src-z-zone-ml-2027031891) | `src/z_zone.ml:548` | 3 | 1 | 1 | 0 | 0 | 64.73 | 76.78 |
| [`Z_PokeBytes`](File-src-z-zone-ml-1788911354.md#function-function-z-pokebytes-function-z-pokebytes-dstptr-srcbytes-srcoff-length-src-z-zone-ml-655049782) | `src/z_zone.ml:557` | 17 | 11 | 6 | 5 | 1 | 417.17 | 54 |

## Code duplication

A clone group is an exact sequence of 6 normalized, contiguous code lines found more than once. Comments and formatting whitespace are ignored. Duplicated-line totals count overlapping windows only once.

Found 915 clone group(s). At most 200 groups are shown.

<details>
<summary>Clone 1 — 2 occurrences</summary>

    global markpoints
    markpoints = [ ]
    i = 0
    while i < AM_NUMMARKPOINTS
    markpoints = markpoints + [ _AM_MPoint ( - 1 , - 1 ) ]
    i = i + 1

- [`src/am_map.ml:484`](File-src-am-map-ml-1409794280.md)
- [`src/am_map.ml:652`](File-src-am-map-ml-1409794280.md)

</details>

<details>
<summary>Clone 2 — 2 occurrences</summary>

    markpoints = [ ]
    i = 0
    while i < AM_NUMMARKPOINTS
    markpoints = markpoints + [ _AM_MPoint ( - 1 , - 1 ) ]
    i = i + 1
    end while

- [`src/am_map.ml:485`](File-src-am-map-ml-1409794280.md)
- [`src/am_map.ml:653`](File-src-am-map-ml-1409794280.md)

</details>

<details>
<summary>Clone 3 — 2 occurrences</summary>

    global f_x
    f_x = 0
    global f_y
    f_y = 0
    global f_w
    f_w = finit_width

- [`src/am_map.ml:580`](File-src-am-map-ml-1409794280.md)
- [`src/am_map.ml:665`](File-src-am-map-ml-1409794280.md)

</details>

<details>
<summary>Clone 4 — 2 occurrences</summary>

    f_x = 0
    global f_y
    f_y = 0
    global f_w
    f_w = finit_width
    global f_h

- [`src/am_map.ml:581`](File-src-am-map-ml-1409794280.md)
- [`src/am_map.ml:666`](File-src-am-map-ml-1409794280.md)

</details>

<details>
<summary>Clone 5 — 2 occurrences</summary>

    global f_y
    f_y = 0
    global f_w
    f_w = finit_width
    global f_h
    f_h = finit_height

- [`src/am_map.ml:582`](File-src-am-map-ml-1409794280.md)
- [`src/am_map.ml:667`](File-src-am-map-ml-1409794280.md)

</details>

<details>
<summary>Clone 6 — 2 occurrences</summary>

    names = [ ]
    if typeof ( path ) != "string" or not fs . exists ( path ) or not fs . isFile ( path ) then return names end if
    dataTry = try ( fs . readAllBytes ( path ) )
    if typeof ( dataTry ) == "error" then return names end if
    data = dataTry
    if typeof ( data ) != "bytes" or len ( data ) < 28 then return names end if

- [`src/d_main.ml:1042`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:1071`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 7 — 2 occurrences</summary>

    if typeof ( path ) != "string" or not fs . exists ( path ) or not fs . isFile ( path ) then return names end if
    dataTry = try ( fs . readAllBytes ( path ) )
    if typeof ( dataTry ) == "error" then return names end if
    data = dataTry
    if typeof ( data ) != "bytes" or len ( data ) < 28 then return names end if
    if data [ 0 ] != 77 or data [ 1 ] != 68 or data [ 2 ] != 72 or data [ 3 ] != 68 then return names end if

- [`src/d_main.ml:1043`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:1072`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 8 — 2 occurrences</summary>

    dataTry = try ( fs . readAllBytes ( path ) )
    if typeof ( dataTry ) == "error" then return names end if
    data = dataTry
    if typeof ( data ) != "bytes" or len ( data ) < 28 then return names end if
    if data [ 0 ] != 77 or data [ 1 ] != 68 or data [ 2 ] != 72 or data [ 3 ] != 68 then return names end if
    version = data [ 4 ] + ( data [ 5 ] << 8 ) + ( data [ 6 ] << 16 ) + ( data [ 7 ] << 24 )

- [`src/d_main.ml:1044`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:1073`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 9 — 2 occurrences</summary>

    if typeof ( dataTry ) == "error" then return names end if
    data = dataTry
    if typeof ( data ) != "bytes" or len ( data ) < 28 then return names end if
    if data [ 0 ] != 77 or data [ 1 ] != 68 or data [ 2 ] != 72 or data [ 3 ] != 68 then return names end if
    version = data [ 4 ] + ( data [ 5 ] << 8 ) + ( data [ 6 ] << 16 ) + ( data [ 7 ] << 24 )
    if version != 6 then return names end if

- [`src/d_main.ml:1045`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:1074`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 10 — 2 occurrences</summary>

    global _d_hdwad_progress_start_ms
    global _d_hdwad_progress_total
    global _d_hdwad_progress_done
    global _d_hdwad_progress_phase_base
    global _d_hdwad_progress_phase_span
    global _d_hdwad_progress_phase_done

- [`src/d_main.ml:1285`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:1312`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 11 — 2 occurrences</summary>

    global _d_hdwad_progress_total
    global _d_hdwad_progress_done
    global _d_hdwad_progress_phase_base
    global _d_hdwad_progress_phase_span
    global _d_hdwad_progress_phase_done
    global _d_hdwad_progress_phase_expected

- [`src/d_main.ml:1286`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:1313`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 12 — 2 occurrences</summary>

    if typeof ( players ) == "array" and displayplayer < len ( players ) then
    R_RenderPlayerView ( players [ displayplayer ] )
    else
    R_RenderPlayerView ( void )
    end if
    end if

- [`src/d_main.ml:2028`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2215`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 13 — 3 occurrences</summary>

    if typeof ( RGL_SetForceSoftware ) == "function" then RGL_SetForceSoftware ( false ) end if
    if typeof ( RH_SetForceLogical ) == "function" then RH_SetForceLogical ( false ) end if
    if typeof ( I_SetForceSoftwarePresent ) == "function" then I_SetForceSoftwarePresent ( false ) end if
    if forceSoftwareWipe and typeof ( R_SetViewSize ) == "function" then
    R_SetViewSize ( setblocks , setdetail )
    end if

- [`src/d_main.ml:2117`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2150`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2273`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 14 — 3 occurrences</summary>

    if typeof ( I_FinishUpdate ) == "function" then
    if profiling then
    t0 = _D_ProfileTimeUs ( )
    I_FinishUpdate ( )
    _D_ProfileAdd ( 5 , _D_ProfileTimeUs ( ) - t0 )
    else

- [`src/d_main.ml:2123`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2141`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2262`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 15 — 3 occurrences</summary>

    if profiling then
    t0 = _D_ProfileTimeUs ( )
    I_FinishUpdate ( )
    _D_ProfileAdd ( 5 , _D_ProfileTimeUs ( ) - t0 )
    else
    I_FinishUpdate ( )

- [`src/d_main.ml:2124`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2142`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2263`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 16 — 3 occurrences</summary>

    t0 = _D_ProfileTimeUs ( )
    I_FinishUpdate ( )
    _D_ProfileAdd ( 5 , _D_ProfileTimeUs ( ) - t0 )
    else
    I_FinishUpdate ( )
    end if

- [`src/d_main.ml:2125`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2143`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2264`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 17 — 3 occurrences</summary>

    I_FinishUpdate ( )
    _D_ProfileAdd ( 5 , _D_ProfileTimeUs ( ) - t0 )
    else
    I_FinishUpdate ( )
    end if
    end if

- [`src/d_main.ml:2126`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2144`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2265`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 18 — 3 occurrences</summary>

    if profiling then
    _d_prof_frames = _d_prof_frames + 1
    _D_ProfileFlushMaybe ( )
    end if
    return
    end if

- [`src/d_main.ml:2133`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2156`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2200`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 19 — 2 occurrences</summary>

    wipestart = I_GetTime ( ) - 1
    done = false
    tics = 1
    while not done
    waitGuard = 0
    while true

- [`src/d_main.ml:2164`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2231`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 20 — 2 occurrences</summary>

    done = false
    tics = 1
    while not done
    waitGuard = 0
    while true
    nowtime = I_GetTime ( )

- [`src/d_main.ml:2165`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2232`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 21 — 2 occurrences</summary>

    tics = 1
    while not done
    waitGuard = 0
    while true
    nowtime = I_GetTime ( )
    tics = nowtime - wipestart

- [`src/d_main.ml:2166`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2233`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 22 — 2 occurrences</summary>

    while not done
    waitGuard = 0
    while true
    nowtime = I_GetTime ( )
    tics = nowtime - wipestart
    if tics > 0 then

- [`src/d_main.ml:2167`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2234`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 23 — 2 occurrences</summary>

    waitGuard = 0
    while true
    nowtime = I_GetTime ( )
    tics = nowtime - wipestart
    if tics > 0 then
    wipestart = nowtime

- [`src/d_main.ml:2168`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2235`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 24 — 2 occurrences</summary>

    while true
    nowtime = I_GetTime ( )
    tics = nowtime - wipestart
    if tics > 0 then
    wipestart = nowtime
    break

- [`src/d_main.ml:2169`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2236`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 25 — 2 occurrences</summary>

    nowtime = I_GetTime ( )
    tics = nowtime - wipestart
    if tics > 0 then
    wipestart = nowtime
    break
    end if

- [`src/d_main.ml:2170`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2237`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 26 — 2 occurrences</summary>

    if typeof ( I_WaitVBL ) == "function" then
    I_WaitVBL ( 1 )
    else
    std . time . sleep ( 1 )
    end if
    waitGuard = waitGuard + 1

- [`src/d_main.ml:2177`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2244`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 27 — 2 occurrences</summary>

    I_WaitVBL ( 1 )
    else
    std . time . sleep ( 1 )
    end if
    waitGuard = waitGuard + 1
    if waitGuard > 2000 then

- [`src/d_main.ml:2178`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:2245`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 28 — 2 occurrences</summary>

    global _d_prof_r_ms
    global _d_prof_st_ms
    global _d_prof_hu_ms
    global _d_prof_am_ms
    global _d_prof_other_ms
    global _d_prof_vid_ms

- [`src/d_main.ml:265`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:499`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 29 — 2 occurrences</summary>

    global _d_prof_st_ms
    global _d_prof_hu_ms
    global _d_prof_am_ms
    global _d_prof_other_ms
    global _d_prof_vid_ms
    global _d_prof_tick_ms

- [`src/d_main.ml:266`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:500`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 30 — 2 occurrences</summary>

    global _d_prof_hu_ms
    global _d_prof_am_ms
    global _d_prof_other_ms
    global _d_prof_vid_ms
    global _d_prof_tick_ms
    global _d_prof_player_ms

- [`src/d_main.ml:267`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:501`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 31 — 2 occurrences</summary>

    global _d_prof_am_ms
    global _d_prof_other_ms
    global _d_prof_vid_ms
    global _d_prof_tick_ms
    global _d_prof_player_ms
    global _d_prof_thinker_ms

- [`src/d_main.ml:268`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:502`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 32 — 2 occurrences</summary>

    global _d_prof_other_ms
    global _d_prof_vid_ms
    global _d_prof_tick_ms
    global _d_prof_player_ms
    global _d_prof_thinker_ms
    global _d_prof_special_ms

- [`src/d_main.ml:269`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:503`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 33 — 2 occurrences</summary>

    global _d_prof_gl_dyn_ms
    global _d_prof_gl_cache_ms
    global _d_prof_gl_sky_ms
    global _d_prof_gl_boundary_ms
    global _d_prof_gl_depth_ms
    global _d_prof_gl_flats_ms

- [`src/d_main.ml:335`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:512`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 34 — 2 occurrences</summary>

    global _d_prof_gl_cache_ms
    global _d_prof_gl_sky_ms
    global _d_prof_gl_boundary_ms
    global _d_prof_gl_depth_ms
    global _d_prof_gl_flats_ms
    global _d_prof_gl_walls_ms

- [`src/d_main.ml:336`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:513`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 35 — 2 occurrences</summary>

    global _d_prof_gl_sky_ms
    global _d_prof_gl_boundary_ms
    global _d_prof_gl_depth_ms
    global _d_prof_gl_flats_ms
    global _d_prof_gl_walls_ms
    global _d_prof_gl_sprites_ms

- [`src/d_main.ml:337`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:514`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 36 — 2 occurrences</summary>

    global _d_prof_gl_boundary_ms
    global _d_prof_gl_depth_ms
    global _d_prof_gl_flats_ms
    global _d_prof_gl_walls_ms
    global _d_prof_gl_sprites_ms
    global _d_prof_gl_masked_ms

- [`src/d_main.ml:338`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:515`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 37 — 2 occurrences</summary>

    global _d_prof_gl_depth_ms
    global _d_prof_gl_flats_ms
    global _d_prof_gl_walls_ms
    global _d_prof_gl_sprites_ms
    global _d_prof_gl_masked_ms
    global _d_prof_gl_weapon_ms

- [`src/d_main.ml:339`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:516`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 38 — 2 occurrences</summary>

    global _d_prof_gl_flat_batches
    global _d_prof_gl_flat_drawn
    global _d_prof_gl_flat_vertices
    global _d_prof_gl_wall_batches
    global _d_prof_gl_wall_drawn
    global _d_prof_gl_wall_vertices

- [`src/d_main.ml:435`](File-src-d-main-ml-105344057.md)
- [`src/d_main.ml:522`](File-src-d-main-ml-105344057.md)

</details>

<details>
<summary>Clone 39 — 2 occurrences</summary>

    global _dnet_mp_snap_cache_tick
    global _dnet_mp_snap_cache_force_all
    global _dnet_mp_snap_cache_player_rows
    global _dnet_mp_snap_cache_actor_ids
    global _dnet_mp_snap_cache_actor_refs
    global _dnet_mp_snap_cache_removed_ids

- [`src/d_net.ml:1005`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4583`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 40 — 2 occurrences</summary>

    global _dnet_mp_snap_cache_force_all
    global _dnet_mp_snap_cache_player_rows
    global _dnet_mp_snap_cache_actor_ids
    global _dnet_mp_snap_cache_actor_refs
    global _dnet_mp_snap_cache_removed_ids
    global _dnet_mp_snap_cache_sector_rows

- [`src/d_net.ml:1006`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4584`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 41 — 2 occurrences</summary>

    global _dnet_mp_snap_cache_player_rows
    global _dnet_mp_snap_cache_actor_ids
    global _dnet_mp_snap_cache_actor_refs
    global _dnet_mp_snap_cache_removed_ids
    global _dnet_mp_snap_cache_sector_rows
    global _dnet_mp_snap_cache_side_rows

- [`src/d_net.ml:1007`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4585`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 42 — 2 occurrences</summary>

    _dnet_mp_client_actor_ids = [ ]
    _dnet_mp_client_actor_refs = [ ]
    _dnet_mp_client_actor_miss = [ ]
    _dnet_mp_client_actor_tx = [ ]
    _dnet_mp_client_actor_ty = [ ]
    _dnet_mp_client_actor_tz = [ ]

- [`src/d_net.ml:1059`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4197`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 43 — 2 occurrences</summary>

    _dnet_mp_client_actor_refs = [ ]
    _dnet_mp_client_actor_miss = [ ]
    _dnet_mp_client_actor_tx = [ ]
    _dnet_mp_client_actor_ty = [ ]
    _dnet_mp_client_actor_tz = [ ]
    _dnet_mp_client_actor_tang = [ ]

- [`src/d_net.ml:1060`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4198`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 44 — 2 occurrences</summary>

    _dnet_mp_client_actor_miss = [ ]
    _dnet_mp_client_actor_tx = [ ]
    _dnet_mp_client_actor_ty = [ ]
    _dnet_mp_client_actor_tz = [ ]
    _dnet_mp_client_actor_tang = [ ]
    _dnet_mp_client_actor_vx = [ ]

- [`src/d_net.ml:1061`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4199`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 45 — 2 occurrences</summary>

    _dnet_mp_client_actor_tx = [ ]
    _dnet_mp_client_actor_ty = [ ]
    _dnet_mp_client_actor_tz = [ ]
    _dnet_mp_client_actor_tang = [ ]
    _dnet_mp_client_actor_vx = [ ]
    _dnet_mp_client_actor_vy = [ ]

- [`src/d_net.ml:1062`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4200`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 46 — 2 occurrences</summary>

    _dnet_mp_client_actor_ty = [ ]
    _dnet_mp_client_actor_tz = [ ]
    _dnet_mp_client_actor_tang = [ ]
    _dnet_mp_client_actor_vx = [ ]
    _dnet_mp_client_actor_vy = [ ]
    _dnet_mp_client_actor_vz = [ ]

- [`src/d_net.ml:1063`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4201`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 47 — 2 occurrences</summary>

    _dnet_mp_client_actor_tz = [ ]
    _dnet_mp_client_actor_tang = [ ]
    _dnet_mp_client_actor_vx = [ ]
    _dnet_mp_client_actor_vy = [ ]
    _dnet_mp_client_actor_vz = [ ]
    _dnet_mp_client_actor_last_snap_tic = [ ]

- [`src/d_net.ml:1064`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4202`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 48 — 2 occurrences</summary>

    _dnet_mp_client_actor_tang = [ ]
    _dnet_mp_client_actor_vx = [ ]
    _dnet_mp_client_actor_vy = [ ]
    _dnet_mp_client_actor_vz = [ ]
    _dnet_mp_client_actor_last_snap_tic = [ ]
    _dnet_mp_client_actor_kind = [ ]

- [`src/d_net.ml:1065`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4203`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 49 — 2 occurrences</summary>

    _dnet_mp_client_actor_vx = [ ]
    _dnet_mp_client_actor_vy = [ ]
    _dnet_mp_client_actor_vz = [ ]
    _dnet_mp_client_actor_last_snap_tic = [ ]
    _dnet_mp_client_actor_kind = [ ]
    _dnet_mp_client_player_tx = [ ]

- [`src/d_net.ml:1066`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4204`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 50 — 2 occurrences</summary>

    _dnet_mp_client_actor_vy = [ ]
    _dnet_mp_client_actor_vz = [ ]
    _dnet_mp_client_actor_last_snap_tic = [ ]
    _dnet_mp_client_actor_kind = [ ]
    _dnet_mp_client_player_tx = [ ]
    _dnet_mp_client_player_ty = [ ]

- [`src/d_net.ml:1067`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4205`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 51 — 2 occurrences</summary>

    _dnet_mp_client_actor_vz = [ ]
    _dnet_mp_client_actor_last_snap_tic = [ ]
    _dnet_mp_client_actor_kind = [ ]
    _dnet_mp_client_player_tx = [ ]
    _dnet_mp_client_player_ty = [ ]
    _dnet_mp_client_player_tz = [ ]

- [`src/d_net.ml:1068`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4206`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 52 — 2 occurrences</summary>

    _dnet_mp_client_actor_last_snap_tic = [ ]
    _dnet_mp_client_actor_kind = [ ]
    _dnet_mp_client_player_tx = [ ]
    _dnet_mp_client_player_ty = [ ]
    _dnet_mp_client_player_tz = [ ]
    _dnet_mp_client_player_tang = [ ]

- [`src/d_net.ml:1069`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4207`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 53 — 2 occurrences</summary>

    _dnet_mp_client_actor_kind = [ ]
    _dnet_mp_client_player_tx = [ ]
    _dnet_mp_client_player_ty = [ ]
    _dnet_mp_client_player_tz = [ ]
    _dnet_mp_client_player_tang = [ ]
    _dnet_mp_client_player_vx = [ ]

- [`src/d_net.ml:1070`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4208`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 54 — 3 occurrences</summary>

    _dnet_mp_client_player_tx = [ ]
    _dnet_mp_client_player_ty = [ ]
    _dnet_mp_client_player_tz = [ ]
    _dnet_mp_client_player_tang = [ ]
    _dnet_mp_client_player_vx = [ ]
    _dnet_mp_client_player_vy = [ ]

- [`src/d_net.ml:1071`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4209`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5508`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 55 — 3 occurrences</summary>

    _dnet_mp_client_player_ty = [ ]
    _dnet_mp_client_player_tz = [ ]
    _dnet_mp_client_player_tang = [ ]
    _dnet_mp_client_player_vx = [ ]
    _dnet_mp_client_player_vy = [ ]
    _dnet_mp_client_player_vz = [ ]

- [`src/d_net.ml:1072`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4210`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5509`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 56 — 3 occurrences</summary>

    _dnet_mp_client_player_tz = [ ]
    _dnet_mp_client_player_tang = [ ]
    _dnet_mp_client_player_vx = [ ]
    _dnet_mp_client_player_vy = [ ]
    _dnet_mp_client_player_vz = [ ]
    _dnet_mp_client_player_last_snap_tic = [ ]

- [`src/d_net.ml:1073`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4211`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5510`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 57 — 2 occurrences</summary>

    _dnet_mp_client_player_tang = [ ]
    _dnet_mp_client_player_vx = [ ]
    _dnet_mp_client_player_vy = [ ]
    _dnet_mp_client_player_vz = [ ]
    _dnet_mp_client_player_last_snap_tic = [ ]
    _dnet_mp_client_last_smooth_tic = - 1

- [`src/d_net.ml:1074`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4212`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 58 — 2 occurrences</summary>

    plyr = array ( MAXPLAYERS )
    i = 0
    while i < MAXPLAYERS
    plyr [ i ] = _DNet_MPMakeWBRowForSlot ( i )
    i = i + 1
    end while

- [`src/d_net.ml:1334`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:1735`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 59 — 3 occurrences</summary>

    global _dnet_mp_client_wait_wistats
    global _dnet_mp_client_have_wistats
    global _dnet_mp_client_wistats_last_tick
    global _dnet_mp_client_wistats_next_req_tic
    global _dnet_mp_client_wistats_req_count
    global _dnet_mp_client_wistats_error

- [`src/d_net.ml:1677`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5448`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:983`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 60 — 3 occurrences</summary>

    global _dnet_mp_client_have_wistats
    global _dnet_mp_client_wistats_last_tick
    global _dnet_mp_client_wistats_next_req_tic
    global _dnet_mp_client_wistats_req_count
    global _dnet_mp_client_wistats_error
    global _dnet_mp_client_cached_wistats

- [`src/d_net.ml:1678`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5449`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:984`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 61 — 3 occurrences</summary>

    slots = _DNet_MPActiveSlots ( )
    i = 0
    while i < len ( slots )
    s = _DNet_ToInt ( slots [ i ] , - 1 )
    if s > 0 then
    MP_PlatformNetSend ( s , payload )

- [`src/d_net.ml:1902`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:1928`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:2369`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 62 — 3 occurrences</summary>

    i = 0
    while i < len ( slots )
    s = _DNet_ToInt ( slots [ i ] , - 1 )
    if s > 0 then
    MP_PlatformNetSend ( s , payload )
    end if

- [`src/d_net.ml:1903`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:1929`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:2370`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 63 — 3 occurrences</summary>

    while i < len ( slots )
    s = _DNet_ToInt ( slots [ i ] , - 1 )
    if s > 0 then
    MP_PlatformNetSend ( s , payload )
    end if
    i = i + 1

- [`src/d_net.ml:1904`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:1930`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:2371`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 64 — 3 occurrences</summary>

    s = _DNet_ToInt ( slots [ i ] , - 1 )
    if s > 0 then
    MP_PlatformNetSend ( s , payload )
    end if
    i = i + 1
    end while

- [`src/d_net.ml:1905`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:1931`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:2372`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 65 — 2 occurrences</summary>

    if s > 0 then
    MP_PlatformNetSend ( s , payload )
    end if
    i = i + 1
    end while
    end function

- [`src/d_net.ml:1906`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:1932`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 66 — 2 occurrences</summary>

    end if
    end if
    i = i + 1
    end while
    return - 1
    end function

- [`src/d_net.ml:2478`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4114`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 67 — 2 occurrences</summary>

    global _dnet_mp_host_actor_ids
    global _dnet_mp_host_actor_nodes
    global _dnet_mp_host_actor_refs
    global _dnet_mp_host_last_actor_sig
    global _dnet_mp_host_actor_miss
    global _dnet_mp_host_actor_seen

- [`src/d_net.ml:2512`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:936`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 68 — 2 occurrences</summary>

    global _dnet_mp_host_actor_nodes
    global _dnet_mp_host_actor_refs
    global _dnet_mp_host_last_actor_sig
    global _dnet_mp_host_actor_miss
    global _dnet_mp_host_actor_seen
    global _dnet_mp_host_actor_active_count

- [`src/d_net.ml:2513`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:937`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 69 — 2 occurrences</summary>

    global _dnet_mp_host_actor_refs
    global _dnet_mp_host_last_actor_sig
    global _dnet_mp_host_actor_miss
    global _dnet_mp_host_actor_seen
    global _dnet_mp_host_actor_active_count
    global _dnet_mp_host_removed_ids

- [`src/d_net.ml:2514`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:938`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 70 — 2 occurrences</summary>

    cur = thinkercap . next
    guard = 0
    while cur != thinkercap and guard < 131072
    if typeof ( cur ) != "struct" then break end if
    nxt = cur . next
    if nxt is void then break end if

- [`src/d_net.ml:2556`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4221`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 71 — 2 occurrences</summary>

    guard = 0
    while cur != thinkercap and guard < 131072
    if typeof ( cur ) != "struct" then break end if
    nxt = cur . next
    if nxt is void then break end if
    if _DNet_MPThinkerIsMobj ( cur ) then

- [`src/d_net.ml:2557`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4222`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 72 — 2 occurrences</summary>

    scanLimit = maxCount * 8
    if forceAll then scanLimit = n end if
    if scanLimit < maxCount then scanLimit = maxCount end if
    if scanLimit > n then scanLimit = n end if
    rowsCap = maxCount
    if rowsCap > scanLimit then rowsCap = scanLimit end if

- [`src/d_net.ml:3062`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3175`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 73 — 2 occurrences</summary>

    if forceAll then scanLimit = n end if
    if scanLimit < maxCount then scanLimit = maxCount end if
    if scanLimit > n then scanLimit = n end if
    rowsCap = maxCount
    if rowsCap > scanLimit then rowsCap = scanLimit end if
    if rowsCap < 0 then rowsCap = 0 end if

- [`src/d_net.ml:3063`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3176`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 74 — 2 occurrences</summary>

    if scanLimit < maxCount then scanLimit = maxCount end if
    if scanLimit > n then scanLimit = n end if
    rowsCap = maxCount
    if rowsCap > scanLimit then rowsCap = scanLimit end if
    if rowsCap < 0 then rowsCap = 0 end if
    rows = array ( rowsCap )

- [`src/d_net.ml:3064`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3177`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 75 — 2 occurrences</summary>

    if rowCount < len ( rows ) then
    trimmed = array ( rowCount )
    j = 0
    while j < rowCount
    trimmed [ j ] = rows [ j ]
    j = j + 1

- [`src/d_net.ml:3105`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3216`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 76 — 2 occurrences</summary>

    trimmed = array ( rowCount )
    j = 0
    while j < rowCount
    trimmed [ j ] = rows [ j ]
    j = j + 1
    end while

- [`src/d_net.ml:3106`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3217`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 77 — 2 occurrences</summary>

    j = 0
    while j < rowCount
    trimmed [ j ] = rows [ j ]
    j = j + 1
    end while
    rows = trimmed

- [`src/d_net.ml:3107`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3218`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 78 — 2 occurrences</summary>

    while j < rowCount
    trimmed [ j ] = rows [ j ]
    j = j + 1
    end while
    rows = trimmed
    end if

- [`src/d_net.ml:3108`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3219`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 79 — 2 occurrences</summary>

    trimmed [ j ] = rows [ j ]
    j = j + 1
    end while
    rows = trimmed
    end if
    return rows

- [`src/d_net.ml:3109`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3220`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 80 — 2 occurrences</summary>

    j = j + 1
    end while
    rows = trimmed
    end if
    return rows
    end function

- [`src/d_net.ml:3110`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3221`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 81 — 6 occurrences</summary>

    global _dnet_mp_client_actor_tx
    global _dnet_mp_client_actor_ty
    global _dnet_mp_client_actor_tz
    global _dnet_mp_client_actor_tang
    global _dnet_mp_client_actor_vx
    global _dnet_mp_client_actor_vy

- [`src/d_net.ml:3390`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3538`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3605`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4143`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4179`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:961`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 82 — 6 occurrences</summary>

    global _dnet_mp_client_actor_ty
    global _dnet_mp_client_actor_tz
    global _dnet_mp_client_actor_tang
    global _dnet_mp_client_actor_vx
    global _dnet_mp_client_actor_vy
    global _dnet_mp_client_actor_vz

- [`src/d_net.ml:3391`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3539`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3606`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4144`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4180`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:962`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 83 — 6 occurrences</summary>

    global _dnet_mp_client_actor_tz
    global _dnet_mp_client_actor_tang
    global _dnet_mp_client_actor_vx
    global _dnet_mp_client_actor_vy
    global _dnet_mp_client_actor_vz
    global _dnet_mp_client_actor_last_snap_tic

- [`src/d_net.ml:3392`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3540`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3607`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4145`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4181`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:963`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 84 — 6 occurrences</summary>

    global _dnet_mp_client_actor_tang
    global _dnet_mp_client_actor_vx
    global _dnet_mp_client_actor_vy
    global _dnet_mp_client_actor_vz
    global _dnet_mp_client_actor_last_snap_tic
    global _dnet_mp_client_actor_kind

- [`src/d_net.ml:3393`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3541`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3608`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4146`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4182`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:964`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 85 — 5 occurrences</summary>

    global _dnet_mp_client_player_tx
    global _dnet_mp_client_player_ty
    global _dnet_mp_client_player_tz
    global _dnet_mp_client_player_tang
    global _dnet_mp_client_player_vx
    global _dnet_mp_client_player_vy

- [`src/d_net.ml:3419`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3720`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4188`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5439`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:970`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 86 — 5 occurrences</summary>

    global _dnet_mp_client_player_ty
    global _dnet_mp_client_player_tz
    global _dnet_mp_client_player_tang
    global _dnet_mp_client_player_vx
    global _dnet_mp_client_player_vy
    global _dnet_mp_client_player_vz

- [`src/d_net.ml:3420`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3721`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4189`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5440`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:971`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 87 — 5 occurrences</summary>

    global _dnet_mp_client_player_tz
    global _dnet_mp_client_player_tang
    global _dnet_mp_client_player_vx
    global _dnet_mp_client_player_vy
    global _dnet_mp_client_player_vz
    global _dnet_mp_client_player_last_snap_tic

- [`src/d_net.ml:3421`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3722`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4190`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5441`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:972`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 88 — 2 occurrences</summary>

    cx = _DNet_ToInt ( mo . x , 0 )
    cy = _DNet_ToInt ( mo . y , 0 )
    cz = _DNet_ToInt ( mo . z , 0 )
    dx = tx - cx
    dy = ty - cy
    dz = tz - cz

- [`src/d_net.ml:3652`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3756`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 89 — 2 occurrences</summary>

    nx = cx
    ny = cy
    nz = cz
    if hard then
    nx = tx
    ny = ty

- [`src/d_net.ml:3664`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3767`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 90 — 2 occurrences</summary>

    ny = cy
    nz = cz
    if hard then
    nx = tx
    ny = ty
    nz = tz

- [`src/d_net.ml:3665`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3768`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 91 — 2 occurrences</summary>

    nz = cz
    if hard then
    nx = tx
    ny = ty
    nz = tz
    else

- [`src/d_net.ml:3666`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3769`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 92 — 2 occurrences</summary>

    if hard then
    nx = tx
    ny = ty
    nz = tz
    else
    sx = _DNet_IDiv ( dx * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )

- [`src/d_net.ml:3667`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3770`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 93 — 2 occurrences</summary>

    nx = tx
    ny = ty
    nz = tz
    else
    sx = _DNet_IDiv ( dx * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sy = _DNet_IDiv ( dy * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )

- [`src/d_net.ml:3668`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3771`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 94 — 2 occurrences</summary>

    ny = ty
    nz = tz
    else
    sx = _DNet_IDiv ( dx * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sy = _DNet_IDiv ( dy * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sz = _DNet_IDiv ( dz * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )

- [`src/d_net.ml:3669`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3772`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 95 — 2 occurrences</summary>

    nz = tz
    else
    sx = _DNet_IDiv ( dx * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sy = _DNet_IDiv ( dy * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sz = _DNet_IDiv ( dz * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    if sx == 0 and dx != 0 then sx = _DNet_MPSign32 ( dx ) end if

- [`src/d_net.ml:3670`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3773`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 96 — 2 occurrences</summary>

    else
    sx = _DNet_IDiv ( dx * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sy = _DNet_IDiv ( dy * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sz = _DNet_IDiv ( dz * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    if sx == 0 and dx != 0 then sx = _DNet_MPSign32 ( dx ) end if
    if sy == 0 and dy != 0 then sy = _DNet_MPSign32 ( dy ) end if

- [`src/d_net.ml:3671`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3774`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 97 — 2 occurrences</summary>

    sx = _DNet_IDiv ( dx * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sy = _DNet_IDiv ( dy * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sz = _DNet_IDiv ( dz * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    if sx == 0 and dx != 0 then sx = _DNet_MPSign32 ( dx ) end if
    if sy == 0 and dy != 0 then sy = _DNet_MPSign32 ( dy ) end if
    if sz == 0 and dz != 0 then sz = _DNet_MPSign32 ( dz ) end if

- [`src/d_net.ml:3672`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3775`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 98 — 2 occurrences</summary>

    sy = _DNet_IDiv ( dy * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    sz = _DNet_IDiv ( dz * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    if sx == 0 and dx != 0 then sx = _DNet_MPSign32 ( dx ) end if
    if sy == 0 and dy != 0 then sy = _DNet_MPSign32 ( dy ) end if
    if sz == 0 and dz != 0 then sz = _DNet_MPSign32 ( dz ) end if
    nx = cx + sx

- [`src/d_net.ml:3673`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3776`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 99 — 2 occurrences</summary>

    sz = _DNet_IDiv ( dz * _DNET_MP_CLIENT_INTERP_NUM , _DNET_MP_CLIENT_INTERP_DEN )
    if sx == 0 and dx != 0 then sx = _DNet_MPSign32 ( dx ) end if
    if sy == 0 and dy != 0 then sy = _DNet_MPSign32 ( dy ) end if
    if sz == 0 and dz != 0 then sz = _DNet_MPSign32 ( dz ) end if
    nx = cx + sx
    ny = cy + sy

- [`src/d_net.ml:3674`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3777`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 100 — 2 occurrences</summary>

    if sx == 0 and dx != 0 then sx = _DNet_MPSign32 ( dx ) end if
    if sy == 0 and dy != 0 then sy = _DNet_MPSign32 ( dy ) end if
    if sz == 0 and dz != 0 then sz = _DNet_MPSign32 ( dz ) end if
    nx = cx + sx
    ny = cy + sy
    nz = cz + sz

- [`src/d_net.ml:3675`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3778`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 101 — 2 occurrences</summary>

    if sy == 0 and dy != 0 then sy = _DNet_MPSign32 ( dy ) end if
    if sz == 0 and dz != 0 then sz = _DNet_MPSign32 ( dz ) end if
    nx = cx + sx
    ny = cy + sy
    nz = cz + sz
    end if

- [`src/d_net.ml:3676`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3779`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 102 — 2 occurrences</summary>

    moved = nx != cx or ny != cy or nz != cz
    if moved then
    needRelink = true
    newsub = void
    if typeof ( R_PointInSubsector ) == "function" then
    newsub = R_PointInSubsector ( nx , ny )

- [`src/d_net.ml:3683`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3797`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 103 — 2 occurrences</summary>

    if moved then
    needRelink = true
    newsub = void
    if typeof ( R_PointInSubsector ) == "function" then
    newsub = R_PointInSubsector ( nx , ny )
    if newsub is not void and mo . subsector is not void and newsub == mo . subsector then

- [`src/d_net.ml:3684`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3798`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 104 — 2 occurrences</summary>

    needRelink = true
    newsub = void
    if typeof ( R_PointInSubsector ) == "function" then
    newsub = R_PointInSubsector ( nx , ny )
    if newsub is not void and mo . subsector is not void and newsub == mo . subsector then
    needRelink = false

- [`src/d_net.ml:3685`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3799`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 105 — 2 occurrences</summary>

    newsub = void
    if typeof ( R_PointInSubsector ) == "function" then
    newsub = R_PointInSubsector ( nx , ny )
    if newsub is not void and mo . subsector is not void and newsub == mo . subsector then
    needRelink = false
    end if

- [`src/d_net.ml:3686`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3800`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 106 — 2 occurrences</summary>

    if typeof ( R_PointInSubsector ) == "function" then
    newsub = R_PointInSubsector ( nx , ny )
    if newsub is not void and mo . subsector is not void and newsub == mo . subsector then
    needRelink = false
    end if
    end if

- [`src/d_net.ml:3687`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3801`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 107 — 2 occurrences</summary>

    newsub = R_PointInSubsector ( nx , ny )
    if newsub is not void and mo . subsector is not void and newsub == mo . subsector then
    needRelink = false
    end if
    end if
    if needRelink and typeof ( P_UnsetThingPosition ) == "function" then P_UnsetThingPosition ( mo ) end if

- [`src/d_net.ml:3688`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3802`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 108 — 2 occurrences</summary>

    if newsub is not void and mo . subsector is not void and newsub == mo . subsector then
    needRelink = false
    end if
    end if
    if needRelink and typeof ( P_UnsetThingPosition ) == "function" then P_UnsetThingPosition ( mo ) end if
    mo . x = nx

- [`src/d_net.ml:3689`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3803`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 109 — 2 occurrences</summary>

    needRelink = false
    end if
    end if
    if needRelink and typeof ( P_UnsetThingPosition ) == "function" then P_UnsetThingPosition ( mo ) end if
    mo . x = nx
    mo . y = ny

- [`src/d_net.ml:3690`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3804`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 110 — 2 occurrences</summary>

    end if
    end if
    if needRelink and typeof ( P_UnsetThingPosition ) == "function" then P_UnsetThingPosition ( mo ) end if
    mo . x = nx
    mo . y = ny
    mo . z = nz

- [`src/d_net.ml:3691`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3805`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 111 — 2 occurrences</summary>

    if needRelink and typeof ( P_SetThingPosition ) == "function" then
    P_SetThingPosition ( mo )
    else if newsub is not void then
    mo . subsector = newsub
    end if
    if mo . subsector is not void and mo . subsector . sector is not void then

- [`src/d_net.ml:3698`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3812`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 112 — 2 occurrences</summary>

    P_SetThingPosition ( mo )
    else if newsub is not void then
    mo . subsector = newsub
    end if
    if mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )

- [`src/d_net.ml:3699`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3813`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 113 — 2 occurrences</summary>

    else if newsub is not void then
    mo . subsector = newsub
    end if
    if mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )
    mo . ceilingz = _DNet_ToInt ( mo . subsector . sector . ceilingheight , 0 )

- [`src/d_net.ml:3700`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3814`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 114 — 2 occurrences</summary>

    mo . subsector = newsub
    end if
    if mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )
    mo . ceilingz = _DNet_ToInt ( mo . subsector . sector . ceilingheight , 0 )
    end if

- [`src/d_net.ml:3701`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3815`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 115 — 2 occurrences</summary>

    end if
    if mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )
    mo . ceilingz = _DNet_ToInt ( mo . subsector . sector . ceilingheight , 0 )
    end if
    else

- [`src/d_net.ml:3702`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:3816`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 116 — 8 occurrences</summary>

    end if
    end if
    end if
    end if
    i = i + 1
    end while

- [`src/d_net.ml:4082`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4561`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5395`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5991`](File-src-d-net-ml-529296669.md)
- [`src/hu_stuff.ml:701`](File-src-hu-stuff-ml-1965779679.md)
- [`src/p_maputl.ml:429`](File-src-p-maputl-ml-227665141.md)
- [`src/p_pspr.ml:545`](File-src-p-pspr-ml-844718747.md)
- [`src/r_gl.ml:5864`](File-src-r-gl-ml-2087530889.md)

</details>

<details>
<summary>Clone 117 — 3 occurrences</summary>

    global _dnet_mp_client_actor_ids
    global _dnet_mp_client_actor_refs
    global _dnet_mp_client_actor_miss
    global _dnet_mp_client_actor_tx
    global _dnet_mp_client_actor_ty
    global _dnet_mp_client_actor_tz

- [`src/d_net.ml:4140`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4176`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:958`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 118 — 3 occurrences</summary>

    global _dnet_mp_client_actor_refs
    global _dnet_mp_client_actor_miss
    global _dnet_mp_client_actor_tx
    global _dnet_mp_client_actor_ty
    global _dnet_mp_client_actor_tz
    global _dnet_mp_client_actor_tang

- [`src/d_net.ml:4141`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4177`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:959`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 119 — 3 occurrences</summary>

    global _dnet_mp_client_actor_miss
    global _dnet_mp_client_actor_tx
    global _dnet_mp_client_actor_ty
    global _dnet_mp_client_actor_tz
    global _dnet_mp_client_actor_tang
    global _dnet_mp_client_actor_vx

- [`src/d_net.ml:4142`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4178`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:960`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 120 — 2 occurrences</summary>

    global _dnet_mp_client_actor_vx
    global _dnet_mp_client_actor_vy
    global _dnet_mp_client_actor_vz
    global _dnet_mp_client_actor_last_snap_tic
    global _dnet_mp_client_actor_kind
    global _dnet_mp_client_player_tx

- [`src/d_net.ml:4183`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:965`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 121 — 2 occurrences</summary>

    global _dnet_mp_client_actor_vy
    global _dnet_mp_client_actor_vz
    global _dnet_mp_client_actor_last_snap_tic
    global _dnet_mp_client_actor_kind
    global _dnet_mp_client_player_tx
    global _dnet_mp_client_player_ty

- [`src/d_net.ml:4184`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:966`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 122 — 2 occurrences</summary>

    global _dnet_mp_client_actor_vz
    global _dnet_mp_client_actor_last_snap_tic
    global _dnet_mp_client_actor_kind
    global _dnet_mp_client_player_tx
    global _dnet_mp_client_player_ty
    global _dnet_mp_client_player_tz

- [`src/d_net.ml:4185`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:967`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 123 — 2 occurrences</summary>

    global _dnet_mp_client_actor_last_snap_tic
    global _dnet_mp_client_actor_kind
    global _dnet_mp_client_player_tx
    global _dnet_mp_client_player_ty
    global _dnet_mp_client_player_tz
    global _dnet_mp_client_player_tang

- [`src/d_net.ml:4186`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:968`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 124 — 2 occurrences</summary>

    global _dnet_mp_client_actor_kind
    global _dnet_mp_client_player_tx
    global _dnet_mp_client_player_ty
    global _dnet_mp_client_player_tz
    global _dnet_mp_client_player_tang
    global _dnet_mp_client_player_vx

- [`src/d_net.ml:4187`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:969`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 125 — 2 occurrences</summary>

    global _dnet_mp_client_player_tang
    global _dnet_mp_client_player_vx
    global _dnet_mp_client_player_vy
    global _dnet_mp_client_player_vz
    global _dnet_mp_client_player_last_snap_tic
    global _dnet_mp_client_last_smooth_tic

- [`src/d_net.ml:4191`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:973`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 126 — 2 occurrences</summary>

    ci = ci + 1
    end while
    end if
    if _DNet_IsSeq ( p . weaponowned ) then
    wi = 0
    while wi < NUMWEAPONS and wi < len ( p . weaponowned ) and wi < 16

- [`src/d_net.ml:4716`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5921`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 127 — 2 occurrences</summary>

    while size > _DNET_MP_PAYLOAD_BUDGET and actorCount > 0
    actorCount = actorCount - 1
    size = size - 34
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
    removedCount = removedCount - 1

- [`src/d_net.ml:4839`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4860`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 128 — 2 occurrences</summary>

    actorCount = actorCount - 1
    size = size - 34
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
    removedCount = removedCount - 1
    size = size - 4

- [`src/d_net.ml:4840`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4861`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 129 — 2 occurrences</summary>

    size = size - 34
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
    removedCount = removedCount - 1
    size = size - 4
    end while

- [`src/d_net.ml:4841`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4862`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 130 — 2 occurrences</summary>

    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
    removedCount = removedCount - 1
    size = size - 4
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0

- [`src/d_net.ml:4842`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4863`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 131 — 2 occurrences</summary>

    while size > _DNET_MP_PAYLOAD_BUDGET and removedCount > 0
    removedCount = removedCount - 1
    size = size - 4
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
    sectorCount = sectorCount - 1

- [`src/d_net.ml:4843`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4864`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 132 — 2 occurrences</summary>

    removedCount = removedCount - 1
    size = size - 4
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
    sectorCount = sectorCount - 1
    size = size - 14

- [`src/d_net.ml:4844`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4865`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 133 — 2 occurrences</summary>

    size = size - 4
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
    sectorCount = sectorCount - 1
    size = size - 14
    end while

- [`src/d_net.ml:4845`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4866`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 134 — 2 occurrences</summary>

    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
    sectorCount = sectorCount - 1
    size = size - 14
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep

- [`src/d_net.ml:4846`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4867`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 135 — 2 occurrences</summary>

    while size > _DNET_MP_PAYLOAD_BUDGET and sectorCount > 0
    sectorCount = sectorCount - 1
    size = size - 14
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
    sideCount = sideCount - 1

- [`src/d_net.ml:4847`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4868`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 136 — 2 occurrences</summary>

    sectorCount = sectorCount - 1
    size = size - 14
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
    sideCount = sideCount - 1
    size = size - 8

- [`src/d_net.ml:4848`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4869`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 137 — 2 occurrences</summary>

    size = size - 14
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
    sideCount = sideCount - 1
    size = size - 8
    end while

- [`src/d_net.ml:4849`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4870`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 138 — 2 occurrences</summary>

    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
    sideCount = sideCount - 1
    size = size - 8
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > 0

- [`src/d_net.ml:4850`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4871`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 139 — 2 occurrences</summary>

    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > minSideKeep
    sideCount = sideCount - 1
    size = size - 8
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > 0
    sideCount = sideCount - 1

- [`src/d_net.ml:4851`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4872`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 140 — 2 occurrences</summary>

    sideCount = sideCount - 1
    size = size - 8
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > 0
    sideCount = sideCount - 1
    size = size - 8

- [`src/d_net.ml:4852`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4873`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 141 — 2 occurrences</summary>

    size = size - 8
    end while
    while size > _DNET_MP_PAYLOAD_BUDGET and sideCount > 0
    sideCount = sideCount - 1
    size = size - 8
    end while

- [`src/d_net.ml:4853`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:4874`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 142 — 2 occurrences</summary>

    global _dnet_mp_dbg_snap_calls
    global _dnet_mp_dbg_snap_skip_not_host
    global _dnet_mp_dbg_snap_skip_not_level
    global _dnet_mp_dbg_snap_skip_nosend
    global _dnet_mp_dbg_snap_skip_rate
    global _dnet_mp_dbg_snap_built

- [`src/d_net.ml:5285`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:996`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 143 — 2 occurrences</summary>

    global _dnet_mp_dbg_snap_skip_not_host
    global _dnet_mp_dbg_snap_skip_not_level
    global _dnet_mp_dbg_snap_skip_nosend
    global _dnet_mp_dbg_snap_skip_rate
    global _dnet_mp_dbg_snap_built
    global _dnet_mp_dbg_snap_targets

- [`src/d_net.ml:5286`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:997`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 144 — 2 occurrences</summary>

    global _dnet_mp_dbg_snap_skip_not_level
    global _dnet_mp_dbg_snap_skip_nosend
    global _dnet_mp_dbg_snap_skip_rate
    global _dnet_mp_dbg_snap_built
    global _dnet_mp_dbg_snap_targets
    global _dnet_mp_dbg_snap_sent

- [`src/d_net.ml:5287`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:998`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 145 — 2 occurrences</summary>

    global _dnet_mp_client_ui_tic
    global _dnet_mp_client_wait_wistats
    global _dnet_mp_client_have_wistats
    global _dnet_mp_client_wistats_last_tick
    global _dnet_mp_client_wistats_next_req_tic
    global _dnet_mp_client_wistats_req_count

- [`src/d_net.ml:5447`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:982`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 146 — 2 occurrences</summary>

    moved = _DNet_ToInt ( mo . x , 0 ) != px or _DNet_ToInt ( mo . y , 0 ) != py or _DNet_ToInt ( mo . z , 0 ) != pz
    if moved and typeof ( P_UnsetThingPosition ) == "function" then P_UnsetThingPosition ( mo ) end if
    if moved then
    mo . x = px
    mo . y = py
    mo . z = pz

- [`src/d_net.ml:5850`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5871`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 147 — 2 occurrences</summary>

    if moved and typeof ( P_UnsetThingPosition ) == "function" then P_UnsetThingPosition ( mo ) end if
    if moved then
    mo . x = px
    mo . y = py
    mo . z = pz
    end if

- [`src/d_net.ml:5851`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5872`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 148 — 2 occurrences</summary>

    if moved then
    mo . x = px
    mo . y = py
    mo . z = pz
    end if
    mo . angle = pang

- [`src/d_net.ml:5852`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5873`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 149 — 2 occurrences</summary>

    mo . x = px
    mo . y = py
    mo . z = pz
    end if
    mo . angle = pang
    if moved and typeof ( P_SetThingPosition ) == "function" then P_SetThingPosition ( mo ) end if

- [`src/d_net.ml:5853`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5874`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 150 — 2 occurrences</summary>

    mo . y = py
    mo . z = pz
    end if
    mo . angle = pang
    if moved and typeof ( P_SetThingPosition ) == "function" then P_SetThingPosition ( mo ) end if
    if moved and mo . subsector is not void and mo . subsector . sector is not void then

- [`src/d_net.ml:5854`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5875`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 151 — 2 occurrences</summary>

    mo . z = pz
    end if
    mo . angle = pang
    if moved and typeof ( P_SetThingPosition ) == "function" then P_SetThingPosition ( mo ) end if
    if moved and mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )

- [`src/d_net.ml:5855`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5876`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 152 — 2 occurrences</summary>

    end if
    mo . angle = pang
    if moved and typeof ( P_SetThingPosition ) == "function" then P_SetThingPosition ( mo ) end if
    if moved and mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )
    mo . ceilingz = _DNet_ToInt ( mo . subsector . sector . ceilingheight , 0 )

- [`src/d_net.ml:5856`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5877`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 153 — 2 occurrences</summary>

    mo . angle = pang
    if moved and typeof ( P_SetThingPosition ) == "function" then P_SetThingPosition ( mo ) end if
    if moved and mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )
    mo . ceilingz = _DNet_ToInt ( mo . subsector . sector . ceilingheight , 0 )
    end if

- [`src/d_net.ml:5857`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:5878`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 154 — 2 occurrences</summary>

    if moved and typeof ( P_SetThingPosition ) == "function" then P_SetThingPosition ( mo ) end if
    if moved and mo . subsector is not void and mo . subsector . sector is not void then
    mo . floorz = _DNet_ToInt ( mo . subsector . sector . floorheight , 0 )
    mo . ceilingz = _DNet_ToInt ( mo . subsector . sector . ceilingheight , 0 )
    end if
    end if

- [`src/d_net.ml:5879`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6096`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 155 — 18 occurrences</summary>

    if typeof ( v ) == "int" then return v end if
    if typeof ( v ) == "float" then
    if v >= 0 then return std . math . floor ( v ) end if
    return std . math . ceil ( v )
    end if
    n = toNumber ( v )

- [`src/d_net.ml:639`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:187`](File-src-hdwad-builder-ml-980370789.md)
- [`src/i_net.ml:46`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:513`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:102`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:357`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:82`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:338`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:264`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:338`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:128`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:111`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:263`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:100`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:127`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:232`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:411`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:116`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 156 — 18 occurrences</summary>

    if typeof ( v ) == "float" then
    if v >= 0 then return std . math . floor ( v ) end if
    return std . math . ceil ( v )
    end if
    n = toNumber ( v )
    if typeof ( n ) == "int" then return n end if

- [`src/d_net.ml:640`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:188`](File-src-hdwad-builder-ml-980370789.md)
- [`src/i_net.ml:47`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:514`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:103`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:358`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:83`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:339`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:265`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:339`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:129`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:112`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:264`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:101`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:128`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:233`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:412`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:117`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 157 — 18 occurrences</summary>

    if v >= 0 then return std . math . floor ( v ) end if
    return std . math . ceil ( v )
    end if
    n = toNumber ( v )
    if typeof ( n ) == "int" then return n end if
    if typeof ( n ) == "float" then

- [`src/d_net.ml:641`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:189`](File-src-hdwad-builder-ml-980370789.md)
- [`src/i_net.ml:48`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:515`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:104`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:359`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:84`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:340`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:266`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:340`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:130`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:113`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:265`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:102`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:129`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:234`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:413`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:118`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 158 — 18 occurrences</summary>

    return std . math . ceil ( v )
    end if
    n = toNumber ( v )
    if typeof ( n ) == "int" then return n end if
    if typeof ( n ) == "float" then
    if n >= 0 then return std . math . floor ( n ) end if

- [`src/d_net.ml:642`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:190`](File-src-hdwad-builder-ml-980370789.md)
- [`src/i_net.ml:49`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:516`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:105`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:360`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:85`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:341`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:267`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:341`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:131`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:114`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:266`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:103`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:130`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:235`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:414`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:119`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 159 — 18 occurrences</summary>

    end if
    n = toNumber ( v )
    if typeof ( n ) == "int" then return n end if
    if typeof ( n ) == "float" then
    if n >= 0 then return std . math . floor ( n ) end if
    return std . math . ceil ( n )

- [`src/d_net.ml:643`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:191`](File-src-hdwad-builder-ml-980370789.md)
- [`src/i_net.ml:50`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:517`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:106`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:361`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:86`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:342`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:268`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:342`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:132`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:115`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:267`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:104`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:131`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:236`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:415`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:120`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 160 — 21 occurrences</summary>

    n = toNumber ( v )
    if typeof ( n ) == "int" then return n end if
    if typeof ( n ) == "float" then
    if n >= 0 then return std . math . floor ( n ) end if
    return std . math . ceil ( n )
    end if

- [`src/d_net.ml:644`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:192`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hu_stuff.ml:194`](File-src-hu-stuff-ml-1965779679.md)
- [`src/i_net.ml:51`](File-src-i-net-ml-1331775872.md)
- [`src/i_sound.ml:342`](File-src-i-sound-ml-33806980.md)
- [`src/i_video.ml:518`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:107`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:362`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:87`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:343`](File-src-p-mobj-ml-1335564114.md)
- [`src/p_mobj.ml:358`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:269`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:343`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:133`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:116`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:268`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:105`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:132`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:237`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:416`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:121`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 161 — 19 occurrences</summary>

    if typeof ( n ) == "int" then return n end if
    if typeof ( n ) == "float" then
    if n >= 0 then return std . math . floor ( n ) end if
    return std . math . ceil ( n )
    end if
    return fallback

- [`src/d_net.ml:645`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:193`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hu_stuff.ml:195`](File-src-hu-stuff-ml-1965779679.md)
- [`src/i_net.ml:52`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:519`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:108`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:363`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:88`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:344`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:270`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:344`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:134`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:117`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:269`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:106`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:133`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:238`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:417`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:122`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 162 — 19 occurrences</summary>

    if typeof ( n ) == "float" then
    if n >= 0 then return std . math . floor ( n ) end if
    return std . math . ceil ( n )
    end if
    return fallback
    end function

- [`src/d_net.ml:646`](File-src-d-net-ml-529296669.md)
- [`src/hdwad_builder.ml:194`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hu_stuff.ml:196`](File-src-hu-stuff-ml-1965779679.md)
- [`src/i_net.ml:53`](File-src-i-net-ml-1331775872.md)
- [`src/i_video.ml:520`](File-src-i-video-ml-140536292.md)
- [`src/m_menu.ml:109`](File-src-m-menu-ml-331716860.md)
- [`src/mp_platform.ml:364`](File-src-mp-platform-ml-1361006310.md)
- [`src/mp_state.ml:89`](File-src-mp-state-ml-130741680.md)
- [`src/p_mobj.ml:345`](File-src-p-mobj-ml-1335564114.md)
- [`src/r_bsp.ml:271`](File-src-r-bsp-ml-998402465.md)
- [`src/r_main.ml:345`](File-src-r-main-ml-1902335243.md)
- [`src/r_plane.ml:135`](File-src-r-plane-ml-1848108848.md)
- [`src/r_segs.ml:118`](File-src-r-segs-ml-1658887754.md)
- [`src/r_things.ml:270`](File-src-r-things-ml-545677447.md)
- [`src/r_upscaled.ml:107`](File-src-r-upscaled-ml-1801241933.md)
- [`src/s_sound.ml:134`](File-src-s-sound-ml-1485495390.md)
- [`src/st_lib.ml:239`](File-src-st-lib-ml-1845497584.md)
- [`src/st_stuff.ml:418`](File-src-st-stuff-ml-811030939.md)
- [`src/wi_stuff.ml:123`](File-src-wi-stuff-ml-450049266.md)

</details>

<details>
<summary>Clone 163 — 2 occurrences</summary>

    if not _DNet_MPIsAuthoritative ( ) then
    disconnectedClient = _dnet_mp_was_client
    _dnet_mp_was_authoritative = false
    _dnet_mp_was_client = false
    _DNet_MPReturnToOffline ( disconnectedClient )
    return

- [`src/d_net.ml:6559`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6725`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 164 — 2 occurrences</summary>

    disconnectedClient = _dnet_mp_was_client
    _dnet_mp_was_authoritative = false
    _dnet_mp_was_client = false
    _DNet_MPReturnToOffline ( disconnectedClient )
    return
    end if

- [`src/d_net.ml:6560`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6726`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 165 — 2 occurrences</summary>

    if _DNet_IsSeq ( players ) and rslot < len ( players ) and typeof ( players [ rslot ] ) == "struct" and typeof ( players [ rslot ] . mo ) == "struct" then
    stidx = _DNet_StateIndex ( players [ rslot ] . mo . state )
    run0 = _DNet_StateIndex ( statenum_t . S_PLAY_RUN1 )
    if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof ( P_SetMobjState ) == "function" then
    P_SetMobjState ( players [ rslot ] . mo , statenum_t . S_PLAY )
    end if

- [`src/d_net.ml:6685`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6695`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 166 — 2 occurrences</summary>

    stidx = _DNet_StateIndex ( players [ rslot ] . mo . state )
    run0 = _DNet_StateIndex ( statenum_t . S_PLAY_RUN1 )
    if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof ( P_SetMobjState ) == "function" then
    P_SetMobjState ( players [ rslot ] . mo , statenum_t . S_PLAY )
    end if
    end if

- [`src/d_net.ml:6686`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6696`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 167 — 2 occurrences</summary>

    run0 = _DNet_StateIndex ( statenum_t . S_PLAY_RUN1 )
    if run0 >= 0 and stidx >= run0 and stidx < run0 + 4 and typeof ( P_SetMobjState ) == "function" then
    P_SetMobjState ( players [ rslot ] . mo , statenum_t . S_PLAY )
    end if
    end if
    end if

- [`src/d_net.ml:6687`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6697`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 168 — 2 occurrences</summary>

    i = 0
    while i < numn
    if _DNet_IsSeq ( nodeingame ) and i < len ( nodeingame ) and nodeingame [ i ] then
    if nettics [ i ] < lowtic then lowtic = nettics [ i ] end if
    end if
    i = i + 1

- [`src/d_net.ml:6847`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6963`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 169 — 2 occurrences</summary>

    while i < numn
    if _DNet_IsSeq ( nodeingame ) and i < len ( nodeingame ) and nodeingame [ i ] then
    if nettics [ i ] < lowtic then lowtic = nettics [ i ] end if
    end if
    i = i + 1
    end while

- [`src/d_net.ml:6848`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6964`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 170 — 2 occurrences</summary>

    if _DNet_IsSeq ( nodeingame ) and i < len ( nodeingame ) and nodeingame [ i ] then
    if nettics [ i ] < lowtic then lowtic = nettics [ i ] end if
    end if
    i = i + 1
    end while
    if lowtic == 2147483647 then lowtic = maketic end if

- [`src/d_net.ml:6849`](File-src-d-net-ml-529296669.md)
- [`src/d_net.ml:6965`](File-src-d-net-ml-529296669.md)

</details>

<details>
<summary>Clone 171 — 2 occurrences</summary>

    if typeof ( n ) != "int" or n < 0 then
    return [ ]
    end if
    a = [ ]
    i = 0
    while i < n

- [`src/d_player.ml:188`](File-src-d-player-ml-1944166105.md)
- [`src/d_player.ml:205`](File-src-d-player-ml-1944166105.md)

</details>

<details>
<summary>Clone 172 — 2 occurrences</summary>

    return [ ]
    end if
    a = [ ]
    i = 0
    while i < n
    a = a + [ v ]

- [`src/d_player.ml:189`](File-src-d-player-ml-1944166105.md)
- [`src/d_player.ml:206`](File-src-d-player-ml-1944166105.md)

</details>

<details>
<summary>Clone 173 — 2 occurrences</summary>

    end if
    a = [ ]
    i = 0
    while i < n
    a = a + [ v ]
    i = i + 1

- [`src/d_player.ml:190`](File-src-d-player-ml-1944166105.md)
- [`src/d_player.ml:207`](File-src-d-player-ml-1944166105.md)

</details>

<details>
<summary>Clone 174 — 2 occurrences</summary>

    a = [ ]
    i = 0
    while i < n
    a = a + [ v ]
    i = i + 1
    end while

- [`src/d_player.ml:191`](File-src-d-player-ml-1944166105.md)
- [`src/d_player.ml:208`](File-src-d-player-ml-1944166105.md)

</details>

<details>
<summary>Clone 175 — 2 occurrences</summary>

    i = 0
    while i < n
    a = a + [ v ]
    i = i + 1
    end while
    return a

- [`src/d_player.ml:192`](File-src-d-player-ml-1944166105.md)
- [`src/d_player.ml:209`](File-src-d-player-ml-1944166105.md)

</details>

<details>
<summary>Clone 176 — 2 occurrences</summary>

    while i < n
    a = a + [ v ]
    i = i + 1
    end while
    return a
    end function

- [`src/d_player.ml:193`](File-src-d-player-ml-1944166105.md)
- [`src/d_player.ml:210`](File-src-d-player-ml-1944166105.md)

</details>

<details>
<summary>Clone 177 — 2 occurrences</summary>

    end if
    if typeof ( V_DrawBlock ) == "function" and typeof ( wipe_scr_start ) == "bytes" then
    V_DrawBlock ( x , y , 0 , width , height , wipe_scr_start )
    end if
    return 0
    end function

- [`src/f_wipe.ml:346`](File-src-f-wipe-ml-1921092045.md)
- [`src/f_wipe.ml:365`](File-src-f-wipe-ml-1921092045.md)

</details>

<details>
<summary>Clone 178 — 2 occurrences</summary>

    dst [ row ] = f
    dst [ row + 1 ] = f
    dst [ row + 2 ] = f
    row = row + dw
    dst [ row ] = f
    dst [ row + 1 ] = f

- [`src/hdwad_builder.ml:1154`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1158`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 179 — 2 occurrences</summary>

    dst [ row + 1 ] = f
    dst [ row + 2 ] = f
    row = row + dw
    dst [ row ] = f
    dst [ row + 1 ] = f
    dst [ row + 2 ] = f

- [`src/hdwad_builder.ml:1155`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1159`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 180 — 2 occurrences</summary>

    images = images + [ UP_XbrzScaleIndexed ( img , scale , pal ) ]
    end if
    UP_ReportProgress ( 1 )
    i = i + 1
    end while
    return images

- [`src/hdwad_builder.ml:1478`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1585`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 181 — 3 occurrences</summary>

    end if
    UP_ReportProgress ( 1 )
    i = i + 1
    end while
    return images
    end function

- [`src/hdwad_builder.ml:1479`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1509`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1586`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 182 — 2 occurrences</summary>

    UP_WriteU32 ( packageBytes , dir + 0 , img . kind )
    nameBytes = bytes ( img . name )
    n = len ( nameBytes )
    if n > 8 then n = 8 end if
    j = 0
    while j < n

- [`src/hdwad_builder.ml:1664`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1821`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 183 — 2 occurrences</summary>

    nameBytes = bytes ( img . name )
    n = len ( nameBytes )
    if n > 8 then n = 8 end if
    j = 0
    while j < n
    packageBytes [ dir + 4 + j ] = nameBytes [ j ]

- [`src/hdwad_builder.ml:1665`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1822`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 184 — 2 occurrences</summary>

    n = len ( nameBytes )
    if n > 8 then n = 8 end if
    j = 0
    while j < n
    packageBytes [ dir + 4 + j ] = nameBytes [ j ]
    j = j + 1

- [`src/hdwad_builder.ml:1666`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1823`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 185 — 2 occurrences</summary>

    if n > 8 then n = 8 end if
    j = 0
    while j < n
    packageBytes [ dir + 4 + j ] = nameBytes [ j ]
    j = j + 1
    end while

- [`src/hdwad_builder.ml:1667`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1824`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 186 — 2 occurrences</summary>

    j = 0
    while j < n
    packageBytes [ dir + 4 + j ] = nameBytes [ j ]
    j = j + 1
    end while
    UP_WriteU32 ( packageBytes , dir + 12 , img . width )

- [`src/hdwad_builder.ml:1668`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1825`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 187 — 2 occurrences</summary>

    while j < n
    packageBytes [ dir + 4 + j ] = nameBytes [ j ]
    j = j + 1
    end while
    UP_WriteU32 ( packageBytes , dir + 12 , img . width )
    UP_WriteU32 ( packageBytes , dir + 16 , img . height )

- [`src/hdwad_builder.ml:1669`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1826`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 188 — 2 occurrences</summary>

    packageBytes [ dir + 4 + j ] = nameBytes [ j ]
    j = j + 1
    end while
    UP_WriteU32 ( packageBytes , dir + 12 , img . width )
    UP_WriteU32 ( packageBytes , dir + 16 , img . height )
    UP_WriteU32 ( packageBytes , dir + 20 , img . xoffset )

- [`src/hdwad_builder.ml:1670`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1827`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 189 — 2 occurrences</summary>

    j = j + 1
    end while
    UP_WriteU32 ( packageBytes , dir + 12 , img . width )
    UP_WriteU32 ( packageBytes , dir + 16 , img . height )
    UP_WriteU32 ( packageBytes , dir + 20 , img . xoffset )
    UP_WriteU32 ( packageBytes , dir + 24 , img . yoffset )

- [`src/hdwad_builder.ml:1671`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1828`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 190 — 2 occurrences</summary>

    end while
    UP_WriteU32 ( packageBytes , dir + 12 , img . width )
    UP_WriteU32 ( packageBytes , dir + 16 , img . height )
    UP_WriteU32 ( packageBytes , dir + 20 , img . xoffset )
    UP_WriteU32 ( packageBytes , dir + 24 , img . yoffset )
    UP_WriteU32 ( packageBytes , dir + 28 , img . flags )

- [`src/hdwad_builder.ml:1672`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1829`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 191 — 2 occurrences</summary>

    UP_WriteU32 ( packageBytes , dir + 12 , img . width )
    UP_WriteU32 ( packageBytes , dir + 16 , img . height )
    UP_WriteU32 ( packageBytes , dir + 20 , img . xoffset )
    UP_WriteU32 ( packageBytes , dir + 24 , img . yoffset )
    UP_WriteU32 ( packageBytes , dir + 28 , img . flags )
    UP_WriteU32 ( packageBytes , dir + 32 , curData )

- [`src/hdwad_builder.ml:1673`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1830`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 192 — 2 occurrences</summary>

    UP_WriteU32 ( packageBytes , dir + 16 , img . height )
    UP_WriteU32 ( packageBytes , dir + 20 , img . xoffset )
    UP_WriteU32 ( packageBytes , dir + 24 , img . yoffset )
    UP_WriteU32 ( packageBytes , dir + 28 , img . flags )
    UP_WriteU32 ( packageBytes , dir + 32 , curData )
    UP_WriteU32 ( packageBytes , dir + 36 , dataSize )

- [`src/hdwad_builder.ml:1674`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1831`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 193 — 2 occurrences</summary>

    UP_WriteU32 ( packageBytes , dir + 20 , img . xoffset )
    UP_WriteU32 ( packageBytes , dir + 24 , img . yoffset )
    UP_WriteU32 ( packageBytes , dir + 28 , img . flags )
    UP_WriteU32 ( packageBytes , dir + 32 , curData )
    UP_WriteU32 ( packageBytes , dir + 36 , dataSize )
    curData = curData + dataSize

- [`src/hdwad_builder.ml:1675`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1832`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 194 — 2 occurrences</summary>

    n = len ( nameBytes )
    if n > 8 then n = 8 end if
    j = 0
    while j < n
    packageBytes [ dir + 8 + j ] = nameBytes [ j ]
    j = j + 1

- [`src/hdwad_builder.ml:1777`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1800`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 195 — 2 occurrences</summary>

    if n > 8 then n = 8 end if
    j = 0
    while j < n
    packageBytes [ dir + 8 + j ] = nameBytes [ j ]
    j = j + 1
    end while

- [`src/hdwad_builder.ml:1778`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1801`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 196 — 2 occurrences</summary>

    j = 0
    while j < n
    packageBytes [ dir + 8 + j ] = nameBytes [ j ]
    j = j + 1
    end while
    curData = curData + dataSize

- [`src/hdwad_builder.ml:1779`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1802`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 197 — 2 occurrences</summary>

    while j < n
    packageBytes [ dir + 8 + j ] = nameBytes [ j ]
    j = j + 1
    end while
    curData = curData + dataSize
    i = i + 1

- [`src/hdwad_builder.ml:1780`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1803`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 198 — 2 occurrences</summary>

    packageBytes [ dir + 8 + j ] = nameBytes [ j ]
    j = j + 1
    end while
    curData = curData + dataSize
    i = i + 1
    end while

- [`src/hdwad_builder.ml:1781`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:1804`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 199 — 2 occurrences</summary>

    if typeof ( cache ) == "array" and key >= 0 and key < len ( cache ) then
    cache [ key ] = d
    rkey = b * 256 + a
    if rkey >= 0 and rkey < len ( cache ) then cache [ rkey ] = d end if
    end if
    return d

- [`src/hdwad_builder.ml:532`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:660`](File-src-hdwad-builder-ml-980370789.md)

</details>

<details>
<summary>Clone 200 — 2 occurrences</summary>

    cache [ key ] = d
    rkey = b * 256 + a
    if rkey >= 0 and rkey < len ( cache ) then cache [ rkey ] = d end if
    end if
    return d
    end function

- [`src/hdwad_builder.ml:533`](File-src-hdwad-builder-ml-980370789.md)
- [`src/hdwad_builder.ml:661`](File-src-hdwad-builder-ml-980370789.md)

</details>


## Definitions

- **Cognitive complexity:** decision complexity weighted by nesting; logical `and`/`or` operators add one.
- **Cyclomatic complexity:** one plus decisions from conditions, loops, switch cases, and logical `and`/`or` operators.
- **Documentation coverage:** percentage of documented API summaries, parameter contracts, fields, constants, globals, and enum variants. Empty categories report 100% and do not affect the overall ratio.
- **Halstead metrics:** operators and operands are counted from MiniLang lexical tokens. Estimated defects are volume divided by 3,000.
- **Maintainability index:** normalized 0–100 index based on Halstead volume, cyclomatic complexity, and source lines. Project MI is source-line weighted across files.
- **SLOC:** non-empty lines containing MiniLang tokens after conditional preprocessing; comment-only lines are excluded.
