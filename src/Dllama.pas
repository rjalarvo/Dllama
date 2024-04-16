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
  public const
     Temperature = 0;
     TEMPERATURE_PERCISE  = 0.0;
     TEMPREATURE_BALANCED = 0.5;
     TEMPREATURE_CREATIVE = 1.0;
  public type
    PUsage = ^Usage;
    Usage = record
      TokenInputSpeed: Double;
      TokenOutputSpeed: Double;
      InputTokens: Int32;
      OutputTokens: Int32;
      TotalTokens: Int32;
    end;
    ModelInfo = record
      Filename: string;
      RefName: string;
      MaxContext: UInt64;
      Template: string;
      TemplateEnding: string;
      SkipTokens: array of string;
    end;
  protected type

    TMessage = record
      Role: string;
      Context: string;
    end;
    TMessages = TList<TMessage>;
    TModels = TDictionary<string, TDllama.ModelInfo>;
  protected
    FModelPath: string;
    FModel: Pllama_model;
    FModelParams: llama_model_params;
    FCandidates: TVirtualBuffer<llama_token_data>;
    FVocabCount: Int32;
    FContext: Pllama_context;
    FContexParams: llama_context_params;
    FUsage: TDllama.Usage;
    FMessages: TMessages;
    FUserMessage: string;
    FError: string;
    FTemperature: Single;
    FLastToken: string;
    FModels: TModels;
    FModelInfo: TDllama.ModelInfo;
    FInferenceActive: Boolean;
    FQuitInferenceKey: Byte;

    function  IsSkipToken(const AToken: string): Boolean;
    function  GetInferencePrompt(): string;
    function  DoInference(const APrompt: string; var AResult: string; AUsage: TDllama.PUsage): Boolean;
  public
    // init
    constructor Create(); override;
    destructor Destroy(); override;

    // error
    function  GetError(): string;
    procedure SetError(const AMsg: string; const AArgs: array of const);

    // model
    function  SetModelPath(const APath: string): Boolean;
    procedure ClearModels();
    procedure AddModel(const AFilename, AReferenceName: string; const AMaxContext: UInt64; const ATemplate, ATemplateEnding: string; const ASkipTokens: array of string);
    function  LoadModel(const AReferenceName: string): Boolean;
    procedure UnloadModel();
    function  ModelLoaded(): Boolean;
    function  GetModelInfo(): TDllama.ModelInfo;
    function  SaveModelDb(const AFilename: string='models.json'): Boolean;
    function  LoadModelDb(const AFilename: string='models.json'): Boolean;

    // message
    procedure ClearMessages();
    procedure AddSystemMessage(const AMessage: string);
    procedure AddSystemMessageFromFile(const AFilename: string);
    procedure AddUserMessage(const AMessage: string);
    procedure AddAssistantMessage(const AMessage: string);
    procedure AddToolMessage(const AMessage: string);
    function  GetUserMessage(): string;

    // inference
    function  GetQuitInferenceKey(): Byte;
    procedure SetQuitInferenceKey(const AKey: Byte=VK_ESCAPE);
    function  GetTemperature(): Single;
    procedure SetTemperature(const ATemperature: Single);
    function  Inference(const AReferenceName: string; var AResponse: string; const AMaxTokens: UInt32=1024; const ATemperature: Single=TEMPREATURE_BALANCED; const ASeed: UInt32=MaxInt; AUsage: TDllama.PUsage=nil): Boolean;
    function  IsInferenceActive(): Boolean;
    procedure GetInferenceUsage(var AUsage: TDllama.Usage);

    // events
    procedure OnCError(const AText: string); virtual;
    function  OnLoadModelProgress(const AReferenceName: string; const AProgress: Single): Boolean; virtual;
    procedure OnLoadModel(const ASuccess: Boolean); virtual;
    procedure OnLog(const ALevel: Integer; const AText: string); virtual;
    procedure OnInference(const AToken: string); virtual;

  end;

implementation

{ TDllama }
function TDllama_ModelLoadProgressCallback(AProgress: single; ACtx: pointer): boolean; cdecl;
var
  LDllama: TDllama;
begin
  LDllama := ACtx;

  if Assigned(LDllama) then
    Result := TDllama(LDllama).OnLoadModelProgress(LDllama.GetModelInfo().RefName, AProgress)
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

constructor TDllama.Create();
begin
  inherited;
  FModels := TModels.Create();
  FMessages := TMessages.Create();
  SetQuitInferenceKey(VK_ESCAPE);
end;

destructor TDllama.Destroy();
begin
  inherited;

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
end;

function  TDllama.GetError(): string;
begin
  Result := FError;
end;

procedure TDllama.SetError(const AMsg: string; const AArgs: array of const);
begin
  FError := Format(AMsg, AArgs);
