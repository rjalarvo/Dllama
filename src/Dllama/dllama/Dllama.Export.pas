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

unit Dllama.Export;

{$I Dllama.Defines.inc}

interface

uses
  System.SysUtils,
  System.IOUtils,
  WinAPI.Windows,
  Dllama.Deps,
  Dllama.Deps.Ext,
  Dllama.Utils,
  Dllama.Core;

// Init
function  Dllama_Init(): Boolean; cdecl;
procedure Dllama_Quit(); cdecl;
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PPAnsiChar); cdecl;

// Config
procedure Dllama_InitConfig(const AModelPath: PAnsiChar; const ANumGPULayers: Integer; const ADisplayInfo: Boolean; const ACancelInferenceKey: Byte); cdecl;
procedure Dllama_GetConfig(AModelPath: PPAnsiChar; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte); cdecl;
function  Dllama_SaveConfig(const AFilename: PAnsiChar): Boolean; cdecl;
function  Dllama_LoadConfig(const AFilename: PAnsiChar): Boolean; cdecl;

// Error
function  Dllama_GetError(): PAnsiChar; cdecl;
procedure Dllama_SetError(const AText: PAnsiChar); cdecl;
procedure Dllama_ClearError(); cdecl;

// Model
function  Dllama_GetLoadModelProgressCallback(): TDllama.LoadModelProgressCallback; cdecl;
procedure Dllama_SetLoadModelProgressCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelProgressCallback); cdecl;
function  Dllama_GetLoadModelCallback(): TDllama.LoadModelCallback; cdecl;
procedure Dllama_SetLoadModelCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelCallback); cdecl;
function  Dllama_AddModel(const AFilename, AName: PAnsiChar; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: PAnsiChar; const AStopSequences: PPAnsiChar; const AStopSequencesCount: Cardinal): Boolean; cdecl;
procedure Dllama_ClearModels(); cdecl;
function  Dllama_GetModelCount(): Cardinal; cdecl;
function  Dllama_SaveModelDb(const AFilename: PAnsiChar): Boolean; cdecl;
function  Dllama_LoadModelDb(const AFilename: PAnsiChar): Boolean; cdecl;
function  Dllama_LoadModel(const AName: PAnsiChar): Boolean; cdecl;
function  Dllama_IsModelLoaded(): Boolean; cdecl;
procedure Dllama_UnloadModel(); cdecl;

// Messages
procedure Dllama_ClearMessages(); cdecl;
procedure Dllama_AddMessage(const ARole, AContent: PAnsiChar); cdecl;
function  Dllama_GetLastUserMessage(): PAnsiChar; cdecl;

