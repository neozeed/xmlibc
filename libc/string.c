#include <ctype.h>

#define _cn (0)
#define _cw (_IS_WHITE)
#define _pn (_IS_PUNCT | _IS_PRINT  | _IS_GRAPH)
#define _sp (_IS_WHITE | _IS_PRINT)
#define _up (_IS_UPPER | _IS_PRINT  | _IS_GRAPH)
#define _xu (_IS_UPPER | _IS_XDIGIT | _IS_PRINT | _IS_GRAPH)
#define _lw (_IS_LOWER | _IS_PRINT  | _IS_GRAPH)
#define _xl (_IS_LOWER | _IS_XDIGIT | _IS_PRINT | _IS_GRAPH)
#define _nm (_IS_DIGIT | _IS_XDIGIT | _IS_PRINT | _IS_GRAPH)
#define _pr (_IS_PRINT | _IS_GRAPH)
#define nil 0

char _char_table[256] = {
/* Control code */
  _cn, _cn, _cn, _cn, _cn, _cn, _cn, _cn,
  _cn, _cw, _cw, _cw, _cw, _cw, _cn, _cn,
  _cn, _cn, _cn, _cn, _cn, _cn, _cn, _cn,
  _cn, _cn, _cn, _cn, _cn, _cn, _cn, _cn,
/* Symbol and number */
  _sp, _pn, _pn, _pn, _pn, _pn, _pn, _pn,
  _pn, _pn, _pn, _pn, _pn, _pn, _pn, _pn,
  _nm, _nm, _nm, _nm, _nm, _nm, _nm, _nm,
  _nm, _nm, _pn, _pn, _pn, _pn, _pn, _pn,
/* Upper case character */
  _pn, _xu, _xu, _xu, _xu, _xu, _xu, _up,
  _up, _up, _up, _up, _up, _up, _up, _up,
  _up, _up, _up, _up, _up, _up, _up, _up,
  _up, _up, _up, _pn, _pn, _pn, _pn, _pn,
/* Lower case character */
  _pn, _xl, _xl, _xl, _xl, _xl, _xl, _lw,
  _lw, _lw, _lw, _lw, _lw, _lw, _lw, _lw,
  _lw, _lw, _lw, _lw, _lw, _lw, _lw, _lw,
  _lw, _lw, _lw, _pn, _pn, _pn, _pn, nil,
/* EUC kanji code */
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil,
};
