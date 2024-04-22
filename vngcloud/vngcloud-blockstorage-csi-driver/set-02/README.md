# Migrate PVC to new Cluster
- This guide teachs you create a PVC from old cluster `VolumeSnapshot` and attach it to a Pod in new cluster.
  ```bash
  kubectl apply -f 01_migrate.yaml
  ```