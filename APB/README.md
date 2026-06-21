# APB Protocol Verification using UVM

## Overview
This project implements and verifies an **AMBA APB (Advanced Peripheral Bus)** slave using **SystemVerilog and UVM**.

The project includes:
- APB Slave RTL Design
- UVM-based Verification Environment
- Functional Coverage
- Scoreboard-based Data Checking

The verification environment generates randomized read/write transactions and validates correct APB protocol behavior.

Tool used:
- **EDA Playground**

---

# APB Basics

APB (Advanced Peripheral Bus) is part of ARM's AMBA protocol family.

It is designed for:
- Low bandwidth communication
- Low power peripherals
- Simple register access

Common APB peripherals:
- UART
- Timer
- GPIO
- Interrupt controller

---

## APB Signals

| Signal | Description |
|--------|-------------|
| PCLK | Bus clock |
| PRESETn / rst | Reset |
| PADDR | Address bus |
| PSEL | Slave select |
| PENABLE | Enable signal |
| PWRITE | Read/Write control |
| PWDATA | Write data |
| PRDATA | Read data |
| PREADY | Slave ready |

---

# Project Structure

```bash
APB/
│── APB_SLAVE.sv
│── UVM_TRANSACTION.sv
│── UVM_SEQUENCE.sv
│── UVM_SEQUENCER.sv
│── UVM_DRIVER.sv
│── UVM_MONITOR.sv
│── UVM_SCOREBOARD.sv
│── UVM_SUBSCRIBER.sv
│── UVM_AGENT.sv
│── UVM_ENVIRONMENT.sv
│── UVM_TEST.sv
│── UVM_TB.sv
│── README.md
```

---

# APB Slave RTL (`apb_slave`)

## Description
The DUT is an APB slave containing internal memory.

Memory:
```text
256 x 32-bit
```

Initial memory contents:
```text
mem[i] = i
```

---

## Supported Operations

### Write Transaction
Master writes data into selected address.

Example:
```text
PADDR  = 10
PWDATA = 55
```

Result:
```text
mem[10] = 55
```

---

### Read Transaction
Master reads data from selected address.

Example:
```text
PADDR = 10
```

Result:
```text
PRDATA = mem[10]
```

---

# APB Transaction Phases

APB transfers occur in two phases.

---

## 1. Setup Phase

Signals:
```text
PSEL   = 1
PENABLE = 0
```

Address and control signals become valid.

---

## 2. Enable Phase

Signals:
```text
PSEL   = 1
PENABLE = 1
```

Data transfer occurs.

---

# DUT Interface (`dut_if`)

The interface contains:
- APB signals
- Clocking blocks
- Modports for:
  - Master
  - Slave
  - Passive monitor

Clocking blocks improve synchronization for:
- Driver
- Monitor
- DUT interaction

---

# UVM Verification Architecture

```text
Sequence
   ↓
Sequencer
   ↓
Driver
   ↓
DUT (APB Slave)
   ↓
Monitor
   ↓
---------------------------------
|               |               |
Scoreboard   Subscriber     Coverage
```

---

# UVM Components

---

## Transaction (`transaction`)
Defines APB transactions.

Fields:
- `paddr`
- `data`
- `pwrite`

Transaction types:
```systemverilog
READ
WRITE
```

Constraints:
- Address range: 0–255
- Data range: 0–255

---

## Sequence (`apb_sequence`)
Generates randomized APB transactions.

Behavior:
- Generates 5 random transactions
- Includes both READ and WRITE

---

## Sequencer (`apb_sequencer`)
Controls flow of sequence items to driver.

---

## Driver (`apb_driver`)
Converts transactions into APB pin-level activity.

Responsibilities:
- Drive setup phase
- Drive enable phase
- Perform read/write operations

Write flow:
```text
SETUP → ENABLE
```

Read flow:
```text
SETUP → ENABLE → Capture PRDATA
```

---

## Monitor (`apb_mon`)
Passively observes APB bus activity.

Responsibilities:
- Detect transactions
- Validate APB protocol behavior
- Capture transaction data
- Send transactions to scoreboard/subscriber

Checks:
- Setup phase followed by Enable phase

Protocol violation example:
```text
SETUP not followed by ENABLE
```

---

## Agent (`apb_agt`)
Contains:
- Sequencer
- Driver
- Monitor

Responsibilities:
- Connect sequencer to driver
- Configure all APB components

---

## Environment (`apb_env`)
Top-level verification environment.

Contains:
- Agent
- Scoreboard
- Subscriber

Responsibilities:
- Connect monitor outputs
- Manage verification flow

---

## Scoreboard (`apb_scoreboard`)
Reference model for correctness checking.

Internal memory:
```text
sc_mem[0:255]
```

Initialization:
```text
sc_mem[i] = i
```

Responsibilities:
- Update reference memory on writes
- Compare read data with expected values

Possible results:
- READ Match
- READ Mismatch

Example:
```text
Expected Data = 10
Actual Data = 10
```

---

## Subscriber (`apb_sub`)
Implements functional coverage.

Coverage points:
- Address coverage
- Data coverage

Covergroup:
```systemverilog
coverpoint addr
coverpoint data
```

This helps measure:
- Address space coverage
- Data range coverage

---

# Test (`apb_test`)

The test:
1. Creates environment
2. Starts APB sequence
3. Raises objection
4. Runs randomized transactions
5. Drops objection

---

# Testbench (`tb`)

Responsibilities:
- Instantiate interface
- Instantiate DUT
- Generate clock
- Apply reset
- Configure virtual interface
- Start UVM test

Clock:
```text
20 ns period
```

---

# Verification Features

- Randomized transaction generation
- Read/Write verification
- Protocol checking
- Scoreboard validation
- Functional coverage collection

---

# Simulation Flow

1. Reset DUT
2. Initialize UVM environment
3. Generate random transactions
4. Driver sends APB transactions
5. DUT responds
6. Monitor captures bus activity
7. Scoreboard validates data
8. Coverage collected

---

# Key Concepts Demonstrated

- AMBA APB Protocol
- UVM Testbench Architecture
- Constrained Random Verification
- Functional Coverage
- Scoreboard-based Checking
- Protocol Monitoring

---

# Tool Used
- EDA Playground

---

# Applications

APB is widely used in:
- SoC peripheral buses
- Register-based communication
- Embedded systems
- Low-power digital designs

---

---

# Author
Protocol Design & Verification Project Repository