// Inference
function  Dllama_GetInferenceCallback(): TDllama.InferenceCallback; cdecl;
procedure Dllama_SetInferenceCallback(const ASender: Pointer; const AHandler: TDllama.InferenceCallback); cdecl;
function  Dllama_GetInferenceDoneCallback(): TDllama.InferenceDoneCallback; cdecl; exports Dllama_GetInferenceDoneCallback;
procedure Dllama_SetInferenceDoneCallback(const ASender: Pointer; const AHandler: TDllama.InferenceDoneCallback); cdecl;
function  Dllama_Inference(const AModelName: PAnsiChar; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean; cdecl;
function  Dllama_GetInferenceResponse(): PAnsiChar; cdecl;
procedure Dllama_GetInferenceUsage(ATokenInputSpeed, ATokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger); cdecl;
function  Dllama_IsInferenceActive(): Boolean; cdecl; exports Dllama_IsInferenceActive;
function  Dllama_Simple_Inference(const AModelPath, AModelsDb, AModelName: PAnsiChar; const AUseGPU: Boolean; const AMaxTokens: UInt32; const ACancelInferenceKey: Byte; const AQuestion: PAnsiChar): PAnsiChar; cdecl;


// Console
procedure Dllama_Console_GetSize(AWidth: PInteger; AHeight: PInteger); cdecl;
procedure Dllama_Console_Clear(); cdecl;
procedure Dllama_Console_ClearLine(AColor: Word); cdecl;
procedure Dllama_Console_SetTitle(const ATitle: PAnsiChar); cdecl;
procedure Dllama_Console_Pause(const AForcePause: Boolean; AColor: Word; const aMsg: PAnsiChar); cdecl;
procedure Dllama_Console_Print(const AText: PAnsiChar; const AColor: Word); cdecl;
procedure Dllama_Console_PrintLn(const AText: PAnsiChar; const AColor: Word); cdecl;

// TokenResponse
procedure Dllama_TokenResponse_SetRightMargin(const AMargin: Integer); cdecl;
function  Dllama_TokenResponse_AddToken(const aToken: PAnsiChar): Integer; cdecl;
function  Dllama_TokenResponse_LastWord(): PAnsiChar; cdecl;
function  Dllama_TokenResponse_Finalize(): Boolean; cdecl;

// UTF8
function  Dllama_UTF8Encode(const AText: PAnsiChar): PAnsiChar; cdecl;
function  Dllama_UTF8Decode(const AText: PAnsiChar): PAnsiChar; cdecl;
procedure Dllama_FreeStr(const AText: PAnsiChar); cdecl;


implementation

var
  LDllama: TDllama = nil;
  LTokenResponse: TTokenResponse;

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

procedure Dllama_AddMessage(const ARole, AContent: PAnsiChar);
var
  LRole: string;
  LContent: string;
begin
  if not Assigned(LDllama) then Exit;

  LRole := UTF8ToString(ARole);
  LContent := UTF8ToString(AContent);

  LDllama.AddMessage(LRole, LContent);
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

function  Dllama_GetInferenceDoneCallback(): TDllama.InferenceDoneCallback;
begin
  Result := nil;
  if not Assigned(LDllama) then Exit;
  Result := LDllama.GetInferenceDoneCallback();
end;

procedure Dllama_SetInferenceDoneCallback(const ASender: Pointer; const AHandler: TDllama.InferenceDoneCallback);
begin
  if not Assigned(LDllama) then Exit;
  LDllama.SetInferenceDoneCallback(ASender, AHandler);
end;

function  Dllama_Inference(const AModelName: PAnsiChar; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;

  Result := LDllama.Inference(UTF8ToString(AModelName), AMaxTokens, ATemperature, ASeed);
end;

function  Dllama_GetInferenceResponse(): PAnsiChar;
begin
  Result := PUTF8Char(LDllama.GetInferenceResponse());
end;

procedure Dllama_GetInferenceUsage(ATokenInputSpeed, ATokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger);
var
  LUsage: TDllama.Usage;
begin
  if not Assigned(LDllama) then Exit;

  LDllama.GetInferenceUsage(LUsage);

  if Assigned(ATokenInputSpeed) then
    ATokenInputSpeed^ := LUsage.TokenInputSpeed;

  if Assigned(ATokenOutputSpeed) then
    ATokenOutputSpeed^ := LUsage.TokenOutputSpeed;

  if Assigned(AInputTokens) then
    AInputTokens^ := LUsage.InputTokens;

  if Assigned(AOutputTokens) then
    AOutputTokens^ := LUsage.OutputTokens;

  if Assigned(ATotalTokens) then
    ATotalTokens^ := LUsage.TotalTokens;
end;

function  Dllama_IsInferenceActive(): Boolean;
begin
  Result := False;
  if not Assigned(LDllama) then Exit;
  Result := LDllama.IsInferenceActive();
end;


function Dllama_Simple_LoadModelProgressCallback(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
begin
  Result := True;
end;

procedure Dllama_Simple_InferenceCallback(const ASender: Pointer; const AToken: PAnsiChar); cdecl;
begin
end;

function  Dllama_Simple_Inference(const AModelPath, AModelsDb, AModelName: PAnsiChar; const AUseGPU: Boolean; const AMaxTokens: UInt32; const ACancelInferenceKey: Byte; const AQuestion: PAnsiChar): PAnsiChar;
var
  LModelPath: string;
  LModelsDb: string;
  LQuestion: string;
  LModelName: string;
  LNumGPULayers: Integer;

  function ConvertToUTF8(const Input: PAnsiChar; CodePage: Word): RawByteString;
  var
    S: string;
  begin
    S := TEncoding.GetEncoding(CodePage).GetString(BytesOf(Input));
    Result := RawByteString(TEncoding.UTF8.GetBytes(S));
  end;

begin
  Result := nil;
  if LDllama.IsInferenceActive() then Exit;

  LQuestion := UTF8ToString(AQuestion);
  //LQuestion := UTF8ToString(ConvertToUTF8(AQuestion, 1251));
  if LQuestion.IsEmpty then
  begin
    Result := 'Question can not be blank.';
    Exit;
  end;

  LModelName := UTF8ToString(AModelName);
  if LQuestion.IsEmpty then
  begin
    Result := 'ModelName can not be blank.';
    Exit;
  end;

  LModelPath := UTF8ToString(AModelPath);
  if not TDirectory.Exists(LModelPath) then
  begin
    Result := Utils.AsUTF8(Format('Models path was not found: "%s" ', [LModelPath]));
    Exit;
  end;

  LModelsDb := TPath.ChangeExtension(UTF8ToString(AModelsDb), 'json');
  if not TFile.Exists(LModelsDb) then
  begin
    Result := Utils.AsUTF8(Format('Models database file was not found: "%s" ', [LModelsDb]));
    Exit;
  end;

  if AUseGPU then
    LNumGPULayers := -1
  else
    LNumGPULayers := 0;
  LDllama.InitConfig(LModelPath, LNumGPULayers, False, ACancelInferenceKey);


  LModelsDb := UTF8ToString(AModelsDb);
  if not LDllama.LoadModelDb(LModelsDb) then
  begin
    Result := Utils.AsUTF8(LDllama.GetError());
    Exit;
  end;

  LDllama.SetLoadModelProgressCallback(nil, Dllama_Simple_LoadModelProgressCallback);
  LDllama.SetInferenceCallback(nil, Dllama_Simple_InferenceCallback);

  LDllama.AddMessage('user', LQuestion);

  if LDllama.Inference(LModelName, AMaxTokens, 1, 1024) then
    begin
      Result := Dllama_GetInferenceResponse();
    end
  else
    begin
      Result := Utils.AsUTF8(Format('Error: %s', [LDllama.GetError()]));
    end;

  // unload model
  LDllama.UnloadModel();

  LDllama.SetInferenceCallback(nil, nil);
  LDllama.SetLoadModelProgressCallback(nil, nil);
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

// TokenResponse
procedure Dllama_TokenResponse_SetRightMargin(const AMargin: Integer);
begin
  LTokenResponse.SetRightMargin(AMargin);
end;

function  Dllama_TokenResponse_AddToken(const AToken: PAnsiChar): Integer;
begin
  Result := Ord(LTokenResponse.AddToken(UTF8ToUnicodeString(AToken)));
end;

function  Dllama_TokenResponse_LastWord(): PAnsiChar;
begin
  Result := Utils.AsUTF8(LTokenResponse.LastWord());
end;

function  Dllama_TokenResponse_Finalize: Boolean;
begin
  Result := LTokenResponse.Finalize();
end;

// UTF8
function Dllama_UTF8Encode(const AText: PAnsiChar): PAnsiChar;
var
  LText: UTF8String;
begin
  LText := AText;
  GetMem(Result, Length(LText) + 1);
  Move(LText[1], Result^, Length(LText));
  Result[Length(LText)] := #0;
end;

function Dllama_UTF8Decode(const AText: PAnsiChar): PAnsiChar;
var
  LText: UTF8String;
  LResult: AnsiString;
begin
  LText := AText;
  LResult := AnsiString(LText);

  GetMem(Result, Length(LResult) + 1);
  Move(LResult[1], Result^, Length(LResult));
  Result[Length(LResult)] := #0;
end;

procedure Dllama_FreeStr(const AText: PAnsiChar);
begin
  if AText <> nil then
    FreeMem(AText);
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
