# datahub-down

Source code for datahub's alternate page. Works through nginx.

Note: Installing this chart along with the manual configurations creates a GLOBAL outage page for that particular error. Meaning, if 2 services are crashed resulting in 504s, then both pages will see the same 504 outage page. Currently, there's no technical way of creating custom errors for a given service.

## Installation

Install the helm chart

```bash
helm install --name datahub-down $(pwd)
```

Add annotations to nginx controller

Add custom errors to nginx controller configamp

## Development

For errors outside of