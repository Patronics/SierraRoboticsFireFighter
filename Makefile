

preprocess: fireFighter.bas include/40X2Symbols.bas
	./picaxepreprocess.py -i fireFighter.bas


clean:
	rm compiled.bas