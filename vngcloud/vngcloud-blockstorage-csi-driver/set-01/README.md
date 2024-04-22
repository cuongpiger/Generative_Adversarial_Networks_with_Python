# Snapshot
- `vngcloud-blockstorage-csi-driver` allow users create a Snapshot from a specific PVC and then restore a new PVC from one.
- This lab guides you how to use Snapshot feature with `vngcloud-blockstorage-csi-driver`.

## Lab 1
- This lab will create a PVC, then creating a Snapshot from it.
- After that, we will create a new PVC from the Snapshot.
- Finally, we will create a Pod using the new PVC.
### Steps

- Step 1: Apply file `01_pvc.yaml` to create a PVC, StorageClass and nginx Pod.
  ```bash
  kubectl apply -f 01_pvc.yaml
  ```

- Step 2: Create a `VolumeSnapshotClass` and `VolumeSnapshot` from the above PVC, using file `02_vs.yaml`.
  ```bash
  kubectl apply -f 02_vs.yaml
  ```

- Step 3: Now, you can create a new PVC from the above `VolumeSnapshot`, using file `03_restore.yaml`
  ```bash
  kubectl apply -f 03_restore.yaml
  ```

- Step 4: Create a Pod using the new PVC, using file `04_attach_to_pod.yaml`
  ```bash
  kubectl apply -f 04_attach_to_pod.yaml
  ```
  