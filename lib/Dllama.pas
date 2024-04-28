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

unit Dllama;

{$IFNDEF WIN64}
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

interface

const
  // Dllama DLL
  DLLAMA_DLL = 'Dllama.dll';

  // Console linefeed & carriage return
  LF   = #10;
  CR   = #13;
  CRLF = LF+CR;

  // Virtual Keys
  VK_ESCAPE = 27;

  // Console colors
  BRIGHTYELLOW = 4 OR 2 OR 8;
  YELLOW       = 4 OR 2;
  WHITE        = 4 OR 2 OR 1;
  BRIGHTWHITE  = 4 OR 2 OR 1 OR 8;
  DARKGREEN    = 2;
  DARKGRAY     = 8;
  CYAN         = 2 OR 1;
  MAGENTA      = 4 OR 1;
  RED          = 4;

  // Temperature
  TEMPERATURE_PERCISE  = 0.0;
  TEMPREATURE_BALANCED = 0.5;
  TEMPREATURE_CREATIVE = 1.0;

  // Message roles
  ROLE_SYSTEM    = 'system';
  ROLE_USER      = 'user';
  ROLE_ASSISTANT = 'assistant';
  ROLE_TOOL      = 'tool';

  // Token Response
  TOKENRESPONSE_WAIT    = 0;
  TOKENRESPONSE_APPEND  = 1;
  TOKENRESPONSE_NEWLINE = 2;

type
  // Callbacks
  TDllama_LoadModelProgressCallback = function(const ASender: Pointer;
    const AModelName: PAnsiChar; const AProgress: Single): Boolean; cdecl;

  TDllama_LoadModelCallback = procedure(const ASender: Pointer;
    const ASuccess: Boolean); cdecl;

  TDllama_InferenceCallback = procedure(const ASender: Pointer;
    const AToken: PAnsiChar); cdecl;

  TDllama_InferenceDoneCallback = procedure(const ASender: Pointer); cdecl;

(**
 * Get version information
 *
 * \param AName          - name
 * \param ACodeName      - codename
 * \param AMajorVersion  - major version
 * \param AMinorVersion  - minor version
 * \param APatchVersion  - patch version
 * \param AVersion       - version (i.e "v0.1.0")
 * \param AProject       - project
 **)
procedure Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion,
  APatchVersion, AVersion, AProject: PPAnsiChar); cdecl; external DLLAMA_DLL;

(**
 * Initalize configuration.
 *
 * \param AModelPath          - path to model file
 * \param ANumGPULayers       - number of GPU layer (-1 for max, 0 for CPU only)
 * \param ADisplayInfo        - display information to console
 * \param ACancelInferenceKey - key that will cancel inference (ie ESC(27))

 **)
procedure Dllama_InitConfig(const AModelPath: PAnsiChar;
  const ANumGPULayers: Integer; const ADisplayInfo: Boolean;
  const ACancelInferenceKey: Byte); cdecl; external DLLAMA_DLL;

(**
 * Get configuration
 *
 * \param AModelPath          - return path to model file
 * \param ANumGPULayers       - return number of GPU layer (-1 for max, 0 for
 *                               CPU only)
 * \param ADisplayInfo        - return display information to console
 * \param ACancelInferenceKey - return key that will cancel inference
 *                              (ie ESC(27))
 **)
procedure Dllama_GetConfig(AModelPath: PPAnsiChar; ANumGPULayers: PInteger;
  ADisplayInfo: PBoolean; ACancelInferenceKey: PByte); cdecl;
  external DLLAMA_DLL;

(**
 * Save configuration.
 *
 * \param AFilename - configuration filename
 *
 * \returns TRUE on success FALSE on failure
 *
 * \sa Dllama_LoadConfig
 **)
function  Dllama_SaveConfig(const AFilename: PAnsiChar): Boolean; cdecl;
  external DLLAMA_DLL;

(**
 * Load configuration.
 *
 * \param AFilename - configuration filename
 *
 * \returns
 **)
function  Dllama_LoadConfig(const AFilename: PAnsiChar): Boolean; cdecl;
  external DLLAMA_DLL;

(**
 * Get error message
 *
 * \returns - error message
 **)
function  Dllama_GetError(): PAnsiChar; cdecl; external DLLAMA_DLL;

(**
 * Set error message
 *
 * \param AText - error message
 **)
procedure Dllama_SetError(const AText: PAnsiChar); cdecl; external DLLAMA_DLL;

(**
 * Clear error message
 **)
procedure Dllama_ClearError(); cdecl; external DLLAMA_DLL;

(**
 * Get LLM load progress callback.
 *
 * \returns load model progress callback
 **)
function  Dllama_GetLoadModelProgressCallback():
  TDllama_LoadModelProgressCallback; cdecl; external DLLAMA_DLL;

(**
 * Set LLM load model progress callback
 *
 * \param ASender  - sender
 * \param AHandler - load model progress callback
 *
 * \returns
 **)
procedure Dllama_SetLoadModelProgressCallback(const ASender: Pointer;
  const AHandler: TDllama_LoadModelProgressCallback); cdecl;
  external DLLAMA_DLL;

