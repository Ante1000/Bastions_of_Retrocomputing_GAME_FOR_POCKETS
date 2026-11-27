# BASTIONS OF RETROCOMPUTING - Sharp PC-E500(S)

A strategy game for the **Sharp PC-E500(S)** (4 lines of 40 characters) based on a similar game for Sharp PC-1500
[Bastions of Retrocomputing](https://github.com/Ante1000/Bastions_of_Retrocomputing_GAME_FOR_POCKETS/tree/main/PC1500),
adapted from the [PC-1600](https://github.com/Ante1000/Bastions_of_Retrocomputing_GAME_FOR_POCKETS/tree/main/PC1600) and
[PC-1360](https://github.com/Ante1000/Bastions_of_Retrocomputing_GAME_FOR_POCKETS/tree/main/PC1360) versions.

> **Status:** runs on a real PC-E500S and in a PC-E500 simulator.
Not testet on a real PC-E500 but it should work too.
> Instructions: [PDF](instructions_v2.6-pce500s.pdf) / [DOCX](instructions_v2.6-pce500s.docx).

## Screen (40 x 4)

- line 1: `Tokens nnn` (left), mode (middle: MAIN MENU, FIGHT, BUY, SELL, RESOURCES, TAX), `RetroSt nnn` (right);
  in a fight the whole line shows `Place - nnP` (Tech Priests still active). Hidden during the title music
- lines 2 and 3: the game (messages and questions; important messages and the menus are centred)
- line 4: `Hnn Gnn Dnn Tnn` = Hackers, Gurus, Daemons, Trojans in fixed fields (a field that grows blinks);
  in a fight (from FIGHTING! on) only the forces thrown into it, centred: `(hnn gnn dnn tnn)`
- round screen, line 3: `YOU: nn  R=REINFORCE  S=SURRENDER`
  - `R=REINFORCE` appears when you have fewer fighters than the Tech Priests and still have Hackers, Daemons or Trojans
    at home. Key R moves Hackers from home to the fight, as many as there are Tech Priests (or all you have), with
    2 Daemons per Hacker and 1 Trojan per 2 Hackers (or what is available)
  - `S=SURRENDER` appears from round 2 when you have fewer fighters than the Tech Priests

## Loading through the serial port (UART, terminal)

1. Connect the serial port of the PC-E500(S) to a computer and open a terminal program there.
2. Set the same serial parameters in the terminal and on the PC-E500(S) (`OPEN "COM:..." AS #1`, see the manual; the
   CR delimiter and the end-of-file code `&H1A` are the defaults after RESET).
3. On the PC-E500(S) type `LOAD` [ENTER] (no file name: the program is loaded through the serial port) and send
   `Basic/bastions_of_retrocomputing-v2.6-pce500s.txt` from the terminal as a plain text file. If the terminal does not
   send the end-of-file code, stop the loading with the BREAK key.
4. Type `RUN`.

The listing ends with an empty `REM` line: a transfer through the serial port cuts the last line.
`...-norem.txt` is the same listing without the REM lines (needs less memory).

## Differences from the PC-1600 version

- 40 columns (`LOCATE`, `RANDOMIZE`); the texts are as on the PC-1600, only the widths changed.
- No `DIM ... * length` (strings are dynamic), no `ZZ` array: simple variables (`TK`, `ZW`, ...) are used directly.
  A variable name must not contain a BASIC keyword (e.g. `TOKENS` contains `TO`).
- `STR$` gives a blank in front of positive numbers on the PC-E500(S); the program strips it (`MID$(STR$(x),2,12)`).
- `WAIT n` is n/59 s (test: 10 x `WAIT 59` = 10 s): the pauses are converted from the PC-1600 ones.
- `BEEP` uses the same tone scale as the PC-1360 (`f = 256000 / (90 + 4 n)`), so the melodies are the converted PC-1360 ones.
- The key check on the round screen is a plain `FOR G=1 TO 50` loop (the `INKEY$` loop runs about 200 times a second).
- Line 4 prints 39 characters (the 40th column of line 4 was not tested for scrolling).

## Files

| File | Contents |
|---|---|
| `Basic/bastions_of_retrocomputing-v2.6-pce500s.txt` | the game (BASIC listing, with REM lines) |
| `Basic/bastions_of_retrocomputing-v2.6-pce500s-norem.txt` | the same without REM lines |
| `instructions_v2.6-pce500s.pdf`, `.docx` | game instructions |
| `Basic/e500s_test.txt` | test program for the PC-E500(S) BASIC (screen, strings, `RESTORE`, `WAIT`, `BEEP`, `INKEY$` speed) |
| `tools/make_wav.sh` | listing -> `bas2img` -> `bin2wav` -> tape recording (WAV), then reads it back with `wav2bin` and compares |
| `tools/*.c` | the Sharp Pocket-Tools (`bas2img`, `bin2wav`, `wav2bin`), with their own license notes |
| `wav/e500s_test_*.wav` | tape recordings of the first version of the test program; outdated (rebuild them with `tools/make_wav.sh`) |

## Tape recording (optional, not tested for the game)

```
tools/make_wav.sh Basic/bastions_of_retrocomputing-v2.6-pce500s-norem.txt wav/bastions-v2.6-pce500s.wav BASTION img
```

`gcc` compiles the tools on first use. Loading: `CLOAD "BASTION"` in PRO or RUN mode; according to the notes of the
Pocket-Tools the program has to be recompiled on the E500 series after the transfer (`TEXT` [ENTER], then `BASIC` [ENTER]).

## License

See [LICENSE](../LICENSE.txt).
