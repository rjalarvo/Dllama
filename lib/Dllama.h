/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
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
|   \ | || | __ _  _ __   __ _ ?
| |) || || |/ _` || '  \ / _` |
|___/ |_||_|\__,_||_|_|_|\__,_|

  Local LLM Inference Library

Copyright © 2024-present tinyBigGAMES? LLC
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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifndef DLLAMA_H
#define DLLAMA_H

// check for supported platform
#ifndef _WIN64
#error "Unsupported platform"
#endif

// link in Dllama.lib
#pragma comment(lib,"Dllama.lib")

// includes
#include <stdbool.h>
#include <stdint.h>
#include <wchar.h>

// Dllama DLL
#define DLLAMA_DLL "Dllama.dll"

// Console linefeed & carriage return
#define LF   '\n'
#define CR   '\r'
#define CRLF "\n\r"

// Virtual Keys
#define VK_ESCAPE 27

// Console colors
#define BRIGHTYELLOW (4 | 2 | 8)
#define YELLOW       (4 | 2)
#define WHITE        (4 | 2 | 1)
#define BRIGHTWHITE  (4 | 2 | 1 | 8)
#define DARKGREEN    2
#define DARKGRAY     8
#define CYAN         (2 | 1)
#define MAGENTA      (4 | 1)
#define RED          4

// Temperature
#define TEMPERATURE_PERCISE  0.0
#define TEMPERATURE_BALANCED 0.5
#define TEMPERATURE_CREATIVE 1.0

// Message roles
#define ROLE_SYSTEM    "system"
#define ROLE_USER      "user"
#define ROLE_ASSISTANT "assistant"
#define ROLE_TOOL      "tool"

// Token Response
#define TOKENRESPONSE_WAIT    0
#define TOKENRESPONSE_APPEND  1
#define TOKENRESPONSE_NEWLINE 2

#define DLLAMA_API __declspec(dllimport)

