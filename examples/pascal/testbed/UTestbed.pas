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

unit UTestbed;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  WinApi.Windows,
  Dllama;

procedure RunTests();

implementation

procedure Pause();
begin
  Dllama_Print(CRLF, WHITE);
  Dllama_Print('Press ENTER to continue...', WHITE);
  ReadLn;
  Dllama_Print(CRLF, WHITE);
end;

// Error callback
procedure OnError(const ASender: Pointer; const AError: PAnsiChar); cdecl;
begin
end;

// Inference Start callback
procedure OnInferenceStart(const ASender: Pointer); cdecl;
begin
  // display user message
  Dllama_Print(CRLF, WHITE);
  Dllama_Print(Dllama_GetLastUserMessage(), DARKGREEN);
  Dllama_Print(CRLF, WHITE);
end;

// Inference Done callback
procedure OnInferenceDone(const ASender: Pointer; const AResponse: PAnsiChar); cdecl;
begin
end;

// Inference Token callback
procedure OnInferenceToken(const ASender: Pointer; const AToken: PAnsiChar); cdecl;
begin
  Dllama_Print(AToken, WHITE);
end;

// Information callback
procedure OnInfo(const ASender: Pointer; const ALevel: Integer; const AText: PAnsiChar); cdecl;
begin
  Dllama_Print(AText, DARKGRAY); // comment out to not display info
end;

function OnLoadModelProgress(const ASender: Pointer; const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;
begin
  Dllama_Print(PUTF8Char(UTF8Encode(Format(CR+'Loading model "%s" (%3.2f%s)...', [AModelName, AProgress*100, '%']))), CYAN);
  Result := True;
end;

// Load Model callback
procedure OnLoadModel(const ASender: Pointer; const ASuccess: Boolean); cdecl;
begin
  Dllama_ClearLine(WHITE);
  Dllama_Print(CR, WHITE);
end;

// Create an example config file
procedure Test01();
begin
  // create an example config.json for reference
  // you can manually edit this to change your Dllama settings,
  // add new models, etc.
  Dllama_CreateExampleConfig('example_config.json');
end;

// Simple Query
procedure Test02();
const
  //CPrompt = 'Who are you?';
  //CPrompt = 'Who is Bill Gates?';
  //CPrompt = 'Why is the sky blue?';
  //CPrompt = 'A story about an AI coming to life.';
  //CPrompt = 'What is AI?';
  CPrompt = 'Почему снег холодный?'; //Why snow is cold?
  //CPrompt = 'Translate to Japanies, Spaish and Italian: Hello, how are you?';

var
  LCallbacks: TDllama_Callbacks;
  LUsage: TDllama_Usage;
  LResponse: PAnsiChar;
  LError: PAnsiChar;
begin
  LCallbacks := Default(TDllama_Callbacks);
  LCallbacks.ErrorCallback := OnError;
  LCallbacks.InfoCallback := OnInfo;
  LCallbacks.LoadModelProgressCallback := OnLoadModelProgress;
  LCallbacks.LoadModelCallback := OnLoadModel;
  LCallbacks.InferenceStartCallback := OnInferenceStart;
  LCallbacks.InferenceDoneCallback := OnInferenceDone;
  LCallbacks.InferenceTokenCallback := OnInferenceToken;

  if not Dllama_Init('config.json', @LCallbacks) then
    Exit;
  try
    Dllama_AddMessage(ROLE_SYSTEM, 'You are a helpful AI assistant');
    Dllama_AddMessage(ROLE_USER, PUTF8Char(UTF8Encode(CPrompt)));
    if Dllama_Inference('phi3', 1024, @LResponse, @LUsage, @LError) then
    begin
      Dllama_Print(PUTF8Char(UTF8Encode(Format(CRLF+'Tokens :: Input: %d, Output: %d, Total: %d, Speed: %3.1f t/s',
        [LUsage.InputTokens, LUsage.OutputTokens, LUsage.TotalTokens, LUsage.TokenOutputSpeed]))), BRIGHTYELLOW);
    end
  else
    begin
      Dllama_Print(PUTF8Char(UTF8Encode(Format('Error: %s', [LError]))), RED);
    end;
  finally
    Dllama_Quit();
  end;
  Dllama_Print(CRLF, WHITE);
end;

// Simple Inference
procedure Test03();
begin
  Writeln('A: ', Dllama_Simple_Inference('config.json', 'phi3', 'what is kno3?', 1024));
end;

procedure RunTests();
begin
  //Test01();
  Test02();
  //Test03();
  Pause();
end;

end.
