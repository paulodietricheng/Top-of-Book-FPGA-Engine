# filter_exp branch

Experimental pipelined filter stage.

- Split timestamp validation across two pipeline stages
- Reduced critical path in filter logic

Tradeoff: Increased latency from 10 → 11 cycles

Result: 240.8 MHz at 11 cycles (~45.7 ns latency)

This approach was rejected due to worse time-domain latency despite higher frequency.

See main README and /docs/optimizations.md for full details.
