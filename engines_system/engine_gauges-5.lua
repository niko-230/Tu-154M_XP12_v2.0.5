-- this is engine's gauges logic
-- FIXES (XP12 support):
--   1. XP11 table override now only applies to XP11 (not XP12)
--   2. Barometer dataref: sim/weather/barometer_sealevel_inhg replaced with
--      sim/weather/region/sealevel_pressure_pas for XP12 compatibility
--   3. frame_time fallback to sim/operation/misc/frame_rate_period if custom returns 0
--   4. Removed unused hascontrol_1 dataref

defineProperty("xp_version", globalPropertyi("sim/version/xplane_internal_version"))
-- определяем версию симулятора сразу чтобы использовать ниже при объявлении датарефов
local _xp_ver_early = get(globalPropertyi("sim/version/xplane_internal_version"))
IS_XP12 = _xp_ver_early >= 120000
-- controls
defineProperty("control_ut", globalPropertyi("sim/custom/buttons/eng/control_ut")) -- кнопка контроль УТ
defineProperty("control_vibro_1", globalPropertyi("sim/custom/buttons/eng/control_vibro_1")) -- кнопка контроль вибрации
defineProperty("control_vibro_2", globalPropertyi("sim/custom/buttons/eng/control_vibro_2")) -- кнопка контроль вибрации
defineProperty("control_vibro_3", globalPropertyi("sim/custom/buttons/eng/control_vibro_3")) -- кнопка контроль вибрации
defineProperty("vibro_sel_1", globalPropertyi("sim/custom/switchers/eng/vibro_sel_1")) -- переключатель прибора вибрации
defineProperty("vibro_sel_2", globalPropertyi("sim/custom/switchers/eng/vibro_sel_2")) -- переключатель прибора вибрации
defineProperty("vibro_sel_3", globalPropertyi("sim/custom/switchers/eng/vibro_sel_3")) -- переключатель прибора вибрации

defineProperty("fuel_meter_on", globalPropertyi("sim/custom/switchers/fuel/fuel_meter_mech_on")) -- расходомер

defineProperty("gauges_on_1", globalPropertyi("sim/custom/switchers/eng/gauges_on_1")) -- приборы контроля двигателей
defineProperty("gauges_on_2", globalPropertyi("sim/custom/switchers/eng/gauges_on_2")) -- приборы контроля двигателей
defineProperty("gauges_on_3", globalPropertyi("sim/custom/switchers/eng/gauges_on_3")) -- приборы контроля двигателей

-- gauges
defineProperty("rpm_low_1", globalPropertyf("sim/custom/gauges/engine/rpm_low_1")) -- обороты турбины низкого давления №1
defineProperty("rpm_low_2", globalPropertyf("sim/custom/gauges/engine/rpm_low_2")) -- обороты турбины низкого давления №2
defineProperty("rpm_low_3", globalPropertyf("sim/custom/gauges/engine/rpm_low_3")) -- обороты турбины низкого давления №3
defineProperty("rpm_high_1", globalPropertyf("sim/custom/gauges/engine/rpm_high_1")) -- обороты турбины высокого давления №1
defineProperty("rpm_high_2", globalPropertyf("sim/custom/gauges/engine/rpm_high_2")) -- обороты турбины высокого давления №2
defineProperty("rpm_high_3", globalPropertyf("sim/custom/gauges/engine/rpm_high_3")) -- обороты турбины высокого давления №3

defineProperty("egt_1", globalPropertyf("sim/custom/gauges/eng/egt_1")) -- ТВГ двиг 1
defineProperty("egt_2", globalPropertyf("sim/custom/gauges/eng/egt_2")) -- ТВГ двиг 2
defineProperty("egt_3", globalPropertyf("sim/custom/gauges/eng/egt_3")) -- ТВГ двиг 3

defineProperty("fuel_press_1", globalPropertyf("sim/custom/gauges/eng/fuel_press_1")) -- давление топлива двиг 1
defineProperty("fuel_press_2", globalPropertyf("sim/custom/gauges/eng/fuel_press_2")) -- давление топлива двиг 2
defineProperty("fuel_press_3", globalPropertyf("sim/custom/gauges/eng/fuel_press_3")) -- давление топлива двиг 3

defineProperty("oil_press_1", globalPropertyf("sim/custom/gauges/eng/oil_press_1")) -- давление масла двиг 1
defineProperty("oil_press_2", globalPropertyf("sim/custom/gauges/eng/oil_press_2")) -- давление масла двиг 2
defineProperty("oil_press_3", globalPropertyf("sim/custom/gauges/eng/oil_press_3")) -- давление масла двиг 3

defineProperty("oil_temp_1", globalPropertyf("sim/custom/gauges/eng/oil_temp_1")) -- температура масла двиг 1
defineProperty("oil_temp_2", globalPropertyf("sim/custom/gauges/eng/oil_temp_2")) -- температура масла двиг 2
defineProperty("oil_temp_3", globalPropertyf("sim/custom/gauges/eng/oil_temp_3")) -- температура масла двиг 3

defineProperty("fuel_flow_1", globalPropertyf("sim/custom/gauges/eng/fuel_flow_1")) -- расход топлива двиг 1
defineProperty("fuel_flow_2", globalPropertyf("sim/custom/gauges/eng/fuel_flow_2")) -- расход топлива двиг 2
defineProperty("fuel_flow_3", globalPropertyf("sim/custom/gauges/eng/fuel_flow_3")) -- расход топлива двиг 3

defineProperty("vibra_1", globalPropertyf("sim/custom/gauges/eng/vibra_1")) -- вибрация двиг 1
defineProperty("vibra_2", globalPropertyf("sim/custom/gauges/eng/vibra_2")) -- вибрация двиг 2
defineProperty("vibra_3", globalPropertyf("sim/custom/gauges/eng/vibra_3")) -- вибрация двиг 3


defineProperty("oil_qty_1", globalPropertyf("sim/custom/gauges/eng/oil_qty_1")) -- количество масла
defineProperty("oil_qty_2", globalPropertyf("sim/custom/gauges/eng/oil_qty_2")) -- количество масла
defineProperty("oil_qty_3", globalPropertyf("sim/custom/gauges/eng/oil_qty_3")) -- количество масла

defineProperty("fuel_temp_1", globalPropertyf("sim/custom/gauges/eng/fuel_temp_1")) -- температура топлива
defineProperty("fuel_temp_2", globalPropertyf("sim/custom/gauges/eng/fuel_temp_2")) -- температура топлива