end;

procedure TDllama.ClearModels();
begin
  FModels.Clear();
end;

procedure TDllama.AddModel(const AFilename, AReferenceName: string; const AMaxContext: UInt64; const ATemplate, ATemplateEnding: string; const ASkipTokens: array of string);
var
  LModelInfo: TDllama.ModelInfo;
  I: Integer;
begin
  LModelInfo.Filename := AFilename;
  LModelInfo.RefName := AReferenceName;
  LModelInfo.MaxContext := AMaxContext;
  LModelInfo.Template := ATemplate;
  LModelInfo.TemplateEnding := ATemplateEnding;
  SetLength(LModelInfo.SkipTokens, High(ASkipTokens)+1);
  for I := Low(ASkipTokens) to High(ASkipTokens) do
  begin
    LModelInfo.SkipTokens[I] := ASkipTokens[I];
  end;
  FModels.AddOrSetValue(AReferenceName, LModelInfo);
end;

function TDllama.SetModelPath(const APath: string): Boolean;
begin
  Result := False;
  if not TDirectory.Exists(APath) then Exit;
  FModelPath := APath;
end;

function TDllama.LoadModel(const AReferenceName: string): Boolean;
var
  LFilename: string;
begin
  Result := False;
  if Assigned(FModel) then Exit;
  try
    if not FModels.TryGetValue(AReferenceName, FModelInfo) then
    begin
      SetError('Refrence model "%s" not found.', [AReferenceName]);
      Exit;
    end;

    LFilename := TPath.Combine(FModelPath, FModelInfo.Filename);
    if not TFile.Exists(LFilename) then Exit;

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
    FModelParams.n_gpu_layers := 1000;

    FModel := llama_load_model_from_file(Utils.AsUTF8(LFilename), FModelParams);
    if not Assigned(FModel) then
    begin
      llama_backend_free();
      restore_cerr();
      SetError('Unable to load model: "%s"', [LFilename]);
      UnloadModel();
      Exit;
    end;

    FContexParams := llama_context_default_params();
    FContexParams.offload_kqv := true;
    FContexParams.seed  := MaxInt;
    FContexParams.n_ctx := FModelInfo.MaxContext;
    FContexParams.n_threads := Utils.GetPhysicalProcessorCount();
    FContexParams.n_threads_batch := FContexParams.n_threads;
    FContext := llama_new_context_with_model(FModel, FContexParams);
    if not Assigned(FContext) then
    begin
      SetError('Failed to create llama context', []);
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

    SetTemperature(0);

    Result := True;
  finally
    OnLoadModel(Result);
  end;
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

  FModelInfo := Default(TDllama.ModelInfo);
end;

function  TDllama.ModelLoaded(): Boolean;
begin
  Result := Boolean(Assigned(FModel) and Assigned(FContext));
end;

function  TDllama.GetModelInfo(): TDllama.ModelInfo;
begin
  Result := FModelInfo;
end;

function  TDllama.SaveModelDb(const AFilename: string): Boolean;
var
  LModelInfo: TPair<string, TDllama.ModelInfo>;
  LJson: TJsonObject;
  LModel: TJsonObject;
  LSkipTokens: TJsonArray;
  LToken: string;
  LFilename: string;
begin
  Result := False;
  if AFilename.IsEmpty then Exit;

  LFilename := TPath.ChangeExtension(AFilename, 'json');

  LJson := TJsonObject.Create();
  try
    with LJson.AddArray('Models') do
    begin
      for LModelInfo in FModels do
      begin
        LModel := TJsonObject.Create();
        LModel.S['Filename'] := LModelInfo.Value.Filename;
        LModel.S['RefName'] := LModelInfo.Key;
        LModel.I['MaxContext'] := LModelInfo.Value.MaxContext;
        LModel.S['Template'] := LModelInfo.Value.Template;
        LModel.S['TemplateEnding'] := LModelInfo.Value.TemplateEnding;
        LSkipTokens := TJsonArray.Create();
        for LToken in LModelInfo.Value.SkipTokens do
        begin
          LSkipTokens.Add(LToken);
        end;
        LModel.A['SkipTokens'] := LSkipTokens;
        Add(LModel);
      end;
    end;
    TFile.WriteAllText(LFilename, LJson.Format(), TEncoding.UTF8);
  finally
    LJson.Free();
  end;
  Result := TFile.Exists(LFilename);
end;

function  TDllama.LoadModelDb(const AFilename: string): Boolean;
var
  LFilename: string;
  LJson: TJsonObject;
  LCount: Integer;
  LModelInfo: TDllama.ModelInfo;
  LSkipTokens: TJsonArray;
  I,J: Integer;
