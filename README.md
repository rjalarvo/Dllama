
![Dllama](media/Dllama.png)

[![Chat on Discord](https://img.shields.io/discord/754884471324672040.svg?logo=discord)](https://discord.gg/tPWjMwK) [![Twitter Follow](https://img.shields.io/twitter/follow/tinyBigGAMES?style=social)](https://twitter.com/tinyBigGAMES)

# Dllama

### Overview
A simple and easy to use library for doing local LLM inference directly from <a href="https://www.embarcadero.com/products/delphi" target="_blank">Delphi</a> (any language with bindings). It can load <a href="https://huggingface.co/docs/hub/gguf" target="_blank">GGUF</a> formatted LLMs into CPU or GPU memory. Uses <a href="https://www.vulkan.org/" target="_blank">Vulkan</a> back end for acceleration. I'm getting ~25 tokens/sec on my INVIDA RTX 3060 using Vulkan.

### Installation
- Download <a href="https://github.com/tinyBigGAMES/Dllama/archive/refs/heads/main.zip" target="_blank">Dllama</a> and extract to a desired location. 
- Download a GGUF model from Hugging Face (only the ones that are supported by <a href="https://github.com/ggerganov/llama.cpp" target="_blank">llama.cpp</a>). See <a href="docs/MODELS.txt" target="_blank">MODELS.txt</a>.
- If you have a Vulkan supported GPU, it will be accelerated for faster inference, otherwise if will use the CPU. You will not be able to use a model larger than your available resources, so take note of the amount of memory that it requires. 
- See the examples in `installdir\examples` folder on how to use **Dllama** in Delphi.
- You **MUST** include `Dllama.dll` in your project distro.
- You should be able to use Dllama API from any programming language with appropriate language bindings that supports Win64 and Unicode. Out of the box Delphi/FreePascal is supported. 
- The latest ship-ready DLLs are always included in the repo, but if you need to rebuild them you will need RAD Studio 12.1 (C++Builder & Delphi).
- This project was built using RAD Studio 12.1 (latest), Windows 11 (latest), Intel Core i5-12400F 2500 Mhz 6 Cores, 12 logical, 36GB RAM, NVIDIA RTX 3060 GPU 12GB RAM.

- Please test it and feel free to submit pull requests.
- If this project is useful to you, consider starring the repo, sponsoring it, spreading the word, etc. Any help is greatly welcomed and appreciated.

### Examples  
A query example:
```Delphi  
uses
  System.SysUtils,
  Dllama,
  Dllama.Ext;
  
var  
  LResponse: string;
  LTokenInputSpeed: Single;
  LTokenOutputSpeed: Single;
  LInputTokens: Integer;
  LOutputTokens: Integer;
  LTotalTokens: Integer;

begin
  // init config
  Dllama_InitConfig('C:\LLM\gguf', -1, False, VK_ESCAPE);

  // add model
  Dllama_AddModel('Meta-Llama-3-8B-Instruct-Q6_K', 'llama3', 1024*8, '<|start_header_id|>%s %s<|end_header_id|>',
    '\n assistant:\n', ['<|eot_id|>', 'assistant']);

  // add messages
  Dllama_AddMessage(ROLE_SYSTEM, 'you are Dllama, a helpful AI assistant.');
  Dllama_AddMessage(ROLE_USER, 'who are you?');

  // display the user prompt
  Dllama_Console_PrintLn(Dllama_GetLastUserMessage(), [], DARKGREEN);
  
  // do inference
  if Dllama_Inference('llama3', LResponse) then
    begin
      // display usage
      Dllama_Console_PrintLn(CRLF, [], WHITE);
      Dllama_GetInferenceUsage(@LTokenInputSpeed, @LTokenOutputSpeed, @LInputTokens, @LOutputTokens,
        @LTotalTokens);
      Dllama_Console_PrintLn('Tokens :: Input: %d, Output: %d, Total: %d, Speed: %3.1f t/s',
        [LInputTokens, LOutputTokens, LTotalTokens, LTokenOutputSpeed], BRIGHTYELLOW);
    end
  else
    begin
      Dllama_Console_PrintLn('Error: %s', [Dllama_GetError()], RED);
    end;
  Dllama_UnloadModel();
end.
```
### Media


https://github.com/tinyBigGAMES/Dllama/assets/69952438/9f1fc3be-01cb-45e3-8b57-25416d7e0b8d



### Support
Our development motto: 
- We will not release products that are buggy, incomplete, adding new features over not fixing underlying issues.
- We will strive to fix issues found with our products in a timely manner.
- We will maintain an attitude of quality over quantity for our products.
- We will establish a great rapport with users/customers, with communication, transparency and respect, always encouragingng feedback to help shape the direction of our products.
- We will be decent, fair, remain humble and committed to the craft.

### Links
- <a href="https://github.com/tinyBigGAMES/Dllama/issues" target="_blank">Issues</a>
- <a href="https://github.com/tinyBigGAMES/Dllama/discussions" target="_blank">Discussions</a>
- <a href="https://discord.gg/tPWjMwK" target="_blank">Discord</a>
- <a href="https://youtube.com/tinyBigGAMES" target="_blank">YouTube</a>
- <a href="https://twitter.com/tinyBigGAMES" target="_blank">X (Twitter)</a>
- <a href="https://learndelphi.org/" target="_blank">learndelphi.org</a>
- <a href="https://tinybiggames.com/" target="_blank">tinyBigGAMES</a>

<p align="center">
  <img src="media/techpartner-white.png" alt="Embarcadero Technical Partner Logo" width="200"/>
  <br>
  Proud to be an <strong>Embarcadero Technical Partner</strong>.
</p>
<sub>As an Embarcadero Technical Partner, I'm committed to providing high-quality Delphi components and tools that enhance developer productivity and harness the power of Embarcadero's developer tools.</sub>

