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
  Dllama.Deps,
  Dllama.Deps.Ext,
  Dllama.Utils,
  Dllama;

const
  // update to your model path
  CModelPath = 'C:\LLM\gguf';

type

  { TTBaseTest }
  TTBaseTest = class(TDllama)
  public
    procedure OnCError(const AText: string); override;
    procedure OnLog(const ALevel: Integer; const AText: string); override;
  end;

  { TTest01 }
  TTest01 = class(TTBaseTest)
  public
    procedure Run(); override;
  end;

  { TTest02 }
  TTest02 = class(TTBaseTest)
  public
    procedure Run(); override;
  end;

  { TTest03 }
  TTest03 = class(TTBaseTest)
  public
    procedure Run(); override;
  end;

procedure RunTests();

implementation

{ TTBaseTest }
procedure TTBaseTest.OnCError(const AText: string);
begin
  // do not display llama cerr info
end;

procedure TTBaseTest.OnLog(const ALevel: Integer; const AText: string);
begin
  // do not display llama log info
end;

{ TTest01 }
procedure TTest01.Run();
var
  LResponse: string;
  LUsage: TDllama.Usage;
begin
  // clear console
  Console.Clear();

  // display title
  Console.PrintLn('Dllama - Query Example'+Console.CRLF, Console.MAGENTA);

  // set model path
  SetModelPath(CModelPath);

  // add models
  AddModel('dolphin-2.8-mistral-7b-v02.Q6_K.gguf', 'dolphin-mistral', 32768, '<|im_start|>%s\n %s<|im_end|>', '', []);
  AddModel('Hermes-2-Pro-Mistral-7B.Q6_K.gguf', 'hermes-mistral', 8192, '<|im_start|>%s\n %s\n<|im_end|>', '\n <|im_start|>assistant\n', ['<dummy00022>', '<dummy00012>', '<dummy00015>']);
  AddModel('WizardLM-2-7B.Q6_K.gguf', 'wizardlm-2', 32768, '<|im_start|>%s\n %s<|im_end|>', 'ASSISTANT:', []);

  // save models to database
  SaveModelDb();

  // add messages
  AddSystemMessage('You Dllama, a helpful AI assistant.');
  AddUserMessage('How to make KNO3?');

  // display user message
  Console.Print(GetUserMessage()+Console.CRLF, Console.DARKGREEN);

  // do inference - use "dolphin-mistral" model
  if Inference('dolphin-mistral', LResponse, 1024, TDllama.TEMPREATURE_BALANCED, 1234, @LUsage) then
    begin
      // display usage
      Console.PrintLn();
      Console.PrintLn();
      Console.PrintLn('Tokens :: Input: %d, Output: %d, Total: %d', [LUsage.InputTokens, LUsage.OutputTokens, LUsage.TotalTokens], Console.BRIGHTYELLOW);
      Console.PrintLn('Speed  :: Input: %3.2f t/s, Output: %3.2f t/s', [LUsage.TokenInputSpeed, LUsage.TokenOutputSpeed], Console.BRIGHTYELLOW);
    end
  else
    begin
      // display errors
      Console.Print(Console.CRLF+'Error: %s', [GetError()], Console.RED)
    end;
end;


