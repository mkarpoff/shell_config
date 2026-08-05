---
name: job-lookup
description: Look up job requisition and job posting details using a jobGuid or iCIMS ID. Use when asked about job details, requisition info, job status, hiring manager, job location, or any job/req lookup.
version: 1.0.0
---

# Job Lookup

## Overview
Retrieve job requisition details from the Hire API using `ReadInternalWebsites`.

## Usage
Use this skill when:
- User asks about a job, requisition, or req by ID
- User needs job details like title, status, location, hiring manager
- Oncall needs to look up job posting information
- User provides a jobGuid or iCIMS ID

## Core Concepts

**Job identifiers:** Jobs are referenced by either a `jobGuid` (UUID format) or an `iCIMS ID` (numeric). Both work as the `jobGuid` query parameter.

**Environments:**

| Environment | URL |
|-------------|-----|
| Beta | `https://hire-beta.amazon.com/jdpv2/api/job-details?jobGuid={id}` |
| Gamma | `https://hire-gamma.amazon.com/jdpv2/api/job-details?jobGuid={id}` |
| Prod | `https://hire.amazon.com/jdpv2/api/job-details?jobGuid={id}` |

You **MUST** default to prod unless the user specifies beta or gamma.

## Quick Reference

**Lookup a job:**
```
ReadInternalWebsites: https://hire.amazon.com/jdpv2/api/job-details?jobGuid={id}
```

Replace `{id}` with the jobGuid or iCIMS ID provided by the user.

## Common Mistakes

- Using beta/gamma when user didn't ask for it — always default to prod
- Forgetting to substitute the actual ID into the URL template
