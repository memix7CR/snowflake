### Snowpipe

Enable data loading from files as soon they land the stages (incremental load), instead of manually executing COPY on a schedule.
Recommended for micro-batching (smaller)

- Using PIPE which is a first-class Snowflake object that contains a COPY statement used by Snowpipe
- Mechanisms for detecting the staged files:
   - Snowpipe using cloud messaging
   - Calling Snowpipe REST API

- Snowpipe normally loads older files first but it doesn not guarantee that files are loaded in the same order as staged
- It uses **file loading metadata** associated with each pipe object to prevent reloading the same files
- Load History is stored in the metadata of the pipe for **14 days**


