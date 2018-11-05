#include "28x2symbols.bas"

main:


slavetimestamp=slavetimestamp+1
put slavetimestamp_ptr, slavetimestamp
goto main