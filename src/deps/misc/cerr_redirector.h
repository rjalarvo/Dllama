#ifndef CERR_REDIRECTOR_H
#define CERR_REDIRECTOR_H

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*cerr_callback)(const char* text, void* user_data);

__declspec(dllexport) void redirect_cerr_to_callback(cerr_callback callback, void* user_data);
__declspec(dllexport) void restore_cerr();

#ifdef __cplusplus
}
#endif

#endif // CERR_REDIRECTOR_H
