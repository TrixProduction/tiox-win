# TakeItOver X (TIOX)

**TakeItOver X (TIOX)** is a simple and fast toolset designed to discover vulnerable or misconfigured domains, specifically those that return a Shopify misconfiguration page. It is designed for researchers, auditors, or security enthusiasts who want to identify abandoned or unclaimed domains pointing to Shopify infrastructure.

## Project Structure

```
TIOX/
├── executables/              # Place httpx.exe and other dependencies here
├── outputs/                  # Generated result files will be written here
├── scripts/                  # All PowerShell scripts are located here
│   ├── scan-vulnerable.ps1           # Scanner for Shopify misconfigured titles
│   ├── extract-shopify-cname.ps1     # Extract domains pointing to shops.myshopify.com
│   └── extract-naive-domains.ps1     # Naive extractor from zone files (no CNAME check)
├── README.md
```

## Requirements

* PowerShell (Windows)
* [httpx](https://github.com/projectdiscovery/httpx) binary (`httpx.exe`) placed inside the `executables/` folder
* Domain list file in `.txt` format (one domain per line for scan, or zone-like format for extractors)

## Scripts

### 1. `scan-vulnerable.ps1`

Scans a list of domains and checks for Shopify misconfiguration by inspecting page titles.

**Usage:**

```powershell
cd scripts
.\scan-vulnerable.ps1 -i ../yourlist.txt -o ../outputs/results.txt
```

**Input format:** one domain per line (e.g. `domain.com`, `www.example.net`)

**Output:** the script writes all domains returning one of the following titles:

* "Domain misconfigured"
* "Create an Ecommerce Website and Sell Online! Ecommerce Software by Shopify"

**Optimized for speed:** 100 domains are batched at a time with httpx multi-threaded execution.

---

### 2. `extract-shopify-cname.ps1`

Parses a zone file and extracts domains pointing to `shops.myshopify.com.` (via CNAME).

**Usage:**

```powershell
cd scripts
.\extract-shopify-cname.ps1 -inputFile ../zonefile.txt
```

**Input format:** raw DNS zone text (e.g. from ICANN CZDS), where each line may contain CNAME entries

**Output:** A file named `domaine-{inputFilename}.txt` in the `scripts/` folder, with each domain on a new line, deduplicated and cleaned (no trailing dot).

---

### 3. `extract-naive-domains.ps1`

Extracts all domains from a zone file that are under 103 characters in length, regardless of DNS target.

**Usage:**

```powershell
cd scripts
.\extract-naive-domains.ps1 -inputFile ../zonefile.txt
```

**Input format:** raw DNS zone file, same as above.

**Output:** A file named `domaine-{inputFilename}.txt`, with filtered, deduplicated domains below 103 characters.

---

## Where to Get Domain Lists

For optimal results, use one of the following sources to get fresh domain data:

* [ICANN CZDS](https://czds.icann.org) — Official zone file access per TLD
* [whoisds.com](https://whoisds.com/newly-registered-domains) — Daily TXT exports of newly registered domains
* [ExpiredDomains.net](https://www.expireddomains.net) — Recently registered and dropped domains

Zone files from ICANN CZDS must be requested and approved. Once downloaded, they can be used with the extract scripts.

**Zone file format expectations:**

```
domain.tld.    3600    IN    CNAME    shops.myshopify.com.
```

## Notes

* This tool does not attempt exploitation — it is for **detection only**.
* Ensure `httpx.exe` is in the `executables/` folder or accessible via system PATH.
* All outputs are written to the `outputs/` folder or beside the scripts by default.
