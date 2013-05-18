'@@
'@file signal_object_bi
'@author DSMan195276
'@date   May 6th, 2013
'@@

!!if not defined __OBJ_OBJECTS_SIGNAL_OBJECT_BI__
!!define __OBJ_OBJECTS_SIGNAL_OBJECT_BI__

'$include:'ref_object.bi'

'@@
'@Object
'@Private
'@Brief Represents a single signal and it's connections in a list of signals
'
'@@
TYPE OBJ_signal_node
  signal_name       AS MEM_string
  id AS _UNSIGNED LONG
  first_connection AS _OFFSET
  next_signal as _OFFSET
END TYPE

'@@
'@Object
'@Private
'@Brief Represents a single connection to a signal in a chain of connections
'
'@@

TYPE OBJ_signal_connection_node
  notify_proc AS @PROC
  id as _UNSIGNED LONG
  dat AS _OFFSET
  next_connection AS _OFFSET 'GUI_signal_connection
END TYPE

'@@
'@Object
'@Inherets OBJ_ref_object
'@Brief Object that handles signals and connections
'
'@Member        ref --> GUI_ref_object
'@PrivateMember next_connection_id --> The next connection ID number to hand out
'@PrivateMember next_signal_id --> The next signal ID number to hand out
'@Member        first_signal --> Points to a GUI_Signal_nodes that is the start
'               of the chain of GUI_Signal_nodes
'@@
TYPE OBJ_signal
  parent as OBJ_ref_object
  next_connection_id AS _UNSIGNED LONG
  next_signal_id AS _UNSIGNED LONG
  first_signal as _OFFSET 'GUI_signal_node
END TYPE

TYPE OBJ_signal_class @class
  parent_class AS OBJ_ref_Object_class

  disconnect_signal         AS @SUB(_OFFSET, LONG)
  disconnect_connection     AS @SUB(_OFFSET, LONG)

  get_signal_id             AS @FUNCTION(_OFFSET, STRING) AS LONG
  connect_to_signal         AS @FUNCTION(_OFFSET, STRING, @PROC, _OFFSET) AS LONG
  connect_to_signal_with_id AS @FUNCTION(_OFFSET, LONG, @PROC, _OFFSET) AS LONG
  add_new_signal                AS @FUNCTION(_OFFSET, STRING) AS LONG

  emit                      AS @SUB(_OFFSET, STRING)
END TYPE

!!endif
