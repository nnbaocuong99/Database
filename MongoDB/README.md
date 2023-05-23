# Using MongoDB

 Db config
 ```yaml
 mongodb:
    enabled: true
    nameOverride: "mongodb"
    fullnameOverride: "mongodb"
    architecture: "standalone"
    auth:
      rootUser: "username"
      rootPassword: "password"
    nodeSelector:
      kubernetes.io/hostname: payment-node17
    tolerations:
      - key: ""
        operator: "Equal"
        value: "storage"
        effect: "NoSchedule"
    service:
      type: NodePort
      nodePort: 32368
    persistence:
      enabled: true
      existingClaim: ""
```
