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

unit Dllama.Core;

{$I Dllama.Defines.inc}

interface

uses
  WinApi.Windows,
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Math,
  System.JSON,
  Dllama.Deps;

const
  DLLAMA_NAME          = 'Dllama™';
  DLLAMA_CODENAME      = 'AlpacaCore';
  DLLAMA_MAJOR_VERSION = '0';
  DLLAMA_MINOR_VERSION = '2';
  DLLAMA_PATCH_VERSION = '0';
  DLLAMA_VERSION       = DLLAMA_MAJOR_VERSION+'.'+DLLAMA_MINOR_VERSION+'.'+DLLAMA_PATCH_VERSION;
  DLLAMA_PROJECT       = DLLAMA_NAME+' ('+DLLAMA_CODENAME+') v'+DLLAMA_MAJOR_VERSION+'.'+DLLAMA_MINOR_VERSION+'.'+DLLAMA_PATCH_VERSION;

type
{$REGION ' TJsonHelper '}

  { TJsonHelper }
  TJsonObject = System.Json.TJSONObject;

  TJsonArray = System.Json.TJSONArray;

  TJsonValueType = (jvtString, jvtObject);

  TJsonHelper = class helper for TJsonObject
  private
    function GetBool(AParam: string): Boolean;
    procedure SetBool(AParam: string; const Value: Boolean);
    function GetString(AParam: string): string;
    procedure SetString(AParam: string; const Value: string);
    function GetObject(AName: string): TJsonObject;
    procedure SetObject(AName: string; const Value: TJsonObject);
    function GetArray(AName: string): TJSONArray;
    procedure SetArray(AName: string; const Value: TJSONArray);
    function GetNames(AIndex: integer): string;
    function GetTypes(AName: string): TJsonValueType;
    function GetInteger(AParam: string): integer;
    procedure SetInteger(AParam: string; const Value: integer);
    function GetFloat(AParam: string): Double;
    procedure SetFloat(AParam: string; const Value: Double);

  public
    function Contains(AName: string): Boolean;
    function IsNull(AName: string): Boolean;
    procedure Assign(ASource: TJSONValue);
    procedure FromJSON(AJson: string);

    function AddObject(const AName: string): TJsonObject;
    function AddArray(const AName: string): TJsonArray;

    class function Parse(const AData: string): TJsonObject; overload;
    class function ParseJSONArray(const AJSONArrayStr: string): TJSONArray;

    property Types[AName: string]: TJsonValueType read GetTypes;
    property Names[AIndex: integer]: string read GetNames;
    property B[AParam: string]: Boolean read GetBool write SetBool;
    property S[AParam: string]: string read GetString write SetString;
    property I[AParam: string]: Integer read GetInteger write SetInteger;
    property F[AParam: string]: Double read GetFloat write SetFloat;
    property O[AName: string]: TJsonObject read GetObject write SetObject;
    property A[AName: string]: TJSONArray read GetArray write SetArray;
  end;
{$ENDREGION}

