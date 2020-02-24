pdf:
	pdflatex stage-documentation

zip: pdf
	cd .. && zip -r stage.zip stage --exclude=stage/.git\* --exclude=.gitignore --exclude=*.cpt --exclude=*.log --exclude=*.aux
