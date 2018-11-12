#include "28x2symbols.bas"

hi2csetup i2cslave, slaveaddr

main:


slavetimestamp=slavetimestamp+1
put slavetimestamp_ptr, slavetimestamp
goto main