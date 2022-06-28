-- Problem statement: Need to aggregate data from nested maps, in each element of the parent map
-- This example uses the schema in /samples/nested-maps-schema.avsc and messages in /samples/nested-maps-message.jsonl

-- Getting a simple value (the warning parameter) for each element in the ROOMS map
-- Aggregating the voltage of all modules inside each ROOM
SELECT
  TRANSFORM(ROOMS,
            (k,v) => k,
            (k,v) => v->WARNING
           ) AS ROOM_WARNING,
  TRANSFORM(ROOMS,
            (k,v) => k,
            (k,v) => REDUCE(v->MODULES,
                            CAST(0 AS DOUBLE),
                            (s,k2,v2) => GREATEST(v2->VOLTAGE,s)
                           )
           ) AS ROOM_MAX_VOLTAGE_FROM_ALL_MODULES
FROM TEST_MAP;