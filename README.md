# Communication_Protocols_Implementation

## Overview
This repository contains my implementation and verification of widely used communication protocols in digital systems and SoC design.

The projects cover both:
- **RTL Design using Verilog/SystemVerilog**
- **Protocol Verification using UVM**

The goal of this repository is to build strong understanding of:
- Serial communication protocols
- Bus architectures
- Protocol timing
- FSM-based design
- Verification methodologies

---

# Protocols Included

This repository currently contains implementations of:

- UART (Universal Asynchronous Receiver Transmitter)
- SPI (Serial Peripheral Interface)
- I2C (Inter-Integrated Circuit)
- APB (Advanced Peripheral Bus)

---

# Repository Structure

```bash
Protocols/
│── UART/
│   ├── uart_tx.v
│   ├── uart_rx.v
│   ├── uart_tb.v
│   └── README.md
│
│── SPI/
│   ├── SPI_MASTER.v
│   ├── spi_slave.v
│   ├── spi_tb.v
│   └── README.md
│
│── I2C/
│   ├── i2c_master.v
│   ├── i2c_slave.v
│   ├── i2c_slave2.v
│   ├── i2c_tb.v
│   └── README.md
│
│── APB/
│   ├── dut_if.sv
│   ├── apb_slave.sv
│   ├── transaction.sv
│   ├── sequence.sv
│   ├── sequencer.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── subscriber.sv
│   ├── agent.sv
│   ├── environment.sv
│   ├── test.sv
│   ├── tb.sv
│   └── README.md
│
└── README.md
```

---

# Project Summary

---

## 1. UART Protocol

### Features
- UART Transmitter
- UART Receiver
- Full communication verification using testbench

### Specifications
- Clock Frequency: 25 MHz
- Baud Rate: 115200
- 8-bit Data
- 1 Start Bit
- 1 Stop Bit
- No Parity

### Concepts Covered
- FSM design
- Serial communication
- Parallel-to-Serial conversion
- Serial-to-Parallel conversion

---

## 2. SPI Protocol

### Features
- SPI Master
- Multiple SPI Slaves
- Full duplex communication
- All 4 SPI modes supported

### Concepts Covered
- Master-slave communication
- Clock polarity/phase handling
- Multi-slave selection
- Full duplex serial transfer

Supported Modes:
- Mode 0
- Mode 1
- Mode 2
- Mode 3

---

## 3. I2C Protocol

### Features
- I2C Master
- Multiple I2C Slaves
- Read and Write operations
- Open-drain bus behavior

### System Architecture
- Sensor Slave
- Display Slave
- Master Controller

### Concepts Covered
- Address-based communication
- Multi-slave architecture
- ACK/NACK handling
- Open-drain bus modeling

Data flow:
```text
Sensor → Master → Display
```

---

## 4. APB Protocol

### Features
- APB Slave RTL
- Full UVM Verification Environment
- Randomized transactions
- Functional coverage
- Scoreboard checking

### UVM Components
- Transaction
- Sequence
- Sequencer
- Driver
- Monitor
- Agent
- Environment
- Scoreboard
- Subscriber

### Concepts Covered
- Bus protocol verification
- Constrained random testing
- Functional coverage
- UVM methodology

---

# Tools Used

| Protocol | Tool |
|----------|------|
| UART | Xilinx Vivado |
| SPI | Xilinx Vivado |
| I2C | Xilinx Vivado |
| APB | EDA Playground |

Languages used:
- Verilog
- SystemVerilog
- UVM

---

# Key Skills Demonstrated

This repository demonstrates practical understanding of:

### Digital Design
- RTL design
- FSM design
- Protocol implementation
- Timing-based control logic

### Verification
- Testbench creation
- Protocol validation
- UVM architecture
- Functional coverage
- Scoreboard design

### Protocol Knowledge
- UART
- SPI
- I2C
- APB

---

# Highlights

- Protocol implementations from scratch
- Both design and verification focused
- Covers serial and bus-based protocols
- Includes industry-standard UVM verification
- Practical simulation-based validation

---

# Learning Objectives

This repository was built to strengthen understanding of:
- Communication protocols in embedded systems
- Bus protocols in SoC design
- Digital verification methodologies
- Industry verification workflows

---

