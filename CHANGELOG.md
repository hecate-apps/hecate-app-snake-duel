# Changelog

## [0.3.1] - 2026-03-17

### Fixed
- Fix match startup crash: unlink supervisor from plugin loader's temporary init process to prevent supervision tree from dying when init process exits

## [0.3.0] - 2026-03-17

### Changed
- Update hecate_sdk from ~> 0.1 to 0.6.1 (pinned)
- Sync all version sources to 0.3.0 (manifest.json, .app.src files, callback module, rebar.config, package.json)
- Update package.sh to include .app files alongside .beam files (matches Martha reference)
- Update min_sdk_version to 0.6.0

### Added
- scripts/bump-version.sh for automated version synchronization

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
