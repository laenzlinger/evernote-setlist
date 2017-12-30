all: compile

compile: CreateSetList.applescript
	osacompile -o CreateSetList.app CreateSetList.applescript

install: compile
	cp -r CreateSetList.app /Applications/CreateSetList.app

clean:
	-rm -r CreateSetList.app
