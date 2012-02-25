pragma Ada_2005;

with Endianess;
with Types;
with Network;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;
with BSDSockets;
with Basics; use Basics;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Network.Streams;
with Network.Barrier;
with Network.Config;
with BSDSockets.Streams;
with Network.Messages;
with Network.Processes;

with SimControl;
with SimElement;
with SimAdmin;
with Config;
with Processes;

with ProgramArguments;

procedure Ps is

   Configuration : Config.Config_Type;
   NetworkImplementation : Network.Config.Implementation_Type;

begin

   Put("Create Configuration");
   Config.Insert
     (Item       => Configuration,
      ModuleName => To_Unbounded_String("Network.Control<->Element"),
      Key        => To_Unbounded_String("StreamImplementation"),
      Value      => To_Unbounded_String("BSDSockets.Stream"));

   Config.Insert
     (Item       => Configuration,
      ModuleName => To_Unbounded_String("Network.Control<->Element"),
      Key        => To_Unbounded_String("ProcessesImplementation"),
      Value      => To_Unbounded_String("Local"));

   Put("Find Implementation");
   NetworkImplementation:=Network.Config.FindImplementation
     (ModuleName    => To_Unbounded_String("Network.Control<->Element"),
      Configuration => Configuration);

   NetworkImplementation.Processes.StoreConfig
     (Configuration => Configuration);

   Put("Spawn Processes");
   NetworkImplementation.Processes.Spawn
     (Program => "simctr" & To_String(Processes.Suffix),
      Amount  => 1);
   Put("Terminate PS");
   New_Line;

end Ps;
