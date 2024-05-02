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

unit Dllama.Core;

{$I Dllama.Defines.inc}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Math,
  WinApi.Windows,
  Dllama.Deps,
  Dllama.Deps.Ext,
  Dllama.Utils;

const
  DLLAMA_NAME          = 'Dllama™';
  DLLAMA_CODENAME      = 'AlpacaCore';
  DLLAMA_MAJOR_VERSION = '0';
  DLLAMA_MINOR_VERSION = '1';
  DLLAMA_PATCH_VERSION = '0';
  DLLAMA_VERSION       = DLLAMA_MAJOR_VERSION+'.'+DLLAMA_MINOR_VERSION+'.'+DLLAMA_PATCH_VERSION;
  DLLAMA_PROJECT       = DLLAMA_NAME+' ('+DLLAMA_CODENAME+') v'+DLLAMA_MAJOR_VERSION+'.'+DLLAMA_MINOR_VERSION+'.'+DLLAMA_PATCH_VERSION;

type
  { TDllama }
  TDllama = class(TBaseObject)
  public type

    LoadModelProgressCallback = function(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
    LoadModelCallback = procedure(const ASender: Pointer; const ASuccess: Boolean); cdecl;
    InferenceCallback = procedure(const ASender: Pointer; const AToken: PAnsiChar); cdecl;
    InferenceDoneCallback = procedure(const ASender: Pointer); cdecl;

    Model = record
      Filename: string;
      Name: string;
      MaxContext: UInt64;
      ChatMessageTemplate: string;
      AChatMessageTemplateEnd: string;
      StopSequences: TArray<string>;
    end;

    Usage = record
      TokenInputSpeed: Double;
      TokenOutputSpeed: Double;
      InputTokens: Int32;
      OutputTokens: Int32;
      TotalTokens: Int32;
    end;
  protected type
    TCallback<T> = record
      Sender: Pointer;
      Handler: T;
    end;

    TConfig = record
      NumGPULayers: Integer;
      DisplayInfo: Boolean;
      ModelPath: string;
      CancelInferenceKey: Byte;
    end;

    TChatMessage = record
      Role: string;
      Context: string;
    end;

    TModels = TDictionary<string, TDllama.Model>;
    TMessages = TList<TChatMessage>;
  protected
    FError: string;
    FConfig: TConfig;
    FModels: TModels;
    FModel: Pllama_model;
    FModelParams: llama_model_params;
    FCandidates: TVirtualBuffer<llama_token_data>;
    FVocabCount: Int32;
    FContext: Pllama_context;
    FContexParams: llama_context_params;
    FLoadedModel: TDllama.Model;
    FMessages: TMessages;
    FLastUserMessage: string;
    FInferenceActive: Boolean;
    FUsage: Dllama.Usage;
    FLoadModelProgressCallback: TCallback<TDllama.LoadModelProgressCallback>;
    FLoadModelCallback: TCallback<LoadModelCallback>;
    FInferenceCallback: TCallback<InferenceCallback>;
    FInferenceDoneCallback: TCallback<InferenceDoneCallback>;
    FInferenceResponse: UTF8String;
  public
    // init
    constructor Create(); override;
    destructor Destroy(); override;

    // config
    procedure InitConfig(const AModelPath: string; const ANumGPULayers: Integer=-1; const ADisplayInfo: Boolean=False; const ACancelInferenceKey: Byte=VK_ESCAPE);
    procedure GetConfig(AModelPath: PString; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte);
    function  SaveConfig(const AFilename: string='config.json'): Boolean;
    function  LoadConfig(const AFilename: string='config.json'): Boolean;

    // error
    function  GetError(): string;
    procedure SetError(const AMsg: string; const AArgs: array of const);
    procedure ClearError();

    // model
    function  GetLoadModelProgressCallback(): TDllama.LoadModelProgressCallback;
    procedure SetLoadModelProgressCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelProgressCallback);
    function  GetLoadModelCallback(): TDllama.LoadModelCallback;
    procedure SetLoadModelCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelCallback);
    function  AddModel(const AFilename, AName: string; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: string; const AStopSequences: TArray<string>): Boolean;
    procedure ClearModels();
    function  GetModelCount(): Cardinal;
    function  GetModelByName(const AName: string): TDllama.Model;
    function  SaveModelDb(const AFilename: string): Boolean;
    function  LoadModelDb(const AFilename: string): Boolean;
    function  LoadModel(const AName: string): Boolean;
    function  GetModelLoaded(): Boolean;
    function  GetLoadedModel(): TDllama.Model;
    procedure UnloadModel();

    // messages
    procedure ClearMessages();
    procedure AddMessage(const ARole, AContent: string);
    function  GetLastUserMessage(): string;

    // inference
    function  GetInferenceCallback(): TDllama.InferenceCallback;
    procedure SetInferenceCallback(const ASender: Pointer; const AHandler: TDllama.InferenceCallback);
    function  GetInferenceDoneCallback(): TDllama.InferenceDoneCallback;
    procedure SetInferenceDoneCallback(const ASender: Pointer; const AHandler: TDllama.InferenceDoneCallback);
    function  Inference(const AModelName: string; const AMaxTokens: UInt32=1024; const ATemperature: Single=0.5; const ASeed: UInt32=MaxInt): Boolean;
    function  GetInferenceResponse(): UTF8String;
    procedure GetInferenceUsage(var AUsage: TDllama.Usage);
    function  IsInferenceActive(): Boolean;

    // Callbacks
    procedure OnCError(const AText: string); virtual;
    function  OnLoadModelProgress(const AModelName: string; const AProgress: Single): Boolean; virtual;
    procedure OnLoadModel(const ASuccess: Boolean); virtual;
    procedure OnLog(const ALevel: Integer; const AText: string); virtual;
    procedure OnInference(const AToken: string); virtual;
    procedure OnInferenceDone(); virtual;
  end;


