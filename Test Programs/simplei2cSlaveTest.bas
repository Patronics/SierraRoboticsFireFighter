
#picaxe 28x2

hi2csetup i2cslave, 62


main:

b0=b0+1
put 1,b0
pause 500

goto main