(**
 * Get LLM load model callback.
 *
 * \param AHandler - load model callback
 * \returns
 **)
function  Dllama_GetLoadModelCallback(): TDllama_LoadModelCallback; cdecl;
  external DLLAMA_DLL;

(**
 * Set LLM load model callback.
 *
 * \param ASender  - sender
 * \param AHandler - load model callback
 **)
procedure Dllama_SetLoadModelCallback(const ASender: Pointer;
  const AHandler: TDllama_LoadModelCallback); cdecl; external DLLAMA_DLL;

(**
 *  Add a LLM model definition.
 *
 * \param AFilename               - filename
 * \param AName                   - reference name
 * \param AMaxContext             - max context
 * \param AChatMessageTemplate    - chat template
 * \param AChatMessageTemplateEnd - chat template ending
 * \param AStopSequences          - stop sequences
 * \param AStopSequencesCount     - stop sequence count

 * \returns TRUE on success, FALSE on failuar
 **)
function  Dllama_AddModel(const AFilename, AName: PAnsiChar;
  const AMaxContext: UInt64; const AChatMessageTemplate,
  AChatMessageTemplateEnd: PAnsiChar; const AStopSequences: PPAnsiChar;
  const AStopSequencesCount: Cardinal): Boolean; cdecl; external DLLAMA_DLL;

(**
 * Clear LLM model definitions.
 **)
procedure Dllama_ClearModels(); cdecl; external DLLAMA_DLL;

(**
 * Get LLM model definition count.
 *
 * \returns number model definitions
 **)
function  Dllama_GetModelCount(): Cardinal; cdecl; external DLLAMA_DLL;

(**
 * Save LLM model database.
 *
 * \param AFilename - filename of model database
 **)
function  Dllama_SaveModelDb(const AFilename: PAnsiChar): Boolean; cdecl;
  external DLLAMA_DLL;

(**
 * Load LLM model database.
 *
 * \param AFilename - filename of model database
 **)
function  Dllama_LoadModelDb(const AFilename: PAnsiChar): Boolean; cdecl;
  external DLLAMA_DLL;

(**
 * Load LLM model from disk.
 *
 * \param AName - llm model filename
 *
 * \return TRUE on success, FALSE on failure.
 *
 * \sa Dllama_SaveModelDb
 * \sa Dllama_GetError
 *
 **)
function  Dllama_LoadModel(const AName: PAnsiChar): Boolean; cdecl;
  external DLLAMA_DLL;

(**
 * Check if model is loaded into memory.
 *
 * \return TRUE if loaded, FALSE if  not loaded
 *
 **)
function Dllama_IsModelLoaded(): Boolean;  cdecl;external DLLAMA_DLL;

(**
 * Unload current LLM model from memory.
 **)
procedure Dllama_UnloadModel(); cdecl; external DLLAMA_DLL;

(**
 * Clear all chat messages.
 **)
procedure Dllama_ClearMessages(); cdecl; external DLLAMA_DLL;

(**
 * Add a chat message.
 *
 * \param ARole    - chat message role
 * \param AContent - chat message role content
 **)
procedure Dllama_AddMessage(const ARole, AContent: PAnsiChar); cdecl;
  external DLLAMA_DLL;

(**
 * Get last user chat message content added.
 *
 * \return last user chage message content
 **)
function  Dllama_GetLastUserMessage(): PAnsiChar; cdecl; external DLLAMA_DLL;

(**
 * Get LLM inference callback.
 *
 * \returns LLM inference callback.
 **)
function  Dllama_GetInferenceCallback(): TDllama_InferenceCallback; cdecl;
  external DLLAMA_DLL;

(**
 * Set LLM inference callback.
 *
 * \param ASender  - sender
 * \param AHandler - LLM inference callback
 **)
procedure Dllama_SetInferenceCallback(const ASender: Pointer;
  const AHandler: TDllama_InferenceCallback); cdecl; external DLLAMA_DLL;

(**
 * Get LLM inference done callback.
 *
 * \returns LLM inference callback
 **)
function  Dllama_GetInferenceDoneCallback(): TDllama_InferenceDoneCallback;
  cdecl; external DLLAMA_DLL;

(**
 * Set LLM inference done callback.
 *
 * \param ASender  - sender
 * \param AHandler - LLM inference done callback.
 **)
procedure Dllama_SetInferenceDoneCallback(const ASender: Pointer;
  const AHandler: TDllama_InferenceDoneCallback); cdecl; external DLLAMA_DLL;

(**
 * Run inference on currenly loaded LLM.
 *
 * \param AModelName   - model reference name
 * \param AResponse    - pointer to a string to hold response
 * \param AMaxTokens   - max token to allow
 * \param ATemperature - control reponse (0-1, 0 = precise, 0.5 = balanced,
 *                       1 = creative)
 * \param ASeed        - seed (set greater than zero for deterministic
 *                       response)
 *
 * \returns TRUE on success, FALSE on failure.
 **)
