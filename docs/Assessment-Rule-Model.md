# Assessment Rule Model

## Purpose
Assessment rules define metadata plus evaluation logic. The orchestrator executes rules by pack and collects normalized findings without embedding reporting behavior inside the rules.

## Rule contract
- `RuleId`
- `Name`
- `AssessmentPack`
- `Service`
- `Description`
- `DefaultSeverity`
- `Evaluate`

## Evaluation behavior
`Evaluate` is a script block that accepts a context object and returns one or more normalized findings. Rule logic should stay focused on technical evaluation and evidence capture.

## Design constraints
- Rules must not own export formatting
- Rules must not embed presentation templates
- Rules should emit findings using the shared `New-AxFinding` contract
