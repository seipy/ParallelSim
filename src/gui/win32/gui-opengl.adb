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

with Ada.Unchecked_Deallocation;
--with Ada.Unchecked_Conversion;
with Win32;
with Win32.User32;
with Win32.Kernel32;
with Win32.GDI32;
with Win32.OpenGL32;
with Interfaces.C.Strings;
with System;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ProcessLoop;

package body GUI.OpenGL is

   type Context_Type;
   type Context_Access is access all Context_Type;
   type Context_Type is new GUI.Context_Type with
      record
         WindowHandle   : Win32.HWND_Type:=0;
         DeviceContext  : Win32.HDC_Type:=0;
         RenderContext  : Win32.HGLRC_Type:=0;
         CSTR_ClassName : Interfaces.C.Strings.chars_ptr
           := Interfaces.C.Strings.Null_Ptr;
         CSTR_Title     : Interfaces.C.Strings.chars_ptr
           := Interfaces.C.Strings.Null_Ptr;
         NextContext : Context_Access:=null;
         LastContext : Context_Access:=null;
      end record;

   Contexts : Context_Access:=null;
   ---------------------------------------------------------------------------

   procedure Free is new Ada.Unchecked_Deallocation
     (Object => Context_Type,
      Name   => Context_Access);

   function WndProc
     (hWnd   : Win32.HWND_Type;
      uMsg   : Win32.UINT_Type;
      wParam : Win32.WPARAM_Type;
      lParam : Win32.LPARAM_Type)
      return Win32.LRESULT_Type;
   pragma Convention(C,WndProc);

   function WndProc
     (hWnd   : Win32.HWND_Type;
      uMsg   : Win32.UINT_Type;
      wParam : Win32.WPARAM_Type;
      lParam : Win32.LPARAM_Type)
      return Win32.LRESULT_Type is

      pragma Warnings(Off,hWnd);
      pragma Warnings(Off,wParam);
      pragma Warnings(Off,lParam);

   begin
      Put(Integer(uMsg));
      New_Line;
      case uMsg is
         when Win32.WM_MOUSELEAVE =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_PAINT =>
            Put("WM_PAINT");
            New_Line;
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_CREATE =>
            Put("WM_CREATE");
            New_Line;
            -- TODO: Initialize Timer
