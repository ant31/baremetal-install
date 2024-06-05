# Replace disk on a lvm mirror 

Replacement of nvmeX on node 4324324-ax101s 
Format the disk in two partition of 50%

0. create partition:

the command will fail at lvm creation steps
```shell
make configure-servers TAGS="-t lvm" GROUP="4324324-ax101s"
```
1. remove old pvs
```shell
# check the volumes names and add --force --force to confirm
pvremove /dev/nvmeXn1p2   
pvremove /dev/nvmeXn1p2 
# confirm with --force
vgreduce --removemissing vgdata 
vgreduce --removemissing vgdata2 
```
2. Convert lv to linear
```sh
lvconvert -m0 vgdata/luks-data
lvconvert -m0 vgdata2/luks-data2
```
3. add new pvs
```sh
pvcreate /dev/nvme0n1p1 /dev/nvmeXn1p2
```

4. Add pvs to vg
```
vgextend vgdata /dev/nvmeXn1p1
vgextend vgdata2 /dev/nvmeXn1p2
```

5. If needed activate VG
```
vgchange -a y vgdata2
vgchange -a y vgdata
```

5. Copy data and recreate raid 1
```
lvconvert -m1 vgdata/luks-data /dev/nvmeXn1p1
lvconvert -m1 vgdata2/luks-data2 /dev/nvmeXn1p2
```
