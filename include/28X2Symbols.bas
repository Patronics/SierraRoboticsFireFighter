#include "sharedSymbols.bas"

#picaxe 28x2

symbol tableID = "S"

symbol j11a=A.1
symbol j11b=A.0

symbol j12a=B.5
symbol j12b=B.7

symbol j13a=B.4
symbol j13b=B.6

symbol j14a=B.3
symbol j14b=B.2

symbol j15a=B.1
symbol j15b=B.0

symbol j16a=C.7
symbol j16b=C.6

symbol j17a=C.5
symbol j17b=C.2

symbol j18a=A.2
symbol j18b=C.1

symbol j19a=A.2
symbol j19b=C.0


''''''SYMBOLS FOR MASTER (to avoid syntax error when using slavecompile
''otherwise unused
symbol SuggestedBehavior=b20
symbol SuggestionPriority=b21
symbol SuggestionIntensity=b22

symbol possibleSuggestedBehavior=argb1
symbol possibleSuggestionPriority=argb2
symbol possibleSuggestionIntensity=argb3



symbol rightDir = b36 
symbol rightAngle = b37 
symbol rightDistance = b38

symbol frontDir = b40
symbol frontAngle = b41
symbol frontDistance = b42


'''''END OF MASTER SYMBOLS
