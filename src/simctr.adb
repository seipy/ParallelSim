with Ada.Text_IO; use Ada.Text_IO;

with BSDSockets.Streams;
with Network.Processes;

with Network.Config;
with Config;
with ProgramArguments;
with SimControl;

with GNAT.Traceback.Symbolic; use GNAT.Traceback.Symbolic;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Text_IO; use Ada.Text_IO;

procedure SimCtr is

   Configuration : Config.Config_Type;

begin
   ProgramArguments.Debug;

   Network.Config.LoadConfiguration
     (Configuration => Configuration);

   Config.Debug
     (Item => Configuration);

   SimControl.Initialize
     (Configuration =>  Configuration);

   loop
      exit when SimControl.Process;
   end loop;

   SimControl.Finalize;
exception
   when E:others =>
      Put("Exception Name : " & Exception_Name(E));
      New_Line;
      Put("Traceback      :");
      New_Line;
      Put(Symbolic_TraceBack(E));
      New_Line;
      loop
         null;
      end loop;
end SimCtr;