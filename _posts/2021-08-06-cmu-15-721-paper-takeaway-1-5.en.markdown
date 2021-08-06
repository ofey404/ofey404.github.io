---
layout: post
title:  "CMU 15-721 paper takeaway 1-5"
date:   2021-08-06 21:06:04 +0800
lang: English
lang-ref: 2021-08-06-cmu-15-721-paper-takeaway-1-5
---

[Youtube Playlist](https://www.youtube.com/playlist?list=PLSE8ODhjZXjasmrEd2_Yi1deeE360zv5O)

01 - History of Databases
==================



## What goes around comes around

> M. Stonebraker, et al., [What Goes Around Comes Around](https://15721.courses.cs.cmu.edu/spring2020/papers/01-intro/whatgoesaround-stonebraker.pdf), in *Readings in Database Systems, 4th Edition*, 2006 *(Optional)*

Main idea:

1. Understand the history of database to try not to repeat it.
2. Ideas of databases: data model or interface. Few new ideas occurred.
3. Advantages in field of database: L/P isolation(for agility and optimization), easy to standardize.



Takeaway:

- Elephants of the market often settles technical debate.
- Complex data model will fail, its simplified subset will live.
- Aware when too many players enter a niche market.



Systems:

| Data model              | System                     | Interface                                          |
| ----------------------- | -------------------------- | -------------------------------------------------- |
| Hierarchical tree       | IBM IMS                    | DL/1, a record at a time, limited P/L independence |
| Hyperspace network      | CODASYL                    | Navigating in the hyperspace, no P/L independence  |
| Relational              | System on VAX, IBM DB/2    | SQL, QUEL...                                       |
| Entity - Relational     | Schema normalization tools | DBA tools                                          |
| Object oriented         | Garden and Exodus          | Certain programming language                       |
| Object - Rational       | Sybase                     | SQL + User defined components                      |
| Semi structured and XML |                            |                                                    |



## What's Really New with NewSQL?

> A. Pavlo, et al., [What's New with NewSQL?](https://15721.courses.cs.cmu.edu/spring2020/papers/01-intro/pavlo-newsql-sigmodrec2016.pdf), in *SIGMOD Record (vol. 45, iss. 2)*, 2016 *(Optional)*

02 In-Memory Databases (No In-Class Lecture) 
=================================



## Staring into the Abyss: An Evaluation of Concurrency Control with One Thousand Cores

> X. Yu, et al., [Staring into the Abyss: An Evaluation of Concurrency Control with One Thousand Cores](https://15721.courses.cs.cmu.edu/spring2020/papers/02-inmemory/p209-yu.pdf), in *VLDB*, 2014



Main idea:

7 concurrent control algrithms, in 2 schemes(2PL and Timestamp Ordering), on a 1024 core simulator.

Bottlenecks to scalability: lock-thrashing, preemptive abort, deadlock, timestamp allocation, memory copying.

| 2PL               | T/O                |
| ----------------- | ------------------ |
| low contention    | higher contention  |
| short transaction | longer transaction |
| kv workload       | OLTP workload      |



Takeaway:

| Bottleneck                 | Direction                                       |
| -------------------------- | ----------------------------------------------- |
| timestamp allocation       | hardware counter, clock, and atomic addition    |
| memory allocation, copying | CPU background copyer, thread-local memory pool |
| No superior scheme         | switch between schemes or hybrid approach       |



System: 

- [mit-carbon/Graphite](https://github.com/mit-carbon/Graphite)



Workload:

- YCSB: Yahoo! Cloud Serving Benchmark.
  - Ziphan distribution.
- TPC-C: For OLTP systems.
  - Implement 2/5 of transactions, a good faith implementation.



03 Multi-Version Concurrency Control (Design Decisions)
===============================



## An Empirical Evaluation of In-Memory Multi-Version Concurrency Control

Main idea:

Scaling MVCC on modern multi-core, in-memory hardware setting.

Key design decisions:

- concurrency control protocol
  - Timestamp Ordering, Optimistic Concurrency Control, 2-Phase Locking, Serialization Certifier.
- version storage
  - Append Only(N2O/O2N), Time travel Storage(master table), Delta Storage
- garbage collection
  - Tuple level(Basic, Cooperative), Transaction level
- index management
  - Secondary key index: logical/physical pointer.



Takeaway:

- Storage scheme is important, some are influenced by allocation scheme.
  - Delta storage: high write performance, not good at read/table scan.

- MVTO works well for most workloads.

- Transaction level gc has small memory footprint, which is good.

- Logical pointer has higher throughput, especially when workload is update-intensive.



System: 

**TODO: Fill this table**

| Configuration | CC protocol | Storage Scheme | GC     | Index    |
| ------------- | ----------- | -------------- | ------ | -------- |
| Oracle/MySQL  | MV2PL       | Delta          | Vacuum | Logical  |
| Postgres      | MV2PL/MV-TO | Append-Only    | Vacuum | Physical |



Workload:

YCSB and TPC-C04 - Multi-Version Concurrency Control [Protocols]
======================



## Fast Serializable Multi-Version Concurrency Control for Main-Memory Database Systems

- T. Neumann, et al., [Fast Serializable Multi-Version Concurrency Control for Main-Memory Database Systems](https://15721.courses.cs.cmu.edu/spring2020/papers/04-mvcc2/p677-neumann.pdf), in *SIGMOD*, 2015 

Main idea:

- Serializability validation: Transaction level validation(modified/deleted/created objects), use a Predicate Tree. Marginal overhead.
  - What goes around: [Precision locks - SIGMOID 81'](https://dl.acm.org/doi/abs/10.1145/582318.582340)
- Scan: Update in-place and _VersionedPositions_. Strides in between two versioned objects are in the order of millions.
- GC with tombstone, index `update` by `delete` then `insert`.



Takeaway:

It's good to know internals of current databases' implementation. They might be simple and out-dated with state-of-art hardware.

Eg: Current serializability validation implementation in 2.3, check entire read set and re-checked in the end. It may be a suitable way in in-disk era.

- [ ] Check what goes around: [Precision locks - SIGMOID 81'](https://dl.acm.org/doi/abs/10.1145/582318.582340)



System used:

Research on [HyPer](https://dbdb.io/db/hyper).

This MVCC model suits HTAP databases best, like [SAP HANA](https://www.sap.com/hk/products/hana.html). Can be implemented in high-performance transactional systems, [H-Store](https://hstore.cs.brown.edu/)/[VoltDB](https://www.voltdb.com/). Little need to prefer snapshot isolation in the future.



Workload evaluated:







05 - Multi-Version Concurrency Control [Garbage Collection] (CMU Databases / Spring 2020)
=======================================



## Scalable Garbage Collection for In-Memory MVCC Systems

J. Böttcher, et al., [Scalable Garbage Collection for In-Memory MVCC Systems](https://15721.courses.cs.cmu.edu/spring2020/papers/05-mvcc3/p128-bottcher.pdf), in *VLDB*, 2019 

Main idea:

- STEAM: Eagerly prune obsolete version.
- Thread local minimum and peek.
- Extra information in tuple: Insert list, attribute mask.

Takeaway:

In place GC would make system more robust to skew.



System used:

Hyper.



Workload evaluated:

CH benchmark, a stress test for GC.

TPC-C, scalability and overhead.

