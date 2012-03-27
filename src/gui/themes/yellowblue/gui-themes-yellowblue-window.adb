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

pragma Ada_2005;

with Ada.Text_IO; use Ada.Text_IO;

package body GUI.Themes.YellowBlue.Window is

   TitleBarHeight   : constant Integer := 24;
   LineWidth        : constant Integer := 1;
   BorderSpaceWidth : constant Integer := 4;
   BorderWidth      : constant Integer := LineWidth*2+BorderSpaceWidth;
   CornerSize       : constant Integer := 2*BorderWidth;
   TopBarHeight     : constant Integer := TitleBarHeight+2*BorderWidth;

   BackgroundColor     : constant Canvas.Color_Type := 16#FF000000#;
   BorderLineColor     : constant Canvas.Color_Type := 16#FFFFFF00#;
   BorderEdgeLineColor : constant Canvas.Color_Type := 16#FFFFFFFF#;
   ClientColor         : constant Canvas.Color_Type := 16#7F00007F#;

   type Window_Type is new GUI.Window.Window_Type with
      record
         TopLeftCorner     : GUI.Canvas_ClassAccess;
         TopBar            : GUI.Canvas_ClassAccess;
         TopRightCorner    : GUI.Canvas_ClassAccess;
         LeftBar           : GUI.Canvas_ClassAccess;
         RightBar          : GUI.Canvas_ClassAccess;
         BottomLeftCorner  : GUI.Canvas_ClassAccess;
         BottomRightCorner : GUI.Canvas_ClassAccess;
         BottomBar         : GUI.Canvas_ClassAccess;
         ClientArea        : GUI.Canvas_ClassAccess;
      end record;
   type Window_Access is access all Window_Type;

   overriding
   procedure MouseDown
     (Item   : access Window_Type;
      Button : MouseButton_Enum;
      X      : Integer;
      Y      : Integer;
      Taken  : out Boolean);

   overriding
   procedure MouseUp
     (Item   : access Window_Type;
      Button : MouseButton_Enum;
      X      : Integer;
      Y      : Integer);

   overriding
   procedure MouseMove
     (Item : access Window_Type;
      X    : Integer;
      Y    : Integer);

   procedure MouseDown
     (Item   : access Window_Type;
      Button : MouseButton_Enum;
      X      : Integer;
      Y      : Integer;
      Taken  : out Boolean) is

   begin
      Put("MouseDown:WINDOW**************");
      New_Line;
      Taken:=True;

      If Button=LeftButton then

         if Y<BorderWidth then

            if X<CornerSize then
               Item.StartChange
                 (RefX => X,
                  RefY => Y,
                  Mode => GUI.Window.WindowChangeModeSizeTopLeft);
               return;
            end if;

            if X>=Item.Priv.Bounds.Width-CornerSize then
               Item.StartChange
                 (RefX => X,
                  RefY => Y,
                  Mode => GUI.Window.WindowChangeModeSizeTopRight);
               return;
            end if;

            Item.StartChange
              (RefX => X,
               RefY => Y,
               Mode => GUI.Window.WindowChangeModeSizeTop);
            return;

         end if;

         if Y>=Item.Priv.Bounds.Height-BorderWidth then

            if X<CornerSize then
               Item.StartChange
                 (Refx => X,
                  Refy => Y,
                  Mode => GUI.Window.WindowChangeModeSizeBottomLeft);
               return;
            end if;

            if X>=Item.Priv.Bounds.Width-CornerSize then
               Item.StartChange
                 (Refx => X,
                  Refy => Y,
                  Mode => GUI.Window.WindowChangeModeSizeBottomRight);
               return;
            end if;

            Item.StartChange
              (RefX => X,
               RefY => Y,
               Mode => GUI.Window.WindowChangeModeSizeBottom);
            return;

         end if;

         if X<BorderWidth then

            if Y<CornerSize then
               Item.StartChange
                 (Refx => X,
                  Refy => Y,
                  Mode => GUI.Window.WindowChangeModeSizeTopLeft);
               return;
            end if;

            if Y>=Item.Priv.Bounds.Height-CornerSize then
               Item.StartChange
                 (Refx => X,
                  Refy => Y,
                  Mode => GUI.Window.WindowChangeModeSizeBottomLeft);
               return;
            end if;

            Item.StartChange
              (RefX => X,
               RefY => Y,
               Mode => GUI.Window.WindowChangeModeSizeLeft);
            return;

         end if;

         if X>=Item.Priv.Bounds.Width-BorderWidth then

            if Y<CornerSize then
               Item.StartChange
                 (Refx => X,
                  Refy => Y,
                  Mode => GUI.Window.WindowChangeModeSizeTopRight);
               return;
            end if;

            if Y>=Item.Priv.Bounds.Height-CornerSize then
               Item.StartChange
                 (Refx => X,
                  Refy => Y,
                  Mode => GUI.Window.WindowChangeModeSizeBottomRight);
            end if;

            Item.StartChange
              (RefX => X,
               RefY => Y,
               Mode => GUI.Window.WindowChangeModeSizeRight);
            return;

         end if;

         if Y<BorderWidth+TitleBarHeight then
            Item.StartChange
              (Refx => X,
               Refy => Y,
               Mode => GUI.Window.WindowChangeModeMove);
         end if;

      end if;

   end MouseDown;
   ---------------------------------------------------------------------------

   procedure MouseUp
     (Item   : access Window_Type;
      Button : MouseButton_Enum;
      X      : Integer;
      Y      : Integer) is
      pragma Unreferenced(Button);
   begin
      Item.ApplyChange
        (Refx => X,
         Refy => Y);
      Item.StopChange;
   end MouseUp;
   ---------------------------------------------------------------------------

   procedure MouseMove
     (Item : access Window_Type;
      X    : Integer;
      Y    : Integer) is
   begin
      Item.ApplyChange
        (Refx => X,
         Refy => Y);
   end MouseMove;
   ---------------------------------------------------------------------------

   function NewWindow
     (Parent : Object_ClassAccess)
      return GUI.Window.Window_ClassAccess is

      NewWindow : Window_Access;

   begin
      NewWindow:=new Window_Type;

      GUI.Window.Initialize
        (Item   => GUI.Window.Window_Access(NewWindow),
         Parent => Parent);

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => TopBarHeight,
         Width  => CornerSize,
         Canvas => NewWindow.TopLeftCorner);

      NewWindow.TopLeftCorner.Clear
        (Color => BackgroundColor);
      NewWindow.TopLeftCorner.HorzLine
        (X     => 0,
         Y     => 0,
         Width => CornerSize,
         Color => BorderLineColor);
      NewWindow.TopLeftCorner.VertLine
        (X      => 0,
         Y      => 1,
         Height => TopBarHeight-1,
         Color  => BorderLineColor);
      NewWindow.TopLeftCorner.HorzLine
        (X      => LineWidth+BorderSpaceWidth,
         Y      => LineWidth+BorderSpaceWidth,
         Width  => CornerSize-LineWidth-BorderSpaceWidth,
         Color  => BorderLineColor);
      NewWindow.TopLeftCorner.VertLine
        (X      => LineWidth+BorderSpaceWidth,
         Y      => LineWidth+BorderSpaceWidth+1,
         Height => TopbarHeight-LineWidth-BorderSpaceWidth-BorderWidth,
         Color  => BorderLineColor);
      NewWindow.TopLeftCorner.HorzLine
        (X      => LineWidth+BorderSpaceWidth+1,
         Y      => TopBarHeight-BorderWidth,
         Width  => CornerSize-LineWidth-BorderSpaceWidth-1,
         Color  => BorderLineColor);
      NewWindow.TopLeftCorner.HorzLine
        (X      => LineWidth+BorderSpaceWidth,
         Y      => TopBarHeight-1,
         Width  => CornerSize-LineWidth-BorderSpaceWidth,
         Color  => BorderLineColor);
      NewWindow.TopLeftCorner.HorzLine
        (X     => 1,
         Y     => CornerSize-1,
         Width => BorderSpaceWidth,
         Color => BorderEdgeLineColor);
      NewWindow.TopLeftCorner.VertLine
        (X      => CornerSize-1,
         Y      => 1,
         Height => BorderSpaceWidth,
         Color  => BorderEdgeLineColor);
      GUI.SetBounds
        (Canvas => NewWindow.TopLeftCorner,
         Bounds =>
           (Top     => 0,
            Left    => 0,
            Height  => TopBarHeight,
            Width   => CornerSize,
            Visible => True));
      Gui.SetAnchors
        (Canvas => NewWindow.TopLeftCorner,
         Top    => True,
         Left   => True,
         Right  => False,
         Bottom => False);
      ------------------------------------------------------------------------
      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => TopBarHeight,
         Width  => 1,
         Canvas => NewWindow.TopBar);

      NewWindow.TopBar.Clear
        (Color => BackgroundColor);
      NewWindow.TopBar.Image(0,0)
        :=BorderLineColor;
      NewWindow.TopBar.Image(LineWidth+BorderSpaceWidth,0)
        :=BorderLineColor;
      NewWindow.TopBar.Image(TOpBarHeight-BorderSpaceWidth-LineWidth-1,0)
        :=BorderLineColor;
      NewWindow.TopBar.Image(TopBarHeight-1,0)
        :=BorderLineColor;
      GUI.SetBounds
        (Canvas => NewWindow.TopBar,
         Bounds =>
           (Top     => 0,
            Left    => CornerSize,
            Height  => TopBarHeight,
            Width   => -2*CornerSize,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.TopBar,
         Top    => True,
         Left   => True,
         Right  => True,
         Bottom => False);
      ------------------------------------------------------------------------
      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => TopBarHeight,
         Width  => CornerSize,
         Canvas => NewWindow.TopRightCorner);

      NewWindow.TopRightCorner.Clear
        (Color => BackgroundColor);
      NewWindow.TopRightCorner.HorzLine
        (X      => 0,
         Y      => 0,
         Width  => CornerSize,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.VertLine
        (X      => CornerSize-1,
         Y      => 1,
         Height => TopbarHeight-1,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.HorzLine
        (X      => 0,
         Y      => LineWidth+BorderSpaceWidth,
         Width  => CornerSize-BorderWidth,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.VertLine
        (X      => CornerSize-BorderWidth,
         Y      => LineWidth+BorderSpaceWidth,
         Height => TopbarHeight-2*BorderWidth+1,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.HorzLine
        (X      => 0,
         Y      => TopBarHeight-1,
         Width  => CornerSize-BorderWidth+1,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.HorzLine
        (X      => 0,
         Y      => TopBarHeight-BorderWidth,
         Width  => CornerSize-BorderWidth+1,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.VertLine
        (X      => 0,
         Y      => LineWidth,
         Height => BorderSpaceWidth,
         Color  => BorderLineColor);
      NewWindow.TopRightCorner.HorzLine
        (X      => CornerSize-LineWidth-BorderSpaceWidth,
         Y      => CornerSize-1,
         Width  => BorderSpaceWidth,
         Color  => BorderEdgeLineColor);
      GUI.SetBounds
        (Canvas => NewWindow.TopRightCorner,
         Bounds =>
           (Top     => 0,
            Left    => -CornerSize,
            Height  => TopBarHeight,
            Width   => CornerSize,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.TopRightCorner,
         Top    => True,
         Left   => False,
         Right  => True,
         Bottom => False);
      ------------------------------------------------------------------------

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => 1,
         Width  => BorderWidth,
         Canvas => NewWindow.LeftBar);
      NewWindow.LeftBar.Clear
        (Color => BackgroundColor);
      NewWindow.LeftBar.Image(0,0):=BorderLineColor;
      NewWindow.LeftBar.Image(0,BorderWidth-1):=BorderLineColor;
      GUI.SetBounds
        (Canvas => NewWindow.LeftBar,
         Bounds =>
           (Top     => TopBarHeight,
            Left    => 0,
            Height  => -TopBarHeight-CornerSize,
            Width   => BorderWidth,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.LeftBar,
         Top    => True,
         Left   => True,
         Right  => False,
         Bottom => True);
      ------------------------------------------------------------------------

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => 1,
         Width  => BorderWidth,
         Canvas => NewWindow.RightBar);
      NewWindow.RightBar.Clear
        (Color => BackgroundColor);
      NewWindow.RightBar.Image(0,0):=BorderLineColor;
      NewWindow.RightBar.Image(0,BorderWidth-1):=BorderLineColor;
      GUI.SetBounds
        (Canvas => NewWindow.RightBar,
         Bounds =>
           (Top     => TopBarHeight,
            Left    => -BorderWidth,
            Height  => -TopBarHeight-CornerSize,
            Width   => BorderWidth,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.RightBar,
         Top    => True,
         Left   => False,
         Right  => True,
         Bottom => True);
      ------------------------------------------------------------------------

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => CornerSize,
         Width  => CornerSize,
         Canvas => NewWindow.BottomLeftCorner);
      NewWindow.BottomLeftCorner.Clear
        (Color => BackgroundColor);
      NewWindow.BottomLeftCorner.VertLine
        (X      => 0,
         Y      => 0,
         Height => CornerSize,
         Color  => BorderLineColor);
      NewWindow.BottomLeftCorner.HorzLine
        (X      => 1,
         Y      => CornerSize-1,
         Width  => CornerSize-1,
         Color  => BorderLineColor);
      NewWindow.BottomLeftCorner.VertLine
        (X      => BorderWidth-1,
         Y      => 0,
         Height => CornerSize-BorderWidth+1,
         Color  => BorderLineColor);
      NewWindow.BottomLeftCorner.HorzLine
        (X      => BorderWidth,
         Y      => CornerSize-BorderWidth,
         Width  => CornerSize-BorderWidth,
         Color  => BorderLineColor);
      NewWindow.BottomLeftCorner.HorzLine
        (X      => LineWidth,
         Y      => 1,
         Width  => BorderSpaceWidth,
         Color  => BorderEdgeLineColor);
      NewWindow.BottomLeftCorner.VertLine
        (X      => CornerSize-1,
         Y      => CornerSize-LineWidth-BorderSpaceWidth,
         Height => BorderSpaceWidth,
         Color  => BorderEdgeLineColor);
      NewWindow.BottomLeftCorner.Bar
        (X      => BorderWidth,
         Y      => 0,
         Height => CornerSize-BorderWidth,
         Width  => CornerSize-BorderWidth,
         Color  => 0);
      GUI.SetBounds
        (Canvas => NewWindow.BottomLeftCorner,
         Bounds =>
           (Top     => -CornerSize,
            Left    => 0,
            Height  => CornerSize,
            Width   => CornerSize,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.BottomLeftCorner,
         Top    => False,
         Left   => True,
         Right  => False,
         Bottom => True);
      ------------------------------------------------------------------------

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => BorderWidth,
         Width  => 1,
         Canvas => NewWindow.BottomBar);
      NewWindow.BottomBar.Clear
        (Color => BackgroundColor);

      NewWindow.BottomBar.Image(0,0)             := BorderLineColor;
      NewWindow.BottomBar.Image(BorderWidth-1,0) := BorderLineColor;

      GUI.SetBounds
        (Canvas => NewWindow.BottomBar,
         Bounds =>
           (Top     => -BorderWidth,
            Left    => CornerSize,
            Height  => BorderWidth,
            Width   => -2*CornerSize,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.BottomBar,
         Top    => False,
         Left   => True,
         Right  => True,
         Bottom => True);
      ------------------------------------------------------------------------

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => CornerSize,
         Width  => CornerSize,
         Canvas => NewWindow.BottomRightCorner);
      NewWindow.BottomRightCorner.Clear
        (Color => BackgroundColor);
      NewWindow.BottomRightCorner.VertLine
        (X      => CornerSize-1,
         Y      => 0,
         Height => CornerSize,
         Color  => BorderLineColor);
      NewWindow.BottomRightCorner.HorzLine
        (X      => 0,
         Y      => CornerSize-1,
         Width  => CornerSize-1,
         Color  => BorderLineColor);
      NewWindow.BottomRightCorner.VertLine
        (X      => CornerSize-BorderWidth,
         Y      => 0,
         Height => CornerSize-BorderWidth+1,
         Color  => BorderLineColor);
      NewWindow.BottomRightCorner.HorzLine
        (X      => 0,
         Y      => CornerSize-BorderWidth,
         Width  => CornerSize-BorderWidth,
         Color  => BorderLineColor);
      NewWindow.BottomRightCorner.HorzLine
        (X      => CornerSize-LineWidth-BorderSpaceWidth,
         Y      => 0,
         Width  => BorderSpaceWidth,
         Color  => BorderEdgeLineColor);
      NewWindow.BottomRightCorner.VertLine
        (X      => 0,
         Y      => CornerSize-LineWidth-BorderSpaceWidth,
         Height => BorderSpaceWidth,
         Color  => BorderEdgeLineColor);
      NewWindow.BottomRightCorner.Bar
        (X      => 0,
         Y      => 0,
         Height => CornerSize-BorderWidth,
         Width  => CornerSize-BorderWidth,
         Color  => 0);
      GUI.SetBounds
        (Canvas => NewWindow.BottomRightCorner,
         Bounds =>
           (Top     => -CornerSize,
            Left    => -CornerSize,
            Height  => CornerSize,
            Width   => CornerSize,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.BottomRightCorner,
         Top    => False,
         Left   => False,
         Right  => True,
         Bottom => True);
      ------------------------------------------------------------------------

      NewWindow.Context.NewCanvas
        (Object => Object_ClassAccess(NewWindow),
         Height => 1,
         Width  => 1,
         Canvas => NewWindow.ClientArea);
      NewWindow.ClientArea.Clear
        (Color => ClientColor);
      GUI.SetBounds
        (Canvas => NewWindow.ClientArea,
         Bounds =>
           (Top     => TopBarHeight,
            Left    => BorderWidth,
            Height  => -TopBarHeight-BorderWidth,
            Width   => -2*BorderWidth,
            Visible => True));
      GUI.SetAnchors
        (Canvas => NewWindow.ClientArea,
         Top    => True,
         Left   => True,
         Right  => True,
         Bottom => True);

      return GUI.Window.Window_ClassAccess(NewWindow);

   end NewWindow;
   ---------------------------------------------------------------------------

end GUI.Themes.YellowBlue.Window;
