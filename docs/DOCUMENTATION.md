# Documentation

## Core loop

1. Start production
2. Products are created over time
3. Products may be defective
4. Truck collects products (or the loading zone scraps them)
5. Player earns/loses money
6. Upgrade systems to improve performance

## Systems

### Machine (`Machine.gd`)
- Produces a product every `production_speed` seconds (starts at 3s) using a Timer.
- Defect chance starts at 90% and is rolled with the level's random number generator.
- Owns the quality and speed upgrades and counts produced products.

### Product (`Product.gd`)
- Moves right along the conveyor.
- Base value 10, production cost 6, scrap value 2.
- Defective products sell for `base value − current defect penalty`, show a defect icon and a red tint.

### Loading zone (`Loadingzone.gd`)
- Area at the end of the conveyor. On contact it loads the product onto the truck if the truck can accept it, otherwise tells the level to scrap it. The product is removed either way.

### Truck (`Truck.gd`)
- Capacity starts at 4.
- States: `AVAILABLE` (accepts products) and `AWAY` (driving off, timer running).
- When load reaches capacity it leaves for 8 seconds, then resets to its start position and becomes available again.

### Economy (`Level.gd`)
- Starting balance is 12.
- Every product that is sold or scrapped changes the balance by `value − production cost`. A scrapped product is a net loss (2 − 6 = −4).
- The defect penalty starts at 2 and multiplies by 1.5 for every 10 products produced.
- The game ends when balance < 0. The highest balance reached is tracked for the stats screen.

### Upgrades
| Upgrade | Effect per level | Base cost | Cost growth |
|---|---|---|---|
| Quality | −0.1 defect chance | 10 | ×1.2 |
| Speed | −0.25s production time (minimum 0.2s) | 10 | ×1.2 |
| Capacity | +1 truck capacity | 20 | ×1.3 |

Flow: the UI emits an upgrade signal, the Level checks `can_afford`, deducts the cost and calls the upgrade function, and the Machine or Truck applies the effect and emits `*_upgrade_applied` so the Level can refresh the button text. The upgraded object owns all logic related to its behavior.

## Architecture

- `Level.gd`: game orchestration, balance and game state (`IDLE`, `RUNNING`, `GAME_OVER`)
- `Machine.gd`: production logic and upgrades
- `Truck.gd`: capacity and transport
- `Product.gd`: product properties
- `Loadingzone.gd`: routes products to the truck or the scrap bin
- `UiFacade.gd`: display and feedback

Systems communicate primarily through signals (Godot 4). The Level connects to signals from the UI, Machine and Truck in `_ready()`.

Render order: conveyor belt (z 0), machine (z 1), products (z 2).

### UI structure (`Scenes/UI/UIFacade.tscn`)

The UI is a separate `CanvasLayer` outside the level scene. The Level only talks to it through the facade's functions and signals.

- **HUD:** top bar with Balance, Truck load and Defect penalty; START / STOP buttons on the machine; three upgrade buttons along the bottom; a floating +/− score popup when a product is sold or scrapped.
- **GameOver:** full-screen translucent red overlay with a duplicate START button, and a "Final Stats" panel built in code from the list of stats the Level provides (highscore, produced, speed, quality, load capacity).

## Design

### Color palette
- **Background:** soft warm gray/beige `#f2efe8`
- **Primary (UI / machine):** muted blue `#7aa6c2`
- **Dark blue (UI text & borders):** `#2d4b5f`
- **Accent (interaction):** soft teal `#6fc2b0`
- **Good (profit):** soft green `#7bc96f`
- **Bad (defect / game over):** soft red `#e57373`
- **Neutral (objects):** warm gray `#c8c3b9`
