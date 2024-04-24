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

unit Dllama.Export;

{$I Dllama.Defines.inc}

interface

uses
  System.SysUtils,
  Dllama.Deps,
  Dllama.Deps.Ext,
  Dllama.Utils,
  Dllama.Core;

// Init
function  Dllama_Init(): Boolean; cdecl;
procedure Dllama_Quit(); cdecl;
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PPAnsiChar); cdecl; exports Dllama_GetVersionInfo;

// Config
procedure Dllama_InitConfig(const AModelPath: PAnsiChar; const ANumGPULayers: Integer; const ADisplayInfo: Boolean; const ACancelInferenceKey: Byte); cdecl; exports Dllama_InitConfig;
procedure Dllama_GetConfig(AModelPath: PPAnsiChar; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte); cdecl; exports Dllama_GetConfig;
function  Dllama_SaveConfig(const AFilename: PAnsiChar): Boolean; cdecl; exports Dllama_SaveConfig;
function  Dllama_LoadConfig(const AFilename: PAnsiChar): Boolean; cdecl; exports Dllama_LoadConfig;

// Error
function  Dllama_GetError(): PAnsiChar; cdecl; exports Dllama_GetError;
procedure Dllama_SetError(const AText: PAnsiChar); cdecl; exports Dllama_SetError;
procedure Dllama_ClearError(); cdecl; exports Dllama_ClearError;

// Model
function  Dllama_GetLoadModelProgressCallback(): TDllama.LoadModelProgressCallback; cdecl; exports Dllama_GetLoadModelProgressCallback;
procedure Dllama_SetLoadModelProgressCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelProgressCallback); cdecl; exports Dllama_SetLoadModelProgressCallback;
function  Dllama_GetLoadModelCallback(): TDllama.LoadModelCallback; cdecl; exports Dllama_GetLoadModelCallback;
procedure Dllama_SetLoadModelCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelCallback); cdecl; exports Dllama_SetLoadModelCallback;
function  Dllama_AddModel(const AFilename, AName: PAnsiChar; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: PAnsiChar; const AStopSequences: PPAnsiChar; const AStopSequencesCount: Cardinal): Boolean; cdecl; exports Dllama_AddModel;
procedure Dllama_ClearModels(); cdecl; exports Dllama_ClearModels;
function  Dllama_GetModelCount(): Cardinal; cdecl; exports Dllama_GetModelCount;
function  Dllama_SaveModelDb(const AFilename: PAnsiChar): Boolean; cdecl; exports Dllama_SaveModelDb;
function  Dllama_LoadModelDb(const AFilename: PAnsiChar): Boolean; cdecl; exports Dllama_LoadModelDb;
function  Dllama_LoadModel(const AName: PAnsiChar): Boolean; cdecl; exports Dllama_LoadModel;
function  Dllama_IsModelLoaded(): Boolean; cdecl; exports Dllama_IsModelLoaded;
procedure Dllama_UnloadModel(); cdecl; exports Dllama_UnloadModel;

// Messages
procedure Dllama_ClearMessages(); cdecl; exports Dllama_ClearMessages;
procedure Dllama_AddMessage(const ARole, AMessage: PAnsiChar); cdecl; exports Dllama_AddMessage;
function  Dllama_GetLastUserMessage(): PAnsiChar; cdecl; exports Dllama_GetLastUserMessage;

// Inference
function  Dllama_GetInferenceCallback(): TDllama.InferenceCallback; cdecl; exports Dllama_GetInferenceCallback;
procedure Dllama_SetInferenceCallback(const ASender: Pointer; const AHandler: TDllama.InferenceCallback); cdecl; exports Dllama_SetInferenceCallback;
function  Dllama_Inference(const AModelName: PAnsiChar; AResponse: PPAnsiChar; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean; cdecl; exports Dllama_Inference;
procedure Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger); cdecl; exports Dllama_GetInferenceUsage;

// Console
procedure Dllama_Console_GetSize(AWidth: PInteger; AHeight: PInteger); cdecl; exports Dllama_Console_GetSize;
procedure Dllama_Console_Clear(); cdecl; exports Dllama_Console_Clear;
procedure Dllama_Console_ClearLine(AColor: Word); cdecl; exports Dllama_Console_ClearLine;
procedure Dllama_Console_SetTitle(const ATitle: PAnsiChar); cdecl; exports Dllama_Console_SetTitle;
procedure Dllama_Console_Pause(const AForcePause: Boolean; AColor: Word; const aMsg: PAnsiChar); cdecl; exports Dllama_Console_Pause;
procedure Dllama_Console_Print(const AText: PAnsiChar; const AColor: Word); cdecl; exports Dllama_Console_Print;
procedure Dllama_Console_PrintLn(const AText: PAnsiChar; const AColor: Word); cdecl; exports Dllama_Console_PrintLn;

