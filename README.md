# Simple Antivirus Daemon

## 1. Overview

This project implements a simple antivirus daemon using Bash scripts. It scans files in a specified directory, identifies potentially malicious files based on their extensions or contents, and moves flagged files to a quarantine directory. A separate script allows users to review quarantined files and restore false positives or permanently delete malicious files.

### Folder Structure

```text
oslab1/
├── antivirusd.sh
├── restore.sh
├── Makefile
├── README.md
├── dir/
└── malicious_dir/
```

* `antivirusd.sh`: Scans the monitored directory and quarantines flagged files.
* `restore.sh`: Allows users to restore quarantined files or permanently delete them.
* `Makefile`: Creates the quarantine directory and provides commands to run both scripts.
* `dir/`: The directory monitored by the antivirus.
* `malicious_dir/`: Stores quarantined files.

## 2. Prerequisites

The project requires Ubuntu and Bash. The `make` utility is also required to use the Makefile.

Install Make if it is not already installed:

```bash
sudo apt update
sudo apt install make
```

Git is optional and is only needed to clone or update the project repository.

## 3. Running the Project

### Step 1: Open the project directory

Navigate to the folder containing the project files:

```bash
cd ~/Desktop/lab1/oslab1
```

### Step 2: Prepare the directories

Create the monitored directory if it does not already exist:

```bash
mkdir -p dir
```

The Makefile automatically creates `malicious_dir` before running either tool.

### Step 3: Run the antivirus

```bash
make antivirus
```

The antivirus scans `dir` and checks it periodically using an interval of 5 seconds. Flagged files are moved to `malicious_dir`.

Press `Ctrl+C` to stop the daemon.

### Step 4: Review quarantined files

```bash
make restore
```

Choose a quarantined file, then select one of the available actions:

1. Restore the file to the monitored directory if it is a false positive.
2. Permanently delete the file if it is malicious.
3. Return to the file list.

## 4. Flagged Extensions and Keywords

The flagged file extensions are defined in the `scan()` function in `antivirusd.sh`. They currently include `.exe`, `.bat`, `.vbs`, `.scr`, and `.ps1`.

The flagged keywords are also checked in the `scan()` function using `grep`. The current keyword list includes terms such as `virus`, `trojan`, `malware`, `worm`, and `ransomware`.

These checks are simple indicators and do not constitute comprehensive malware detection.