implementation

{ TDllama }

// Callbacks
function TDllama_ModelLoadProgressCallback(AProgress: single; ACtx: pointer): boolean; cdecl;
var
  LDllama: TDllama;
begin
  LDllama := ACtx;

  if Assigned(LDllama) then
    Result := TDllama(LDllama).OnLoadModelProgress(LDllama.GetLoadedModel().Name, AProgress)
  else
    Result := False;
end;

procedure TDllama_LogCallback(ALevel: ggml_log_level; const AText: PUTF8Char; AUserData: Pointer); cdecl;
begin
  if Assigned(AUserData) then
    TDllama(AUserData).OnLog(ALevel, Utf8ToString(AText));
end;

procedure TDllama_CErrCallback(const text: PUTF8Char; user_data: Pointer); cdecl;
begin
  if Assigned(user_data) then
    TDllama(user_data).OnCError(Utf8ToString(text));
end;


// init
constructor TDllama.Create();
begin
  inherited;
  FModels := TModels.Create();
  FMessages := TMessages.Create();
end;

destructor TDllama.Destroy();
begin
  UnloadModel();

  if Assigned(FMessages) then
  begin
    FMessages.Free();
    FMessages := nil;
  end;

  if Assigned(FModels) then
  begin
    FModels.Free();
    FModels := nil;
  end;

  inherited;
end;

procedure TDllama.InitConfig(const AModelPath: string; const ANumGPULayers: Integer; const ADisplayInfo: Boolean; const ACancelInferenceKey: Byte);
begin
  if ANumGPULayers < 0 then
    FConfig.NumGPULayers := MaxInt
  else
    FConfig.NumGPULayers := EnsureRange(ANumGPULayers, 0, MaxInt);
  FConfig.DisplayInfo := ADisplayInfo;
  FConfig.ModelPath := AModelPath;
  FConfig.CancelInferenceKey := ACancelInferenceKey;
end;

procedure TDllama.GetConfig(AModelPath: PString; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte);
begin
  if Assigned(AModelPath) then
    AModelPath^ := FConfig.ModelPath;

  if Assigned(ANumGPULayers) then
    ANumGPULayers^ := FConfig.NumGPULayers;

  if Assigned(ADisplayInfo) then
    ADisplayInfo^ := FConfig.DisplayInfo;

  if Assigned(ACancelInferenceKey) then
    ACancelInferenceKey^ := FConfig.CancelInferenceKey;
