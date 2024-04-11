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
    PUsage = ^Usage;
    Usage = record
      TokenInputSpeed: Double;
      TokenOutputSpeed: Double;
      InputTokens: Int32;
      OutputTokens: Int32;
      TotalTokens: Int32;
    end;

  protected
    FModelPath: string;
    FModelFilename: string;
    FModel: Pllama_model;
    FModelParams: llama_model_params;
    FCandidates: TVirtualBuffer<llama_token_data>;
    FVocabCount: Int32;
    FContext: Pllama_context;
    FContexParams: llama_context_params;
    FUsage: TDllama.Usage;
    FPrompt: TStringList;
    FUserMessage: string;
    FError: string;
    FTemperature: Single;

    function  DoInference(const APrompt: string; var AResult: string; AUsage: TDllama.PUsage): Boolean;

  public
    constructor Create(); override;
    destructor Destroy(); override;

    function  GetError(): string;
    procedure SetError(const AMsg: string; const AArgs: array of const);

    function  SetModelPath(const APath: string): Boolean;
    function  LoadModel(const AFilename: string; const AMaxContex: Integer): Boolean;
    procedure UnloadModel();
    function  GetModelFilename(): string;

    procedure ClearMessages();
    procedure AddSystemMessage(const AMessage: string);
    procedure AddSystemMessageFromFile(const AFilename: string);
    procedure AddUserMessage(const AMessage: string);
    procedure AddAssistantMessage(const AMessage: string);
    procedure AddToolMessage(const AMessage: string);
    function  GetUserMessage(): string;

    function  GetTemperature(): Single;
    procedure SetTemperature(const ATemperature: Single);

    function  GetInferencePrompt(): string;
    function  Inference(var AResponse: string; AUsage: TDllama.PUsage=nil): Boolean;
    procedure GetInferenceUsage(var AUsage: TDllama.Usage);

    procedure OnCError(const AText: string); virtual;
    function  OnLoadModelProgress(const AProgress: Single): Boolean; virtual;
    procedure OnLog(const ALevel: Integer; const AText: string); virtual;
    procedure OnInference(const AToken: string); virtual;
  end;

implementation

{ TDllama }
function TDllama_ModelLoadProgressCallback(progress: single; ctx: pointer): boolean; cdecl;
begin
  if Assigned(ctx) then
    Result := TDllama(ctx).OnLoadModelProgress(progress)
  else
    Result := False;
end;

procedure TDllama_LogCallback(level: ggml_log_level; const text: PUTF8Char; user_data: Pointer); cdecl;
begin
  if Assigned(user_data) then
    TDllama(user_data).OnLog(level, Utf8ToString(text));
end;

procedure TDllama_CErrCallback(const text: PUTF8Char; user_data: Pointer); cdecl;
begin
  if Assigned(user_data) then
    TDllama(user_data).OnCError(Utf8ToString(text));
end;

constructor TDllama.Create();
begin
  inherited;
  FPrompt := TStringList.Create();
end;

destructor TDllama.Destroy();
begin
  inherited;

  UnloadModel();

  if Assigned(FPrompt) then
  begin
    FPrompt.Free();
    FPrompt := nil;
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

function TDllama.SetModelPath(const APath: string): Boolean;
begin
  Result := False;
  if not TDirectory.Exists(APath) then Exit;
  FModelPath := APath;
end;

function TDllama.LoadModel(const AFilename: string; const AMaxContex: Integer): Boolean;
var
  LFilename: string;
begin
  Result := False;
  if Assigned(FModel) then Exit;

  LFilename := TPath.Combine(FModelPath, AFilename);
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

  FVocabCount := llama_n_vocab(FModel);
  try
    FCandidates := TVirtualBuffer<llama_token_data>.Create(FVocabCount);
  except
    On E: Exception do
    begin
      SetError(E.Message, []);
    end;
  end;

  FContexParams := llama_context_default_params();
  FContexParams.offload_kqv := true;
  FContexParams.seed  := MaxInt;
  FContexParams.n_ctx := AMaxContex;
  FContexParams.n_threads := Utils.GetPhysicalProcessorCount();
  FContexParams.n_threads_batch := FContexParams.n_threads;
  FContext := llama_new_context_with_model(FModel, FContexParams);
  if not Assigned(FContext) then
  begin
    SetError('Failed to create llama context', []);
    UnloadModel();
    Exit;
  end;

  FModelFilename := AFilename;

  SetTemperature(0);

  Result := True;
end;

procedure TDllama.UnloadModel();
begin
  if not Assigned(FModel) then Exit;

  if Assigned(FCandidates) then
  begin
    FCandidates.Free();
    FCandidates := nil;
  end;

  if Assigned(FModel) then
  begin
    llama_free_model(FModel);
    FModel := nil;
    FModelFilename := '';
  end;

  if Assigned(FContext) then
  begin
    llama_free(FContext);
    FContext := nil;
  end;

  llama_backend_free();
  restore_cerr();
end;

function  TDllama.GetModelFilename(): string;
begin
  Result := FModelFilename;
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
  LLogits: PSingle;
  LLogitsP: PSingle;
  LCandidatesP: llama_token_data_array;
  LNewTokenId: llama_token;
  LToken: string;
  LNBatch: Int32;
  LTokenData: llama_token_data;
  LTimings: llama_timings;