begin
  Result := False;
  if AFilename.IsEmpty then Exit;

  LFilename := TPath.ChangeExtension(AFilename, 'json');
  if not TFile.Exists(LFilename) then Exit;

  LJson := TJsonObject.Parse(TFile.ReadAllText(LFilename, TEncoding.UTF8));
  try
    if not LJson.Contains('Models') then Exit;
    LCount := LJson.A['Models'].Count;

    if LCount = 0 then Exit;

    ClearModels();

    for I := 0 to LCount-1 do
    begin
      LModelInfo.Filename := LJson.A['Models'].Items[I].FindValue('Filename').Value;
      LModelInfo.RefName := LJson.A['Models'].Items[I].FindValue('RefName').Value;
      LModelInfo.MaxContext := LJson.A['Models'].Items[I].FindValue('MaxContext').Value.ToInt64;
      LModelInfo.Template := LJson.A['Models'].Items[I].FindValue('Template').Value;
      LModelInfo.TemplateEnding := LJson.A['Models'].Items[I].FindValue('TemplateEnding').Value;

      LSkipTokens := LJson.A['Models'].Items[I].FindValue('SkipTokens') as TJsonArray;
      SetLength(LModelInfo.SkipTokens, LSkipTokens.Count);
      for J := 0 to LSkipTokens.Count-1 do
      begin
         LModelInfo.SkipTokens[J] := LSkipTokens.Items[J].Value;
      end;

      AddModel(LModelInfo.Filename, LModelInfo.RefName, LModelInfo.MaxContext, LModelInfo.Template, LModelInfo.TemplateEnding, LModelInfo.SkipTokens);
    end;

  finally
    LJson.Free();
  end;
end;

function  TDllama.DoInference(const APrompt: string; var AResult: string; AUsage: TDllama.PUsage): Boolean;
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
  LNBatch: Int32;
  LTokenData: llama_token_data;
  LTimings: llama_timings;
  LFirstToken: Boolean;