end;

function  TDllama.SaveConfig(const AFilename: string): Boolean;
var
  LFilename: string;
  LJson: TJsonObject;
begin
  Result := False;

  if AFilename.IsEmpty then
  begin
    SetError('[TDllama.SaveConfig] Filename can not be empty', []);
    Exit;
  end;
  LFilename := TPath.ChangeExtension(AFilename, 'json');

  LJson := TJsonObject.Create();
  try
    LJson.S['ModelPath'] := FConfig.ModelPath;
    LJson.I['NumGPULayers'] := FConfig.NumGPULayers;
    LJson.B['DisplayInfo'] := FConfig.DisplayInfo;
    LJson.I['CancelInferenceKey'] := FConfig.CancelInferenceKey;

    TFile.WriteAllText(LFilename, LJson.Format(), TEncoding.UTF8);

    Result := TFile.Exists(LFilename);
  finally
    LJson.Free();
  end;
end;

function  TDllama.LoadConfig(const AFilename: string): Boolean;
var
  LFilename: string;
  LJson: TJsonObject;
begin
  Result := False;

  LFilename := TPath.ChangeExtension(AFilename, 'json');
  if not TFile.Exists(LFilename) then
  begin
    SetError('[TDllama.LoadConfig] Filename was not found: "%s"', [LFilename]);
    Exit;
  end;

  LJson := TJsonObject.Parse(TFile.ReadAllText(LFilename, TEncoding.UTF8));
  try

    // check for valid "ModelPath" field
    if not LJson.Contains('ModelPath') then
    begin
      SetError('[TDllama.LoadConfig] Invalid Json, "ModelPath" field was not found in : "%s"', [LFilename]);
      Exit;
    end;

    // check for valid "NumGPULayers" field
    if not LJson.Contains('NumGPULayers') then
    begin
      SetError('[TDllama.LoadConfig] Invalid Json, "NumGPULayers" field was not found in : "%s"', [LFilename]);
      Exit;
    end;

    // check for valid "DisplayInfo" field
    if not LJson.Contains('DisplayInfo') then
    begin
      SetError('[TDllama.LoadConfig] Invalid Json, "DisplayInfo" field was not found in : "%s"', [LFilename]);
      Exit;
    end;

    // check for valid "CancelInferenceKey" field
    if not LJson.Contains('CancelInferenceKey') then
    begin
      SetError('[TDllama.LoadConfig] Invalid Json, "CancelInferenceKey" field was not found in : "%s"', [LFilename]);
      Exit;
    end;

    FConfig.NumGPULayers := LJson.I['NumGPULayers'];
    FConfig.DisplayInfo := LJson.B['DisplayInfo'];
    FConfig.ModelPath :=  LJson.S['ModelPath'];
    FConfig.CancelInferenceKey := LJson.I['CancelInferenceKey'];

  finally
    LJson.Free();
  end;
end;

// error
function  TDllama.GetError(): string;
begin
  Result := FError;
end;

procedure TDllama.SetError(const AMsg: string; const AArgs: array of const);
begin
  FError := Format(AMsg, AArgs);
end;

procedure TDllama.ClearError();
begin
  FError := '';
end;

// model
function  TDllama.GetLoadModelProgressCallback(): TDllama.LoadModelProgressCallback;
begin
  Result := FLoadModelProgressCallback.Handler;
end;

procedure TDllama.SetLoadModelProgressCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelProgressCallback);
begin
  FLoadModelProgressCallback.Sender := ASender;
  FLoadModelProgressCallback.Handler := AHandler;
end;

function  TDllama.GetLoadModelCallback(): TDllama.LoadModelCallback;
begin
  Result := FLoadModelCallback.Handler;
end;

procedure TDllama.SetLoadModelCallback(const ASender: Pointer; const AHandler: TDllama.LoadModelCallback);
begin
  FLoadModelCallback.Sender := ASender;
  FLoadModelCallback.Handler := AHandler;
