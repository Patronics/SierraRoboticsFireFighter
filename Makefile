

preprocess: fireFighter.bas include/40X2Symbols.bas
	./picaxepreprocess.py -i fireFighter.bas

compile: preprocess
	tr -d '\r' < compiled.bas > ./compilers/compiled.bas
	./compilers/c/picaxe28x2 ./compilers/compiled.bas
syntax: preprocess
	tr -d '\r' < compiled.bas > ./compilers/compiled.bas
	./compilers/c/picaxe28x2 -s ./compilers/compiled.bas

clean:
	-rm compiled.bas
	-rm compilers/compiled.bas
	-rm *.err
	-rm compilers/*.err