{$REGION ' TDllama '}
  { TDllama }
  TDllama = class
  public const
    LF   = #10;
    CR   = #13;
    CRLF = LF+CR;

    BRIGHTYELLOW = FOREGROUND_RED OR FOREGROUND_GREEN OR FOREGROUND_INTENSITY;
    YELLOW       = FOREGROUND_RED OR FOREGROUND_GREEN;
    WHITE        = FOREGROUND_RED OR FOREGROUND_GREEN OR FOREGROUND_BLUE;
    BRIGHTWHITE  = FOREGROUND_RED OR FOREGROUND_GREEN OR FOREGROUND_BLUE OR FOREGROUND_INTENSITY;
    DARKGREEN    = FOREGROUND_GREEN;
    DARKGRAY     = FOREGROUND_INTENSITY;
    CYAN         = FOREGROUND_GREEN OR FOREGROUND_BLUE;
    MAGENTA      = FOREGROUND_RED OR FOREGROUND_BLUE;
    RED          = FOREGROUND_RED;

    ROLE_SYSTEM = 'system';
    ROLE_USER = 'user';
    ROLE_ASSISTANT = 'assistant ';
    ROLE_TOOL = 'tool';

  public type
    ErrorCallback = procedure(const ASender: Pointer; const AError: PAnsiChar); cdecl;
    InfoCallback = procedure(const ASender: Pointer; const ALevel: Integer; const AText: PAnsiChar); cdecl;
    LoadModelProgressCallback = function(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
    LoadModelCallback = procedure(const ASender: Pointer; const ASuccess: Boolean); cdecl;
    InferenceStartCallback = procedure(const ASender: Pointer); cdecl;
    InferenceDoneCallback = procedure(const ASender: Pointer; const AResponse: PAnsiChar); cdecl;
    InferenceTokenCallback = procedure(const ASender: Pointer; const AToken: PAnsiChar); cdecl;

    PCallbacks = ^Callbacks;
    Callbacks = record
      Sender: Pointer;
      ErrorCallback: TDllama.ErrorCallback;
      InfoCallback: TDllama.InfoCallback;
      LoadModelProgressCallback: TDllama.LoadModelProgressCallback;
      LoadModelCallback: TDllama.LoadModelCallback;
      InferenceStartCallback: TDllama.InferenceStartCallback;
      InferenceDoneCallback: TDllama.InferenceDoneCallback;
      InferenceTokenCallback: TDllama.InferenceTokenCallback;
    end;

    PUsage = ^Usage;
    Usage = record
      TokenInputSpeed: Double;
      TokenOutputSpeed: Double;
      InputTokens: Int32;
      OutputTokens: Int32;
      TotalTokens: Int32;
    end;
  private type
    TModel = record
      Filename: string;
      Name: string;
      MaxContext: UInt32;
      Template: string;
      TemplateEnd: string;
      Stop: TArray<string>;
    end;
    TChatMessage = record
      Role: string;
      Context: string;
    end;
    TModels = TDictionary<string, TModel>;
    TMessages = TList<TChatMessage>;
  private
    FModel: Pllama_model;
    FContext: Pllama_context;
    FModels: TModels;
    FMessages: TMessages;
    FModelPath: string;
    FNumGPULayers: Int32;
    FLoadedModel: TModel;
    FError: UTF8String;
    FInit: Boolean;
    FCallbacks: TDllama.Callbacks;
    FLastKeyState: Boolean;
    FInferenceCancelKey: Word;
    FInferenceResponse: UTF8String;
    FLastUserMessage: UTF8String;
    function  ContainsText(const AText, ASubText: string): Boolean;
    function  SanitizeFromJson(const AText: string): string;
    function  HasOutput(): Boolean;
    procedure SetTextColor(AColor: WORD);
    function  GetPhysicalProcessorCount: DWORD;
    function  WasKeyPressed(const AKey: Word): Boolean;
    procedure SetError(const AMsg: string; const AArgs: array of const);
    function  AddModel(const AFilename, AName: string; const AMaxContext: UInt32; const ATemplate, ATemplateEnd: string; const AStop: TArray<string>): Boolean;
    function  LoadConfig(const AFilename: string): Boolean;
    function  LoadModel(const AModelName: string): Boolean;
    procedure UnloadModel();
    function  Tokenize(ctx: Pllama_context; const text: string; addSpecial: Boolean; parseSpecial: Boolean = False): TArray<llama_token>;
    function  TokenToPiece(ctx: Pllama_context; token: llama_token; special: Boolean = True): string;
    procedure BatchAdd(var batch: llama_batch; id: llama_token; pos: llama_pos; const seq_ids: TArray<llama_seq_id>; logits: Boolean);
    procedure OnError(const AText: UTF8String);
    procedure OnInfo(const ALevel: Integer; const AText: string);
    procedure OnInferenceToken(const AToken: string);
    procedure OnInferenceStart();
    procedure OnInferenceDone();
    function  OnLoadModelProgress(const AModelName: string; const AProgress: Single): Boolean;
    procedure OnLoadModel(const ASuccess: Boolean);
  public
    constructor Create(); virtual;
    destructor Destroy(); override;

    // init
    function  CreateExampleConfig(const AConfigFilename: string='example_config.json'): Boolean;
    function  Init(const AConfigFilename: string; const ACallbacks: PCallbacks): Boolean;
    procedure Quit();

    // message
    procedure ClearMessages();
    procedure AddMessage(const ARole, AContent: string);
    function  GetLastUserMessage(): UTF8String;

    // inference
    function  Inference(const AModelName: string; const AMaxTokens: UInt32; AResponse: PPAnsiChar=nil; const AUsage: PUsage=nil; const AError: PPAnsiChar=nil): Boolean;

    // console
    procedure ClearLine(AColor: WORD);
    procedure Print(const AMsg: string; const AArgs: array of const; const AColor: WORD=WHITE); overload;
    procedure Print(const AText: string; const AColor: WORD=WHITE); overload;
  end;

{ exports }

procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PPAnsiChar); cdecl;
function  Dllama_CreateExampleConfig(const AConfigFilename: PAnsiChar): Boolean; cdecl;
function  Dllama_Init(const AConfigFilename: PAnsiChar; const ACallbacks: TDllama.PCallbacks): Boolean; cdecl;
procedure Dllama_Quit(); cdecl;
procedure Dllama_ClearMessages(); cdecl;
procedure Dllama_AddMessage(const ARole, AContent: PAnsiChar); cdecl;
function  Dllama_GetLastUserMessage(): PAnsiChar; cdecl;
function  Dllama_Inference(const AModelName: PAnsiChar; const AMaxTokens: UInt32; AResponse: PPAnsiChar=nil; const AUsage: TDllama.PUsage=nil; const AError: PPAnsiChar=nil): Boolean; cdecl;
function  Dllama_Simple_Inference(const AConfigFilename, AModelName, AQuestion: PAnsiChar; const AMaxTokens: UInt32): PAnsiChar; cdecl;
procedure Dllama_ClearLine(AColor: WORD); cdecl;
procedure Dllama_Print(const AText: PAnsiChar; const AColor: WORD=TDllama.WHITE); cdecl;

{$ENDREGION}

implementation

{$REGION ' TJsonHelper '}
{ TJsonHelper }
procedure TJsonHelper.Assign(ASource: TJSONValue);
begin
  FromJSON(ASource.ToJSON);
end;

function TJsonHelper.Contains(AName: string): Boolean;
begin
  Result := FindValue(AName) <> nil;
end;

procedure TJsonHelper.FromJSON(AJson: string);
begin
  Parse(BytesOf(AJson), 0);
end;

function TJsonHelper.AddObject(const AName: string): TJsonObject;
begin
  Result := TJsonObject.Create();
  AddPair(AName, Result);
end;

function TJsonHelper.AddArray(const AName: string): TJsonArray;
begin
  Result := TJsonArray.Create();
  AddPair(AName, Result);
end;

class function TJsonHelper.Parse(const AData: string): TJsonObject;
begin
  Result := TJSONObject.ParseJSONValue(AData) as TJSONObject;
end;

class function TJsonHelper.ParseJSONArray(const AJSONArrayStr: string): TJSONArray;
begin
  Result := TJSONArray.ParseJSONValue(AJSONArrayStr) as TJSONArray;
end;

function TJsonHelper.GetArray(AName: string): TJSONArray;
begin
  Result := FindValue(AName) as TJsonArray;
  if Result = nil then
  begin
    Result := TJSONArray.Create;
    AddPair(AName, Result);
  end;
end;

function TJsonHelper.GetBool(AParam: string): Boolean;
var
  AValue: TJSONValue;
begin
  Result := False;
  AValue := FindValue(AParam);
  if AValue <> nil then
    Result := AValue.AsType<Boolean> = True;
end;

function TJsonHelper.GetInteger(AParam: string): integer;
var
  AValue: TJSONValue;
begin
  Result := 0;

  AValue := FindValue(AParam);
  if AValue <> nil then
    Result := AValue.AsType<Integer>;
