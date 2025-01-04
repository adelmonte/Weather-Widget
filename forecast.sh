#!/bin/bash
CITY="New+York"
API_KEY=""
API_URL="http://api.openweathermap.org/data/2.5/forecast?q=${CITY}&appid=${API_KEY}&units=imperial"

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
    printf "%*s%s%*s" $(( (width - ${#text}) / 2 )) "" "$text" $(( (width - ${#text} + 1) / 2 )) ""
}
print_centered_row() {
    local col1="$1"
    local col2="$2"
    local col3="$3"
    local width=16
    echo "$(center_text "$col1" $width)$(center_text "$col2" $width)$(center_text "$col3" $width)"
}
print_temp_row() {
    local high1="$1"
    local low1="$2"
    local high2="$3"
    local low2="$4"
    local high3="$5"
    local low3="$6"
    local width=68
    local temp_format="<span foreground='#FF0000'>H</span>:%d° <span foreground='#0000FF'>L</span>:%d°"
    local col1=$(printf "$temp_format" "$high1" "$low1")
    local col2=$(printf "$temp_format" "$high2" "$low2")
    local col3=$(printf "$temp_format" "$high3" "$low3")
    echo "$(printf "%-${width}s" "$col1")$(center_text "$col2" $width)$(printf "%${width}s" "$col3")"
}
get_weather() {
    local response=$(curl -s $API_URL)
    local day1_high=$(echo $response | jq -r '[.list[0:8] | .[].main.temp_max] | max' | awk '{print int($1+0.5)}')
    local day1_low=$(echo $response | jq -r '[.list[0:8] | .[].main.temp_min] | min' | awk '{print int($1+0.5)}')
    local day1_cond=$(echo $response | jq -r '.list[4].weather[0].main')
    local day2_high=$(echo $response | jq -r '[.list[8:16] | .[].main.temp_max] | max' | awk '{print int($1+0.5)}')
    local day2_low=$(echo $response | jq -r '[.list[8:16] | .[].main.temp_min] | min' | awk '{print int($1+0.5)}')
    local day2_cond=$(echo $response | jq -r '.list[12].weather[0].main')
    local day3_high=$(echo $response | jq -r '[.list[16:24] | .[].main.temp_max] | max' | awk '{print int($1+0.5)}')
    local day3_low=$(echo $response | jq -r '[.list[16:24] | .[].main.temp_min] | min' | awk '{print int($1+0.5)}')
    local day3_cond=$(echo $response | jq -r '.list[20].weather[0].main')
    
    local day1_icon=$(get_weather_icon "$day1_cond")
    local day2_icon=$(get_weather_icon "$day2_cond")
    local day3_icon=$(get_weather_icon "$day3_cond")
    local date1=$(date +"%a %b %d")
    local date2=$(date -d "1 day" +"%a %b %d")
    local date3=$(date -d "2 days" +"%a %b %d")
    
    local row1=$(print_centered_row "$date1" "$date2" "$date3")
    local row2=$(print_centered_row "$day1_icon" "$day2_icon" "$day3_icon")
    local row3=$(print_temp_row "$day1_high" "$day1_low" "$day2_high" "$day2_low" "$day3_high" "$day3_low")
    local row4=$(print_centered_row "$day1_cond" "$day2_cond" "$day3_cond")
    
    echo "<txt>${row1}
${row2}
${row3}
${row4}</txt>"
    echo "<tool>Weather Forecast for ${CITY}
${date1}: ${day1_icon}
<span foreground='#FF0000'>H</span>:${day1_high}°F <span foreground='#0000FF'>L</span>:${day1_low}°F
Condition: ${day1_cond}
${date2}: ${day2_icon}
<span foreground='#FF0000'>H</span>:${day2_high}°F <span foreground='#0000FF'>L</span>:${day2_low}°F
Condition: ${day2_cond}
${date3}: ${day3_icon}
<span foreground='#FF0000'>H</span>:${day3_high}°F <span foreground='#0000FF'>L</span>:${day3_low}°F
Condition: ${day3_cond}</tool>"
}
get_weather


#Self Hide Widget
# Get the panel with smaller width
PANEL_ID=$(wmctrl -l -G | grep "xfce4-panel" | awk '{print $1, $4}' | sort -k2n | head -1 | cut -d' ' -f1)

if [ -n "$PANEL_ID" ]; then
    wmctrl -i -r "$PANEL_ID" -b add,below
fi
