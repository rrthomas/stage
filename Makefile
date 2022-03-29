pdf:
	latexmk stage-documentation

dist: pdf
	cd .. && zip -r stage.zip stage --exclude=stage/.git\* --exclude=.gitignore --exclude=*.cpt --exclude=*.log --exclude=*.aux --exclude=*.fdb_latexmk --exclude=*.fls
