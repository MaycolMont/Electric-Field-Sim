# AGENTS.md — Electric Field Simulator

## Project overview

Godot 4.6 project in GDScript (ignore `ElecField.csproj` — no C# code, all `.gd`). GL Compatibility renderer. Main scene: `scenes/editor.tscn`. Open via the Godot editor's project manager — no standalone build exists yet.

## Architecture

| File | Role |
|---|---|
| `scripts/editor.gd` | Main editor scene controller; "Add Electron/Proton" buttons |
| `scripts/field.gd` | Simulation core: grid of field vectors, superposition calculation, particle management |
| `scripts/particle.gd` | Charged particle (proton sprite = positive, electron sprite = negative) |
| `scripts/sim_object_2d.gd` | Base class — draggable with left-click toggle (MOVE/FIXED), right-click to delete |
| `scripts/MVector.gd` | Electric field vector display (RayCast2D + Line2D), color-coded by magnitude (red→green) |

## Key mechanics

- The electric field uses a simplified constant `9 * 10**3` (not `9 * 10**9`).
- Vectors only render when at least one particle exists; hidden when last particle removed.
- Field recalculated every frame while any particle is in MOVE state.
- `editor.tscn` → `Field` node (Control) → `add_particle(±30)`. Default charge: ±30.

## Input

- **Left click** on an object: toggle between draggable (MOVE) and fixed
- **Right click** on an object: delete it (calls `queue_free`)
- Window is non-resizable and always-on-top.

## Tests

No test framework exists. `scripts/test.gd` is a sandbox scene (`scenes/test.tscn`) — not automated tests.

## Style

- Code and README are in Spanish.
- No formatter, linter, or typechecker config present.
- GDScript conventions: `snake_case` for variables/functions, PascalCase for class names and enums.

## How to run

Open the project root in the Godot 4.6 editor and press F5 (or click "Play Scene" on `scenes/editor.tscn`).
