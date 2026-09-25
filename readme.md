# PhotoMode — The Forever Winter

Free camera and photo mode for The Forever Winter.

[Fixed Based on the original SpectatorToggle by terraru and Fekete Imre (imi).](https://www.nexusmods.com/theforeverwinter/mods/65)

---

## Requirements

1. **Signature Bypass** — [Download from Nexus](https://www.nexusmods.com/theforeverwinter/mods/57)
2. **UE4SS v3.0.1** — [Download from GitHub](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest)

---

## Installation

1. Extract **Signature Bypass** into:
   `\The Forever Winter\Windows\ForeverWinter\Binaries\Win64\`
2. Extract **UE4SS** into:
   `\The Forever Winter\Windows\ForeverWinter\Binaries\Win64\`
3. Copy the **PhotoMode** folder into:
   `\The Forever Winter\Windows\ForeverWinter\Binaries\Win64\ue4ss\Mods\`
4. Enable in UE4SS `mods.txt` by adding:
   ```
   PhotoMode : 1
   ```
5. Enable in UE4SS `mods.json` by adding:
   ```json
   {
     "mod_name": "PhotoMode",
     "mod_enabled": true
   },
   ```

Done.

---

## Disable

In `mods.txt` change:

```
PhotoMode : 0
```

In `mods.json` change:

```json
{
  "mod_name": "PhotoMode",
  "mod_enabled": false
},
```

---

## Uninstall

1. Remove the **PhotoMode** folder from `ue4ss\Mods\`
2. In `mods.txt` remove:
   ```
   PhotoMode : 1
   ```
3. In `mods.json` remove:
   ```json
   {
     "mod_name": "PhotoMode",
     "mod_enabled": true
   },
   ```

---

## Usage

* First toggle between **Spectator Mode** and player cam with **F8**.
* While in **Spectator Mode** enable **Photo Mode** with **N** on your keyboard.
* To get out of photomode press **N** again then press **F8** to get back to game.

---

## Changing Default Keybind

Spectator mode keybind can be remapped in script by changing `F8` in `main.lua` (in `PhotoMode/Scripts` folder) to your preferred key (use notepad++ to open main.lua).

Photo mode keybind can be remapped in script by changing `N` in `main.lua` (in `PhotoMode/Scripts` folder) to your preferred key (use notepad++ to open main.lua).

**Original keybind (Spectator mode):**

```lua
RegisterKeyBind(Key.F8, {}, function()
```

**Original keybind (Photo mode):**

```lua
RegisterKeyBind(Key.N, {}, function()
```

**Example of changed keybind:**

```lua
RegisterKeyBind(Key.P, {}, function()
```

---

## Valid Key Names

<details>
<summary>Click to expand full key list</summary>

```
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12

ZERO ONE TWO THREE FOUR FIVE SIX SEVEN EIGHT NINE

NUM_ZERO NUM_ONE NUM_TWO NUM_THREE NUM_FOUR NUM_FIVE
NUM_SIX NUM_SEVEN NUM_EIGHT NUM_NINE

LEFT_MOUSE_BUTTON RIGHT_MOUSE_BUTTON MIDDLE_MOUSE_BUTTON

SPACE TAB RETURN ESCAPE BACKSPACE DEL INS HOME END PAGE_UP PAGE_DOWN

LEFT_ARROW UP_ARROW RIGHT_ARROW DOWN_ARROW

CAPS_LOCK NUM_LOCK SCROLL_LOCK PAUSE PRINT_SCREEN
```

</details>
