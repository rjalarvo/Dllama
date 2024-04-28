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

#include <iostream>
#include <streambuf>
#include <string>

extern "C" {
#include "cerr_redirector.h"
}


void* userData = nullptr;

class CallbackStreambuf : public std::streambuf {
public:
    CallbackStreambuf(cerr_callback callback) : callbackFunction(callback) {}

protected:
    virtual int sync() override {
        if (callbackFunction && !buffer.empty()) {
            callbackFunction(buffer.c_str(), userData);
            buffer.clear();
        }
        return 0;
    }

    virtual std::streamsize xsputn(const char_type* s, std::streamsize count) override {
        buffer.append(s, count);
        return count;
    }

    virtual int_type overflow(int_type c = traits_type::eof()) override {
        if (!traits_type::eq_int_type(c, traits_type::eof())) {
            char_type ch = traits_type::to_char_type(c);
            buffer += ch;
        }
        return c;
    }

private:
    std::string buffer;
    cerr_callback callbackFunction;
};

std::streambuf* originalCerrBuf = nullptr;
CallbackStreambuf* callbackStreambuf = nullptr;

void redirect_cerr_to_callback(cerr_callback callback, void* user_data) {
    if (!callbackStreambuf) {
        callbackStreambuf = new CallbackStreambuf(callback);
        originalCerrBuf = std::cerr.rdbuf(); 
        std::cerr.rdbuf(callbackStreambuf); 
        userData = user_data;
    }
}

void restore_cerr() {
    if (originalCerrBuf != nullptr) {
        std::cerr.rdbuf(originalCerrBuf); 
        delete callbackStreambuf;
        callbackStreambuf = nullptr;
        originalCerrBuf = nullptr;
    }
}