begin
  Result := False;
  AResult := '';
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
      if Console.WasKeyPressed(VK_ESCAPE) then
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

      llama_sample_temp(FContext, @LCandidatesP, FTemperature{ 1e-8});
      LNewTokenId := llama_sample_token_greedy(FContext, @LCandidatesP);

      if (llama_token_eos(FModel) = LNewTokenId) or (LNCur = LNLen) then
      begin
        // reached end of inference
        Break;
      end;

      LToken := llama_token_to_piece(FContext, LNewTokenId);
      AResult := AResult + LToken;
      OnInference(LToken);

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
end;

procedure TDllama.ClearMessages();
begin
  FPrompt.Clear();
end;

procedure TDllama.AddSystemMessage(const AMessage: string);
begin
  if AMessage.IsEmpty then Exit;
  FPrompt.Add(Format('<|im_start|>\n system %s \n<|im_end|>', [AMessage]));
end;

procedure TDllama.AddSystemMessageFromFile(const AFilename: string);
begin
  if not TFile.Exists(AFilename) then Exit;
  AddSystemMessage(TFile.ReadAllText(AFilename, TEncoding.UTF8));
end;

procedure TDllama.AddUserMessage(const AMessage: string);
begin
  if AMessage.IsEmpty then Exit;
  FPrompt.Add(Format('<|im_start|>\n user %s \n<|im_end|>', [AMessage]));
  FUserMessage := AMessage;
end;

procedure TDllama.AddAssistantMessage(const AMessage: string);
begin
  if AMessage.IsEmpty then Exit;
  FPrompt.Add(Format('<|im_start|>\n assistant %s \n<|im_end|>', [AMessage]));
end;

procedure TDllama.AddToolMessage(const AMessage: string);
begin
  if AMessage.IsEmpty then Exit;
  FPrompt.Add(Format('<|im_start|>\n tool %s \n<|im_end|>', [AMessage]));
end;

function  TDllama.GetInferencePrompt(): string;
begin
  Result := FPrompt.Text + '\n <|im_start|> assistant\n';
end;

function  TDllama.GetUserMessage(): string;
begin
  Result := FUserMessage;
end;

function  TDllama.GetTemperature(): Single;
begin
  Result := FTemperature;
end;

procedure TDllama.SetTemperature(const ATemperature: Single);
begin
  FTemperature := EnsureRange(ATemperature, 1e-8, 1);
end;

function  TDllama.Inference(var AResponse: string; AUsage: TDllama.PUsage): Boolean;
var
  LMessages: string;
begin
  Result := False;
  if FPrompt.Text.IsEmpty then Exit;
  LMessages := GetInferencePrompt();
  Result := DoInference(LMessages, AResponse, AUsage)
end;

procedure TDllama.GetInferenceUsage(var AUsage: TDllama.Usage);
begin
  AUsage := FUsage;
end;

procedure TDllama.OnCError(const AText: string);
begin
  Console.Print(AText);
end;

function  TDllama.OnLoadModelProgress(const AProgress: Single): Boolean;
begin
  Console.Print(Console.CR+'Loading model (%3.2f%s)...', [AProgress*100, '%']);
  Result := True;
end;

procedure TDllama.OnLog(const ALevel: Integer; const AText: string);
begin
  Console.Print(AText);
end;

procedure TDllama.OnInference(const AToken: string);
begin
  Console.Print(AToken);
end;


{$REGION ' DLL LOADER '}
{$R Dllama.Deps.res}

var
  DepsDLLHandle: THandle = 0;
  DepsDLLFilename: string = '';
  IsInit: Boolean = False;

procedure LoadDLL();
var
  LResStream: TResourceStream;

  function GetResName: string;
  const
    CValue = '7afff4c3624c470c80b1885262cbcf75';
  begin
    Result := CValue;
  end;

  procedure AbortDLL();
  begin
    Halt;
  end;

begin
  // load deps DLL
  if DepsDLLHandle <> 0 then Exit;
  if not Boolean((FindResource(HInstance, PChar(GetResName), RT_RCDATA) <> 0)) then AbortDLL();
  LResStream := TResourceStream.Create(HInstance, GetResName, RT_RCDATA);
  try
    LResStream.Position := 0;
    DepsDLLFilename := TPath.Combine(TPath.GetTempPath,
      TPath.ChangeExtension(TPath.GetGUIDFileName.ToLower, 'dat'));
    LResStream.SaveToFile(DepsDLLFilename);
    if not TFile.Exists(DepsDLLFilename) then AbortDLL();
    DepsDLLHandle := LoadLibrary(PChar(DepsDLLFilename));
    if DepsDLLHandle = 0 then AbortDLL();
  finally
    LResStream.Free();
  end;
  GetExports(DepsDLLHandle);
end;

procedure UnloadDLL();
begin
  // unload deps DLL
  if DepsDLLHandle <> 0 then
  begin
    FreeLibrary(DepsDLLHandle);
    TFile.Delete(DepsDLLFilename);
    DepsDLLHandle := 0;
    DepsDLLFilename := '';
  end;
end;

initialization
begin
  // turn on memory leak detection
  ReportMemoryLeaksOnShutdown := True;

  // load allegro DLL
  LoadDLL();
end;

finalization
begin
  // shutdown allegro DLL
  UnloadDLL();
end;
{$ENDREGION}

end.

