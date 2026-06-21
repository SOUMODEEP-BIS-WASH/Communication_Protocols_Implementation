# SPI Protocol Implementation (Verilog and SystemVerilog)

## Overview
This project implements a complete **SPI (Serial Peripheral Interface)** communication system in Verilog, including:

- SPI Master (`SPI_MASTER`)
- SPI Slave (`spi_slave`)
- Testbench (`spi_tb`)

The design supports:
- Full duplex communication
- Multiple slave selection
- All 4 SPI modes (Mode 0, 1, 2, 3)

The project is designed and simulated using **AMD Vivado**.

---

## SPI Basics

SPI is a synchronous serial communication protocol commonly used for communication between:
- Microcontrollers
- Sensors
- ADC/DAC
- Flash Memory
- Peripheral ICs

---

## SPI Signals

| Signal | Description |
|--------|-------------|
| MOSI | Master Out Slave In |
| MISO | Master In Slave Out |
| SCLK | Serial Clock |
| SS | Slave Select |

---

## Project Structure

```bash
SPI/
│── SPI_MASTER.sv
│── spi_slave.sv
│── spi_tb.sv
│── README.md
```

---

# SPI Master (`SPI_MASTER`)

## Description
The SPI master controls communication with slave devices.

Responsibilities:
- Generate serial clock (`SCLK`)
- Select slave using slave select lines
- Transmit data via MOSI
- Receive data via MISO

This implementation supports communication with **4 slave devices**.

---

## Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| s0 | 1 | SPI mode select |
| s1 | 1 | SPI mode select |
| miso | 1 | Data from slave |
| run | 1 | Start communication |
| ss_0 | 1 | Slave select bit 0 |
| ss_1 | 1 | Slave select bit 1 |
| din | 8 | Input data to transmit |

---

## Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| mosi | 1 | Data sent to slave |
| sclk | 1 | SPI clock |
| done | 1 | Transaction complete |
| dout | 8 | Data received from slave |
| ss1–ss4 | 1 | Slave select outputs |

---

## Slave Selection Logic

| ss_1 | ss_0 | Selected Slave |
|------|------|----------------|
| 0 | 0 | Slave 1 |
| 0 | 1 | Slave 2 |
| 1 | 0 | Slave 3 |
| 1 | 1 | Slave 4 |

---

# SPI Slave (`spi_slave`)

## Description
The SPI slave receives serial data from master via MOSI and sends data back through MISO.

Responsibilities:
- Receive serial data
- Transmit serial response
- Support all SPI modes
- Operate only when selected

---

## Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| s0 | 1 | SPI mode select |
| s1 | 1 | SPI mode select |
| mosi | 1 | Data from master |
| run | 1 | Start transaction |
| ss | 1 | Slave select |
| sclk | 1 | SPI clock |
| din | 8 | Slave transmit data |

---

## Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| miso | 1 | Data sent to master |
| done | 1 | Transaction complete |
| dout | 8 | Data received |

---

# SPI Modes Supported

This implementation supports all 4 SPI modes.

| Mode | CPOL | CPHA | Description |
|------|------|------|-------------|
| Mode 0 | 0 | 0 | Sample rising, shift falling |
| Mode 1 | 0 | 1 | Sample falling, shift rising |
| Mode 2 | 1 | 0 | Sample rising, shift falling |
| Mode 3 | 1 | 1 | Sample falling, shift rising |

Implementation mapping:

| s1 | s0 | Mode |
|----|----|------|
| 0 | 0 | Mode 0 |
| 0 | 1 | Mode 1 |
| 1 | 0 | Mode 2 |
| 1 | 1 | Mode 3 |

Separate tasks are implemented for each mode:
- `spi_operation_00()`
- `spi_operation_01()`
- `spi_operation_10()`
- `spi_operation_11()`

---

# Testbench (`spi_tb`)

## Description
The testbench verifies communication between:
- 1 SPI Master
- 4 SPI Slaves

Each slave has unique input data.

---

## Slave Data

| Slave | Data |
|-------|------|
| Slave 1 | 10 |
| Slave 2 | 20 |
| Slave 3 | 30 |
| Slave 4 | 40 |

Master input data:

```text
230
```

---

## Test Configuration

Current simulation settings:

- SPI Mode: Mode 0 (`s0=0`, `s1=0`)
- Selected Slave: Slave 4 (`ss_0=1`, `ss_1=1`)

Thus communication occurs between:
- Master ↔ Slave 4

---

## Simulation Flow

1. Initialize all modules
2. Load transmit data into master and slaves
3. Select slave
4. Enable run signal
5. Start SPI communication
6. Exchange 8-bit serial data
7. Verify received output

---

# Communication Features

- Full duplex transfer
- Simultaneous transmit and receive
- Multiple slave architecture
- Mode-selectable SPI operation
- 8-bit data transactions

---

# Simulation

## Tool Used
- Xilinx Vivado Simulator

---

## Steps to Run
1. Open Vivado
2. Create RTL project
3. Add:
   - `SPI_MASTER.sv`
   - `spi_slave.sv`
   - `spi_tb.sv`
4. Set `spi_tb` as top module
5. Run simulation

---

# Key Concepts Demonstrated

- SPI Protocol Implementation
- Master-Slave Communication
- Multi-Slave Selection
- Full Duplex Data Transfer
- Clock Phase/Polarity Handling
- Serial Shift Operations

---

# Applications

SPI is widely used in:
- Flash Memory
- EEPROM
- Sensors
- Displays
- SD Cards
- ADC/DAC interfaces

---

---

# Author
Protocol Design & Verification Project Repository
