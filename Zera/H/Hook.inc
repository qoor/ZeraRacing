#if !defined __HOOK_H__
#define __HOOK_H__

#define function%0\32;%1(%2) %1(%2)
#define GetMapBGMAudioID(%0) (%0 + BGM_HANDLE_AREA)
#define IsMapBGMAudioID(%0,%1) (%1 == GetMapBGMAudioID(%0))

#endif