--            declare
--               function ConvertLParamToCREATESTRUCTPtr is
--                 new Ada.Unchecked_Conversion
--                   (Source => Win32.LPARAM_Type,
--                    Target => Win32.CREATESTRUCT_Access);
--
--               CreateStruct : Win32.CREATESTRUCT_Access
--                 :=ConvertLParamToCREATESTRUCTPtr(lParam);
--               Result : Win32.LONG_Type;
--               pragma Warnings(Off,Result);
--            begin
--               Result:=Win32.User32.SetWindowLongPtr
--                 (hWnd      => hWnd,
--                  nIndex    => 0,
--                  dwNewLong => CreateStruct'Address);
--            end;
            return 0;
         when Win32.WM_SIZE =>
            -- TODO : Extract Resize
            Put("WM_SIZE");
            New_Line;
            return 0;
         when Win32.WM_SIZING =>
            Put("WM_SIZING");
            New_Line;
            return 0;
         when Win32.WM_LBUTTONDBLCLK =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_RBUTTONDBLCLK =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_LBUTTONDOWN =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_LBUTTONUP =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_RBUTTONDOWN =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_RBUTTONUP =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_MOUSEMOVE =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_DESTROY =>
            declare
               BoolResult : Win32.BOOL_Type;
               pragma Unreferenced(BoolResult);
            begin
               BoolResult:=Win32.User32.PostMessage
                 (hWnd   => hWnd,
                  Msg    => Win32.WM_QUIT,
                  wParam => 0,
                  lParam => System.Null_Address);
            end;
            return 0;
--         when Win32.WM_TIMER =>
--            return 0;
         when Win32.WM_ERASEBKGND =>
            return 1;
         when Win32.WM_KEYDOWN =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_KEYUP =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when Win32.WM_CHAR =>
            return Win32.User32.DefWindowProc
              (hWnd => hWnd,
               uMsg => uMsg,
               wParam => wParam,
               lParam => lParam);
         when others =>
            return Win32.User32.DefWindowProc
              (hWnd   => hWnd,
               uMsg   => uMsg,
               wParam => wParam,
               lParam => lParam);
      end case;
   end WndProc;
   ---------------------------------------------------------------------------

   -- This procedure extracts all waiting messages for each window/context
   -- and forwards them to the window proc responsible.
   -- It is implemented in a non blocking way using PeekMessage instead of
   -- GetMessage.
   procedure Process is
      lMsg : aliased Win32.MSG_Type;

      use type Win32.BOOL_Type;

      Context : Context_Access;

   begin
      Context:=Contexts;
      ContextLoop:
      while Context/=null loop

         ---------------------------------------------------------------------
         MessageLoop:
         while Win32.User32.PeekMessage
           (lpMsg         => lMsg'Access,
            hWnd          => Context.WindowHandle,
            wMsgFilterMin => 0,
            wMsgFilterMax => 0,
            wRemoveMsg    => Win32.PM_REMOVE)/=0 loop

            declare
               BoolResult : Win32.BOOL_Type;
               LResult    : Win32.LRESULT_Type;
               pragma Unreferenced(BoolResult);
               pragma Unreferenced(LResult);
            begin
               BoolResult := Win32.User32.TranslateMessage(lMsg'Access);
               LResult    := Win32.User32.DispatchMessage(lMsg'Access);
            end;

         end loop MessageLoop;
         ---------------------------------------------------------------------

         Context:=Context.NextContext;
      end loop ContextLoop;

   end Process;
   ---------------------------------------------------------------------------

   procedure FreeContext
     (Context : Context_ClassAccess) is
      Cont : Context_Access;

      use type Win32.HDC_Type;
      use type Win32.HWND_Type;

      BoolResult : Win32.BOOL_Type;
      pragma Unreferenced(BoolResult);
      IntResult  : Interfaces.C.int;
      pragma Unreferenced(IntResult);

   begin
      Cont := Context_Access(Context);
      -- Remove Context from the contexts list
      if Cont.LastContext/=null then
         Cont.LastContext.NextContext:=Cont.NextContext;
      else
         Contexts:=Cont.NextContext;
         if Contexts=null then
            ProcessLoop.Remove(Process'Access);
         end if;

      end if;

      if Cont.NextContext/=null then
         Cont.NextContext.LastContext:=Cont.LastContext;
      end if;

      -- Free Device Context
      if Cont.DeviceContext/=0 then
         IntResult:=Win32.User32.ReleaseDC
           (hWnd => Cont.WindowHandle,
            hDC => Cont.DeviceContext);
      end if;

      -- Destroy and free window
      if Cont.WindowHandle/=0 then
         BoolResult:=Win32.User32.DestroyWindow
           (hWnd => Cont.WindowHandle);
      end if;

      -- Remove Window class
      BoolResult:=Win32.User32.UnregisterClass
        (Cont.CSTR_ClassName,
         Win32.Kernel32.GetModuleHandle(Interfaces.C.Strings.Null_Ptr));

      -- Free C String memory
      Interfaces.C.Strings.Free(Cont.CSTR_ClassName);
      Interfaces.C.Strings.Free(Cont.CSTR_Title);

      Free(Cont);
   end FreeContext;
   ---------------------------------------------------------------------------

   function NewContext
     (Configuration : StringStringMap.Map)
      return Context_ClassAccess is
      pragma Warnings(Off,Configuration);

      use type Win32.UINT_Type;
      use type Interfaces.C.int;
      use type Win32.ATOM_Type;
      use type Win32.WORD_Type;
      use type Win32.DWORD_Type;
      use type Win32.HWND_Type;
      use type Win32.HDC_Type;
      use type Win32.BOOL_Type;

      Context    : Context_Access;
      WndClass   : aliased Win32.WNDCLASS_Type;
      HInstance  : Win32.HINSTANCE_Type;

      dwStyle    : Win32.DWORD_Type;
      dwExStyle  : Win32.DWORD_Type;

      BoolResult : Win32.BOOL_Type;
      HWNDResult : Win32.HWND_Type;
      pragma Unreferenced(BoolResult);
      pragma Unreferenced(HWNDResult);

   begin

      -- Create new context object and add it to the contexts list
      Context:=new Context_Type;
      Context.NextContext := Contexts;
      if Contexts/=null then
         Contexts.LastContext:=Context;
      else
         ProcessLoop.Add(Process'Access);
      end if;
      Contexts:=Context;

      -- Obtain handle to current process
      HInstance:=Win32.Kernel32.GetModuleHandle
        (lpModuleName => Interfaces.C.Strings.Null_Ptr);

      Context.CSTR_ClassName
        := Interfaces.C.Strings.New_String("OpenGLWindow");
      Context.CSTR_Title
        := Interfaces.C.Strings.New_String("ParallelSim");

      -- Create and Register a window class for an ordinary window
      WndClass.Style
        := Win32.CS_HREDRAW
        or Win32.CS_VREDRAW
        or Win32.CS_OWNDC;

      WndClass.lpfnWndProc := WndProc'Access;
      WndClass.hInstance   := HInstance;
      WndClass.hIcon       := Win32.User32.LoadIcon
        (hInstance  => 0,
         lpIconName => Win32.IDI_WINLOGO);
      WndClass.hCursor := Win32.User32.LoadIcon
        (hInstance  => 0,
         lpIconName => Win32.IDC_ARROW);
      WndClass.lpszClassName := Context.CSTR_ClassName;
      WndClass.cbWndExtra    := System.Address'Size/8;

      if Win32.User32.RegisterClass
        (lpWndClass => WndClass'Access)=0 then
         raise FailedToCreateContext
           with "RegisterClass failed with "
             &Win32.DWORD_Type'Image(Win32.GetLastError);
      end if;

      -- Create the window with the previously created window class
      dwStyle := Win32.WS_OVERLAPPEDWINDOW
        or Win32.WS_CLIPCHILDREN
        or Win32.WS_CLIPSIBLINGS;
      dwExStyle := Win32.WS_EX_APPWINDOW
        or Win32.WS_EX_CLIENTEDGE;

      Context.WindowHandle
        := Win32.User32.CreateWindowEx
          (dwExStyle    => dwExStyle,
           lpClassName  => Context.CSTR_ClassName,
           lpWindowName => Context.CSTR_Title,
           dwStyle      => dwStyle,
           x            => 100,
           y            => 100,
           nwidth       => 640,
           nheight      => 480,
           hWndParent   => 0,
           hMenu        => 0,
           hInstance    => HInstance,
           lpParam      => Context'Address);

      if Context.WindowHandle=0 then
         FreeContext(Context_ClassAccess(Context));
         raise FailedToCreateContext
           with "Failed call to CreateWindowEx exited with "
             &Win32.DWORD_Type'Image(Win32.GetLastError);
      end if;

      -- Obtain a device context for the window
      Context.DeviceContext := Win32.User32.GetDC(Context.WindowHandle);
      if Context.DeviceContext=0 then
         FreeContext(Context_ClassAccess(Context));
         raise FailedToCreateContext
           with "Failed call to GetDC exited with "
             &Win32.DWORD_Type'Image(Win32.GetLastError);
      end if;

      -- Ensure window is visible and focused
      BoolResult:=Win32.User32.ShowWindow
        (hWnd     => Context.WindowHandle,
         nCmdShow => Win32.SW_SHOW);

      BoolResult:=Win32.User32.SetForegroundWindow
        (hWnd => Context.WindowHandle);

      HWNDResult:=Win32.User32.SetFocus
        (hWnd => Context.WindowHandle);

      -- Setup OpenGL context
      declare
         pdf         : aliased Win32.PIXELFORMATDESCRIPTOR_Type;
         PixelFormat : Interfaces.C.int;
      begin
         pdf.nSize    := Win32.PIXELFORMATDESCRIPTOR_Type'Size/8;
         pdf.nVersion := 1;
         pdf.dwFlags
           := Win32.PFD_DRAW_TO_WINDOW
           or Win32.PFD_SUPPORT_OPENGL;
         pdf.iPixelType := Win32.PFD_TYPE_RGBA;
         pdf.cColorBits := 24;
         pdf.cDepthBits := 24;
         pdf.iLayerType := Win32.PFD_MAIN_PLANE;
         PixelFormat := Win32.GDI32.ChoosePixelFormat
           (hdc => Context.DeviceContext,
            ppfd => pdf'Access);
         if PixelFormat=0 then
            FreeContext(Context_ClassAccess(Context));
            raise FailedToCreateContext
              with "Failed to pick a Pixelformat using ChoosePixelFormat. Error code :"
                &Interfaces.C.int'Image(PixelFormat);
         end if;
         if Win32.GDI32.SetPixelFormat
           (hdc          => Context.DeviceContext,
            iPixelFormat => PixelFormat,
            ppfd         => pdf'Access)/=Win32.TRUE then
            FreeContext(Context_ClassAccess(Context));
            raise FailedToCreateContext
              with "Failed to set the Pixelformat using SetPixelFormat. Error code :"
                &Win32.DWORD_Type'Image(Win32.GetLastError);
         end if;
      end;

      Context.RenderContext
        :=Win32.OpenGL32.wglCreateContext(Context.DeviceContext);

      if Win32.OpenGL32.wglMakeCurrent
        (hdc   => Context.DeviceContext,
         hglrc => Context.RenderContext)/=Win32.TRUE then
         FreeContext(Context_ClassAccess(Context));
         raise FailedToCreateContext
           with "Failed call to wglMakeCurrent with "
             &Win32.DWORD_Type'Image(Win32.GetLastError);
      end if;

      return Context_ClassAccess(Context);
   end NewContext;
   ---------------------------------------------------------------------------

   Implementation : constant Implementation_Type:=
     (NewContext  => NewContext'Access,
      FreeContext => FreeContext'Access);

   procedure Register is
   begin
      Implementations.Register
        (Identifier     => To_Unbounded_String("OpenGL"),
         Implementation => Implementation);
   end Register;
   ---------------------------------------------------------------------------

end GUI.OpenGL;