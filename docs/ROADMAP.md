# Roadmap

**Status: v1.0 shipped, project closed.** Everything under "Future ideas" was deliberately left out of v1.0.

## Shipped in v1.0
- Production loop with defects, scrap and a loading zone
- Truck with capacity that leaves and returns on a travel timer
- Three scaling upgrades: quality, speed and truck capacity
- Scaling defect penalty and a game over screen with final stats
- Unified color palette, top-bar HUD, restartable game over screen
- Builds for macOS (universal) and Windows (x86_64)

## Where to pick it up
If the project is ever reopened, the best first steps are balance tuning and the truck-timer idea, since both make the existing upgrades matter more without adding new systems.

## Future ideas

### Core improvements
Improvements to existing systems without changing the core loop.
- Improve game balance (cost vs reward tuning)
- Make the speed upgrade more impactful

### Gameplay additions
New mechanics that enhance the current gameplay loop.
- Multiple product types
- Events that force decisions
  - **Contract:** produce a certain amount of products within a given time. A tier 1 contract might require upgrading production speed 3 times from the default, a tier 2 contract 10 times. Contracts could award extra money.
- Demand

  | Demand | Effect |
  |---|---|
  | LOW | Lower price, less forgiving |
  | NORMAL | Baseline |
  | HIGH | Higher price, bonus rewards |

- A buffer upgrade to avoid scrapping

### Systems expansion
Larger systems that expand the scope of the game.
- Multiple machines
- Input resources (basic supply chain) with different materials

### Notes & ideas
- Reputation score: as reputation increases, the penalty for selling defects increases.
- Holding a buffer causes a balance decrease every 10 seconds.
- Make the truck leave either when a timer runs out or when it is full, whichever hits first. This gives meaning to production speed.
- Upgrades to add machines and conveyor belts could eventually unlock a top-down view for managing large-scale production.
