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

unit Dllama.Deps.Ext;

{$I Dllama.Defines.inc}

interface

uses
  Dllama.Deps,
  Dllama.Utils;

{ llama }
function  llama_should_add_bos_token(const model: Pllama_model): Boolean;

function  llama_token_to_piece(const ctx: Pllama_context; token: llama_token): string;

procedure llama_batch_add(var batch: llama_batch; id: llama_token; pos: llama_pos; const seq_ids: array of llama_seq_id; logits: Boolean);
procedure llama_batch_clear(var batch: llama_batch);

procedure llama_timing_usage(timings: llama_timings; var input_tokens: Int32; var output_tokens: Int32; var input_speed: double; var output_speed: Double);


implementation

uses
  System.SysUtils;

function llama_should_add_bos_token(const model: Pllama_model): Boolean;
var
  add_bos: Integer;
begin
  add_bos := llama_add_bos_token(model);

  if add_bos <> -1 then
    Result := Boolean(add_bos)
  else
    Result := llama_vocab_type(model) = LLAMA_VOCAB_TYPE_SPM;
end;

function llama_token_to_piece(const ctx: Pllama_context; token: llama_token): string;
var
  LTokens: Integer;
  LCheck: Integer;
begin
  Result := '';

  LTokens := Dllama.Deps.llama_token_to_piece(llama_get_model(ctx), token, PUTF8Char(Utils.GetTempStaticBuffer()), 8, False);
  if LTokens < 0 then
    begin
      LCheck := Dllama.Deps.llama_token_to_piece(llama_get_model(ctx), token, PUTF8Char(Utils.GetTempStaticBuffer()), -LTokens, False);
      Assert(LCheck = -LTokens);
      Utils.GetTempStaticBuffer[-LTokens] := 0;
    end
  else
    begin
      Utils.GetTempStaticBuffer[LTokens] := 0;
    end;
  Result := Utf8ToString(PAnsiChar(Utils.GetTempStaticBuffer()));
end;

procedure llama_batch_add(var batch: llama_batch; id: llama_token; pos: llama_pos; const seq_ids: array of llama_seq_id; logits: Boolean);
var
  i: Integer;
  tokenPtr: Pllama_token;
  posPtr: Pllama_pos;
  n_seq_idPtr: PInt32;
  seq_idPtr: PPllama_seq_id;
  logitsPtr: PInt8;
begin
  //batch.token[batch.n_tokens] := id;
  tokenPtr := batch.token;
  Inc(tokenPtr, batch.n_tokens);
  tokenPtr^ := id;

  //batch.pos[batch.n_tokens] := pos;
  posPtr := batch.pos;
  Inc(posPtr, batch.n_tokens);
  PosPtr^ := pos;

  //batch.n_seq_id[batch.n_tokens] := Length(seq_ids);
  n_seq_idPtr := batch.n_seq_id;
  Inc(n_seq_idPtr, batch.n_tokens);
  n_seq_idPtr^ :=  Length(seq_ids);

  for i := 0 to High(seq_ids) do
  begin
    seq_idPtr := batch.seq_id;
    Inc(seq_idPtr, batch.n_tokens);

    Inc(seq_idPtr^, I);
    seq_idPtr^^ := seq_ids[i];
  end;

  //batch.logits[batch.n_tokens] := logits;
  logitsPtr := batch.logits;
  Inc(logitsPtr, batch.n_tokens);
  logitsPtr^ := Ord(logits);

  Inc(batch.n_tokens);
end;

procedure llama_batch_clear(var batch: llama_batch);
begin
  batch.n_tokens := 0;
end;

procedure llama_timing_usage(timings: llama_timings; var input_tokens: Int32; var output_tokens: Int32; var input_speed: double; var output_speed: Double);
begin
  input_tokens := timings.n_p_eval;
  output_tokens := timings.n_eval;
  input_speed := 1e3 / timings.t_p_eval_ms * timings.n_p_eval;
  output_speed := 1e3 / timings.t_eval_ms * timings.n_eval;
end;

end.