end;

function TDllama.AddModel(const AFilename, AName: string; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: string; const AStopSequences: TArray<string>): Boolean;
var
  LFilename: string;
  LModel: TDllama.Model;
begin
  Result := False;

  LFilename := TPath.ChangeExtension(TPath.Combine(FConfig.ModelPath, AFilename), 'gguf');
  (*
  if not TFile.Exists(LFilename) then
  begin
    SetError('[TDllama.AddModel] Model filename was not found: "%s"', [LFilename]);
    Exit;
  end;
  *)

  if AName.IsEmpty then
  begin
    SetError('[TDllama.AddModel] Model reference name can not be blank', []);
    Exit;
  end;

  if AChatMessageTemplate.IsEmpty then
  begin
    SetError('[TDllama.AddModel] Model chat message template can not be blank', []);
    Exit;
  end;

  LModel := Default(TDllama.Model);
  LModel.Filename := TPath.GetFileName(LFilename);
  LModel.Name := AName;
  LModel.MaxContext := AMaxContext;
  LModel.ChatMessageTemplate := AChatMessageTemplate;
  LModel.AChatMessageTemplateEnd := AChatMessageTemplateEnd;
  LModel.StopSequences := AStopSequences;
  FModels.AddOrSetValue(AName, LModel);

  Result := True;
end;

procedure TDllama.ClearModels();
begin
  FModels.Clear();
end;

function  TDllama.GetModelCount(): Cardinal;
begin
  Result := FModels.Count;
end;

function  TDllama.GetModelByName(const AName: string): TDllama.Model;
begin
  Result := Default(TDllama.Model);
  FModels.TryGetValue(AName, Result);
end;

function  TDllama.SaveModelDb(const AFilename: string): Boolean;
var
  LFilename: string;
  LModel: TPair<string, TDllama.Model>;
  LJson: TJsonObject;
  LModelJO: TJsonObject;
  StopSequencesJA: TJsonArray;
  LStopSequence: string;
begin
  Result := False;
  if AFilename.IsEmpty then
  begin
    SetError('[TDllama.SaveModelDb] Filename can not be empty', []);
    Exit;
  end;
  LFilename := TPath.ChangeExtension(AFilename, 'json');

  LJson := TJsonObject.Create();
  try
    with LJson.AddArray('Models') do
    begin
      for LModel in FModels do
      begin
        LModelJO := TJsonObject.Create();

        LModelJO.S['Filename'] := LModel.Value.Filename;
        LModelJO.S['Name'] := LModel.Key;
        LModelJO.I['MaxContext'] := LModel.Value.MaxContext;
        LModelJO.S['ChatMessageTemplate'] := LModel.Value.ChatMessageTemplate;
        LModelJO.S['AChatMessageTemplateEnd'] := LModel.Value.AChatMessageTemplateEnd;

        StopSequencesJA := TJsonArray.Create();

        for LStopSequence in LModel.Value.StopSequences do
        begin
          StopSequencesJA.Add(LStopSequence);
        end;

        LModelJO.A['StopSequences'] := StopSequencesJA;

        Add(LModelJO);
      end;
    end;

    TFile.WriteAllText(LFilename, LJson.Format(), TEncoding.UTF8);
    Result := TFile.Exists(LFilename);
  finally
    LJson.Free();
  end;

end;

function  TDllama.LoadModelDb(const AFilename: string): Boolean;
var
  LFilename: string;
  LJson: TJsonObject;
  LCount: Integer;
  LModelInfo: TDllama.Model;
  I,J: Integer;
  LStopSequencesJA: TJsonArray;
