# I2C Protocol Implementation (Verilog and SystemVerilog)

## Overview
This project implements a complete **I2C (Inter-Integrated Circuit)** communication system in Verilog and SystemVerilog.

The design includes:
- I2C Master (`i2c_master`)
- Sensor Slave (`i2c_slave`)
- Display Slave (`i2c_slave2`)
- Testbench (`i2c_tb`)

The project demonstrates:
- Multi-slave I2C communication
- Read operation from one slave
- Write operation to another slave
- Open-drain bus behavior using pull-up resistors

The design is developed and simulated using **AMD Vivado**.

---

## I2C Basics

I2C is a synchronous two-wire serial communication protocol.

It uses only two signals:

| Signal | Description |
|--------|-------------|
| SDA | Serial Data Line |
| SCL | Serial Clock Line |

Key features:
- Multi-master / multi-slave support
- Address-based communication
- Half-duplex communication
- Open-drain architecture with pull-up resistors

---

## Project Structure

```bash
I2C/
│── i2c_master.sv
│── i2c_slave.sv
│── i2c_slave2.sv
│── i2c_tb.sv
│── README.md
```

---

# System Architecture

```text
                +----------------+
                |   I2C Master   |
                +--------+-------+
                         |
                 SDA / SCL Bus
                         |
         --------------------------------
         |                              |
+----------------+            +----------------+
| Sensor Slave   |            | Display Slave  |
| Address = 81   |            | Address = 18   |
+----------------+            +----------------+
```

---

# I2C Master (`i2c_master`)

## Description
The master controls all communication over the I2C bus.

Responsibilities:
- Generate clock (SCL)
- Generate START condition
- Send slave address
- Send register address
- Perform read/write operation
- Generate STOP condition

---

## Inputs

| Signal | Width | Description |
|--------|-------|-------------|
| slave_address_in | 7 | Target slave address |
| slave_register_addr_in | 8 | Target register |
| data_in | 8 | Data to write |
| rw | 1 | Read/Write control |
| run | 1 | Start transaction |
| clk | 1 | System clock |

---

## Outputs

| Signal | Width | Description |
|--------|-------|-------------|
| sda | 1 | Bidirectional data line |
| scl | 1 | Serial clock |
| data_out | 8 | Received data |

---

## Supported Operations

### Read Operation
Master reads data from slave register.

Sequence:
```text
START
→ Slave Address
→ R/W = 1
→ ACK
→ Register Address
→ ACK
→ Read Data
→ ACK
→ STOP
```

---

### Write Operation
Master writes data to slave register.

Sequence:
```text
START
→ Slave Address
→ R/W = 0
→ ACK
→ Register Address
→ ACK
→ Write Data
→ ACK
→ STOP
```

---

# Sensor Slave (`i2c_slave`)

## Description
Represents a sensor-like I2C peripheral.

Slave Address:
```text
81
```

Registers:
| Register | Address | Data |
|----------|---------|------|
| Register 1 | 201 | 10 |
| Register 2 | 202 | 20 |
| Register 3 | 203 | 30 |

This slave primarily responds to **read requests**.

---

# Display Slave (`i2c_slave2`)

## Description
Represents an LCD/display peripheral.

Slave Address:
```text
18
```

Registers:
| Register | Address |
|----------|---------|
| Register 1 | 251 |
| Register 2 | 252 |
| Register 3 | 253 |

This slave receives data and displays it.

Example output:
```text
[LCD DISPLAY]: 20
```

---

# Bus Behavior

The design models I2C bus behavior using:

```verilog
pullup(w1);
pullup(w2);
```

This correctly simulates:
- Open-drain SDA
- Open-drain SCL
- Idle HIGH bus state

---

# Testbench (`i2c_tb`)

## Description
The testbench demonstrates a real communication workflow.

---

## Phase 1: Read from Sensor Slave

Configuration:
```text
Slave Address   = 81
Register Address = 202
RW = 1 (Read)
```

Expected result:
- Master reads data from sensor slave register 202
- Returned value = 20

Console output:
```text
DATA FROM SENSOR SLAVE = 20
```

---

## Phase 2: Write to Display Slave

Configuration:
```text
Slave Address   = 18
Register Address = 251
RW = 0 (Write)
Data = 20
```

Expected result:
- Master writes sensor data to display slave
- Display slave outputs:

```text
[LCD DISPLAY]: 20
```

---

# Simulation Flow

1. Initialize all modules
2. Start read transaction from Sensor Slave
3. Receive sensor data
4. Start write transaction to Display Slave
5. Send received sensor data to display
6. Display Slave prints received data

---

# Key Concepts Demonstrated

- I2C Protocol Implementation
- Multi-Slave Communication
- Address-Based Communication
- Read and Write Transactions
- START/STOP Conditions
- ACK/NACK Handling
- Open-Drain Bus Modeling

---

# Applications

I2C is widely used in:
- Sensors
- RTC modules
- EEPROM
- LCD displays
- ADC/DAC devices
- Embedded systems

---

# Simulation

## Tool Used
- Xilinx Vivado Simulator

---

## Steps to Run

1. Open Vivado
2. Create project
3. Add:
   - `i2c_master.sv`
   - `i2c_slave.sv`
   - `i2c_slave2.sv`
   - `i2c_tb.sv`
4. Set `i2c_tb` as top module
5. Run simulation

---

---

# Author
Protocol Design & Verification Project Repository
