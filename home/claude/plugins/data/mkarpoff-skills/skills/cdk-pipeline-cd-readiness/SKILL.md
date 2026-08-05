---
name: cdk-pipeline-cd-readiness
description: Make CDK pipelines ready for full Continuous Deployment. Use when adding LSE blockers, time window blockers, Gordian Knot validations, bake times, or rollback triggers to @amzn/pipelines CDK pipelines. Each fix should be a separate CR.
version: 1.0.0
---

# CDK Pipeline CD Readiness

## Overview
Guides agents through making @amzn/pipelines CDK pipelines production-ready for full Continuous Deployment by adding safety mechanisms: LSE blockers, time window blockers, Gordian Knot scan validations, bake times with rollback alarms.

## Usage
Use this skill when:
- Adding LSE promotion blockers to a pipeline
- Adding time window blockers (working hours, holidays, change control)
- Adding Gordian Knot scanner approval steps
- Adding bake time steps with CloudWatch alarm rollback
- Making a pipeline "CD ready" or "production safe"

## Core Concepts

All constructs come from `@amzn/pipelines`. Each change below **MUST** be a separate code review (CR).

### 1. LSE Promotion Blockers

Blocks promotion during Large Scale Events. Uses `AlarmBlocker.fromString` with a Carnaval alarm — NOT a TimeWindowBlocker.

```typescript
import { AlarmBlocker } from '@amzn/pipelines';

// Add to prod stage — PDX is the default for us-west-2 pipelines
stage.addInboundAlarmBlocker(AlarmBlocker.fromString('AARG.LSETool.OngoingLSE.PDX'));
```

If the pipeline deploys to multiple production regions, you **MUST** also add LSE blockers for each region:

```typescript
stage.addInboundAlarmBlocker(AlarmBlocker.fromString('AARG.LSETool.OngoingLSE.PDX'));
stage.addInboundAlarmBlocker(AlarmBlocker.fromString('AARG.LSETool.OngoingLSE.IAD'));
stage.addInboundAlarmBlocker(AlarmBlocker.fromString('AARG.LSETool.OngoingLSE.DUB'));
```

The alarm string format is `AARG.LSETool.OngoingLSE.<AIRPORT_CODE>`.

### 2. Time Window Blockers

Restricts promotions to safe time windows. Uses `TimeWindowBlocker`.

You **MUST** add these three time window blockers to prod stages:

```typescript
import { TimeWindowBlocker } from '@amzn/pipelines';

// Add all three to prod stage
stage.addInboundTimeWindowBlocker(new TimeWindowBlocker('Consumer Change Control - NA'));
stage.addInboundTimeWindowBlocker(new TimeWindowBlocker('Pacific Time Canadian Holidays'));
stage.addInboundTimeWindowBlocker(TimeWindowBlocker.US_WORKING_HOURS);
```

Full list of available time windows: https://pipelines.amazon.com/time_windows

### 3. Gordian Knot Scanner Validation

Adds security scanning to the version set stage.

```typescript
import { GordianKnotScannerApprovalWorkflowStep, Platform, ScanProfile } from '@amzn/pipelines';

pipeline.versionSetStage.addApprovalWorkflow('Code Checks')
  .addStep(new GordianKnotScannerApprovalWorkflowStep({
    platform: Platform.AL2_X86_64,
    scanProfileName: ScanProfile.ASSERT_HIGH,
  }));
```

Scan profiles (strictest to least): `ASSERT_HIGH`, `ASSERT_MEDIUM_STRICT`, `ASSERT_MEDIUM`, `ASSERT_LOW`.

### 4. Bake Time with Rollback

Adds a bake period that rolls back if a CloudWatch alarm fires.

**Requirements:**
- The alarm **MUST** have an explicit `alarmName` (not auto-generated) so the ARN resolves at synth time
- The approval workflow **MUST** set `rollbackOnFailure: true`
- You cannot have multiple approval workflows approving ALL targets on the same stage — add the bake step to the existing workflow

```typescript
import { BakeTimeCloudWatchApprovalWorkflowStep } from '@amzn/pipelines';

// When creating the approval workflow, enable rollback:
const approvalWorkflow = stage.addApprovalWorkflow('Prod Validation', {
  rollbackOnFailure: true,
});

// Add bake time step referencing a CloudWatch alarm with explicit name:
approvalWorkflow.addStep(new BakeTimeCloudWatchApprovalWorkflowStep({
  name: 'Prod Bake Time',
  duration: 30, // minutes
  cloudWatchAlarm: monitoringStack.errorRateAlarm,
}));
```

**Alarm must have explicit name:**
```typescript
const alarm = new cloudwatch.Alarm(this, 'ErrorRateAlarm', {
  alarmName: `MyService-${stage}-ErrorRateAlarm`, // REQUIRED for pipeline resolution
  // ...
});
```

Only use ARN string when referencing a rollback alarm from another pipeline:
```typescript
approvalWorkflow.addStep(new BakeTimeCloudWatchApprovalWorkflowStep({
  name: 'Prod Bake Time',
  duration: 30,
  cloudWatchAlarmArn: `arn:aws:cloudwatch:us-west-2:accountId:alarm:MyAlarmName`,
}));
```

## Quick Reference

| Feature | Import | Method |
|---------|--------|--------|
| LSE Blocker | `AlarmBlocker` | `stage.addInboundAlarmBlocker(AlarmBlocker.fromString(...))` |
| Time Window | `TimeWindowBlocker` | `stage.addInboundTimeWindowBlocker(new TimeWindowBlocker(...))` |
| Gordian Knot | `GordianKnotScannerApprovalWorkflowStep` | `workflow.addStep(new GordianKnotScannerApprovalWorkflowStep(...))` |
| Bake Time | `BakeTimeCloudWatchApprovalWorkflowStep` | `workflow.addStep(new BakeTimeCloudWatchApprovalWorkflowStep(...))` |

## Common Mistakes

- **Using TimeWindowBlocker for LSE** — LSE blockers are Carnaval alarms, use `AlarmBlocker.fromString`
- **Multiple all-target approval workflows** — Only one workflow can approve all targets per stage. Add steps to the existing workflow.
- **Alarm without explicit name** — Pipeline synth fails if alarm ARN contains unresolved tokens. Always set `alarmName`.
- **Forgetting `rollbackOnFailure`** — Without this flag, bake time failure won't trigger rollback.

## CR Strategy

Each of these **MUST** be a separate CR:
1. LSE promotion blockers
2. Time window blockers
3. Gordian Knot scanner validation
4. Bake time with rollback alarm

This allows incremental review and safe rollback of each safety mechanism independently.
