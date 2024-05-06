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

  Local LLM Inference Library

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

{$IFDEF FPC}
{$MODE DELPHIUNICODE}
{$ENDIF}

{$IFNDEF WIN64}
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

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

  // Message roles
  ROLE_SYSTEM    = 'system';
  ROLE_USER      = 'user';
  ROLE_ASSISTANT = 'assistant';
  ROLE_TOOL      = 'tool';

type
  // Callbacks types
  TDllama_ErrorCallback = procedure(const ASender: Pointer;
    const AError: PAnsiChar); cdecl;

  TDllama_InfoCallback = procedure(const ASender: Pointer;
    const ALevel: Integer; const AText: PAnsiChar); cdecl;

  TDllama_LoadModelProgressCallback = function(const ASender: Pointer;
    const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;

  TDllama_LoadModelCallback = procedure(const ASender: Pointer;
    const ASuccess: Boolean); cdecl;

  TDllama_InferenceStartCallback = procedure(const ASender: Pointer); cdecl;

  TDllama_InferenceDoneCallback = procedure(const ASender: Pointer;
    const AResponse: PAnsiChar); cdecl;

  TDllama_InferenceTokenCallback = procedure(const ASender: Pointer;
    const AToken: PAnsiChar); cdecl;

  // Callback record
  PDllama_Callbacks = ^TDllama_Callbacks;
  TDllama_Callbacks = record
    Sender: Pointer;
    ErrorCallback: TDllama_ErrorCallback;
    InfoCallback: TDllama_InfoCallback;
    LoadModelProgressCallback: TDllama_LoadModelProgressCallback;
    LoadModelCallback: TDllama_LoadModelCallback;
    InferenceStartCallback: TDllama_InferenceStartCallback;
    InferenceDoneCallback: TDllama_InferenceDoneCallback;
    InferenceTokenCallback: TDllama_InferenceTokenCallback;
  end;

  // Usage record
  PDllama_Usage = ^TDllama_Usage;
  TDllama_Usage = record
    TokenInputSpeed: Double;
    TokenOutputSpeed: Double;
    InputTokens: Int32;
    OutputTokens: Int32;
    TotalTokens: Int32;
  end;

// Get Dllama version information
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion,
  APatchVersion, AVersion, AProject: PPAnsiChar); cdecl; external DLLAMA_DLL;

// Create an example config.json file
function  Dllama_CreateExampleConfig(
  const AConfigFilename: PAnsiChar): Boolean; cdecl; external DLLAMA_DLL;

// Init Dllama, loading a config.json file, init callbacks, call before any
// other routine except Dllama_GetVersionInfo, Dllama_CreateExampleConfig
function  Dllama_Init(const AConfigFilename: PAnsiChar;
  const ACallbacks: PDllama_Callbacks): Boolean; cdecl; external DLLAMA_DLL;

// Quit Dllama, call before program shutdown
procedure Dllama_Quit(); cdecl; external DLLAMA_DLL;

// Clear all messages
procedure Dllama_ClearMessages(); cdecl; external DLLAMA_DLL;

// Add a new message for inference
procedure Dllama_AddMessage(const ARole,
  AContent: PAnsiChar); cdecl; external DLLAMA_DLL;

// Get last "user" role message added to messages
function  Dllama_GetLastUserMessage(): PAnsiChar; cdecl; external DLLAMA_DLL;

// Do inference on model, up to AMaxTokens, get response, usage and error
function  Dllama_Inference(const AModelName: PAnsiChar;
  const AMaxTokens: UInt32; AResponse: PPAnsiChar=nil;
  const AUsage: PDllama_Usage=nil;
  const AError: PPAnsiChar=nil): Boolean; cdecl; external DLLAMA_DLL;

// Do inference on model with a single call. It will return a response
// to your question or an error if failed.
function  Dllama_Simple_Inference(const AConfigFilename, AModelName,
  AQuestion: PAnsiChar; const AMaxTokens: UInt32): PAnsiChar;
  cdecl; external DLLAMA_DLL;

// Clear the current console line
procedure Dllama_ClearLine(AColor: WORD); cdecl; external DLLAMA_DLL;

// Print text to console
procedure Dllama_Print(const AText: PAnsiChar;
  const AColor: WORD=WHITE); cdecl; external DLLAMA_DLL;

implementation

initialization
  {$IFNDEF FPC}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

finalization

end.
