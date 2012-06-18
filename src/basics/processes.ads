-------------------------------------------------------------------------------
--   Copyright 2012 Julian Schutsch
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
--   25.Feb 2012 Julian Schutsch
--     - Original version

-- Reason for implementation
--   Executing programs without attaching them to the executing program is
--   not specified in the Ada standard library.

pragma Ada_2005;

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
private With ByteOperations;
with Basics; use Basics;
with Processes_Plattform;

package Processes is

   FailedExecute      : Exception;
   ExecutableNotFound : Exception;
   FailedToCreatePipe : Exception;

   CurrentPathPrefix: constant Unbounded_String:=Processes_Plattform.CurrentPathPrefix;

   type OnMessage_Access is
     access procedure
       (CallBackObject : AnyObject_ClassAccess;
        Message        : Unbounded_String);

   type Process_Public is new AnyObject_Type with
      record
         CallBackObject : AnyObject_ClassAccess;
         OnMessage      : OnMessage_Access;
      end record;
   type Process_Type is new Process_Public with private;

   procedure Execute
     (Item        : access Process_Type;
      ProgramName : Unbounded_String;
      Arguments   : Unbounded_String);

   procedure Kill
     (Item : access Process_Type);

private
   use ByteOperations;

   type Process_Type is new Process_Public with
      record
         P                  : Processes_Plattform.Processes_Type;
         CharacterBuffer    : CharacterBuffer_Type(1024);
         Buffer             : ByteArray_Access:=null;
      end record;
   type Process_Access is access all Process_Type;

end Processes;
