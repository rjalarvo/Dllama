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

unit Dllama.Ext;

interface

uses
  System.SysUtils,
  System.StrUtils,
  Dllama;

type

  // AddToken return messages
  //  paWait = No new (full) words, just wait for more incoming tokens
  //  Append = Append existing line with latest word
  //  NewLine = start new line then print the latest word
  TTokenPrintAction = (paWait, paAppend, paNewline);

  { TResponse }
  TTokenResponse = record
  public
    Raw: String;                  // Full response as is
    LineLengthMax: Integer;       // Define confined space, in chars for fixed width font
    WordBreaks: array of char;    // What is considered a logical line-break
    Words: array of String;       // Response but as array of "words"
  private
    LWord: String;                // Internal! current word accumulating
    LLine: String;                // Internal! for keeping track what has been printed
  public
    class operator Initialize (out ADest: TTokenResponse);
    function AddToken(const aToken: String): TTokenPrintAction;
    function Splitword(const AWord: String; var APrefix, ASuffix: String): Boolean;
    function LastWord: String;
    procedure Finalize;
  end;

// Info
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PString);

// Config
procedure Dllama_InitConfig(const AModelPath: string; const ANumGPULayers: Integer=-1; const ADisplayInfo: Boolean=False; const ACancelInferenceKey: Byte=VK_ESCAPE);
procedure Dllama_GetConfig(AModelPath: PString; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte);
function  Dllama_SaveConfig(const AFilename: string='config.json'): Boolean;
function  Dllama_LoadConfig(const AFilename: string='config.json'): Boolean;

// Error
function  Dllama_GetError(): string;
procedure Dllama_SetError(const AMsg: string; const AArgs: array of const);

// Model
function  Dllama_AddModel(const AFilename, AName: string; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: string; const AStopSequences: array of string): Boolean;
function  Dllama_SaveModelDb(const AFilename: string='models.json'): Boolean;
function  Dllama_LoadModelDb(const AFilename: string='models.json'): Boolean;
function  Dllama_LoadModel(const AName: string): Boolean;

// Messages
procedure Dllama_AddMessage(const ARole, AMessage: string);
function  Dllama_GetLastUserMessage(): string;

// Inference
function  Dllama_Inference(const AModelName: string; var AResponse: string; const AMaxTokens: UInt32=1024; const ATemperature: Single=TEMPREATURE_BALANCED; const ASeed: UInt32=MaxInt): Boolean;
procedure Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger);

// Console
procedure Dllama_Console_SetTitle(const ATitle: string);
procedure Dllama_Console_Pause(const AForcePause: Boolean=False; AColor: Word=WHITE; const AMsg: string='');
procedure Dllama_Console_Print(const AMsg: string; const AArgs: array of const; const AColor: Word);
procedure Dllama_Console_PrintLn(const AMsg: string; const AArgs: array of const; const AColor: Word);

var
  TokenResponse: TTokenResponse;

implementation

// Info
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject: PString);
var
  LName: PAnsiChar;
  LCodeName: PAnsiChar;
  LMajorVersion: PAnsiChar;
  LMinorVersion: PAnsiChar;
  LPatchVersion: PAnsiChar;
  LVersion: PAnsiChar;
  LProject: PAnsiChar;
begin
  Dllama.Dllama_GetVersionInfo(@LName, @LCodeName, @LMajorVersion, @LMinorVersion, @LPatchVersion, @LVersion, @LProject);

  if Assigned(AName) then
    AName^ := string(LName);

  if Assigned(ACodeName) then
    ACodeName^ := string(LCodeName);

  if Assigned(AMajorVersion) then
    AMajorVersion^ := string(LMajorVersion);

  if Assigned(AMinorVersion) then
    AMinorVersion^ := string(LMinorVersion);

  if Assigned(APatchVersion) then
    APatchVersion^ := string(LPatchVersion);

  if Assigned(AVersion) then
    AVersion^ := string(LVersion);

  if Assigned(AProject) then
    AProject^ := string(LProject);
end;

// Config
procedure Dllama_InitConfig(const AModelPath: string; const ANumGPULayers: Integer; const ADisplayInfo: Boolean; const ACancelInferenceKey: Byte);
begin
  Dllama.Dllama_InitConfig(PUTF8Char(UTF8Encode(AModelPath)), aNumGPULayers, ADisplayInfo, ACancelInferenceKey);
