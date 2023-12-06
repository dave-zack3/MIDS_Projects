# Lab 5 Findings - Dave Zack

- [Lab 5 Findings - \[Dave Zack\]](#lab-5-findings---dave-zack)
  - [Introduction](#introduction)
  - [Findings](#findings)
    - [Cache Rate 0%](#cache-rate-0)
    - [Cache Rate 25%](#cache-rate-25)
    - [Cache Rate 50%](#cache-rate-50)
    - [Cache Rate 75%](#cache-rate-75)
    - [Cache Rate 90%](#cache-rate-90)
    - [Cache Rate 100%](#cache-rate-100)
    - [Overall Findings Table](#overall-findings-table)
    - [Finding 1](#finding-1)
    - [Finding 2](#finding-2)
    - [Finding 3](#finding-n)
  - [Conclusion](#conclusion)

---

## Introduction

In this lab we were tasked with load testing our deployed API using `K6`. This involved running `k6 run load.js` with multiple different cache rates, checking the `istio` workload dashboard and seeing what the response time profile looked like. Overall, the API we have developed so far is a simple application, so the differences between different cache rates were noticeable but not staggering. Findings are documented below.

## Findings

Here I will insert the screenshots of different cache rates' impact on API performance as output by both the `istio` dashboards and `K6`. The cache rates captured are as follows:

```
[0%, 25%, 50%, 75%, 90%, 100%]
```
### Cache Rate 0%

<img width="818" alt="k6_CacheRate0" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/aa9e8ba5-18a5-4081-96ba-6ca0f33b3e7c">

<img width="1428" alt="Grafana_CacheRate0" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/415aea68-4df1-448c-b50f-26c490a2f90d">


### Cache Rate 25%

<img width="811" alt="k6_CacheRate25" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/2c202cd7-f504-4bd9-8c49-2480645f4430">

<img width="1428" alt="Grafana_CacheRate25" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/e48e993f-a2af-45c0-91d3-38b13fa34f76">


### Cache Rate 50%

<img width="819" alt="k6_CacheRate50" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/71fc1c3f-1c7b-437a-9ef1-7a48acc215d3">

<img width="1393" alt="Grafana_CacheRate50" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/10c5b276-d345-4017-94a3-d10ea95e44f3">


### Cache Rate 75%

<img width="807" alt="k6_CacheRate75" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/9d70dd0e-8790-4f06-993c-42f593954147">

<img width="1428" alt="Grafana_CacheRate75" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/48300339-653b-445b-9658-7b33ab4959c6">


### Cache Rate 90%

<img width="811" alt="k6_CacheRate90" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/39fb90a1-2cea-411e-829a-9325238667c1">

<img width="1426" alt="Grafana_CacheRate90" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/5679d9fa-00f9-4a4c-851d-b2e249316db8">


### Cache Rate 100%

<img width="811" alt="k6_CacheRate100" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/89cfa8f4-6465-4573-a4c8-a94d11d6000b">

<img width="1424" alt="Grafana_CacheRate100" src="https://github.com/UCB-W255/summer23-dave-zack3/assets/111018314/776fb3c4-c56c-4ce6-a36f-58c8909c628f">

### Overall Findings Table

| Cache Rate | `p(90)` Time | `p(95)` Time |
| ---------- | ---------- | ---------- |
| **0%** | 49.64 ms | 53.44 ms |
| **25%** | 49.06 ms | 53.25 ms |
| **50%** | 51.91 ms | 56.92 ms |
| **75%** | 52.01 ms | 57.44 ms |
| **90%** | 51.74 ms | 54.87 ms |
| **100%** | 49.71 ms | 53.04 ms |

### Finding 1

Because of the simplicity of the application we are deploying, the cache rate appears to have a limited affect on the `p(90)` and `p(95)` response times of the API. As evident from the above table, the response times at those levels are all within ~4 ms of each other. This leads me to believe the cache rate is not a limiting factor at the lower-end of performance, at least in the context of how `K6` was run. 

### Finding 2

From the `Grafana` dashboards, it is clear the impact of the cache on the response times. As you can see from the embedded images above, the response time picks up for each cache rate as the "users" come online and then eventually flattens out near-zero once the cache populates all possible combinations of values. This demonstrates the benefits of caching your responses and preventing the API endpoint from being overworked.

### Finding 3

This is a bit of a leap but my assumption is that the impact of the cache rate on the peaks in the `Grafana` graphs and `p(90)` and `p(95)` response times are a limitation of how the `K6` script was set up to run. When the cache rate was 100%, the application would always be fed the vector `[1, 1, 1, 1, 1, 1, 0, 0]`. When the cache rate was 0% the API would be fed `[randint(0,20), ... , randint(0,20)]`. It is possible that using a larger bound on the random integers would lead to a more prominent demonstration of the benefits of caching given how many requests are sent by `K6` to the application. 

## Conclusion

Overall, caching has proven to be a valuable tool in enabling quick response times, although, in the context of this lab, performance at the `p(90)` and `p(95)` levels were comparable among all cache hit rates. 