begin
  Result := False;
  AResult := '';
  LFirstToken := True;
  FInferenceActive := True;
  try
    LNLen := FContexParams.n_ctx;

    LAddBos := llama_should_add_bos_token(FModel);
    LMaxTokens := Aprompt.Length + Ord(LAddBos);

    SetLength(LTokens, LMaxTokens);
    LTokenCount := llama_tokenize(FModel, Utils.AsUTF8(Aprompt), LMaxTokens, @LTokens[0], LMaxTokens, LAddBos, true);

    LNCtx    := llama_n_ctx(FContext);
    LNkvReq := LTokenCount + (LNLen - LTokenCount);

    if (LNkvReq > LNCtx) then
    begin
      SetError('The required KV cache size is not big enough', []);
      UnloadModel();
      exit;
    end;

    LNBatch := llama_n_batch(FContext);
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
        if Console.WasKeyPressed(FQuitInferenceKey) then
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

        llama_sample_temp(FContext, @LCandidatesP, FTemperature);
        LNewTokenId := llama_sample_token_greedy(FContext, @LCandidatesP);

        if (llama_token_eos(FModel) = LNewTokenId) or (LNCur = LNLen) then
        begin
          // reached end of inference
          Break;
        end;

        LToken := llama_token_to_piece(FContext, LNewTokenId);

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
        if not IsSkipToken(LToken) then
        begin
          if LToken.EndsWith('\', True) then
            begin
              FLastToken := LToken;
            end
          else
            begin
              if (FLastToken.EndsWith('\', True)) then
              if (LToken = 'n') or (LToken = 'r') or (LToken = 'b') or (LToken = 't') or
                 (LToken = 'f') or (LToken = '/') or (LToken = '"') or (LToken = '\') then
              begin
                LToken := FLastToken + LToken;
                LToken := Utils.SanitizeFromJson(LToken);
                FLastToken := '';
              end;

              AResult := AResult + LToken;
              OnInference(LToken);
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
      if Assigned(AUsage) then
        Ausage^ := FUsage;
    finally
      llama_batch_free(LBatch);
    end;
    Result := True;
  finally
    FInferenceActive := False;
  end;
end;

procedure TDllama.ClearMessages();
begin
  FMessages.Clear();
end;

procedure TDllama.AddSystemMessage(const AMessage: string);
var
  LMessage: TMessage;
begin
  if AMessage.IsEmpty then Exit;
  LMessage.Role := 'system';
  LMessage.Context := AMessage;
  FMessages.Add(LMessage);
end;

procedure TDllama.AddSystemMessageFromFile(const AFilename: string);
begin
  if not TFile.Exists(AFilename) then Exit;
  AddSystemMessage(TFile.ReadAllText(AFilename, TEncoding.UTF8));
end;

procedure TDllama.AddUserMessage(const AMessage: string);
var
  LMessage: TMessage;
begin
  if AMessage.IsEmpty then Exit;
  LMessage.Role := 'user';
  LMessage.Context := AMessage;
  FMessages.Add(LMessage);
  FUserMessage := AMessage;
end;

procedure TDllama.AddAssistantMessage(const AMessage: string);
var
  LMessage: TMessage;
begin
  if AMessage.IsEmpty then Exit;
  LMessage.Role := 'assistant';
  LMessage.Context := AMessage;
  FMessages.Add(LMessage);
  FUserMessage := AMessage;
end;

procedure TDllama.AddToolMessage(const AMessage: string);
var
  LMessage: TMessage;
begin
  if AMessage.IsEmpty then Exit;
  LMessage.Role := 'tool';
  LMessage.Context := AMessage;
  FMessages.Add(LMessage);
end;

function  TDllama.IsSkipToken(const AToken: string): Boolean;
var
  LSkipToken: string;
begin
  Result := False;
  for LSkipToken in FModelInfo.SkipTokens do
  begin
    if SameText(AToken, LSkipToken) then
    begin
      Exit(True);
    end;
  end;
end;

function  TDllama.GetInferencePrompt(): string;
var
  LMessage: TMessage;
begin
  Result := '';
  if FMessages.Count = 0 then Exit;

  for LMessage in FMessages do
  begin
    Result := Result + Format(FModelInfo.Template, [LMessage.Role, LMessage.Context]);
  end;
  if not FModelInfo.TemplateEnding.IsEmpty then
    Result := Result + FModelInfo.TemplateEnding;
end;

function  TDllama.GetUserMessage(): string;
begin
  Result := FUserMessage;
end;

function  TDllama.GetTemperature(): Single;
begin
  Result := FTemperature;
end;

function  TDllama.GetQuitInferenceKey(): Byte;
begin
  Result := FQuitInferenceKey;
end;

procedure TDllama.SetQuitInferenceKey(const AKey: Byte);
begin
  FQuitInferenceKey := AKey;
end;

procedure TDllama.SetTemperature(const ATemperature: Single);
begin
  FTemperature := EnsureRange(ATemperature, 1e-8, 1);
end;

function  TDllama.Inference(const AReferenceName: string; var AResponse: string; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32; AUsage: TDllama.PUsage): Boolean;
var
  LMessages: string;
begin
  Result := False;

  // no model is loaded
  if not ModelLoaded() then
    begin
      // try to load model
      if not LoadModel(AReferenceName) then Exit;
    end
  else
    begin
      // check if requested model is not already loaded
      if FModelInfo.RefName <> AReferenceName  then
      begin
        // unload current model
        UnloadModel();

        // try to load model
        if not LoadModel(AReferenceName) then Exit;
      end;
    end;

  if Assigned(FContext) then
  begin
    llama_free(FContext);
  end;

  FContexParams := llama_context_default_params();
  FContexParams.offload_kqv := true;
  FContexParams.seed  := ASeed;
  FContexParams.n_ctx := EnsureRange(AMaxTokens, 512, FModelInfo.MaxContext);
  FContexParams.n_threads := Utils.GetPhysicalProcessorCount();
  FContexParams.n_threads_batch := FContexParams.n_threads;
  FContext := llama_new_context_with_model(FModel, FContexParams);
  if not Assigned(FContext) then
  begin
    SetError('Failed to create llama context', []);
    UnloadModel();
    Exit;
  end;

  if FMessages.Count = 0 then Exit;
  LMessages := GetInferencePrompt();
  FLastToken := '';

  SetTemperature(ATemperature);
  Result := DoInference(LMessages, AResponse, AUsage);
end;

function  TDllama.IsInferenceActive(): Boolean;
begin
  Result := FInferenceActive;
end;

procedure TDllama.GetInferenceUsage(var AUsage: TDllama.Usage);
begin
  AUsage := FUsage;
end;

procedure TDllama.OnCError(const AText: string);
begin
  Console.Print(AText);
end;

function  TDllama.OnLoadModelProgress(const AReferenceName: string; const AProgress: Single): Boolean;
begin
  Console.Print(Console.CR+'Loading model "%s" (%3.2f%s)...', [AReferenceName, AProgress*100, '%']);
  Result := True;
end;

procedure TDllama.OnLoadModel(const ASuccess: Boolean);
begin
  Console.ClearLine(Console.WHITE);
end;

procedure TDllama.OnLog(const ALevel: Integer; const AText: string);
begin
  Console.Print(AText);
end;

procedure TDllama.OnInference(const AToken: string);
begin
  Console.Print(AToken);
end;

end.

