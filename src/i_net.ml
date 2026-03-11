/*
  Copyright 2026 Nils Kopal

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  Script: i_net.ml
  Purpose: Implements platform integration for input, timing, video, audio, and OS services.
*/
import i_system
import d_event
import d_net
import m_argv
import doomstat

/*
* Function: I_InitNetwork
* Purpose: Initializes state and dependencies for the platform layer.
*/
function I_InitNetwork()

  if typeof(D_NetInitSinglePlayer) == "function" then
    D_NetInitSinglePlayer()
  end if
end function

/*
* Function: I_NetCmd
* Purpose: Implements the I_NetCmd routine for the platform layer.
*/
function I_NetCmd()

end function

/*
* Function: UDPsocket
* Purpose: Implements the UDPsocket routine for the engine module behavior.
*/
function UDPsocket()
  return -1
end function

/*
* Function: BindToLocalPort
* Purpose: Implements the BindToLocalPort routine for the engine module behavior.
*/
function BindToLocalPort(sock, port)
  sock = sock
  port = port
  return false
end function

/*
* Function: PacketSend
* Purpose: Implements the PacketSend routine for the engine module behavior.
*/
function PacketSend(sock, node, data, length)
  sock = sock
  node = node
  data = data
  length = length
  return false
end function

/*
* Function: PacketGet
* Purpose: Reads or updates state used by the engine module behavior.
*/
function PacketGet(sock, nodeOut, dataOut, lengthOut)
  sock = sock
  if typeof(nodeOut) == "array" and len(nodeOut) > 0 then nodeOut[0] = -1 end if
  if typeof(lengthOut) == "array" and len(lengthOut) > 0 then lengthOut[0] = 0 end if
  dataOut = dataOut
  return false
end function

/*
* Function: GetLocalAddress
* Purpose: Reads or updates state used by the engine module behavior.
*/
function GetLocalAddress()
  return "127.0.0.1"
end function



