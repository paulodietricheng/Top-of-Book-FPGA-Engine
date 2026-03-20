# datapath branch

Applies datapath and comparator optimizations.

- Reused spread computation for cross detection
- Simplified filter logic by invalidating only the valid bit
- Reduced comparator width by removing non-critical fields

Result: 223.4 MHz at 10 cycles (~44.8 ns latency)

See main README and /docs/optimizations.md for full details.
