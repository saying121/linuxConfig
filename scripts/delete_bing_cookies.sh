#!/bin/bash

sqlite3 ~/.config/microsoft-edge/Default/Cookies "DELETE FROM cookies WHERE host_key LIKE '%bing.com%';" -batch
