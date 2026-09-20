# Supply Chain Game

A simple supply chain / production game where you produce goods, manage defects, and spend your earnings on upgrades to avoid bankruptcy. Built with Godot 4.7 (GDScript).

## Download

Grab the latest build from the [Releases page](https://github.com/dkajo/supply-chain-game/releases/latest):

| Platform | File | Notes |
|---|---|---|
| Windows (64-bit) | `SupplyChainGame-Windows.zip` | Unzip and double-click `SupplyChainGame.exe`. If SmartScreen warns, choose *More info → Run anyway*. |
| macOS (Intel & Apple Silicon) | `SupplyChainGame-macOS.zip` | Unzip and move the app anywhere. The app is not notarized, so the first time **right-click → Open** (or *System Settings → Privacy & Security → Open Anyway*). |

The builds are unsigned, so your OS will warn on first launch.

## How to play

1. Press **START**. The machine begins producing a product every few seconds.
2. Each product may be defective, and defects sell for less.
3. Products ride the conveyor into the loading zone. If the truck is waiting and has room, the product is loaded and sold. Otherwise it is scrapped.
4. When the truck is full it drives away, then returns empty.
5. Spend your balance on upgrades (quality, speed, truck capacity) to stay ahead of the growing defect penalty.
6. The game ends when your balance drops below 0. The game over screen shows your stats and lets you try again.

## Run from source

1. Install [Godot 4.7](https://godotengine.org/download) (standard, non-.NET build).
2. Clone this repo and open `project.godot` in the Godot project manager.
3. Press **F5**. The main scene is `Scenes/level.tscn`.

## Export builds

1. In Godot: *Editor → Manage Export Templates → Download and Install* (once).
2. *Project → Export*, add a **macOS** or **Windows Desktop** preset, then **Export Project**.

`export_presets.cfg` and `builds/` are git-ignored, so presets must be recreated on a fresh clone.

## Documentation

- [Documentation](docs/DOCUMENTATION.md): systems, upgrade numbers, architecture and UI structure
- [Roadmap](docs/ROADMAP.md): what shipped in v1.0 and ideas that were left out

## Project structure

```
Assets/    Sprites and visual assets (.png, .svg, .webp)
Scripts/   Game logic (.gd)
Scenes/    Game scenes (.tscn)
  UI/      UI scenes (HUD, game over, button styles)
```
