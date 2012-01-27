-------------------------------------------------------------------------------
--   Copyright 2011 Julian Schutsch
--
--   This file is part of ParallelSim
--
--   ParallelSim is free software: you can redistribute it and/or modify
--   it under the terms of the GNU Affero General Public License as published
--   by the Free Software Foundation, either version 3 of the License, or
--   (at your option) any later version.
--
--   ParallelSim is distributed in the hope that it will be useful,
--   but WITHOUT ANY WARRANTY; without even the implied warranty of
--   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--   GNU Affero General Public License for more details.
--
--   You should have received a copy of the GNU Affero General Public License
--   along with ParallelSim.  If not, see <http://www.gnu.org/licenses/>.
-------------------------------------------------------------------------------

-- Revision History
--   27.Jan 2012 Julian Schutsch
--     - Original version
pragma Ada_2012;

with BSDSockets.Thin;
with Interfaces.C;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body BSDSockets is
   use type Interfaces.C.int;

   function Socket
     (AddressFamily : AddressFamilyEnum;
      SocketType    : SocketTypeEnum;
      Protocol      : ProtocolEnum) return SocketID is
      Value : Interfaces.C.int;
   begin
      Value:=BSDSockets.Thin.Socket(AddressFamily,
                                    SocketType,
                                    Protocol);
      if Value=-1 then
         raise FailedToCreateSocket;
      end if;
      return SocketID(Value);
   end Socket;

   procedure Initialize is
   begin
      BSDSockets.Thin.Initialize;
   end Initialize;

   procedure Finalize is
   begin
      BSDSockets.Thin.Finalize;
   end Finalize;

end BSDSockets;