begin
  Result := False;

  LFilename := TPath.ChangeExtension(AFilename, 'json');
  if not TFile.Exists(LFilename) then
  begin
    SetError('[TDllama.LoadModelDb] Filename was not found: "%s"', [LFilename]);
    Exit;
  end;

  LJson := TJsonObject.Parse(TFile.ReadAllText(LFilename, TEncoding.UTF8));
  try
    if not LJson.Contains('Models') then Exit;
    LCount := LJson.A['Models'].Count;

    if LCount = 0 then Exit;

    ClearModels();

    LModelInfo := Default(TDllama.Model);

    for I := 0 to LCount-1 do
    begin
      // check for valid "Filename" field
      if not Assigned(LJson.A['Models'].Items[I].FindValue('Filename')) then
      begin
        SetError('[TDllama.LoadModelDb] Invalid Json, "Filename" field was not found in : "%s"', [LFilename]);
        Exit;
      end;

      // check for valid "Name" field
      if not Assigned(LJson.A['Models'].Items[I].FindValue('Name')) then
      begin
        SetError('[TDllama.LoadModelDb] Invalid Json, "Name" field was not found in : "%s"', [LFilename]);
        Exit;
      end;

      // check for valid "MaxContext" field
      if not Assigned(LJson.A['Models'].Items[I].FindValue('MaxContext')) then
      begin
        SetError('[TDllama.LoadModelDb] Invalid Json, "MaxContext" field was not found in : "%s"', [LFilename]);
        Exit;
      end;

      // check for valid "ChatMessageTemplate" field
      if not Assigned(LJson.A['Models'].Items[I].FindValue('ChatMessageTemplate')) then
      begin
        SetError('[TDllama.LoadModelDb] Invalid Json, "ChatMessageTemplate" field was not found in : "%s"', [LFilename]);
        Exit;
      end;

      // check for valid "AChatMessageTemplateEnd" field
      if not Assigned(LJson.A['Models'].Items[I].FindValue('AChatMessageTemplateEnd')) then
      begin
        SetError('[TDllama.LoadModelDb] Invalid Json, "AChatMessageTemplateEnd" field was not found in : "%s"', [LFilename]);
        Exit;
      end;

      LModelInfo.Filename := LJson.A['Models'].Items[I].FindValue('Filename').Value;
      LModelInfo.Name := LJson.A['Models'].Items[I].FindValue('Name').Value;
      LModelInfo.MaxContext := LJson.A['Models'].Items[I].FindValue('MaxContext').Value.ToInt64;
      LModelInfo.ChatMessageTemplate := LJson.A['Models'].Items[I].FindValue('ChatMessageTemplate').Value;
      LModelInfo.AChatMessageTemplateEnd := LJson.A['Models'].Items[I].FindValue('AChatMessageTemplateEnd').Value;

      if Assigned(LJson.A['Models'].Items[I].FindValue('StopSequences')) then
      begin
        LStopSequencesJA := LJson.A['Models'].Items[I].FindValue('StopSequences') as TJsonArray;
        SetLength(LModelInfo.StopSequences, LStopSequencesJA.Count);
        for J := 0 to LStopSequencesJA.Count-1 do
        begin
          LModelInfo.StopSequences[J] := LStopSequencesJA.Items[J].Value;
        end;
      end;

      if not AddModel(LModelInfo.Filename, LModelInfo.Name, LModelInfo.MaxContext, LModelInfo.ChatMessageTemplate, LModelInfo.AChatMessageTemplateEnd, LModelInfo.StopSequences) then
        Exit;
    end;

    Result := True;

  finally
    LJson.Free();
  end;

end;

function  TDllama.LoadModel(const AName: string): Boolean;
var
  LFilename: string;
