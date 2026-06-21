# UART Protocol Implementation (Verilog and SystemVerilog)

## Overview
This project implements a complete **UART (Universal Asynchronous Receiver Transmitter)** communication system in Verilog, including:

- UART Transmitter (`uart_tx`)
- UART Receiver (`uart_rx`)
- Testbench (`uart_tb`)

The design supports serial communication using standard UART framing:
- **1 Start bit**
- **8 Data bits**
- **1 Stop bit**
- **No parity**

The project is designed and simulated in **AMD Vivado**.

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Clock Frequency | 25 MHz |
| Baud Rate | 115200 |
| Clock Cycles per Bit | 217 |
| Data Width | 8-bit |
| Parity | None |
| Stop Bits | 1 |

Clock-per-bit calculation:

```text
clk_per_bit = Clock Frequency / Baud Rate
            = 25,000,000 / 115200
            ≈ 217
```

---

## Project Structure

```bash
UART/
│── uart_tx.v
│── uart_rx.v
│── uart_tb.sv
│── README.md
```

---

# UART Transmitter (`uart_tx`)

## Description
The UART transmitter converts 8-bit parallel input data into serial output data.

Transmission sequence:
1. Idle state (line remains HIGH)
2. Start bit (LOW)
3. 8-bit data transmission (LSB first)
4. Stop bit (HIGH)

---

## Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | System clock |
| rst | 1 | Active-low reset |
| dval | 1 | Data valid signal to start transmission |
| data_in | 8 | Parallel input data |

---

## Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| tx_serial | 1 | UART serial output |
| active | 1 | Transmission in progress |
| done | 1 | Transmission completed |

---

## FSM States

```text
IDLE  -> Waiting for valid data
START -> Sends start bit
DATA  -> Sends 8-bit data
STOP  -> Sends stop bit
```

---

# UART Receiver (`uart_rx`)

## Description
The UART receiver converts serial UART data back into parallel 8-bit data.

Reception sequence:
1. Wait for start bit detection
2. Sample start bit midpoint
3. Receive 8 data bits
4. Detect stop bit
5. Assert data valid signal

---

## Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| clk | 1 | System clock |
| rx_serial | 1 | Serial input |

---

## Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| dataout | 8 | Received parallel data |
| dataval | 1 | Data received successfully |

---

## FSM States

```text
IDLE    -> Waiting for start bit
START   -> Validate start bit
DATA    -> Receive data bits
STOP    -> Receive stop bit
CLEANUP -> Finalize reception
```

---

# Testbench (`uart_tb`)

## Description
The testbench verifies end-to-end UART communication by connecting transmitter output to receiver input.

### Test Flow
1. Reset transmitter
2. Send 8-bit data (`8'h3F`)
3. UART TX serially transmits data
4. UART RX receives data
5. Compare transmitted and received data

---

## Test Data

```verilog
datain = 8'h3F
```

Decimal equivalent:

```text
63
```

Binary:

```text
00111111
```

---

## Expected Output

Successful simulation should print:

```text
TRANSMISSION SUCCESSFULL: RECEIVED BIT = 63 SENT BIT = 63
```

---

# Simulation

## Tool Used
- AMD Vivado Simulator

---

## Steps to Run
1. Open Vivado
2. Create new RTL project
3. Add:
   - `uart_tx.v`
   - `uart_rx.v`
   - `uart_tb.sv`
4. Set `uart_tb` as top module
5. Run simulation

---

# Key Concepts Demonstrated

- UART Protocol Implementation
- FSM-based Serial Communication
- Parallel-to-Serial Conversion
- Serial-to-Parallel Conversion
- Timing Control using Clock Counters
- End-to-End Verification using Testbench

---

# Applications

UART is widely used in:
- Microcontroller communication
- Embedded systems
- Debug interfaces
- Bluetooth modules
- GPS modules
- Serial peripherals

---


---

# Author
Protocol Design & Verification Project Repository
