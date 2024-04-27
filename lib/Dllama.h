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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifndef _WIN64
#error "Unsupported platform"
#endif

#include <stdbool.h>
#include <stdint.h>

#define DLLAMA_API __declspec(dllexport)

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

// Callbacks
typedef bool (*LoadModelProgressCallback)(const void * ASender, const char * AModelName, const float AProgress);
typedef void (*LoadModelCallback)(const void * ASender, const bool ASuccess);
typedef void (*InferenceCallback)(const void * ASender, const char * AToken);
typedef void (*InferenceDoneCallback)(const void * ASender);

// Info
DLLAMA_API void Dllama_GetVersionInfo(const char** AName, const char** ACodeName, const char** AMajorVersion, const char** AMinorVersion, const char** APatchVersion, const char** AVersion, const char** AProject);

// Config
DLLAMA_API void Dllama_InitConfig(const char * AModelPath, const int ANumGPULayers, const bool ADisplayInfo, const unsigned char ACancelInferenceKey);
DLLAMA_API void Dllama_GetConfig(char** AModelPath, int* ANumGPULayers, bool* ADisplayInfo, unsigned char* ACancelInferenceKey);
DLLAMA_API bool Dllama_SaveConfig(const char * AFilename);
DLLAMA_API bool Dllama_LoadConfig(const char * AFilename);

// Error
DLLAMA_API char* Dllama_GetError();
DLLAMA_API void Dllama_SetError(const char * AText);
DLLAMA_API void Dllama_ClearError();

// Model
DLLAMA_API LoadModelProgressCallback Dllama_GetLoadModelProgressCallback();
DLLAMA_API void Dllama_SetLoadModelProgressCallback(const void * ASender, LoadModelProgressCallback AHandler);
DLLAMA_API LoadModelCallback Dllama_GetLoadModelCallback();
DLLAMA_API void Dllama_SetLoadModelCallback(const void * ASender, LoadModelCallback AHandler);
DLLAMA_API bool Dllama_AddModel(const char * AFilename, const char * AName, const uint64_t AMaxContext, const char * AChatMessageTemplate, const char * AChatMessageTemplateEnd, const char** AStopSequences, const unsigned AStopSequencesCount);
DLLAMA_API void Dllama_ClearModels();
DLLAMA_API unsigned Dllama_GetModelCount();
DLLAMA_API bool Dllama_SaveModelDb(const char * AFilename);
DLLAMA_API bool Dllama_LoadModelDb(const char * AFilename);
DLLAMA_API bool Dllama_LoadModel(const char * AName);
DLLAMA_API bool Dllama_IsModelLoaded();
DLLAMA_API void Dllama_UnloadModel();

// Messages
DLLAMA_API void Dllama_ClearMessages();
DLLAMA_API void Dllama_AddMessage(const char * ARole, const char * AMessage);
DLLAMA_API char* Dllama_GetLastUserMessage();

// Inference
DLLAMA_API InferenceCallback Dllama_GetInferenceCallback();
DLLAMA_API void Dllama_SetInferenceCallback(const void * ASender, InferenceCallback AHandler);
DLLAMA_API InferenceDoneCallback Dllama_GetInferenceDoneCallback();
DLLAMA_API void Dllama_SetInferenceDoneCallback(const void * ASender, InferenceDoneCallback AHandler);
DLLAMA_API bool Dllama_Inference(const char * AModelName, char** AResponse, const uint32_t AMaxTokens, const float ATemperature, const uint32_t ASeed);
DLLAMA_API void Dllama_GetInferenceUsage(float* ATokenInputSpeed, float* ATokenOutputSpeed, int* AInputTokens, int* AOutputTokens, int* ATotalTokens);
DLLAMA_API char * Dllama_Simple_Inference(const char * AModelPath, const char * AModelsDb, const char * AModelName, const bool AUseGPU, const uint32_t AMaxTokens, const char * AQuestion);
DLLAMA_API bool Dllama_IsInferenceActive();

// Console
DLLAMA_API void Dllama_Console_GetSize(int* AWidth, int* AHeight);
DLLAMA_API void Dllama_Console_Clear();
DLLAMA_API void Dllama_Console_ClearLine(unsigned short AColor);
DLLAMA_API void Dllama_Console_SetTitle(const char * ATitle);
DLLAMA_API void Dllama_Console_Pause(bool AForcePause, unsigned short AColor, const char * aMsg);
DLLAMA_API void Dllama_Console_Print(const char * AText, unsigned short AColor);
DLLAMA_API void Dllama_Console_PrintLn(const char * AText, unsigned short AColor);

// TokenResponse
DLLAMA_API void Dllama_TokenResponse_SetRightMargin(int AMargin);
DLLAMA_API int  Dllama_TokenResponse_AddToken(const char * AToken);
DLLAMA_API char* Dllama_TokenResponse_LastWord();
DLLAMA_API bool  Dllama_TokenResponse_Finalize();

