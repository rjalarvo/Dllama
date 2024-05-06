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

#include "Dllama.Core.hpp"
#include "exports.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)

DLLAMA_API void Dllama_GetVersionInfo(System::PPAnsiChar AName, System::PPAnsiChar ACodeName, System::PPAnsiChar AMajorVersion, System::PPAnsiChar AMinorVersion, System::PPAnsiChar APatchVersion, System::PPAnsiChar AVersion, System::PPAnsiChar AProject)
{
    Dllama::Core::Dllama_GetVersionInfo(AName, ACodeName, AMajorVersion, AMinorVersion, APatchVersion, AVersion, AProject);
}

DLLAMA_API bool __cdecl Dllama_CreateExampleConfig(const char * AConfigFilename)
{
    return Dllama::Core::Dllama_CreateExampleConfig(AConfigFilename);
}

DLLAMA_API bool __cdecl Dllama_Init(const char * AConfigFilename, const TDllama::PCallbacks ACallbacks)
{
	return Dllama::Core::Dllama_Init(AConfigFilename, ACallbacks);
}

DLLAMA_API void __cdecl Dllama_Quit()
{
     Dllama::Core::Dllama_Quit();
}

DLLAMA_API void __cdecl Dllama_ClearMessages()
{
    Dllama::Core::Dllama_ClearMessages();
}

DLLAMA_API void __cdecl Dllama_AddMessage(const char * ARole, const char * AContent)
{
    Dllama::Core::Dllama_AddMessage(ARole, AContent);
}

DLLAMA_API char * __cdecl Dllama_GetLastUserMessage()
{
	return Dllama::Core::Dllama_GetLastUserMessage();
}

DLLAMA_API bool __cdecl Dllama_Inference(const char * AModelName, const System::UInt32 AMaxTokens, System::PPAnsiChar AResponse, const TDllama::PUsage AUsage, const System::PPAnsiChar AError)
{
	return Dllama::Core::Dllama_Inference(AModelName, AMaxTokens, AResponse, AUsage, AError);
}

DLLAMA_API void __cdecl Dllama_ClearLine(System::Word AColor)
{
    Dllama::Core::Dllama_ClearLine(AColor);
}

DLLAMA_API void __cdecl Dllama_Print(const char * AText, const System::Word AColor)
{
    Dllama::Core::Dllama_Print(AText, AColor);
}

