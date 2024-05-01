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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

//---------------------------------------------------------------------------

#pragma hdrstop


#include "exports.h"

#include "Dllama.Export.hpp"
//---------------------------------------------------------------------------
#pragma package(smart_init)


// Info
DLLAMA_API void Dllama_GetVersionInfo(System::PPAnsiChar AName, System::PPAnsiChar ACodeName, System::PPAnsiChar AMajorVersion, System::PPAnsiChar AMinorVersion, System::PPAnsiChar APatchVersion, System::PPAnsiChar AVersion, System::PPAnsiChar AProject)
{
    Dllama::Export::Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject);
}


// Config
DLLAMA_API void Dllama_InitConfig(const char * AModelPath, const int ANumGPULayers, const bool ADisplayInfo, const System::Byte ACancelInferenceKey)
{
	Dllama::Export::Dllama_InitConfig(AModelPath, ANumGPULayers, ADisplayInfo, ACancelInferenceKey);
}

DLLAMA_API void Dllama_GetConfig(System::PPAnsiChar AModelPath, System::PInteger ANumGPULayers, System::PBoolean ADisplayInfo, System::PByte ACancelInferenceKey)
{
	Dllama::Export::Dllama_GetConfig(AModelPath, ANumGPULayers, ADisplayInfo, ACancelInferenceKey);
}

DLLAMA_API bool Dllama_SaveConfig(const char * AFilename)
{
	return Dllama::Export::Dllama_SaveConfig(AFilename);
}

DLLAMA_API bool Dllama_LoadConfig(const char * AFilename)
{
	return Dllama::Export::Dllama_LoadConfig(AFilename);
}


// Error
DLLAMA_API char* Dllama_GetError()
{
	return Dllama::Export::Dllama_GetError();
}

DLLAMA_API void Dllama_SetError(const char * AText)
{
	Dllama::Export::Dllama_SetError(AText);
}

DLLAMA_API void Dllama_ClearError()
{
	Dllama::Export::Dllama_ClearError();
}


// Model
DLLAMA_API Dllama::Core::TDllama::LoadModelProgressCallback Dllama_GetLoadModelProgressCallback()
{
	return Dllama::Export::Dllama_GetLoadModelProgressCallback();
}

DLLAMA_API void Dllama_SetLoadModelProgressCallback(const void * ASender, const Dllama::Core::TDllama::LoadModelProgressCallback AHandler)
{
	Dllama::Export::Dllama_SetLoadModelProgressCallback(ASender, AHandler);
}

DLLAMA_API Dllama::Core::TDllama::LoadModelCallback Dllama_GetLoadModelCallback()
{
	return Dllama::Export::Dllama_GetLoadModelCallback();
}

DLLAMA_API void Dllama_SetLoadModelCallback(const void * ASender, const Dllama::Core::TDllama::LoadModelCallback AHandler)
{
	Dllama::Export::Dllama_SetLoadModelCallback(ASender, AHandler);
}

DLLAMA_API bool Dllama_AddModel(const char * AFilename, const char * AName, const unsigned __int64 AMaxContext, const char * AChatMessageTemplate, const char * AChatMessageTemplateEnd, const System::PPAnsiChar AStopSequences, const unsigned AStopSequencesCount)
{
	return Dllama::Export::Dllama_AddModel(AFilename, AName, AMaxContext, AChatMessageTemplate, AChatMessageTemplateEnd, AStopSequences, AStopSequencesCount);
}

DLLAMA_API void Dllama_ClearModels()
{
	Dllama::Export::Dllama_ClearModels();
}

DLLAMA_API unsigned Dllama_GetModelCount()
{
	return Dllama::Export::Dllama_GetModelCount();
}

DLLAMA_API bool Dllama_SaveModelDb(const char * AFilename)
{
	return Dllama::Export::Dllama_SaveModelDb(AFilename);
}

DLLAMA_API bool Dllama_LoadModelDb(const char * AFilename)
{
	return Dllama::Export::Dllama_LoadModelDb(AFilename);
}

DLLAMA_API bool Dllama_LoadModel(const char * AName)
{
	return Dllama::Export::Dllama_LoadModel(AName);
}

DLLAMA_API bool Dllama_IsModelLoaded()
{
	return Dllama::Export::Dllama_IsModelLoaded();
}

DLLAMA_API void Dllama_UnloadModel()
{
	Dllama::Export::Dllama_UnloadModel();
}


// Messages
DLLAMA_API void Dllama_ClearMessages()
{
	Dllama::Export::Dllama_ClearMessages();
}

DLLAMA_API void Dllama_AddMessage(const char * ARole, const char * ACentent)
{
	Dllama::Export::Dllama_AddMessage(ARole, ACentent);
}

DLLAMA_API char* Dllama_GetLastUserMessage()
{
	return Dllama::Export::Dllama_GetLastUserMessage();
}

