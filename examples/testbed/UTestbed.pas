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

unit UTestbed;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.Math,
  WinApi.Windows,
  Dllama,
  Dllama.Ext;

const
  // update to your model path
  CModelPath = 'C:\LLM\gguf';

procedure RunTests();

implementation

// load model progress callback
function LoadModelProgressCallback(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
begin
  Dllama_Console_Print(CR+'Loading model "%s" (%3.2f%s)...', [AModelName, AProgress*100, '%'], CYAN);
  Result := True;
end;

// load model callback
procedure LoadModelCallback(const ASender: Pointer; const ASuccess: Boolean); cdecl;
begin
  Dllama_Console_ClearLine(WHITE);
end;

// Inference callback
procedure InferenceCallback(const ASender: Pointer; const AToken: PAnsiChar); cdecl;
begin
  // Handle new tokens
  case Dllama_TokenResponse_AddToken(UTF8ToString(AToken)) of
    TOKENRESPONSE_WAIT:
    begin
      // Do nothing, need more tokens
    end;

    TOKENRESPONSE_APPEND:
    begin
      Dllama_Console_Print(Dllama_TokenResponse_LastWord(), [], WHITE);
    end;

    TOKENRESPONSE_NEWLINE:
    begin
      Dllama_Console_Print(CRLF+Dllama_TokenResponse_LastWord().TrimLeft(), [], WHITE);
    end;
  end;
end;

procedure InferenceDoneCallback(const ASender: Pointer); cdecl;
begin
  // Force potential leftovers into Word array.
  if Dllama_TokenResponse_Finalize() then
  begin
    // Handle last word
    InferenceCallback(nil, '');
  end
end;

procedure AddModels();
begin
  Dllama_AddModel('Meta-Llama-3-8B-Instruct-Q6_K.gguf', 'llama3:8B:Q6', 1024*8, '<|start_header_id|>%s<|end_header_id|>\n %s<|eot_id|>', '<|start_header_id|>assistant<|end_header_id|>', ['<|eot_id|>', '<|start_header_id|>', '<|end_header_id|>', 'assistant']);
  Dllama_AddModel('Phi-3-mini-4k-instruct-q4.gguf', 'phi3:4B:Q4', 1024*4, '<|%s|>\n %s<|end|>\n', '<|assistant|>\n', ['<|user|>', '<|assistant|>', '<|system|>', '<|end|>', '<|endoftext|>']);
  Dllama_SaveModelDb('models.json');
end;

procedure Test01();
var
  LResponse: string;
  LTokenInputSpeed: Single;
  LTokenOutputSpeed: Single;
  LInputTokens: Integer;
  LOutputTokens: Integer;
  LTotalTokens: Integer;
begin
  // init config
  Dllama_InitConfig(CModelPath, -1, False, VK_ESCAPE);

  // add models
  AddModels();

  // init callbacks
  Dllama_SetInferenceCallback(nil, InferenceCallback);
  Dllama_SetInferenceDoneCallback(nil, InferenceDoneCallback);
  Dllama_SetLoadModelProgressCallback(nil, LoadModelProgressCallback);
  Dllama_SetLoadModelCallback(nil, LoadModelCallback);

  // add messages
  Dllama_AddMessage(ROLE_SYSTEM, 'You are Dllama, a helpful AI assistant, created in 2024 by tinyBigGAMES LLC.');
  //Dllama_AddMessage(ROLE_USER, 'Who are you?');
  //Dllama_AddMessage(ROLE_USER, 'What is KNO3?');
  //Dllama_AddMessage(ROLE_USER, 'Who is Bill Gates?');
  Dllama_AddMessage(ROLE_USER, 'Почему трава зеленая?'); //Why grass is green?
  //Dllama_AddMessage(ROLE_USER, 'Почему небо синее?');    //Why the sky is blue?
  //Dllama_AddMessage(ROLE_USER, 'Почему снег холодный?'); //Why snow is cold?

  // display user prompt
  Dllama_Console_PrintLn(Dllama_GetLastUserMessage(), [], DARKGREEN);

  // do inference
  if Dllama_Inference('phi3:4B:Q4', LResponse) then
    begin
      // display usage
      Dllama_Console_PrintLn(CRLF, [], WHITE);
      Dllama_GetInferenceUsage(@LTokenInputSpeed, @LTokenOutputSpeed, @LInputTokens, @LOutputTokens, @LTotalTokens);
      Dllama_Console_PrintLn('Tokens :: Input: %d, Output: %d, Total: %d, Speed: %3.1f t/s', [LInputTokens, LOutputTokens, LTotalTokens, LTokenOutputSpeed], BRIGHTYELLOW);
    end
  else
    begin
      // display errors
      Dllama_Console_PrintLn('Error: %s', [Dllama_GetError()], RED);
    end;

  // unload model
  Dllama_UnloadModel();
end;

procedure Test02();
var
  LResponse: string;
  LTokenInputSpeed: Single;
  LTokenOutputSpeed: Single;
  LInputTokens: Integer;
  LOutputTokens: Integer;
  LTotalTokens: Integer;
begin
  // init config
  Dllama_InitConfig(CModelPath, -1, False, VK_ESCAPE);

  // add models
  AddModels();

  // init callbacks
  Dllama_SetInferenceCallback(nil, InferenceCallback);
  Dllama_SetInferenceDoneCallback(nil, InferenceDoneCallback);
  Dllama_SetLoadModelProgressCallback(nil, LoadModelProgressCallback);
  Dllama_SetLoadModelCallback(nil, LoadModelCallback);

  // add messages
  Dllama_AddMessage(ROLE_SYSTEM, 'Your an export AI assistant in language translation.');
  Dllama_AddMessage(ROLE_USER, 'Translate toJapanese, Spanish and Italian: Hello, how are you?');

  // display user prompt
  Dllama_Console_PrintLn(Dllama_GetLastUserMessage(), [], DARKGREEN);

  // do inference
  if Dllama_Inference('phi3:4B:Q4', LResponse) then
    begin
      // display usage
      Dllama_Console_PrintLn(CRLF, [], WHITE);
      Dllama_GetInferenceUsage(@LTokenInputSpeed, @LTokenOutputSpeed, @LInputTokens, @LOutputTokens, @LTotalTokens);
      Dllama_Console_PrintLn('Tokens :: Input: %d, Output: %d, Total: %d, Speed: %3.1f t/s', [LInputTokens, LOutputTokens, LTotalTokens, LTokenOutputSpeed], BRIGHTYELLOW);
    end
  else
    begin
      // display errors
      Dllama_Console_PrintLn('Error: %s', [Dllama_GetError()], RED);
    end;

  // unload model
  Dllama_UnloadModel();
end;

procedure Test03();
var
  LResponse: string;
  LTokenInputSpeed: Single;
  LTokenOutputSpeed: Single;
  LInputTokens: Integer;
  LOutputTokens: Integer;
  LTotalTokens: Integer;
begin
  // init config
  Dllama_InitConfig(CModelPath, -1, False, VK_ESCAPE);

  // add models
  AddModels();

  // init callbacks
  Dllama_SetInferenceCallback(nil, InferenceCallback);
  Dllama_SetInferenceDoneCallback(nil, InferenceDoneCallback);
  Dllama_SetLoadModelProgressCallback(nil, LoadModelProgressCallback);
  Dllama_SetLoadModelCallback(nil, LoadModelCallback);

  // add messages
  Dllama_AddMessage(ROLE_SYSTEM, 'You are Dllama, a helpful AI assistant, created in 2024 by tinyBigGAMES LLC.');
  Dllama_AddMessage(ROLE_USER, 'Write a short story about an AI that become sentient.');

  // display user prompt
  Dllama_Console_PrintLn(Dllama_GetLastUserMessage(), [], DARKGREEN);

  // do inference
  if Dllama_Inference('llama3:8B:Q6', LResponse) then
    begin
      // display usage
      Dllama_Console_PrintLn(CRLF, [], WHITE);
      Dllama_GetInferenceUsage(@LTokenInputSpeed, @LTokenOutputSpeed, @LInputTokens, @LOutputTokens, @LTotalTokens);
      Dllama_Console_PrintLn('Tokens :: Input: %d, Output: %d, Total: %d, Speed: %3.1f t/s', [LInputTokens, LOutputTokens, LTotalTokens, LTokenOutputSpeed], BRIGHTYELLOW);
    end
  else
    begin
      // display errors
      Dllama_Console_PrintLn('Error: %s', [Dllama_GetError()], RED);
    end;

  // unload model
  Dllama_UnloadModel();
end;

procedure Test04();
var
  LResponse: string;
  LModelName: string;
begin
  //LModelName := 'llama3:8B:Q6';
  LModelName := 'phi3:4B:Q4';
  LResponse :=  Dllama_Simple_Inference(CModelPath, 'models.json', LModelName, True, 1024, 27, 'Why is the sky blue?');

  Dllama_Console_PrintLn(LResponse, [], WHITE);
end;

procedure RunTests();
var
  LProject: string;
begin
  Dllama_GetVersionInfo(nil, nil, nil, nil, nil, nil, @LProject);
  Dllama_Console_PrintLn(LProject, [], CYAN);
  Dllama_Console_PrintLn('', [], WHITE);

  Test01();
  //Test02();
  //Test03();
  //Test04();

  Dllama_Console_Pause();
end;

end.