implementation

var
  LDllama: TDllama = nil;

procedure CheckDllama();
begin
  if not Assigned(LDllama) then Exit;
end;

function  Dllama_Init(): Boolean;
begin
  Result := False;
  if Assigned(LDllama) then Exit;
  LDllama := TDllama.Create();
  Result := True;
end;

procedure Dllama_Quit();
begin
  if not Assigned(LDllama) then Exit;
  LDllama.Free();
  LDllama := nil;
end;

procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PPAnsiChar);
begin
  if Assigned(AName) then
    AName^ := DLLAMA_NAME;

  if Assigned(ACodeName) then
    ACodeName^ := DLLAMA_CODENAME;

  if Assigned(AMajorVersion) then
    AMajorVersion^ := DLLAMA_MAJOR_VERSION;

  if Assigned(AMinorVersion) then
    AMinorVersion^ := DLLAMA_MINOR_VERSION;

  if Assigned(APatchVersion) then
    APatchVersion^ := DLLAMA_PATCH_VERSION;

  if Assigned(AVersion) then
    AVersion^ := DLLAMA_VERSION;

  if Assigned(AProject) then
    AProject^ := DLLAMA_PROJECT;
end;

// config
procedure Dllama_InitConfig(const AModelPath: PAnsiChar; const ANumGPULayers: Integer; const ADisplayInfo: Boolean; const ACancelInferenceKey: Byte);
begin
  if not Assigned(LDllama) then Exit;
  LDllama.InitConfig(UTF8ToUnicodeString(AModelPath), ANumGPULayers, ADisplayInfo, ACancelInferenceKey);
end;

procedure Dllama_GetConfig(AModelPath: PPAnsiChar; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte);
var
  LModelPath: string;
begin
  if not Assigned(LDllama) then Exit;

  LDllama.GetConfig(@LModelPath, ANumGPULayers, ADisplayInfo, ACancelInferenceKey);

  if Assigned(AModelPath) then
    AModelPath^ := Utils.AsUTF8(LModelPath);
end;

function  Dllama_SaveConfig(const AFilename: PAnsiChar): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.SaveConfig(UTF8ToUnicodeString(AFilename));
end;

function  Dllama_LoadConfig(const AFilename: PAnsiChar): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.LoadConfig(UTF8ToUnicodeString(AFilename));
end;


// error
function  Dllama_GetError(): PAnsiChar;
begin
  Result := nil;
  if not Assigned(LDllama) then Exit;

  Result := Utils.AsUTF8(LDllama.GetError());
end;

procedure Dllama_SetError(const AText: PAnsiChar);
begin
  if not Assigned(LDllama) then Exit;

  LDllama.SetError(UTF8ToUnicodeString(AText), [])
end;

procedure Dllama_ClearError();
begin
  if not Assigned(LDllama) then Exit;

  LDllama.ClearError();
end;


// model
function  Dllama_GetLoadModelProgressCallback(): TDllama.LoadModelProgressCallback;
begin
  Result := nil;
  if not Assigned(LDllama) then Exit;
  Result := LDllama.GetLoadModelProgressCallback();
end;

procedure Dllama_SetLoadModelProgressCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelProgressCallback);
begin
  if not Assigned(LDllama) then Exit;
  LDllama.SetLoadModelProgressCallback(ASender, AHandler);
end;

function  Dllama_GetLoadModelCallback(): TDllama.LoadModelCallback;
begin
  Result := nil;
  if not Assigned(LDllama) then Exit;
  Result := LDllama.GetLoadModelCallback();
end;

procedure Dllama_SetLoadModelCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelCallback);
begin
  if not Assigned(LDllama) then Exit;
  LDllama.SetLoadModelCallback(ASender, AHandler);
end;

function  Dllama_AddModel(const AFilename, AName: PAnsiChar; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: PAnsiChar; const AStopSequences: PPAnsiChar; const AStopSequencesCount: Cardinal): Boolean;
var
  LStopSequences: TArray<string>;
  I: Integer;
  LStopSequencesP: PPAnsiChar;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  if (AStopSequencesCount > 0) and Assigned(AStopSequences) then
  begin
    SetLength(LStopSequences, AStopSequencesCount);
    LStopSequencesP := AStopSequences;
    for I := 0 to AStopSequencesCount-1 do
    begin
      LStopSequences[I] := string(LStopSequencesP^);
      Inc(LStopSequencesP);
    end;
  end;

  Result := LDllama.AddModel(UTF8ToUnicodeString(AFilename), UTF8ToUnicodeString(AName), AMaxContext, UTF8ToUnicodeString(AChatMessageTemplate), UTF8ToUnicodeString(AChatMessageTemplateEnd), LStopSequences);

