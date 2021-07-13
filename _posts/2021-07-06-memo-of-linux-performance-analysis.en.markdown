---
layout: post
title:  "Memo of linux performance analysis command"
date:   2021-07-06 13:24:48 +0800
lang: English
lang-ref: 2021-07-06-memo-of-linux-performance-analysis
---

This is a short memo for linux performance analysis. 

TL;DR:
- CPU: `vmstat 1`
    - thread saturation
    - time
- Memory usage
    - `vmstat 1`
    - `free -m`
- IO: `iostat -xz 1`
- Network
    - `sar -n DEV 1`
    - `sar -n TCP,ETCP 1`
- System load average: `uptime`
- System message: `dmesg | tail`
- Process summary: `pidstat 1`

Ref:
- https://netflixtechblog.com/linux-performance-analysis-in-60-000-milliseconds-accc10403c55

## System load average

```
$ uptime
 13:32:18 up 2 days, 18:28,  1 user,  load average: 0.63, 0.38, 0.36
```

Last three number is **system load average(queue/load average)** of 1, 5, 15 mins, indicates CPU load.

The system load average is relative to CPU, eg: 0-1 for a single core, 0-2 for a dual.

## System message

```
$ dmesg | tail
[228725.272574] wlp3s0: disconnect from AP 80:69:33:8c:43:d2 for new auth to 80:69:33:8c:25:92
[228725.317532] wlp3s0: authenticate with 80:69:33:8c:25:92
[228725.328348] wlp3s0: send auth to 80:69:33:8c:25:92 (try 1/3)
```

## CPU thread saturation

```bash
$ vmstat 1
procs -----------memory----------       ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd     free   buff    cache   si   so    bi    bo   in   cs   us sy id wa st
 2  0      0 28933980  16116 13100944    0    0    23   726  102  109   13  7 80  0  0
 0  0      0 28933596  16116 13100952    0    0     0     0  708  704    0  0 99  0  0
```

The `r` is number of processes running on CPU and waiting for a turn, don't include IO.

P.S.
- The output of vmstat is not very well indented.
- 1 means refresh every 1 second.

## CPU time

vmstat's cpu column.

### Process summary

```bash
$ pidstat 1
Linux 5.12.13-200.fc33.x86_64 (ToyBox) 	07/06/2021 	_x86_64_	(16 CPU)

01:45:58 PM   UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
01:45:59 PM  1000      4511    0.98    0.00    0.00    0.00    0.98    13  gnome-shell
01:45:59 PM  1000      8588    0.00    0.98    0.00    0.00    0.98     7  code
```

P.S. Percentage can go over 100%, for multicore CPUs.

## Memory usage

vmstat's memory and swap column.

----

```bash
$ free -m
              total        used        free      shared  buff/cache   available
Mem:          47466        6328       28325          97       12811       40472
Swap:          4095           0        4095
```

## IO

```bash
$ iostat -xz 1
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.38    0.00    0.25    0.06    0.00   99.31

Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme0n1          0.00      0.00     0.00   0.00    0.00     0.00   17.00    152.00     1.00   5.56    0.35     8.94    0.00      0.00     0.00   0.00    0.00     0.00    2.00    0.50    0.01   0.80
```

Metrics:
- await: The average wait time, in ms.
- avgqu-sz: The average number of requests issued to the device. 
- `%util`: Device utilization rate.

`-z` means omit inactive.

## Network

```bash
sar -n DEV 1
sar -n TCP,ETCP 1
```

'sar' may be the abbreviation of 'system activity report'.

`-n` means network statistics. It seems that sar can do much more than monitoring network.

