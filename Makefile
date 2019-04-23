.PHONY: bench release test

VERSION = $(shell cat version.go | sed -n 's/.*const Version = "\(.*\)"/\1/p')

fixtures/fileset.pb: fixtures/*.proto
	$(info Generating fixtures...)
	@cd fixtures && go generate

bench:
	go test -bench=.

test: fixtures/fileset.pb
	@go test -race -cover ./ ./utils

release:
	@echo Releasing v${VERSION}...
	git add CHANGELOG.md version.go
	git commit -m "Bump version to v${VERSION}"
	git tag -m "Version ${VERSION}" "v${VERSION}"
	git push && git push --tags
