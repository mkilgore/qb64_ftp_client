'@@
'@file signal_object_bi
'@author DSMan195276
'@date   May 6th, 2013
'@@

@if not defined __GUI_OBJECTS_SIGNAL_OBJECT_BI__
@define __GUI_OBJECTS_SIGNAL_OBJECT_BI__

'$include:'ref_object.bi'

'@@
'@Object
'@Private
'@Brief Represents a single signal and it's connections in a list of signals
'
'@@
TYPE GUI_signal_Object
  signal_name AS MEM_string
  id AS _UNSIGNED LONG
  first_connection AS _OFFSET
  next_signal as _OFFSET
END TYPE

TYPE GUI_signal_connection
  notify_proc AS @PROC
  id as _UNSIGNED LONG
  dat AS _OFFSET
  next_connection AS _OFFSET 'GUI_signal_connection
END TYPE

'@@
'@Object
'@Inherets GUI_ref_object
'@Brief Object that handles signals and connections
'
'@Member        ref --> GUI_ref_object
'@PrivateMember next_connection_id --> The next connection ID number to hand out
'@PrivateMember next_signal_id --> The next signal ID number to hand out
'@Member        first_signal --> Points to a GUI_Signal_Object that is the start
'               of the chain of GUI_Signal_Objects
'@@
TYPE GUI_signal
  ref as GUI_ref_object
  next_connection_id AS _UNSIGNED LONG
  next_signal_id AS _UNSIGNED LONG
  first_signal as _OFFSET 'GUI_signal
END TYPE

@endif