#ifdef __cplusplus
extern "C" {
#endif

// Callbacks
typedef bool (*LoadModelProgressCallback)(const void * ASender,
  const char * AModelName, const float AProgress);
typedef void (*LoadModelCallback)(const void * ASender, const bool ASuccess);
typedef void (*InferenceCallback)(const void * ASender, const char * AToken);
typedef void (*InferenceDoneCallback)(const void * ASender);

/**
 * Get version information
 *
 * \param AName          - name
 * \param ACodeName      - codename
 * \param AMajorVersion  - major version
 * \param AMinorVersion  - minor version
 * \param APatchVersion  - patch version
 * \param AVersion       - version (i.e "v0.1.0")
 * \param AProject       - project
 **/
DLLAMA_API void Dllama_GetVersionInfo(const char** AName,
  const char** ACodeName, const char** AMajorVersion,
  const char** AMinorVersion, const char** APatchVersion,
  const char** AVersion, const char** AProject);

/**
 * Initalize configuration.
 *
 * \param AModelPath          - path to model file
 * \param ANumGPULayers       - number of GPU layer (-1 for max, 0 for CPU only)
 * \param ADisplayInfo        - display information to console
 * \param ACancelInferenceKey - key that will cancel inference (ie ESC(27))
 **/
DLLAMA_API void Dllama_InitConfig(const char * AModelPath,
  const int ANumGPULayers, const bool ADisplayInfo,
  const unsigned char ACancelInferenceKey);

/**
 * Get configuration
 *
 * \param AModelPath          - return path to model file
 * \param ANumGPULayers       - return number of GPU layer (-1 for max, 0 for
 *                               CPU only)
 * \param ADisplayInfo        - return display information to console
 * \param ACancelInferenceKey - return key that will cancel inference
 *                              (ie ESC(27))
 **/
DLLAMA_API void Dllama_GetConfig(char** AModelPath, int* ANumGPULayers,
  bool* ADisplayInfo, unsigned char* ACancelInferenceKey);

/**
 * Save configuration.
 *
 * \param AFilename - configuration filename
 *
 * \returns TRUE on success FALSE on failure
 *
 * \sa Dllama_LoadConfig
 **/
DLLAMA_API bool Dllama_SaveConfig(const char * AFilename);

/**
 * Load configuration.
 *
 * \param AFilename - configuration filename
 *
 * \returns TRUE if succesful, FALSE if failed.
 **/
DLLAMA_API bool Dllama_LoadConfig(const char * AFilename);

/**
 * Get error message
 *
 * \returns - error message
 **/
DLLAMA_API char* Dllama_GetError();

/**
 * Set error message
 *
 * \param AText - error message
 **/
DLLAMA_API void Dllama_SetError(const char * AText);

/**
 * Clear error message
 **/
DLLAMA_API void Dllama_ClearError();

/**
 * Get LLM load progress callback.
 *
 * \returns load model progress callback
 **/
DLLAMA_API LoadModelProgressCallback Dllama_GetLoadModelProgressCallback();

/**
 * Set LLM load model progress callback
 *
 * \param ASender  - sender
 * \param AHandler - load model progress callback
 *
 * \returns
 **/
DLLAMA_API void Dllama_SetLoadModelProgressCallback(const void * ASender,
  LoadModelProgressCallback AHandler);

/**
 * Get LLM load model callback.
 *
 * \param AHandler - load model callback
 * \returns
 **/
DLLAMA_API LoadModelCallback Dllama_GetLoadModelCallback();

/**
 * Set LLM load model callback.
 *
 * \param ASender  - sender
 * \param AHandler - load model callback
 **/
DLLAMA_API void Dllama_SetLoadModelCallback(const void * ASender,
  LoadModelCallback AHandler);

/**
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
 **/
DLLAMA_API bool Dllama_AddModel(const char * AFilename, const char * AName,
  const uint64_t AMaxContext, const char * AChatMessageTemplate,
  const char * AChatMessageTemplateEnd, const char** AStopSequences,
  const unsigned AStopSequencesCount);

/**
 * Clear LLM model definitions.
 **/
DLLAMA_API void Dllama_ClearModels();

/**
 * Get LLM model definition count.
 *
 * \returns number model definitions
 **/
DLLAMA_API unsigned Dllama_GetModelCount();

/**
 * Save LLM model database.
 *
 * \param AFilename - filename of model database
 **/
DLLAMA_API bool Dllama_SaveModelDb(const char * AFilename);

/**
 * Load LLM model database.
 *
 * \param AFilename - filename of model database
 **/
DLLAMA_API bool Dllama_LoadModelDb(const char * AFilename);

/**
 * Load LLM model from disk.
 *
 * \param AName - llm model filename
 *
 * \return TRUE on success, FALSE on failure.
 *
 * \sa Dllama_SaveModelDb
 * \sa Dllama_GetError
  **/
DLLAMA_API bool Dllama_LoadModel(const char * AName);

/**
 * Check if model is loaded into memory.
 *
 * \return TRUE if loaded, FALSE if  not loaded
 *
  **/
DLLAMA_API bool Dllama_IsModelLoaded();

/**
 * Unload current LLM model from memory.
 **/
DLLAMA_API void Dllama_UnloadModel();

/**
 * Clear all chat messages.
 **/
DLLAMA_API void Dllama_ClearMessages();

/**
 * Add a chat message.
 *
 * \param ARole    - chat message role
 * \param AContent - chat message role content
 **/
DLLAMA_API void Dllama_AddMessage(const char * ARole, const char * ACentent);

/**
 * Get last user chat message content added.
 *
 * \return last user chage message content
 **/
DLLAMA_API char* Dllama_GetLastUserMessage();

/**
 * Get LLM inference callback.
 *
 * \returns LLM inference callback.
 **/
DLLAMA_API InferenceCallback Dllama_GetInferenceCallback();

/**
 * Set LLM inference callback.
 *
 * \param ASender  - sender
 * \param AHandler - LLM inference callback
 **/
DLLAMA_API void Dllama_SetInferenceCallback(const void * ASender,
  InferenceCallback AHandler);

/**
 * Get LLM inference done callback.
 *
 * \returns LLM inference callback
 **/
DLLAMA_API InferenceDoneCallback Dllama_GetInferenceDoneCallback();

/**
 * Set LLM inference done callback.
 *
 * \param ASender  - sender
 * \param AHandler - LLM inference done callback.
 **/
DLLAMA_API void Dllama_SetInferenceDoneCallback(const void * ASender,
  InferenceDoneCallback AHandler);

/**
 * Run inference on currenly loaded LLM.
 *
 * \param AModelName   - model reference name
 * \param AMaxTokens   - max token to allow
 * \param ATemperature - control reponse (0-1, 0 = precise, 0.5 = balanced,
 *                       1 = creative)
 * \param ASeed        - seed (set greater than zero for deterministic
 *                       response)
 *
 * \returns TRUE on success, FALSE on failure.
 **/
DLLAMA_API bool Dllama_Inference(const char * AModelName,
  const uint32_t AMaxTokens, const float ATemperature, const uint32_t ASeed);

/**
 * Get response of last inference on currenly loaded LLM.
 *
 * \returns UTF8 encoded string.
 **/
DLLAMA_API char* Dllama_GetInferenceResponse();


/**
 * Get usage about last LLM inference.
 *
 * \param ATokenInputSpeed  - returns token input speed (tokens/sec)
 * \param ATokenOutputSpeed - returns token output seepd (tokens/sec)
 * \param AInputTokens      - returns number of input tokens
 * \param AOutputTokens     - returns number of output tokens
 * \param ATotalTokens      - returnes total number of tokens
 **/
DLLAMA_API void Dllama_GetInferenceUsage(float* ATokenInputSpeed,
  float* ATokenOutputSpeed, int* AInputTokens, int* AOutputTokens,
  int* ATotalTokens);

/**
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
 **/
DLLAMA_API char * Dllama_Simple_Inference(const char * AModelPath,
  const char * AModelsDb, const char * AModelName, const bool AUseGPU,
  const uint32_t AMaxTokens, const unsigned char ACancelInferenceKey,
  const char * AQuestion);

/**
 * Check if LLM inference is in progress.
 *
 * \returns TRUE of inference is active, FALSE if not.
 **/
DLLAMA_API bool Dllama_IsInferenceActive();

/**
 * Get size of console window
 *
 * \param AWidth  - returns the width of console window
 * \param AHeight - return height of console window
 **/
DLLAMA_API void Dllama_Console_GetSize(int* AWidth, int* AHeight);

/**
 * Clear the console window.
 **/
DLLAMA_API void Dllama_Console_Clear();

/**
 * Clear current line of console window.
 *
 * \param AColor - color to clear current console line to
 **/
DLLAMA_API void Dllama_Console_ClearLine(unsigned short AColor);

/**
 * Set title of console window.
 *
 * \param ATitle - string to set console title
 **/
DLLAMA_API void Dllama_Console_SetTitle(const char * ATitle);

/**
 * Display an optional message and wait in console window and wait for a
 * keypress.
 *
 * \param AForcePause - set TRUE to always pause, FALSE to skip pause if
 *                      running on commandline
 * \param AColor      - color to display message text in
 * \param AMsg        - message to display, if empty, display default message
 **/
DLLAMA_API void Dllama_Console_Pause(bool AForcePause, unsigned short AColor,
  const char * aMsg);

/**
 * Print a message in console window.
 *
 * \param AText  - print text at current line in console
 * \param AColor - the color to print text in
 **/
DLLAMA_API void Dllama_Console_Print(const char * AText, unsigned short AColor);

/**
 * Print a message in console window with linefeed.
 *
 * \param AText  - print text at current line in console
 * \param AColor - the color to print text in
 **/
DLLAMA_API void Dllama_Console_PrintLn(const char * AText, unsigned short AColor);

/**
 * Set the right margin of console window when streaming tokens during LLM
 * inference.
 *
 * \param AMargin - margin value
 **/
DLLAMA_API void Dllama_TokenResponse_SetRightMargin(int AMargin);

/**
 * Add a new token to token response buffer.
 *
 * \param AToken return a token response action
 **/
DLLAMA_API int  Dllama_TokenResponse_AddToken(const char * AToken);

/**
 * The current word to print from token response buffer.
 *
 * \returns wrapped text to display when streaming
 **/
DLLAMA_API char* Dllama_TokenResponse_LastWord();

/**
 * Check if there are pending text in the token response buffer.
 *
 * \returns TRUE if there is more text to display, FALSE if not.
 **/
DLLAMA_API bool  Dllama_TokenResponse_Finalize();

// UTF8
DLLAMA_API char* Dllama_UTF8Encode(const char * AText);
DLLAMA_API char* Dllama_UTF8Decode(const char * AText);
DLLAMA_API void Dllama_FreeStr(const char * AText);


#ifdef __cplusplus
}
#endif //__cplusplus

#endif //DLLAMA_H
