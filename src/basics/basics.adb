--   Copyright 2012 Julian Schutsch
--
--   This file is part of ParallelSim
--
--   ParallelSim is free software: you can redistribute it and/or modify
--   it under the terms of the GNU Affero General Public License as published by
--   the Free Software Foundation, either version 3 of the License, or
--   (at your option) any later version.
--
--   ParallelSim is distributed in the hope that it will be useful,
--   but WITHOUT ANY WARRANTY; without even the implied warranty of
--   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--   GNU Affero General Public License for more details.
--
--   You should have received a copy of the GNU Affero General Public License
--   along with ParallelSim.  If not, see <http://www.gnu.org/licenses/>.

-- Revision History
--   2.Feb 2012 Julian Schutsch
--     - Original version
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Basics is
   use type Ada.Containers.Hash_Type;

   function StringSumHash(id: Unbounded_String) return Ada.Containers.Hash_Type is
      Sum : Ada.Containers.Hash_Type:=0;
   begin
      for i in 0..Length(id)-1 loop
         Sum := Sum+Character'Pos(Element(id,i));
      end loop;
      return Sum;
   end;

end Basics;