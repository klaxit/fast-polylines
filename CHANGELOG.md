
# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/).
This project adheres to [Semantic Versioning](http://semver.org/).


## [unreleased] —

### Added

- support for windows (#19 #23) by [@mohits]

### Changed

- Speedup calculation by avoiding calling pow(10,x) (#22) by [@mohits]

### Fixed

- move from travis to github actions

[@mohits]: https://github.com/mohits
## [2.1.0] — 2020-04-30

### Added

- A Require ptah that match the gem name (#18)

## [2.0.1] — 2020-04-02

### Fixed

- Broken behavior when approaching the chunk size limit (#16)


[unreleased]: https://github.com/klaxit/fast-polylines/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/klaxit/fast-polylines/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/klaxit/fast-polylines/compare/v2.0.0...v2.0.1
