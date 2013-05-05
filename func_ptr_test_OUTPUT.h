extern MEM_FREE;void *MEM_FREE_ptr () {  MEM_FREE_ptr = (void*)(MEM_FREE;}
extern MEM_MEMCPY;void *MEM_MEMCPY_ptr () {  MEM_MEMCPY_ptr = (void*)(MEM_MEMCPY;}
extern MEM_MEMSET;void *MEM_MEMSET_ptr () {  MEM_MEMSET_ptr = (void*)(MEM_MEMSET;}
extern MEM_MEMMOVE;void *MEM_MEMMOVE_ptr () {  MEM_MEMMOVE_ptr = (void*)(MEM_MEMMOVE;}
extern FUNC_1;void *FUNC_1_ptr () {  FUNC_1_ptr = (void*)(FUNC_1;}
extern FUNC_2;void *FUNC_2_ptr () {  FUNC_2_ptr = (void*)(FUNC_2;}
extern MEM_PUT_STR;void *MEM_PUT_STR_ptr () {  MEM_PUT_STR_ptr = (void*)(MEM_PUT_STR;}
extern MEM_PUT_STR_ARRAY;void *MEM_PUT_STR_ARRAY_ptr () {  MEM_PUT_STR_ARRAY_ptr = (void*)(MEM_PUT_STR_ARRAY;}
extern MEM_ALLOCATE_ARRAY;void *MEM_ALLOCATE_ARRAY_ptr () {  MEM_ALLOCATE_ARRAY_ptr = (void*)(MEM_ALLOCATE_ARRAY;}
extern MEM_REALLOCATE_ARRAY;void *MEM_REALLOCATE_ARRAY_ptr () {  MEM_REALLOCATE_ARRAY_ptr = (void*)(MEM_REALLOCATE_ARRAY;}
extern MEM_ALLOCATE_STRING_ARRAY;void *MEM_ALLOCATE_STRING_ARRAY_ptr () {  MEM_ALLOCATE_STRING_ARRAY_ptr = (void*)(MEM_ALLOCATE_STRING_ARRAY;}
extern MEM_FREE_STRING_ARRAY;void *MEM_FREE_STRING_ARRAY_ptr () {  MEM_FREE_STRING_ARRAY_ptr = (void*)(MEM_FREE_STRING_ARRAY;}
extern MEM_FREE_ARRAY;void *MEM_FREE_ARRAY_ptr () {  MEM_FREE_ARRAY_ptr = (void*)(MEM_FREE_ARRAY;}
extern MEM_FREE_STRING;void *MEM_FREE_STRING_ptr () {  MEM_FREE_STRING_ptr = (void*)(MEM_FREE_STRING;}
void call__OFFSET( void* func, void* A) {
((void(*)(void*))(func))(A);}
void call__OFFSET__OFFSET_LONG( void* func, void* A, void* B, int* C) {
((void(*)(void*, void*, int*))(func))(,C);}
void call__OFFSET_LONG_LONG( void* func, void* A, int* B, int* C) {
((void(*)(void*, int*, int*))(func))(,C);}
void call_MEM_STRING_STRING( void* func, float* A, char* B) {
((void(*)(float*, char*))(func))(,B);}
void call_MEM_ARRAY_SINGLE_STRING( void* func, float* A, float* B, char* C) {
((void(*)(float*, float*, char*))(func))(,C);}
void call_MEM_ARRAY_SINGLE_SINGLE( void* func, float* A, float* B, float* C) {
((void(*)(float*, float*, float*))(func))(,C);}
void call_MEM_ARRAY_SINGLE( void* func, float* A, float* B) {
((void(*)(float*, float*))(func))(,B);}
void call_MEM_ARRAY( void* func, float* A) {
((void(*)(float*))(func))(A);}
void call_MEM_STRING( void* func, float* A) {
((void(*)(float*))(func))(A);}
