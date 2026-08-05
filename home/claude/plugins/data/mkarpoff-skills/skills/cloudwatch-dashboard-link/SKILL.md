---
name: cloudwatch-dashboard-link
description: Generate external viewing links for CloudWatch dashboards. Use when the user wants to share, view, or get a link to a CloudWatch dashboard, or mentions cw-dashboards.
version: 1.0.0
---

# CloudWatch Dashboard Link

## Overview
Generates external viewing links for Amazon CloudWatch dashboards using the internal `cw-dashboards.aka.amazon.com` portal.

## Usage
Use this skill when:
- User asks for a link to view a CloudWatch dashboard
- User wants to share a CloudWatch dashboard externally
- User mentions "dashboard link" or "cw-dashboards"

## Core Concepts

The external dashboard URL format is:

```
https://cw-dashboards.aka.amazon.com/cloudwatch/dashboardInternal?accountId={ACCOUNT_ID}&name={DASHBOARD_NAME}#dashboards/dashboard/{DASHBOARD_NAME}
```

**Parameters:**
- `accountId` — The AWS account ID (12-digit number)
- `name` (query param) — The dashboard name as it appears in CloudWatch
- Fragment (`#dashboards/dashboard/{DASHBOARD_NAME}`) — Same dashboard name

## Quick Reference

Given an account ID and dashboard name, construct the link:

```
Account ID: 012168015891
Dashboard:  HireDebriefService-prod

Link: https://cw-dashboards.aka.amazon.com/cloudwatch/dashboardInternal?accountId=012168015891&name=HireDebriefService-prod#dashboards/dashboard/HireDebriefService-prod
```

You **MUST** ask the user for the account ID and dashboard name if not provided.

You **SHOULD** verify the account ID is a valid 12-digit number.
