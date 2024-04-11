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

unit Dllama.Deps;

{$I Dllama.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  WinApi.Windows;

const
  GGML_FILE_MAGIC = $67676d6c;
  GGML_FILE_VERSION = 1;
  GGML_QNT_VERSION = 2;
  GGML_QNT_VERSION_FACTOR = 1000;
  GGML_MAX_DIMS = 4;
  GGML_MAX_PARAMS = 2048;
  GGML_MAX_CONTEXTS = 64;
  GGML_MAX_SRC = 10;
  GGML_MAX_NAME = 64;
  GGML_MAX_OP_PARAMS = 64;
  GGML_DEFAULT_N_THREADS = 4;
  GGML_DEFAULT_GRAPH_SIZE = 2048;
  GGML_MEM_ALIGN = 16;
  GGML_EXIT_SUCCESS = 0;
  GGML_EXIT_ABORTED = 1;
  GGUF_MAGIC = 'GGUF';
  GGUF_VERSION = 3;
  GGUF_DEFAULT_ALIGNMENT = 32;
  GGML_N_TASKS_MAX = -1;
  LLAMA_DEFAULT_SEED = $FFFFFFFF;
  LLAMA_MAX_RNG_STATE = (64*1024);
  LLAMA_FILE_MAGIC_GGLA = $67676c61;
  LLAMA_FILE_MAGIC_GGSN = $6767736e;
  LLAMA_FILE_MAGIC_GGSQ = $67677371;
  LLAMA_SESSION_MAGIC = LLAMA_FILE_MAGIC_GGSN;
  LLAMA_SESSION_VERSION = 5;
  LLAMA_STATE_SEQ_MAGIC = LLAMA_FILE_MAGIC_GGSQ;
  LLAMA_STATE_SEQ_VERSION = 1;

type
  ggml_status = Integer;
  Pggml_status = ^ggml_status;

const
  GGML_STATUS_ALLOC_FAILED = -2;
  GGML_STATUS_FAILED = -1;
  GGML_STATUS_SUCCESS = 0;
  GGML_STATUS_ABORTED = 1;

type
  ggml_type = Integer;
  Pggml_type = ^ggml_type;

const
  GGML_TYPE_F32 = 0;
  GGML_TYPE_F16 = 1;
  GGML_TYPE_Q4_0 = 2;
  GGML_TYPE_Q4_1 = 3;
  GGML_TYPE_Q5_0 = 6;
  GGML_TYPE_Q5_1 = 7;
  GGML_TYPE_Q8_0 = 8;
  GGML_TYPE_Q8_1 = 9;
  GGML_TYPE_Q2_K = 10;
  GGML_TYPE_Q3_K = 11;
  GGML_TYPE_Q4_K = 12;
  GGML_TYPE_Q5_K = 13;
  GGML_TYPE_Q6_K = 14;
  GGML_TYPE_Q8_K = 15;
  GGML_TYPE_IQ2_XXS = 16;
  GGML_TYPE_IQ2_XS = 17;
  GGML_TYPE_IQ3_XXS = 18;
  GGML_TYPE_IQ1_S = 19;
  GGML_TYPE_IQ4_NL = 20;
  GGML_TYPE_IQ3_S = 21;
  GGML_TYPE_IQ2_S = 22;
  GGML_TYPE_IQ4_XS = 23;
  GGML_TYPE_I8 = 24;
  GGML_TYPE_I16 = 25;
  GGML_TYPE_I32 = 26;
  GGML_TYPE_I64 = 27;
  GGML_TYPE_F64 = 28;
  GGML_TYPE_IQ1_M = 29;
  GGML_TYPE_COUNT = 30;

type
  ggml_prec = Integer;
  Pggml_prec = ^ggml_prec;

const
  GGML_PREC_DEFAULT = 0;
  GGML_PREC_F32 = 1;

type
  ggml_backend_type = Integer;
  Pggml_backend_type = ^ggml_backend_type;

const
  GGML_BACKEND_TYPE_CPU = 0;
  GGML_BACKEND_TYPE_GPU = 10;
  GGML_BACKEND_TYPE_GPU_SPLIT = 20;

type
  ggml_ftype = Integer;
  Pggml_ftype = ^ggml_ftype;

const
  GGML_FTYPE_UNKNOWN = -1;
  GGML_FTYPE_ALL_F32 = 0;
  GGML_FTYPE_MOSTLY_F16 = 1;
  GGML_FTYPE_MOSTLY_Q4_0 = 2;
  GGML_FTYPE_MOSTLY_Q4_1 = 3;
  GGML_FTYPE_MOSTLY_Q4_1_SOME_F16 = 4;
  GGML_FTYPE_MOSTLY_Q8_0 = 7;
  GGML_FTYPE_MOSTLY_Q5_0 = 8;
  GGML_FTYPE_MOSTLY_Q5_1 = 9;
  GGML_FTYPE_MOSTLY_Q2_K = 10;
  GGML_FTYPE_MOSTLY_Q3_K = 11;
  GGML_FTYPE_MOSTLY_Q4_K = 12;
  GGML_FTYPE_MOSTLY_Q5_K = 13;
  GGML_FTYPE_MOSTLY_Q6_K = 14;
  GGML_FTYPE_MOSTLY_IQ2_XXS = 15;
  GGML_FTYPE_MOSTLY_IQ2_XS = 16;
  GGML_FTYPE_MOSTLY_IQ3_XXS = 17;
  GGML_FTYPE_MOSTLY_IQ1_S = 18;
  GGML_FTYPE_MOSTLY_IQ4_NL = 19;
  GGML_FTYPE_MOSTLY_IQ3_S = 20;
  GGML_FTYPE_MOSTLY_IQ2_S = 21;
  GGML_FTYPE_MOSTLY_IQ4_XS = 22;
  GGML_FTYPE_MOSTLY_IQ1_M = 23;

type
  ggml_op = Integer;
  Pggml_op = ^ggml_op;

const
  GGML_OP_NONE = 0;
  GGML_OP_DUP = 1;
  GGML_OP_ADD = 2;
  GGML_OP_ADD1 = 3;
  GGML_OP_ACC = 4;
  GGML_OP_SUB = 5;
  GGML_OP_MUL = 6;
  GGML_OP_DIV = 7;
  GGML_OP_SQR = 8;
  GGML_OP_SQRT = 9;
  GGML_OP_LOG = 10;
  GGML_OP_SUM = 11;
  GGML_OP_SUM_ROWS = 12;
  GGML_OP_MEAN = 13;
  GGML_OP_ARGMAX = 14;
  GGML_OP_REPEAT = 15;
  GGML_OP_REPEAT_BACK = 16;
  GGML_OP_CONCAT = 17;
  GGML_OP_SILU_BACK = 18;
  GGML_OP_NORM = 19;
  GGML_OP_RMS_NORM = 20;
  GGML_OP_RMS_NORM_BACK = 21;
  GGML_OP_GROUP_NORM = 22;
  GGML_OP_MUL_MAT = 23;
  GGML_OP_MUL_MAT_ID = 24;
  GGML_OP_OUT_PROD = 25;
  GGML_OP_SCALE = 26;
  GGML_OP_SET = 27;
  GGML_OP_CPY = 28;
  GGML_OP_CONT = 29;
  GGML_OP_RESHAPE = 30;
  GGML_OP_VIEW = 31;
  GGML_OP_PERMUTE = 32;
  GGML_OP_TRANSPOSE = 33;
  GGML_OP_GET_ROWS = 34;
  GGML_OP_GET_ROWS_BACK = 35;
  GGML_OP_DIAG = 36;
  GGML_OP_DIAG_MASK_INF = 37;
  GGML_OP_DIAG_MASK_ZERO = 38;
  GGML_OP_SOFT_MAX = 39;
  GGML_OP_SOFT_MAX_BACK = 40;
  GGML_OP_ROPE = 41;
  GGML_OP_ROPE_BACK = 42;
  GGML_OP_ALIBI = 43;
  GGML_OP_CLAMP = 44;
  GGML_OP_CONV_TRANSPOSE_1D = 45;
  GGML_OP_IM2COL = 46;
  GGML_OP_CONV_TRANSPOSE_2D = 47;
  GGML_OP_POOL_1D = 48;
  GGML_OP_POOL_2D = 49;
  GGML_OP_UPSCALE = 50;
  GGML_OP_PAD = 51;
  GGML_OP_ARANGE = 52;
  GGML_OP_TIMESTEP_EMBEDDING = 53;
  GGML_OP_ARGSORT = 54;
  GGML_OP_LEAKY_RELU = 55;
  GGML_OP_FLASH_ATTN = 56;
  GGML_OP_FLASH_FF = 57;
  GGML_OP_FLASH_ATTN_BACK = 58;
  GGML_OP_SSM_CONV = 59;
  GGML_OP_SSM_SCAN = 60;
  GGML_OP_WIN_PART = 61;
  GGML_OP_WIN_UNPART = 62;
  GGML_OP_GET_REL_POS = 63;
  GGML_OP_ADD_REL_POS = 64;
  GGML_OP_UNARY = 65;
  GGML_OP_MAP_UNARY = 66;
  GGML_OP_MAP_BINARY = 67;
  GGML_OP_MAP_CUSTOM1_F32 = 68;
  GGML_OP_MAP_CUSTOM2_F32 = 69;
  GGML_OP_MAP_CUSTOM3_F32 = 70;
  GGML_OP_MAP_CUSTOM1 = 71;
  GGML_OP_MAP_CUSTOM2 = 72;
  GGML_OP_MAP_CUSTOM3 = 73;
  GGML_OP_CROSS_ENTROPY_LOSS = 74;
  GGML_OP_CROSS_ENTROPY_LOSS_BACK = 75;
  GGML_OP_COUNT = 76;

type
  ggml_unary_op = Integer;
  Pggml_unary_op = ^ggml_unary_op;

const
  GGML_UNARY_OP_ABS = 0;
  GGML_UNARY_OP_SGN = 1;
  GGML_UNARY_OP_NEG = 2;
  GGML_UNARY_OP_STEP = 3;
  GGML_UNARY_OP_TANH = 4;
  GGML_UNARY_OP_ELU = 5;
  GGML_UNARY_OP_RELU = 6;
  GGML_UNARY_OP_GELU = 7;
  GGML_UNARY_OP_GELU_QUICK = 8;
  GGML_UNARY_OP_SILU = 9;
  GGML_UNARY_OP_HARDSWISH = 10;
  GGML_UNARY_OP_HARDSIGMOID = 11;
  GGML_UNARY_OP_COUNT = 12;

type
  ggml_object_type = Integer;
  Pggml_object_type = ^ggml_object_type;

const
  GGML_OBJECT_TYPE_TENSOR = 0;
  GGML_OBJECT_TYPE_GRAPH = 1;
  GGML_OBJECT_TYPE_WORK_BUFFER = 2;

type
  ggml_log_level = Integer;
  Pggml_log_level = ^ggml_log_level;

const
  GGML_LOG_LEVEL_ERROR = 2;
  GGML_LOG_LEVEL_WARN = 3;
  GGML_LOG_LEVEL_INFO = 4;
  GGML_LOG_LEVEL_DEBUG = 5;

type
  ggml_tensor_flag = Integer;
  Pggml_tensor_flag = ^ggml_tensor_flag;

const
  GGML_TENSOR_FLAG_INPUT = 1;
  GGML_TENSOR_FLAG_OUTPUT = 2;
  GGML_TENSOR_FLAG_PARAM = 4;

type
  ggml_cgraph_eval_order = Integer;
  Pggml_cgraph_eval_order = ^ggml_cgraph_eval_order;

const
  GGML_CGRAPH_EVAL_ORDER_LEFT_TO_RIGHT = 0;
  GGML_CGRAPH_EVAL_ORDER_RIGHT_TO_LEFT = 1;
  GGML_CGRAPH_EVAL_ORDER_COUNT = 2;

type
  ggml_task_type = Integer;
  Pggml_task_type = ^ggml_task_type;

const
  GGML_TASK_TYPE_INIT = 0;
  GGML_TASK_TYPE_COMPUTE = 1;
  GGML_TASK_TYPE_FINALIZE = 2;

type
  ggml_numa_strategy = Integer;
  Pggml_numa_strategy = ^ggml_numa_strategy;

const
  GGML_NUMA_STRATEGY_DISABLED = 0;
  GGML_NUMA_STRATEGY_DISTRIBUTE = 1;
  GGML_NUMA_STRATEGY_ISOLATE = 2;
  GGML_NUMA_STRATEGY_NUMACTL = 3;
  GGML_NUMA_STRATEGY_MIRROR = 4;
  GGML_NUMA_STRATEGY_COUNT = 5;

type
  ggml_op_pool = Integer;
  Pggml_op_pool = ^ggml_op_pool;

const
  GGML_OP_POOL_MAX = 0;
  GGML_OP_POOL_AVG = 1;
  GGML_OP_POOL_COUNT = 2;

type
  ggml_sort_order = Integer;
  Pggml_sort_order = ^ggml_sort_order;

const
  GGML_SORT_ORDER_ASC = 0;
  GGML_SORT_ORDER_DESC = 1;

type
  ggml_opt_type = Integer;
  Pggml_opt_type = ^ggml_opt_type;

const
  GGML_OPT_TYPE_ADAM = 0;
  GGML_OPT_TYPE_LBFGS = 1;

type
  ggml_linesearch = Integer;
  Pggml_linesearch = ^ggml_linesearch;

const
  GGML_LINESEARCH_DEFAULT = 1;
  GGML_LINESEARCH_BACKTRACKING_ARMIJO = 0;
  GGML_LINESEARCH_BACKTRACKING_WOLFE = 1;
  GGML_LINESEARCH_BACKTRACKING_STRONG_WOLFE = 2;

type
  ggml_opt_result = Integer;
  Pggml_opt_result = ^ggml_opt_result;

const
  GGML_OPT_RESULT_OK = 0;
  GGML_OPT_RESULT_DID_NOT_CONVERGE = 1;
  GGML_OPT_RESULT_NO_CONTEXT = 2;
  GGML_OPT_RESULT_INVALID_WOLFE = 3;
  GGML_OPT_RESULT_FAIL = 4;
  GGML_OPT_RESULT_CANCEL = 5;
  GGML_LINESEARCH_FAIL = -128;
  GGML_LINESEARCH_MINIMUM_STEP = -127;
  GGML_LINESEARCH_MAXIMUM_STEP = -126;
  GGML_LINESEARCH_MAXIMUM_ITERATIONS = -125;
  GGML_LINESEARCH_INVALID_PARAMETERS = -124;

type
  gguf_type = Integer;
  Pgguf_type = ^gguf_type;

const
  GGUF_TYPE_UINT8 = 0;
  GGUF_TYPE_INT8 = 1;
  GGUF_TYPE_UINT16 = 2;
  GGUF_TYPE_INT16 = 3;
  GGUF_TYPE_UINT32 = 4;
  GGUF_TYPE_INT32 = 5;
  GGUF_TYPE_FLOAT32 = 6;
  GGUF_TYPE_BOOL = 7;
  GGUF_TYPE_STRING = 8;
  GGUF_TYPE_ARRAY = 9;
  GGUF_TYPE_UINT64 = 10;
  GGUF_TYPE_INT64 = 11;
  GGUF_TYPE_FLOAT64 = 12;
  GGUF_TYPE_COUNT = 13;

type
  ggml_backend_buffer_usage = Integer;
  Pggml_backend_buffer_usage = ^ggml_backend_buffer_usage;

const
  GGML_BACKEND_BUFFER_USAGE_ANY = 0;
  GGML_BACKEND_BUFFER_USAGE_WEIGHTS = 1;

type
  llama_vocab_type = Integer;
  Pllama_vocab_type = ^llama_vocab_type;

const
  LLAMA_VOCAB_TYPE_NONE = 0;
  LLAMA_VOCAB_TYPE_SPM = 1;
  LLAMA_VOCAB_TYPE_BPE = 2;
  LLAMA_VOCAB_TYPE_WPM = 3;

type
  llama_rope_type = Integer;
  Pllama_rope_type = ^llama_rope_type;

const
  LLAMA_ROPE_TYPE_NONE = -1;
  LLAMA_ROPE_TYPE_NORM = 0;
  LLAMA_ROPE_TYPE_NEOX = 2;
  LLAMA_ROPE_TYPE_GLM = 4;

type
  llama_token_type = Integer;
  Pllama_token_type = ^llama_token_type;

const
  LLAMA_TOKEN_TYPE_UNDEFINED = 0;
  LLAMA_TOKEN_TYPE_NORMAL = 1;
  LLAMA_TOKEN_TYPE_UNKNOWN = 2;
  LLAMA_TOKEN_TYPE_CONTROL = 3;
  LLAMA_TOKEN_TYPE_USER_DEFINED = 4;
  LLAMA_TOKEN_TYPE_UNUSED = 5;
  LLAMA_TOKEN_TYPE_BYTE = 6;

type
  llama_ftype = Integer;
  Pllama_ftype = ^llama_ftype;

const
  LLAMA_FTYPE_ALL_F32 = 0;
  LLAMA_FTYPE_MOSTLY_F16 = 1;
  LLAMA_FTYPE_MOSTLY_Q4_0 = 2;
  LLAMA_FTYPE_MOSTLY_Q4_1 = 3;
  LLAMA_FTYPE_MOSTLY_Q4_1_SOME_F16 = 4;
  LLAMA_FTYPE_MOSTLY_Q8_0 = 7;
  LLAMA_FTYPE_MOSTLY_Q5_0 = 8;
  LLAMA_FTYPE_MOSTLY_Q5_1 = 9;
  LLAMA_FTYPE_MOSTLY_Q2_K = 10;
  LLAMA_FTYPE_MOSTLY_Q3_K_S = 11;
  LLAMA_FTYPE_MOSTLY_Q3_K_M = 12;
  LLAMA_FTYPE_MOSTLY_Q3_K_L = 13;
  LLAMA_FTYPE_MOSTLY_Q4_K_S = 14;
  LLAMA_FTYPE_MOSTLY_Q4_K_M = 15;
  LLAMA_FTYPE_MOSTLY_Q5_K_S = 16;
  LLAMA_FTYPE_MOSTLY_Q5_K_M = 17;
  LLAMA_FTYPE_MOSTLY_Q6_K = 18;
  LLAMA_FTYPE_MOSTLY_IQ2_XXS = 19;
  LLAMA_FTYPE_MOSTLY_IQ2_XS = 20;
  LLAMA_FTYPE_MOSTLY_Q2_K_S = 21;
  LLAMA_FTYPE_MOSTLY_IQ3_XS = 22;
  LLAMA_FTYPE_MOSTLY_IQ3_XXS = 23;
  LLAMA_FTYPE_MOSTLY_IQ1_S = 24;
  LLAMA_FTYPE_MOSTLY_IQ4_NL = 25;
  LLAMA_FTYPE_MOSTLY_IQ3_S = 26;
  LLAMA_FTYPE_MOSTLY_IQ3_M = 27;
  LLAMA_FTYPE_MOSTLY_IQ2_S = 28;
  LLAMA_FTYPE_MOSTLY_IQ2_M = 29;
  LLAMA_FTYPE_MOSTLY_IQ4_XS = 30;
  LLAMA_FTYPE_MOSTLY_IQ1_M = 31;
  LLAMA_FTYPE_GUESSED = 1024;

type
  llama_rope_scaling_type = Integer;
  Pllama_rope_scaling_type = ^llama_rope_scaling_type;

const
  LLAMA_ROPE_SCALING_TYPE_UNSPECIFIED = -1;
  LLAMA_ROPE_SCALING_TYPE_NONE = 0;
  LLAMA_ROPE_SCALING_TYPE_LINEAR = 1;
  LLAMA_ROPE_SCALING_TYPE_YARN = 2;
  LLAMA_ROPE_SCALING_TYPE_MAX_VALUE = 2;

type
  llama_pooling_type = Integer;
  Pllama_pooling_type = ^llama_pooling_type;

const
  LLAMA_POOLING_TYPE_UNSPECIFIED = -1;
  LLAMA_POOLING_TYPE_NONE = 0;
  LLAMA_POOLING_TYPE_MEAN = 1;
  LLAMA_POOLING_TYPE_CLS = 2;

type
  llama_split_mode = Integer;
  Pllama_split_mode = ^llama_split_mode;

const
  LLAMA_SPLIT_MODE_NONE = 0;
  LLAMA_SPLIT_MODE_LAYER = 1;
  LLAMA_SPLIT_MODE_ROW = 2;

type
  llama_model_kv_override_type = Integer;
  Pllama_model_kv_override_type = ^llama_model_kv_override_type;

const
  LLAMA_KV_OVERRIDE_TYPE_INT = 0;
  LLAMA_KV_OVERRIDE_TYPE_FLOAT = 1;
  LLAMA_KV_OVERRIDE_TYPE_BOOL = 2;

type
  llama_gretype = Integer;
  Pllama_gretype = ^llama_gretype;

const
  LLAMA_GRETYPE_END = 0;
  LLAMA_GRETYPE_ALT = 1;
  LLAMA_GRETYPE_RULE_REF = 2;
  LLAMA_GRETYPE_CHAR = 3;
  LLAMA_GRETYPE_CHAR_NOT = 4;
  LLAMA_GRETYPE_CHAR_RNG_UPPER = 5;
  LLAMA_GRETYPE_CHAR_ALT = 6;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  PUInt8 = ^UInt8;
  PInt8 = ^Int8;
  PInt64 = ^Int64;
  PInt32 = ^Int32;
  PPointer = ^Pointer;
  PNativeUInt = ^NativeUInt;
  Pggml_context = Pointer;
  PPggml_context = ^Pggml_context;
  Pggml_backend_buffer = Pointer;
  PPggml_backend_buffer = ^Pggml_backend_buffer;
  Pgguf_context = Pointer;
  PPgguf_context = ^Pgguf_context;
  Pggml_backend_buffer_type = Pointer;
  PPggml_backend_buffer_type = ^Pggml_backend_buffer_type;
  Pggml_backend = Pointer;
  PPggml_backend = ^Pggml_backend;
  Pggml_gallocr = Pointer;
  PPggml_gallocr = ^Pggml_gallocr;
  Pggml_backend_event = Pointer;
  PPggml_backend_event = ^Pggml_backend_event;
  Pggml_backend_sched = Pointer;
  PPggml_backend_sched = ^Pggml_backend_sched;
  Pllama_model = Pointer;
  PPllama_model = ^Pllama_model;
  Pllama_context = Pointer;
  PPllama_context = ^Pllama_context;
  Pllama_grammar = Pointer;
  PPllama_grammar = ^Pllama_grammar;
  Pggml_object = ^ggml_object;
  Pggml_tensor = ^ggml_tensor;
  PPggml_tensor = ^Pggml_tensor;
  Pggml_cplan = ^ggml_cplan;
  Pggml_hash_set = ^ggml_hash_set;
  Pggml_cgraph = ^ggml_cgraph;
  Pggml_scratch = ^ggml_scratch;
  Pggml_init_params = ^ggml_init_params;
  Pggml_compute_params = ^ggml_compute_params;
  Pggml_opt_params = ^ggml_opt_params;
  Pggml_opt_context = ^ggml_opt_context;
  Pgguf_init_params = ^gguf_init_params;
  Pggml_type_traits_t = ^ggml_type_traits_t;
  Pggml_tallocr = ^ggml_tallocr;
  Pggml_backend_graph_copy = ^ggml_backend_graph_copy;
  Pllama_token_data = ^llama_token_data;
  Pllama_token_data_array = ^llama_token_data_array;
  Pllama_batch = ^llama_batch;
  Pllama_model_kv_override = ^llama_model_kv_override;
  Pllama_model_params = ^llama_model_params;
  Pllama_context_params = ^llama_context_params;
  Pllama_model_quantize_params = ^llama_model_quantize_params;
  Pllama_grammar_element = ^llama_grammar_element;
  PPllama_grammar_element = ^Pllama_grammar_element;
  Pllama_timings = ^llama_timings;
  Pllama_chat_message = ^llama_chat_message;
  Pllama_kv_cache_view_cell = ^llama_kv_cache_view_cell;
  Pllama_kv_cache_view = ^llama_kv_cache_view;
  Pllama_beam_view = ^llama_beam_view;
  Pllama_beams_state = ^llama_beams_state;

  ggml_fp16_t = UInt16;
  Pggml_fp16_t = ^ggml_fp16_t;

  ggml_object = record
    offs: NativeUInt;
    size: NativeUInt;
    next: Pggml_object;
    &type: ggml_object_type;
    padding: array [0..3] of UTF8Char;
  end;

  ggml_tensor = record
    &type: ggml_type;
    backend: ggml_backend_type;
    buffer: Pggml_backend_buffer;
    ne: array [0..3] of Int64;
    nb: array [0..3] of NativeUInt;
    op: ggml_op;
    op_params: array [0..15] of Int32;
    flags: Int32;
    grad: Pggml_tensor;
    src: array [0..9] of Pggml_tensor;
    perf_runs: Integer;
    perf_cycles: Int64;
    perf_time_us: Int64;
    view_src: Pggml_tensor;
    view_offs: NativeUInt;
    data: Pointer;
    name: array [0..63] of UTF8Char;
    extra: Pointer;
    padding: array [0..7] of UTF8Char;
  end;

  ggml_abort_callback = function(data: Pointer): Boolean; cdecl;

  ggml_cplan = record
    work_size: NativeUInt;
    work_data: PUInt8;
    n_threads: Integer;
    abort_callback: ggml_abort_callback;
    abort_callback_data: Pointer;
  end;

  ggml_hash_set = record
    size: NativeUInt;
    keys: PPggml_tensor;
  end;

  ggml_cgraph = record
    size: Integer;
    n_nodes: Integer;
    n_leafs: Integer;
    nodes: PPggml_tensor;
    grads: PPggml_tensor;
    leafs: PPggml_tensor;
    visited_hash_table: ggml_hash_set;
    order: ggml_cgraph_eval_order;
    perf_runs: Integer;
    perf_cycles: Int64;
    perf_time_us: Int64;
  end;

  ggml_scratch = record
    offs: NativeUInt;
    size: NativeUInt;
    data: Pointer;
  end;

  ggml_init_params = record
    mem_size: NativeUInt;
    mem_buffer: Pointer;
    no_alloc: Boolean;
  end;

  ggml_compute_params = record
    &type: ggml_task_type;
    ith: Integer;
    nth: Integer;
    wsize: NativeUInt;
    wdata: Pointer;
  end;

  ggml_guid = array [0..15] of UInt8;
  ggml_guid_t = ^ggml_guid;

  ggml_unary_op_f32_t = procedure(const p1: Integer; p2: PSingle; const p3: PSingle); cdecl;

  ggml_binary_op_f32_t = procedure(const p1: Integer; p2: PSingle; const p3: PSingle; const p4: PSingle); cdecl;

  ggml_custom1_op_f32_t = procedure(p1: Pggml_tensor; const p2: Pggml_tensor); cdecl;

  ggml_custom2_op_f32_t = procedure(p1: Pggml_tensor; const p2: Pggml_tensor; const p3: Pggml_tensor); cdecl;

  ggml_custom3_op_f32_t = procedure(p1: Pggml_tensor; const p2: Pggml_tensor; const p3: Pggml_tensor; const p4: Pggml_tensor); cdecl;

  ggml_custom1_op_t = procedure(dst: Pggml_tensor; const a: Pggml_tensor; ith: Integer; nth: Integer; userdata: Pointer); cdecl;

  ggml_custom2_op_t = procedure(dst: Pggml_tensor; const a: Pggml_tensor; const b: Pggml_tensor; ith: Integer; nth: Integer; userdata: Pointer); cdecl;

  ggml_custom3_op_t = procedure(dst: Pggml_tensor; const a: Pggml_tensor; const b: Pggml_tensor; const c: Pggml_tensor; ith: Integer; nth: Integer; userdata: Pointer); cdecl;

  ggml_opt_callback = procedure(data: Pointer; accum_step: Integer; sched: PSingle; cancel: PBoolean); cdecl;

  ggml_log_callback = procedure(level: ggml_log_level; const text: PUTF8Char; user_data: Pointer); cdecl;

  P_anonymous_type_1 = ^_anonymous_type_1;
  _anonymous_type_1 = record
    n_iter: Integer;
    sched: Single;
    decay: Single;
    decay_min_ndim: Integer;
    alpha: Single;
    beta1: Single;
    beta2: Single;
    eps: Single;
    eps_f: Single;
    eps_g: Single;
    gclip: Single;
  end;

  P_anonymous_type_2 = ^_anonymous_type_2;
  _anonymous_type_2 = record
    m: Integer;
    n_iter: Integer;
    max_linesearch: Integer;
    eps: Single;
    ftol: Single;
    wolfe: Single;
    min_step: Single;
    max_step: Single;
    linesearch: ggml_linesearch;
  end;

  ggml_opt_params = record
    &type: ggml_opt_type;
    graph_size: NativeUInt;
    n_threads: Integer;
    past: Integer;
    delta: Single;
    max_no_improvement: Integer;
    print_forward_graph: Boolean;
    print_backward_graph: Boolean;
    n_gradient_accumulation: Integer;
    adam: _anonymous_type_1;
    lbfgs: _anonymous_type_2;
  end;

  P_anonymous_type_3 = ^_anonymous_type_3;
  _anonymous_type_3 = record
    g: Pggml_tensor;
    m: Pggml_tensor;
    v: Pggml_tensor;
    pf: Pggml_tensor;
    fx_best: Single;
    fx_prev: Single;
    n_no_improvement: Integer;
  end;

  P_anonymous_type_4 = ^_anonymous_type_4;
  _anonymous_type_4 = record
    x: Pggml_tensor;
    xp: Pggml_tensor;
    g: Pggml_tensor;
    gp: Pggml_tensor;
    d: Pggml_tensor;
    pf: Pggml_tensor;
    lmal: Pggml_tensor;
    lmys: Pggml_tensor;
    lms: Pggml_tensor;
    lmy: Pggml_tensor;
    fx_best: Single;
    step: Single;
    j: Integer;
    k: Integer;
    &end: Integer;
    n_no_improvement: Integer;
  end;

  ggml_opt_context = record
    ctx: Pggml_context;
    params: ggml_opt_params;
    iter: Integer;
    nx: Int64;
    just_initialized: Boolean;
    loss_before: Single;
    loss_after: Single;
    adam: _anonymous_type_3;
    lbfgs: _anonymous_type_4;
  end;

  gguf_init_params = record
    no_alloc: Boolean;
    ctx: PPggml_context;
  end;

  ggml_to_float_t = procedure(const x: Pointer; y: PSingle; k: Int64); cdecl;

  ggml_from_float_t = procedure(const x: PSingle; y: Pointer; k: Int64); cdecl;

  ggml_vec_dot_t = procedure(n: Integer; s: PSingle; bs: NativeUInt; const x: Pointer; bx: NativeUInt; const y: Pointer; by: NativeUInt; nrc: Integer); cdecl;

  ggml_type_traits_t = record
    type_name: PUTF8Char;
    blck_size: Integer;
    type_size: NativeUInt;
    is_quantized: Boolean;
    to_float: ggml_to_float_t;
    from_float: ggml_from_float_t;
    from_float_reference: ggml_from_float_t;
    vec_dot: ggml_vec_dot_t;
    vec_dot_type: ggml_type;
    nrows: Int64;
  end;

  ggml_backend_buffer_type_t = Pointer;
  Pggml_backend_buffer_type_t = ^ggml_backend_buffer_type_t;
  ggml_backend_buffer_t = Pointer;
  Pggml_backend_buffer_t = ^ggml_backend_buffer_t;
  ggml_backend_t = Pointer;
  Pggml_backend_t = ^ggml_backend_t;

  ggml_tallocr = record
    buffer: ggml_backend_buffer_t;
    base: Pointer;
    alignment: NativeUInt;
    offset: NativeUInt;
  end;

  ggml_gallocr_t = Pointer;
  Pggml_gallocr_t = ^ggml_gallocr_t;
  ggml_backend_event_t = Pointer;
  Pggml_backend_event_t = ^ggml_backend_event_t;
  ggml_backend_graph_plan_t = Pointer;
  ggml_backend_sched_t = Pointer;
  Pggml_backend_sched_t = ^ggml_backend_sched_t;

  ggml_backend_sched_eval_callback = function(t: Pggml_tensor; ask: Boolean; user_data: Pointer): Boolean; cdecl;

  ggml_backend_graph_copy = record
    buffer: ggml_backend_buffer_t;
    ctx_allocated: Pggml_context;
    ctx_unallocated: Pggml_context;
    graph: Pggml_cgraph;
  end;

  ggml_backend_eval_callback = function(node_index: Integer; t1: Pggml_tensor; t2: Pggml_tensor; user_data: Pointer): Boolean; cdecl;
  llama_pos = Int32;
  Pllama_pos = ^llama_pos;
  llama_token = Int32;
  Pllama_token = ^llama_token;
  llama_seq_id = Int32;
  Pllama_seq_id = ^llama_seq_id;
  PPllama_seq_id = ^Pllama_seq_id;

  llama_token_data = record
    id: llama_token;
    logit: Single;
    p: Single;
  end;

  llama_token_data_array = record
    data: Pllama_token_data;
    size: NativeUInt;
    sorted: Boolean;
  end;

  llama_progress_callback = function(progress: Single; ctx: Pointer): Boolean; cdecl;

  llama_batch = record
    n_tokens: Int32;
    token: Pllama_token;
    embd: PSingle;
    pos: Pllama_pos;
    n_seq_id: PInt32;
    seq_id: PPllama_seq_id;
    logits: PInt8;
    all_pos_0: llama_pos;
    all_pos_1: llama_pos;
    all_seq_id: llama_seq_id;
  end;

  P_anonymous_type_5 = ^_anonymous_type_5;
  _anonymous_type_5 = record
    case Integer of
      0: (int_value: Int64);
      1: (float_value: Double);
      2: (bool_value: Boolean);
  end;

  llama_model_kv_override = record
    key: array [0..127] of UTF8Char;
    tag: llama_model_kv_override_type;
    f3: _anonymous_type_5;
  end;

  llama_model_params = record
    n_gpu_layers: Int32;
    split_mode: llama_split_mode;
    main_gpu: Int32;
    tensor_split: PSingle;
    progress_callback: llama_progress_callback;
    progress_callback_user_data: Pointer;
    kv_overrides: Pllama_model_kv_override;
    vocab_only: Boolean;
    use_mmap: Boolean;
    use_mlock: Boolean;
  end;

  llama_context_params = record
    seed: UInt32;
    n_ctx: UInt32;
    n_batch: UInt32;
    n_ubatch: UInt32;
    n_seq_max: UInt32;
    n_threads: UInt32;
    n_threads_batch: UInt32;
    rope_scaling_type: llama_rope_scaling_type;
    pooling_type: llama_pooling_type;
    rope_freq_base: Single;
    rope_freq_scale: Single;
    yarn_ext_factor: Single;
    yarn_attn_factor: Single;
    yarn_beta_fast: Single;
    yarn_beta_slow: Single;
    yarn_orig_ctx: UInt32;
    defrag_thold: Single;
    cb_eval: ggml_backend_sched_eval_callback;
    cb_eval_user_data: Pointer;
    type_k: ggml_type;
    type_v: ggml_type;
    logits_all: Boolean;
    embeddings: Boolean;
    offload_kqv: Boolean;
    abort_callback: ggml_abort_callback;
    abort_callback_data: Pointer;
  end;

  llama_model_quantize_params = record
    nthread: Int32;
    ftype: llama_ftype;
    output_tensor_type: ggml_type;
    token_embedding_type: ggml_type;
    allow_requantize: Boolean;
    quantize_output_tensor: Boolean;
    only_copy: Boolean;
    pure: Boolean;
    imatrix: Pointer;
    kv_overrides: Pointer;
  end;

  llama_grammar_element = record
    &type: llama_gretype;
    value: UInt32;
  end;

  llama_timings = record
    t_start_ms: Double;
    t_end_ms: Double;
    t_load_ms: Double;
    t_sample_ms: Double;
    t_p_eval_ms: Double;
    t_eval_ms: Double;
    n_sample: Int32;
    n_p_eval: Int32;
    n_eval: Int32;
  end;

  llama_chat_message = record
    role: PUTF8Char;
    content: PUTF8Char;
  end;

  llama_kv_cache_view_cell = record
    pos: llama_pos;
  end;

  llama_kv_cache_view = record
    n_cells: Int32;
    n_seq_max: Int32;
    token_count: Int32;
    used_cells: Int32;
    max_contiguous: Int32;
    max_contiguous_idx: Int32;
    cells: Pllama_kv_cache_view_cell;
    cells_sequences: Pllama_seq_id;
  end;

  llama_beam_view = record
    tokens: Pllama_token;
    n_tokens: NativeUInt;
    p: Single;
    eob: Boolean;
  end;

  llama_beams_state = record
    beam_views: Pllama_beam_view;
    n_beams: NativeUInt;
    common_prefix_length: NativeUInt;
    last_call: Boolean;
  end;

  llama_beam_search_callback_fn_t = procedure(callback_data: Pointer; p2: llama_beams_state); cdecl;

  cerr_callback = procedure(const text: PUTF8Char; user_data: Pointer); cdecl;

var
  ggml_status_to_string: function(status: ggml_status): PUTF8Char; cdecl;
  ggml_fp16_to_fp32: function(x: ggml_fp16_t): Single; cdecl;
  ggml_fp32_to_fp16: function(x: Single): ggml_fp16_t; cdecl;
  ggml_fp16_to_fp32_row: procedure(const x: Pggml_fp16_t; y: PSingle; n: Int64); cdecl;
  ggml_fp32_to_fp16_row: procedure(const x: PSingle; y: Pggml_fp16_t; n: Int64); cdecl;
  ggml_guid_matches: function(guid_a: ggml_guid_t; guid_b: ggml_guid_t): Boolean; cdecl;
  ggml_time_init: procedure(); cdecl;
  ggml_time_ms: function(): Int64; cdecl;
  ggml_time_us: function(): Int64; cdecl;
  ggml_cycles: function(): Int64; cdecl;
  ggml_cycles_per_ms: function(): Int64; cdecl;
  ggml_print_backtrace: procedure(); cdecl;
  ggml_fopen: function(const fname: PUTF8Char; const mode: PUTF8Char): PPointer; cdecl;
  ggml_numa_init: procedure(numa: ggml_numa_strategy); cdecl;
  ggml_is_numa: function(): Boolean; cdecl;
  ggml_print_object: procedure(const obj: Pggml_object); cdecl;
  ggml_print_objects: procedure(const ctx: Pggml_context); cdecl;
  ggml_nelements: function(const tensor: Pggml_tensor): Int64; cdecl;
  ggml_nrows: function(const tensor: Pggml_tensor): Int64; cdecl;
  ggml_nbytes: function(const tensor: Pggml_tensor): NativeUInt; cdecl;
  ggml_nbytes_pad: function(const tensor: Pggml_tensor): NativeUInt; cdecl;
  ggml_blck_size: function(&type: ggml_type): Integer; cdecl;
  ggml_type_size: function(&type: ggml_type): NativeUInt; cdecl;
  ggml_row_size: function(&type: ggml_type; ne: Int64): NativeUInt; cdecl;
  ggml_type_sizef: function(&type: ggml_type): Double; cdecl;
  ggml_type_name: function(&type: ggml_type): PUTF8Char; cdecl;
  ggml_op_name: function(op: ggml_op): PUTF8Char; cdecl;
  ggml_op_symbol: function(op: ggml_op): PUTF8Char; cdecl;
  ggml_unary_op_name: function(op: ggml_unary_op): PUTF8Char; cdecl;
  ggml_op_desc: function(const t: Pggml_tensor): PUTF8Char; cdecl;
  ggml_element_size: function(const tensor: Pggml_tensor): NativeUInt; cdecl;
  ggml_is_quantized: function(&type: ggml_type): Boolean; cdecl;
  ggml_ftype_to_ggml_type: function(ftype: ggml_ftype): ggml_type; cdecl;
  ggml_is_transposed: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_contiguous: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_permuted: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_empty: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_scalar: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_vector: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_matrix: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_is_3d: function(const tensor: Pggml_tensor): Boolean; cdecl;
  ggml_n_dims: function(const tensor: Pggml_tensor): Integer; cdecl;
  ggml_are_same_shape: function(const t0: Pggml_tensor; const t1: Pggml_tensor): Boolean; cdecl;
  ggml_tensor_overhead: function(): NativeUInt; cdecl;
  ggml_init: function(params: ggml_init_params): Pggml_context; cdecl;
  ggml_free: procedure(ctx: Pggml_context); cdecl;
  ggml_used_mem: function(const ctx: Pggml_context): NativeUInt; cdecl;
  ggml_set_scratch: function(ctx: Pggml_context; scratch: ggml_scratch): NativeUInt; cdecl;
  ggml_get_no_alloc: function(ctx: Pggml_context): Boolean; cdecl;
  ggml_set_no_alloc: procedure(ctx: Pggml_context; no_alloc: Boolean); cdecl;
  ggml_get_mem_buffer: function(const ctx: Pggml_context): Pointer; cdecl;
  ggml_get_mem_size: function(const ctx: Pggml_context): NativeUInt; cdecl;
  ggml_get_max_tensor_size: function(const ctx: Pggml_context): NativeUInt; cdecl;
  ggml_new_tensor: function(ctx: Pggml_context; &type: ggml_type; n_dims: Integer; const ne: PInt64): Pggml_tensor; cdecl;
  ggml_new_tensor_1d: function(ctx: Pggml_context; &type: ggml_type; ne0: Int64): Pggml_tensor; cdecl;
  ggml_new_tensor_2d: function(ctx: Pggml_context; &type: ggml_type; ne0: Int64; ne1: Int64): Pggml_tensor; cdecl;
  ggml_new_tensor_3d: function(ctx: Pggml_context; &type: ggml_type; ne0: Int64; ne1: Int64; ne2: Int64): Pggml_tensor; cdecl;
  ggml_new_tensor_4d: function(ctx: Pggml_context; &type: ggml_type; ne0: Int64; ne1: Int64; ne2: Int64; ne3: Int64): Pggml_tensor; cdecl;
  ggml_new_i32: function(ctx: Pggml_context; value: Int32): Pggml_tensor; cdecl;
  ggml_new_f32: function(ctx: Pggml_context; value: Single): Pggml_tensor; cdecl;
  ggml_dup_tensor: function(ctx: Pggml_context; const src: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_view_tensor: function(ctx: Pggml_context; src: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_get_first_tensor: function(const ctx: Pggml_context): Pggml_tensor; cdecl;
  ggml_get_next_tensor: function(const ctx: Pggml_context; tensor: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_get_tensor: function(ctx: Pggml_context; const name: PUTF8Char): Pggml_tensor; cdecl;
  ggml_set_zero: function(tensor: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_set_i32: function(tensor: Pggml_tensor; value: Int32): Pggml_tensor; cdecl;
  ggml_set_f32: function(tensor: Pggml_tensor; value: Single): Pggml_tensor; cdecl;
  ggml_unravel_index: procedure(const tensor: Pggml_tensor; i: Int64; i0: PInt64; i1: PInt64; i2: PInt64; i3: PInt64); cdecl;
  ggml_get_i32_1d: function(const tensor: Pggml_tensor; i: Integer): Int32; cdecl;
  ggml_set_i32_1d: procedure(const tensor: Pggml_tensor; i: Integer; value: Int32); cdecl;
  ggml_get_i32_nd: function(const tensor: Pggml_tensor; i0: Integer; i1: Integer; i2: Integer; i3: Integer): Int32; cdecl;
  ggml_set_i32_nd: procedure(const tensor: Pggml_tensor; i0: Integer; i1: Integer; i2: Integer; i3: Integer; value: Int32); cdecl;
  ggml_get_f32_1d: function(const tensor: Pggml_tensor; i: Integer): Single; cdecl;
  ggml_set_f32_1d: procedure(const tensor: Pggml_tensor; i: Integer; value: Single); cdecl;
  ggml_get_f32_nd: function(const tensor: Pggml_tensor; i0: Integer; i1: Integer; i2: Integer; i3: Integer): Single; cdecl;
  ggml_set_f32_nd: procedure(const tensor: Pggml_tensor; i0: Integer; i1: Integer; i2: Integer; i3: Integer; value: Single); cdecl;
  ggml_get_data: function(const tensor: Pggml_tensor): Pointer; cdecl;
  ggml_get_data_f32: function(const tensor: Pggml_tensor): PSingle; cdecl;
  ggml_get_unary_op: function(const tensor: Pggml_tensor): ggml_unary_op; cdecl;
  ggml_get_name: function(const tensor: Pggml_tensor): PUTF8Char; cdecl;
  ggml_set_name: function(tensor: Pggml_tensor; const name: PUTF8Char): Pggml_tensor; cdecl;
  ggml_format_name: function(tensor: Pggml_tensor; const fmt: PUTF8Char): Pggml_tensor varargs; cdecl;
  ggml_dup: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_dup_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_add: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_add_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_add_cast: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; &type: ggml_type): Pggml_tensor; cdecl;
  ggml_add1: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_add1_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_acc: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; nb1: NativeUInt; nb2: NativeUInt; nb3: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_acc_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; nb1: NativeUInt; nb2: NativeUInt; nb3: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_sub: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sub_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_mul: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_mul_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_div: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_div_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sqr: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sqr_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sqrt: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sqrt_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_log: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_log_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sum: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sum_rows: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_mean: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_argmax: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_repeat: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_repeat_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_concat: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_abs: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_abs_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sgn: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_sgn_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_neg: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_neg_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_step: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_step_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_tanh: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_tanh_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_elu: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_elu_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_relu: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_leaky_relu: function(ctx: Pggml_context; a: Pggml_tensor; negative_slope: Single; inplace: Boolean): Pggml_tensor; cdecl;
  ggml_relu_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_gelu: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_gelu_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_gelu_quick: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_gelu_quick_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_silu: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_silu_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_silu_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_hardswish: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_hardsigmoid: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_norm: function(ctx: Pggml_context; a: Pggml_tensor; eps: Single): Pggml_tensor; cdecl;
  ggml_norm_inplace: function(ctx: Pggml_context; a: Pggml_tensor; eps: Single): Pggml_tensor; cdecl;
  ggml_rms_norm: function(ctx: Pggml_context; a: Pggml_tensor; eps: Single): Pggml_tensor; cdecl;
  ggml_rms_norm_inplace: function(ctx: Pggml_context; a: Pggml_tensor; eps: Single): Pggml_tensor; cdecl;
  ggml_group_norm: function(ctx: Pggml_context; a: Pggml_tensor; n_groups: Integer): Pggml_tensor; cdecl;
  ggml_group_norm_inplace: function(ctx: Pggml_context; a: Pggml_tensor; n_groups: Integer): Pggml_tensor; cdecl;
  ggml_rms_norm_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; eps: Single): Pggml_tensor; cdecl;
  ggml_mul_mat: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_mul_mat_set_prec: procedure(a: Pggml_tensor; prec: ggml_prec); cdecl;
  ggml_mul_mat_id: function(ctx: Pggml_context; &as: Pggml_tensor; ids: Pggml_tensor; id: Integer; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_out_prod: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_scale: function(ctx: Pggml_context; a: Pggml_tensor; s: Single): Pggml_tensor; cdecl;
  ggml_scale_inplace: function(ctx: Pggml_context; a: Pggml_tensor; s: Single): Pggml_tensor; cdecl;
  ggml_set: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; nb1: NativeUInt; nb2: NativeUInt; nb3: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_set_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; nb1: NativeUInt; nb2: NativeUInt; nb3: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_set_1d: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_set_1d_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_set_2d: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; nb1: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_set_2d_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; nb1: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_cpy: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_cast: function(ctx: Pggml_context; a: Pggml_tensor; &type: ggml_type): Pggml_tensor; cdecl;
  ggml_cont: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_cont_1d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64): Pggml_tensor; cdecl;
  ggml_cont_2d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64): Pggml_tensor; cdecl;
  ggml_cont_3d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; ne2: Int64): Pggml_tensor; cdecl;
  ggml_cont_4d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; ne2: Int64; ne3: Int64): Pggml_tensor; cdecl;
  ggml_reshape: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_reshape_1d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64): Pggml_tensor; cdecl;
  ggml_reshape_2d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64): Pggml_tensor; cdecl;
  ggml_reshape_3d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; ne2: Int64): Pggml_tensor; cdecl;
  ggml_reshape_4d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; ne2: Int64; ne3: Int64): Pggml_tensor; cdecl;
  ggml_view_1d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_view_2d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; nb1: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_view_3d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; ne2: Int64; nb1: NativeUInt; nb2: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_view_4d: function(ctx: Pggml_context; a: Pggml_tensor; ne0: Int64; ne1: Int64; ne2: Int64; ne3: Int64; nb1: NativeUInt; nb2: NativeUInt; nb3: NativeUInt; offset: NativeUInt): Pggml_tensor; cdecl;
  ggml_permute: function(ctx: Pggml_context; a: Pggml_tensor; axis0: Integer; axis1: Integer; axis2: Integer; axis3: Integer): Pggml_tensor; cdecl;
  ggml_transpose: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_get_rows: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_get_rows_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; c: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_diag: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_diag_mask_inf: function(ctx: Pggml_context; a: Pggml_tensor; n_past: Integer): Pggml_tensor; cdecl;
  ggml_diag_mask_inf_inplace: function(ctx: Pggml_context; a: Pggml_tensor; n_past: Integer): Pggml_tensor; cdecl;
  ggml_diag_mask_zero: function(ctx: Pggml_context; a: Pggml_tensor; n_past: Integer): Pggml_tensor; cdecl;
  ggml_diag_mask_zero_inplace: function(ctx: Pggml_context; a: Pggml_tensor; n_past: Integer): Pggml_tensor; cdecl;
  ggml_soft_max: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_soft_max_inplace: function(ctx: Pggml_context; a: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_soft_max_ext: function(ctx: Pggml_context; a: Pggml_tensor; mask: Pggml_tensor; pos: Pggml_tensor; scale: Single; max_bias: Single): Pggml_tensor; cdecl;
  ggml_soft_max_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_soft_max_back_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_rope: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; n_dims: Integer; mode: Integer; n_ctx: Integer): Pggml_tensor; cdecl;
  ggml_rope_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; n_dims: Integer; mode: Integer; n_ctx: Integer): Pggml_tensor; cdecl;
  ggml_rope_custom: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; n_dims: Integer; mode: Integer; n_ctx: Integer; n_orig_ctx: Integer; freq_base: Single; freq_scale: Single; ext_factor: Single; attn_factor: Single; beta_fast: Single; beta_slow: Single): Pggml_tensor; cdecl;
  ggml_rope_custom_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; n_dims: Integer; mode: Integer; n_ctx: Integer; n_orig_ctx: Integer; freq_base: Single; freq_scale: Single; ext_factor: Single; attn_factor: Single; beta_fast: Single; beta_slow: Single): Pggml_tensor; cdecl;
  ggml_rope_yarn_corr_dims: procedure(n_dims: Integer; n_orig_ctx: Integer; freq_base: Single; beta_fast: Single; beta_slow: Single; dims: PSingle); cdecl;
  ggml_rope_xpos_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; n_dims: Integer; base: Single; down: Boolean): Pggml_tensor; cdecl;
  ggml_rope_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; n_dims: Integer; mode: Integer; n_ctx: Integer; n_orig_ctx: Integer; freq_base: Single; freq_scale: Single; ext_factor: Single; attn_factor: Single; beta_fast: Single; beta_slow: Single; xpos_base: Single; xpos_down: Boolean): Pggml_tensor; cdecl;
  ggml_alibi: function(ctx: Pggml_context; a: Pggml_tensor; n_past: Integer; n_head: Integer; bias_max: Single): Pggml_tensor; cdecl;
  ggml_clamp: function(ctx: Pggml_context; a: Pggml_tensor; min: Single; max: Single): Pggml_tensor; cdecl;
  ggml_im2col: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; s0: Integer; s1: Integer; p0: Integer; p1: Integer; d0: Integer; d1: Integer; is_2D: Boolean; dst_type: ggml_type): Pggml_tensor; cdecl;
  ggml_conv_depthwise_2d: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; s0: Integer; s1: Integer; p0: Integer; p1: Integer; d0: Integer; d1: Integer): Pggml_tensor; cdecl;
  ggml_conv_1d: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; s0: Integer; p0: Integer; d0: Integer): Pggml_tensor; cdecl;
  ggml_conv_1d_ph: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; s: Integer; d: Integer): Pggml_tensor; cdecl;
  ggml_conv_transpose_1d: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; s0: Integer; p0: Integer; d0: Integer): Pggml_tensor; cdecl;
  ggml_conv_2d: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; s0: Integer; s1: Integer; p0: Integer; p1: Integer; d0: Integer; d1: Integer): Pggml_tensor; cdecl;
  ggml_conv_2d_sk_p0: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_conv_2d_s1_ph: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_conv_transpose_2d_p0: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; stride: Integer): Pggml_tensor; cdecl;
  ggml_pool_1d: function(ctx: Pggml_context; a: Pggml_tensor; op: ggml_op_pool; k0: Integer; s0: Integer; p0: Integer): Pggml_tensor; cdecl;
  ggml_pool_2d: function(ctx: Pggml_context; a: Pggml_tensor; op: ggml_op_pool; k0: Integer; k1: Integer; s0: Integer; s1: Integer; p0: Single; p1: Single): Pggml_tensor; cdecl;
  ggml_upscale: function(ctx: Pggml_context; a: Pggml_tensor; scale_factor: Integer): Pggml_tensor; cdecl;
  ggml_pad: function(ctx: Pggml_context; a: Pggml_tensor; p0: Integer; p1: Integer; p2: Integer; p3: Integer): Pggml_tensor; cdecl;
  ggml_timestep_embedding: function(ctx: Pggml_context; timesteps: Pggml_tensor; dim: Integer; max_period: Integer): Pggml_tensor; cdecl;
  ggml_argsort: function(ctx: Pggml_context; a: Pggml_tensor; order: ggml_sort_order): Pggml_tensor; cdecl;
  ggml_arange: function(ctx: Pggml_context; start: Single; stop: Single; step: Single): Pggml_tensor; cdecl;
  ggml_top_k: function(ctx: Pggml_context; a: Pggml_tensor; k: Integer): Pggml_tensor; cdecl;
  ggml_flash_attn: function(ctx: Pggml_context; q: Pggml_tensor; k: Pggml_tensor; v: Pggml_tensor; masked: Boolean): Pggml_tensor; cdecl;
  ggml_flash_attn_back: function(ctx: Pggml_context; q: Pggml_tensor; k: Pggml_tensor; v: Pggml_tensor; d: Pggml_tensor; masked: Boolean): Pggml_tensor; cdecl;
  ggml_flash_ff: function(ctx: Pggml_context; a: Pggml_tensor; b0: Pggml_tensor; b1: Pggml_tensor; c0: Pggml_tensor; c1: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_ssm_conv: function(ctx: Pggml_context; s: Pggml_tensor; x: Pggml_tensor; c: Pggml_tensor; sq: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_ssm_scan: function(ctx: Pggml_context; s: Pggml_tensor; x: Pggml_tensor; dt: Pggml_tensor; A: Pggml_tensor; B: Pggml_tensor; C: Pggml_tensor; sq: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_win_part: function(ctx: Pggml_context; a: Pggml_tensor; w: Integer): Pggml_tensor; cdecl;
  ggml_win_unpart: function(ctx: Pggml_context; a: Pggml_tensor; w0: Integer; h0: Integer; w: Integer): Pggml_tensor; cdecl;
  ggml_unary: function(ctx: Pggml_context; a: Pggml_tensor; op: ggml_unary_op): Pggml_tensor; cdecl;
  ggml_unary_inplace: function(ctx: Pggml_context; a: Pggml_tensor; op: ggml_unary_op): Pggml_tensor; cdecl;
  ggml_get_rel_pos: function(ctx: Pggml_context; a: Pggml_tensor; qh: Integer; kh: Integer): Pggml_tensor; cdecl;
  ggml_add_rel_pos: function(ctx: Pggml_context; a: Pggml_tensor; pw: Pggml_tensor; ph: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_add_rel_pos_inplace: function(ctx: Pggml_context; a: Pggml_tensor; pw: Pggml_tensor; ph: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_map_unary_f32: function(ctx: Pggml_context; a: Pggml_tensor; fun: ggml_unary_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_unary_inplace_f32: function(ctx: Pggml_context; a: Pggml_tensor; fun: ggml_unary_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_binary_f32: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; fun: ggml_binary_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_binary_inplace_f32: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; fun: ggml_binary_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom1_f32: function(ctx: Pggml_context; a: Pggml_tensor; fun: ggml_custom1_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom1_inplace_f32: function(ctx: Pggml_context; a: Pggml_tensor; fun: ggml_custom1_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom2_f32: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; fun: ggml_custom2_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom2_inplace_f32: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; fun: ggml_custom2_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom3_f32: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; c: Pggml_tensor; fun: ggml_custom3_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom3_inplace_f32: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; c: Pggml_tensor; fun: ggml_custom3_op_f32_t): Pggml_tensor; cdecl;
  ggml_map_custom1: function(ctx: Pggml_context; a: Pggml_tensor; fun: ggml_custom1_op_t; n_tasks: Integer; userdata: Pointer): Pggml_tensor; cdecl;
  ggml_map_custom1_inplace: function(ctx: Pggml_context; a: Pggml_tensor; fun: ggml_custom1_op_t; n_tasks: Integer; userdata: Pointer): Pggml_tensor; cdecl;
  ggml_map_custom2: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; fun: ggml_custom2_op_t; n_tasks: Integer; userdata: Pointer): Pggml_tensor; cdecl;
  ggml_map_custom2_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; fun: ggml_custom2_op_t; n_tasks: Integer; userdata: Pointer): Pggml_tensor; cdecl;
  ggml_map_custom3: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; c: Pggml_tensor; fun: ggml_custom3_op_t; n_tasks: Integer; userdata: Pointer): Pggml_tensor; cdecl;
  ggml_map_custom3_inplace: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; c: Pggml_tensor; fun: ggml_custom3_op_t; n_tasks: Integer; userdata: Pointer): Pggml_tensor; cdecl;
  ggml_cross_entropy_loss: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_cross_entropy_loss_back: function(ctx: Pggml_context; a: Pggml_tensor; b: Pggml_tensor; c: Pggml_tensor): Pggml_tensor; cdecl;
  ggml_set_param: procedure(ctx: Pggml_context; tensor: Pggml_tensor); cdecl;
  ggml_build_forward_expand: procedure(cgraph: Pggml_cgraph; tensor: Pggml_tensor); cdecl;
  ggml_build_backward_expand: procedure(ctx: Pggml_context; gf: Pggml_cgraph; gb: Pggml_cgraph; keep: Boolean); cdecl;
  ggml_new_graph: function(ctx: Pggml_context): Pggml_cgraph; cdecl;
  ggml_new_graph_custom: function(ctx: Pggml_context; size: NativeUInt; grads: Boolean): Pggml_cgraph; cdecl;
  ggml_graph_dup: function(ctx: Pggml_context; cgraph: Pggml_cgraph): Pggml_cgraph; cdecl;
  ggml_graph_view: function(cgraph: Pggml_cgraph; i0: Integer; i1: Integer): ggml_cgraph; cdecl;
  ggml_graph_cpy: procedure(src: Pggml_cgraph; dst: Pggml_cgraph); cdecl;
  ggml_graph_reset: procedure(cgraph: Pggml_cgraph); cdecl;
  ggml_graph_clear: procedure(cgraph: Pggml_cgraph); cdecl;
  ggml_graph_overhead: function(): NativeUInt; cdecl;
  ggml_graph_overhead_custom: function(size: NativeUInt; grads: Boolean): NativeUInt; cdecl;
  ggml_graph_plan: function(const cgraph: Pggml_cgraph; n_threads: Integer): ggml_cplan; cdecl;
  ggml_graph_compute: function(cgraph: Pggml_cgraph; cplan: Pggml_cplan): ggml_status; cdecl;
  ggml_graph_compute_with_ctx: function(ctx: Pggml_context; cgraph: Pggml_cgraph; n_threads: Integer): ggml_status; cdecl;
  ggml_graph_get_tensor: function(cgraph: Pggml_cgraph; const name: PUTF8Char): Pggml_tensor; cdecl;
  ggml_graph_export: procedure(const cgraph: Pggml_cgraph; const fname: PUTF8Char); cdecl;
  ggml_graph_import: function(const fname: PUTF8Char; ctx_data: PPggml_context; ctx_eval: PPggml_context): Pggml_cgraph; cdecl;
  ggml_graph_print: procedure(const cgraph: Pggml_cgraph); cdecl;
  ggml_graph_dump_dot: procedure(const gb: Pggml_cgraph; const gf: Pggml_cgraph; const filename: PUTF8Char); cdecl;
  ggml_build_backward_gradient_checkpointing: procedure(ctx: Pggml_context; gf: Pggml_cgraph; gb: Pggml_cgraph; gb_tmp: Pggml_cgraph; checkpoints: PPggml_tensor; n_checkpoints: Integer); cdecl;
  ggml_opt_default_params: function(&type: ggml_opt_type): ggml_opt_params; cdecl;
  ggml_opt: function(ctx: Pggml_context; params: ggml_opt_params; f: Pggml_tensor): ggml_opt_result; cdecl;
  ggml_opt_init: procedure(ctx: Pggml_context; opt: Pggml_opt_context; params: ggml_opt_params; nx: Int64); cdecl;
  ggml_opt_resume: function(ctx: Pggml_context; opt: Pggml_opt_context; f: Pggml_tensor): ggml_opt_result; cdecl;
  ggml_opt_resume_g: function(ctx: Pggml_context; opt: Pggml_opt_context; f: Pggml_tensor; gf: Pggml_cgraph; gb: Pggml_cgraph; callback: ggml_opt_callback; callback_data: Pointer): ggml_opt_result; cdecl;
  ggml_set_input: procedure(tensor: Pggml_tensor); cdecl;
  ggml_set_output: procedure(tensor: Pggml_tensor); cdecl;
  ggml_quantize_init: procedure(&type: ggml_type); cdecl;
  ggml_quantize_free: procedure(); cdecl;
  ggml_quantize_requires_imatrix: function(&type: ggml_type): Boolean; cdecl;
  ggml_quantize_chunk: function(&type: ggml_type; const src: PSingle; dst: Pointer; start: Int64; nrows: Int64; n_per_row: Int64; const imatrix: PSingle): NativeUInt; cdecl;
  gguf_init_empty: function(): Pgguf_context; cdecl;
  gguf_init_from_file: function(const fname: PUTF8Char; params: gguf_init_params): Pgguf_context; cdecl;
  gguf_free: procedure(ctx: Pgguf_context); cdecl;
  gguf_type_name: function(&type: gguf_type): PUTF8Char; cdecl;
  gguf_get_version: function(const ctx: Pgguf_context): Integer; cdecl;
  gguf_get_alignment: function(const ctx: Pgguf_context): NativeUInt; cdecl;
  gguf_get_data_offset: function(const ctx: Pgguf_context): NativeUInt; cdecl;
  gguf_get_data: function(const ctx: Pgguf_context): Pointer; cdecl;
  gguf_get_n_kv: function(const ctx: Pgguf_context): Integer; cdecl;
  gguf_find_key: function(const ctx: Pgguf_context; const key: PUTF8Char): Integer; cdecl;
  gguf_get_key: function(const ctx: Pgguf_context; key_id: Integer): PUTF8Char; cdecl;
  gguf_get_kv_type: function(const ctx: Pgguf_context; key_id: Integer): gguf_type; cdecl;
  gguf_get_arr_type: function(const ctx: Pgguf_context; key_id: Integer): gguf_type; cdecl;
  gguf_get_val_u8: function(const ctx: Pgguf_context; key_id: Integer): UInt8; cdecl;
  gguf_get_val_i8: function(const ctx: Pgguf_context; key_id: Integer): Int8; cdecl;
  gguf_get_val_u16: function(const ctx: Pgguf_context; key_id: Integer): UInt16; cdecl;
  gguf_get_val_i16: function(const ctx: Pgguf_context; key_id: Integer): Int16; cdecl;
  gguf_get_val_u32: function(const ctx: Pgguf_context; key_id: Integer): UInt32; cdecl;
  gguf_get_val_i32: function(const ctx: Pgguf_context; key_id: Integer): Int32; cdecl;
  gguf_get_val_f32: function(const ctx: Pgguf_context; key_id: Integer): Single; cdecl;
  gguf_get_val_u64: function(const ctx: Pgguf_context; key_id: Integer): UInt64; cdecl;
  gguf_get_val_i64: function(const ctx: Pgguf_context; key_id: Integer): Int64; cdecl;
  gguf_get_val_f64: function(const ctx: Pgguf_context; key_id: Integer): Double; cdecl;
  gguf_get_val_bool: function(const ctx: Pgguf_context; key_id: Integer): Boolean; cdecl;
  gguf_get_val_str: function(const ctx: Pgguf_context; key_id: Integer): PUTF8Char; cdecl;
  gguf_get_val_data: function(const ctx: Pgguf_context; key_id: Integer): Pointer; cdecl;
  gguf_get_arr_n: function(const ctx: Pgguf_context; key_id: Integer): Integer; cdecl;
  gguf_get_arr_data: function(const ctx: Pgguf_context; key_id: Integer): Pointer; cdecl;
  gguf_get_arr_str: function(const ctx: Pgguf_context; key_id: Integer; i: Integer): PUTF8Char; cdecl;
  gguf_get_n_tensors: function(const ctx: Pgguf_context): Integer; cdecl;
  gguf_find_tensor: function(const ctx: Pgguf_context; const name: PUTF8Char): Integer; cdecl;
  gguf_get_tensor_offset: function(const ctx: Pgguf_context; i: Integer): NativeUInt; cdecl;
  gguf_get_tensor_name: function(const ctx: Pgguf_context; i: Integer): PUTF8Char; cdecl;
  gguf_get_tensor_type: function(const ctx: Pgguf_context; i: Integer): ggml_type; cdecl;
  gguf_set_val_u8: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: UInt8); cdecl;
  gguf_set_val_i8: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Int8); cdecl;
  gguf_set_val_u16: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: UInt16); cdecl;
  gguf_set_val_i16: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Int16); cdecl;
  gguf_set_val_u32: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: UInt32); cdecl;
  gguf_set_val_i32: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Int32); cdecl;
  gguf_set_val_f32: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Single); cdecl;
  gguf_set_val_u64: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: UInt64); cdecl;
  gguf_set_val_i64: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Int64); cdecl;
  gguf_set_val_f64: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Double); cdecl;
  gguf_set_val_bool: procedure(ctx: Pgguf_context; const key: PUTF8Char; val: Boolean); cdecl;
  gguf_set_val_str: procedure(ctx: Pgguf_context; const key: PUTF8Char; const val: PUTF8Char); cdecl;
  gguf_set_arr_data: procedure(ctx: Pgguf_context; const key: PUTF8Char; &type: gguf_type; const data: Pointer; n: Integer); cdecl;
  gguf_set_arr_str: procedure(ctx: Pgguf_context; const key: PUTF8Char; data: PPUTF8Char; n: Integer); cdecl;
  gguf_set_kv: procedure(ctx: Pgguf_context; src: Pgguf_context); cdecl;
  gguf_add_tensor: procedure(ctx: Pgguf_context; const tensor: Pggml_tensor); cdecl;
  gguf_set_tensor_type: procedure(ctx: Pgguf_context; const name: PUTF8Char; &type: ggml_type); cdecl;
  gguf_set_tensor_data: procedure(ctx: Pgguf_context; const name: PUTF8Char; const data: Pointer; size: NativeUInt); cdecl;
  gguf_write_to_file: procedure(const ctx: Pgguf_context; const fname: PUTF8Char; only_meta: Boolean); cdecl;
  gguf_get_meta_size: function(const ctx: Pgguf_context): NativeUInt; cdecl;
  gguf_get_meta_data: procedure(const ctx: Pgguf_context; data: Pointer); cdecl;
  ggml_cpu_has_avx: function(): Integer; cdecl;
  ggml_cpu_has_avx_vnni: function(): Integer; cdecl;
  ggml_cpu_has_avx2: function(): Integer; cdecl;
  ggml_cpu_has_avx512: function(): Integer; cdecl;
  ggml_cpu_has_avx512_vbmi: function(): Integer; cdecl;
  ggml_cpu_has_avx512_vnni: function(): Integer; cdecl;
  ggml_cpu_has_fma: function(): Integer; cdecl;
  ggml_cpu_has_neon: function(): Integer; cdecl;
  ggml_cpu_has_arm_fma: function(): Integer; cdecl;
  ggml_cpu_has_metal: function(): Integer; cdecl;
  ggml_cpu_has_f16c: function(): Integer; cdecl;
  ggml_cpu_has_fp16_va: function(): Integer; cdecl;
  ggml_cpu_has_wasm_simd: function(): Integer; cdecl;
  ggml_cpu_has_blas: function(): Integer; cdecl;
  ggml_cpu_has_cuda: function(): Integer; cdecl;
  ggml_cpu_has_clblast: function(): Integer; cdecl;
  ggml_cpu_has_vulkan: function(): Integer; cdecl;
  ggml_cpu_has_kompute: function(): Integer; cdecl;
  ggml_cpu_has_gpublas: function(): Integer; cdecl;
  ggml_cpu_has_sse3: function(): Integer; cdecl;
  ggml_cpu_has_ssse3: function(): Integer; cdecl;
  ggml_cpu_has_sycl: function(): Integer; cdecl;
  ggml_cpu_has_vsx: function(): Integer; cdecl;
  ggml_cpu_has_matmul_int8: function(): Integer; cdecl;
  ggml_internal_get_type_traits: function(&type: ggml_type): ggml_type_traits_t; cdecl;
  ggml_tallocr_new: function(buffer: ggml_backend_buffer_t): ggml_tallocr; cdecl;
  ggml_tallocr_alloc: procedure(talloc: Pggml_tallocr; tensor: Pggml_tensor); cdecl;
  ggml_gallocr_new: function(buft: ggml_backend_buffer_type_t): ggml_gallocr_t; cdecl;
  ggml_gallocr_new_n: function(bufts: Pggml_backend_buffer_type_t; n_bufs: Integer): ggml_gallocr_t; cdecl;
  ggml_gallocr_free: procedure(galloc: ggml_gallocr_t); cdecl;
  ggml_gallocr_reserve: function(galloc: ggml_gallocr_t; graph: Pggml_cgraph): Boolean; cdecl;
  ggml_gallocr_reserve_n: function(galloc: ggml_gallocr_t; graph: Pggml_cgraph; const node_buffer_ids: PInteger; const leaf_buffer_ids: PInteger): Boolean; cdecl;
  ggml_gallocr_alloc_graph: function(galloc: ggml_gallocr_t; graph: Pggml_cgraph): Boolean; cdecl;
  ggml_gallocr_get_buffer_size: function(galloc: ggml_gallocr_t; buffer_id: Integer): NativeUInt; cdecl;
  ggml_backend_alloc_ctx_tensors_from_buft: function(ctx: Pggml_context; buft: ggml_backend_buffer_type_t): Pggml_backend_buffer; cdecl;
  ggml_backend_alloc_ctx_tensors: function(ctx: Pggml_context; backend: ggml_backend_t): Pggml_backend_buffer; cdecl;
  ggml_backend_buft_name: function(buft: ggml_backend_buffer_type_t): PUTF8Char; cdecl;
  ggml_backend_buft_alloc_buffer: function(buft: ggml_backend_buffer_type_t; size: NativeUInt): ggml_backend_buffer_t; cdecl;
  ggml_backend_buft_get_alignment: function(buft: ggml_backend_buffer_type_t): NativeUInt; cdecl;
  ggml_backend_buft_get_max_size: function(buft: ggml_backend_buffer_type_t): NativeUInt; cdecl;
  ggml_backend_buft_get_alloc_size: function(buft: ggml_backend_buffer_type_t; tensor: Pggml_tensor): NativeUInt; cdecl;
  ggml_backend_buft_supports_backend: function(buft: ggml_backend_buffer_type_t; backend: ggml_backend_t): Boolean; cdecl;
  ggml_backend_buft_is_host: function(buft: ggml_backend_buffer_type_t): Boolean; cdecl;
  ggml_backend_buffer_name: function(buffer: ggml_backend_buffer_t): PUTF8Char; cdecl;
  ggml_backend_buffer_free: procedure(buffer: ggml_backend_buffer_t); cdecl;
  ggml_backend_buffer_get_base: function(buffer: ggml_backend_buffer_t): Pointer; cdecl;
  ggml_backend_buffer_get_size: function(buffer: ggml_backend_buffer_t): NativeUInt; cdecl;
  ggml_backend_buffer_init_tensor: procedure(buffer: ggml_backend_buffer_t; tensor: Pggml_tensor); cdecl;
  ggml_backend_buffer_get_alignment: function(buffer: ggml_backend_buffer_t): NativeUInt; cdecl;
  ggml_backend_buffer_get_max_size: function(buffer: ggml_backend_buffer_t): NativeUInt; cdecl;
  ggml_backend_buffer_get_alloc_size: function(buffer: ggml_backend_buffer_t; tensor: Pggml_tensor): NativeUInt; cdecl;
  ggml_backend_buffer_clear: procedure(buffer: ggml_backend_buffer_t; value: UInt8); cdecl;
  ggml_backend_buffer_is_host: function(buffer: ggml_backend_buffer_t): Boolean; cdecl;
  ggml_backend_buffer_set_usage: procedure(buffer: ggml_backend_buffer_t; usage: ggml_backend_buffer_usage); cdecl;
  ggml_backend_buffer_get_type: function(buffer: ggml_backend_buffer_t): ggml_backend_buffer_type_t; cdecl;
  ggml_backend_buffer_reset: procedure(buffer: ggml_backend_buffer_t); cdecl;
  ggml_backend_guid: function(backend: ggml_backend_t): ggml_guid_t; cdecl;
  ggml_backend_name: function(backend: ggml_backend_t): PUTF8Char; cdecl;
  ggml_backend_free: procedure(backend: ggml_backend_t); cdecl;
  ggml_backend_get_default_buffer_type: function(backend: ggml_backend_t): ggml_backend_buffer_type_t; cdecl;
  ggml_backend_alloc_buffer: function(backend: ggml_backend_t; size: NativeUInt): ggml_backend_buffer_t; cdecl;
  ggml_backend_get_alignment: function(backend: ggml_backend_t): NativeUInt; cdecl;
  ggml_backend_get_max_size: function(backend: ggml_backend_t): NativeUInt; cdecl;
  ggml_backend_tensor_set_async: procedure(backend: ggml_backend_t; tensor: Pggml_tensor; const data: Pointer; offset: NativeUInt; size: NativeUInt); cdecl;
  ggml_backend_tensor_get_async: procedure(backend: ggml_backend_t; const tensor: Pggml_tensor; data: Pointer; offset: NativeUInt; size: NativeUInt); cdecl;
  ggml_backend_tensor_set: procedure(tensor: Pggml_tensor; const data: Pointer; offset: NativeUInt; size: NativeUInt); cdecl;
  ggml_backend_tensor_get: procedure(const tensor: Pggml_tensor; data: Pointer; offset: NativeUInt; size: NativeUInt); cdecl;
  ggml_backend_synchronize: procedure(backend: ggml_backend_t); cdecl;
  ggml_backend_graph_plan_create: function(backend: ggml_backend_t; cgraph: Pggml_cgraph): ggml_backend_graph_plan_t; cdecl;
  ggml_backend_graph_plan_free: procedure(backend: ggml_backend_t; plan: ggml_backend_graph_plan_t); cdecl;
  ggml_backend_graph_plan_compute: function(backend: ggml_backend_t; plan: ggml_backend_graph_plan_t): ggml_status; cdecl;
  ggml_backend_graph_compute: function(backend: ggml_backend_t; cgraph: Pggml_cgraph): ggml_status; cdecl;
  ggml_backend_graph_compute_async: function(backend: ggml_backend_t; cgraph: Pggml_cgraph): ggml_status; cdecl;
  ggml_backend_supports_op: function(backend: ggml_backend_t; const op: Pggml_tensor): Boolean; cdecl;
  ggml_backend_offload_op: function(backend: ggml_backend_t; const op: Pggml_tensor): Boolean; cdecl;
  ggml_backend_tensor_copy: procedure(src: Pggml_tensor; dst: Pggml_tensor); cdecl;
  ggml_backend_tensor_copy_async: procedure(backend_src: ggml_backend_t; backend_dst: ggml_backend_t; src: Pggml_tensor; dst: Pggml_tensor); cdecl;
  ggml_backend_event_new: function(backend: ggml_backend_t): ggml_backend_event_t; cdecl;
  ggml_backend_event_free: procedure(event: ggml_backend_event_t); cdecl;
  ggml_backend_event_record: procedure(event: ggml_backend_event_t); cdecl;
  ggml_backend_event_synchronize: procedure(event: ggml_backend_event_t); cdecl;
  ggml_backend_event_wait: procedure(backend: ggml_backend_t; event: ggml_backend_event_t); cdecl;
  ggml_backend_cpu_init: function(): ggml_backend_t; cdecl;
  ggml_backend_is_cpu: function(backend: ggml_backend_t): Boolean; cdecl;
  ggml_backend_cpu_set_n_threads: procedure(backend_cpu: ggml_backend_t; n_threads: Integer); cdecl;
  ggml_backend_cpu_set_abort_callback: procedure(backend_cpu: ggml_backend_t; abort_callback: ggml_abort_callback; abort_callback_data: Pointer); cdecl;
  ggml_backend_cpu_buffer_from_ptr: function(ptr: Pointer; size: NativeUInt): ggml_backend_buffer_t; cdecl;
  ggml_backend_cpu_buffer_type: function(): ggml_backend_buffer_type_t; cdecl;
  ggml_backend_reg_get_count: function(): NativeUInt; cdecl;
  ggml_backend_reg_find_by_name: function(const name: PUTF8Char): NativeUInt; cdecl;
  ggml_backend_reg_init_backend_from_str: function(const backend_str: PUTF8Char): ggml_backend_t; cdecl;
  ggml_backend_reg_get_name: function(i: NativeUInt): PUTF8Char; cdecl;
  ggml_backend_reg_init_backend: function(i: NativeUInt; const params: PUTF8Char): ggml_backend_t; cdecl;
  ggml_backend_reg_get_default_buffer_type: function(i: NativeUInt): ggml_backend_buffer_type_t; cdecl;
  ggml_backend_reg_alloc_buffer: function(i: NativeUInt; size: NativeUInt): ggml_backend_buffer_t; cdecl;
  ggml_backend_sched_new: function(backends: Pggml_backend_t; bufts: Pggml_backend_buffer_type_t; n_backends: Integer; graph_size: NativeUInt; parallel: Boolean): ggml_backend_sched_t; cdecl;
  ggml_backend_sched_free: procedure(sched: ggml_backend_sched_t); cdecl;
  ggml_backend_sched_reserve: function(sched: ggml_backend_sched_t; measure_graph: Pggml_cgraph): Boolean; cdecl;
  ggml_backend_sched_get_n_splits: function(sched: ggml_backend_sched_t): Integer; cdecl;
  ggml_backend_sched_get_n_copies: function(sched: ggml_backend_sched_t): Integer; cdecl;
  ggml_backend_sched_get_buffer_size: function(sched: ggml_backend_sched_t; backend: ggml_backend_t): NativeUInt; cdecl;
  ggml_backend_sched_set_tensor_backend: procedure(sched: ggml_backend_sched_t; node: Pggml_tensor; backend: ggml_backend_t); cdecl;
  ggml_backend_sched_get_tensor_backend: function(sched: ggml_backend_sched_t; node: Pggml_tensor): ggml_backend_t; cdecl;
  ggml_backend_sched_alloc_graph: function(sched: ggml_backend_sched_t; graph: Pggml_cgraph): Boolean; cdecl;
  ggml_backend_sched_graph_compute: function(sched: ggml_backend_sched_t; graph: Pggml_cgraph): ggml_status; cdecl;
  ggml_backend_sched_graph_compute_async: function(sched: ggml_backend_sched_t; graph: Pggml_cgraph): ggml_status; cdecl;
  ggml_backend_sched_synchronize: procedure(sched: ggml_backend_sched_t); cdecl;
  ggml_backend_sched_reset: procedure(sched: ggml_backend_sched_t); cdecl;
  ggml_backend_sched_set_eval_callback: procedure(sched: ggml_backend_sched_t; callback: ggml_backend_sched_eval_callback; user_data: Pointer); cdecl;
  ggml_backend_graph_copy_rtn: function(backend: ggml_backend_t; graph: Pggml_cgraph): ggml_backend_graph_copy; cdecl;
  ggml_backend_graph_copy_free: procedure(copy: ggml_backend_graph_copy); cdecl;
  ggml_backend_compare_graph_backend: function(backend1: ggml_backend_t; backend2: ggml_backend_t; graph: Pggml_cgraph; callback: ggml_backend_eval_callback; user_data: Pointer): Boolean; cdecl;
  ggml_backend_tensor_alloc: procedure(buffer: ggml_backend_buffer_t; tensor: Pggml_tensor; addr: Pointer); cdecl;
  ggml_backend_view_init: procedure(buffer: ggml_backend_buffer_t; tensor: Pggml_tensor); cdecl;
  llama_model_default_params: function(): llama_model_params; cdecl;
  llama_context_default_params: function(): llama_context_params; cdecl;
  llama_model_quantize_default_params: function(): llama_model_quantize_params; cdecl;
  llama_backend_init: procedure(); cdecl;
  llama_numa_init: procedure(numa: ggml_numa_strategy); cdecl;
  llama_backend_free: procedure(); cdecl;
  llama_load_model_from_file: function(const path_model: PUTF8Char; params: llama_model_params): Pllama_model; cdecl;
  llama_free_model: procedure(model: Pllama_model); cdecl;
  llama_new_context_with_model: function(model: Pllama_model; params: llama_context_params): Pllama_context; cdecl;
  llama_free: procedure(ctx: Pllama_context); cdecl;
  llama_time_us: function(): Int64; cdecl;
  llama_max_devices: function(): NativeUInt; cdecl;
  llama_supports_mmap: function(): Boolean; cdecl;
  llama_supports_mlock: function(): Boolean; cdecl;
  llama_supports_gpu_offload: function(): Boolean; cdecl;
  llama_get_model: function(const ctx: Pllama_context): Pllama_model; cdecl;
  llama_n_ctx: function(const ctx: Pllama_context): UInt32; cdecl;
  llama_n_batch: function(const ctx: Pllama_context): UInt32; cdecl;
  llama_n_ubatch: function(const ctx: Pllama_context): UInt32; cdecl;
  llama_n_seq_max: function(const ctx: Pllama_context): UInt32; cdecl;
  llama_vocab_type_rtn: function(const model: Pllama_model): llama_vocab_type; cdecl;
  llama_rope_type_rtn: function(const model: Pllama_model): llama_rope_type; cdecl;
  llama_n_vocab: function(const model: Pllama_model): Int32; cdecl;
  llama_n_ctx_train: function(const model: Pllama_model): Int32; cdecl;
  llama_n_embd: function(const model: Pllama_model): Int32; cdecl;
  llama_n_layer: function(const model: Pllama_model): Int32; cdecl;
  llama_rope_freq_scale_train: function(const model: Pllama_model): Single; cdecl;
  llama_model_meta_val_str: function(const model: Pllama_model; const key: PUTF8Char; buf: PUTF8Char; buf_size: NativeUInt): Int32; cdecl;
  llama_model_meta_count: function(const model: Pllama_model): Int32; cdecl;
  llama_model_meta_key_by_index: function(const model: Pllama_model; i: Int32; buf: PUTF8Char; buf_size: NativeUInt): Int32; cdecl;
  llama_model_meta_val_str_by_index: function(const model: Pllama_model; i: Int32; buf: PUTF8Char; buf_size: NativeUInt): Int32; cdecl;
  llama_model_desc: function(const model: Pllama_model; buf: PUTF8Char; buf_size: NativeUInt): Int32; cdecl;
  llama_model_size: function(const model: Pllama_model): UInt64; cdecl;
  llama_model_n_params: function(const model: Pllama_model): UInt64; cdecl;
  llama_get_model_tensor: function(model: Pllama_model; const name: PUTF8Char): Pggml_tensor; cdecl;
  llama_model_quantize: function(const fname_inp: PUTF8Char; const fname_out: PUTF8Char; const params: Pllama_model_quantize_params): UInt32; cdecl;
  llama_model_apply_lora_from_file: function(const model: Pllama_model; const path_lora: PUTF8Char; scale: Single; const path_base_model: PUTF8Char; n_threads: Int32): Int32; cdecl;
  llama_control_vector_apply: function(lctx: Pllama_context; const data: PSingle; len: NativeUInt; n_embd: Int32; il_start: Int32; il_end: Int32): Int32; cdecl;
  llama_kv_cache_view_init: function(const ctx: Pllama_context; n_seq_max: Int32): llama_kv_cache_view; cdecl;
  llama_kv_cache_view_free: procedure(view: Pllama_kv_cache_view); cdecl;
  llama_kv_cache_view_update: procedure(const ctx: Pllama_context; view: Pllama_kv_cache_view); cdecl;
  llama_get_kv_cache_token_count: function(const ctx: Pllama_context): Int32; cdecl;
  llama_get_kv_cache_used_cells: function(const ctx: Pllama_context): Int32; cdecl;
  llama_kv_cache_clear: procedure(ctx: Pllama_context); cdecl;
  llama_kv_cache_seq_rm: function(ctx: Pllama_context; seq_id: llama_seq_id; p0: llama_pos; p1: llama_pos): Boolean; cdecl;
  llama_kv_cache_seq_cp: procedure(ctx: Pllama_context; seq_id_src: llama_seq_id; seq_id_dst: llama_seq_id; p0: llama_pos; p1: llama_pos); cdecl;
  llama_kv_cache_seq_keep: procedure(ctx: Pllama_context; seq_id: llama_seq_id); cdecl;
  llama_kv_cache_seq_add: procedure(ctx: Pllama_context; seq_id: llama_seq_id; p0: llama_pos; p1: llama_pos; delta: llama_pos); cdecl;
  llama_kv_cache_seq_div: procedure(ctx: Pllama_context; seq_id: llama_seq_id; p0: llama_pos; p1: llama_pos; d: Integer); cdecl;
  llama_kv_cache_seq_pos_max: function(ctx: Pllama_context; seq_id: llama_seq_id): llama_pos; cdecl;
  llama_kv_cache_defrag: procedure(ctx: Pllama_context); cdecl;
  llama_kv_cache_update: procedure(ctx: Pllama_context); cdecl;
  llama_state_get_size: function(const ctx: Pllama_context): NativeUInt; cdecl;
  llama_get_state_size: function(const ctx: Pllama_context): NativeUInt; cdecl;
  llama_state_get_data: function(ctx: Pllama_context; dst: PUInt8): NativeUInt; cdecl;
  llama_copy_state_data: function(ctx: Pllama_context; dst: PUInt8): NativeUInt; cdecl;
  llama_state_set_data: function(ctx: Pllama_context; const src: PUInt8): NativeUInt; cdecl;
  llama_set_state_data: function(ctx: Pllama_context; const src: PUInt8): NativeUInt; cdecl;
  llama_state_load_file: function(ctx: Pllama_context; const path_session: PUTF8Char; tokens_out: Pllama_token; n_token_capacity: NativeUInt; n_token_count_out: PNativeUInt): Boolean; cdecl;
  llama_load_session_file: function(ctx: Pllama_context; const path_session: PUTF8Char; tokens_out: Pllama_token; n_token_capacity: NativeUInt; n_token_count_out: PNativeUInt): Boolean; cdecl;
  llama_state_save_file: function(ctx: Pllama_context; const path_session: PUTF8Char; const tokens: Pllama_token; n_token_count: NativeUInt): Boolean; cdecl;
  llama_save_session_file: function(ctx: Pllama_context; const path_session: PUTF8Char; const tokens: Pllama_token; n_token_count: NativeUInt): Boolean; cdecl;
  llama_state_seq_get_size: function(ctx: Pllama_context; seq_id: llama_seq_id): NativeUInt; cdecl;
  llama_state_seq_get_data: function(ctx: Pllama_context; dst: PUInt8; seq_id: llama_seq_id): NativeUInt; cdecl;
  llama_state_seq_set_data: function(ctx: Pllama_context; const src: PUInt8; dest_seq_id: llama_seq_id): NativeUInt; cdecl;
  llama_state_seq_save_file: function(ctx: Pllama_context; const filepath: PUTF8Char; seq_id: llama_seq_id; const tokens: Pllama_token; n_token_count: NativeUInt): NativeUInt; cdecl;
  llama_state_seq_load_file: function(ctx: Pllama_context; const filepath: PUTF8Char; dest_seq_id: llama_seq_id; tokens_out: Pllama_token; n_token_capacity: NativeUInt; n_token_count_out: PNativeUInt): NativeUInt; cdecl;
  llama_batch_get_one: function(tokens: Pllama_token; n_tokens: Int32; pos_0: llama_pos; seq_id: llama_seq_id): llama_batch; cdecl;
  llama_batch_init: function(n_tokens: Int32; embd: Int32; n_seq_max: Int32): llama_batch; cdecl;
  llama_batch_free: procedure(batch: llama_batch); cdecl;
  llama_decode: function(ctx: Pllama_context; batch: llama_batch): Int32; cdecl;
  llama_set_n_threads: procedure(ctx: Pllama_context; n_threads: UInt32; n_threads_batch: UInt32); cdecl;
  llama_set_causal_attn: procedure(ctx: Pllama_context; causal_attn: Boolean); cdecl;
  llama_set_abort_callback: procedure(ctx: Pllama_context; abort_callback: ggml_abort_callback; abort_callback_data: Pointer); cdecl;
  llama_synchronize: procedure(ctx: Pllama_context); cdecl;
  llama_get_logits: function(ctx: Pllama_context): PSingle; cdecl;
  llama_get_logits_ith: function(ctx: Pllama_context; i: Int32): PSingle; cdecl;
  llama_get_embeddings: function(ctx: Pllama_context): PSingle; cdecl;
  llama_get_embeddings_ith: function(ctx: Pllama_context; i: Int32): PSingle; cdecl;
  llama_get_embeddings_seq: function(ctx: Pllama_context; seq_id: llama_seq_id): PSingle; cdecl;
  llama_token_get_text: function(const model: Pllama_model; token: llama_token): PUTF8Char; cdecl;
  llama_token_get_score: function(const model: Pllama_model; token: llama_token): Single; cdecl;
  llama_token_get_type: function(const model: Pllama_model; token: llama_token): llama_token_type; cdecl;
  llama_token_bos: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_eos: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_cls: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_sep: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_nl: function(const model: Pllama_model): llama_token; cdecl;
  llama_add_bos_token: function(const model: Pllama_model): Int32; cdecl;
  llama_add_eos_token: function(const model: Pllama_model): Int32; cdecl;
  llama_token_prefix: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_middle: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_suffix: function(const model: Pllama_model): llama_token; cdecl;
  llama_token_eot: function(const model: Pllama_model): llama_token; cdecl;
  llama_tokenize: function(const model: Pllama_model; const text: PUTF8Char; text_len: Int32; tokens: Pllama_token; n_tokens_max: Int32; add_special: Boolean; parse_special: Boolean): Int32; cdecl;
  llama_token_to_piece: function(const model: Pllama_model; token: llama_token; buf: PUTF8Char; length: Int32): Int32; cdecl;
  llama_chat_apply_template: function(const model: Pllama_model; const tmpl: PUTF8Char; const chat: Pllama_chat_message; n_msg: NativeUInt; add_ass: Boolean; buf: PUTF8Char; length: Int32): Int32; cdecl;
  llama_grammar_init: function(rules: PPllama_grammar_element; n_rules: NativeUInt; start_rule_index: NativeUInt): Pllama_grammar; cdecl;
  llama_grammar_free: procedure(grammar: Pllama_grammar); cdecl;
  llama_grammar_copy: function(const grammar: Pllama_grammar): Pllama_grammar; cdecl;
  llama_set_rng_seed: procedure(ctx: Pllama_context; seed: UInt32); cdecl;
  llama_sample_repetition_penalties: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; const last_tokens: Pllama_token; penalty_last_n: NativeUInt; penalty_repeat: Single; penalty_freq: Single; penalty_present: Single); cdecl;
  llama_sample_apply_guidance: procedure(ctx: Pllama_context; logits: PSingle; logits_guidance: PSingle; scale: Single); cdecl;
  llama_sample_softmax: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array); cdecl;
  llama_sample_top_k: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; k: Int32; min_keep: NativeUInt); cdecl;
  llama_sample_top_p: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; p: Single; min_keep: NativeUInt); cdecl;
  llama_sample_min_p: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; p: Single; min_keep: NativeUInt); cdecl;
  llama_sample_tail_free: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; z: Single; min_keep: NativeUInt); cdecl;
  llama_sample_typical: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; p: Single; min_keep: NativeUInt); cdecl;
  llama_sample_entropy: procedure(ctx: Pllama_context; candidates_p: Pllama_token_data_array; min_temp: Single; max_temp: Single; exponent_val: Single); cdecl;
  llama_sample_temp: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; temp: Single); cdecl;
  llama_sample_grammar: procedure(ctx: Pllama_context; candidates: Pllama_token_data_array; const grammar: Pllama_grammar); cdecl;
  llama_sample_token_mirostat: function(ctx: Pllama_context; candidates: Pllama_token_data_array; tau: Single; eta: Single; m: Int32; mu: PSingle): llama_token; cdecl;
  llama_sample_token_mirostat_v2: function(ctx: Pllama_context; candidates: Pllama_token_data_array; tau: Single; eta: Single; mu: PSingle): llama_token; cdecl;
  llama_sample_token_greedy: function(ctx: Pllama_context; candidates: Pllama_token_data_array): llama_token; cdecl;
  llama_sample_token: function(ctx: Pllama_context; candidates: Pllama_token_data_array): llama_token; cdecl;
  llama_grammar_accept_token: procedure(ctx: Pllama_context; grammar: Pllama_grammar; token: llama_token); cdecl;
  llama_beam_search: procedure(ctx: Pllama_context; callback: llama_beam_search_callback_fn_t; callback_data: Pointer; n_beams: NativeUInt; n_past: Int32; n_predict: Int32); cdecl;
  llama_split_path: function(split_path: PUTF8Char; maxlen: NativeUInt; const path_prefix: PUTF8Char; split_no: Integer; split_count: Integer): Integer; cdecl;
  llama_split_prefix: function(split_prefix: PUTF8Char; maxlen: NativeUInt; const split_path: PUTF8Char; split_no: Integer; split_count: Integer): Integer; cdecl;
  llama_get_timings: function(ctx: Pllama_context): llama_timings; cdecl;
  llama_print_timings: procedure(ctx: Pllama_context); cdecl;
  llama_reset_timings: procedure(ctx: Pllama_context); cdecl;
  llama_print_system_info: function(): PUTF8Char; cdecl;
  llama_log_set: procedure(log_callback: ggml_log_callback; user_data: Pointer); cdecl;
  llama_dump_timing_info_yaml: procedure(stream: PPointer; const ctx: Pllama_context); cdecl;
  redirect_cerr_to_callback: procedure(callback: cerr_callback; user_data: Pointer); cdecl;
  restore_cerr: procedure(); cdecl;

