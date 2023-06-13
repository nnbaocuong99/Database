# Installations docs

### How to Back Up and Restore MongoDB
<!--
<details>
<summary><samp>&#9776;</samp> click to expand <Back Up and Restore MongoDB> </summary>
<br>
-->
#### 1. This repo will cover the following:
- Back up and restore with the [MongoDB tools](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/?_ga=2.156187707.1254817124.1686623984-2025668380.1686623984)
- Back up and restore using [MongoDB Atlas](https://www.mongodb.com/docs/manual/core/backups/?_ga=2.156187707.1254817124.1686623984-2025668380.1686623984#back-up-with-atlas)
- Best practices for Backup and Restore
- The difference between logical and physical backups in MongoDB
- An example of how to back up and restore using both the MongoDB tools and MongoDB Atlas

<br>

#### 2. The MongoDB Backup and Restore Tool
The MongoDB Backup and Restore Tool allows you to encapsulate the state of a cluster and return to that state at any time. This helps protect you from data loss, as you can restore a database to a MongoDB instance using a created copy of that instance. Backups created with plain MongoDB Backup and Restore tools are logical backups, and they make use of the [BSON data type](https://www.mongodb.com/docs/manual/reference/bson-types/?_ga=2.202381713.1254817124.1686623984-2025668380.1686623984). MongoDB Atlas can work with both logical and physical backups.

<br>
  
#### 3. MongoDB Atlas Backup and Restore
MongoDB Atlas allows the user to create backups using the [cloud backup system](https://docs.atlas.mongodb.com/backup/cloud-backup/overview/?_ga=2.195385004.1254817124.1686623984-2025668380.1686623984). MongoDB Cloud Backups are created using the native snapshot functionality of the cluster’s cloud service provider.

MongoDB Atlas supports cloud backups for clusters served on the following hosting platforms:
- Google Cloud Platform (GCP)
- Amazon Web Services (AWS)
- Microsoft Azure

The [restore function](https://docs.atlas.mongodb.com/backup/cloud-backup/restore/?_ga=2.195385004.1254817124.1686623984-2025668380.1686623984) in MongoDB Atlas lets the user restore to either a replica set or a sharded cluster, as long as the destination uses the same encryption provider as the snapshot cluster of origin. The target cluster must also be using either the same version of MongoDB or a newer version than the snapshot cluster. [Legacy backups](https://docs.atlas.mongodb.com/backup/legacy-backup/overview/?_ga=2.121075336.1254817124.1686623984-2025668380.1686623984) are supported but deprecated.

The MongoDB Atlas backup feature incrementally backs up the data in a specified cluster, and you can restore from these snapshots or from any point in time within the past 24 hours. [The cloud backup and cloud restore functions](https://docs.atlas.mongodb.com/backup/cloud-backup/restore/?_ga=2.199014063.1254817124.1686623984-2025668380.1686623984) remain the preferred method of managing backups.

<br>

#### 4. MongoDB Backup and Restore Best Practices

There are some best practices you should follow when using the MongoDB backup and restore services for your MongoDB clusters.
- MongoDB uses both regular JSON and Binary JSON (BSON) file formats. It’s better to use BSON when backing up and restoring. While JSON is easy to work with, it doesn’t support all of the data types that BSON supports, and it may lead to the loss of fidelity.

- You don’t need to explicitly create a MongoDB database, as it will be automatically created when you specify a database to import from. Similarly, a structure for a collection will be created whenever the first document is inserted into the database.

- When creating a new cluster, you have the option to turn on cloud backup. While you can also enable cloud backups when modifying an existing cluster, you should turn this feature on by default, as it will prevent data loss.

- If a snapshot fails, Atlas will automatically attempt to create another snapshot. While you can use a fallback snapshot to restore a cluster, it should only be done when absolutely necessary. Fallback snapshots are created using a different process, and they may have inconsistent data.

- Use secondary servers for backups as this helps avoid degrading the performance of the primary node.

- Time the backup of data sets around periods of low bandwidth/traffic. Backups can take a long time, especially if the data sets are quite large.

- Use a replica set connection string when using unsupervised scripts. A standalone connection string will fail if the MongoDB host proves unavailable.

<br>

#### 5. Backup Types
There are two types of backups in MongoDB: `logical backups` and `physical backups`

- Logical Backups 
  - Logical backups dump data from databases into backup files, formatted as a BSON file. During the logical backup process, client APIs are used to get the data from the server. The data is encrypted, serialized, and written as either a “.bson,” “.json,” or “.csv” file, depending on the backup utility used. If you have enabled field level encryption, backing up data will ensure that the field remains encrypted.
  - MongoDB supplies two utilities to manage logical backups: Mongodump and Mongorestore.
  - The Mongodump command dumps a backup of the database into the “.bson” format, and this can be restored by providing the logical statements found in the dump file to the databases.
  - The Mongorestore command is used to restore the dump files created by Mongodump. Index creation happens after the data is restored.
  - Logical backups copy the data itself. They don’t copy any of the physical files relating to the data (like control files, log files, executables, etc.). They are typically used to archive databases, verify database structures, and move databases across different environments and operating systems.
  - If you have one server that contains a collection you need in another server, you could use a MongoDB logical backup to migrate the collection from the original server to the target server.

- Physical Backups
  - Physical backups are snapshots of the data files in MongoDB at a given point in time. The snapshots can be used to cleanly recover the database, as they include all the data found when the snapshot was created. Physical backups are critical when attempting to back up large databases quickly.
  - There are currently no provided, out-of-the-box solutions for creating physical backups with MongoDB. While you can create physical backups with LVM snapshots or block storage volume snapshots, it’s easier to use MongoDB Atlas. When using MongoDB Atlas, you can utilize any disk snapshot created by your cloud service provider. Alternatively, cloud backups can be made using either the [MongoDB Cloud Manager](https://www.mongodb.com/cloud/cloud-manager?tck=docs_server) or the [Ops Manager](https://docs.opsmanager.mongodb.com/current/?_ga=2.233733406.1254817124.1686623984-2025668380.1686623984)
  - Physical backups make copies of all the physical files that belong to a database, such as the data files, control files, and log files. The database files are saved onto a type of storage media, and they can then be used to restore a database system if there is damage to the system. You could use a physical backup snapshot alongside MongoDB Atlas to recover a lost or damaged database.
  - MongoDB Atlas can be used to restore both logical and physical backups.

<br>

#### 6. How to Back Up and Restore a MongoDB Database
Now, we’ll take a look at how to create a MongoDB backup database and restore that database. We’ll do this with both MongoDB Atlas and with the Mongodump and Mongorestore utilities.

<br>

#### 7. Using MongoDB Atlas
When using MongoDB Atlas, the snapshots are created by your cloud service provider, so be sure to refer to the corresponding documentation to configure your snapshots. Once a snapshot has been taken, you can use the [cloud restore](https://docs.atlas.mongodb.com/backup/cloud-backup/restore?_ga=2.132406542.1254817124.1686623984-2025668380.1686623984#std-label-restoration-cloud-provider-snapshot) option in MongoDB Atlas.

After ensuring that the Atlas cluster of choice can’t receive client requests or choosing to restore to a new Atlas cluster, simply navigate to the “Clusters” view in MongoDB Atlas. Afterwards, select “Backup,” choose a snapshot to restore, and then follow the prompts to restore your cluster.

![image](https://github.com/nnbaocuong99/Database/assets/100349044/ee846302-7685-46a1-963d-8f6379a52688)

<div align="center">  
  Now, let’s look at how to back up and restore using the MongoDB utilities.
  </div>






#### 8. Using MongoDB Backup and Restore Tools
Assuming that we have a remote MongoDB machine running and wish to create a snapshot of that database on a local machine, this can be done using the mongodump command on the primary node. We just need to indicate the host and port number (the default is port 27017) for the remote server, and provide some argument parameters like the name of the database, our user name, and our password. Finally, we indicate the dump directory we want to create the snapshot in.

```ruby
mongodump -h sample.mongodbhost.com:27017 -d DATABASE_NAME -u USER_NAME -p SAMPLE_PASSWORD -o ~/Desktop
```

One of the best practices of backing up large databases is splitting them up. You can pass a query into mongodump using the --query parameter so that you, in case of a failure, are able to use some kind of timestamp/ordering field in your collection to resume the backup process.

In order to restore a database with a saved snapshot, we just have to use the mongorestore command. It restores data by connecting to a running mongod directly. You can limit the output from the database by running restore in quiet mode using the --quiet option. Once more, we provide the MongoDB host and port, along with the user name, database name, and password. Finally, we provide the output directory.

```ruby
mongorestore --host sample.mongohost.com --port 27017 --username USER_NAME --password SAMPLE_PASSWORD --db DATABASE_NAME .
```
MongoDB enables users to back up and restore their databases. A database can be backed up and restored using either MongoDB backup and restore utilities or the cloud database platform MongoDB Atlas.

<!--
<br>
</details>
-->



