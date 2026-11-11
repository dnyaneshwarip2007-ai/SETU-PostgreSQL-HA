\# SETU â€“ PostgreSQL High Availability \& Disaster Recovery



\*\*Project ID:\*\* SWFW\_SS\_09



\## 1. Project Overview



SETU is a PostgreSQL High Availability (HA) and Disaster Recovery (DR) lab project. It demonstrates primary-standby streaming replication, controlled failover, database backup, and recovery using Docker containers.



The project explores how database availability can be maintained and how data can be restored after a failure.



\## 2. Objectives



\- Understand PostgreSQL high availability.

\- Configure primary-standby streaming replication.

\- Demonstrate controlled standby promotion during primary failure.

\- Automate logical database backups using PowerShell.

\- Verify database recovery using a backup file.



\## 3. Technologies Used



\- PostgreSQL 18

\- Docker Desktop

\- Docker Engine and WSL2

\- PowerShell

\- SQL

\- Windows 11



\## 4. Architecture



The currently verified cluster topology is:



```text

&#x20;         PostgreSQL HA Cluster



&#x20;      pg-replica2 (PRIMARY)

&#x20;               |

&#x20;               | Streaming Replication

&#x20;               |

&#x20;      pg-replica1 (STANDBY)



&#x20;      Separate Recovery Container

&#x20;             pg-recovery

```



The standby can be promoted to primary during a controlled failover demonstration.



\## 5. Project Features



\### A. Streaming Replication



\- Configured PostgreSQL primary and standby containers.

\- Enabled WAL-based streaming replication.

\- Verified the standby was receiving data from the primary.



\### B. Failover Monitoring



The PowerShell script `setu\_failover\_monitor.ps1`:



\- Monitors the primary container's running state.

\- Checks whether the standby is available and in recovery mode.

\- Attempts to promote the standby using `pg\_promote()`.

\- Verifies whether promotion succeeded.



\### C. Database Backup



The script `setu\_backup.ps1`:



\- Checks whether the configured PostgreSQL container is running.

\- Creates a logical database backup using `pg\_dump`.

\- Copies the backup from the container to the local `backups/` directory.

\- Checks that the backup file exists and is not empty.



\### D. Disaster Recovery



\- Created a separate recovery container.

\- Restored database data from a logical backup.

\- Verified the restored records.



\## 6. Repository Structure



```text

SETU-PostgreSQL-HA/

â”‚

â”œâ”€â”€ docs/

â”‚

â”œâ”€â”€ screenshots/

â”‚   â”œâ”€â”€ database\_backup\_created.png

â”‚   â”œâ”€â”€ Disaster\_Recovery\_Verification.png

â”‚   â”œâ”€â”€ final\_cluster\_status.png

â”‚   â””â”€â”€ HA\_recovery.png

â”‚

â”œâ”€â”€ scripts/

â”‚   â”œâ”€â”€ setu\_backup.ps1

â”‚   â””â”€â”€ setu\_failover\_monitor.ps1

â”‚

â”œâ”€â”€ sql/

â”‚   â””â”€â”€ init.sql

â”‚

â”œâ”€â”€ .gitignore

â””â”€â”€ README.md

```



Generated database backups are intentionally excluded from this repository.



\## 7. How to Run the Scripts



\### Prerequisites



\- Windows 11

\- Docker Desktop installed and running

\- PostgreSQL containers configured and running

\- PowerShell



\### Run the backup script



Open PowerShell and execute:



```powershell

powershell -ExecutionPolicy Bypass -File ".\\scripts\\setu\_backup.ps1"

```



The generated backup is stored in the `backups/` directory.



\### Run the failover monitor



```powershell

powershell -ExecutionPolicy Bypass -File ".\\scripts\\setu\_failover\_monitor.ps1"

```



\*\*Important:\*\* Run this script only in the configured lab environment. It monitors Docker container status and is not a production-ready failover solution.



\## 8. Database Initialization



The `sql/init.sql` file creates the `setu\_db` database and a sample `students` table.



It can be executed using an administrative PostgreSQL `psql` session:



```powershell

psql -U postgres -f .\\sql\\init.sql

```



The script uses PostgreSQL `psql` commands, including `\\connect`.



\## 9. Screenshots



\### Final Cluster Status



!\[Final Cluster Status](screenshots/final\_cluster\_status.png)



\### High Availability Recovery



!\[HA Recovery](screenshots/HA\_recovery.png)



\### Database Backup



!\[Database Backup](screenshots/database\_backup\_created.png)



\### Disaster Recovery Verification



!\[Disaster Recovery](screenshots/Disaster\_Recovery\_Verification.png)



\## 10. Limitations and Future Improvements



\- Implement production-grade health checks and failover orchestration.

\- Add quorum and fencing mechanisms to prevent split-brain scenarios.

\- Automate standby rejoining after failover.

\- Implement PostgreSQL WAL archiving and point-in-time recovery (PITR).

\- Add physical volume snapshots and snapshot-based recovery.

\- Configure encrypted and off-site backup storage.

\- Add Docker Compose for easier cluster deployment.

\- Perform more extensive failover and recovery testing.



\## 11. Learning Outcomes



Through this project, I gained practical experience with:



\- PostgreSQL database administration.

\- Primary-standby streaming replication.

\- Docker containers and WSL2.

\- PowerShell automation.

\- Database backup and restoration.

\- High availability and disaster recovery concepts.



\---



**Project:** SETU - PostgreSQL High Availability and Disaster Recovery

\*\*Project ID:\*\* SWFW\_SS\_09