end;

function TJsonHelper.GetNames(AIndex: integer): string;
begin
  Result := Pairs[AIndex].JsonString.Value;
end;

function TJsonHelper.GetObject(AName: string): TJsonObject;
begin
  Result := Values[AName] as TJSONObject;
  if Result = nil then
  begin
    Result := TJsonObject.Create;
    AddPair(AName, TJsonObject.Create);
  end;
end;

function TJsonHelper.GetString(AParam: string): string;
var
  AValue: TJSONValue;
begin
  Result := '';
  AValue := FindValue(AParam);
  if AValue <> nil then
    Result := AValue.AsType<string>;
end;

function TJsonHelper.IsNull(AName: string): Boolean;
begin
  Result := Values[AName] is TJSONNull;
end;

procedure TJsonHelper.SetArray(AName: string; const Value: TJSONArray);
begin
  AddPair(AName, Value);
end;

procedure TJsonHelper.SetBool(AParam: string; const Value: Boolean);
begin
  AddPair(AParam, TJSONBool.Create(Value));
end;

procedure TJsonHelper.SetInteger(AParam: string; const Value: integer);
begin
  AddPair(AParam, TJSONNumber.Create(Value));
end;

function TJsonHelper.GetFloat(AParam: string): Double;
begin
  Result := StrToFloatDef(AParam, 0);
end;

procedure TJsonHelper.SetFloat(AParam: string; const Value: Double);
begin
  AddPair(AParam, TJSONNumber.Create(Value));
end;

procedure TJsonHelper.SetObject(AName: string; const Value: TJsonObject);
begin
  AddPair(AName, Value)
end;

procedure TJsonHelper.SetString(AParam: string; const Value: string);
begin
  AddPair(AParam, TJSONString.Create(Value));
end;

function TJsonHelper.GetTypes(AName: string): TJsonValueType;
var
  APair: TJSONValue;
begin
  Result := jvtObject;
  APair := GetValue(AName);
  if APair is TJsonObject then Result := jvtObject;
  if APair is TJSONString then Result := jvtString;
end;
{$ENDREGION}

{ TDllama }
// Callbacks
function TDllama_ModelLoadProgressCallback(AProgress: single; AUserData: pointer): Boolean; cdecl;
var
  LDllama: TDllama;
begin
  LDllama := AUserData;

  if Assigned(LDllama) then
    Result := LDllama.OnLoadModelProgress(LDllama.FLoadedModel.Name, AProgress)
  else
    Result := True;
end;

procedure TDllama_LogCallback(ALevel: ggml_log_level; const AText: PUTF8Char; AUserData: Pointer); cdecl;
begin
  if Assigned(AUserData) then
    TDllama(AUserData).OnInfo(ALevel, Utf8ToString(AText));
end;

procedure TDllama_CErrCallback(const AText: PUTF8Char; AUserData: Pointer); cdecl;
begin
  if Assigned(AUserData) then
    TDllama(AUserData).OnInfo(GGML_LOG_LEVEL_ERROR, Utf8ToString(AText));
end;

function TDllama.ContainsText(const AText, ASubText: string): Boolean;
begin
  Result := Pos(UpperCase(ASubText), UpperCase(AText)) > 0;
end;

function  TDllama.SanitizeFromJson(const AText: string): string;
var
  LText: string;
