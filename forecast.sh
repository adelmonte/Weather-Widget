#!/bin/bash

CITY="Spokane"
API_KEY=""
API_URL="http://api.openweathermap.org/data/2.5/forecast?q=${CITY}&cnt=24&appid=${API_KEY}&units=imperial"
sleep 2

get_weather_icon() {
    case $1 in
        Clear) echo "☀️";;
        Clouds) echo "☁️";;
        Rain) echo "🌧️";;
        Snow) echo "❄️";;
        Drizzle) echo "🌦️";;
        Thunderstorm) echo "⛈️";;
        Mist|Fog|Haze) echo "🌫️";;
        *) echo "❓";;
    esac
}

center_text() {
    local text="$1"
    local width="$2"
    local textwidth=${#text}
    local padding=$(( (width - textwidth) / 2 ))
    local extra=$(( (width - textwidth) % 2 ))
    printf "%*s%s%*s" $padding "" "$text" $(( padding + extra )) ""
}

print_centered_row() {
    local col1="$1"
    local col2="$2"
    local col3="$3"
    local width=15
    printf "%s%s%s\n" "$(center_text "$col1" $width)" "$(center_text "$col2" $width)" "$(center_text "$col3" $width)"
}

get_weather() {
    local response=$(curl -s $API_URL)
    local day1_temp=$(echo $response | jq -r '.list[0].main.temp_max' | awk '{print int($1+0.5)}')
    local day1_cond=$(echo $response | jq -r '.list[0].weather[0].main')
    local day2_temp=$(echo $response | jq -r '.list[8].main.temp_max' | awk '{print int($1+0.5)}')
    local day2_cond=$(echo $response | jq -r '.list[8].weather[0].main')
    local day3_temp=$(echo $response | jq -r '.list[16].main.temp_max' | awk '{print int($1+0.5)}')
    local day3_cond=$(echo $response | jq -r '.list[16].weather[0].main')
    
    local day1_icon=$(get_weather_icon "$day1_cond")
    local day2_icon=$(get_weather_icon "$day2_cond")
    local day3_icon=$(get_weather_icon "$day3_cond")

    local date1=$(date +"%a %b %d")
    local date2=$(date -d "1 day" +"%a %b %d")
    local date3=$(date -d "2 days" +"%a %b %d")
    
    print_centered_row "$date1" "$date2" "$date3"
    print_centered_row "$day1_icon" "$day2_icon" "$day3_icon"
    print_centered_row "${day1_temp}°F" "${day2_temp}°F" " ${day3_temp}°F"
    print_centered_row "$day1_cond" "$day2_cond" "$day3_cond"
}

get_weather
