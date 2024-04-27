//---------------------------------------------------------------------------

#pragma hdrstop


#include "exports.h"

#include "Dllama.Export.hpp"
//---------------------------------------------------------------------------
#pragma package(smart_init)

#define DLLAMA_API extern "C" __declspec(dllexport)


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

DLLAMA_API void Dllama_AddMessage(const char * ARole, const char * AMessage)
{
	Dllama::Export::Dllama_AddMessage(ARole, AMessage);
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

DLLAMA_API bool Dllama_Inference(const char * AModelName, System::PPAnsiChar AResponse, const System::UInt32 AMaxTokens, const float ATemperature, const System::UInt32 ASeed)
{
	return Dllama::Export::Dllama_Inference(AModelName, AResponse, AMaxTokens, ATemperature, ASeed);
}

DLLAMA_API char * Dllama_Simple_Inference(const char * AModelPath, const char * AModelsDb, const char * AModelName, const bool AUseGPU, const System::UInt32 AMaxTokens, const char * AQuestion)
{
    return Dllama::Export::Dllama_Simple_Inference(AModelPath, AModelsDb, AModelName, AUseGPU, AMaxTokens, AQuestion);
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





