#if !defined __TIMER_H__
#define __TIMER_H__

#define GetRealTimerTime(%0) floatround(%0 * 0.93)

new globalSecondTimer;
new playerSecondTimer;

new global80msTimer;
new player80msTimer;

new global50msTimer;

forward OnSecondTimer();
forward On80msTimer();
forward On50msTimer();

#endif
