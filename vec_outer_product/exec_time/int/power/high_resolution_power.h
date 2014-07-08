#ifndef __HIGH_RESOLUTION_POWER_H__
#define __HIGH_RESOLUTION_POWER_H__

//const long long DELTA_T = 20008248; // time between 2 power updates (in nanoseconds)
const long long DELTA_T = 15046128; // time between 2 power updates (in nanoseconds) for k20

//int nvml_init();

//int power_profile(void (*call_cuda_kernel)(void));

int high_resolution_power_profile(void (*call_cuda_kernel)(void));
long long get_exec_time_in_nanoseconds(void (*call_cuda_kernel)(void));

#endif //__HIGH_RESOLUTION_POWER_H__