end;

procedure Dllama_GetConfig(AModelPath: PString; ANumGPULayers: PInteger; ADisplayInfo: PBoolean; ACancelInferenceKey: PByte);
var
  LModelPath: PAnsiChar;
begin
  Dllama.Dllama_GetConfig(@LModelPath, ANumGPULayers, ADisplayInfo, ACancelInferenceKey);

  if Assigned(AModelPath) then
    AModelPath^ := string(LModelPath);
end;

function  Dllama_SaveConfig(const AFilename: string): Boolean;
begin
  Result := Dllama.Dllama_SaveConfig(PUTF8Char(UTF8Encode(AFilename)));
end;

function  Dllama_LoadConfig(const AFilename: string): Boolean;
begin
  Result := Dllama.Dllama_LoadConfig(PUTF8Char(UTF8Encode(AFilename)));
end;


// Error
function  Dllama_GetError(): string;
begin
  Result := string(Dllama.Dllama_GetError());
end;

procedure Dllama_SetError(const AMsg: string; const AArgs: array of const);
begin
  Dllama.Dllama_SetError(PUTF8Char(UTF8Encode(Format(AMsg, AArgs))));
end;

// Model
function  Dllama_AddModel(const AFilename, AName: string; const AMaxContext: UInt64; const AChatMessageTemplate, AChatMessageTemplateEnd: string; const AStopSequences: array of string): Boolean;
var
  LStopSequences: array of PAnsiChar;
  LStopSequenceStrings: array of AnsiString; // To keep the strings alive
  LStopSequenceCount: Integer;
  I: Integer;
begin
  LStopSequenceCount := High(AStopSequences) + 1;
  SetLength(LStopSequences, LStopSequenceCount);
  SetLength(LStopSequenceStrings, LStopSequenceCount); // Allocate space for the strings

  for I := 0 to LStopSequenceCount - 1 do
  begin
    LStopSequenceStrings[I] := UTF8Encode(AStopSequences[I]); // Convert and store in a persistent array
    LStopSequences[I] := PAnsiChar(LStopSequenceStrings[I]);  // Assign the pointer to the persistent string
  end;

  Result := Dllama.Dllama_AddModel(PUTF8Char(UTF8Encode(AFilename)), PUTF8Char(UTF8Encode(AName)), AMaxContext, PUTF8Char(UTF8Encode(AChatMessageTemplate)), PUTF8Char(UTF8Encode(AChatMessageTemplateEnd)), @LStopSequences[0], LStopSequenceCount);
end;

function  Dllama_SaveModelDb(const AFilename: string): Boolean;
begin
  Result := Dllama.Dllama_SaveModelDb(PUTF8Char(UTF8Encode(AFilename)));
end;

function  Dllama_LoadModelDb(const AFilename: string): Boolean;
begin
  Result := Dllama.Dllama_LoadModelDb(PUTF8Char(UTF8Encode(AFilename)));
end;

function  Dllama_LoadModel(const AName: string): Boolean;
begin
  Result := Dllama.Dllama_LoadModel(PUTF8Char(UTF8Encode(AName)));
end;


// Messages
procedure Dllama_AddMessage(const ARole, AMessage: string);
begin
  Dllama.Dllama_AddMessage(PUTF8Char(UTF8Encode(ARole)), PUTF8Char(UTF8Encode(AMessage)));
end;

function  Dllama_GetLastUserMessage(): string;
begin
  Result := string(Dllama.Dllama_GetLastUserMessage());
end;

// Inference
function  Dllama_Inference(const AModelName: string; var AResponse: string; const AMaxTokens: UInt32; const ATemperature: Single; const ASeed: UInt32): Boolean;
var
  LResponse: PAnsiChar;
begin
  Result := Dllama.Dllama_Inference(PUTF8Char(UTF8Encode(AModelName)), @LResponse, AMaxTokens, ATemperature, ASeed);
  AResponse := string(LResponse);
end;

procedure Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed: PSingle; AInputTokens, AOutputTokens, ATotalTokens: PInteger);
begin
  Dllama.Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed, AInputTokens, AOutputTokens, ATotalTokens);
