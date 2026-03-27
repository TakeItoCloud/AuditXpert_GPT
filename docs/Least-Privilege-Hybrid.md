# Least Privilege Guidance For Hybrid Assessments

## Principle
Hybrid and on-prem assessments should prefer read-only collection using standard PowerShell modules and operating system commands, without invasive discovery or write actions.

## Guidance
- Prefer RSAT and Active Directory module queries only when available
- Handle missing modules explicitly and downgrade findings to informational where collection is limited
- Use lab-friendly checks for optional AD CS and Exchange hybrid scenarios
- Keep data collection separated from assessment evaluation so future collectors can be swapped without changing rule logic

## Operational note
Phase 07 does not perform remediation, configuration changes, or invasive collection. Optional checks are clearly identified in evidence and descriptions.
