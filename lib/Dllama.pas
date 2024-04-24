{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
                        =-
      +@-              *%:+
     *:=@:            =@+ :=
    #- -=*:  :.-#:-= =-%  .*
    @.  = # =*+++***-:+.  ==
    #=  -  -.    ... :.  =*
     +-  ..--+.  :+==   #+
    .+*:  :-     ..-+=-=+.
     ##+*#%@@@@@@#####%@@:
     .@@@@@@@+::+%@@@@@@*
      #@@@@%--: :-**@@@#. *
     = -===.* ==+ +#   : .#.
     *-  .==*. = :*:  :- :*
     +*:  = :#---=+     .*:
     :+:      =--=     -+:
       *=-  ..    :+  --
        :--*=:-+--..=-..
        +-             +=
       .*.   -:.  .=   :#
       -*      ::-:     +:
       *=               -+
       #-               -%:
      .=                 :
 ___   _  _
|   \ | || | __ _  _ __   __ _ ™
| |) || || |/ _` || '  \ / _` |
|___/ |_||_|\__,_||_|_|_|\__,_|

    LLM inference in Delphi

Copyright © 2024-present tinyBigGAMES™ LLC
         All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com
License: BSD 3-Clause License

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }

unit Dllama;

interface

const
  // Dllama DLL
  DLLAMA_DLL = 'Dllama.dll';

  // Console linefeed & carriage return
  LF   = #10;
  CR   = #13;
  CRLF = LF+CR;

  // Virtual Keys
  VK_ESCAPE = 27;

  // Console colors
  BRIGHTYELLOW = 4 OR 2 OR 8;
  YELLOW       = 4 OR 2;
  WHITE        = 4 OR 2 OR 1;
  BRIGHTWHITE  = 4 OR 2 OR 1 OR 8;
  DARKGREEN    = 2;
  DARKGRAY     = 8;
  CYAN         = 2 OR 1;
  MAGENTA      = 4 OR 1;
  RED          = 4;

  // Temperature
  TEMPERATURE_PERCISE  = 0.0;
  TEMPREATURE_BALANCED = 0.5;
  TEMPREATURE_CREATIVE = 1.0;

  // Message roles
  ROLE_SYSTEM    = 'system';
  ROLE_USER      = 'user';
  ROLE_ASSISTANT = 'assistant';
  ROLE_TOOL      = 'tool';

type
  // Callbacks
  TDllama_LoadModelProgressCallback = function(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
  TDllama_LoadModelCallback = procedure(const ASender: Pointer; const ASuccess: Boolean); cdecl;
  TDllama_InferenceCallback = procedure(const ASender: Pointer; const AToken: PAnsiChar); cdecl;
  TDllama_InferenceDoneCallback = procedure(const ASender: Pointer); cdecl;

// Info
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PPAnsiChar); cdecl; external DLLAMA_DLL;

// Config
procedure Dllama_InitConfig(const AModelPath: PAnsiChar; const ANumGPULayers: Integer; const ADisplayInfo: Boolean; const ACancelInferenceKey: Byte); cdecl; external DLLAMA_DLL;
procedure Dllama_GetConfig(AModelPath: PPAnsiChar; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte); cdecl; external DLLAMA_DLL;
function  Dllama_SaveConfig(const AFilename: PAnsiChar): Boolean; cdecl; external DLLAMA_DLL;
function  Dllama_LoadConfig(const AFilename: PAnsiChar): Boolean; cdecl; external DLLAMA_DLL;

// Error
function  Dllama_GetError(): PAnsiChar; cdecl; external DLLAMA_DLL;
procedure Dllama_SetError(const AText: PAnsiChar); cdecl; external DLLAMA_DLL;
procedure Dllama_ClearError(); cdecl; external DLLAMA_DLL;

// Model
function  Dllama_GetLoadModelProgressCallback(): TDllama_LoadModelProgressCallback; cdecl; external DLLAMA_DLL;
procedure Dllama_SetLoadModelProgressCallback(const ASender: Pointer; const AHandler: TDllama_LoadModelProgressCallback); cdecl; external DLLAMA_DLL;
function  Dllama_GetLoadModelCallback(): TDllama_LoadModelCallback; cdecl; external DLLAMA_DLL;
procedure Dllama_SetLoadModelCallback(const ASender: Pointer; const AHandler: TDllama_LoadModelCallback); cdecl; external DLLAMA_DLL;
function  Dllama_AddModel(const AFilename, AName: PAnsiChar; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: PAnsiChar; const AStopSequences: PPAnsiChar; const AStopSequencesCount: Cardinal): Boolean; cdecl; external DLLAMA_DLL;
procedure Dllama_ClearModels(); cdecl; external DLLAMA_DLL;
function  Dllama_GetModelCount(): Cardinal; cdecl; external DLLAMA_DLL;
function  Dllama_SaveModelDb(const AFilename: PAnsiChar): Boolean; cdecl; external DLLAMA_DLL;
function  Dllama_LoadModelDb(const AFilename: PAnsiChar): Boolean; cdecl; external DLLAMA_DLL;
function  Dllama_LoadModel(const AName: PAnsiChar): Boolean; cdecl; external DLLAMA_DLL;
procedure Dllama_UnloadModel(); cdecl; external DLLAMA_DLL;

// Messages
procedure Dllama_ClearMessages(); cdecl; external DLLAMA_DLL;
procedure Dllama_AddMessage(const ARole, AMessage: PAnsiChar); cdecl; external DLLAMA_DLL;
function  Dllama_GetLastUserMessage(): PAnsiChar; cdecl; external DLLAMA_DLL;

// Inference
function  Dllama_GetInferenceCallback(): TDllama_InferenceCallback; cdecl; external DLLAMA_DLL;
procedure Dllama_SetInferenceCallback(const ASender: Pointer; const AHandler: TDllama_InferenceCallback); cdecl; external DLLAMA_DLL;
function  Dllama_GetInferenceDoneCallback(): TDllama_InferenceDoneCallback; cdecl; external DLLAMA_DLL;
procedure Dllama_SetInferenceDoneCallback(const ASender: Pointer; const AHandler: TDllama_InferenceDoneCallback); cdecl; external DLLAMA_DLL;
function  Dllama_Inference(const AModelName: PAnsiChar; AResponse: PPAnsiChar; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean; cdecl; external DLLAMA_DLL;
procedure Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger); cdecl; external DLLAMA_DLL;

// Console
procedure Dllama_Console_GetSize(AWidth: PInteger; AHeight: PInteger); cdecl; external DLLAMA_DLL;
procedure Dllama_Console_Clear(); cdecl; external DLLAMA_DLL;
procedure Dllama_Console_ClearLine(AColor: Word); cdecl; external DLLAMA_DLL;
procedure Dllama_Console_SetTitle(const ATitle: PAnsiChar); cdecl; external DLLAMA_DLL;
procedure Dllama_Console_Pause(const AForcePause: Boolean; AColor: Word; const aMsg: PAnsiChar); cdecl; external DLLAMA_DLL;
procedure Dllama_Console_Print(const AText: PAnsiChar; const AColor: Word); cdecl; external DLLAMA_DLL;
procedure Dllama_Console_PrintLn(const AText: PAnsiChar; const AColor: Word); cdecl; external DLLAMA_DLL;

implementation

initialization
begin
  ReportMemoryLeaksOnShutdown := True;
end;

finalization
begin
end;

end.