end;

// Console
procedure Dllama_Console_SetTitle(const ATitle: string);
begin
  Dllama.Dllama_Console_SetTitle(PUTF8Char(UTF8Encode(ATitle)));
end;

procedure Dllama_Console_Pause(const AForcePause: Boolean; AColor: Word; const AMsg: string);
begin
  Dllama.Dllama_Console_Pause(AForcePause, AColor, PUTF8Char(UTF8Encode(AMsg)));
end;

procedure Dllama_Console_Print(const AMsg: string; const AArgs: array of const; const AColor: Word);
begin
  Dllama.Dllama_Console_Print(PUTF8Char(UTF8Encode(Format(AMsg, AArgs))), AColor);
end;

procedure Dllama_Console_PrintLn(const AMsg: string; const AArgs: array of const; const AColor: Word);
begin
  Dllama.Dllama_Console_PrintLn(PUTF8Char(UTF8Encode(Format(AMsg, AArgs))), AColor);
end;

{ TTokenResponse }
class operator TTokenResponse.Initialize (out ADest: TTokenResponse);
var
  LWidth: Integer;
begin
  Dllama_Console_GetSize(@LWidth, nil);

  ADest.LineLengthMax := LWidth - 0;

  // These depend on the use case, what the AI is spewing out, here demo for natural language
  SetLength(ADest.WordBreaks, 6);
  ADest.WordBreaks[0] := ' ';
  ADest.WordBreaks[1] := '-';
  ADest.WordBreaks[2] := ',';
  ADest.WordBreaks[3] := '.';
  ADest.WordBreaks[4] := #13;
  ADest.WordBreaks[5] := #10;
end;

function TTokenResponse.AddToken(const aToken: String): TTokenPrintAction;
var
  LPrefix, LSuffix: String;
begin
  // Always keep full response up to date, other tasks would need it
  Raw := Raw + aToken;

  // Accumulate "word"
  LWord := LWord + aToken;

  // Check if a natural break exists, also split if word is longer than the allowed space
  if SplitWord(LWord, LPrefix, LSuffix) then
    begin
      Setlength(Words, Length(Words)+1);      // Make space
      Words[Length(Words)-1] := LPrefix;       // Add new word to array

      LWord := LSuffix;                         // Keep the remainder of the split

      // Word was split, so there is something that can be printed

      // Need for a new line?
      if Length(LLine) + Length(LastWord) > LineLengthMax then
        begin
          Result  := TTokenPrintAction.paNewline;
          LLine    := LastWord;                      // Reset Line (will be new line and then the word)
        end
      else
        begin
          Result  := TTokenPrintAction.paAppend;
          LLine    := LLine + LastWord;               // Append to the line
        end;
    end
  else
    begin
      Result := TTokenPrintAction.paWait;
    end;
end;

procedure TTokenResponse.Finalize;
begin
  // Unsplit tail is still unprocessed, add it as the last word
  Setlength(Words, Length(Words)+1);      // Make space
  Words[Length(Words)-1] := LWord;       // Add new word to array
end;

function TTokenResponse.LastWord: String;
begin
  Result := Words[Length(Words)-1];
end;

function TTokenResponse.Splitword(const AWord: String; var APrefix, ASuffix: String): Boolean;
var
  LLetter, LSeparator: Integer;
begin
  Result := false;

  for LLetter := 1 to Length(AWord) do               // Iterate whole word
  begin
    for LSeparator := 0 to Length(WordBreaks)-1 do   // Iterate all separating characters
    begin
      if AWord[LLetter] = WordBreaks[LSeparator] then // check for natural break
      begin
        // Let the world know there's stuff that can be a reason for a line change
        Result := True;

        APrefix := LeftStr(AWord, LLetter);
        ASuffix := RightStr(AWord, Length(AWord)-LLetter);
      end;
    end;
  end;

  // Maybe the word is too long but there was no natural break, then cut it to LineLengthMax
  if Length(AWord) > LineLengthMax then
  begin
    Result := True;
    APrefix := LeftStr(AWord, LineLengthMax);
    ASuffix := RightStr(AWord, Length(AWord)-LineLengthMax);
  end;
end;

end.
