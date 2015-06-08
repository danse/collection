Convert timestamped data to a format suitable for a Collection vis

Input data:

    [{ time: t1, value: v1}, { time: t2, value: v2}, ... ]

Output data: 

    [{
      time: t1, collection: [{ size: 1, value: v1}]
    }, {
      time: t2, collection: [{ size: 1, value: v2}, { size: 2, value: v3}]
    },
      ...
    }]

Where v3 = (v1 + v2)/2

This in the simple case when t1 and t2 are separated by the
aggregation interval. Otherwise the result could be different if for
example we have two data points in the same day and we are aggregating
by day.
