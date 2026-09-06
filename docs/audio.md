# Sound-effect volume regression

MiniDoom 2.0.4 fixes spatial sound effects becoming much quieter when their
position is updated. `I_StartSound` converted Doom's 0–15 volume to the mixer's
0–127 range, while `I_UpdateSoundParams` passed the original value through.
At volume 8 this changed the mixer input from 67 to 8. Both paths now use the
same conversion, preserving the exact PCM samples for an unchanged sound.

The map-8 distance rule also used a fixed floor of 15 from the original
127-step mixer scale. At lower slider settings, distance could increase the
volume or bypass mute. Its floor is now proportional to the selected volume
(`volume * 15 / 127`), so attenuation stays monotonic and zero stays silent.

The fixes apply to the shared Windows and Linux mixer. Original sound assets,
music playback, saved preferences and default slider settings are preserved.

## Regression fixture

`tests/fixtures/audio_unit.ml` imports the production sound stack. It compares
actual PCM buffers, including both stereo channels, before and after an update.
The deterministic cases cover all 16 slider positions, five stereo positions,
the full spatial frontend, muting an active channel, and attenuation from 0 to
1,600 map units in maps 1 and 8. A local IWAD additionally exercises every
available original DMX sound through the WAD loader and sample decoder.

Windows, using the normal compiler/IWAD discovery:

```powershell
.\tests\run_tests.ps1 -Test audio
```

For an optional device check, after building the engine:

```powershell
.\tests\cases\test_audio.ps1 -RepoRoot $PWD -Iwad C:\Games\DOOM2.WAD -ArtifactDir test-results\audio-device -Device
```

This prepares and queues a silent stereo PCM buffer on WinMM, then closes the
owned handle. It does not record audio or change system volume.

Linux, after building the native helpers into `build/linux`:

```bash
python3 ../MiniLangCompilerPy/mlc_win64.py tests/fixtures/audio_unit.ml \
  build/linux/audio_unit -I src -I ../MiniLangCompilerPy --target linux-x64
chmod +x build/linux/audio_unit
LD_LIBRARY_PATH="$PWD/build/linux${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
  ./build/linux/audio_unit /path/to/DOOM2.WAD
```

Running the fixture without an IWAD argument executes the synthetic cases only.
No IWAD or extracted original sound samples are distributed with the tests.
