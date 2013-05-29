!!include once

'@@
'@file signal_object_bi
'@author DSMan195276
'@date   May 6th, 2013
'@@@

'@@
'@Object
'@Brief Object that handles signals and connections
'
'@PrivateMember next_connection_id --> The next connection ID number to hand out
'@PrivateMember next_signal_id --> The next signal ID number to hand out
'@Member        first_signal --> Points to a GUI_Signal_nodes that is the start
'               of the chain of GUI_Signal_nodes
'@@@

TYPE OBJ_signal_trait
  next_connection_id AS _UNSIGNED LONG
  next_signal_id AS _UNSIGNED LONG
  first_signal as _OFFSET 'GUI_signal_node
END TYPE

TYPE OBJ_signal_trait_class @class
  disconnect_signal         AS @SUB(_OFFSET, LONG)
  disconnect_connection     AS @SUB(_OFFSET, LONG)

  get_signal_id             AS @FUNCTION(_OFFSET, _OFFSET) AS LONG
  connect_to_signal         AS @FUNCTION(_OFFSET, _OFFSET, @PROC, _OFFSET) AS LONG
  connect_to_signal_with_id AS @FUNCTION(_OFFSET, LONG, @PROC, _OFFSET) AS LONG
  add_new_signal            AS @FUNCTION(_OFFSET, _OFFSET) AS LONG

  emit                      AS @SUB(_OFFSET, _OFFSET)
END TYPE

DECLARE FUNCTION OBJ_signal_trait_get_type&  ()
DECLARE SUB      OBJ_signal_trait_init       (this AS _OFFSET)
DECLARE SUB      OBJ_signal_trait_init_class (class AS _OFFSET)
DECLARE SUB      OBJ_signal_trait_destroy    (this AS _OFFSET)
DECLARE FUNCTION OBJ_SIGNAL_TRAIT_CAST%& (this as _OFFSET)
DECLARE FUNCTION OBJ_IS_SIGNAL_TRAIT& (this as _OFFSET)
