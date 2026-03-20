# baseline branch

Initial implementation with an unpipelined arbiter.

- Deep combinational reduction tree
- No pipelining between comparison stages

Result: 85 MHz at 8 cycles (~94 ns latency)

This version serves as the performance baseline for all subsequent optimizations.

See main README and /docs/optimizations.md for full details.