begin
  Result := False;

  if Assigned(FModel) then
  begin
    if AName = FLoadedModel.Name then Exit;
  end;

  UnloadModel();

  try
    if not FModels.TryGetValue(AName, FLoadedModel) then
    begin
      SetError('[TDllama.LoadModel] Refrence model "%s" not found.', [AName]);
      Exit;
    end;

    LFilename := TPath.Combine(FConfig.ModelPath, FLoadedModel.Filename);
    if not TFile.Exists(LFilename) then
    begin
      SetError('[TDllama.LoadModel] Model "%s" not found.', [LFilename]);
      Exit;
    end;

    redirect_cerr_to_callback(TDllama_CErrCallback, Self);
    llama_log_set(TDllama_LogCallback, Self);

    llama_backend_init();

    llama_numa_init(GGML_NUMA_STRATEGY_DISTRIBUTE);

    FModelParams := llama_model_default_params();
    FModelParams.progress_callback_user_data := Self;
    FModelParams.progress_callback := TDllama_ModelLoadProgressCallback;

    {TODO: figure how to find the actual number of gpu layers available. For now,
           setting to a super high value will cause it to use the max number
           that is actually available. For my GPU it's 33 for example. }
    FModelParams.n_gpu_layers := FConfig.NumGPULayers;

    FModel := llama_load_model_from_file(Utils.AsUTF8(LFilename), FModelParams);
    if not Assigned(FModel) then
    begin
      llama_backend_free();
      restore_cerr();
      SetError('[TDllama.LoadModel] Unable to load model: "%s"', [LFilename]);
      UnloadModel();
      Exit;
    end;

    FContexParams := llama_context_default_params();
    FContexParams.offload_kqv := true;
    FContexParams.seed  := MaxInt;
    FContexParams.n_ctx := FLoadedModel.MaxContext;
    FContexParams.n_threads := Utils.GetPhysicalProcessorCount();
    FContexParams.n_threads_batch := FContexParams.n_threads;
    FContext := llama_new_context_with_model(FModel, FContexParams);
    if not Assigned(FContext) then
    begin
      SetError('[TDllama.LoadModel] Failed to create llama context', []);
      UnloadModel();
      Exit;
    end;

    FVocabCount := llama_n_vocab(FModel);
    try
      FCandidates := TVirtualBuffer<llama_token_data>.Create(FVocabCount);
    except
      On E: Exception do
      begin
        SetError(E.Message, []);
      end;
    end;

    Result := True;

    (*
    if llama_model_meta_val_str(FModel, 'tokenizer.chat_template', PAnsiChar(Utils.GetTempStaticBuffer()), Utils.GetTempStaticBufferSize()) < 0 then
      writeln('template: unknown')
    else
      writeln('template: ', PAnsiChar(Utils.GetTempStaticBuffer()));
    *)

  finally
    OnLoadModel(Result);
  end;
end;

function  TDllama.GetModelLoaded(): Boolean;
begin
  Result := Boolean(Assigned(FModel) and Assigned(FContext));
end;

function  TDllama.GetLoadedModel(): TDllama.Model;
begin
  Result := FLoadedModel;
end;

procedure TDllama.UnloadModel();
begin
  if not Assigned(FModel) then Exit;

  if Assigned(FCandidates) then
  begin
    FCandidates.Free();
    FCandidates := nil;
  end;

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

  llama_backend_free();
  restore_cerr();

  FLoadedModel := Default(TDllama.Model);
end;

// message
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
  if Utils.ContainsText(ARole, 'user') then
    FLastUserMessage := AContent;
end;

function  TDllama.GetLastUserMessage(): string;
begin
  Result := FLastUserMessage;
end;

// inference
function  TDllama.GetInferenceCallback(): TDllama.InferenceCallback;
begin
  Result := FInferenceCallback.Handler;
end;

procedure TDllama.SetInferenceCallback(const ASender: Pointer; const AHandler: TDllama.InferenceCallback);
begin
  FInferenceCallback.Sender := ASender;
  FInferenceCallback.Handler := AHandler;
end;

function  TDllama.GetInferenceDoneCallback(): TDllama.InferenceDoneCallback;
begin
  Result := FInferenceDoneCallback.Handler
end;

procedure TDllama.SetInferenceDoneCallback(const ASender: Pointer; const AHandler: TDllama.InferenceDoneCallback);
begin
  FInferenceDoneCallback.Sender := ASender;
  FInferenceDoneCallback.Handler := AHandler;
end;

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


function  TDllama.Inference(const AModelName: string; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean;
var
  LAddBos: Boolean;
  LTokens: array of llama_token;
  LMaxTokens: Integer;
  LTokenCount: Integer;
  I, LNCtx, LNkvReq, LNLen: Integer;
  LBatch: llama_batch;
  LBatchLogitsP: PInt8;
  LNCur: Integer;
  LLogits: System.PSingle;
  LLogitsP: System.PSingle;
  LCandidatesP: llama_token_data_array;
  LNewTokenId: llama_token;
  LToken: string;
  LPrevToken: string;
  LNBatch: Int32;
  LTokenData: llama_token_data;
  LTimings: llama_timings;
  LFirstToken: Boolean;
  LPrompt: string;
  LTemperature: Single;
  LSkip: Boolean;
  LBuffer: string;

  function BuildPrompt(): string;
  var
    LMessage: TChatMessage;
  begin
    Result := '';
    for LMessage in FMessages do
    begin
      Result := Result + Format(FLoadedModel.ChatMessageTemplate, [LMessage.Role, LMessage.Context]);
      Result := Result.Trim();
    end;
    Result := Result + FLoadedModel.AChatMessageTemplateEnd;
  end;

begin
  Result := False;
  FInferenceResponse := '';

  if IsInferenceActive() then Exit;

  LFirstToken := True;
  LBuffer := '';
  LPrevToken := '';
  FInferenceActive := True;
  try

    if not LoadModel(AModelName) then
    begin
      Exit;
    end;

    LPrompt := BuildPrompt();

    LNLen := FContexParams.n_ctx;

    LAddBos := llama_should_add_bos_token(FModel);
    LMaxTokens := LPrompt.Length + Ord(LAddBos);

    SetLength(LTokens, LMaxTokens);
    LTokenCount := llama_tokenize(FModel, Utils.AsUTF8(LPrompt), LMaxTokens, @LTokens[0], LMaxTokens, LAddBos, true);

    LNCtx    := llama_n_ctx(FContext);
    LNkvReq := LTokenCount + (LNLen - LTokenCount);

    if (LNkvReq > LNCtx) then
    begin
      SetError('The required KV cache size is not big enough', []);
      UnloadModel();
      exit;
    end;

    LNBatch := llama_n_batch(FContext);
    //LNBatch := 512;
    LBatch := llama_batch_init(LNBatch, 0, 1);
    try
      for I := 0 to LTokenCount-1 do
      begin
        llama_batch_add(LBatch, LTokens[I], I, [0], false);
      end;

      LBatchLogitsP := LBatch.logits;
      Inc(LBatchLogitsP, LBatch.n_tokens - 1);
      LBatchLogitsP^ := Ord(true);

      try
        if llama_decode(FContext, LBatch) <> 0 then
        begin
          SetError('llama decode failed', []);
          UnloadModel();
          Exit;
        end;
      except
        on E: Exception do
        begin
          SetError(E.Message, []);
          UnloadModel();
          Exit;
        end;
      end;

      LNCur := LBatch.n_tokens;

      while (LNCur <= LNLen)  do
      begin
        if Console.WasKeyPressed(FConfig.CancelInferenceKey) then
        begin
          Break;
        end;

        LLogits  := llama_get_logits_ith(FContext, LBatch.n_tokens - 1);

        for I := FVocabCount-1 downto 0 do
        begin
          LTokenData.id := I;
          LLogitsP := LLogits;
          inc(LLogitsP, I);
          LTokenData.logit := LLogitsP^;
          LTokenData.p := 0;
          FCandidates.Item[I] := LTokenData;
        end;

        LCandidatesP.data := FCandidates.Memory;
        LCandidatesP.size := FVocabCount + 1;
        LCandidatesP.sorted := False;

        LTemperature := EnsureRange(ATemperature, 1e-8, 1);
        llama_sample_temp(FContext, @LCandidatesP, LTemperature);
        LNewTokenId := llama_sample_token_greedy(FContext, @LCandidatesP);

        if (llama_token_eos(FModel) = LNewTokenId) or (LNCur = LNLen) then
        begin
          // reached end of inference
          Break;
        end;

        LToken := llama_token_to_piece(FContext, LNewTokenId);

        //TODO: some models I get a first token as one of its stop sequences, which will
        //      terminate the inferance without any input. Not sure what going on, but for
        //      now I will check for this condition and skip it. More resource in needed to
        //      see how to properly handle this.
        if (LFirstToken = True) and (IsAStopToken(LToken, FLoadedModel.StopSequences) = True) then
          LSkip := True
        else
          LSkip := False;

        // check to see if we need to skip this token altogether
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

          // sanitize token
          LToken := Utils.SanitizeFromJson(LToken);

          // build up token buffer
          LBuffer := LBuffer + LToken;

          // check for and process specal chars
          LSkip := False;
          if IsPartEndsWith(LBuffer, ['\n', '\r', '\b', '\t', '\f']) then
          begin
            LPrevToken := LPrevToken + LToken;
            if IsAStopToken(LBuffer, ['\n', '\r', '\b', '\t', '\f']) then
              begin
                LToken := LPrevToken;
                LToken := Utils.SanitizeFromJson(LToken);
                LPrevToken := '';
              end
            else
              LSkip := True;
          end;

          // check for stop sequences
          if not LSkip then
          begin
            if not IsPartEndsWith(LBuffer, FLoadedModel.StopSequences) then
              begin
                FInferenceResponse := FInferenceResponse + UTF8String(LToken);
                OnInference(LToken);
              end
            else
              begin
                if IsAStopToken(LBuffer, FLoadedModel.StopSequences) then
                  Break;
              end;
          end;
        end;

        llama_batch_clear(LBatch);
        llama_batch_add(LBatch, LNewTokenId, LNCur, [0], true);

        inc(LNCur);

        try
          if boolean(llama_decode(FContext, LBatch)) then
          begin
            SetError('Failed to evaluate', []);
            UnloadModel();
            Exit;
          end;
        except
          on E: Exception do
          begin
            SetError(E.Message, []);
            UnloadModel();
            Exit;
          end;
        end;
      end;

      LTimings := llama_get_timings(FContext);
      llama_timing_usage(LTimings, FUsage.InputTokens, FUsage.OutputTokens, FUsage.TokenInputSpeed, FUsage.TokenOutputSpeed);
      FUsage.TotalTokens := FUsage.InputTokens + FUsage.OutputTokens;
    finally
      llama_batch_free(LBatch);
    end;
    Result := True;
  finally
    FInferenceActive := False;
    OnInferenceDone();
  end;
end;

function  TDllama.GetInferenceResponse(): UTF8String;
begin
  Result := FInferenceResponse;
end;

procedure TDllama.GetInferenceUsage(var AUsage: TDllama.Usage);
begin
  AUsage := FUsage;
end;

function  TDllama.IsInferenceActive(): Boolean;
begin
  Result := FInferenceActive;
end;

procedure TDllama.OnCError(const AText: string);
begin
  if FConfig.DisplayInfo then
    Console.Print(AText);
end;

function  TDllama.OnLoadModelProgress(const AModelName: string; const AProgress: Single): Boolean;
begin
  if Assigned(FLoadModelProgressCallback.Handler) then
    begin
      Result := FLoadModelProgressCallback.Handler(FLoadModelProgressCallback.Sender, Utils.AsUTF8(AModelName), AProgress);
    end
  else
    begin
      Console.Print(Console.CR+'Loading model "%s" (%3.2f%s)...', [AModelName, AProgress*100, '%']);
      Result := True;
    end;
end;

procedure TDllama.OnLoadModel(const ASuccess: Boolean);
begin
  if Assigned(FLoadModelCallback.Handler) then
    FLoadModelCallback.Handler(FLoadModelCallback.Sender, ASuccess)
  else
    Console.ClearLine(Console.WHITE);
end;

procedure TDllama.OnLog(const ALevel: Integer; const AText: string);
begin
  if FConfig.DisplayInfo then
    Console.Print(AText);
end;

procedure TDllama.OnInference(const AToken: string);
begin
  if Assigned(FInferenceCallback.Handler) then
    FInferenceCallback.Handler(FInferenceCallback.Sender, Utils.AsUTF8(AToken))
  else
    Console.Print(AToken);
end;

procedure TDllama.OnInferenceDone();
begin
  if Assigned(FInferenceDoneCallback.Handler) then
    FInferenceDoneCallback.Handler(FInferenceDoneCallback.Sender);
end;


end.
