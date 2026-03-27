# Framework Mapping Model

## Configuration model
Framework mappings are stored as JSON under `config/framework-mappings`. Each file includes:
- `Framework`
- `Version`
- `Description`
- `Mappings`

Each mapping entry includes:
- `Domain`
- `Control`
- `Categories`
- `Services`

## Supported framework families
- NIS2-oriented domains
- ISO/IEC 27001-style Annex A and control-domain mappings
- Internal security baseline mappings

## Transparency note
Mappings are intended to support assessment interpretation. They are configurable and should be reviewed by the assessment owner before being used in formal governance deliverables.
