# Simple Antivirus Daemon

## 1. Overview

This project implements a simple antivirus daemon using Bash scripts. It scans files in a specified directory, identifies potentially malicious files based on their extensions or contents, and moves flagged files to a quarantine directory. A separate script allows users to review quarantined files and restore false positives or permanently delete malicious files.

### Folder Structure

```text
oslab1/
├── antivirusd.sh
├── restore.sh
├── antivirus-cron.sh
├── Makefile
├── README.md
└── whitelist
```

* `antivirusd.sh`: Scans the monitored directory and quarantines flagged files.
* `restore.sh`: Allows users to restore quarantined files or permanently delete them.
* `antivirus-cron.sh`: Performs a single scan for scheduled cron execution.
* `Makefile`: Creates the quarantine directory and provides commands to run both scripts.
* `whitelist`: Stores the paths of files identified as false positives.

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
## 5. Cron Job (Bonus)

The `antivirus-cron.sh` script performs one scan of the monitored directory and moves flagged files into `malicious_dir`. Unlike `antivirusd.sh`, it does not run continuously. Cron is used to schedule repeated scans.

### Prerequisites

- Linux with Bash and cron installed and running.
- `antivirus-cron.sh` and the project files downloaded.
- A monitored directory named `dir`.
- A quarantine directory named `malicious_dir`.

### Step 1: Prepare the directories

From the project directory, run:

```bash
mkdir -p dir malicious_dir
```

### Step 2: Configure the cron job

Open the current user's crontab:

```bash
crontab -e
```

Add the following line, replacing `/path/to/oslab1` with the absolute path to the project directory:

```cron
* * * * * sleep 23; /bin/bash /path/to/oslab1/antivirus-cron.sh /path/to/oslab1/dir /path/to/oslab1/malicious_dir
```

This schedules a scan every minute, delayed by approximately 23 seconds. Standard cron uses five time fields and does not directly support seconds.

Save and exit the editor. To verify the saved schedule, run:

```bash
crontab -l
```

To stop the scheduled scans, run `crontab -e` and remove the added line.

### Step 3: Third Friday schedule example

The five-field cron expression below illustrates 12:31 a.m. on Fridays that fall between the 15th and 21st of the month:

```cron
31 0 15-21 * 5 command
```

On many cron implementations, the day-of-month and day-of-week fields are evaluated as alternatives, so this expression can run on additional dates. Use a date-checking wrapper if the job must run **only on the third Friday**. Replace `command` with the command to be scheduled.

## 5. Whitelist

The project uses a file named `whitelist` to remember files that have been identified as false positives. This prevents files that have been restored from being flagged again during future scans.

### How a file is added

When the user runs `make restore` and chooses option 1 to restore a quarantined file, `restore.sh` moves the file back into the monitored directory and appends its path to `whitelist`. Each entry is stored on a separate line, for example:

```text
dir/keyword.txt
```

The `whitelist` file is stored in the project directory and persists after the daemon stops or restarts. Do not delete or clear this file if the saved whitelist entries need to be preserved.

### How scans check the whitelist

Before checking a file's extension or contents, both `antivirusd.sh` and `antivirus-cron.sh` search `whitelist` for an exact match to the file's path. If a match is found, the scanner skips that file. Otherwise, it checks the file against the configured malicious extensions and keywords.

The scanners use `grep -Fxq` for this check: `-F` treats the path as literal text and `-q` suppresses output.

This whitelist is a simple local record of files marked as false positives, not a general malware-detection system.
