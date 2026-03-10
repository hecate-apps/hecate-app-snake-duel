# Changelog

## [0.2.2] - 2026-03-10

### Fixed
- Fix API paths for in-VM plugin routing (use relative paths, not old standalone paths)
- Fix SSE streaming to work with in-VM plugin model (route through daemon socket)
- Pass plugin name to custom element for correct SSE socket routing

## [0.2.1] - 2026-03-10

### Fixed
- Add display_name to manifest (card was showing technical name)
- Fix group_icon to use valid gemoji shortcode (video_game instead of gamepad-2)
- Fix tar.gz packaging to produce flat structure (ebin/ at root, not nested)
- Use package.sh script matching scribe's reference implementation

## [0.1.0] - 2026-02-22

### Added
- Initial extraction from hecate-daemon (run_snake_duel + query_snake_duel)
- Snake Duel game engine (server-side)
- AI opponent with configurable asshole factor
- Live match streaming via SSE
- Match history and leaderboard (SQLite read model)
- Web Component frontend (snake-duel-studio tag)
