### Cluster of resource

- CPU, Memory and Temporary Storage
- Active on usage of ( SELECT, DML like DELETE, INSERT, COPY INTO, etc.)
- Can be stopped and resized at any time even while running
    - Running queries not impacted (only new queries)
- When creating VW can specify:
    - Auto-Suspend : default: (10 mins) suspend after inactivity
    - Auto-resume : resumes whenever a statement that requires a warehouse is required


### Multi-cluster warehouse

- Up to 10 server clusters
- Auto-supend, auto-resume applies for the whole cluster not 1 server
- Can be resized at any time
- Multi cluster modes:
   - Maximized : same min and max # of clusters (but > 1)
   - Auto-scale: different min and max # of clusters.

### Scaling Policies

![](/assets/)
