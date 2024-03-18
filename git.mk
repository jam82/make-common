# file: git.mk
# desc: common git commands

# SHELL := /bin/bash

feat	?= dummy

.PHONY: git-feature git-merge-feature git-merge-dev git-prepare-release git-version git-publish

# create a feature branch
git-feature:
	@git checkout -b feature/$(feat)
	@git push -u origin feature/$(feat)

# merge feature branch into dev
git-merge-feature:
	@git checkout dev
	@git merge feature/$(feat)
	@git branch -d feature/$(feat)
	@git push -u origin dev

# merge dev into main
git-merge-dev-to-main:
	@git checkout main
	@git merge dev
	@git push -u origin main
	@git checkout dev

# prepare a release and merge dev to main
git-prepare-release:
	@git push origin dev
	@git checkout main
	@git merge dev
	@git push origin main
	@git checkout dev

# bump the version number and update the changelog
git-version:
	@git checkout main
	@semantic-release version
	@git checkout dev
	@git merge main
	@git push -u origin dev

# create a new git tag and build the distribution files
git-publish:
	@git checkout main
	@semantic-release publish
	@git push -u origin main
	@git checkout dev
	@git push -u origin dev

git-quickshot:
	@git add .
	@codegpt commit
	@git push -u origin dev
	@git checkout main
	@git merge dev
	@git push -u origin main
	@git checkout dev
