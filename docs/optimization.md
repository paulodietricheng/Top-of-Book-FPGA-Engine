# Optimization Timeline

This document outlines the evolution of the design, focusing on architectural changes, their impact on performance, and the reasoning behind each decision.

---

## Baseline (Unpipelined Arbiter)

**Configuration**
- 8 cycles
- 85 MHz
- ~94 ns latency

**Bottleneck**
- Unpipelined reduction tree
- Deep combinational path (33 logic levels)
- High fanout and carry chain depth

**Insight**
A linear reduction of N inputs creates excessive combinational depth. This structure does not scale and fundamentally limits frequency.

**Action**
Introduce pipelining into the arbitration structure.

---

## Arbiter Pipeline

**Change**
- Converted reduction tree into a pipelined tournament tree
- Inserted registers between every comparison levels

**Result**
- 10 cycles
- 182 MHz
- ~55 ns latency

**Impact**
- Significant reduction in combinational depth per stage
- Major improvement in Fmax
- Increased latency due to added pipeline stages

**Tradeoff**
Latency increased (+2 cycles), but overall time-domain latency improved due to higher frequency.

---

## Datapath Optimization

**Change**
- Reused spread computation for crossed market detection
- Simplified filter logic to invalidate only the valid bit
- Reduced comparator width by removing non-critical fields (size)

**Result**
- 10 cycles
- 223.4 MHz
- ~44.8 ns latency

**Impact**
- Reduced logic depth in critical paths
- Lower fan-in for comparator logic
- Improved timing without increasing latency
- FPGA's implement `A > B` as `A - B > 0`

**Insight**
Datapath simplification can yield meaningful timing improvements without architectural changes.

---

## Filter Bottleneck Identification

**Observation**
The filter stage became the critical path.

**Details**
- Timestamp comparison implemented using carry chains
- Comparison result drives clock enable (CE)
- Combines data path and control logic

**Impact**
- ~6 logic levels in critical path
- Difficult to pipeline without introducing additional latency

**Insight**
Control-dependent paths (e.g., CE gating) are harder to optimize than pure datapath logic.

---

### Filter Pipelining Experiment (Rejected)

**Change**
- Split filter into two stages:
  - Stage 1: evaluate timestamp condition
  - Stage 2: apply validity update

**Result**
- 11 cycles
- 240.8 MHz
- ~45.7 ns latency

**Impact**
- Improved Fmax
- Increased latency

**Decision**
Rejected.

**Reason**
Although frequency improved, total time-domain latency increased (+ ~0.9 ns). The design prioritizes absolute latency over frequency.

---

## Final Pipeline Refinement

**Change**
- Made `Decode` and `Scoring` stages fully combinational
- Moved `valid` gating into `canonicalization` stage, which now holds state.

**Result**
- 8 cycles
- 223.4 MHz
- ~35.8 ns latency

**Impact**
- Reduced latency without affecting timing
- Maintained high frequency while eliminating redundant stages

**Insight**
Careful removal of pipeline stages can improve latency without degrading Fmax when stages are not timing-critical.

---

## Final Design Summary

- 8 cycles @ 223.4 MHz
- ~35.8 ns latency
- Fully streaming, deterministic pipeline
- Critical path located in filter stage (timestamp comparison + CE logic)

