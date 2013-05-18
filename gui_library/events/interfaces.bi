
!!if not defined __GUI_EVENTS_INTERFACES_BI__
!!define __GUI_EVENTS_INTERFACES_BI__

TYPE GUI_event_interface @interface
  proc1 AS @SUB(_OFFSET)
  proc2 AS @SUB(_OFFSET, _OFFSET)
  proc3 AS @FUNCTION(_OFFSET, LONG) AS LONG
END TYPE

!!endif

