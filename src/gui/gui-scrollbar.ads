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
--   4.Apr 2012 Julian Schutsch
--     - Original version

pragma Ada_2005;

package GUI.ScrollBar is

   InvalidScrollBarPosition : Exception;

   type OnPositionChange_Access is
     access procedure
       (CallBackObject : AnyObject_ClassAccess);

   type ScrollBar_Private is private;
   type ScrollBar_Type is new Object_Type with
      record
         OnPositionChange : OnPositionChange_Access:=null;
         SPriv            : ScrollBar_Private;
      end record;

   type ScrollBar_Access is access all ScrollBar_Type;
   type ScrollBar_ClassAccess is access all ScrollBar_Type'Class;

   type ScrollBar_Constructor is
     access function
       (Parent : Object_ClassAccess)
        return ScrollBar_ClassAccess;

   procedure Initialize
     (Item    : ScrollBar_Access;
      Parent  : Object_ClassAccess);

   overriding
   procedure Finalize
     (Item : access ScrollBar_Type);

   function GetMin
     (Item : access ScrollBar_Type)
      return Integer;

   function GetMax
     (Item : access ScrollBar_Type)
      return Integer;

   function GetPosition
     (Item : access ScrollBar_Type)
      return Integer;

   procedure SetPosition
     (Item     : access ScrollBar_Type;
      Position : Integer);

   procedure UpdateBarPosition
     (ScrollBar : access ScrollBar_Type) is null;

private

   type ScrollBar_Private is
      record
         Min      : Integer:=1;
         Max      : Integer:=100;
         Position : Integer:=100;
      end record;

end GUI.ScrollBar;