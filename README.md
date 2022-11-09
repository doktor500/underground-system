# UnderGround System

An underground railway system is keeping track of customer travel times between different stations.
They are using this data to calculate the average time it takes to travel from one station to another.

## Requirement

Implement the `UndergroundSystem` class:

* `check_in(id, station_name, time)`
  * A customer with a card `id`, checks in at the station `station_name` at the `time`.
  * A customer can only be checked into one place at a time.
* `check_out(id, station_name, time)`
  * A customer with a card `id`, checks out from the station `station_name` at the `time`.
* `get_average_time(start_station, end_station)`
  * Returns the average time it takes to travel from `start_station` to `end_station`.

## Notes

1. The average time is computed from all the previous traveling times from `start_station` to `end_station` that happened directly, meaning a check in at `start_station` followed by a check out from `end_station`.
1. The time it takes to travel from `start_station` to `end_station` may be different from the time it takes to travel from `end_station` to `start_station`.
1. There will be at least one customer that has traveled from `start_station` to `end_station` before `get_average_time` is called.
1. You may assume all calls to the `check_in` and `check_out` methods are consistent.
1. If a customer checks in at time t1 then checks out at time t2, then t1 < t2.
1. All events happen in chronological order.

## Input

Commands file:
* `check<in/out>,id,station_name,time`
* `get_average,start_station,end_station`

Example
```
check_in,45,Leyton,3
check_in,32,Paradise,8
check_out,45,Waterloo,15
check_out,32,Cambridge,22
get_average,Paradise,Cambridge
```

## Output

```
Paradise,Cambridge,14.0
```

## Example 1

Input
```
check_in,45,Leyton,3
check_in,32,Paradise,8
check_in,27,Leyton,10
check_out,45,Waterloo,15
check_out,27,Waterloo,20
check_out,32,Cambridge,22
get_average,Paradise,Cambridge
get_average,Leyton,Waterloo
check_in,10,Leyton,24
get_average,Leyton,Waterloo
check_out,10,Waterloo,38
get_average,Leyton,Waterloo
```

Output
```
Paradise,Cambridge,14.0
Leyton,Waterloo,11.0
Leyton,Waterloo,12.0
```

## Implementation

### Notes

#### Assumptions

- I am assuming there was a typo in the Example 1 Input and I've changed one of the lines from `check_in,10,Waterloo,38` to `check_out,10,Waterloo,38`
- This solution is over-engineered for such a simple problem to solve, however, I've decided to use Ruby and Kafka to solve this code assessment since I know these are the technologies used by the team and as a way to demonstrate proficiency on the confluent's tech stack

### Decisions to reduce scope

- The setup to run kafka is not configured to be highly available and in a real production environment this needs to be configured differently
- I've decided to not use Ruby on Rails in order to reduce some framework dependencies given the reduced scope of this problem
- The KSQL query to calculate trips average time can be way more performant and further optimisations could be applied [incremental-averaging](https://math.stackexchange.com/questions/106700/incremental-averaging)

### Executing unit tests

```
rspec
```

### Executing integration tests

```
./scripts/test-integration.sh
```


### Dependencies

- [Ruby 3.0.2](https://www.ruby-lang.org/en/)
- [Bundler](https://bundler.io/)
- [Docker](https://www.docker.com/)
- [gettext](https://www.gnu.org/software/gettext/)

To install gettext on Mac OS X with brew execute `brew bundle` in this directory or just `brew install gettext`