procedure GetExports(const aDLLHandle: THandle);

implementation

procedure GetExports(const aDLLHandle: THandle);
begin
  if aDllHandle = 0 then Exit;
  ggml_abs := GetProcAddress(aDLLHandle, 'ggml_abs');
  ggml_abs_inplace := GetProcAddress(aDLLHandle, 'ggml_abs_inplace');
  ggml_acc := GetProcAddress(aDLLHandle, 'ggml_acc');
  ggml_acc_inplace := GetProcAddress(aDLLHandle, 'ggml_acc_inplace');
  ggml_add := GetProcAddress(aDLLHandle, 'ggml_add');
  ggml_add_cast := GetProcAddress(aDLLHandle, 'ggml_add_cast');
  ggml_add_inplace := GetProcAddress(aDLLHandle, 'ggml_add_inplace');
  ggml_add_rel_pos := GetProcAddress(aDLLHandle, 'ggml_add_rel_pos');
  ggml_add_rel_pos_inplace := GetProcAddress(aDLLHandle, 'ggml_add_rel_pos_inplace');
  ggml_add1 := GetProcAddress(aDLLHandle, 'ggml_add1');
  ggml_add1_inplace := GetProcAddress(aDLLHandle, 'ggml_add1_inplace');
  ggml_alibi := GetProcAddress(aDLLHandle, 'ggml_alibi');
  ggml_arange := GetProcAddress(aDLLHandle, 'ggml_arange');
  ggml_are_same_shape := GetProcAddress(aDLLHandle, 'ggml_are_same_shape');
  ggml_argmax := GetProcAddress(aDLLHandle, 'ggml_argmax');
  ggml_argsort := GetProcAddress(aDLLHandle, 'ggml_argsort');
  ggml_backend_alloc_buffer := GetProcAddress(aDLLHandle, 'ggml_backend_alloc_buffer');
  ggml_backend_alloc_ctx_tensors := GetProcAddress(aDLLHandle, 'ggml_backend_alloc_ctx_tensors');
  ggml_backend_alloc_ctx_tensors_from_buft := GetProcAddress(aDLLHandle, 'ggml_backend_alloc_ctx_tensors_from_buft');
  ggml_backend_buffer_clear := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_clear');
  ggml_backend_buffer_free := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_free');
  ggml_backend_buffer_get_alignment := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_get_alignment');
  ggml_backend_buffer_get_alloc_size := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_get_alloc_size');
  ggml_backend_buffer_get_base := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_get_base');
  ggml_backend_buffer_get_max_size := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_get_max_size');
  ggml_backend_buffer_get_size := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_get_size');
  ggml_backend_buffer_get_type := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_get_type');
  ggml_backend_buffer_init_tensor := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_init_tensor');
  ggml_backend_buffer_is_host := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_is_host');
  ggml_backend_buffer_name := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_name');
  ggml_backend_buffer_reset := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_reset');
  ggml_backend_buffer_set_usage := GetProcAddress(aDLLHandle, 'ggml_backend_buffer_set_usage');
  ggml_backend_buft_alloc_buffer := GetProcAddress(aDLLHandle, 'ggml_backend_buft_alloc_buffer');
  ggml_backend_buft_get_alignment := GetProcAddress(aDLLHandle, 'ggml_backend_buft_get_alignment');
  ggml_backend_buft_get_alloc_size := GetProcAddress(aDLLHandle, 'ggml_backend_buft_get_alloc_size');
  ggml_backend_buft_get_max_size := GetProcAddress(aDLLHandle, 'ggml_backend_buft_get_max_size');
  ggml_backend_buft_is_host := GetProcAddress(aDLLHandle, 'ggml_backend_buft_is_host');
  ggml_backend_buft_name := GetProcAddress(aDLLHandle, 'ggml_backend_buft_name');
  ggml_backend_buft_supports_backend := GetProcAddress(aDLLHandle, 'ggml_backend_buft_supports_backend');
  ggml_backend_compare_graph_backend := GetProcAddress(aDLLHandle, 'ggml_backend_compare_graph_backend');
  ggml_backend_cpu_buffer_from_ptr := GetProcAddress(aDLLHandle, 'ggml_backend_cpu_buffer_from_ptr');
  ggml_backend_cpu_buffer_type := GetProcAddress(aDLLHandle, 'ggml_backend_cpu_buffer_type');
  ggml_backend_cpu_init := GetProcAddress(aDLLHandle, 'ggml_backend_cpu_init');
  ggml_backend_cpu_set_abort_callback := GetProcAddress(aDLLHandle, 'ggml_backend_cpu_set_abort_callback');
  ggml_backend_cpu_set_n_threads := GetProcAddress(aDLLHandle, 'ggml_backend_cpu_set_n_threads');
  ggml_backend_event_free := GetProcAddress(aDLLHandle, 'ggml_backend_event_free');
  ggml_backend_event_new := GetProcAddress(aDLLHandle, 'ggml_backend_event_new');
  ggml_backend_event_record := GetProcAddress(aDLLHandle, 'ggml_backend_event_record');
  ggml_backend_event_synchronize := GetProcAddress(aDLLHandle, 'ggml_backend_event_synchronize');
  ggml_backend_event_wait := GetProcAddress(aDLLHandle, 'ggml_backend_event_wait');
  ggml_backend_free := GetProcAddress(aDLLHandle, 'ggml_backend_free');
  ggml_backend_get_alignment := GetProcAddress(aDLLHandle, 'ggml_backend_get_alignment');
  ggml_backend_get_default_buffer_type := GetProcAddress(aDLLHandle, 'ggml_backend_get_default_buffer_type');
  ggml_backend_get_max_size := GetProcAddress(aDLLHandle, 'ggml_backend_get_max_size');
  ggml_backend_graph_compute := GetProcAddress(aDLLHandle, 'ggml_backend_graph_compute');
  ggml_backend_graph_compute_async := GetProcAddress(aDLLHandle, 'ggml_backend_graph_compute_async');
  ggml_backend_graph_copy_free := GetProcAddress(aDLLHandle, 'ggml_backend_graph_copy_free');
  ggml_backend_graph_copy_rtn := GetProcAddress(aDLLHandle, 'ggml_backend_graph_copy');
  ggml_backend_graph_plan_compute := GetProcAddress(aDLLHandle, 'ggml_backend_graph_plan_compute');
  ggml_backend_graph_plan_create := GetProcAddress(aDLLHandle, 'ggml_backend_graph_plan_create');
  ggml_backend_graph_plan_free := GetProcAddress(aDLLHandle, 'ggml_backend_graph_plan_free');
  ggml_backend_guid := GetProcAddress(aDLLHandle, 'ggml_backend_guid');
  ggml_backend_is_cpu := GetProcAddress(aDLLHandle, 'ggml_backend_is_cpu');
  ggml_backend_name := GetProcAddress(aDLLHandle, 'ggml_backend_name');
  ggml_backend_offload_op := GetProcAddress(aDLLHandle, 'ggml_backend_offload_op');
  ggml_backend_reg_alloc_buffer := GetProcAddress(aDLLHandle, 'ggml_backend_reg_alloc_buffer');
  ggml_backend_reg_find_by_name := GetProcAddress(aDLLHandle, 'ggml_backend_reg_find_by_name');
  ggml_backend_reg_get_count := GetProcAddress(aDLLHandle, 'ggml_backend_reg_get_count');
  ggml_backend_reg_get_default_buffer_type := GetProcAddress(aDLLHandle, 'ggml_backend_reg_get_default_buffer_type');
  ggml_backend_reg_get_name := GetProcAddress(aDLLHandle, 'ggml_backend_reg_get_name');
  ggml_backend_reg_init_backend := GetProcAddress(aDLLHandle, 'ggml_backend_reg_init_backend');
  ggml_backend_reg_init_backend_from_str := GetProcAddress(aDLLHandle, 'ggml_backend_reg_init_backend_from_str');
  ggml_backend_sched_alloc_graph := GetProcAddress(aDLLHandle, 'ggml_backend_sched_alloc_graph');
  ggml_backend_sched_free := GetProcAddress(aDLLHandle, 'ggml_backend_sched_free');
  ggml_backend_sched_get_buffer_size := GetProcAddress(aDLLHandle, 'ggml_backend_sched_get_buffer_size');
  ggml_backend_sched_get_n_copies := GetProcAddress(aDLLHandle, 'ggml_backend_sched_get_n_copies');
  ggml_backend_sched_get_n_splits := GetProcAddress(aDLLHandle, 'ggml_backend_sched_get_n_splits');
  ggml_backend_sched_get_tensor_backend := GetProcAddress(aDLLHandle, 'ggml_backend_sched_get_tensor_backend');
  ggml_backend_sched_graph_compute := GetProcAddress(aDLLHandle, 'ggml_backend_sched_graph_compute');
  ggml_backend_sched_graph_compute_async := GetProcAddress(aDLLHandle, 'ggml_backend_sched_graph_compute_async');
  ggml_backend_sched_new := GetProcAddress(aDLLHandle, 'ggml_backend_sched_new');
  ggml_backend_sched_reserve := GetProcAddress(aDLLHandle, 'ggml_backend_sched_reserve');
  ggml_backend_sched_reset := GetProcAddress(aDLLHandle, 'ggml_backend_sched_reset');
  ggml_backend_sched_set_eval_callback := GetProcAddress(aDLLHandle, 'ggml_backend_sched_set_eval_callback');
  ggml_backend_sched_set_tensor_backend := GetProcAddress(aDLLHandle, 'ggml_backend_sched_set_tensor_backend');
  ggml_backend_sched_synchronize := GetProcAddress(aDLLHandle, 'ggml_backend_sched_synchronize');
  ggml_backend_supports_op := GetProcAddress(aDLLHandle, 'ggml_backend_supports_op');
  ggml_backend_synchronize := GetProcAddress(aDLLHandle, 'ggml_backend_synchronize');
  ggml_backend_tensor_alloc := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_alloc');
  ggml_backend_tensor_copy := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_copy');
  ggml_backend_tensor_copy_async := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_copy_async');
  ggml_backend_tensor_get := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_get');
  ggml_backend_tensor_get_async := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_get_async');
  ggml_backend_tensor_set := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_set');
  ggml_backend_tensor_set_async := GetProcAddress(aDLLHandle, 'ggml_backend_tensor_set_async');
  ggml_backend_view_init := GetProcAddress(aDLLHandle, 'ggml_backend_view_init');
  ggml_blck_size := GetProcAddress(aDLLHandle, 'ggml_blck_size');
  ggml_build_backward_expand := GetProcAddress(aDLLHandle, 'ggml_build_backward_expand');
  ggml_build_backward_gradient_checkpointing := GetProcAddress(aDLLHandle, 'ggml_build_backward_gradient_checkpointing');
  ggml_build_forward_expand := GetProcAddress(aDLLHandle, 'ggml_build_forward_expand');
  ggml_cast := GetProcAddress(aDLLHandle, 'ggml_cast');
  ggml_clamp := GetProcAddress(aDLLHandle, 'ggml_clamp');
  ggml_concat := GetProcAddress(aDLLHandle, 'ggml_concat');
  ggml_cont := GetProcAddress(aDLLHandle, 'ggml_cont');
  ggml_cont_1d := GetProcAddress(aDLLHandle, 'ggml_cont_1d');
  ggml_cont_2d := GetProcAddress(aDLLHandle, 'ggml_cont_2d');
  ggml_cont_3d := GetProcAddress(aDLLHandle, 'ggml_cont_3d');
  ggml_cont_4d := GetProcAddress(aDLLHandle, 'ggml_cont_4d');
  ggml_conv_1d := GetProcAddress(aDLLHandle, 'ggml_conv_1d');
  ggml_conv_1d_ph := GetProcAddress(aDLLHandle, 'ggml_conv_1d_ph');
  ggml_conv_2d := GetProcAddress(aDLLHandle, 'ggml_conv_2d');
  ggml_conv_2d_s1_ph := GetProcAddress(aDLLHandle, 'ggml_conv_2d_s1_ph');
  ggml_conv_2d_sk_p0 := GetProcAddress(aDLLHandle, 'ggml_conv_2d_sk_p0');
  ggml_conv_depthwise_2d := GetProcAddress(aDLLHandle, 'ggml_conv_depthwise_2d');
  ggml_conv_transpose_1d := GetProcAddress(aDLLHandle, 'ggml_conv_transpose_1d');
  ggml_conv_transpose_2d_p0 := GetProcAddress(aDLLHandle, 'ggml_conv_transpose_2d_p0');
  ggml_cpu_has_arm_fma := GetProcAddress(aDLLHandle, 'ggml_cpu_has_arm_fma');
  ggml_cpu_has_avx := GetProcAddress(aDLLHandle, 'ggml_cpu_has_avx');
  ggml_cpu_has_avx_vnni := GetProcAddress(aDLLHandle, 'ggml_cpu_has_avx_vnni');
  ggml_cpu_has_avx2 := GetProcAddress(aDLLHandle, 'ggml_cpu_has_avx2');
  ggml_cpu_has_avx512 := GetProcAddress(aDLLHandle, 'ggml_cpu_has_avx512');
  ggml_cpu_has_avx512_vbmi := GetProcAddress(aDLLHandle, 'ggml_cpu_has_avx512_vbmi');
  ggml_cpu_has_avx512_vnni := GetProcAddress(aDLLHandle, 'ggml_cpu_has_avx512_vnni');
  ggml_cpu_has_blas := GetProcAddress(aDLLHandle, 'ggml_cpu_has_blas');
  ggml_cpu_has_clblast := GetProcAddress(aDLLHandle, 'ggml_cpu_has_clblast');
  ggml_cpu_has_cuda := GetProcAddress(aDLLHandle, 'ggml_cpu_has_cuda');
  ggml_cpu_has_f16c := GetProcAddress(aDLLHandle, 'ggml_cpu_has_f16c');
  ggml_cpu_has_fma := GetProcAddress(aDLLHandle, 'ggml_cpu_has_fma');
  ggml_cpu_has_fp16_va := GetProcAddress(aDLLHandle, 'ggml_cpu_has_fp16_va');
  ggml_cpu_has_gpublas := GetProcAddress(aDLLHandle, 'ggml_cpu_has_gpublas');
  ggml_cpu_has_kompute := GetProcAddress(aDLLHandle, 'ggml_cpu_has_kompute');
  ggml_cpu_has_matmul_int8 := GetProcAddress(aDLLHandle, 'ggml_cpu_has_matmul_int8');
  ggml_cpu_has_metal := GetProcAddress(aDLLHandle, 'ggml_cpu_has_metal');
  ggml_cpu_has_neon := GetProcAddress(aDLLHandle, 'ggml_cpu_has_neon');
  ggml_cpu_has_sse3 := GetProcAddress(aDLLHandle, 'ggml_cpu_has_sse3');
  ggml_cpu_has_ssse3 := GetProcAddress(aDLLHandle, 'ggml_cpu_has_ssse3');
  ggml_cpu_has_sycl := GetProcAddress(aDLLHandle, 'ggml_cpu_has_sycl');
  ggml_cpu_has_vsx := GetProcAddress(aDLLHandle, 'ggml_cpu_has_vsx');
  ggml_cpu_has_vulkan := GetProcAddress(aDLLHandle, 'ggml_cpu_has_vulkan');
  ggml_cpu_has_wasm_simd := GetProcAddress(aDLLHandle, 'ggml_cpu_has_wasm_simd');
  ggml_cpy := GetProcAddress(aDLLHandle, 'ggml_cpy');
  ggml_cross_entropy_loss := GetProcAddress(aDLLHandle, 'ggml_cross_entropy_loss');
  ggml_cross_entropy_loss_back := GetProcAddress(aDLLHandle, 'ggml_cross_entropy_loss_back');
  ggml_cycles := GetProcAddress(aDLLHandle, 'ggml_cycles');
  ggml_cycles_per_ms := GetProcAddress(aDLLHandle, 'ggml_cycles_per_ms');
  ggml_diag := GetProcAddress(aDLLHandle, 'ggml_diag');
  ggml_diag_mask_inf := GetProcAddress(aDLLHandle, 'ggml_diag_mask_inf');
  ggml_diag_mask_inf_inplace := GetProcAddress(aDLLHandle, 'ggml_diag_mask_inf_inplace');
  ggml_diag_mask_zero := GetProcAddress(aDLLHandle, 'ggml_diag_mask_zero');
  ggml_diag_mask_zero_inplace := GetProcAddress(aDLLHandle, 'ggml_diag_mask_zero_inplace');
  ggml_div := GetProcAddress(aDLLHandle, 'ggml_div');
  ggml_div_inplace := GetProcAddress(aDLLHandle, 'ggml_div_inplace');
  ggml_dup := GetProcAddress(aDLLHandle, 'ggml_dup');
  ggml_dup_inplace := GetProcAddress(aDLLHandle, 'ggml_dup_inplace');
  ggml_dup_tensor := GetProcAddress(aDLLHandle, 'ggml_dup_tensor');
  ggml_element_size := GetProcAddress(aDLLHandle, 'ggml_element_size');
  ggml_elu := GetProcAddress(aDLLHandle, 'ggml_elu');
  ggml_elu_inplace := GetProcAddress(aDLLHandle, 'ggml_elu_inplace');
  ggml_flash_attn := GetProcAddress(aDLLHandle, 'ggml_flash_attn');
  ggml_flash_attn_back := GetProcAddress(aDLLHandle, 'ggml_flash_attn_back');
  ggml_flash_ff := GetProcAddress(aDLLHandle, 'ggml_flash_ff');
  ggml_fopen := GetProcAddress(aDLLHandle, 'ggml_fopen');
  ggml_format_name := GetProcAddress(aDLLHandle, 'ggml_format_name');
  ggml_fp16_to_fp32 := GetProcAddress(aDLLHandle, 'ggml_fp16_to_fp32');
  ggml_fp16_to_fp32_row := GetProcAddress(aDLLHandle, 'ggml_fp16_to_fp32_row');
  ggml_fp32_to_fp16 := GetProcAddress(aDLLHandle, 'ggml_fp32_to_fp16');
  ggml_fp32_to_fp16_row := GetProcAddress(aDLLHandle, 'ggml_fp32_to_fp16_row');
  ggml_free := GetProcAddress(aDLLHandle, 'ggml_free');
  ggml_ftype_to_ggml_type := GetProcAddress(aDLLHandle, 'ggml_ftype_to_ggml_type');
  ggml_gallocr_alloc_graph := GetProcAddress(aDLLHandle, 'ggml_gallocr_alloc_graph');
  ggml_gallocr_free := GetProcAddress(aDLLHandle, 'ggml_gallocr_free');
  ggml_gallocr_get_buffer_size := GetProcAddress(aDLLHandle, 'ggml_gallocr_get_buffer_size');
  ggml_gallocr_new := GetProcAddress(aDLLHandle, 'ggml_gallocr_new');
  ggml_gallocr_new_n := GetProcAddress(aDLLHandle, 'ggml_gallocr_new_n');
  ggml_gallocr_reserve := GetProcAddress(aDLLHandle, 'ggml_gallocr_reserve');
  ggml_gallocr_reserve_n := GetProcAddress(aDLLHandle, 'ggml_gallocr_reserve_n');
  ggml_gelu := GetProcAddress(aDLLHandle, 'ggml_gelu');
  ggml_gelu_inplace := GetProcAddress(aDLLHandle, 'ggml_gelu_inplace');
  ggml_gelu_quick := GetProcAddress(aDLLHandle, 'ggml_gelu_quick');
  ggml_gelu_quick_inplace := GetProcAddress(aDLLHandle, 'ggml_gelu_quick_inplace');
  ggml_get_data := GetProcAddress(aDLLHandle, 'ggml_get_data');
  ggml_get_data_f32 := GetProcAddress(aDLLHandle, 'ggml_get_data_f32');
  ggml_get_f32_1d := GetProcAddress(aDLLHandle, 'ggml_get_f32_1d');
  ggml_get_f32_nd := GetProcAddress(aDLLHandle, 'ggml_get_f32_nd');
  ggml_get_first_tensor := GetProcAddress(aDLLHandle, 'ggml_get_first_tensor');
  ggml_get_i32_1d := GetProcAddress(aDLLHandle, 'ggml_get_i32_1d');
  ggml_get_i32_nd := GetProcAddress(aDLLHandle, 'ggml_get_i32_nd');
  ggml_get_max_tensor_size := GetProcAddress(aDLLHandle, 'ggml_get_max_tensor_size');
  ggml_get_mem_buffer := GetProcAddress(aDLLHandle, 'ggml_get_mem_buffer');
  ggml_get_mem_size := GetProcAddress(aDLLHandle, 'ggml_get_mem_size');
  ggml_get_name := GetProcAddress(aDLLHandle, 'ggml_get_name');
  ggml_get_next_tensor := GetProcAddress(aDLLHandle, 'ggml_get_next_tensor');
  ggml_get_no_alloc := GetProcAddress(aDLLHandle, 'ggml_get_no_alloc');
  ggml_get_rel_pos := GetProcAddress(aDLLHandle, 'ggml_get_rel_pos');
  ggml_get_rows := GetProcAddress(aDLLHandle, 'ggml_get_rows');
  ggml_get_rows_back := GetProcAddress(aDLLHandle, 'ggml_get_rows_back');
  ggml_get_tensor := GetProcAddress(aDLLHandle, 'ggml_get_tensor');
  ggml_get_unary_op := GetProcAddress(aDLLHandle, 'ggml_get_unary_op');
  ggml_graph_clear := GetProcAddress(aDLLHandle, 'ggml_graph_clear');
  ggml_graph_compute := GetProcAddress(aDLLHandle, 'ggml_graph_compute');
  ggml_graph_compute_with_ctx := GetProcAddress(aDLLHandle, 'ggml_graph_compute_with_ctx');
  ggml_graph_cpy := GetProcAddress(aDLLHandle, 'ggml_graph_cpy');
  ggml_graph_dump_dot := GetProcAddress(aDLLHandle, 'ggml_graph_dump_dot');
  ggml_graph_dup := GetProcAddress(aDLLHandle, 'ggml_graph_dup');
  ggml_graph_export := GetProcAddress(aDLLHandle, 'ggml_graph_export');
  ggml_graph_get_tensor := GetProcAddress(aDLLHandle, 'ggml_graph_get_tensor');
  ggml_graph_import := GetProcAddress(aDLLHandle, 'ggml_graph_import');
  ggml_graph_overhead := GetProcAddress(aDLLHandle, 'ggml_graph_overhead');
  ggml_graph_overhead_custom := GetProcAddress(aDLLHandle, 'ggml_graph_overhead_custom');
  ggml_graph_plan := GetProcAddress(aDLLHandle, 'ggml_graph_plan');
  ggml_graph_print := GetProcAddress(aDLLHandle, 'ggml_graph_print');
  ggml_graph_reset := GetProcAddress(aDLLHandle, 'ggml_graph_reset');
  ggml_graph_view := GetProcAddress(aDLLHandle, 'ggml_graph_view');
  ggml_group_norm := GetProcAddress(aDLLHandle, 'ggml_group_norm');
  ggml_group_norm_inplace := GetProcAddress(aDLLHandle, 'ggml_group_norm_inplace');
  ggml_guid_matches := GetProcAddress(aDLLHandle, 'ggml_guid_matches');
  ggml_hardsigmoid := GetProcAddress(aDLLHandle, 'ggml_hardsigmoid');
  ggml_hardswish := GetProcAddress(aDLLHandle, 'ggml_hardswish');
  ggml_im2col := GetProcAddress(aDLLHandle, 'ggml_im2col');
  ggml_init := GetProcAddress(aDLLHandle, 'ggml_init');
  ggml_internal_get_type_traits := GetProcAddress(aDLLHandle, 'ggml_internal_get_type_traits');
  ggml_is_3d := GetProcAddress(aDLLHandle, 'ggml_is_3d');
  ggml_is_contiguous := GetProcAddress(aDLLHandle, 'ggml_is_contiguous');
  ggml_is_empty := GetProcAddress(aDLLHandle, 'ggml_is_empty');
  ggml_is_matrix := GetProcAddress(aDLLHandle, 'ggml_is_matrix');
  ggml_is_numa := GetProcAddress(aDLLHandle, 'ggml_is_numa');
  ggml_is_permuted := GetProcAddress(aDLLHandle, 'ggml_is_permuted');
  ggml_is_quantized := GetProcAddress(aDLLHandle, 'ggml_is_quantized');
  ggml_is_scalar := GetProcAddress(aDLLHandle, 'ggml_is_scalar');
  ggml_is_transposed := GetProcAddress(aDLLHandle, 'ggml_is_transposed');
  ggml_is_vector := GetProcAddress(aDLLHandle, 'ggml_is_vector');
  ggml_leaky_relu := GetProcAddress(aDLLHandle, 'ggml_leaky_relu');
  ggml_log := GetProcAddress(aDLLHandle, 'ggml_log');
  ggml_log_inplace := GetProcAddress(aDLLHandle, 'ggml_log_inplace');
  ggml_map_binary_f32 := GetProcAddress(aDLLHandle, 'ggml_map_binary_f32');
  ggml_map_binary_inplace_f32 := GetProcAddress(aDLLHandle, 'ggml_map_binary_inplace_f32');
  ggml_map_custom1 := GetProcAddress(aDLLHandle, 'ggml_map_custom1');
  ggml_map_custom1_f32 := GetProcAddress(aDLLHandle, 'ggml_map_custom1_f32');
  ggml_map_custom1_inplace := GetProcAddress(aDLLHandle, 'ggml_map_custom1_inplace');
  ggml_map_custom1_inplace_f32 := GetProcAddress(aDLLHandle, 'ggml_map_custom1_inplace_f32');
  ggml_map_custom2 := GetProcAddress(aDLLHandle, 'ggml_map_custom2');
  ggml_map_custom2_f32 := GetProcAddress(aDLLHandle, 'ggml_map_custom2_f32');
  ggml_map_custom2_inplace := GetProcAddress(aDLLHandle, 'ggml_map_custom2_inplace');
  ggml_map_custom2_inplace_f32 := GetProcAddress(aDLLHandle, 'ggml_map_custom2_inplace_f32');
  ggml_map_custom3 := GetProcAddress(aDLLHandle, 'ggml_map_custom3');
  ggml_map_custom3_f32 := GetProcAddress(aDLLHandle, 'ggml_map_custom3_f32');
  ggml_map_custom3_inplace := GetProcAddress(aDLLHandle, 'ggml_map_custom3_inplace');
  ggml_map_custom3_inplace_f32 := GetProcAddress(aDLLHandle, 'ggml_map_custom3_inplace_f32');
  ggml_map_unary_f32 := GetProcAddress(aDLLHandle, 'ggml_map_unary_f32');
  ggml_map_unary_inplace_f32 := GetProcAddress(aDLLHandle, 'ggml_map_unary_inplace_f32');
  ggml_mean := GetProcAddress(aDLLHandle, 'ggml_mean');
  ggml_mul := GetProcAddress(aDLLHandle, 'ggml_mul');
  ggml_mul_inplace := GetProcAddress(aDLLHandle, 'ggml_mul_inplace');
  ggml_mul_mat := GetProcAddress(aDLLHandle, 'ggml_mul_mat');
  ggml_mul_mat_id := GetProcAddress(aDLLHandle, 'ggml_mul_mat_id');
  ggml_mul_mat_set_prec := GetProcAddress(aDLLHandle, 'ggml_mul_mat_set_prec');
  ggml_n_dims := GetProcAddress(aDLLHandle, 'ggml_n_dims');
  ggml_nbytes := GetProcAddress(aDLLHandle, 'ggml_nbytes');
  ggml_nbytes_pad := GetProcAddress(aDLLHandle, 'ggml_nbytes_pad');
  ggml_neg := GetProcAddress(aDLLHandle, 'ggml_neg');
  ggml_neg_inplace := GetProcAddress(aDLLHandle, 'ggml_neg_inplace');
  ggml_nelements := GetProcAddress(aDLLHandle, 'ggml_nelements');
  ggml_new_f32 := GetProcAddress(aDLLHandle, 'ggml_new_f32');
  ggml_new_graph := GetProcAddress(aDLLHandle, 'ggml_new_graph');
  ggml_new_graph_custom := GetProcAddress(aDLLHandle, 'ggml_new_graph_custom');
  ggml_new_i32 := GetProcAddress(aDLLHandle, 'ggml_new_i32');
  ggml_new_tensor := GetProcAddress(aDLLHandle, 'ggml_new_tensor');
  ggml_new_tensor_1d := GetProcAddress(aDLLHandle, 'ggml_new_tensor_1d');
  ggml_new_tensor_2d := GetProcAddress(aDLLHandle, 'ggml_new_tensor_2d');
  ggml_new_tensor_3d := GetProcAddress(aDLLHandle, 'ggml_new_tensor_3d');
  ggml_new_tensor_4d := GetProcAddress(aDLLHandle, 'ggml_new_tensor_4d');
  ggml_norm := GetProcAddress(aDLLHandle, 'ggml_norm');
  ggml_norm_inplace := GetProcAddress(aDLLHandle, 'ggml_norm_inplace');
  ggml_nrows := GetProcAddress(aDLLHandle, 'ggml_nrows');
  ggml_numa_init := GetProcAddress(aDLLHandle, 'ggml_numa_init');
  ggml_op_desc := GetProcAddress(aDLLHandle, 'ggml_op_desc');
  ggml_op_name := GetProcAddress(aDLLHandle, 'ggml_op_name');
  ggml_op_symbol := GetProcAddress(aDLLHandle, 'ggml_op_symbol');
  ggml_opt := GetProcAddress(aDLLHandle, 'ggml_opt');
  ggml_opt_default_params := GetProcAddress(aDLLHandle, 'ggml_opt_default_params');
  ggml_opt_init := GetProcAddress(aDLLHandle, 'ggml_opt_init');
  ggml_opt_resume := GetProcAddress(aDLLHandle, 'ggml_opt_resume');
  ggml_opt_resume_g := GetProcAddress(aDLLHandle, 'ggml_opt_resume_g');
  ggml_out_prod := GetProcAddress(aDLLHandle, 'ggml_out_prod');
  ggml_pad := GetProcAddress(aDLLHandle, 'ggml_pad');
  ggml_permute := GetProcAddress(aDLLHandle, 'ggml_permute');
  ggml_pool_1d := GetProcAddress(aDLLHandle, 'ggml_pool_1d');
  ggml_pool_2d := GetProcAddress(aDLLHandle, 'ggml_pool_2d');
  ggml_print_backtrace := GetProcAddress(aDLLHandle, 'ggml_print_backtrace');
  ggml_print_object := GetProcAddress(aDLLHandle, 'ggml_print_object');
  ggml_print_objects := GetProcAddress(aDLLHandle, 'ggml_print_objects');
  ggml_quantize_chunk := GetProcAddress(aDLLHandle, 'ggml_quantize_chunk');
  ggml_quantize_free := GetProcAddress(aDLLHandle, 'ggml_quantize_free');
  ggml_quantize_init := GetProcAddress(aDLLHandle, 'ggml_quantize_init');
  ggml_quantize_requires_imatrix := GetProcAddress(aDLLHandle, 'ggml_quantize_requires_imatrix');
  ggml_relu := GetProcAddress(aDLLHandle, 'ggml_relu');
  ggml_relu_inplace := GetProcAddress(aDLLHandle, 'ggml_relu_inplace');
  ggml_repeat := GetProcAddress(aDLLHandle, 'ggml_repeat');
  ggml_repeat_back := GetProcAddress(aDLLHandle, 'ggml_repeat_back');
  ggml_reshape := GetProcAddress(aDLLHandle, 'ggml_reshape');
  ggml_reshape_1d := GetProcAddress(aDLLHandle, 'ggml_reshape_1d');
  ggml_reshape_2d := GetProcAddress(aDLLHandle, 'ggml_reshape_2d');
  ggml_reshape_3d := GetProcAddress(aDLLHandle, 'ggml_reshape_3d');
  ggml_reshape_4d := GetProcAddress(aDLLHandle, 'ggml_reshape_4d');
  ggml_rms_norm := GetProcAddress(aDLLHandle, 'ggml_rms_norm');
  ggml_rms_norm_back := GetProcAddress(aDLLHandle, 'ggml_rms_norm_back');
  ggml_rms_norm_inplace := GetProcAddress(aDLLHandle, 'ggml_rms_norm_inplace');
  ggml_rope := GetProcAddress(aDLLHandle, 'ggml_rope');
  ggml_rope_back := GetProcAddress(aDLLHandle, 'ggml_rope_back');
  ggml_rope_custom := GetProcAddress(aDLLHandle, 'ggml_rope_custom');
  ggml_rope_custom_inplace := GetProcAddress(aDLLHandle, 'ggml_rope_custom_inplace');
  ggml_rope_inplace := GetProcAddress(aDLLHandle, 'ggml_rope_inplace');
  ggml_rope_xpos_inplace := GetProcAddress(aDLLHandle, 'ggml_rope_xpos_inplace');
  ggml_rope_yarn_corr_dims := GetProcAddress(aDLLHandle, 'ggml_rope_yarn_corr_dims');
  ggml_row_size := GetProcAddress(aDLLHandle, 'ggml_row_size');
  ggml_scale := GetProcAddress(aDLLHandle, 'ggml_scale');
  ggml_scale_inplace := GetProcAddress(aDLLHandle, 'ggml_scale_inplace');
  ggml_set := GetProcAddress(aDLLHandle, 'ggml_set');
  ggml_set_1d := GetProcAddress(aDLLHandle, 'ggml_set_1d');
  ggml_set_1d_inplace := GetProcAddress(aDLLHandle, 'ggml_set_1d_inplace');
  ggml_set_2d := GetProcAddress(aDLLHandle, 'ggml_set_2d');
  ggml_set_2d_inplace := GetProcAddress(aDLLHandle, 'ggml_set_2d_inplace');
  ggml_set_f32 := GetProcAddress(aDLLHandle, 'ggml_set_f32');
  ggml_set_f32_1d := GetProcAddress(aDLLHandle, 'ggml_set_f32_1d');
  ggml_set_f32_nd := GetProcAddress(aDLLHandle, 'ggml_set_f32_nd');
  ggml_set_i32 := GetProcAddress(aDLLHandle, 'ggml_set_i32');
  ggml_set_i32_1d := GetProcAddress(aDLLHandle, 'ggml_set_i32_1d');
  ggml_set_i32_nd := GetProcAddress(aDLLHandle, 'ggml_set_i32_nd');
  ggml_set_inplace := GetProcAddress(aDLLHandle, 'ggml_set_inplace');
  ggml_set_input := GetProcAddress(aDLLHandle, 'ggml_set_input');
  ggml_set_name := GetProcAddress(aDLLHandle, 'ggml_set_name');
  ggml_set_no_alloc := GetProcAddress(aDLLHandle, 'ggml_set_no_alloc');
  ggml_set_output := GetProcAddress(aDLLHandle, 'ggml_set_output');
  ggml_set_param := GetProcAddress(aDLLHandle, 'ggml_set_param');
  ggml_set_scratch := GetProcAddress(aDLLHandle, 'ggml_set_scratch');
  ggml_set_zero := GetProcAddress(aDLLHandle, 'ggml_set_zero');
  ggml_sgn := GetProcAddress(aDLLHandle, 'ggml_sgn');
  ggml_sgn_inplace := GetProcAddress(aDLLHandle, 'ggml_sgn_inplace');
  ggml_silu := GetProcAddress(aDLLHandle, 'ggml_silu');
  ggml_silu_back := GetProcAddress(aDLLHandle, 'ggml_silu_back');
  ggml_silu_inplace := GetProcAddress(aDLLHandle, 'ggml_silu_inplace');
  ggml_soft_max := GetProcAddress(aDLLHandle, 'ggml_soft_max');
  ggml_soft_max_back := GetProcAddress(aDLLHandle, 'ggml_soft_max_back');
  ggml_soft_max_back_inplace := GetProcAddress(aDLLHandle, 'ggml_soft_max_back_inplace');
  ggml_soft_max_ext := GetProcAddress(aDLLHandle, 'ggml_soft_max_ext');
  ggml_soft_max_inplace := GetProcAddress(aDLLHandle, 'ggml_soft_max_inplace');
  ggml_sqr := GetProcAddress(aDLLHandle, 'ggml_sqr');
  ggml_sqr_inplace := GetProcAddress(aDLLHandle, 'ggml_sqr_inplace');
  ggml_sqrt := GetProcAddress(aDLLHandle, 'ggml_sqrt');
  ggml_sqrt_inplace := GetProcAddress(aDLLHandle, 'ggml_sqrt_inplace');
  ggml_ssm_conv := GetProcAddress(aDLLHandle, 'ggml_ssm_conv');
  ggml_ssm_scan := GetProcAddress(aDLLHandle, 'ggml_ssm_scan');
  ggml_status_to_string := GetProcAddress(aDLLHandle, 'ggml_status_to_string');
  ggml_step := GetProcAddress(aDLLHandle, 'ggml_step');
  ggml_step_inplace := GetProcAddress(aDLLHandle, 'ggml_step_inplace');
  ggml_sub := GetProcAddress(aDLLHandle, 'ggml_sub');
  ggml_sub_inplace := GetProcAddress(aDLLHandle, 'ggml_sub_inplace');
  ggml_sum := GetProcAddress(aDLLHandle, 'ggml_sum');
  ggml_sum_rows := GetProcAddress(aDLLHandle, 'ggml_sum_rows');
  ggml_tallocr_alloc := GetProcAddress(aDLLHandle, 'ggml_tallocr_alloc');
  ggml_tallocr_new := GetProcAddress(aDLLHandle, 'ggml_tallocr_new');
  ggml_tanh := GetProcAddress(aDLLHandle, 'ggml_tanh');
  ggml_tanh_inplace := GetProcAddress(aDLLHandle, 'ggml_tanh_inplace');
  ggml_tensor_overhead := GetProcAddress(aDLLHandle, 'ggml_tensor_overhead');
  ggml_time_init := GetProcAddress(aDLLHandle, 'ggml_time_init');
  ggml_time_ms := GetProcAddress(aDLLHandle, 'ggml_time_ms');
  ggml_time_us := GetProcAddress(aDLLHandle, 'ggml_time_us');
  ggml_timestep_embedding := GetProcAddress(aDLLHandle, 'ggml_timestep_embedding');
  ggml_top_k := GetProcAddress(aDLLHandle, 'ggml_top_k');
  ggml_transpose := GetProcAddress(aDLLHandle, 'ggml_transpose');
  ggml_type_name := GetProcAddress(aDLLHandle, 'ggml_type_name');
  ggml_type_size := GetProcAddress(aDLLHandle, 'ggml_type_size');
  ggml_type_sizef := GetProcAddress(aDLLHandle, 'ggml_type_sizef');
  ggml_unary := GetProcAddress(aDLLHandle, 'ggml_unary');
  ggml_unary_inplace := GetProcAddress(aDLLHandle, 'ggml_unary_inplace');
  ggml_unary_op_name := GetProcAddress(aDLLHandle, 'ggml_unary_op_name');
  ggml_unravel_index := GetProcAddress(aDLLHandle, 'ggml_unravel_index');
  ggml_upscale := GetProcAddress(aDLLHandle, 'ggml_upscale');
  ggml_used_mem := GetProcAddress(aDLLHandle, 'ggml_used_mem');
  ggml_view_1d := GetProcAddress(aDLLHandle, 'ggml_view_1d');
  ggml_view_2d := GetProcAddress(aDLLHandle, 'ggml_view_2d');
  ggml_view_3d := GetProcAddress(aDLLHandle, 'ggml_view_3d');
  ggml_view_4d := GetProcAddress(aDLLHandle, 'ggml_view_4d');
  ggml_view_tensor := GetProcAddress(aDLLHandle, 'ggml_view_tensor');
  ggml_win_part := GetProcAddress(aDLLHandle, 'ggml_win_part');
  ggml_win_unpart := GetProcAddress(aDLLHandle, 'ggml_win_unpart');
  gguf_add_tensor := GetProcAddress(aDLLHandle, 'gguf_add_tensor');
  gguf_find_key := GetProcAddress(aDLLHandle, 'gguf_find_key');
  gguf_find_tensor := GetProcAddress(aDLLHandle, 'gguf_find_tensor');
  gguf_free := GetProcAddress(aDLLHandle, 'gguf_free');
  gguf_get_alignment := GetProcAddress(aDLLHandle, 'gguf_get_alignment');
  gguf_get_arr_data := GetProcAddress(aDLLHandle, 'gguf_get_arr_data');
  gguf_get_arr_n := GetProcAddress(aDLLHandle, 'gguf_get_arr_n');
  gguf_get_arr_str := GetProcAddress(aDLLHandle, 'gguf_get_arr_str');
  gguf_get_arr_type := GetProcAddress(aDLLHandle, 'gguf_get_arr_type');
  gguf_get_data := GetProcAddress(aDLLHandle, 'gguf_get_data');
  gguf_get_data_offset := GetProcAddress(aDLLHandle, 'gguf_get_data_offset');
  gguf_get_key := GetProcAddress(aDLLHandle, 'gguf_get_key');
  gguf_get_kv_type := GetProcAddress(aDLLHandle, 'gguf_get_kv_type');
  gguf_get_meta_data := GetProcAddress(aDLLHandle, 'gguf_get_meta_data');
  gguf_get_meta_size := GetProcAddress(aDLLHandle, 'gguf_get_meta_size');
  gguf_get_n_kv := GetProcAddress(aDLLHandle, 'gguf_get_n_kv');
  gguf_get_n_tensors := GetProcAddress(aDLLHandle, 'gguf_get_n_tensors');
  gguf_get_tensor_name := GetProcAddress(aDLLHandle, 'gguf_get_tensor_name');
  gguf_get_tensor_offset := GetProcAddress(aDLLHandle, 'gguf_get_tensor_offset');
  gguf_get_tensor_type := GetProcAddress(aDLLHandle, 'gguf_get_tensor_type');
  gguf_get_val_bool := GetProcAddress(aDLLHandle, 'gguf_get_val_bool');
  gguf_get_val_data := GetProcAddress(aDLLHandle, 'gguf_get_val_data');
  gguf_get_val_f32 := GetProcAddress(aDLLHandle, 'gguf_get_val_f32');
  gguf_get_val_f64 := GetProcAddress(aDLLHandle, 'gguf_get_val_f64');
  gguf_get_val_i16 := GetProcAddress(aDLLHandle, 'gguf_get_val_i16');
  gguf_get_val_i32 := GetProcAddress(aDLLHandle, 'gguf_get_val_i32');
  gguf_get_val_i64 := GetProcAddress(aDLLHandle, 'gguf_get_val_i64');
  gguf_get_val_i8 := GetProcAddress(aDLLHandle, 'gguf_get_val_i8');
  gguf_get_val_str := GetProcAddress(aDLLHandle, 'gguf_get_val_str');
  gguf_get_val_u16 := GetProcAddress(aDLLHandle, 'gguf_get_val_u16');
  gguf_get_val_u32 := GetProcAddress(aDLLHandle, 'gguf_get_val_u32');
  gguf_get_val_u64 := GetProcAddress(aDLLHandle, 'gguf_get_val_u64');
  gguf_get_val_u8 := GetProcAddress(aDLLHandle, 'gguf_get_val_u8');
  gguf_get_version := GetProcAddress(aDLLHandle, 'gguf_get_version');
  gguf_init_empty := GetProcAddress(aDLLHandle, 'gguf_init_empty');
  gguf_init_from_file := GetProcAddress(aDLLHandle, 'gguf_init_from_file');
  gguf_set_arr_data := GetProcAddress(aDLLHandle, 'gguf_set_arr_data');
  gguf_set_arr_str := GetProcAddress(aDLLHandle, 'gguf_set_arr_str');
  gguf_set_kv := GetProcAddress(aDLLHandle, 'gguf_set_kv');
  gguf_set_tensor_data := GetProcAddress(aDLLHandle, 'gguf_set_tensor_data');
  gguf_set_tensor_type := GetProcAddress(aDLLHandle, 'gguf_set_tensor_type');
  gguf_set_val_bool := GetProcAddress(aDLLHandle, 'gguf_set_val_bool');
  gguf_set_val_f32 := GetProcAddress(aDLLHandle, 'gguf_set_val_f32');
  gguf_set_val_f64 := GetProcAddress(aDLLHandle, 'gguf_set_val_f64');
  gguf_set_val_i16 := GetProcAddress(aDLLHandle, 'gguf_set_val_i16');
  gguf_set_val_i32 := GetProcAddress(aDLLHandle, 'gguf_set_val_i32');
  gguf_set_val_i64 := GetProcAddress(aDLLHandle, 'gguf_set_val_i64');
  gguf_set_val_i8 := GetProcAddress(aDLLHandle, 'gguf_set_val_i8');
  gguf_set_val_str := GetProcAddress(aDLLHandle, 'gguf_set_val_str');
  gguf_set_val_u16 := GetProcAddress(aDLLHandle, 'gguf_set_val_u16');
  gguf_set_val_u32 := GetProcAddress(aDLLHandle, 'gguf_set_val_u32');
  gguf_set_val_u64 := GetProcAddress(aDLLHandle, 'gguf_set_val_u64');
  gguf_set_val_u8 := GetProcAddress(aDLLHandle, 'gguf_set_val_u8');
  gguf_type_name := GetProcAddress(aDLLHandle, 'gguf_type_name');
  gguf_write_to_file := GetProcAddress(aDLLHandle, 'gguf_write_to_file');
  llama_add_bos_token := GetProcAddress(aDLLHandle, 'llama_add_bos_token');
  llama_add_eos_token := GetProcAddress(aDLLHandle, 'llama_add_eos_token');
  llama_backend_free := GetProcAddress(aDLLHandle, 'llama_backend_free');
  llama_backend_init := GetProcAddress(aDLLHandle, 'llama_backend_init');
  llama_batch_free := GetProcAddress(aDLLHandle, 'llama_batch_free');
  llama_batch_get_one := GetProcAddress(aDLLHandle, 'llama_batch_get_one');
  llama_batch_init := GetProcAddress(aDLLHandle, 'llama_batch_init');
  llama_beam_search := GetProcAddress(aDLLHandle, 'llama_beam_search');
  llama_chat_apply_template := GetProcAddress(aDLLHandle, 'llama_chat_apply_template');
  llama_context_default_params := GetProcAddress(aDLLHandle, 'llama_context_default_params');
  llama_control_vector_apply := GetProcAddress(aDLLHandle, 'llama_control_vector_apply');
  llama_copy_state_data := GetProcAddress(aDLLHandle, 'llama_copy_state_data');
  llama_decode := GetProcAddress(aDLLHandle, 'llama_decode');
  llama_dump_timing_info_yaml := GetProcAddress(aDLLHandle, 'llama_dump_timing_info_yaml');
  llama_free := GetProcAddress(aDLLHandle, 'llama_free');
  llama_free_model := GetProcAddress(aDLLHandle, 'llama_free_model');
  llama_get_embeddings := GetProcAddress(aDLLHandle, 'llama_get_embeddings');
  llama_get_embeddings_ith := GetProcAddress(aDLLHandle, 'llama_get_embeddings_ith');
  llama_get_embeddings_seq := GetProcAddress(aDLLHandle, 'llama_get_embeddings_seq');
  llama_get_kv_cache_token_count := GetProcAddress(aDLLHandle, 'llama_get_kv_cache_token_count');
  llama_get_kv_cache_used_cells := GetProcAddress(aDLLHandle, 'llama_get_kv_cache_used_cells');
  llama_get_logits := GetProcAddress(aDLLHandle, 'llama_get_logits');
  llama_get_logits_ith := GetProcAddress(aDLLHandle, 'llama_get_logits_ith');
  llama_get_model := GetProcAddress(aDLLHandle, 'llama_get_model');
  llama_get_model_tensor := GetProcAddress(aDLLHandle, 'llama_get_model_tensor');
  llama_get_state_size := GetProcAddress(aDLLHandle, 'llama_get_state_size');
  llama_get_timings := GetProcAddress(aDLLHandle, 'llama_get_timings');
  llama_grammar_accept_token := GetProcAddress(aDLLHandle, 'llama_grammar_accept_token');
  llama_grammar_copy := GetProcAddress(aDLLHandle, 'llama_grammar_copy');
  llama_grammar_free := GetProcAddress(aDLLHandle, 'llama_grammar_free');
  llama_grammar_init := GetProcAddress(aDLLHandle, 'llama_grammar_init');
  llama_kv_cache_clear := GetProcAddress(aDLLHandle, 'llama_kv_cache_clear');
  llama_kv_cache_defrag := GetProcAddress(aDLLHandle, 'llama_kv_cache_defrag');
  llama_kv_cache_seq_add := GetProcAddress(aDLLHandle, 'llama_kv_cache_seq_add');
  llama_kv_cache_seq_cp := GetProcAddress(aDLLHandle, 'llama_kv_cache_seq_cp');
  llama_kv_cache_seq_div := GetProcAddress(aDLLHandle, 'llama_kv_cache_seq_div');
  llama_kv_cache_seq_keep := GetProcAddress(aDLLHandle, 'llama_kv_cache_seq_keep');
  llama_kv_cache_seq_pos_max := GetProcAddress(aDLLHandle, 'llama_kv_cache_seq_pos_max');
  llama_kv_cache_seq_rm := GetProcAddress(aDLLHandle, 'llama_kv_cache_seq_rm');
  llama_kv_cache_update := GetProcAddress(aDLLHandle, 'llama_kv_cache_update');
  llama_kv_cache_view_free := GetProcAddress(aDLLHandle, 'llama_kv_cache_view_free');
  llama_kv_cache_view_init := GetProcAddress(aDLLHandle, 'llama_kv_cache_view_init');
  llama_kv_cache_view_update := GetProcAddress(aDLLHandle, 'llama_kv_cache_view_update');
  llama_load_model_from_file := GetProcAddress(aDLLHandle, 'llama_load_model_from_file');
  llama_load_session_file := GetProcAddress(aDLLHandle, 'llama_load_session_file');
  llama_log_set := GetProcAddress(aDLLHandle, 'llama_log_set');
  llama_max_devices := GetProcAddress(aDLLHandle, 'llama_max_devices');
  llama_model_apply_lora_from_file := GetProcAddress(aDLLHandle, 'llama_model_apply_lora_from_file');
  llama_model_default_params := GetProcAddress(aDLLHandle, 'llama_model_default_params');
  llama_model_desc := GetProcAddress(aDLLHandle, 'llama_model_desc');
  llama_model_meta_count := GetProcAddress(aDLLHandle, 'llama_model_meta_count');
  llama_model_meta_key_by_index := GetProcAddress(aDLLHandle, 'llama_model_meta_key_by_index');
  llama_model_meta_val_str := GetProcAddress(aDLLHandle, 'llama_model_meta_val_str');
  llama_model_meta_val_str_by_index := GetProcAddress(aDLLHandle, 'llama_model_meta_val_str_by_index');
  llama_model_n_params := GetProcAddress(aDLLHandle, 'llama_model_n_params');
  llama_model_quantize := GetProcAddress(aDLLHandle, 'llama_model_quantize');
  llama_model_quantize_default_params := GetProcAddress(aDLLHandle, 'llama_model_quantize_default_params');
  llama_model_size := GetProcAddress(aDLLHandle, 'llama_model_size');
  llama_n_batch := GetProcAddress(aDLLHandle, 'llama_n_batch');
  llama_n_ctx := GetProcAddress(aDLLHandle, 'llama_n_ctx');
  llama_n_ctx_train := GetProcAddress(aDLLHandle, 'llama_n_ctx_train');
  llama_n_embd := GetProcAddress(aDLLHandle, 'llama_n_embd');
  llama_n_layer := GetProcAddress(aDLLHandle, 'llama_n_layer');
  llama_n_seq_max := GetProcAddress(aDLLHandle, 'llama_n_seq_max');
  llama_n_ubatch := GetProcAddress(aDLLHandle, 'llama_n_ubatch');
  llama_n_vocab := GetProcAddress(aDLLHandle, 'llama_n_vocab');
  llama_new_context_with_model := GetProcAddress(aDLLHandle, 'llama_new_context_with_model');
  llama_numa_init := GetProcAddress(aDLLHandle, 'llama_numa_init');
  llama_print_system_info := GetProcAddress(aDLLHandle, 'llama_print_system_info');
  llama_print_timings := GetProcAddress(aDLLHandle, 'llama_print_timings');
  llama_reset_timings := GetProcAddress(aDLLHandle, 'llama_reset_timings');
  llama_rope_freq_scale_train := GetProcAddress(aDLLHandle, 'llama_rope_freq_scale_train');
  llama_rope_type_rtn := GetProcAddress(aDLLHandle, 'llama_rope_type');
  llama_sample_apply_guidance := GetProcAddress(aDLLHandle, 'llama_sample_apply_guidance');
  llama_sample_entropy := GetProcAddress(aDLLHandle, 'llama_sample_entropy');
  llama_sample_grammar := GetProcAddress(aDLLHandle, 'llama_sample_grammar');
  llama_sample_min_p := GetProcAddress(aDLLHandle, 'llama_sample_min_p');
  llama_sample_repetition_penalties := GetProcAddress(aDLLHandle, 'llama_sample_repetition_penalties');
  llama_sample_softmax := GetProcAddress(aDLLHandle, 'llama_sample_softmax');
  llama_sample_tail_free := GetProcAddress(aDLLHandle, 'llama_sample_tail_free');
  llama_sample_temp := GetProcAddress(aDLLHandle, 'llama_sample_temp');
  llama_sample_token := GetProcAddress(aDLLHandle, 'llama_sample_token');
  llama_sample_token_greedy := GetProcAddress(aDLLHandle, 'llama_sample_token_greedy');
  llama_sample_token_mirostat := GetProcAddress(aDLLHandle, 'llama_sample_token_mirostat');
  llama_sample_token_mirostat_v2 := GetProcAddress(aDLLHandle, 'llama_sample_token_mirostat_v2');
  llama_sample_top_k := GetProcAddress(aDLLHandle, 'llama_sample_top_k');
  llama_sample_top_p := GetProcAddress(aDLLHandle, 'llama_sample_top_p');
  llama_sample_typical := GetProcAddress(aDLLHandle, 'llama_sample_typical');
  llama_save_session_file := GetProcAddress(aDLLHandle, 'llama_save_session_file');
  llama_set_abort_callback := GetProcAddress(aDLLHandle, 'llama_set_abort_callback');
  llama_set_causal_attn := GetProcAddress(aDLLHandle, 'llama_set_causal_attn');
  llama_set_n_threads := GetProcAddress(aDLLHandle, 'llama_set_n_threads');
  llama_set_rng_seed := GetProcAddress(aDLLHandle, 'llama_set_rng_seed');
  llama_set_state_data := GetProcAddress(aDLLHandle, 'llama_set_state_data');
  llama_split_path := GetProcAddress(aDLLHandle, 'llama_split_path');
  llama_split_prefix := GetProcAddress(aDLLHandle, 'llama_split_prefix');
  llama_state_get_data := GetProcAddress(aDLLHandle, 'llama_state_get_data');
  llama_state_get_size := GetProcAddress(aDLLHandle, 'llama_state_get_size');
  llama_state_load_file := GetProcAddress(aDLLHandle, 'llama_state_load_file');
  llama_state_save_file := GetProcAddress(aDLLHandle, 'llama_state_save_file');
  llama_state_seq_get_data := GetProcAddress(aDLLHandle, 'llama_state_seq_get_data');
  llama_state_seq_get_size := GetProcAddress(aDLLHandle, 'llama_state_seq_get_size');
  llama_state_seq_load_file := GetProcAddress(aDLLHandle, 'llama_state_seq_load_file');
  llama_state_seq_save_file := GetProcAddress(aDLLHandle, 'llama_state_seq_save_file');
  llama_state_seq_set_data := GetProcAddress(aDLLHandle, 'llama_state_seq_set_data');
  llama_state_set_data := GetProcAddress(aDLLHandle, 'llama_state_set_data');
  llama_supports_gpu_offload := GetProcAddress(aDLLHandle, 'llama_supports_gpu_offload');
  llama_supports_mlock := GetProcAddress(aDLLHandle, 'llama_supports_mlock');
  llama_supports_mmap := GetProcAddress(aDLLHandle, 'llama_supports_mmap');
  llama_synchronize := GetProcAddress(aDLLHandle, 'llama_synchronize');
  llama_time_us := GetProcAddress(aDLLHandle, 'llama_time_us');
  llama_token_bos := GetProcAddress(aDLLHandle, 'llama_token_bos');
  llama_token_cls := GetProcAddress(aDLLHandle, 'llama_token_cls');
  llama_token_eos := GetProcAddress(aDLLHandle, 'llama_token_eos');
  llama_token_eot := GetProcAddress(aDLLHandle, 'llama_token_eot');
  llama_token_get_score := GetProcAddress(aDLLHandle, 'llama_token_get_score');
  llama_token_get_text := GetProcAddress(aDLLHandle, 'llama_token_get_text');
  llama_token_get_type := GetProcAddress(aDLLHandle, 'llama_token_get_type');
  llama_token_middle := GetProcAddress(aDLLHandle, 'llama_token_middle');
  llama_token_nl := GetProcAddress(aDLLHandle, 'llama_token_nl');
  llama_token_prefix := GetProcAddress(aDLLHandle, 'llama_token_prefix');
  llama_token_sep := GetProcAddress(aDLLHandle, 'llama_token_sep');
  llama_token_suffix := GetProcAddress(aDLLHandle, 'llama_token_suffix');
  llama_token_to_piece := GetProcAddress(aDLLHandle, 'llama_token_to_piece');
  llama_tokenize := GetProcAddress(aDLLHandle, 'llama_tokenize');
  llama_vocab_type_rtn := GetProcAddress(aDLLHandle, 'llama_vocab_type');
  redirect_cerr_to_callback := GetProcAddress(aDLLHandle, 'redirect_cerr_to_callback');
  restore_cerr := GetProcAddress(aDLLHandle, 'restore_cerr');
end;

end.
