-- this is starting logic
-- FIXES (XP12 support):
--   1. Исправлены перепутанные индексы sim_starter1/sim_start1 и sim_starter2/sim_start2
--   2. starter_torq теперь раздельно для XP11 (0.2) и XP12 (0.28)
--   3. set(APU_N1, 100) перенесён в блок только для XP11
--   4. Давление воздуха от ВСУ защищено проверкой — добавлен минимальный порог apu_n1
--   5. Убрано условие fuel_flow_mode из fuel_system — датареф пустой в XP12
--   6. ГЛАВНЫЙ FIX XP12: добавлено управление isolation valves левого и правого контуров
--      В XP12 ВСУ подаёт воздух только в CENTER duct (двигатель 2)
--      Для двигателей 1 и 3 нужно открывать isol_valve_left и isol_valve_right
--      Иначе стартер физически не получает воздух и не создаёт момент

-- controls
defineProperty("starter_cap",        globalPropertyi("sim/custom/switchers/eng/starter_cap"))
defineProperty("starter_switch",     globalPropertyi("sim/custom/switchers/eng/starter_switch"))
defineProperty("starter_eng_select", globalPropertyi("sim/custom/switchers/eng/starter_eng_select"))
defineProperty("starter_mode",       globalPropertyi("sim/custom/switchers/eng/starter_mode"))

defineProperty("starter_start", globalPropertyi("sim/custom/buttons/eng/starter_start"))
defineProperty("starter_stop",  globalPropertyi("sim/custom/buttons/eng/starter_stop"))

defineProperty("flight_start_1", globalPropertyi("sim/custom/buttons/eng/flight_start_1"))
defineProperty("flight_start_2", globalPropertyi("sim/custom/buttons/eng/flight_start_2"))
defineProperty("flight_start_3", globalPropertyi("sim/custom/buttons/eng/flight_start_3"))