begin
  LText := AText;
  LText := LText.Replace('\n', #10);
  LText := LText.Replace('\r', #13);
  LText := LText.Replace('\b', #8);
  LText := LText.Replace('\t', #9);
  LText := LText.Replace('\f', #12);
  LText := LText.Replace('\/', '/');
  LText := LText.Replace('\"', '"');
  LText := LText.Replace('\\', '\');
  Result := LText;
end;

function  TDllama.HasOutput(): Boolean;
var
  LStdOut: THandle;
  LMode: DWORD;
begin
  LStdOut := GetStdHandle(STD_OUTPUT_HANDLE);
  Result := (LStdOut <> INVALID_HANDLE_VALUE) and GetConsoleMode(LStdOut, LMode);
end;

procedure TDllama.SetTextColor(AColor: WORD);
var
  LConsoleHandle: THandle;
begin
  LConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(LConsoleHandle, AColor);
end;

function TDllama.GetPhysicalProcessorCount: DWORD;
var
  BufferSize: DWORD;
  Buffer: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;
  ProcessorInfo: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;
  Offset: DWORD;
begin
  Result := 0;
  BufferSize := 0;

  // Call GetLogicalProcessorInformation with buffer size set to 0 to get required buffer size
  if not GetLogicalProcessorInformation(nil, BufferSize) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
  begin
    // Allocate buffer
    GetMem(Buffer, BufferSize);
    try
      // Call GetLogicalProcessorInformation again with allocated buffer
      if GetLogicalProcessorInformation(Buffer, BufferSize) then
      begin
        ProcessorInfo := Buffer;
        Offset := 0;

        // Loop through processor information to count physical processors
        while Offset + SizeOf(SYSTEM_LOGICAL_PROCESSOR_INFORMATION) <= BufferSize do
        begin
          if ProcessorInfo.Relationship = RelationProcessorCore then
            Inc(Result);

          Inc(ProcessorInfo);
          Inc(Offset, SizeOf(SYSTEM_LOGICAL_PROCESSOR_INFORMATION));
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure TDllama.SetError(const AMsg: string; const AArgs: array of const);
begin
  FError := UTF8Encode(Format(AMsg, AArgs));
  OnError(FError);
end;

function  TDllama.AddModel(const AFilename, AName: string; const AMaxContext: UInt32; const ATemplate, ATemplateEnd: string; const AStop: TArray<string>): Boolean;
var
  LModel: TModel;
begin
  Result := False;

  if AFilename.IsEmpty then
  begin
    SetError('[%s] Model filename can not be blank"', ['TDllama.AddModel']);
    Exit;
  end;

  if AName.IsEmpty then
  begin
    SetError('[%s] Model reference name can not be blank"', ['TDllama.AddModel']);
    Exit;
  end;

  LModel.Filename := TPath.ChangeExtension(AFilename, 'gguf');
  LModel.Name := AName;
  LModel.MaxContext := AMaxContext;
  LModel.Template := ATemplate;
  LModel.TemplateEnd := ATemplateEnd;
  LModel.Stop := AStop;

  FModels.AddOrSetValue(AName, LModel);

  Result := True;
end;

function  TDllama.LoadConfig(const AFilename: string): Boolean;
var
  LFilename: string;
  LText: string;
  LJson: TJsonObject;
  LArray: TJsonArray;
  I,J: Integer;
  LModel: TModel;

  function FieldExist(const AJSONValue: TJSONValue; const APath: string): Boolean;
  begin
    Result := Boolean(AJSONValue.FindValue(APath) <> nil);
    if Result= False then
    begin
      SetError('[%s] Field "%s" was not found', ['TDllama.LoadConfig', APath]);
    end;
  end;

begin
  Result := False;

  try
    LFilename := TPath.ChangeExtension(AFilename, 'json');
    if not TFile.Exists(LFilename) then
    begin
      SetError('[%s] Dllama configuration file was not found: "%s"', ['TDllama.LoadConfig', LFilename]);
      Exit;
    end;

    LText := TFile.ReadAllText(AFilename, TEncoding.UTF8);

    LJson := TJsonObject.Parse(LText);
    try
      if not FieldExist(LJson, 'model_path') then
        Exit
      else
        FModelPath := LJson.S['model_path'];

      if not FieldExist(LJson, 'gpu_layers') then
        Exit
      else
        FNumGPULayers := LJson.I['gpu_layers'];
      if FNumGPULayers < 0 then
        FNumGPULayers := MaxInt
      else
       FNumGPULayers := EnsureRange(FNumGPULayers, 0, MaxInt);

      if not FieldExist(LJson, 'models') then
        Exit;

      for I := 0 to LJson.A['models'].Count-1 do
      begin
        if not FieldExist(LJson.A['models'].Items[I], 'filename') then
          Exit
        else
          LModel.Filename := LJson.A['models'].Items[I].FindValue('filename').Value;

        if not FieldExist(LJson.A['models'].Items[I], 'name') then
          Exit
        else
          LModel.Name := LJson.A['models'].Items[I].FindValue('name').Value;

        if not FieldExist(LJson.A['models'].Items[I], 'max_context') then
          Exit
        else
          LModel.MaxContext := LJson.A['models'].Items[I].FindValue('max_context').Value.ToInt64;

        if not FieldExist(LJson.A['models'].Items[I], 'template') then
          Exit
        else
          LModel.Template := LJson.A['models'].Items[I].FindValue('template').Value;

        if not FieldExist(LJson.A['models'].Items[I], 'template_end') then
          Exit
        else
          LModel.TemplateEnd := LJson.A['models'].Items[I].FindValue('template_end').Value;

        if not FieldExist(LJson.A['models'].Items[I], 'stop') then
          Exit;

        LArray := LJson.A['models'].Items[I].FindValue('stop') as TJsonArray;
        SetLength(LModel.Stop, LArray.Count);
        for J := 0 to LArray.Count-1 do
        begin
          LModel.Stop[J] := LArray.Items[J].Value;
        end;

        if not AddModel(LModel.Filename, LModel.Name, LModel.MaxContext, LModel.Template, LModel.TemplateEnd, LModel.Stop) then
          Exit;
      end;

      Result := True;

    finally
      LJson.Free();
    end;

  except
    on E: Exception do
    begin
      SetError('[%s] %s', ['TDllama.LoadConfig', E.Message]);
      Exit;
    end;
  end;

end;

function  TDllama.LoadModel(const AModelName: string): Boolean;
var
  LModelParams: llama_model_params;
  LContexParams: llama_context_params;
  LFilename: string;
begin
  Result := False;

  if not FInit then
  begin
    SetError('[%s] Dllama has not been initalized', ['TDllama.LoadConfig']);
    Exit;
  end;

  if Assigned(FModel) then
  begin
    if AModelName = FLoadedModel.Name then Exit;
  end;

  try
    if not FModels.TryGetValue(AModelName, FLoadedModel) then
    begin
      SetError('[TDllama.LoadModel] Refrence model "%s" not found.', [AModelName]);
      Exit;
    end;

    LFilename := TPath.Combine(FModelPath, FLoadedModel.Filename);
    if not TFile.Exists(LFilename) then
    begin
      SetError('[TDllama.LoadModel] Model "%s" not found.', [LFilename]);
      Exit;
    end;

    UnloadModel();

    LModelParams := llama_model_default_params();
    LModelParams.progress_callback_user_data := Self;
    LModelParams.progress_callback := TDllama_ModelLoadProgressCallback;

    {TODO: figure how to find the actual number of gpu layers available. For now,
           setting to a super high value will cause it to use the max number
           that is actually available. For my GPU it's 33 for example. }
    LModelParams.n_gpu_layers := FNumGPULayers;

    FModel := llama_load_model_from_file(PUTF8Char(UTF8Encode(LFilename)), LModelParams);
    if not Assigned(FModel) then
    begin
      SetError('[TDllama.LoadModel] Unable to load model: "%s"', [LFilename]);
      UnloadModel();
      Exit;
    end;
    OnLoadModel(True);

    LContexParams := llama_context_default_params();
    LContexParams.offload_kqv := true;
    LContexParams.seed  := MaxInt;
    LContexParams.n_ctx := FLoadedModel.MaxContext;
    LContexParams.n_threads := GetPhysicalProcessorCount();
    LContexParams.n_threads_batch := LContexParams.n_threads;
    FContext := llama_new_context_with_model(FModel, LContexParams);
    if not Assigned(FContext) then
    begin
      SetError('[TDllama.LoadModel] Failed to create llama context', []);
      UnloadModel();
      Exit;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      SetError('[%s] %s', ['TDllama.LoadConfig', E.Message]);
      UnloadModel();
      Exit;
    end;
  end;
end;

procedure TDllama.UnloadModel();
begin
  if Assigned(FContext) then
  begin
    llama_free(FContext);
    FContext := nil;
  end;

  if Assigned(FModel) then
  begin
    llama_free_model(FModel);
    FModel := nil;
  end;
end;

function TDllama.WasKeyPressed(const AKey: Word): Boolean;
var
  CurrentKeyState: Boolean;
begin
  CurrentKeyState := (GetAsyncKeyState(AKey) and $8000) <> 0;
  // Check if the current state is pressed and the last state was not pressed
  Result := CurrentKeyState and (not FLastKeyState);
  FLastKeyState := CurrentKeyState; // Update last key state for the next call
end;

procedure TDllama.OnError(const AText: UTF8String);
begin
  if Assigned(FCallbacks.ErrorCallback) then
    FCallbacks.ErrorCallback(FCallbacks.Sender, PUTF8Char(UTF8Encode(AText)));
end;

procedure TDllama.OnInfo(const ALevel: Integer; const AText: string);
begin
  if Assigned(FCallbacks.InfoCallback) then
    FCallbacks.InfoCallback(FCallbacks.Sender, ALevel, PUTF8Char(UTF8Encode(AText)));
end;

procedure TDllama.OnInferenceToken(const AToken: string);
begin
  if Assigned(FCallbacks.InferenceTokenCallback) then
    FCallbacks.InferenceTokenCallback(FCallbacks.Sender, PUTF8Char(UTF8Encode(AToken)))
  else
    Print(AToken, []);
end;

procedure TDllama.OnInferenceStart();
begin
  if Assigned(FCallbacks.InferenceStartCallback) then
    FCallbacks.InferenceStartCallback(FCallbacks.Sender);
end;

procedure TDllama.OnInferenceDone();
begin
  if Assigned(FCallbacks.InferenceDoneCallback) then
    FCallbacks.InferenceDoneCallback(FCallbacks.Sender, PUTF8Char(FInferenceResponse));
end;

function  TDllama.OnLoadModelProgress(const AModelName: string; const AProgress: Single): Boolean;
begin
  if Assigned(FCallbacks.LoadModelProgressCallback) then
    Result := FCallbacks.LoadModelProgressCallback(FCallbacks.Sender,  PUTF8Char(UTF8Encode(AModelName)), AProgress)
  else
    begin
      Print(CR+'Loading model "%s" (%3.2f%s)...', [AModelName, AProgress*100, '%'], CYAN);
      Result := True;
    end;
end;

procedure TDllama.OnLoadModel(const ASuccess: Boolean);
begin
  if Assigned(FCallbacks.LoadModelCallback) then
    FCallbacks.LoadModelCallback(FCallbacks.Sender,  ASuccess)
  else
    ClearLine(WHITE);
end;

constructor TDllama.Create();
begin
  inherited;
end;

destructor TDllama.Destroy();
begin
  Quit();
  inherited;
end;

function TDllama.CreateExampleConfig(const AConfigFilename: string): Boolean;
var
  LJson: TJsonObject;
  LObject: TJsonObject;
  LFilename: string;
begin
  Result := False;

  try
    if AConfigFilename.IsEmpty then
    begin
      SetError('[%s] Filename can not be black', ['TDllama.CreateExampleConfig']);
      Exit;
    end;

    LFilename := TPath.ChangeExtension(AConfigFilename, 'json');

    LJson := TJsonObject.Create();
    try
      LJson.S['model_path'] := 'C:\LLM\gguf';
      LJson.I['gpu_layers'] := -1;
      LJson.I['inference_cancel_key'] := 27;


      with LJson.AddArray('models') do
      begin
        LObject := TJsonObject.Create();
        LObject.S['filename'] := 'Phi-3-mini-4k-instruct-q4.gguf';
        LObject.S['name'] := 'phi3';
        LObject.I['max_context'] := 4000;
        LObject.S['template'] := '<|%s|>%s<|im_end|>';
        LObject.S['template_end'] := '<|assistant|>';
        with LObject.AddArray('stop') do
        begin
          Add('<|user|>');
          Add('<|assistant|>');
          Add('<|system|>');
          Add('<|end|>');
          Add('<|endoftext|>');
        end;
        Add(LObject);

        LObject := TJsonObject.Create();
        LObject.S['filename'] := 'Meta-Llama-3-8B-Instruct-Q6_K.gguf';
        LObject.S['name'] := 'llama3';
        LObject.I['max_context'] := 8000;
        LObject.S['template'] := '<|begin_of_text|><|start_header_id|>%s<|end_header_id|>%s<|eot_id|>';
        LObject.S['template_end'] := '<|start_header_id|>assistant<|end_header_id|>';
        with LObject.AddArray('stop') do
        begin
          Add('<|eot_id|>');
          Add('<|start_header_id|>');
          Add('<|end_header_id|>');
          Add('assistant');
        end;
        Add(LObject);
      end;

      TFile.WriteAllText(LFilename, LJson.Format(2), TEncoding.UTF8);

      Result := TFile.Exists(LFilename);
    finally
      LJson.Free();
    end;
  except
    on E: Exception do
    begin
      SetError('[%s] %s', ['TDllama.LoadConfig', E.Message]);
      Exit;
    end;
  end;
end;

function  TDllama.Init(const AConfigFilename: string; const ACallbacks: PCallbacks): Boolean;
begin
  Result := False;
  if FInit then Exit;
  try
    FCallbacks := Default(Callbacks);
    if Assigned(ACallbacks) then
      FCallbacks := ACallbacks^;
    FInferenceCancelKey := 27; // ESCAPE by default
    FModels := TModels.Create();
    FMessages := TMessages.Create();
    if not LoadConfig(AConfigFilename) then Exit;
    redirect_cerr_to_callback(TDllama_CErrCallback, Self);
    llama_log_set(TDllama_LogCallback, Self);
    llama_backend_init();
    llama_numa_init(GGML_NUMA_STRATEGY_DISTRIBUTE);
    FInit := True;
    Result := True;
  except
    on E: Exception do
    begin
      SetError('[%s] %s', ['TDllama.LoadConfig', E.Message]);
      Exit;
    end;
  end;
end;

procedure TDllama.Quit();
begin
  if not FInit then Exit;
  UnloadModel();

  FModels.Free();
  FModels := nil;

  FMessages.Free();
  FMessages := nil;

  llama_backend_free();
  restore_cerr();

  FInit := False;

  FModelPath := '';
  FNumGPULayers := 0;
  FLoadedModel := Default(TModel);
  FError := '';
  FCallbacks := Default(Callbacks);
  FLastKeyState := False;
  FInferenceCancelKey := 27; // ESC default
end;

function TDllama.Tokenize(ctx: Pllama_context; const text: string; addSpecial: Boolean; parseSpecial: Boolean = False): TArray<llama_token>;
var
  nTokens: Integer;
  LResult: TArray<llama_token>;
  LText: UTF8String;
begin
  LText := UTF8Encode(text);

  // upper limit for the number of tokens
  nTokens := Length(LText) + 2 * Ord(addSpecial);
  SetLength(LResult, nTokens);
  nTokens := Dllama.Deps.llama_tokenize(llama_get_model(ctx), PUTF8Char(LText), Length(LText), @LResult[0], Length(LResult), addSpecial, parseSpecial);
  if nTokens < 0 then
  begin
    SetLength(LResult, -nTokens);
    nTokens := Dllama.Deps.llama_tokenize(llama_get_model(ctx), PUTF8Char(LText), Length(LText), @LResult[0], Length(LResult), addSpecial, parseSpecial);
    Assert(nTokens = -Length(LResult));
  end
  else
  begin
    SetLength(LResult, nTokens);
  end;
  Result := LResult;
end;

var
  buffer: array[0..1023] of UTF8Char;

function TDllama.TokenToPiece(ctx: Pllama_context; token: llama_token; special: Boolean = True): string;
var
  nTokens: Int32;
  LCheck: Int32;
begin
  nTokens := Dllama.Deps.llama_token_to_piece(llama_get_model(ctx), token, @buffer[0], 8, special);
  if nTokens < 0 then
  begin
    LCheck := Dllama.Deps.llama_token_to_piece(llama_get_model(ctx), token, @buffer[0], -nTokens, special);
    Assert(LCheck = -nTokens);
    Buffer[-nTokens] := #0;
  end
  else
  begin
    Buffer[nTokens] := #0;
  end;
  Result := UTF8ToString(@Buffer[0]);
end;

procedure TDllama.BatchAdd(var batch: llama_batch; id: llama_token; pos: llama_pos; const seq_ids: TArray<llama_seq_id>; logits: Boolean);
var
  i: Integer;
begin
  Pllama_token(IntPtr(batch.token) + batch.n_tokens * SizeOf(llama_token))^ := id;
  Pllama_pos(IntPtr(batch.pos) + batch.n_tokens * SizeOf(llama_pos))^ := pos;
  PInt32(IntPtr(batch.n_seq_id) + batch.n_tokens * SizeOf(Int32))^ := Length(seq_ids);
  for i := Low(seq_ids) to High(seq_ids) do
  begin
    PPllama_seq_id(IntPtr(batch.seq_id) + batch.n_tokens * SizeOf(Pllama_seq_id))^^ := seq_ids[i];
  end;
    PInt8(IntPtr(batch.logits) + batch.n_tokens * SizeOf(Int8))^ := Ord(logits);
  Inc(batch.n_tokens);
end;

procedure TDllama.ClearMessages();
begin
  FMessages.Clear();
end;

procedure TDllama.AddMessage(const ARole, AContent: string);
var
  LMessage: TChatMessage;
  LRole: string;
  LContent: string;
begin
  LRole := ARole.Trim();
  LContent := AContent.Trim();

  if LContent.IsEmpty then Exit;
  if LRole.IsEmpty then Exit;

  LMessage.Role := LRole;
  LMessage.Context := LContent;
  FMessages.Add(LMessage);
  if ContainsText(ARole, 'user') then
    FLastUserMessage := UTF8Encode(AContent);
end;

function  TDllama.GetLastUserMessage(): UTF8String;
begin
  Result := FLastUserMessage;
end;

function  TDllama.Inference(const AModelName: string; const AMaxTokens: UInt32; AResponse: PPAnsiChar; const AUsage: PUsage; const AError: PPAnsiChar): Boolean;
var
  LTokenList: TArray<llama_token>;
  LNCtx: UInt32;
  I: Integer;
  LCandidates: TArray<llama_token_data>;
  LNkvReq: UInt32;
  LNLen: UInt32;
  LBatch: llama_batch;
  LNCur: UInt32;
  LNVocab: Int32;
  LLogits: System.PSingle;
  CandidatesP: llama_token_data_array;
  LNewTokenId: llama_token;
  LToken: string;
  n_batch: int32;
  LTokenBuffer: string;
  LPrompt: string;
  LFirstToken: Boolean;
  LSkip: Boolean;
  LPrevToken: string;
  LTimings: llama_timings;
  LUsage: TDllama.Usage;

  function IsPartEndsWith(const MainStr: string; const AStopTokens: TArray<string>): Boolean;
  var
    i: Integer;
    LStopToken: string;
  begin
    Result := False;

    for LStopToken in AStopTokens do
    begin
      for i := 0 to Length(LStopToken)-1 do
      begin
        if MainStr.EndsWith(LStopToken.Substring(0, i+1)) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;

  function IsAStopToken(const AText: string; const AStopTokens: TArray<string>): Boolean;
  var
    LStopToken: string;
  begin
    Result := False;

    for LStopToken in AStopTokens do
    begin
      if AText.EndsWith(LStopToken) then
      begin
        Exit(True);
      end;
    end;
  end;

  function BuildPrompt(): string;
  var
    LMessage: TChatMessage;
  begin
    Result := '';
    for LMessage in FMessages do
    begin
      Result := Result + Format(FLoadedModel.Template, [LMessage.Role, LMessage.Context]);
      Result := Result.Trim();
    end;
    Result := Result + FLoadedModel.TemplateEnd;
  end;

begin
  Result := False;
  LFirstToken := True;
  LPrevToken := '';
  LTokenBuffer := '';

  try
    try
      if not FInit then
      begin
        SetError('[%s] Dllama has not been initalized', ['TDllama.Inference']);
        Exit;
      end;

      if FMessages.Count = 0 then
      begin
        SetError('[%s] Prompt can not be empty', ['TDllama.Inference']);
        Exit;
      end;


      if not LoadModel(AModelName) then
        Exit;

      LPrompt := BuildPrompt();

      FInferenceResponse := '';

      OnInferenceStart();
      try
        FLastKeyState := False;

        LTokenList := Tokenize(FContext, LPrompt, true, true);

        LTokenBuffer := '';
        LNCtx := llama_n_ctx(FContext);

        LNLen := EnsureRange(AMaxTokens, 512, LNCtx);

        LNkvReq := Length(LTokenList) + (LNLen - Length(LTokenList));

        if LNkvReq > LNCtx then
        begin
          SetError('[%s] The required KV cache size is not big enough', ['TDllama.Inference']);
          Exit;
        end;
        n_batch := llama_n_batch(FContext);
        LBatch := llama_batch_init(n_batch, 0, 1);
        try
          for I := 0 to Length(LTokenList)-1 do
          begin
            BatchAdd(LBatch, LTokenList[I], I, [0], false);
          end;

          PInt8(IntPtr(LBatch.logits) + (LBatch.n_tokens-1) * SizeOf(Int8))^ := 1;

          if llama_decode(FContext, LBatch) <> 0 then
          begin
            SetError('[%s] Failed to decode batch', ['TDllama.Inference']);
            Exit;
          end;

          LNCur    := LBatch.n_tokens;

          LNVocab := llama_n_vocab(FModel);
          SetLength(LCandidates, LNVocab);

          while (LNCur <= LNLen) do
          begin
            if WasKeyPressed(FInferenceCancelKey) then
              Break;

            LLogits  := llama_get_logits_ith(FContext, LBatch.n_tokens - 1);

            for I := 0 to LNVocab-1 do
            begin
              LCandidates[I].id := I;
              LCandidates[I].logit := PSingle(IntPtr(LLogits) + I*SizeOf(Single))^;
              LCandidates[I].p := 0;
            end;

            CandidatesP.data := @LCandidates[0];
            CandidatesP.size := LNVocab;
            CandidatesP.sorted := false;

            // sort
            llama_sample_softmax(FContext, @CandidatesP);

            // generate token
            LNewTokenId := llama_sample_token_greedy(FContext, @CandidatesP);

            // check for ending conditions
            if llama_token_eot(FModel) = LNewTokenId then
              break;

            if llama_token_eos(FModel) = LNewTokenId then
              break;

            if llama_token_is_eog(FModel, LNewTokenId) then
              break;

            if LNCur >= LNLen then
              break;

            LToken := TokenToPiece(FContext, LNewTokenId, false);

            //TODO: some models I get a first token as one of its stop sequences, which will
            //      terminate the inferance without any input. Not sure what going on, but for
            //      now I will check for this condition and skip it. More resource in needed to
            //      see how to properly handle this.
            if (LFirstToken = True) and (IsAStopToken(LToken, FLoadedModel.Stop) = True) then
              LSkip := True
            else
              LSkip := False;

            if not LSkip then
            begin

              // trim leading whitespace of first non-BOS token
              if llama_token_bos(FModel) <> LNewTokenId then
              begin
                if LFirstToken then
                begin
                  LToken := LToken.TrimLeft;
                  LFirstToken := False;
                end;
              end;

              LToken := SanitizeFromJson(LToken);

              LTokenBuffer := LTokenBuffer + LToken;

              // check for and process specal chars
              LSkip := False;
              if IsPartEndsWith(LTokenBuffer, ['\n', '\r', '\b', '\t', '\f']) then
              begin
                LPrevToken := LPrevToken + LToken;
                if IsAStopToken(LTokenBuffer, ['\n', '\r', '\b', '\t', '\f']) then
                  begin
                    LToken := LPrevToken;
                    LToken := SanitizeFromJson(LToken);
                    LPrevToken := '';
                  end
                else
                  LSkip := True;
              end;

              // check for stop sequences
              if not LSkip then
              begin
                if not IsPartEndsWith(LTokenBuffer, FLoadedModel.Stop) then
                  begin
                    FInferenceResponse := FInferenceResponse + UTF8String(LToken);
                    OnInferenceToken(LToken);
                  end
                else
                  begin
                    if IsAStopToken(LTokenBuffer, FLoadedModel.Stop) then
                      Break;
                  end;
              end;
            end;

            LBatch.n_tokens := 0;
            BatchAdd(LBatch, LNewTokenId, LNCur, [0], true);

            inc(LNCur);
            if llama_decode(FContext, LBatch) = 1 then
            begin
              SetError('[%s] Failed to evaluate the current batch with the transformer model', ['TDllama.Inference']);
              Exit;
            end;
          end;

          // get usage
          LTimings := llama_get_timings(FContext);
          LUsage.InputTokens := LTimings.n_p_eval;
          LUsage.OutputTokens := LTimings.n_eval;
          LUsage.TokenInputSpeed := 1e3 / LTimings.t_p_eval_ms * LTimings.n_p_eval;
          LUsage.TokenOutputSpeed := 1e3 / LTimings.t_eval_ms * LTimings.n_eval;
          LUsage.TotalTokens := LUsage.InputTokens + LUsage.OutputTokens;

          if Assigned(AUsage) then
            AUsage^ := LUsage;

          Result := True;
        finally
          llama_batch_free(LBatch);
        end;
      finally
        if Assigned(AResponse) then
          AResponse^ := PUTF8Char(FInferenceResponse);

        OnInferenceDone();
      end;
    except
      on E: Exception do
      begin
        SetError('[%s] %s', ['TDllama.Inference', E.Message]);
      end;
    end;
  finally
    if Assigned(AError) then
      AError^ := PUTF8Char(FError);
  end;
end;

procedure TDllama.ClearLine(AColor: WORD);
var
  LConsoleOutput: THandle;
  LConsoleInfo: TConsoleScreenBufferInfo;
  LNumCharsWritten: DWORD;
  LCoord: TCoord;
begin
  LConsoleOutput := GetStdHandle(STD_OUTPUT_HANDLE);

  if GetConsoleScreenBufferInfo(LConsoleOutput, LConsoleInfo) then
  begin
    LCoord.X := 0;
    LCoord.Y := LConsoleInfo.dwCursorPosition.Y;

    SetTextColor(AColor);
    FillConsoleOutputCharacter(LConsoleOutput, ' ', LConsoleInfo.dwSize.X,
      LCoord, LNumCharsWritten);
    SetConsoleCursorPosition(LConsoleOutput, LCoord);
  end;
end;

procedure TDllama.Print(const AMsg: string; const AArgs: array of const; const AColor: WORD=WHITE);
begin
  if not HasOutput then Exit;
  SetTextColor(AColor);
  Write(Format(AMsg, AArgs));
  SetTextColor(WHITE);
end;

procedure TDllama.Print(const AText: string; const AColor: WORD=WHITE);
begin
  if not HasOutput then Exit;
  SetTextColor(AColor);
  Write(AText);
  SetTextColor(WHITE);
end;

{ --------------------------------------------------------------------------- }
var
  LDllama: TDllama = nil;

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

function  Dllama_CreateExampleConfig(const AConfigFilename: PAnsiChar): Boolean;
begin
  Result := LDllama.CreateExampleConfig(UTF8ToString(AConfigFilename));
end;

function  Dllama_Init(const AConfigFilename: PAnsiChar; const ACallbacks: TDllama.PCallbacks): Boolean;
begin
  Result := LDllama.Init(UTF8ToString(AConfigFilename), ACallbacks)
end;

procedure Dllama_Quit();
begin
  LDllama.Quit();
end;

procedure Dllama_ClearMessages();
begin
  LDllama.ClearMessages();
end;

procedure Dllama_AddMessage(const ARole, AContent: PAnsiChar);
begin
  LDllama.AddMessage(UTF8ToString(ARole), UTF8ToString(AContent));
end;

function  Dllama_GetLastUserMessage(): PAnsiChar;
begin
  Result := PUTF8Char(LDllama.GetLastUserMessage());
end;

function  Dllama_Inference(const AModelName: PAnsiChar; const AMaxTokens: UInt32; AResponse: PPAnsiChar=nil; const AUsage: TDllama.PUsage=nil; const AError: PPAnsiChar=nil): Boolean;
begin
  Result := LDllama.Inference(UTF8ToString(AModelName), AMaxTokens, AResponse, AUsage, AError);
end;

{ Dllama_Simple_Inference }
procedure Dllama_Simple_Inference_OnInferenceToken(const ASender: Pointer; const AToken: PAnsiChar); cdecl;
begin
end;

procedure Dllama_Simple_Inference_OnInfo(const ASender: Pointer; const ALevel: Integer; const AText: PAnsiChar); cdecl;
begin
end;

function Dllama_Simple_Inference_OnLoadModelProgress(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
begin
  Result := True;
end;

procedure Dllama_Simple_Inference_OnLoadModel(const ASender: Pointer; const ASuccess: Boolean); cdecl;
begin
end;

function  Dllama_Simple_Inference(const AConfigFilename, AModelName, AQuestion: PAnsiChar; const AMaxTokens: UInt32): PAnsiChar;
var
  LCallbacks: TDllama.Callbacks;
begin
  Result := nil;

  if AConfigFilename = '' then
  begin
    Result := 'AConfigFilename can not be blank.';
    Exit;
  end;

  if AQuestion = '' then
  begin
    Result := 'AQuestion can not be blank.';
    Exit;
  end;

  LCallbacks := Default(TDllama.Callbacks);
  LCallbacks.InferenceTokenCallback := Dllama_Simple_Inference_OnInferenceToken;
  LCallbacks.InfoCallback := Dllama_Simple_Inference_OnInfo;
  LCallbacks.LoadModelProgressCallback := Dllama_Simple_Inference_OnLoadModelProgress;
  LCallbacks.LoadModelCallback := Dllama_Simple_Inference_OnLoadModel;

  if not Dllama_Init(AConfigFilename, @LCallbacks) then
  begin
    Result := PUTF8Char(LDllama.FError);
    Exit;
  end;
  try
    Dllama_AddMessage(TDllama.ROLE_USER, AQuestion);

    if Dllama_Inference(AModelName, AMaxTokens, nil, nil, nil) then
    begin
      Result := PUTF8Char(LDllama.FInferenceResponse);
    end
  else
    begin
      Result := PUTF8Char(LDllama.FError);
    end;
  finally
    Dllama_Quit();
  end;
end;

procedure Dllama_ClearLine(AColor: WORD);
begin
  LDllama.ClearLine(AColor);
end;

procedure Dllama_Print(const AText: PAnsiChar; const AColor: WORD);
begin
  LDllama.Print(UTF8ToString(AText), AColor);
end;

{ --------------------------------------------------------------------------- }

var
  LInputCodePage: Cardinal;
  LOutputCodePage: Cardinal;


initialization
begin
  ReportMemoryLeaksOnShutdown := True;

  // save current console codepage
  LInputCodePage := GetConsoleCP();
  LOutputCodePage := GetConsoleOutputCP();

  // set code page to UTF8
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);

  // init dllama
  LDllama := TDllama.Create();
end;

finalization
begin
  // destroy dllama
  LDllama.Free();

  // restore code page
  SetConsoleCP(LInputCodePage);
  SetConsoleOutputCP(LOutputCodePage);
end;


end.