end;

procedure Dllama_ClearModels();
begin
  if not Assigned(LDllama) then Exit;

  LDllama.ClearModels();
end;

function  Dllama_GetModelCount(): Cardinal;
begin
  Result := 0;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.GetModelCount();
end;


function  Dllama_SaveModelDb(const AFilename: PAnsiChar): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.SaveModelDb(UTF8ToUnicodeString(AFilename));
end;

function  Dllama_LoadModelDb(const AFilename: PAnsiChar): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.LoadModelDb(UTF8ToUnicodeString(AFilename));
end;

function  Dllama_LoadModel(const AName: PAnsiChar): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.LoadModel(UTF8ToUnicodeString(AName));
end;

function  Dllama_IsModelLoaded(): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.GetModelLoaded();
end;

procedure Dllama_UnloadModel();
begin
  if not Assigned(LDllama) then Exit;

  LDllama.UnloadModel();
end;

// Messages
procedure Dllama_ClearMessages();
begin
  if not Assigned(LDllama) then Exit;

  LDllama.ClearMessages();
end;

procedure Dllama_AddMessage(const ARole, AMessage: PAnsiChar);
begin
  if not Assigned(LDllama) then Exit;

  LDllama.AddMessage(UTF8ToUnicodeString(ARole), UTF8ToUnicodeString(AMessage));
end;

function  Dllama_GetLastUserMessage(): PAnsiChar;
begin
  Result := nil;
  if not Assigned(LDllama) then Exit;

  Result := Utils.AsUTF8(LDllama.GetLastUserMessage());
end;


// Inference
function  Dllama_GetInferenceCallback(): TDllama.InferenceCallback;
begin
  Result := Nil;
  if not Assigned(LDllama) then Exit;
  Result := LDllama.GetInferenceCallback();
end;

procedure Dllama_SetInferenceCallback(const ASender: Pointer; const AHandler: TDllama.InferenceCallback);
begin
  if not Assigned(LDllama) then Exit;
  LDllama.SetInferenceCallback(ASender, AHandler);
end;

function  Dllama_Inference(const AModelName: PAnsiChar; AResponse: PPAnsiChar; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean;
var
  LResponse: string;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  if Assigned(AResponse) then
    LResponse := string(AResponse^);

  Result := LDllama.Inference(string(AModelName), LResponse, AMaxTokens, ATemperature, ASeed);

  if Assigned(AResponse) then
    AResponse^ := Utils.AsUTF8(LResponse);
end;

procedure Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger);
var
  LUsage: TDllama.Usage;
begin
  if not Assigned(LDllama) then Exit;

  LDllama.GetInferenceUsage(LUsage);

  if Assigned(ATokenInputSpeed) then
    ATokenInputSpeed^ := LUsage.TokenInputSpeed;

  if Assigned(TokenOutputSpeed) then
    TokenOutputSpeed^ := LUsage.TokenOutputSpeed;

  if Assigned(AInputTokens) then
    AInputTokens^ := LUsage.InputTokens;

  if Assigned(AOutputTokens) then
    AOutputTokens^ := LUsage.OutputTokens;

  if Assigned(ATotalTokens) then
    ATotalTokens^ := LUsage.TotalTokens;

end;

// Console
procedure Dllama_Console_GetSize(AWidth: PInteger; AHeight: PInteger);
begin
  Console.GetSize(AWidth, AHeight);
end;

procedure Dllama_Console_Clear();
begin
  Console.Clear();
end;

procedure Dllama_Console_ClearLine(AColor: Word);
begin
  Console.ClearLine(AColor);
end;

procedure Dllama_Console_SetTitle(const ATitle: PAnsiChar);
begin
  Console.SetTitle(UTF8ToUnicodeString(ATitle));
end;

procedure Dllama_Console_Pause(const AForcePause: Boolean; aColor: Word; const aMsg: PAnsiChar);
begin
  Console.Pause(AForcePause, AColor, UTF8ToUnicodeString(AMsg));
end;

procedure Dllama_Console_Print(const AText: PAnsiChar; const AColor: Word);
begin
  Console.Print(UTF8ToUnicodeString(AText), AColor);
end;

procedure Dllama_Console_PrintLn(const AText: PAnsiChar; const AColor: Word);
begin
  Console.PrintLn(UTF8ToUnicodeString(AText), AColor);
end;


initialization
begin
  ReportMemoryLeaksOnShutdown := True;
  Dllama_Init();
end;

finalization
begin
  Dllama_Quit();
end;

end.