-- sources xp11 
--defineProperty("sim_egt_1", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[0]")) -- EGT from sim
--defineProperty("sim_egt_2", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[1]")) -- EGT from sim
--defineProperty("sim_egt_3", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_C[2]")) -- EGT from sim

-- sources xp12 
defineProperty("sim_egt_1", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_cel[0]")) -- EGT from sim
defineProperty("sim_egt_2", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_cel[1]")) -- EGT from sim
defineProperty("sim_egt_3", globalPropertyf("sim/cockpit2/engine/indicators/EGT_deg_cel[2]")) -- EGT from sim

--sim/cockpit2/engine/indicators/EGT_deg_cel new dataref - - 

defineProperty("ENGN_FF_1", globalPropertyf("sim/cockpit2/engine/indicators/fuel_flow_kg_sec[0]")) -- FF from sim kg/second
defineProperty("ENGN_FF_2", globalPropertyf("sim/cockpit2/engine/indicators/fuel_flow_kg_sec[1]")) -- FF from sim kg/second
defineProperty("ENGN_FF_3", globalPropertyf("sim/cockpit2/engine/indicators/fuel_flow_kg_sec[2]")) -- FF from sim kg/second

defineProperty("fuel_p_1", globalPropertyf("sim/cockpit2/engine/indicators/fuel_pressure_psi[0]"))
defineProperty("fuel_p_2", globalPropertyf("sim/cockpit2/engine/indicators/fuel_pressure_psi[1]"))
defineProperty("fuel_p_3", globalPropertyf("sim/cockpit2/engine/indicators/fuel_pressure_psi[2]"))

defineProperty("oil_p_1", globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[0]"))
defineProperty("oil_p_2", globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[1]"))
defineProperty("oil_p_3", globalPropertyf("sim/cockpit2/engine/indicators/oil_pressure_psi[2]"))

defineProperty("oil_t_1", globalPropertyf("sim/cockpit2/engine/indicators/oil_temperature_deg_C[0]"))
defineProperty("oil_t_2", globalPropertyf("sim/cockpit2/engine/indicators/oil_temperature_deg_C[1]"))
defineProperty("oil_t_3", globalPropertyf("sim/cockpit2/engine/indicators/oil_temperature_deg_C[2]"))

defineProperty("vibration_1", globalPropertyf("sim/custom/eng/vibration_1")) -- вибрация двигателя
defineProperty("vibration_2", globalPropertyf("sim/custom/eng/vibration_2")) -- вибрация двигателя
defineProperty("vibration_3", globalPropertyf("sim/custom/eng/vibration_3")) -- вибрация двигателя

defineProperty("engn_oil_qty_1", globalPropertyf("sim/custom/failures/engn_oil_qty_1")) -- остаток масла
defineProperty("engn_oil_qty_2", globalPropertyf("sim/custom/failures/engn_oil_qty_2")) -- остаток масла
defineProperty("engn_oil_qty_3", globalPropertyf("sim/custom/failures/engn_oil_qty_3")) -- остаток масла




-- engines
defineProperty("eng1_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]")) -- engine 1 rpm
defineProperty("eng2_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]")) -- engine 2 rpm
defineProperty("eng3_N1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]")) -- engine 3 rpm

defineProperty("eng1_N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]")) -- engine 1 rpm
defineProperty("eng2_N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]")) -- engine 2 rpm
defineProperty("eng3_N2", globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]")) -- engine 3 rpm

defineProperty("comsta0", globalPropertyi("sim/operation/failures/rel_comsta0")) -- compressor stall
defineProperty("comsta1", globalPropertyi("sim/operation/failures/rel_comsta1"))
defineProperty("comsta2", globalPropertyi("sim/operation/failures/rel_comsta2"))


-- other sources
defineProperty("bus27_volt_left", globalPropertyf("sim/custom/elec/bus27_volt_left")) -- напряжение сети 27
defineProperty("bus27_volt_right", globalPropertyf("sim/custom/elec/bus27_volt_right")) -- напряжение сети 27

defineProperty("emerg_inv115", globalPropertyi("sim/custom/switchers/eng/emerg_inv115")) -- аварийн. преобраз 115в

defineProperty("bus115_1_volt", globalPropertyf("sim/custom/elec/bus115_1_volt"))

defineProperty("bus36_volt_left", globalPropertyf("sim/custom/elec/bus36_volt_left")) -- напряжение сети 36в лев
defineProperty("bus36_volt_right", globalPropertyf("sim/custom/elec/bus36_volt_right")) -- напряжение сети 36в прав

defineProperty("thermo", globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc")) -- outside temperature

defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  -- MSL alt in meters

-- FIX: барометр — XP12 использует sim/weather/region/sealevel_pressure_pas (Паскали)
-- XP10/11 использовал sim/weather/barometer_sealevel_inhg (inHg)
-- Определяем версию симулятора для выбора нужного датарефа
local xp_ver_init = globalPropertyi("sim/version/xplane_internal_version")
local _xp_ver_val = globalPropertyi("sim/version/xplane_internal_version")

defineProperty("baro_press_pas",  globalPropertyf("sim/weather/region/sealevel_pressure_pas"))   -- XP12: давление в Паскалях
-- XP11: старый датареф объявляем только если не XP12 чтобы не было предупреждений в логе
if not IS_XP12 then
	defineProperty("baro_press_inhg", globalPropertyf("sim/weather/barometer_sealevel_inhg"))
end

-- failures
defineProperty("fuel_flowmeter_1_fail", globalPropertyi("sim/custom/failures/fuel_flowmeter_1_fail"))
defineProperty("fuel_flowmeter_2_fail", globalPropertyi("sim/custom/failures/fuel_flowmeter_2_fail"))
defineProperty("fuel_flowmeter_3_fail", globalPropertyi("sim/custom/failures/fuel_flowmeter_3_fail"))

-- Smart Copilot
defineProperty("ismaster", globalPropertyf("scp/api/ismaster")) -- Master. 0 = plugin not found, 1 = slave 2 = master
-- hascontrol_1 удалён — не использовался в коде

-- time
defineProperty("frame_time", globalPropertyf("sim/custom/time/frame_time")) -- flight time (custom)
defineProperty("frame_rate_period", globalPropertyf("sim/operation/misc/frame_rate_period")) -- стандартный fallback


MASTER = get(ismaster) ~= 1  -- не local: обновляется в update() каждый кадр

-- FIX: frame_time — если кастомный датареф вернул 0 при инициализации, используем стандартный
local function get_passed()
	local ft = get(frame_time)
	if ft == nil or ft <= 0 then
		ft = get(frame_rate_period)
	end
	if ft == nil or ft <= 0 then ft = 0.016 end -- крайний fallback ~60fps
	return ft
end

local passed = get_passed()

-- FIX: определяем версию один раз при старте
local xp_version_val = get(xp_version)
local IS_XP12 = xp_version_val >= 120000  -- XP12 internal version >= 120000
local IS_XP11 = xp_version_val >= 110000 and xp_version_val < 120000

-- FIX: универсальная функция получения давления на уровне моря в inHg
local function get_baro_inhg()
	if IS_XP12 then
		-- XP12: давление в Паскалях, переводим в inHg (1 inHg = 3386.39 Па)
		local pas = get(baro_press_pas)
		if pas and pas > 0 then
			return pas / 3386.39
		else
			return 29.92 -- fallback стандартная атмосфера
		end
	else
		-- XP10/11: датареф уже в inHg
		local inhg = get(baro_press_inhg)
		if inhg and inhg > 0 then
			return inhg
		else
			return 29.92
		end
	end
end

local power_27_L = get(bus27_volt_left) > 13
local power_27_R = get(bus27_volt_right) > 13
local power_36_L = get(bus36_volt_left) > 30
local power_36_R = get(bus36_volt_right) > 30
local power_115 = get(bus115_1_volt) > 110

local gau_1_on = get(gauges_on_1)
local gau_2_on = get(gauges_on_2)
local gau_3_on = get(gauges_on_3)

-- vibration gauges

local vibr_1_actual = 0
local vibr_2_actual = 0
local vibr_3_actual = 0

local function vibra_gau()

	local vibr_1 = 0
	local vibr_2 = 0
	local vibr_3 = 0
	
	local vibrat_1 = get(vibration_1)
	local vibrat_2 = get(vibration_2)
	local vibrat_3 = get(vibration_3)
	
	if power_27_L then
		if get(control_vibro_1) == 1 then
			vibr_1 = 95 * gau_1_on
		elseif get(vibro_sel_1) == 0 then
			vibr_1 = vibrat_1 * gau_1_on * 0.95
		else
			vibr_1 = vibrat_1 * gau_1_on 
		end
	end
	
	if power_27_R then
		if get(control_vibro_2) == 1 then
			vibr_2 = 95 * gau_2_on
		elseif get(vibro_sel_2) == 0 then
			vibr_2 = vibrat_2 * gau_2_on * 0.95
		else
			vibr_2 = vibrat_2 * gau_2_on
		end		
		
		if get(control_vibro_3) == 1 then
			vibr_3 = 95 * gau_3_on
		elseif get(vibro_sel_3) == 0 then
			vibr_3 = vibrat_3 * gau_3_on * 0.95
		else
			vibr_3 = vibrat_3 * gau_3_on
		end
	end
	
	-- smooth movement
	vibr_1_actual = vibr_1_actual + (vibr_1 - vibr_1_actual) * passed * 3
	vibr_2_actual = vibr_2_actual + (vibr_2 - vibr_2_actual) * passed * 3
	vibr_3_actual = vibr_3_actual + (vibr_3 - vibr_3_actual) * passed * 3

	-- set results
	set(vibra_1, vibr_1_actual)
	set(vibra_2, vibr_2_actual)
	set(vibra_3, vibr_3_actual)


end



-- 3 needle gauges

local fuelP_1_actual = 0
local fuelP_2_actual = 0
local fuelP_3_actual = 0

local oilP_1_actual = 0
local oilP_2_actual = 0
local oilP_3_actual = 0

local oilT_1_actual = 0
local oilT_2_actual = 0
local oilT_3_actual = 0

local fuel_P_table = {{ -100000, 0.0 },    -- bugs walkaround
                  {  0, 00 }, -- zero pressure
				  {  40, 30 }, --
				  {  50, 40 }, -- 
           	      {  60, 60 }, -- 
				  {  100, 100 },    -- 
          	      {  1000000000, 110 }}    -- bugs walkaround	

local oil_P_table = {{ -100000, 0.0 },    -- bugs walkaround
                  {  0, 00 }, -- zero pressure
				  {  15, 30 }, -- 
           	      {  45, 41 }, -- 
				  {  80, 80 },    -- 
          	      {  1000000000, 110 }}    -- bugs walkaround	

local function emi3()
	
	local fuelP_1 = 0
	local fuelP_2 = 0
	local fuelP_3 = 0
	
	local oilP_1 = 0
	local oilP_2 = 0
	local oilP_3 = 0
	
	local oilT_1 = -50
	local oilT_2 = -50
	local oilT_3 = -50
	
	if power_36_L then 
		fuelP_1 = interpolate(fuel_P_table, get(fuel_p_1))-- * gau_1_on
		oilP_1 = interpolate(oil_P_table, get(oil_p_1)) * 0.1-- * gau_1_on 
	end	
	
	if power_36_R then
		fuelP_2 = interpolate(fuel_P_table, get(fuel_p_2))-- * gau_2_on
		fuelP_3 = interpolate(fuel_P_table, get(fuel_p_3))-- * gau_3_on
		
		oilP_2 = interpolate(oil_P_table, get(oil_p_2)) * 0.1-- * gau_2_on
		oilP_3 = interpolate(oil_P_table, get(oil_p_3)) * 0.1-- * gau_3_on
	end
	
	if power_27_L then --and gau_1_on == 1 then
		oilT_1 = get(oil_t_1)
	end

	if power_27_R then --and gau_2_on == 1 then
		oilT_2 = get(oil_t_2)
	end

	if power_27_R then --and gau_3_on == 1 then
		oilT_3 = get(oil_t_3)
	end	

	-- smooth movements
	fuelP_1_actual = fuelP_1_actual + (fuelP_1 - fuelP_1_actual) * passed * 3
	fuelP_2_actual = fuelP_2_actual + (fuelP_2 - fuelP_2_actual) * passed * 3
	fuelP_3_actual = fuelP_3_actual + (fuelP_3 - fuelP_3_actual) * passed * 3
	
	oilP_1_actual = oilP_1_actual + (oilP_1 - oilP_1_actual) * passed * 3
	oilP_2_actual = oilP_2_actual + (oilP_2 - oilP_2_actual) * passed * 3
	oilP_3_actual = oilP_3_actual + (oilP_3 - oilP_3_actual) * passed * 3
	
	oilT_1_actual = oilT_1_actual + (oilT_1 - oilT_1_actual) * passed * 3
	oilT_2_actual = oilT_2_actual + (oilT_2 - oilT_2_actual) * passed * 3
	oilT_3_actual = oilT_3_actual + (oilT_3 - oilT_3_actual) * passed * 3
	
	-- set results
	set(fuel_press_1, fuelP_1_actual)
	set(fuel_press_2, fuelP_2_actual)
	set(fuel_press_3, fuelP_3_actual)
	
	set(oil_press_1, oilP_1_actual)
	set(oil_press_2, oilP_2_actual)
	set(oil_press_3, oilP_3_actual)
	
	set(oil_temp_1, oilT_1_actual)
	set(oil_temp_2, oilT_2_actual)
	set(oil_temp_3, oilT_3_actual)


end




-- EGT
local egt_1_actual = 0
local egt_2_actual = 0
local egt_3_actual = 0

local EGT_gau_on_L = 0
local EGT_gau_on_R = 0

local function egt_gauges()
	
	-- check power for EGT gauges

	local emerg_sw = get(emerg_inv115) == 1
	
	local power_L = power_27_L and (power_115 or ((power_27_L or power_27_R) and emerg_sw))
	local power_R = power_27_R and (power_115 or ((power_27_L or power_27_R) and emerg_sw))
	
	local egt_1_need = 0
	local egt_2_need = 0
	local egt_3_need = 0
	
	local stall_1 = 0
	if get(comsta0) == 6 then stall_1 = 1 end
	local stall_2 = 0
	if get(comsta1) == 6 then stall_2 = 1 end
	local stall_3 = 0
	if get(comsta2) == 6 then stall_3 = 1 end
	
	local test_button = get(control_ut) == 1
	
	if power_L then
		egt_1_need = get(sim_egt_1) * (1 + stall_1 * 1)
		if test_button then egt_1_need = 120 end
		EGT_gau_on_L = 1
	else
		EGT_gau_on_L = 0
	end
	if power_R then
		egt_2_need = get(sim_egt_2) * (1 + stall_2 * 1)
		egt_3_need = get(sim_egt_3) * (1 + stall_3 * 1)
		if test_button then egt_2_need = 140 end
		if test_button then egt_3_need = 130 end
		EGT_gau_on_R = 1
	else
		EGT_gau_on_R = 0
	end	
	
	-- smooth needle movement
	egt_1_actual = egt_1_actual + (egt_1_need - egt_1_actual) * passed
	egt_2_actual = egt_2_actual + (egt_2_need - egt_2_actual) * passed
	egt_3_actual = egt_3_actual + (egt_3_need - egt_3_actual) * passed
	
	set(egt_1, egt_1_actual)
	set(egt_2, egt_2_actual)
	set(egt_3, egt_3_actual)

end


-- fuel flow meters
local FF_1 = 200
local FF_2 = 200
local FF_3 = 200

local FF_1_act = 200
local FF_2_act = 200
local FF_3_act = 200

local fuel_flow_gau_on = 0

local function fuel_flow()
	
	-- check power for gauges
	local power = power_27_R and power_115 and get(fuel_meter_on) == 1
	
	if power then 
		FF_1 = get(ENGN_FF_1) * 3600 * (1 - get(fuel_flowmeter_1_fail))
		FF_2 = get(ENGN_FF_2) * 3600 * (1 - get(fuel_flowmeter_2_fail))
		FF_3 = get(ENGN_FF_3) * 3600 * (1 - get(fuel_flowmeter_3_fail))
		fuel_flow_gau_on = 1
	else
		fuel_flow_gau_on = 0
	end
	
	-- set limits
	if FF_1 < 200 then FF_1 = 200 end
	if FF_2 < 200 then FF_2 = 200 end
	if FF_3 < 200 then FF_3 = 200 end
	
	-- set smooth
	FF_1_act = FF_1_act + (FF_1 - FF_1_act) * passed * 3
	FF_2_act = FF_2_act + (FF_2 - FF_2_act) * passed * 3
	FF_3_act = FF_3_act + (FF_3 - FF_3_act) * passed * 3
	
	set(fuel_flow_1, FF_1_act)
	set(fuel_flow_2, FF_2_act)
	set(fuel_flow_3, FF_3_act)

end

-- tachometers (physics-based spin-up logic from B2)
-- All state variables packed into table T to stay under SASL 60-upvalue limit

-- читаем текущие N2 из симулятора при инициализации, чтобы иглы не выстреливали
local _n2_init_1 = get(globalPropertyf("sim/flightmodel/engine/ENGN_N2_[0]")) or 0
local _n2_init_2 = get(globalPropertyf("sim/flightmodel/engine/ENGN_N2_[1]")) or 0
local _n2_init_3 = get(globalPropertyf("sim/flightmodel/engine/ENGN_N2_[2]")) or 0
local _n1_init_1 = get(globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]")) or 0
local _n1_init_2 = get(globalPropertyf("sim/flightmodel/engine/ENGN_N1_[1]")) or 0
local _n1_init_3 = get(globalPropertyf("sim/flightmodel/engine/ENGN_N1_[2]")) or 0

local T = {
	-- N2 gauge needle state (high-pressure tachometer) — инициализируем текущим N2
	ang1 = _n2_init_1, ang2 = _n2_init_2, ang3 = _n2_init_3,
	-- N1 gauge needle state (low-pressure tachometer) — инициализируем текущим N1
	ang1b = _n1_init_1, ang2b = _n1_init_2, ang3b = _n1_init_3,
	-- last N2 values — инициализируем текущим N2 чтобы delta=0 в первом фрейме
	rpm1_last = _n2_init_1, rpm2_last = _n2_init_2, rpm3_last = _n2_init_3,
	-- IGV (inlet guide vanes) state
	rna1 = 0, rna2 = 0, rna3 = 0,
	-- turbine power coefficients
	cturb1 = 1, cturb2 = 1, cturb3 = 1,
	-- N1 physics integrators — инициализируем текущим N1
	N2need1 = _n1_init_1, N2need2 = _n1_init_2, N2need3 = _n1_init_3,
	N2need1_old = _n1_init_1, N2need2_old = _n1_init_2, N2need3_old = _n1_init_3,
	N2need1_prev = _n1_init_1, N2need2_prev = _n1_init_2, N2need3_prev = _n1_init_3,
	N1need1 = _n2_init_1, N1need2 = _n2_init_2, N1need3 = _n2_init_3,
	-- N2 windmilling runout — инициализируем текущим N2
	n2run1 = _n2_init_1, n2run2 = _n2_init_2, n2run3 = _n2_init_3,
	-- needle start-move flags — если двигатель уже работает, разрешаем движение
	nmove1 = bool2int(_n1_init_1 > 20),
	nmove2 = bool2int(_n1_init_2 > 20),
	nmove3 = bool2int(_n1_init_3 > 20),
	-- dynamic pressure and time
	q = 0, tme = 0, tas_LP = 0,
	-- fan animation angles
	fan1 = math.random()*360, fan3 = math.random()*360,
	-- startup delay counter — если двигатели уже запущены, пропускаем задержку
	start_timer = bool2int(_n2_init_1 > 10 or _n2_init_2 > 10 or _n2_init_3 > 10) * 60,
	-- physics constants — откалиброваны под Д-30КУ-154 (Ту-154М)
	-- Д-30КУ-154: двухвальный ТРДД, тяга 11000 кгс
	-- КВД (N2): стартер отключается 41-44%, антипомпаж закрывается 79%
	-- ВНА: открывается 74.5-92.5% N2, ротор КВД тяжелее чем у НК-8
	M_rot   = 0.55,    -- масса ротора КНД (Д-30 тяжелее НК-8)
	c_aero  = 0.0032,  -- аэродинамическое сопротивление КНД
	c_q_base= 0.00012, -- коэффициент ветрового раскрутки (большой вентилятор)
	c_f     = 0.00018, -- коэффициент трения КНД
	T_tas   = 10,
	-- КВД (N2): ротор Д-30 тяжелее, выбег длиннее чем у НК-8
	n2_c_aero = 0.00025, -- меньше сопротивление (высокооборотный ротор)
	n2_c_f    = 0.008,   -- меньше трение (более совершенные подшипники)
	n2_c_q    = 0.000018,
	-- РЛЭ Ту-154М стр.8.1.8: время запуска от 0 до МГ = 35-80 с (типичное ~50 с при ISA)
	-- n2_M_rot увеличен с 0.18 до 0.32 для попадания в норматив времени запуска
	n2_M_rot  = 0.32,    -- масса ротора КВД Д-30 (откалибровано под РЛЭ 35-80 с)
	rpm_knd   = 6200/0.97, -- обороты КНД при 100% N1 (Д-30 чуть выше чем НК-8)
	-- lookup tables — откалиброваны под Д-30КУ-154
	-- c_q_tbl: ветровое раскручивание — большой вентилятор Д-30, чуть меньше отклик
	c_q_tbl  = {{-10000,0.25},{80,0.25},{360,1},{20000,1}},
	-- n1s_tbl: блокировка N1-физики — стартер Д-30 отключается на 41-44% N2
	-- двигатель самостоятельно выходит на idle после 44%, блокировка убирается с 55%
	n1s_tbl  = {{-100000,0},{0,0},{44,0},{55,1},{1000000000,1}},
	-- e2n1_tbl: поправка хвостового двигателя (S-образный канал Д-30КУ-154)
	-- хвостовой двигатель имеет более длинный воздуховод, N1 на 0.6% ниже на idle
	e2n1_tbl = {{-100000,0},{55,0.6},{80,0.6},{88,1.1},{94,0.8},{1000,0.6}},
	-- kpp3_tbl: таблица для отказа КПП на 3-м двигателе
	kpp3_tbl = {{-100000,0},{0,0},{17,17},{62,55},{69.5,74.4},{75,80},{85,85},{100,100},{1000000000,100}},
	-- [SCALE] Масштабирование симового N2 → показание прибора (%)
	-- Откалибровано: sim 60 → 62% (idle), sim 90 → 96% (взлёт)
	-- Посадочный с механизацией sim ~74 → ~80%
	-- Д-30КУ-154 по документации (МСА +15°C):
	--   N2 взлёт: 94-96%,  макс допустимый: 98%
	--   N1 взлёт: 90-92%,  макс шкалы: 95%
	-- Данные из РЛЭ Ту-154М Таблица 8.1.1 (наземные, МСА Pн=760, tн=15°C):
	--   Малый газ:            КВД 59,5-61,5%  КНД 30%
	--   0,42 номин (МГ пос.): КВД 81,0-83,5%  КНД 57,5-60,5%
	--   0,6 номин.:           КВД 85,5-88,0%  КНД 67,0-70,0%
	--   0,7 номин.:           КВД 87,5-90,0%  КНД 71,0-74,0%
	--   0,9 номин.:           КВД 91,0-92,8%  КНД 78,5-81,5%
	--   Номинальный:          КВД 93,0-95,0%  КНД 82,0-85,0%
	--   Взлётный:             КВД 94,5-96,0%  КНД 85,5-88,0%
	-- Таблица 8.1.2 (H=11км, M=0,8): Малый газ КВД 78%, КНД 63%
	-- Замер в симуляторе: sim~67 → реальный МГ ~60.5%  =>  k ≈ 60.5/67 = 0.903
	n2_display_k = 1.0, n1_display_k = 1.0, n2_max = 98.5, n1_max = 95,
	n2_scale = {
		{  0,    0   },
		{ 20,   18   },
		{ 67,   53   },  -- ниже МГ — отбросная зона
		{ 80,   60.5 },  -- малый газ земля: sim~80 → РЛЭ 59.5-61.5%
		{ 84,   65   },  -- ~0,6 номин. нижний
		{ 88,   70   },  -- между 0,6 и 0,7
		{ 91,   76   },  -- ~0,7 номин.
		{ 94,   83   },  -- ~0,9 номин.
		{ 96,   89   },  -- ~номинальный
		{ 99,   94   },  -- ~взлётный нижний
		{105,   96   },  -- взлётный верхний (РЛЭ 94,5-96,0%)
		{112,  98.5  },  -- максимум КВД по РЛЭ (98,5%)
		{200,  98.5  },
	},
	-- N1 (КНД) шкала по РЛЭ Таблица 8.1.1
	n1_scale = {
		{  0,    0   },
		{ 20,   18   },
		{ 30,   30   },  -- малый газ земля (РЛЭ точно 30%)
		{ 57,   57.5 },  -- 0,42 номин. нижний (РЛЭ 57,5-60,5%)
		{ 66,   67   },  -- 0,6 номин. нижний
		{ 73,   74   },  -- 0,7 номин. верхний
		{ 81,   82   },  -- номинальный нижний
		{ 87,   88   },  -- взлётный верхний (РЛЭ 85,5-88,0%)
		{ 95,   95   },  -- максимум КНД по РЛЭ (95%)
		{200,   95   },
	},
	-- [REALISM] инерция иглы при выключении
	ang1_slow = _n2_init_1, ang2_slow = _n2_init_2, ang3_slow = _n2_init_3,
	ang1b_slow = _n1_init_1, ang2b_slow = _n1_init_2, ang3b_slow = _n1_init_3,
	-- [REALISM] разброс показаний — у Д-30КУ-154 допуск ±1% N2, ±1% N1 по РЭ
	bias_n2_1 = (math.random()-0.5)*1.0,
	bias_n2_2 = (math.random()-0.5)*1.0,
	bias_n2_3 = (math.random()-0.5)*1.0,
	bias_n1_1 = (math.random()-0.5)*1.0,
	bias_n1_2 = (math.random()-0.5)*1.0,
	bias_n1_3 = (math.random()-0.5)*1.0,
	-- [REALISM] зависание N2 при запуске
	-- Д-30КУ-154: зависание чаще встречается на диапазоне 30-38% (тяжёлый ротор)
	hang_timer1 = 0, hang_timer2 = 0, hang_timer3 = 0,
	hang_val1 = 0,   hang_val2 = 0,   hang_val3 = 0,
	hang_active1 = false, hang_active2 = false, hang_active3 = false,
	-- [REALISM] N1-гистерезис при резком убирании газа
	n1_lag1 = _n1_init_1, n1_lag2 = _n1_init_2, n1_lag3 = _n1_init_3,
	-- [NEW-1] Приёмистость: N2 опережает N1 при резком добавлении газа
	-- n2_advance: текущее "опережение" N2 относительно N1 (затухает со временем)
	n2_adv1 = 0, n2_adv2 = 0, n2_adv3 = 0,
	-- [NEW-4] Разница инерции КНД/КВД: отслеживаем скорость изменения N2
	n2_rate1 = 0, n2_rate2 = 0, n2_rate3 = 0,
	-- [NEW-6] Помпаж клапанов: флаттер иглы при пересечении порога 79% N2
	-- surge_flutter: величина флаттера (затухает)
	surge_flutter1 = 0, surge_flutter2 = 0, surge_flutter3 = 0,
	-- отслеживаем пересечение порога 79% снизу вверх
	surge_crossed1 = false, surge_crossed2 = false, surge_crossed3 = false,
	-- [NEW bleed/crossbleed/false_start]
	bleed_drop1 = 0, bleed_drop2 = 0, bleed_drop3 = 0,
	crossbleed_drop1 = 0, crossbleed_drop2 = 0, crossbleed_drop3 = 0,
	false_start1 = false, false_start2 = false, false_start3 = false,
	false_start_n2_1 = 0, false_start_n2_2 = 0, false_start_n2_3 = 0,
	false_start_timer1 = 0, false_start_timer2 = 0, false_start_timer3 = 0,
	flame1_prev = 0, flame2_prev = 0, flame3_prev = 0,
	-- кэш показаний N2-прибора для ограничения N1
	disp_n2_1 = 0, disp_n2_2 = 0, disp_n2_3 = 0,
}

-- All tachometer datarefs in one table (counts as 1 upvalue)
local Tdr = {
	burn1  = globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[0]"),
	burn2  = globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[1]"),
	burn3  = globalPropertyf("sim/flightmodel2/engines/engine_is_burning_fuel[2]"),
	rho    = globalPropertyf("sim/weather/rho"),
	tas    = globalPropertyf("sim/flightmodel2/position/true_airspeed"),
	tempSL = globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc"),
	wdir   = globalPropertyf("sim/weather/aircraft/wind_now_direction_degt"),
	adir   = globalPropertyf("sim/flightmodel/position/mag_psi"),
	revL   = globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]"),
	revR   = globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[2]"),
	-- custom datarefs (may be nil if not present in this M variant)
	covers = globalPropertyi("sim/custom/anim/engine_caps"),
	apd1   = globalPropertyf("sim/custom/start/apd_working_1"),
	apd2   = globalPropertyf("sim/custom/start/apd_working_2"),
	apd3   = globalPropertyf("sim/custom/start/apd_working_3"),
	igv1   = globalPropertyi("sim/custom/engines/rna_1"),
	igv2   = globalPropertyi("sim/custom/engines/rna_2"),
	igv3   = globalPropertyi("sim/custom/engines/rna_3"),
	idle   = globalPropertyf("sim/custom/engines/flight_idle"),
	disa   = globalPropertyf("sim/custom/engines/d_isa_temp"),
	kpp3f  = globalPropertyf("sim/custom/failures/kpp_3_fail"),
	rot1   = globalPropertyf("sim/custom/engines/nk_rotation_1"),
	rot3   = globalPropertyf("sim/custom/engines/nk_rotation_3"),
	knd1   = globalPropertyf("sim/custom/engines/knd_1"),
	knd3   = globalPropertyf("sim/custom/engines/knd_3"),
	-- горячий старт — датарефы вынесены из функции чтобы не создавать каждый кадр
	hot1   = globalPropertyf("sim/custom/engine/hotstart_1"),
	hot2   = globalPropertyf("sim/custom/engine/hotstart_2"),
	hot3   = globalPropertyf("sim/custom/engine/hotstart_3"),
	-- bleed air: правильный путь sim/cockpit/pressure/bleed_air_mode
	bleed_air = globalPropertyf("sim/cockpit/pressure/bleed_air_mode"),
	-- ПОС двигателей: исправлена опечатка enigne→engine (оба пути работают в XP12)
	anti_ice1 = globalPropertyf("sim/cockpit/switches/anti_ice_inlet_heat_per_engine[0]"),
	anti_ice2 = globalPropertyf("sim/cockpit/switches/anti_ice_inlet_heat_per_engine[1]"),
	anti_ice3 = globalPropertyf("sim/cockpit/switches/anti_ice_inlet_heat_per_engine[2]"),
	-- crossbleed: правильный датареф XP12
	crossbleed = globalPropertyf("sim/cockpit2/fuel/fuel_crossfeed_selector"),
}

-- safe_get: returns value or fallback if dataref is nil/unavailable
local function safe_get(dr, fallback)
	if dr == nil then return fallback end
	local ok, val = pcall(get, dr)
	if ok and val ~= nil then return val end
	return fallback
end

-- safe_set: silently skips set() if dataref is nil/unavailable
local function safe_set(dr, val)
	if dr == nil then return end
	pcall(set, dr, val)
end

local function n1_from_n2(rpm, d_isa, altitude, tas)
	local knd = 1.35432317320705628561e+01 + 1.05818030992323813821e-01*d_isa - 2.41159426273638954896e-01*rpm - 2.88293089248683933462e-03*d_isa*rpm + 1.17362636037093952257e-02*math.pow(rpm, 2)
	knd = knd + math.max(-2.69166791400897068343e+02 + 2.22049699099214983278e+01*altitude + 1.46945301863934254527e+01*rpm - 9.85089687252083234803e-01*altitude*rpm - 2.96261417738032106772e-01*math.pow(rpm, 2) + 1.41929325403952685813e-02*altitude*math.pow(rpm, 2) + 2.61617340318329736140e-03*math.pow(rpm, 3) - 6.56641350639726608220e-05*altitude*math.pow(rpm, 3) - 8.54680990421439715666e-06*math.pow(rpm, 4), 0) * tas / 850
	return knd
end

local function tachometers()

	local alt_baro = get(msl_alt)
	if alt_baro > 12000 then alt_baro = 12000 end

if MASTER then
	if T.start_timer < 60 then T.start_timer = T.start_timer + passed end

	local flame1 = get(Tdr.burn1)
	local flame2 = get(Tdr.burn2)
	local flame3 = get(Tdr.burn3)

	local rpm_1 = get(eng1_N2)
	local rpm_2 = get(eng2_N2)
	local rpm_3 = get(eng3_N2)

	local idle_rpm = safe_get(Tdr.idle, 68)
	if idle_rpm < 1 then idle_rpm = 68 end
	local dens  = get(Tdr.rho)
	local temp  = get(Tdr.tempSL)
	-- [Д-30КУ-154] ВНА управляется по приведённым оборотам КВД через ДПО-30К
	-- Открывается при N2=74.5%, полностью открыт при N2=92.5% — не зависит от температуры
	local rna_thres = 74.5  -- порог открытия ВНА по N2 (Д-30КУ-154, РЭ)
	T.tme    = T.tme + passed
	T.tas_LP = passed / (T.T_tas + passed) * get(Tdr.tas) * 3.6 + T.tas_LP * T.T_tas / (T.T_tas + passed)
	local d_isa = safe_get(Tdr.disa, 0)
	T.q = dens * math.pow((T.tas_LP / 3.6), 2) / 2

	-- [температурные поправки удалены по запросу — двигатели работают без зависимости от t н.в.]

	-- N2 windmilling / runout
	if flame1 > 0 or safe_get(Tdr.apd1, 0) > 0 then
		T.n2run1 = rpm_1
	else
		T.n2run1 = math.max(T.n2run1 + (-T.n2_c_aero*dens*math.pow(T.n2run1,2) + T.n2_c_q*T.q - T.n2_c_f) / T.n2_M_rot * passed, 0)
		rpm_1 = T.n2run1;  set(eng1_N2, T.n2run1)
	end
	if flame2 > 0 or safe_get(Tdr.apd2, 0) > 0 then
		T.n2run2 = rpm_2
	else
		T.n2run2 = math.max(T.n2run2 + (-T.n2_c_aero*dens*math.pow(T.n2run2,2) + T.n2_c_q*T.q - T.n2_c_f) / T.n2_M_rot * passed, 0)
		rpm_2 = T.n2run2;  set(eng2_N2, T.n2run2)
	end
	if flame3 > 0 or safe_get(Tdr.apd3, 0) > 0 then
		T.n2run3 = rpm_3
	else
		T.n2run3 = math.max(T.n2run3 + (-T.n2_c_aero*dens*math.pow(T.n2run3,2) + T.n2_c_q*T.q - T.n2_c_f) / T.n2_M_rot * passed, 0)
		rpm_3 = T.n2run3;  set(eng3_N2, T.n2run3)
	end

	-- [2] Горячий старт — если двигатель недавно остановили, N2 раскручивается медленнее
	-- hot_factor: 1.0 = холодный, 0.6 = горячий (остаточное тепло тормозит раскрутку)
	local hot1 = math.max(0.6, 1.0 - safe_get(Tdr.hot1, 0) * 0.4)
	local hot2 = math.max(0.6, 1.0 - safe_get(Tdr.hot2, 0) * 0.4)
	local hot3 = math.max(0.6, 1.0 - safe_get(Tdr.hot3, 0) * 0.4)

	-- [NEW-1b] Отбор воздуха — bleed air проседание N2
	local bleed_on     = safe_get(Tdr.bleed_air, 0) > 0
	local anti_ice1_on = safe_get(Tdr.anti_ice1, 0) > 0
	local anti_ice2_on = safe_get(Tdr.anti_ice2, 0) > 0
	local anti_ice3_on = safe_get(Tdr.anti_ice3, 0) > 0
	local bleed_load1 = bool2int(flame1>0) * (bool2int(bleed_on)*0.6 + bool2int(anti_ice1_on)*0.5)
	local bleed_load2 = bool2int(flame2>0) * (bool2int(bleed_on)*0.6 + bool2int(anti_ice2_on)*0.5)
	local bleed_load3 = bool2int(flame3>0) * (bool2int(bleed_on)*0.6 + bool2int(anti_ice3_on)*0.5)
	T.bleed_drop1 = T.bleed_drop1 + (bleed_load1 - T.bleed_drop1) * passed * 0.5
	T.bleed_drop2 = T.bleed_drop2 + (bleed_load2 - T.bleed_drop2) * passed * 0.5
	T.bleed_drop3 = T.bleed_drop3 + (bleed_load3 - T.bleed_drop3) * passed * 0.5

	-- [NEW-4b] Crossbleed — проседание N2 донора при открытом кране
	local xbleed = safe_get(Tdr.crossbleed, 0) > 0
	local xbleed_load1 = bool2int(xbleed and flame1>0 and
		(flame2==0 and safe_get(Tdr.apd2,0)>0 or flame3==0 and safe_get(Tdr.apd3,0)>0)) * 0.8
	local xbleed_load2 = bool2int(xbleed and flame2>0 and flame3==0 and safe_get(Tdr.apd3,0)>0) * 0.8
	T.crossbleed_drop1 = T.crossbleed_drop1 + (xbleed_load1 - T.crossbleed_drop1) * passed * 0.8
	T.crossbleed_drop2 = T.crossbleed_drop2 + (xbleed_load2 - T.crossbleed_drop2) * passed * 0.8
	if flame1>0 then rpm_1 = math.max(0, rpm_1 - T.bleed_drop1 - T.crossbleed_drop1) end
	if flame2>0 then rpm_2 = math.max(0, rpm_2 - T.bleed_drop2 - T.crossbleed_drop2) end
	if flame3>0 then rpm_3 = math.max(0, rpm_3 - T.bleed_drop3) end

	-- [NEW-7] Ложный запуск — 12% шанс при зажигании
	-- N2 растёт несколько секунд затем падает (топливо не воспламенилось)
	for i = 1, 3 do
		local fl    = i==1 and flame1    or (i==2 and flame2    or flame3)
		local fl_pr = i==1 and T.flame1_prev or (i==2 and T.flame2_prev or T.flame3_prev)
		local fs    = i==1 and T.false_start1 or (i==2 and T.false_start2 or T.false_start3)
		local fs_n2 = i==1 and T.false_start_n2_1 or (i==2 and T.false_start_n2_2 or T.false_start_n2_3)
		local fs_t  = i==1 and T.false_start_timer1 or (i==2 and T.false_start_timer2 or T.false_start_timer3)
		local rpm_i = i==1 and rpm_1 or (i==2 and rpm_2 or rpm_3)
		if fl > 0 and fl_pr == 0 and not fs then
			if math.random() < 0.12 then
				fs = true; fs_n2 = rpm_i; fs_t = 4 + math.random() * 4
			end
		end
		if fs then
			fs_t = fs_t - passed
			if fs_t <= 0 or fl == 0 then
				fs = false
			else
				local fake_n2 = fs_n2 + (1 - math.exp(-fs_t * 0.3)) * 8
				if i==1 then rpm_1 = math.min(rpm_1, fake_n2)
				elseif i==2 then rpm_2 = math.min(rpm_2, fake_n2)
				else rpm_3 = math.min(rpm_3, fake_n2) end
			end
		end
		if i==1 then T.false_start1=fs; T.false_start_n2_1=fs_n2; T.false_start_timer1=fs_t; T.flame1_prev=fl
		elseif i==2 then T.false_start2=fs; T.false_start_n2_2=fs_n2; T.false_start_timer2=fs_t; T.flame2_prev=fl
		else T.false_start3=fs; T.false_start_n2_3=fs_n2; T.false_start_timer3=fs_t; T.flame3_prev=fl end
	end

	-- [3] Зависание N2 при запуске
	for i = 1, 3 do
		local rpm_i   = i==1 and rpm_1   or (i==2 and rpm_2   or rpm_3)
		local flame_i = i==1 and flame1  or (i==2 and flame2  or flame3)
		local hang_active = i==1 and T.hang_active1 or (i==2 and T.hang_active2 or T.hang_active3)
		local hang_val    = i==1 and T.hang_val1    or (i==2 and T.hang_val2    or T.hang_val3)
		local hang_timer  = i==1 and T.hang_timer1  or (i==2 and T.hang_timer2  or T.hang_timer3)

		-- [3] Зависание N2 при запуске — Д-30КУ-154
		-- Тяжёлый ротор КВД, зависание на 30-36%, шанс ~10% (реже чем у НК-8)
		-- Стартер отключается на 41-44%, после этого зависание уже не возникает
		if flame_i > 0 and not hang_active and rpm_i > 28 and rpm_i < 38 then
			if math.random() < 0.0002 then  -- ~10% шанс при прохождении диапазона
				hang_active = true
				hang_val    = 30 + math.random() * 6  -- зависание на 30-36%
				hang_timer  = 4 + math.random() * 6   -- на 4-10 секунд
			end
		end
		if hang_active then
			hang_timer = hang_timer - passed
			if hang_timer <= 0 or flame_i == 0 then
				hang_active = false
			end
		end
		if i==1 then T.hang_active1=hang_active; T.hang_val1=hang_val; T.hang_timer1=hang_timer
		elseif i==2 then T.hang_active2=hang_active; T.hang_val2=hang_val; T.hang_timer2=hang_timer
		else T.hang_active3=hang_active; T.hang_val3=hang_val; T.hang_timer3=hang_timer end
	end
	-- применяем зависание к N2
	if T.hang_active1 and rpm_1 < T.hang_val1 + 2 then rpm_1 = math.min(rpm_1, T.hang_val1) end
	if T.hang_active2 and rpm_2 < T.hang_val2 + 2 then rpm_2 = math.min(rpm_2, T.hang_val2) end
	if T.hang_active3 and rpm_3 < T.hang_val3 + 2 then rpm_3 = math.min(rpm_3, T.hang_val3) end

	-- вспомогательные функции скорости игл
	-- Д-30КУ-154: земной малый газ ~62% N2, полётный ~72% — медленная раскрутка до 72%
	local function n2_spd(need, delta)
		if delta <= 0 or need <= 20 or need >= 72 then return 10 end
		return 2 + (need - 20) / 52 * 8
	end
	local function n1_spd(need, delta)
		if delta <= 0 or need <= 20 or need >= 72 then return 20 end
		return 4 + (need - 20) / 52 * 16
	end

	-- [4] Инерция иглы при выключении — сглаженное N2 тормозит иглу в начале падения
	-- При убывающем N2 игла следует за сглаженным (медленным) значением
	T.ang1_slow  = T.ang1_slow  + (rpm_1 - T.ang1_slow)  * passed * (rpm_1 > T.ang1_slow  and 8 or 1.5)
	T.ang2_slow  = T.ang2_slow  + (rpm_2 - T.ang2_slow)  * passed * (rpm_2 > T.ang2_slow  and 8 or 1.5)
	T.ang3_slow  = T.ang3_slow  + (rpm_3 - T.ang3_slow)  * passed * (rpm_3 > T.ang3_slow  and 8 or 1.5)

	-- N2 gauge needles
	local target1 = rpm_1 < T.rpm1_last and T.ang1_slow or rpm_1
	local target2 = rpm_2 < T.rpm2_last and T.ang2_slow or rpm_2
	local target3 = rpm_3 < T.rpm3_last and T.ang3_slow or rpm_3

	T.N1need1 = target1
	if ((rpm_1 - T.rpm1_last) > 0 and T.N1need1 < 3.5) or T.N1need1 < 0.3 then
		T.ang1 = T.ang1 - T.ang1 * passed
	elseif (rpm_1 - T.rpm1_last) > 0 and T.N1need1 >= 3.5 and T.N1need1 < 5 then
		T.ang1 = T.ang1 + ((10*math.exp(-(T.N1need1-3.5)*5)*math.sin(10*(T.N1need1-3.5)) + T.N1need1) - T.ang1) * passed * 5
	else
		T.ang1 = T.ang1 + (T.N1need1 + (-0.145*math.pow(T.N1need1,2)+2.425*T.N1need1-8.313)*0.2*math.sin(20*T.tme)*bool2int(T.N1need1>5 and T.N1need1<12) - T.ang1) * passed * n2_spd(T.N1need1, rpm_1-T.rpm1_last) * hot1

	end
	-- [5] Разброс показаний + [7] дрожание на малом газу
	-- idle_jitter уменьшен: реальный Д-30КУ-154 на малом газу колеблется не более ±0.5% по РЭ
	-- [NEW-1+6] добавляем опережение приёмистости и флаттер клапанов к показанию N2
	local surge1_osc = T.surge_flutter1 * math.sin(T.tme * 28) * 0.5
	local idle_jitter1 = bool2int(flame1>0 and math.abs(rpm_1 - idle_rpm) < 3) * (math.random()-0.5) * 0.15
	local disp_n2_1 = math.min(T.n2_max, interpolate(T.n2_scale, T.ang1 + T.n2_adv1 + surge1_osc))
	T.disp_n2_1 = disp_n2_1
	set(rpm_high_1, disp_n2_1 + T.bias_n2_1 * bool2int(T.ang1 > 5) + idle_jitter1)

	T.N1need2 = target2
	if ((rpm_2 - T.rpm2_last) > 0 and T.N1need2 < 3.5) or T.N1need2 < 0.9 then
		T.ang2 = T.ang2 - T.ang2 * passed * 2
	elseif (rpm_2 - T.rpm2_last) > 0 and T.N1need2 >= 3.5 and T.N1need2 < 5 then
		T.ang2 = T.ang2 + ((10*math.exp(-(T.N1need2-3.5)*5)*math.sin(10*(T.N1need2-3.5)) + T.N1need2) - T.ang2) * passed * 5
	else
		T.ang2 = T.ang2 + (T.N1need2 + (-0.145*math.pow(T.N1need2,2)+2.425*T.N1need2-8.313)*0.17*math.sin(20*T.tme+1.5)*bool2int(T.N1need2>5 and T.N1need2<12) - T.ang2) * passed * n2_spd(T.N1need2, rpm_2-T.rpm2_last) * hot2
	end
	local surge2_osc = T.surge_flutter2 * math.sin(T.tme * 26) * 0.5
	local idle_jitter2 = bool2int(flame2>0 and math.abs(rpm_2 - idle_rpm) < 3) * (math.random()-0.5) * 0.15
	local disp_n2_2 = math.min(T.n2_max, interpolate(T.n2_scale, T.ang2 + T.n2_adv2 + surge2_osc))
	T.disp_n2_2 = disp_n2_2
	set(rpm_high_2, disp_n2_2 + T.bias_n2_2 * bool2int(T.ang2 > 5) + idle_jitter2)

	T.N1need3 = target3
	if safe_get(Tdr.kpp3f, 0) > 0 then T.N1need3 = interpolate(T.kpp3_tbl, rpm_3) end
	if ((rpm_3 - T.rpm3_last) > 0 and T.N1need3 < 3.5) or T.N1need3 < 0.3 then
		T.ang3 = T.ang3 - T.ang3 * passed
	elseif (rpm_3 - T.rpm3_last) > 0 and T.N1need3 >= 3.5 and T.N1need3 < 5 then
		T.ang3 = T.ang3 + ((10*math.exp(-(T.N1need3-3.5)*5)*math.sin(10*(T.N1need3-3.5)) + T.N1need3) - T.ang3) * passed * 5
	else
		T.ang3 = T.ang3 + (T.N1need3 + (-0.145*math.pow(T.N1need3,2)+2.425*T.N1need3-8.313)*0.21*math.sin(19*T.tme)*bool2int(T.N1need3>5 and T.N1need3<12) - T.ang3) * passed * n2_spd(T.N1need3, rpm_3-T.rpm3_last) * hot3
	end
	local surge3_osc = T.surge_flutter3 * math.sin(T.tme * 27) * 0.5
	local idle_jitter3 = bool2int(flame3>0 and math.abs(rpm_3 - idle_rpm) < 3) * (math.random()-0.5) * 0.15
	local disp_n2_3 = math.min(T.n2_max, interpolate(T.n2_scale, T.ang3 + T.n2_adv3 + surge3_osc))
	T.disp_n2_3 = disp_n2_3
	set(rpm_high_3, disp_n2_3 + T.bias_n2_3 * bool2int(T.ang3 > 5) + idle_jitter3)

	-- [NEW-4] Скорость изменения N2 — КВД реагирует быстрее КНД
	-- Вычисляем ДО обновления rpm_last чтобы получить правильную дельту
	local n2_rate_tau = 0.3
	local n2_delta1 = passed > 0 and (rpm_1 - T.rpm1_last) / passed or 0
	local n2_delta2 = passed > 0 and (rpm_2 - T.rpm2_last) / passed or 0
	local n2_delta3 = passed > 0 and (rpm_3 - T.rpm3_last) / passed or 0
	T.n2_rate1 = T.n2_rate1 + (n2_delta1 - T.n2_rate1) * passed / n2_rate_tau
	T.n2_rate2 = T.n2_rate2 + (n2_delta2 - T.n2_rate2) * passed / n2_rate_tau
	T.n2_rate3 = T.n2_rate3 + (n2_delta3 - T.n2_rate3) * passed / n2_rate_tau

	if passed ~= 0 then
		T.rpm1_last = rpm_1;  T.rpm2_last = rpm_2;  T.rpm3_last = rpm_3
	end
	-- КВД инерция: при ускорении эффективная масса ротора N2 меньше (КВД быстрее КНД)
	-- При n2_rate > 0 (ускорение) — N2 реагирует в 1.4x быстрее КНД
	-- При n2_rate < 0 (замедление) — симметрично
	local n2_inertia_corr1 = 1.0 - math.max(0, T.n2_rate1) * 0.003
	local n2_inertia_corr2 = 1.0 - math.max(0, T.n2_rate2) * 0.003
	local n2_inertia_corr3 = 1.0 - math.max(0, T.n2_rate3) * 0.003
	n2_inertia_corr1 = math.max(0.6, math.min(1.0, n2_inertia_corr1))
	n2_inertia_corr2 = math.max(0.6, math.min(1.0, n2_inertia_corr2))
	n2_inertia_corr3 = math.max(0.6, math.min(1.0, n2_inertia_corr3))

	-- [NEW-1] Приёмистость: N2 опережает N1 при резком добавлении газа
	-- При быстром росте N2 (>5%/сек) N1 запаздывает — опережение нарастает и затухает
	local accel_thresh = 5.0  -- порог ускорения N2 (%/сек) для появления опережения
	local adv_rise  = 0.4   -- скорость нарастания опережения
	local adv_decay = 0.8   -- скорость затухания опережения
	if T.n2_rate1 > accel_thresh then
		T.n2_adv1 = math.min(T.n2_adv1 + (T.n2_rate1 - accel_thresh) * adv_rise * passed, 4.0)
	else
		T.n2_adv1 = math.max(0, T.n2_adv1 - adv_decay * passed)
	end
	if T.n2_rate2 > accel_thresh then
		T.n2_adv2 = math.min(T.n2_adv2 + (T.n2_rate2 - accel_thresh) * adv_rise * passed, 4.0)
	else
		T.n2_adv2 = math.max(0, T.n2_adv2 - adv_decay * passed)
	end
	if T.n2_rate3 > accel_thresh then
		T.n2_adv3 = math.min(T.n2_adv3 + (T.n2_rate3 - accel_thresh) * adv_rise * passed, 4.0)
	else
		T.n2_adv3 = math.max(0, T.n2_adv3 - adv_decay * passed)
	end

	-- [NEW-6] Флаттер иглы N2 при закрытии антипомпажных клапанов (порог 79% N2)
	-- Д-30КУ-154: клапаны закрываются пружинами при N2 > 79% — небольшой гидравлический удар
	local surge_thr = 79.0
	-- двигатель 1
	if not T.surge_crossed1 and rpm_1 > surge_thr and T.rpm1_last <= surge_thr and flame1 > 0 then
		T.surge_flutter1 = 1.8  -- начальная амплитуда флаттера (%)
		T.surge_crossed1 = true
	elseif rpm_1 < surge_thr - 2 then
		T.surge_crossed1 = false  -- сброс при падении ниже порога
	end
	T.surge_flutter1 = T.surge_flutter1 * math.max(0, 1 - passed * 3.5)  -- затухание ~0.3 сек
	-- двигатель 2
	if not T.surge_crossed2 and rpm_2 > surge_thr and T.rpm2_last <= surge_thr and flame2 > 0 then
		T.surge_flutter2 = 1.8
		T.surge_crossed2 = true
	elseif rpm_2 < surge_thr - 2 then
		T.surge_crossed2 = false
	end
	T.surge_flutter2 = T.surge_flutter2 * math.max(0, 1 - passed * 3.5)
	-- двигатель 3
	if not T.surge_crossed3 and rpm_3 > surge_thr and T.rpm3_last <= surge_thr and flame3 > 0 then
		T.surge_flutter3 = 1.8
		T.surge_crossed3 = true
	elseif rpm_3 < surge_thr - 2 then
		T.surge_crossed3 = false
	end
	T.surge_flutter3 = T.surge_flutter3 * math.max(0, 1 - passed * 3.5)
	local c_q = T.c_q_base * interpolate(T.c_q_tbl, T.tas_LP)
	local li1 = n1_from_n2(idle_rpm, d_isa, alt_baro/1000, T.tas_LP) - T.rna1
	local li2 = n1_from_n2(idle_rpm, d_isa, alt_baro/1000, T.tas_LP) - T.rna2 - interpolate(T.e2n1_tbl, idle_rpm)
	local li3 = n1_from_n2(idle_rpm, d_isa, alt_baro/1000, T.tas_LP) - T.rna3
	T.cturb1 = T.c_aero*dens*math.pow(li1,2)/math.pow(idle_rpm,2) - c_q*T.q/math.pow(idle_rpm,2)
	T.cturb2 = T.c_aero*dens*math.pow(li2,2)/math.pow(idle_rpm,2) - c_q*T.q/math.pow(idle_rpm,2)
	T.cturb3 = T.c_aero*dens*math.pow(li3,2)/math.pow(idle_rpm,2) - c_q*T.q/math.pow(idle_rpm,2)

	local wa = math.min(get(Tdr.wdir) - get(Tdr.adir), 360 - get(Tdr.wdir) + get(Tdr.adir))
	if T.tas_LP > 80 then wa = 0 end
	local revL  = safe_get(Tdr.revL, 0)
	local revR  = safe_get(Tdr.revR, 0)
	local cov   = safe_get(Tdr.covers, 0)
	local coswa = math.cos(wa / 180 * 3.14) * (1 - cov)
	local q1 = T.q * coswa * (1 - 0.5*revL)
	local q2 = T.q * coswa
	local q3 = T.q * coswa * (1 - 0.5*revR)
	if math.abs(wa) > 90 then q1=q1/2*(1-revL); q3=q3/2*(1-revR) end

	-- [6] Влияние высоты на N1 — поправочный коэффициент выше тропопаузы (~11000м)
	local alt_n1_corr = 1.0
	if alt_baro > 9000 then
		alt_n1_corr = 1.0 + (alt_baro - 9000) / 3000 * 0.04  -- +4% к N1 к 12000м
	end

	-- N1 engine 1
	T.N2need1_old = n1_from_n2(T.ang1, d_isa, alt_baro/1000, T.tas_LP) - T.rna1
	T.N2need1_old = T.N2need1_old * interpolate(T.n1s_tbl, T.ang1) * alt_n1_corr
	if T.N2need1 > rna_thres and T.rna1 > 0 then
		T.rna1 = T.rna1 - T.rna1*passed*(1-0.8*math.max(math.max(T.rna1,4)-4,0)/2)/2
		if T.rna1<0 then T.rna1=0 end
	elseif T.N2need1 < rna_thres and T.rna1 < 6 then
		T.rna1 = T.rna1 + (6-T.rna1)*passed*(1-0.8*(1-math.min(math.min(T.rna1,2),2)/2))/2
		if T.rna1>6 then T.rna1=6 end
	end
	local aN1
	if T.N2need1 >= 0 then
		aN1 = T.cturb1*math.pow(T.ang1,2)*(0.2+0.8*flame1) - T.c_aero*dens*math.pow(T.N2need1,2) + c_q*q1 - T.c_f*math.min(T.N2need1/0.001,1)
	else
		aN1 = T.cturb1*math.pow(T.ang1,2)*(0.2+0.8*flame1) + T.c_aero*dens*math.pow(T.N2need1,2) + c_q*q1 - T.c_f*math.max(T.N2need1/0.001,-1)
	end
	if T.start_timer > 3 then T.N2need1 = T.N2need1 + aN1/(T.M_rot * n2_inertia_corr1)*passed * hot1 end
	if math.abs(T.N2need1) < T.N2need1_old*flame1 then T.N2need1 = T.N2need1_old*flame1 end
	-- [4] инерция иглы N1 при снижении + [8] гистерезис при резком убирании газа
	T.ang1b_slow = T.ang1b_slow + (T.N2need1 - T.ang1b_slow) * passed * (T.N2need1 > T.ang1b_slow and 6 or 2)
	local n1_target1 = T.N2need1 < T.N2need1_prev and T.ang1b_slow or T.N2need1
	-- [8] лаг при резком убирании газа
	local drop1 = T.N2need1_prev - T.N2need1
	if drop1 > 5 then  -- резкое снижение > 5% за фрейм
		T.n1_lag1 = T.n1_lag1 + (T.N2need1 - T.n1_lag1) * passed * 1.5
		n1_target1 = T.n1_lag1
	else
		T.n1_lag1 = T.N2need1
	end
	if ((T.N2need1-T.N2need1_prev)>0 and T.N2need1<2) or T.N2need1<1 then
		T.ang1b = T.ang1b - T.ang1b*passed*2
	elseif (T.N2need1-T.N2need1_prev)>0 and T.N2need1>=2 and T.N2need1<3 then
		T.ang1b = T.ang1b + ((2*math.exp(-(T.N2need1-2)*5)*math.sin(10*(T.N2need1-2))+T.N2need1)-T.ang1b)*passed*5
		T.nmove1=1
	else
		T.ang1b = T.ang1b + (n1_target1+(-0.04167*math.pow(n1_target1,2)+0.5417*n1_target1-1.5)*0.57*math.sin(20*T.tme+2)*bool2int(n1_target1>3 and n1_target1<9)-T.ang1b)*passed*n1_spd(T.N2need1,T.N2need1-T.N2need1_prev)*T.nmove1
	end
	if T.N2need1>20 then T.nmove1=1 elseif T.ang1b<0.4 then T.nmove1=0 end
	local idle_jitter1b = bool2int(flame1>0 and math.abs(T.N2need1 - li1) < 2) * (math.random()-0.5) * 0.12
	local disp_n1_1 = math.min(T.n1_max, interpolate(T.n1_scale, T.ang1b))
	-- N1-прибор не может превышать N2-прибор (физика Д-30КУ-154: N1 всегда < N2)
	disp_n1_1 = math.min(disp_n1_1, T.disp_n2_1 * 0.97)
	set(rpm_low_1, disp_n1_1 + T.bias_n1_1 * bool2int(T.ang1b > 5) + idle_jitter1b)

	-- N1 engine 2
	T.N2need2_old = n1_from_n2(T.ang2, d_isa, alt_baro/1000, T.tas_LP) - T.rna2 - interpolate(T.e2n1_tbl, T.ang2)
	T.N2need2_old = T.N2need2_old * interpolate(T.n1s_tbl, T.ang2) * alt_n1_corr
	if T.N2need2 > rna_thres+0.5 and T.rna2 > 0 then
		T.rna2 = T.rna2 - T.rna2*passed*(1-0.8*math.max(math.max(T.rna2,4)-4,0)/2)/2
		if T.rna2<0 then T.rna2=0 end
	elseif T.N2need2 < rna_thres+0.25 and T.rna2 < 6 then
		T.rna2 = T.rna2 + (6-T.rna2)*passed*(1-0.8*(1-math.min(math.min(T.rna2,2),2)/2))/2
		if T.rna2>6 then T.rna2=6 end
	end
	aN1 = T.cturb2*math.pow(T.ang2,2)*(0.2+0.8*flame2) - T.c_aero*dens*math.pow(T.N2need2,2) + c_q*q2 - T.c_f
	T.N2need2 = math.max(T.N2need2_old*flame2, T.N2need2 + aN1/(T.M_rot * n2_inertia_corr2)*passed * hot2)
	T.ang2b_slow = T.ang2b_slow + (T.N2need2 - T.ang2b_slow) * passed * (T.N2need2 > T.ang2b_slow and 6 or 2)
	local n1_target2 = T.N2need2 < T.N2need2_prev and T.ang2b_slow or T.N2need2
	local drop2 = T.N2need2_prev - T.N2need2
	if drop2 > 5 then
		T.n1_lag2 = T.n1_lag2 + (T.N2need2 - T.n1_lag2) * passed * 1.5
		n1_target2 = T.n1_lag2
	else
		T.n1_lag2 = T.N2need2
	end
	if ((T.N2need2-T.N2need2_prev)>0 and T.N2need2<2) or T.N2need2<1 then
		T.ang2b = T.ang2b - T.ang2b*passed*2
	elseif (T.N2need2-T.N2need2_prev)>0 and T.N2need2>=2 and T.N2need2<3 then
		T.ang2b = T.ang2b + ((2*math.exp(-(T.N2need2-2)*5)*math.sin(10*(T.N2need2-2))+T.N2need2)-T.ang2b)*passed*5
		T.nmove2=1
	else
		T.ang2b = T.ang2b + (n1_target2+(-0.04167*math.pow(n1_target2,2)+0.5417*n1_target2-1.5)*0.66*math.sin(20*T.tme+3)*bool2int(n1_target2>3 and n1_target2<9)-T.ang2b)*passed*n1_spd(T.N2need2,T.N2need2-T.N2need2_prev)*T.nmove2
	end
	if T.N2need2>20 then T.nmove2=1 elseif T.ang2b<0.4 then T.nmove2=0 end
	local idle_jitter2b = bool2int(flame2>0 and math.abs(T.N2need2 - li2) < 2) * (math.random()-0.5) * 0.12
	local disp_n1_2 = math.min(T.n1_max, interpolate(T.n1_scale, T.ang2b))
	disp_n1_2 = math.min(disp_n1_2, T.disp_n2_2 * 0.97)
	set(rpm_low_2, disp_n1_2 + T.bias_n1_2 * bool2int(T.ang2b > 5) + idle_jitter2b)

	-- N1 engine 3
	T.N2need3_old = n1_from_n2(T.ang3, d_isa, alt_baro/1000, T.tas_LP) - T.rna3
	T.N2need3_old = T.N2need3_old * interpolate(T.n1s_tbl, T.ang3) * alt_n1_corr
	if T.N2need3 > rna_thres-0.5 and T.rna3 > 0 then
		T.rna3 = T.rna3 - T.rna3*passed*(1-0.8*math.max(math.max(T.rna3,4)-4,0)/2)/2
		if T.rna3<0 then T.rna3=0 end
	elseif T.N2need3 < rna_thres+0.5 and T.rna3 < 6 then
		T.rna3 = T.rna3 + (6-T.rna3)*passed*(1-0.8*(1-math.min(math.min(T.rna3,2),2)/2))/2
		if T.rna3>6 then T.rna3=6 end
	end
	if T.N2need3 >= 0 then
		aN1 = T.cturb3*math.pow(T.ang3,2)*(0.2+0.8*flame3) - T.c_aero*dens*math.pow(T.N2need3,2) + c_q*q3 - T.c_f*math.min(T.N2need3/0.001,1)
	else
		aN1 = T.cturb3*math.pow(T.ang3,2)*(0.2+0.8*flame3) + T.c_aero*dens*math.pow(T.N2need3,2) + c_q*q3 - T.c_f*math.max(T.N2need3/0.001,-1)
	end
	if T.start_timer > 3 then T.N2need3 = T.N2need3 + aN1/(T.M_rot * n2_inertia_corr3)*passed * hot3 end
	if math.abs(T.N2need3) < T.N2need3_old*flame3 then T.N2need3 = T.N2need3_old*flame3 end
	T.ang3b_slow = T.ang3b_slow + (T.N2need3 - T.ang3b_slow) * passed * (T.N2need3 > T.ang3b_slow and 6 or 2)
	local n1_target3 = T.N2need3 < T.N2need3_prev and T.ang3b_slow or T.N2need3
	local drop3 = T.N2need3_prev - T.N2need3
	if drop3 > 5 then
		T.n1_lag3 = T.n1_lag3 + (T.N2need3 - T.n1_lag3) * passed * 1.5
		n1_target3 = T.n1_lag3
	else
		T.n1_lag3 = T.N2need3
	end
	if ((T.N2need3-T.N2need3_prev)>0 and T.N2need3<2) or T.N2need3<1.1 then
		T.ang3b = T.ang3b - T.ang3b*passed
	elseif (T.N2need3-T.N2need3_prev)>0 and T.N2need3>=2 and T.N2need3<3 then
		T.ang3b = T.ang3b + ((2*math.exp(-(T.N2need3-2)*5)*math.sin(10*(T.N2need3-2))+T.N2need3)-T.ang3b)*passed*5
		T.nmove3=1
	else
		T.ang3b = T.ang3b + (n1_target3+(-0.04167*math.pow(n1_target3,2)+0.5417*n1_target3-1.5)*0.45*math.sin(20*T.tme+1)*bool2int(n1_target3>3 and n1_target3<9)-T.ang3b)*passed*n1_spd(T.N2need3,T.N2need3-T.N2need3_prev)*T.nmove3
	end
	if T.N2need3>20 then T.nmove3=1 elseif T.ang3b<0.4 then T.nmove3=0 end
	local idle_jitter3b = bool2int(flame3>0 and math.abs(T.N2need3 - li3) < 2) * (math.random()-0.5) * 0.12
	local disp_n1_3 = math.min(T.n1_max, interpolate(T.n1_scale, T.ang3b))
	disp_n1_3 = math.min(disp_n1_3, T.disp_n2_3 * 0.97)
	set(rpm_low_3, disp_n1_3 + T.bias_n1_3 * bool2int(T.ang3b > 5) + idle_jitter3b)

	-- fan animation
	if T.N2need1 < 2 then T.fan1 = T.fan1 + T.N2need1/100*T.rpm_knd/60*360*passed end
	if T.fan1 >= 360 then T.fan1 = T.fan1 - 360 end
	if T.N2need3 < 2 then T.fan3 = T.fan3 + T.N2need3/100*T.rpm_knd/60*360*passed end
	if T.fan3 >= 360 then T.fan3 = T.fan3 - 360 end

	T.N2need1_prev = T.N2need1;  T.N2need2_prev = T.N2need2;  T.N2need3_prev = T.N2need3

	safe_set(Tdr.igv1, bool2int(T.rna1 > 5))
	safe_set(Tdr.igv2, bool2int(T.rna2 > 5))
	safe_set(Tdr.igv3, bool2int(T.rna3 > 5))
	safe_set(Tdr.rot1, T.fan1)
	safe_set(Tdr.rot3, T.fan3)
	safe_set(Tdr.knd1, T.N2need1)
	safe_set(Tdr.knd3, T.N2need3)

end

end



------------------------
-- fake gauges --
------------------------

local oil_qty_act_1 = 4
local oil_qty_act_2 = 4
local oil_qty_act_3 = 4




local function oil_qty_gau()
	
	local oil_now_1 = get(engn_oil_qty_1)
	local oil_now_2 = get(engn_oil_qty_2)
	local oil_now_3 = get(engn_oil_qty_3)
	
	
	local qty_1 = 4
	local qty_2 = 4
	local qty_3 = 4
	
	if power_36_L and power_36_R then
		qty_1 = oil_now_1 - T.rpm1_last * 0.05
		qty_2 = oil_now_2 - T.rpm2_last * 0.05
		qty_3 = oil_now_3 - T.rpm3_last * 0.05
	else
		qty_1 = 4
		qty_2 = 4
		qty_3 = 4
	end
	
	if get(gauges_on_1) == 0 then qty_1 = 4 end
	if get(gauges_on_2) == 0 then qty_2 = 4 end
	if get(gauges_on_3) == 0 then qty_3 = 4 end
	
	
	oil_qty_act_1 = oil_qty_act_1 + (qty_1 - oil_qty_act_1) * passed
	oil_qty_act_2 = oil_qty_act_2 + (qty_2 - oil_qty_act_2) * passed
	oil_qty_act_3 = oil_qty_act_3 + (qty_3 - oil_qty_act_3) * passed
	
	
	set(oil_qty_1, math.max(4, oil_qty_act_1))
	set(oil_qty_2, math.max(4, oil_qty_act_2))
	set(oil_qty_3, math.max(4, oil_qty_act_3))
	


end


local fuel_temp_act_1 = 0
local fuel_temp_act_2 = 0

local function fuel_temp_gau()

	local air_temp = get(thermo)
	
	if power_27_R then 
		fuel_temp_act_1 = fuel_temp_act_1 + (air_temp - fuel_temp_act_1) * passed
		fuel_temp_act_2 = fuel_temp_act_2 + (air_temp - fuel_temp_act_2) * passed
	else
		fuel_temp_act_1 = fuel_temp_act_1 + (0 - fuel_temp_act_1) * passed
		fuel_temp_act_2 = fuel_temp_act_2 + (0 - fuel_temp_act_2) * passed
	
	end

	if fuel_temp_act_1 > 65 then fuel_temp_act_1 = 65
	elseif fuel_temp_act_1 < -65 then fuel_temp_act_1 = -65 end
	
	if fuel_temp_act_2 > 65 then fuel_temp_act_2 = 65
	elseif fuel_temp_act_2 < -65 then fuel_temp_act_2 = -65 end

	set(fuel_temp_1, fuel_temp_act_1)
	set(fuel_temp_2, fuel_temp_act_2)


end




function update()
	-- FIX: frame_time с fallback на стандартный датареф
	passed = get_passed()
	
	MASTER = get(ismaster) ~= 1	
	
	
	power_27_L = get(bus27_volt_left) > 13
	power_27_R = get(bus27_volt_right) > 13
	power_115 = get(bus115_1_volt) > 110
	power_36_L = get(bus36_volt_left) > 30
	power_36_R = get(bus36_volt_right) > 30
	
	gau_1_on = get(gauges_on_1)
	gau_2_on = get(gauges_on_2) 
	gau_3_on = get(gauges_on_3)
	
	tachometers()
	egt_gauges()
	emi3()	
	fuel_flow()
	vibra_gau()
	oil_qty_gau()
	fuel_temp_gau()

end
