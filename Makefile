.PHONY: install md

install:
	npm install -g swagger-markdown

md:
	swagger-markdown -i swagger.yaml -o swagger.md
