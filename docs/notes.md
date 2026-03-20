# arbiter branch

Introduces a pipelined tournament tree for arbitration.

- Reduction tree split across multiple pipeline stages
- Reduced combinational depth per stage

Tradeoff: Increased latency from 8 → 10 cycles

Result: 182 MHz at 10 cycles (~55 ns latency)

See main README and /docs/optimizations.md for full details.