// Inference
DLLAMA_API Dllama::Core::TDllama::InferenceCallback Dllama_GetInferenceCallback()
{
	return Dllama::Export::Dllama_GetInferenceCallback();
}

DLLAMA_API void Dllama_SetInferenceCallback(const void * ASender, const Dllama::Core::TDllama::InferenceCallback AHandler)
{
	Dllama::Export::Dllama_SetInferenceCallback(ASender, AHandler);
}

DLLAMA_API Dllama::Core::TDllama::InferenceDoneCallback Dllama_GetInferenceDoneCallback()
{
	return Dllama::Export::Dllama_GetInferenceDoneCallback();
}

DLLAMA_API void Dllama_SetInferenceDoneCallback(const void * ASender, const Dllama::Core::TDllama::InferenceDoneCallback AHandler)
{
	Dllama::Export::Dllama_SetInferenceDoneCallback(ASender, AHandler);
}

DLLAMA_API bool Dllama_Inference(const char * AModelName, const System::UInt32 AMaxTokens, const float ATemperature, const System::UInt32 ASeed)
{
	return Dllama::Export::Dllama_Inference(AModelName, AMaxTokens, ATemperature, ASeed);
}

DLLAMA_API char* Dllama_GetInferenceResponse()
{
    return Dllama::Export::Dllama_GetInferenceResponse();
}

DLLAMA_API char * Dllama_Simple_Inference(const char * AModelPath, const char * AModelsDb, const char * AModelName, const bool AUseGPU, const System::UInt32 AMaxTokens, const System::Byte ACancelInferenceKey, const char * AQuestion)
{
    return Dllama::Export::Dllama_Simple_Inference(AModelPath, AModelsDb, AModelName, AUseGPU, AMaxTokens, ACancelInferenceKey, AQuestion);
}

DLLAMA_API bool Dllama_IsInferenceActive()
{
    return Dllama::Export::Dllama_IsInferenceActive();
}

DLLAMA_API void Dllama_GetInferenceUsage(System::PSingle ATokenInputSpeed, System::PSingle TokenOutputSpeed, System::PInteger AInputTokens, System::PInteger AOutputTokens, System::PInteger ATotalTokens)
{
	Dllama::Export::Dllama_GetInferenceUsage(ATokenInputSpeed, TokenOutputSpeed, AInputTokens, AOutputTokens, ATotalTokens);
}


// Console
DLLAMA_API void Dllama_Console_GetSize(System::PInteger AWidth, System::PInteger AHeight)
{
	Dllama::Export::Dllama_Console_GetSize(AWidth, AHeight);
}

DLLAMA_API void Dllama_Console_Clear()
{
	Dllama::Export::Dllama_Console_Clear();
}

DLLAMA_API void Dllama_Console_ClearLine(System::Word AColor)
{
	Dllama::Export::Dllama_Console_ClearLine(AColor);
}

DLLAMA_API void Dllama_Console_SetTitle(const char * ATitle)
{
	Dllama::Export::Dllama_Console_SetTitle(ATitle);
}

DLLAMA_API void Dllama_Console_Pause(const bool AForcePause, System::Word AColor, const char * aMsg)
{
	Dllama::Export::Dllama_Console_Pause(AForcePause, AColor, aMsg);
}

DLLAMA_API void Dllama_Console_Print(const char * AText, const System::Word AColor)
{
	Dllama::Export::Dllama_Console_Print(AText, AColor);
}

DLLAMA_API void Dllama_Console_PrintLn(const char * AText, const System::Word AColor)
{
	Dllama::Export::Dllama_Console_PrintLn(AText, AColor);
}


// TokenResponse
DLLAMA_API void Dllama_TokenResponse_SetRightMargin(const int AMargin)
{
    Dllama::Export::Dllama_TokenResponse_SetRightMargin(AMargin);
}

DLLAMA_API int  Dllama_TokenResponse_AddToken(const char * AToken)
{
	return Dllama::Export::Dllama_TokenResponse_AddToken(AToken);
}

DLLAMA_API char* Dllama_TokenResponse_LastWord()
{
	return Dllama::Export::Dllama_TokenResponse_LastWord();
}

DLLAMA_API bool  Dllama_TokenResponse_Finalize()
{
    return Dllama::Export::Dllama_TokenResponse_Finalize();
}

// UTF8
DLLAMA_API char* Dllama_UTF8Encode(const char * AText)
{
    return Dllama::Export::Dllama_UTF8Encode(AText);
}

DLLAMA_API char* Dllama_UTF8Decode(const char * AText)
{
    return Dllama::Export::Dllama_UTF8Decode(AText);
}

DLLAMA_API void Dllama_FreeStr(const char * AText)
{
    Dllama::Export::Dllama_FreeStr(AText);
}




