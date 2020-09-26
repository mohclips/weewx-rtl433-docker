# Description

# Build

docker build -t rtl433_weewx .

docker tag rtl433_weewx:latest rtl433_weewx:staging

# Run

docker-compose up -d

# test

docker exec -it rtl433_weewx bash

# get device id
```
PYTHONPATH=/usr/share/weewx python /usr/share/weewx/user/sdr.py       
out:['{"time" : "2020-09-21 18:23:27", "model" : "CurrentCost-TX", "id" : 2302, "power0_W" : 1073, "power1_W" : 0, "power2_W" : 0}\n']
out:['{"time" : "2020-09-21 18:23:33", "model" : "CurrentCost-TX", "id" : 2302, "power0_W" : 1080, "power1_W" : 0, "power2_W" : 0}\n', '{"time" : "2020-09-21 18:23:34", "model" : "Fineoffset-WHx080", "subtype" : 0, "id" : 125, "battery_ok" : 0, "temperature_C" : 19.500, "humidity" : 74, "wind_dir_deg" : 180, "wind_avg_km_h" : 0.000, "wind_max_km_h" : 1.224, "rain_mm" : 446.700, "mic" : "CRC"}\n']
```


# debug un parsed sensors

PYTHONPATH=/usr/share/weewx python /usr/share/weewx/user/sdr.py  --cmd="rtl_433 -M utc -F json" --hide parsed,out,empty

# inside the container

PYTHONPATH=/usr/share/weewx python /usr/share/weewx/user/sdr.py --cmd="rtl_433 -M utc -F json -R 32"

R=32 == Fineoffset-WHx080