-- default datarefs and commands
defineProperty("sim_igniter1", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[0]"))
defineProperty("sim_igniter2", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[1]"))
defineProperty("sim_igniter3", globalPropertyi("sim/cockpit2/engine/actuators/igniter_on[2]"))

defineProperty("sim_ignition1", globalPropertyi("sim/cockpit2/engine/actuators/ignition_on[0]"))
defineProperty("sim_ignition2", globalPropertyi("sim/cockpit2/engine/actuators/ignition_on[1]"))
defineProperty("sim_ignition3", globalPropertyi("sim/cockpit2/engine/actuators/ignition_on[2]"))

-- FIX: исправлены индексы — двигатель 1=[0], двигатель 2=[1], двигатель 3=[2]
--defineProperty("sim_starter1", globalPropertyf("sim/cockpit/engine/starter_duration[0]"))
--defineProperty("sim_starter2", globalPropertyf("sim/cockpit/engine/starter_duration[1]"))
--defineProperty("sim_starter3", globalPropertyf("sim/cockpit/engine/starter_duration[2]"))

defineProperty("sim_starter1", globalPropertyf("sim/cockpit2/engines/actuators/starter_hit[0]"))
defineProperty("sim_starter2", globalPropertyf("sim/cockpit2/engines/actuators/starter_hit[1]"))
defineProperty("sim_starter3", globalPropertyf("sim/cockpit2/engines/actuators/starter_hit[2]"))

--sim/cockpit2/engines/actuators/starter_hit

defineProperty("sim_start1", globalPropertyf("sim/flightmodel2/engines/starter_making_torque[0]"))
defineProperty("sim_start2", globalPropertyf("sim/flightmodel2/engines/starter_making_torque[1]"))
defineProperty("sim_start3", globalPropertyf("sim/flightmodel2/engines/starter_making_torque[2]"))

starter_1 = findCommand("sim/starters/engage_starter_1")
starter_2 = findCommand("sim/starters/engage_starter_2")
starter_3 = findCommand("sim/starters/engage_starter_3")

-- sources
defineProperty("bus27_volt_left",  globalPropertyf("sim/custom/elec/bus27_volt_left"))
defineProperty("bus27_volt_right", globalPropertyf("sim/custom/elec/bus27_volt_right"))

defineProperty("apu_air_doors", globalPropertyf("sim/custom/eng/apu_air_doors"))
defineProperty("apu_n1",        globalPropertyf("sim/custom/eng/apu_n1"))

defineProperty("eng_rpm1", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]"))
defineProperty("eng_rpm2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]"))
defineProperty("eng_rpm3", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]"))

defineProperty("eng_work1", globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[0]"))
defineProperty("eng_work2", globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[1]"))
defineProperty("eng_work3", globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[2]"))

defineProperty("eng_airvalve_1", globalPropertyf("sim/custom/bleed/eng_airvalve_1"))
defineProperty("eng_airvalve_2", globalPropertyf("sim/custom/bleed/eng_airvalve_2"))
defineProperty("eng_airvalve_3", globalPropertyf("sim/custom/bleed/eng_airvalve_3"))

defineProperty("tank1_1", globalPropertyi("sim/custom/fuel/pump_tank1_1_work"))
defineProperty("tank1_2", globalPropertyi("sim/custom/fuel/pump_tank1_2_work"))
defineProperty("tank1_3", globalPropertyi("sim/custom/fuel/pump_tank1_3_work"))
defineProperty("tank1_4", globalPropertyi("sim/custom/fuel/pump_tank1_4_work"))

defineProperty("auto_tanks_turn", globalPropertyi("sim/custom/fuel/auto_tanks_turn"))
defineProperty("fuel_flow_mode",  globalPropertyi("sim/custom/switchers/fuel/fuel_flow_mode"))

-- caps
defineProperty("engine_caps", globalPropertyi("sim/custom/anim/engine_caps"))

-- time
defineProperty("frame_time",        globalPropertyf("sim/custom/time/frame_time"))
defineProperty("frame_rate_period", globalPropertyf("sim/operation/misc/frame_rate_period"))
defineProperty("sim_run_time",      globalPropertyf("sim/time/total_running_time_sec"))

-- results
defineProperty("starter_pressure", globalPropertyf("sim/custom/start/starter_pressure"))
defineProperty("apd_working_1",    globalPropertyf("sim/custom/start/apd_working_1"))
defineProperty("apd_working_2",    globalPropertyf("sim/custom/start/apd_working_2"))
defineProperty("apd_working_3",    globalPropertyf("sim/custom/start/apd_working_3"))
defineProperty("start_sys_work",   globalPropertyf("sim/custom/start/start_sys_work"))
defineProperty("fuel_in_1", globalPropertyi("sim/custom/start/fuel_in_1"))
defineProperty("fuel_in_2", globalPropertyi("sim/custom/start/fuel_in_2"))
defineProperty("fuel_in_3", globalPropertyi("sim/custom/start/fuel_in_3"))

-- стартер
defineProperty("starter_torq",     globalPropertyf("sim/aircraft/engine/acf_starter_torque_ratio"))
defineProperty("starter_rpm",      globalPropertyf("sim/aircraft/engine/acf_starter_max_rpm_ratio"))
defineProperty("jet_spoolup_time", globalPropertyf("sim/aircraft/engine/acf_spooltime_jet"))

-- Smart Copilot
defineProperty("ismaster", globalPropertyf("scp/api/ismaster"))

-- XP версия
defineProperty("sim_vers", globalPropertyi("sim/version/xplane_internal_version"))

-- APU
defineProperty("APU_switch",  globalPropertyf("sim/cockpit/engine/APU_switch"))
defineProperty("APU_running", globalPropertyf("sim/cockpit/engine/APU_running"))
defineProperty("APU_N1",      globalPropertyf("sim/cockpit/engine/APU_N1"))
defineProperty("apu_bleed",   globalPropertyf("sim/cockpit2/bleedair/actuators/apu_bleed"))

-- FIX XP12: isolation valves — клапаны изоляции левого и правого контуров отбора воздуха
-- В XP12 ВСУ подаёт воздух только в CENTER duct (двигатель 2/хвостовой)
-- Для запуска двигателей 1 и 3 (крыльевые) нужно открыть эти клапаны
-- чтобы воздух от ВСУ попал в левый и правый контуры
defineProperty("isol_valve_left",  globalPropertyi("sim/cockpit2/bleedair/actuators/isol_valve_left"))
defineProperty("isol_valve_right", globalPropertyi("sim/cockpit2/bleedair/actuators/isol_valve_right"))

-- индикаторы наличия воздуха в контурах (для диагностики)
defineProperty("bleed_avail_left",   globalPropertyf("sim/cockpit2/bleedair/indicators/bleed_available_left"))
defineProperty("bleed_avail_center", globalPropertyf("sim/cockpit2/bleedair/indicators/bleed_available_center"))
defineProperty("bleed_avail_right",  globalPropertyf("sim/cockpit2/bleedair/indicators/bleed_available_right"))

-- engine bleed SOV — клапаны отбора воздуха от двигателей
defineProperty("eng_bleed_sov_1", globalPropertyi("sim/cockpit2/bleedair/actuators/engine_bleed_sov[0]"))
defineProperty("eng_bleed_sov_2", globalPropertyi("sim/cockpit2/bleedair/actuators/engine_bleed_sov[1]"))
defineProperty("eng_bleed_sov_3", globalPropertyi("sim/cockpit2/bleedair/actuators/engine_bleed_sov[2]"))


local xp_ver = get(sim_vers)
local IS_XP12 = xp_ver ~= nil and xp_ver >= 120000
local IS_XP11 = xp_ver ~= nil and xp_ver >= 111000 and xp_ver < 120000

if IS_XP11 then
	set(starter_torq, 0.2)
elseif IS_XP12 then
	set(starter_torq, 0.28)
	set(starter_rpm,  0.28)
end

-- FIX: frame_time с fallback
local function get_passed()
	local ft = get(frame_time)
	if ft == nil or ft <= 0 then ft = get(frame_rate_period) end
	if ft == nil or ft <= 0 then ft = 0.016 end
	return ft
end

local time_last = get(sim_run_time)

local eng1_start_time = time_last - 100
local eng2_start_time = time_last - 100
local eng3_start_time = time_last - 100

local eng1_starting = false
local eng2_starting = false
local eng3_starting = false

local eng1_starting_air = false
local eng2_starting_air = false
local eng3_starting_air = false

local eng1_rpm_check = false
local eng2_rpm_check = false
local eng3_rpm_check = false

commandEnd(starter_1)
commandEnd(starter_2)
commandEnd(starter_3)

local start_button_pressed = false
local starter_press = 0

local select_last = get(starter_eng_select)

local START_SEQ_TIME = 56
local RPM_FOR_FUEL_IN = 16
local RPM_FOR_IGNITER = 20
local RPM_APD_OFF = 47

local eng_start_press_t = {{ -100000, 0.0 },
                  {  0, 00 },
				  {  70, 0.35 },
           	      {  83, 1.05 },
				  {  100, 1.3 },
          	      {  1000000000, 110 }}


function update()

	-- XP11 костыль только для XP11
	if IS_XP11 then
		set(APU_N1, 100)
	end

	-- FIX XP12: управление isolation valves и bleed SOV
	-- Открываем клапаны изоляции и отбора воздуха от двигателей
	-- Это позволяет воздуху от ВСУ и работающих двигателей
	-- добраться до стартеров двигателей 1 и 3
	if IS_XP12 then
		-- APU bleed всегда открыт если ВСУ работает
		local apu_n1_val = get(apu_n1)
		if apu_n1_val ~= nil and apu_n1_val > 50 then
			set(apu_bleed, 1)
		end
		-- isolation valves открыты — воздух идёт во все три контура
		set(isol_valve_left,  1)
		set(isol_valve_right, 1)
		-- клапаны отбора воздуха от двигателей открыты
		-- это позволяет запущенному двигателю 2 давать воздух для запуска 1 и 3
		set(eng_bleed_sov_1, 1)
		set(eng_bleed_sov_2, 1)
		set(eng_bleed_sov_3, 1)
	end

	starter_press = get(starter_pressure)

	local passed = get_passed()

	local rpm1 = get(eng_rpm1)
	local rpm2 = get(eng_rpm2)
	local rpm3 = get(eng_rpm3)

	local time_now = get(sim_run_time)

	local blocked = get(engine_caps) == 1

	-- автоматическое отключение топлива если двигатель не запустился
	if (time_now - eng1_start_time > START_SEQ_TIME and rpm1 < RPM_APD_OFF) or (blocked and rpm1 >= 5) then
		set(fuel_in_1, 0)
		set(sim_ignition1, 0)
		set(sim_igniter1, 0)
		commandEnd(starter_1)
	end
	if (time_now - eng2_start_time > START_SEQ_TIME and rpm2 < RPM_APD_OFF) or (blocked and rpm2 >= 5) then
		set(fuel_in_2, 0)
		set(sim_ignition2, 0)
		set(sim_igniter2, 0)
		commandEnd(starter_2)
	end
	if (time_now - eng3_start_time > START_SEQ_TIME and rpm3 < RPM_APD_OFF) or (blocked and rpm3 >= 5) then
		set(fuel_in_3, 0)
		set(sim_ignition3, 0)
		set(sim_igniter3, 0)
		commandEnd(starter_3)
	end

	-- давление воздуха от работающих двигателей
	local press_1 = get(eng_work1) * get(eng_airvalve_1) * interpolate(eng_start_press_t, rpm1)
	local press_2 = get(eng_work2) * get(eng_airvalve_2) * interpolate(eng_start_press_t, rpm2)
	local press_3 = get(eng_work3) * get(eng_airvalve_3) * interpolate(eng_start_press_t, rpm3)

	local power27L = get(bus27_volt_left) > 13
	local power27R = get(bus27_volt_right) > 13

	local start_mode  = get(starter_mode)
	local power_sys   = get(starter_switch) == 1 and power27L and power27R
	local start_button = get(starter_start) == 1
	local eng_select  = get(starter_eng_select)

	local stop_button = get(starter_stop) == 1 or eng_select ~= select_last

	select_last = eng_select

	if power_sys then
		set(start_sys_work, 1)

		-- давление от ВСУ с проверкой оборотов
		local apu_contrib = 0
		local apu_n1_val   = get(apu_n1)
		local apu_doors_val = get(apu_air_doors)
		if apu_n1_val ~= nil and apu_n1_val > 50 and apu_doors_val ~= nil then
			apu_contrib = apu_doors_val * apu_n1_val * 0.01
		end

		starter_press = starter_press + (apu_contrib + (press_1 + press_2 + press_3)) * passed

		-- начало процесса запуска
		local fuel_system = get(auto_tanks_turn) > 0 and get(tank1_1) + get(tank1_2) + get(tank1_3) + get(tank1_4) == 4

		if not eng1_starting and not eng2_starting and not eng3_starting and start_button and starter_press > 3 and fuel_system then
			if eng_select == 1 and power27L and rpm1 < RPM_APD_OFF then
				eng1_start_time = time_now

				eng1_starting = true
				eng2_starting = false
				eng3_starting = false
				eng1_starting_air = false
				eng2_starting_air = false
				eng3_starting_air = false
			elseif eng_select == 2 and power27R and rpm2 < RPM_APD_OFF then
				eng2_start_time = time_now

				eng1_starting = false
				eng2_starting = true
				eng3_starting = false
				eng1_starting_air = false
				eng2_starting_air = false
				eng3_starting_air = false
			elseif eng_select == 3 and power27R and rpm3 < RPM_APD_OFF then
				eng3_start_time = time_now

				eng1_starting = false
				eng2_starting = false
				eng3_starting = true
				eng1_starting_air = false
				eng2_starting_air = false
				eng3_starting_air = false
			end
		end

	else
		set(start_sys_work, 0)
	end

		----------------
		-- engine 1 --
		-----------------

	if eng1_starting and not eng1_starting_air and power27L then
		if time_now - eng1_start_time > 1 and time_now - eng1_start_time <= START_SEQ_TIME then
			commandBegin(starter_1)
		end

		if rpm1 > RPM_APD_OFF or time_now - eng1_start_time > START_SEQ_TIME then
			commandEnd(starter_1)
			eng1_starting = false
		end

		if rpm1 >= RPM_FOR_FUEL_IN then
			set(fuel_in_1, start_mode)
		end

		if rpm1 >= RPM_FOR_IGNITER then
			set(sim_ignition1, 1)
			set(sim_igniter1, 1)
		end

		if stop_button then
			commandEnd(starter_1)
			eng1_starting = false
			set(sim_ignition1, 0)
			set(sim_igniter1, 0)
			eng1_start_time = eng1_start_time - 70
		end
	end

	-- запуск в полёте двигатель 1
	if not eng1_starting and not eng1_starting_air and get(flight_start_1) == 1 and rpm1 > RPM_FOR_IGNITER and power27L then
		eng1_start_time = time_now
		eng1_starting_air = true
	end

	if eng1_starting_air then
		if time_now - eng1_start_time < START_SEQ_TIME and rpm1 > RPM_FOR_IGNITER and rpm1 < RPM_APD_OFF + 20 then
			set(sim_ignition1, 1)
			set(sim_igniter1, 1)
			commandBegin(starter_1)
			set(fuel_in_1, 1)
		else
			commandEnd(starter_1)
			eng1_starting_air = false
		end
	end

		----------------
		-- engine 2 --
		-----------------

	if eng2_starting and not eng2_starting_air and power27R then
		if time_now - eng2_start_time > 1 and time_now - eng2_start_time <= START_SEQ_TIME then
			commandBegin(starter_2)
		end

		if rpm2 > RPM_APD_OFF or time_now - eng2_start_time > START_SEQ_TIME then
			commandEnd(starter_2)
			eng2_starting = false
		end

		if rpm2 >= RPM_FOR_FUEL_IN then
			set(fuel_in_2, start_mode)
		end

		if rpm2 >= RPM_FOR_IGNITER then
			set(sim_ignition2, 1)
			set(sim_igniter2, 1)
		end

		if stop_button then
			commandEnd(starter_2)
			eng2_starting = false
			set(sim_ignition2, 0)
			set(sim_igniter2, 0)
			eng2_start_time = eng2_start_time - 70
		end
	end

	-- запуск в полёте двигатель 2
	if not eng2_starting and not eng2_starting_air and get(flight_start_2) == 1 and rpm2 > RPM_FOR_IGNITER and power27R then
		eng2_start_time = time_now
		eng2_starting_air = true
	end

	if eng2_starting_air then
		if time_now - eng2_start_time < START_SEQ_TIME and rpm2 > RPM_FOR_IGNITER and rpm2 < RPM_APD_OFF + 20 then
			set(sim_ignition2, 1)
			set(sim_igniter2, 1)
			commandBegin(starter_2)
			set(fuel_in_2, 1)
		else
			commandEnd(starter_2)
			eng2_starting_air = false
		end
	end

		----------------
		-- engine 3 --
		-----------------

	if eng3_starting and not eng3_starting_air and power27R then
		if time_now - eng3_start_time > 1 and time_now - eng3_start_time <= START_SEQ_TIME then
			commandBegin(starter_3)
		end

		if rpm3 > RPM_APD_OFF or time_now - eng3_start_time > START_SEQ_TIME then
			commandEnd(starter_3)
			eng3_starting = false
		end

		if rpm3 >= RPM_FOR_FUEL_IN then
			set(fuel_in_3, start_mode)
		end

		if rpm3 >= RPM_FOR_IGNITER then
			set(sim_ignition3, 1)
			set(sim_igniter3, 1)
		end

		if stop_button then
			commandEnd(starter_3)
			eng3_starting = false
			set(sim_ignition3, 0)
			set(sim_igniter3, 0)
			eng3_start_time = eng3_start_time - 70
		end
	end

	-- запуск в полёте двигатель 3
	if not eng3_starting and not eng3_starting_air and get(flight_start_3) == 1 and rpm3 > RPM_FOR_IGNITER and power27R then
		eng3_start_time = time_now
		eng3_starting_air = true
	end

	if eng3_starting_air then
		if time_now - eng3_start_time < START_SEQ_TIME and rpm3 > RPM_FOR_IGNITER and rpm3 < RPM_APD_OFF + 20 then
			set(sim_ignition3, 1)
			set(sim_igniter3, 1)
			commandBegin(starter_3)
			set(fuel_in_3, 1)
		else
			commandEnd(starter_3)
			eng3_starting_air = false
		end
	end

	----------------------------------------
	-- остановить стартер (защита от зависания)
	if not eng1_starting and not eng1_starting_air then
		commandEnd(starter_1)
	end
	if not eng2_starting and not eng2_starting_air then
		commandEnd(starter_2)
	end
	if not eng3_starting and not eng3_starting_air then
		commandEnd(starter_3)
	end

	-- снижение давления в системе запуска
	starter_press = starter_press - (0.2 * passed) * (starter_press + 1)
	starter_press = starter_press - bool2int(eng1_starting or eng2_starting or eng3_starting) * passed * 0.4

	if starter_press > 4.8 then starter_press = 4.8
	elseif starter_press < 0 then starter_press = 0 end

	-- запись результатов
	if get(ismaster) ~= 1 then
		set(starter_pressure, starter_press)
		set(apd_working_1, bool2int(eng1_starting or eng1_starting_air))
		set(apd_working_2, bool2int(eng2_starting or eng2_starting_air))
		set(apd_working_3, bool2int(eng3_starting or eng3_starting_air))
	end

end
