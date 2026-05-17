---

### Step 1: Create a New Alert Rule

1. In the left-hand main sidebar, hover over the **Alerting** (bell) icon and click on **Alert rules**.
2. Click the orange **Create alert rule** button at the top right of the page.

### Step 2: Name and Define the Core Target

1. **Name:** Set the rule name to `AppHealthCheckAlert`.
2. **Rule type:** Select **Grafana managed alert**.

### Step 3: Configure the PromQL Query & Performance Options

1. Under **Query A**, make sure your local **Prometheus** data source is active in the dropdown selection.
2. In the code input box, paste the optimized boolean metric string:
```promql
(sum(kube_deployment_status_replicas_available{deployment="backend", namespace="devops-assignment"}) by (namespace) == 0) + 1 
or 
(sum(increase(kube_pod_container_status_restarts_total{namespace="devops-assignment"}[5m])) by (namespace) > 2)

```


3. Set the configuration selectors above or below the query text to these values:
* **Type:** `Instant` *(Forces a single execution value check instead of an entire timeline line graph)*
* **Format:** `Table` *(Formats the raw output data into a structured layout for easy metric reading)*



### Step 4: Map the Condition Evaluator

In the **Alert condition** (or Condition C) block at the bottom of the query section, establish the mathematical trap:

* **WHEN QUERY:** `A`
* **Evaluator:** Change dropdown to **`Is above`**
* **Value:** Type **`0`**
*(When the system crashes, the query output yields a `1`. Since 1 is above 0, the threshold is successfully crossed and the alert trips!)*

### Step 5: Assign Folder Organization & Labels

Scroll down to the storage sections:

1. **Folder:** Click the dropdown $\rightarrow$ select **New folder** $\rightarrow$ create one called `EKS-Observability`.
2. **Evaluation group:** Click **New evaluation group** $\rightarrow$ name it `app-health-group`.
3. **Labels:** Click **Add labels** $\rightarrow$ add a Key of `severity` and a Value of `critical`.

### Step 6: Define Evaluation Interval and Buffers

Under **Set evaluation behavior**:

1. **Evaluation interval:** Set to `1m` *(Checks if the logic is broken every 60 seconds)*.
2. **Pending period (For):** Select or type **`2m`**. *(Ensures temporary network or container blips don't wake up team engineers—the failure state must hold consistently for 2 minutes before changing to a flashing red status)*.

### Step 7: Finalize Description Messages & Save

1. In the **Summary** text box, type: `Application Down or Pod Crashlooping`.
2. In the **Description** box, note what the alert tracks for anyone viewing it.
3. Scroll back up to the top right header bar and click **Save rule and exit**.