function  Dllama_Inference(const AModelName: PAnsiChar; AResponse: PPAnsiChar;
  const AMaxTokens: UInt32; const ATemperature: Single;
  const ASeed: UInt32): Boolean; cdecl; external DLLAMA_DLL;

(**
 * Get usage about last LLM inference.
 *
 * \param ATokenInputSpeed  - returns token input speed (tokens/sec)
 * \param ATokenOutputSpeed - returns token output seepd (tokens/sec)
 * \param AInputTokens      - returns number of input tokens
 * \param AOutputTokens     - returns number of output tokens
 * \param ATotalTokens      - returnes total number of tokens
 **)
procedure Dllama_GetInferenceUsage(ATokenInputSpeed,
  ATokenOutputSpeed: PSingle; AInputTokens, AOutputTokens,
  ATotalTokens: PInteger); cdecl; external DLLAMA_DLL;

(**
 * Run inference on currenly loaded LLM in simple way.
 *
 * \param AModelPath          - path to model files
 * \param AModelsDb           - model database filename
 * \param AModelName          - model reference name
 * \param AUseGPU             - TRUE to use GPU, FALSE to use CPU
 * \param AMaxTokens          - max tokens for inference
 * \param ACancelInferenceKey - key to break out of inference
 * \param AQuestion           - question to ask LLM
 * \returns response from LLM
 **)
function  Dllama_Simple_Inference(const AModelPath, AModelsDb,
  AModelName: PAnsiChar; const AUseGPU: Boolean; const AMaxTokens: UInt32;
  const ACancelInferenceKey: Byte; const AQuestion: PAnsiChar): PAnsiChar;
  cdecl; external DLLAMA_DLL;

(**
 * Check if LLM inference is in progress.
 *
 * \returns TRUE of inference is active, FALSE if not.
 **)
function  Dllama_IsInferenceActive(): Boolean; cdecl; external DLLAMA_DLL;

(**
 * Get size of console window
 *
 * \param AWidth  - returns the width of console window
 * \param AHeight - return height of console window
 **)
procedure Dllama_Console_GetSize(AWidth: PInteger; AHeight: PInteger); cdecl;
  external DLLAMA_DLL;

(**
 * Clear the console window.
 **)
procedure Dllama_Console_Clear(); cdecl; external DLLAMA_DLL;

(**
 * Clear current line of console window.
 *
 * \param AColor - color to clear current console line to
 **)
procedure Dllama_Console_ClearLine(AColor: Word); cdecl; external DLLAMA_DLL;

(**
 * Set title of console window.
 *
 * \param ATitle - string to set console title
 **)
procedure Dllama_Console_SetTitle(const ATitle: PAnsiChar); cdecl;
  external DLLAMA_DLL;

(**
 * Display an optional message and wait in console window and wait for a
 * keypress.
 *
 * \param AForcePause - set TRUE to always pause, FALSE to skip pause if
 *                      running on commandline
 * \param AColor      - color to display message text in
 * \param AMsg        - message to display, if empty, display default message
 **)
procedure Dllama_Console_Pause(const AForcePause: Boolean; AColor: Word;
  const AMsg: PAnsiChar); cdecl; external DLLAMA_DLL;

(**
 * Print a message in console window.
 *
 * \param AText  - print text at current line in console
 * \param AColor - the color to print text in
 **)
procedure Dllama_Console_Print(const AText: PAnsiChar; const AColor: Word);
  cdecl; external DLLAMA_DLL;

(**
 * Print a message in console window with linefeed.
 *
 * \param AText  - print text at current line in console
 * \param AColor - the color to print text in
 **)
procedure Dllama_Console_PrintLn(const AText: PAnsiChar; const AColor: Word);
  cdecl; external DLLAMA_DLL;

(**
 * Set the right margin of console window when streaming tokens during LLM
 * inference.
 *
 * \param AMargin - margin value
 **)
procedure Dllama_TokenResponse_SetRightMargin(const AMargin: Integer); cdecl;
  external DLLAMA_DLL;

(**
 * Add a new token to token response buffer.
 *
 * \param AToken return a token response action
 **)
function  Dllama_TokenResponse_AddToken(const AToken: PAnsiChar): Integer;
  cdecl; external DLLAMA_DLL;

(**
 * The current word to print from token response buffer.
 *
 * \returns wrapped text to display when streaming
 **)
function  Dllama_TokenResponse_LastWord(): PAnsiChar; cdecl;
  external DLLAMA_DLL;

(**
 * Check if there are pending text in the token response buffer.
 *
 * \returns TRUE if there is more text to display, FALSE if not.
 **)
function  Dllama_TokenResponse_Finalize(): Boolean; cdecl; external DLLAMA_DLL;


implementation

{$IF CompilerVersion < 34.0} // Delphi 12 corresponds to version 34.0
uses
  System.Math;
{$IFEND}

initialization
begin
  {$IF CompilerVersion < 34.0} // Delphi 12 corresponds to version 34.0
  // disable floating point exceptions
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
  {$IFEND}

  ReportMemoryLeaksOnShutdown := True;
end;

finalization
begin
end;

end.
