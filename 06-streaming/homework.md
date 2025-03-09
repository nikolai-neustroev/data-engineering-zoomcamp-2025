# Question 1: Redpanda version

Now let's find out the version of redpandas.

For that, check the output of the command rpk help inside the container. The name of the container is redpanda-1.

Find out what you need to execute based on the help output.

What's the version, based on the output of the command you executed? (copy the entire version)

## Answer:
```
$ rpk version
Version:     v24.2.18
Git ref:     f9a22d4430
Build date:  2025-02-14T12:59:41Z
OS/Arch:     linux/arm64
Go version:  go1.23.1

Redpanda Cluster
  node-1  v24.2.18 - f9a22d443087b824803638623d6b7492ec8221f9
```

# Question 2. Creating a topic

Before we can send data to the redpanda server, we need to create a topic. We do it also with the rpk command we used previously for figuring out the version of redpandas.

Read the output of help and based on it, create a topic with name `green-trips`

What's the output of the command for creating a topic? Include the entire output in your answer.

## Answer:
```
$ rpk topic create green-trips
TOPIC        STATUS
green-trips  OK
```

# Question 3. Connecting to the Kafka server

Provided that you can connect to the server, what's the output of the last command?

## Answer:
```
True
```

# Question 4: Sending the Trip Data

How much time did it take to send the entire dataset and flush?

## Answer:
```
20.35
```

# Question 5: Build a Sessionization Window (2 points)

Which pickup and drop off locations have the longest unbroken streak of taxi trips?

`docker compose exec jobmanager ./bin/flink run -py /opt/src/job/session_job.py --pyFiles /opt/src -d`

## Answer:
```
```
