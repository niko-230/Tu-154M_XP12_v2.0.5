
--defineProperty("weel_switch", globalPropertyi("sim/custom/xap/An24_gauges/noseweel"))
defineProperty("nosewheel_turn_enable", globalPropertyi("sim/custom/switchers/nosewheel_turn_enable")) -- выключатель поворота передней стойки на штурвале
defineProperty("nosewheel_turn_sel", globalPropertyi("sim/custom/switchers/nosewheel_turn_sel")) -- переключатель угла поворота передней стойки. 0 - 10, 1 - 63

defineProperty("bus27_volt_left", globalPropertyf("sim/custom/elec/bus27_volt_left")) -- напряжение сети 27
defineProperty("bus27_volt_right", globalPropertyf("sim/custom/elec/bus27_volt_right")) -- напряжение сети 27

defineProperty("gs_press_2", globalPropertyf("sim/custom/hydro/gs_press_2")) -- давление в ГС2

defineProperty("have_pedals", globalPropertyi("sim/custom/have_pedals"))

tiller_avail = globalPropertyi("sim/joystick/joy_mapped_axis_avail[37]") -- index 37 is nosewheel tiller
tiller_val = globalPropertyf("sim/joystick/joy_mapped_axis_value[37]") -- "1 + because Lua tables start with 1"

joy_yaw = globalPropertyf("sim/cockpit2/controls/yoke_heading_ratio") -- yaw position of joystick

tire_steer_command_deg = globalPropertyf("sim/flightmodel2/gear/tire_steer_command_deg[0]")
tire_steer_actual_deg = globalPropertyf("sim/flightmodel2/gear/tire_steer_actual_deg[0]")


pushback = globalPropertyi("bp/connected")
push_started=globalPropertyi("bp/started")
override_wheel_steer = globalPropertyi("sim/operation/override/override_wheel_steer")

-- results
defineProperty("weel_angle1", globalPropertyf("sim/aircraft/gear/acf_nw_steerdeg1"))
defineProperty("weel_angle2", globalPropertyf("sim/aircraft/gear/acf_nw_steerdeg2"))
--defineProperty("weel_on", globalPropertyf("sim/cockpit2/controls/nosewheel_steer_on"))

defineProperty("lock", globalPropertyi("sim/cockpit2/controls/nosewheel_steer_on"))


function update()
	
	local pbConnect = get(pushback) == 1
	local pbStart = get(push_started) 
	set(override_wheel_steer, 1)
	local turn_mode = get(nosewheel_turn_sel)
	local press = math.min(get(gs_press_2) / 200, 1)
	local nws_on=get(nosewheel_turn_enable)
	local nws_power=(get(bus27_volt_left) > 13 or get(bus27_volt_right) > 13) and nws_on == 1 and press > 0.2
	if nws_power or pbStart>0 then
		set(lock, 1) -- do not let nosewheel become free castor
		if turn_mode == 0 then set(weel_angle1, 10 * press) set(weel_angle2, 10 * press)
		else set(weel_angle1, 63 * press) set(weel_angle2, 63 * press)
		end
	else
		set(lock, bool2int(pbConnect))
		set(weel_angle1, pbStart*63) 
		set(weel_angle2, pbStart*63)
	end
	
	-- turn nosewheel

	local pedals=get(have_pedals)==1
	if not pbConnect then
		if turn_mode == 1 and pedals then -- use tiller
			set(tire_steer_command_deg, get(tiller_val) * get(weel_angle1)*nws_on)
		else -- use yaw
			set(tire_steer_command_deg, get(joy_yaw) * get(weel_angle1)*nws_on)
		end

	end
	

	
	
	
end


--gear_togle_command = findCommand("sim/flight_controls/gyro_rotor_trim_up")

gear_togle_command = findCommand("sim/flight_controls/nwheel_steer_toggle")
function gear_toggle_handler(phase)
	if 0 == phase then
		if get(nosewheel_turn_enable) ~= 1 then set(nosewheel_turn_enable, 1)
		else set(nosewheel_turn_enable, 0) end
	end
return 0
end

registerCommandHandler(gear_togle_command, 0, gear_toggle_handler)

function onAvionicsDone()
	set(override_wheel_steer, 0)

end