{ TTest02 }
procedure TTest02.Run();
const
  CSystem =
  '''
  You are a function calling AI model. You are provided with function signatures within <tools></tools> XML tags. You may call one or more functions to assist with the user query. Don't make assumptions about what values to plug into functions. Here are the available tools: <tools> {'type': 'function', 'function': {'name': 'get_stock_fundamentals', 'description': 'get_stock_fundamentals(symbol: str) -> dict - Get fundamental data for a given stock symbol using yfinance API.\n\n    Args:\n    symbol (str): The stock symbol.\n\n    Returns:\n    dict: A dictionary containing fundamental data.', 'parameters': {'type': 'object', 'properties': {'symbol': {'type': 'string'}}, 'required': ['symbol']}}}  </tools> Use the following pydantic model json schema for each tool call you will make: {'title': 'FunctionCall', 'type': 'object', 'properties': {'arguments': {'title': 'Arguments', 'type': 'object'}, 'name': {"title": "Name", "type": "string"}}, "required": ["arguments", "name"]} For each function call return a json object with function name and arguments within <tool_call></tool_call> XML tags as follows:
  <tool_call>
  {"arguments": <args-dict>, "name": <function-name>}
  </tool_call>
  ''';

  CUser =
  '''
  Fetch the stock fundamentals data for Tesla (TSLA)
  ''';

  CToolResponse =
  '''
  <tool_response>
  {"name": "get_stock_fundamentals", "content": {"symbol": "TSLA", "company_name": "Tesla, Inc.", "sector": "Consumer Cyclical", "industry": "Auto Manufacturers", "market_cap": 611384164352, "pe_ratio": 49.604652, "pb_ratio": 9.762013, "dividend_yield": None, "eps": 4.3, "beta": 2.427, "52_week_high": 299.29, "52_week_low": 152.37}}
  </tool_response>
  ''';
var
  LResponse: string;
  LUsage: TDllama.Usage;
begin
  // clear console
  Console.Clear();

  // display title
  Console.PrintLn('Dllama - Function Calling Example'+Console.CRLF, Console.MAGENTA);

  // load model info from database
  LoadModelDb();

  // add messages
  AddSystemMessage(CSystem);
  AddUserMessage(CUser);
  AddCustomRoleMessage('tool', CToolResponse);

  // display user message
  Console.Print(GetUserMessage()+Console.CRLF, Console.DARKGREEN);

  // do inference - use "hermes-mistral" model for function calling support
  if Inference('hermes-mistral', LResponse, 1024, TDllama.TEMPREATURE_BALANCED, 4567, @LUsage) then
    begin
      // display usage
      Console.PrintLn();
      Console.PrintLn();
      Console.PrintLn('Tokens :: Input: %d, Output: %d, Total: %d', [LUsage.InputTokens, LUsage.OutputTokens, LUsage.TotalTokens], Console.BRIGHTYELLOW);
      Console.PrintLn('Speed  :: Input: %3.2f t/s, Output: %3.2f t/s', [LUsage.TokenInputSpeed, LUsage.TokenOutputSpeed], Console.BRIGHTYELLOW);
    end
  else
    begin
      // display errors
      Console.Print(Console.CRLF+'Error: %s', [GetError()], Console.RED)
    end;
end;


{ TTest03 }
procedure TTest03.Run();
var
  LResponse: string;
  LUsage: TDllama.Usage;
begin
  // clear console
  Console.Clear();

  // display title
  Console.PrintLn('Dllama - Language Translation Example'+Console.CRLF, Console.MAGENTA);

  // load model info from database
  LoadModelDb();

  // add messages
  AddSystemMessage('You are an expert in language translation.');
  AddUserMessage('Convert to Spanish and Chinese: Hello, how are you?');

  // display user message
  Console.Print(GetUserMessage()+Console.CRLF, Console.DARKGREEN);

  // do inference - use "wizardlm-2" model
  if Inference('wizardlm-2', LResponse, 1024, TDllama.TEMPREATURE_BALANCED, 891011, @LUsage) then
    begin
      // display usage
      Console.PrintLn();
      Console.PrintLn();
      Console.PrintLn('Tokens :: Input: %d, Output: %d, Total: %d', [LUsage.InputTokens, LUsage.OutputTokens, LUsage.TotalTokens], Console.BRIGHTYELLOW);
      Console.PrintLn('Speed  :: Input: %3.2f t/s, Output: %3.2f t/s', [LUsage.TokenInputSpeed, LUsage.TokenOutputSpeed], Console.BRIGHTYELLOW);
    end
  else
    begin
      // display errors
      Console.Print(Console.CRLF+'Error: %s', [GetError()], Console.RED)
    end;
end;

procedure RunTests();
begin
  //RunObject(TTest01);
  //RunObject(TTest02);
  RunObject(TTest03);
  Console.Pause();
end;

end.
