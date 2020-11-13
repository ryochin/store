all: compile upload

compile:
	cd store && ruby ./compile.rb

upload:
	scp -C store.html ryo@minerva.aquahill.net:/app/static/aquahill/store.html
