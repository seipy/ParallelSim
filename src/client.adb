pragma Ada_2005;

with Config;
with GUI.UseImplementations;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with SimClientGUI;
with GUI.Themes.YellowBlue;
with Fonts.Freetype;
with ExceptionOutput;

procedure Client is

   Configuration  : Config.Config_Type;

begin

   GUI.UseImplementations.Register;
   GUI.Themes.YellowBlue.Register;
   Fonts.Freetype.Initialize;

   Config.Insert
     (Container => Configuration,
      Key       => To_Unbounded_String("GUI.GUIImplementation"),
      New_Item  => To_Unbounded_String("OpenGL"));

   Config.Insert
     (Container => Configuration,
      Key       => To_Unbounded_String("GUI.Theme"),
      New_Item  => To_Unbounded_String("YellowBlue"));

   SimClientGUI.Initialize
     (Configuration => Configuration);

   loop
      exit when SimClientGUI.Process;
   end loop;

   SimClientGUI.Finalize;

   Fonts.Freetype.Finalize;
   GUI.Themes.YellowBlue.UnRegister;
   GUI.UseImplementations.Unregister;

exception
   when E:others =>
      ExceptionOutput.Put(E);

end Client;
